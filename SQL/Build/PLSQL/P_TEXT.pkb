create or replace package body P_TEXT is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- SET_TEXT
-- ----------------------------------------
--
  procedure SET_TEXT
   (pnITM_ID in out P_BASE.tnITM_ID,
    psTAB_ALIAS in P_BASE.tsTAB_ALIAS,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psTEXT in P_BASE.tmsText)
  is
    sTXTT_ACTIVE_FLAG P_BASE.tsTXTT_ACTIVE_FLAG;
    sLANG_ACTIVE_FLAG P_BASE.tsLANG_ACTIVE_FLAG;
    sTAB_ALIAS P_BASE.tsTAB_ALIAS := psTAB_ALIAS;
    sMULTI_INSTANCE_FLAG P_BASE.tsTTP_MULTI_INSTANCE_FLAG;
    nTXT_SEQ_NBR_MAX P_BASE.tnTXT_SEQ_NBR_MAX;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_TEXT',
      to_char(pnITM_ID) || '~' || psTAB_ALIAS || '~' || psTXTT_CODE || '~' || to_char(pnSEQ_NBR) ||
        '~' || psLANG_CODE || '~' || to_char(length(psTEXT)) || ':' || psTEXT);
  --
  -- Ensure required text type is active.
  --
    begin
      select ACTIVE_FLAG
      into sTXTT_ACTIVE_FLAG
      from T_TEXT_TYPES
      where CODE = psTXTT_CODE
      for update;
    exception
      when NO_DATA_FOUND
      then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Unknown text type');
    end;
  --
    if sTXTT_ACTIVE_FLAG = 'N'
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'Inactive text type');
    end if;
  --
  -- Ensure required language is active.
  --
    begin
      select ACTIVE_FLAG
      into sLANG_ACTIVE_FLAG
      from T_LANGUAGES
      where CODE = psLANG_CODE
      for update;
    exception
      when NO_DATA_FOUND
      then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 3, 'Unknown text language');
    end;
  --
    if sLANG_ACTIVE_FLAG = 'N'
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 4, 'Inactive text language');
    end if;
  --
    if pnITM_ID is null
    then
    --
    -- Text is to be created for a new data item.
    --
      if pnSEQ_NBR is not null
      then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 5, 'Cannot specify a text item sequence number without a data item identifier');
      end if;
    --
    -- Create new T_DATA_ITEMS row.
    --
      insert into T_DATA_ITEMS (ID, TAB_ALIAS)
      values (ITM_SEQ.nextval, sTAB_ALIAS)
      returning ID into pnITM_ID;
    --
      P_UTILITY.TRACE_POINT
       ('Inserted T_DATA_ITEMS',
        to_char(pnITM_ID) || '~' || sTAB_ALIAS || '~' || psTXTT_CODE || '~' || to_char(pnSEQ_NBR) ||
          '~' || psLANG_CODE || '~' || to_char(length(psTEXT)) || ':' || psTEXT);
    --
    -- Create new T_TEXT_TYPE_HEADERS row.
    --
      insert into T_TEXT_TYPE_HEADERS (ITM_ID, TXTT_CODE, TAB_ALIAS, TXT_SEQ_NBR_MAX)
      values (pnITM_ID, psTXTT_CODE, sTAB_ALIAS, 1);
    --
      P_UTILITY.TRACE_POINT('Inserted T_TEXT_TYPE_HEADERS');
    --
      pnSEQ_NBR := 1;
    --
    else
    --
    -- Text already exists for this data item.
    --
      select TAB_ALIAS into sTAB_ALIAS from T_DATA_ITEMS TXT where TXT.ID = pnITM_ID;
    --
      if sTAB_ALIAS != psTAB_ALIAS
      then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 6, 'Wrong table for this data item identifier');
      end if;
    --
      if pnSEQ_NBR is null
      then
      --
      -- Check if there are any existing text items of the required type.
      --
        update T_TEXT_TYPE_HEADERS
        set TXT_SEQ_NBR_MAX = TXT_SEQ_NBR_MAX + 1
        where ITM_ID = pnITM_ID
        and TXTT_CODE = psTXTT_CODE
        returning TXT_SEQ_NBR_MAX into pnSEQ_NBR;
      --
        P_UTILITY.TRACE_POINT
         ('Updated T_TEXT_TYPE_HEADERS',
          to_char(pnITM_ID) || '~' || sTAB_ALIAS || '~' || psTXTT_CODE || '~' ||
            to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
            to_char(length(psTEXT)) || ':' || psTEXT);
      --
        if sql%rowcount = 0
        then
        --
        -- Data item has no existing text items of this type: create new T_TEXT_TYPE_HEADERS row.
        --
          insert into T_TEXT_TYPE_HEADERS (ITM_ID, TXTT_CODE, TAB_ALIAS, TXT_SEQ_NBR_MAX)
          values (pnITM_ID, psTXTT_CODE, sTAB_ALIAS, 1);
        --
          P_UTILITY.TRACE_POINT('Inserted T_TEXT_TYPE_HEADERS');
        --
          pnSEQ_NBR := 1;
        --
        else
          select MULTI_INSTANCE_FLAG
          into sMULTI_INSTANCE_FLAG
          from T_TEXT_TYPE_PROPERTIES
          where TXTT_CODE = psTXTT_CODE
          and TAB_ALIAS = sTAB_ALIAS;
        --
          if sMULTI_INSTANCE_FLAG = 'N'
          then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 7, 'Only one text item of this type allowed');
          end if;
        end if;
      else
      --
      -- Check that T_TEXT_TYPE_HEADERS row exists and requested text item sequence number is not
      --  greater than the current maximum.
      --
        begin
          select TXT_SEQ_NBR_MAX
          into nTXT_SEQ_NBR_MAX
          from T_TEXT_TYPE_HEADERS
          where ITM_ID = pnITM_ID
          and TXTT_CODE = psTXTT_CODE;
        exception
          when NO_DATA_FOUND
          then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 8, 'No existing text of this type');
        end;
      --
        if pnSEQ_NBR > nTXT_SEQ_NBR_MAX
        then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 9, 'Text item sequence number greater than current maximum');
        end if;
      end if;
    end if;
  --
  -- Create or update T_TEXT_ITEMS row.
  --
    merge into T_TEXT_ITEMS TXT
    using
     (select pnITM_ID ITM_ID, psTXTT_CODE TXTT_CODE, pnSEQ_NBR SEQ_NBR, psLANG_CODE LANG_CODE,
        LONG_TEXT_FLAG
      from T_TEXT_TYPE_PROPERTIES
      where TXTT_CODE = psTXTT_CODE
      and TAB_ALIAS = sTAB_ALIAS) INP
    on (TXT.ITM_ID = INP.ITM_ID
      and TXT.TXTT_CODE = INP.TXTT_CODE
      and TXT.SEQ_NBR = INP.SEQ_NBR
      and TXT.LANG_CODE = INP.LANG_CODE)
    when matched then
      update
      set TEXT = case when INP.LONG_TEXT_FLAG = 'N' then psTEXT end,
        LONG_TEXT = case when INP.LONG_TEXT_FLAG = 'Y' then psTEXT end
    when not matched then
      insert
       (ITM_ID, TXTT_CODE, SEQ_NBR, LANG_CODE, TAB_ALIAS,
        TEXT,
        LONG_TEXT)
      values
       (pnITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, sTAB_ALIAS,
        case when INP.LONG_TEXT_FLAG = 'N' then psTEXT end,
        case when INP.LONG_TEXT_FLAG = 'Y' then psTEXT end);
  --
    P_UTILITY.TRACE_POINT
     ('Merged T_TEXT_ITEMS',
      to_char(pnITM_ID) || '~' || sTAB_ALIAS || '~' || psTXTT_CODE || '~' || to_char(pnSEQ_NBR) ||
        '~' || psLANG_CODE || '~' || to_char(length(psTEXT)) || ':' || psTEXT);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_TEXT;
--
-- ----------------------------------------
-- DELETE_TEXT
-- ----------------------------------------
--
  procedure DELETE_TEXT
   (pnITM_ID in P_BASE.tnITM_ID,
    psTXTT_CODE in P_BASE.tsTXTT_CODE := null,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    sMANDATORY_FLAG P_BASE.tsTTP_MANDATORY_FLAG;
    nItemCount1 integer;  -- Count of existing text items.
    nItemCount2 integer;  -- Count of text items to be deleted.
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_TEXT',
      to_char(pnITM_ID) || '~' || psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
  -- Determine if text to be deleted is of a mandatory text type (not necessary if all text is to be
  --  deleted).
  --
    if psTXTT_CODE is not null
    then
      select TTP.MANDATORY_FLAG
      into sMANDATORY_FLAG
      from T_DATA_ITEMS TXT
      join T_TEXT_TYPE_PROPERTIES TTP
        on TTP.TAB_ALIAS = TXT.TAB_ALIAS
        and TTP.TXTT_CODE = psTXTT_CODE
      where TXT.ID = pnITM_ID;
    end if;
  --
    if psLANG_CODE is not null
    then
    --
    -- Count number of text items existing / to be deleted.
    --
      select count(*), count(case when SEQ_NBR = pnSEQ_NBR and LANG_CODE = psLANG_CODE then 1 end)
      into nItemCount1, nItemCount2
      from T_TEXT_ITEMS
      where ITM_ID = pnITM_ID
      and TXTT_CODE = psTXTT_CODE;
    --
      if nItemCount2 = 0
      then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 10, 'No text to delete');
      end if;
    --
      if nItemCount1 = nItemCount2
      then
      --
      -- Single text item of this type is to be deleted.
      --
        if sMANDATORY_FLAG = 'Y'
        then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 11, 'Cannot delete last mandatory text item');
        else
        --
        -- The single subordinate T_TEXT_ITEMS row will be cascade deleted.
        --
          delete from T_TEXT_TYPE_HEADERS where ITM_ID = pnITM_ID and TXTT_CODE = psTXTT_CODE;
        --
          P_UTILITY.TRACE_POINT('Deleted T_TEXT_TYPE_HEADERS-A~' || to_char(sql%rowcount));
        end if;
      else
      --
      -- Just one of several text items of this type is to be deleted.
      --
        delete from T_TEXT_ITEMS
        where ITM_ID = pnITM_ID
        and TXTT_CODE = psTXTT_CODE
        and SEQ_NBR = pnSEQ_NBR
        and LANG_CODE = psLANG_CODE;
      --
        P_UTILITY.TRACE_POINT('Deleted T_TEXT_ITEMS-A~' || to_char(sql%rowcount));
      end if;
    --
    elsif pnSEQ_NBR is not null
    then
    --
    -- Count number of text items existing / to be deleted.
    --
      select count(*), count(case when SEQ_NBR = pnSEQ_NBR then 1 end)
      into nItemCount1, nItemCount2
      from T_TEXT_ITEMS
      where ITM_ID = pnITM_ID
      and TXTT_CODE = psTXTT_CODE;
    --
      if nItemCount2 = 0
      then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 10, 'No text to delete');
      end if;
    --
      if nItemCount1 = nItemCount2
      then
      --
      -- All text items of this type are to be deleted.
      --
        if sMANDATORY_FLAG = 'Y'
        then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 11, 'Cannot delete last mandatory text item');
        else
        --
        -- The subordinate T_TEXT_ITEMS rows will be cascade deleted.
        --
          delete from T_TEXT_TYPE_HEADERS where ITM_ID = pnITM_ID and TXTT_CODE = psTXTT_CODE;
        --
          P_UTILITY.TRACE_POINT('Deleted T_TEXT_TYPE_HEADERS-B~' || to_char(sql%rowcount));
        end if;
      else
      --
      -- Not all the text items of this type are to be deleted.
      --
        delete from T_TEXT_ITEMS
        where ITM_ID = pnITM_ID
        and TXTT_CODE = psTXTT_CODE
        and SEQ_NBR = pnSEQ_NBR;
      --
        P_UTILITY.TRACE_POINT('Deleted T_TEXT_ITEMS-B~' || to_char(sql%rowcount));
      end if;
    --
    elsif psTXTT_CODE is not null
    then
      if sMANDATORY_FLAG = 'Y'
      then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 12, 'Cannot delete mandatory text type');
      end if;
    --
    -- Subordinate T_TEXT_ITEMS rows will be cascade deleted.
    --
      delete from T_TEXT_TYPE_HEADERS where ITM_ID = pnITM_ID and TXTT_CODE = psTXTT_CODE;
    --
      P_UTILITY.TRACE_POINT('Deleted T_TEXT_TYPE_HEADERS-C~' || to_char(sql%rowcount));
    --
      if sql%rowcount = 0
      then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 10, 'No text to delete');
      end if;
    else
    --
    -- Subordinate T_TEXT_TYPE_HEADERS and T_TEXT_ITEMS rows will be cascade deleted.
    --
      delete from T_DATA_ITEMS where ID = pnITM_ID;
    --
      P_UTILITY.TRACE_POINT('Deleted T_DATA_ITEMS~' || to_char(sql%rowcount));
    --
      if sql%rowcount = 0
      then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 10, 'No text to delete');
      end if;
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_TEXT;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sComponent != 'TXT'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'Component code mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
end P_TEXT;
/

show errors
