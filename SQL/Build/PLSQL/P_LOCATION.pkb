create or replace package body P_LOCATION is
--
-- ========================================
-- Local global variables
-- ========================================
--
  gsCOUNTRY_LOCAT_CODE P_BASE.tsLOCT_CODE;  -- Location attribute type of standard country code.
--
-- Parameters used in calculating hashed, check-digited location code.
--
  gnLOC_ID_MULTIPLIER number;
  gnLOC_ID_INCREMENT number;
  gnLOC_ID_CHECK_MULTIPLIER number;
  gnLOC_ID_CHECK_INCREMENT number;
  gnLOC_ID_CHECK_MODULUS number;
--
-- ========================================
-- Private program units
-- ========================================
--
-- ----------------------------------------
-- CHECK_LOCATION_ID
-- ----------------------------------------
--
  procedure CHECK_LOCATION_ID
   (pnID in P_BASE.tmnLOC_ID)
  is
  begin
    P_UTILITY.START_MODULE(sVersion || '-' || sComponent || '.CHECK_LOCATION_ID', to_char(pnID));
  --
    if trunc(pnID / 1e8) !=
      gnLOC_ID_CHECK_INCREMENT -
        mod(mod(pnID, 1e8) * gnLOC_ID_CHECK_MULTIPLIER, gnLOC_ID_CHECK_MODULUS)
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 19, 'Check digit failure in supplied location id');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end CHECK_LOCATION_ID;
--
-- ----------------------------------------
-- INSERT_LOCATION_RELATIONSHIP1
-- ----------------------------------------
--
  procedure INSERT_LOCATION_RELATIONSHIP1
   (pnLOC_ID_FROM in P_BASE.tmnLOC_ID,
    pnLOC_ID_TO in P_BASE.tmnLOC_ID,
    psLOCRT_CODE in P_BASE.tmsLOCRT_CODE,
    pdSTART_DATE in P_BASE.tdDate := null,
    pdEND_DATE in P_BASE.tdDate := null)
  is
    sACTIVE_FLAG P_BASE.tsLOCRT_ACTIVE_FLAG;
    dSTART_DATE P_BASE.tdDate;
    dEND_DATE P_BASE.tdDate;
  --
    dSTART_DATE1 P_BASE.tdDate;
    dEND_DATE1 P_BASE.tdDate;
    nLOCR_ITM_ID1 P_BASE.tnITM_ID;
    xLOCR_ROWID1 rowid;
    dEND_DATE2 P_BASE.tdDate;
    nLOCR_ITM_ID2 P_BASE.tnITM_ID;
    xLOCR_ROWID2 rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_LOCATION_RELATIONSHIP1',
      to_char(pnLOC_ID_FROM) || '~' || to_char(pnLOC_ID_TO) || '~' ||
        psLOCRT_CODE || '~' || to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS'));
  --
    select ACTIVE_FLAG
    into sACTIVE_FLAG
    from T_LOCATION_RELATIONSHIP_TYPES
    where CODE = psLOCRT_CODE;
  --
    if sACTIVE_FLAG = 'N'
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 16, 'Inactive location relationship type');
    end if;
  --
  -- Determine effective date range of the combined related locations.
  --
    select max(START_DATE), min(END_DATE)
    into dSTART_DATE, dEND_DATE
    from LOCATIONS
    where ID in (pnLOC_ID_FROM, pnLOC_ID_TO);
  --
  -- Check that effective date parameters (if specified) fall within the effective date range of the
  --  related locations, or default them if not specified.
  --
    if pdSTART_DATE < dSTART_DATE or pdEND_DATE > dEND_DATE
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 17, 'Location relationship effective date range outside effective date range of related locations');
    else
      dSTART_DATE := nvl(pdSTART_DATE, dSTART_DATE);
      dEND_DATE := nvl(pdEND_DATE, dEND_DATE);
    end if;
  --
    P_UTILITY.TRACE_POINT
     ('Dates', to_char(pnLOC_ID_FROM) || '~' || to_char(pnLOC_ID_TO) || '~' ||
        psLOCRT_CODE || '~' || to_char(dSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(dEND_DATE, 'YYYY-MM-DD HH24:MI:SS'));
  --
  -- Check for an existing relationship between these locations of the same type and with an
  --  effective date range which is overlapping or contiguously adjacent (the start date of one
  --  relationship is equal to the end date of the other). An overlapping relationship is currently
  --  regarded as invalid, although it may be possible to merge the relationships instead.
  --  Contiguously adjacent relationships are merged with the new relationship where possible.
  --
    begin
    -- Find relationship(s) whose effective date range would overlap with the new relationship or
    --  which contiguously precedes the new relationship.
      select START_DATE, END_DATE, ITM_ID, rowid
      into dSTART_DATE1, dEND_DATE1, nLOCR_ITM_ID1, xLOCR_ROWID1
      from T_LOCATION_RELATIONSHIPS
      where LOC_ID_FROM = pnLOC_ID_FROM
      and LOC_ID_TO = pnLOC_ID_TO
      and LOCRT_CODE = psLOCRT_CODE
      and START_DATE < dEND_DATE
      and END_DATE >= dSTART_DATE;
    exception
      when TOO_MANY_ROWS
      then
      -- One or more of the found relationships must overlap with the new relationship.
        P_MESSAGE.DISPLAY_MESSAGE(sComponent, 18, 'Overlapping location relationship already exists');
    --
      when NO_DATA_FOUND
      then null;
    end;
  --
    if dEND_DATE1 > dSTART_DATE
    then
    -- Overlapping relationship - report as invalid.
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 18, 'Overlapping location relationship already exists');
    end if;
  --
    begin
    -- Find relationship whose effective date range contiguously follows the new relationship.
      select END_DATE, ITM_ID, rowid
      into dEND_DATE2, nLOCR_ITM_ID2, xLOCR_ROWID2
      from T_LOCATION_RELATIONSHIPS
      where LOC_ID_FROM = pnLOC_ID_FROM
      and LOC_ID_TO = pnLOC_ID_TO
      and LOCRT_CODE = psLOCRT_CODE
      and START_DATE = dEND_DATE;
    exception
      when NO_DATA_FOUND
      then null;
    end;
  --
    if xLOCR_ROWID1 is null and xLOCR_ROWID2 is null
    then
    -- No adjacent relationship - simply insert new relationship.
      insert into T_LOCATION_RELATIONSHIPS
       (LOC_ID_FROM, LOC_ID_TO, LOCRT_CODE, START_DATE, END_DATE)
      values
       (pnLOC_ID_FROM, pnLOC_ID_TO, psLOCRT_CODE, dSTART_DATE, dEND_DATE);
    elsif xLOCR_ROWID1 is null
    then
    -- Relationship with effective date range contiguously following the new relationship only -
    --  extend the effective date range downwards to encompass the new relationship.
      update T_LOCATION_RELATIONSHIPS
      set START_DATE = dSTART_DATE,
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCR_ROWID2;
    elsif xLOCR_ROWID2 is null
    then
    -- Relationship with effective date range contiguously preceding the new relationship only -
    --  extend the effective date range upwards to encompass the new relationship.
      update T_LOCATION_RELATIONSHIPS
      set END_DATE = dEND_DATE,
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCR_ROWID1;
    else
    -- Relationships with effective date ranges both contiguously preceding and following the new
    --  relationship - if possible, merge the effective date ranges of the two relationships, which
    --  will then also encompass the new relationship.
      if nLOCR_ITM_ID2 is null
      then
      -- Following relationship has no associated general data item, so it can be safely deleted.
        delete from T_LOCATION_RELATIONSHIPS
        where rowid = xLOCR_ROWID2;
      -- Update preceding relationship to encompass following and new relationships.
        update T_LOCATION_RELATIONSHIPS
        set END_DATE = dEND_DATE2,
          VERSION_NBR = VERSION_NBR + 1
        where rowid = xLOCR_ROWID1;
      elsif nLOCR_ITM_ID1 is null
      then
      -- Preceding relationship has no associated general data item, so it can be safely deleted,
        delete from T_LOCATION_RELATIONSHIPS
        where rowid = xLOCR_ROWID1;
      -- Update following relationship to encompass preceding and new relationships.
        update T_LOCATION_RELATIONSHIPS
        set START_DATE = dSTART_DATE1,
          VERSION_NBR = VERSION_NBR + 1
        where rowid = xLOCR_ROWID2;
      else
      -- Both preceding and following relationships have associated general data items, so neither
      --  can be safely deleted and the relationships cannot easily be merged. For now, simply
      --  insert the new relationship between the two existing ones. It is not expected that this
      --  situation will arise very often in practice; however, if experience shows it to be useful,
      --  a more sophisticated solution can be developed in the future (e.g. merging the attributes
      --  of the two general data items).
        insert into T_LOCATION_RELATIONSHIPS
         (LOC_ID_FROM, LOC_ID_TO, LOCRT_CODE, START_DATE, END_DATE)
        values
         (pnLOC_ID_FROM, pnLOC_ID_TO, psLOCRT_CODE, dSTART_DATE, dEND_DATE);
      end if;
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_LOCATION_RELATIONSHIP1;
--
-- ----------------------------------------
-- UPDATE_LOCATION_RELATIONSHIP1
-- ----------------------------------------
--
  procedure UPDATE_LOCATION_RELATIONSHIP1
   (pnLOC_ID_FROM in P_BASE.tmnLOC_ID,
    pnLOC_ID_TO in P_BASE.tmnLOC_ID,
    psLOCRT_CODE in P_BASE.tmsLOCRT_CODE,
    pdSTART_DATE in P_BASE.tmdDate,
    pnVERSION_NBR in out P_BASE.tnLOCR_VERSION_NBR,
    pdSTART_DATE_NEW in P_BASE.tdDate := P_BASE.gdFALSE_DATE,
    pdEND_DATE in P_BASE.tdDate := P_BASE.gdFALSE_DATE)
  is
    dEND_DATE P_BASE.tdDate;
    nVERSION_NBR P_BASE.tnLOCR_VERSION_NBR;
    xLOCR_ROWID rowid;
    dSTART_DATE_NEW P_BASE.tdDate;
    dEND_DATE_NEW P_BASE.tdDate;
  --
    dSTART_DATE1 P_BASE.tdDate;
    dEND_DATE1 P_BASE.tdDate;
    nLOCR_ITM_ID1 P_BASE.tnITM_ID;
    xLOCR_ROWID1 rowid;
    dEND_DATE2 P_BASE.tdDate;
    nLOCR_ITM_ID2 P_BASE.tnITM_ID;
    xLOCR_ROWID2 rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_LOCATION_RELATIONSHIP1',
      to_char(pnLOC_ID_FROM) || '~' || to_char(pnLOC_ID_TO) || '~' ||
        psLOCRT_CODE || '~' || to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pnVERSION_NBR) || '~' || to_char(pdSTART_DATE_NEW, 'YYYY-MM-DD HH24:MI:SS') ||
        '~' || to_char(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS'));
  --
    select END_DATE, VERSION_NBR, rowid
    into dEND_DATE, nVERSION_NBR, xLOCR_ROWID
    from T_LOCATION_RELATIONSHIPS
    where LOC_ID_FROM = pnLOC_ID_FROM
    and LOC_ID_TO = pnLOC_ID_TO
    and LOCRT_CODE = psLOCRT_CODE
    and START_DATE = pdSTART_DATE;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
    --
    -- Determine new values for dates.
    --
      if pdSTART_DATE_NEW = P_BASE.gdFALSE_DATE
      then dSTART_DATE_NEW := pdSTART_DATE;
      else dSTART_DATE_NEW := nvl(pdSTART_DATE_NEW, P_BASE.gdMIN_DATE);
      end if;
    --
      if pdEND_DATE = P_BASE.gdFALSE_DATE
      then dEND_DATE_NEW := dEND_DATE;
      else dEND_DATE_NEW := nvl(pdEND_DATE, P_BASE.gdMAX_DATE);
      end if;
    --
      P_UTILITY.TRACE_POINT
       ('Dates', to_char(pnLOC_ID_FROM) || '~' || to_char(pnLOC_ID_TO) || '~' ||
          psLOCRT_CODE || '~' || to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
          to_char(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
          to_char(dSTART_DATE_NEW, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
          to_char(dEND_DATE_NEW, 'YYYY-MM-DD HH24:MI:SS'));
    --
    -- Check for another relationship between these locations of the same type and with an effective
    --  date range which is overlapping or contiguously adjacent (the start date of one relationship
    --  is equal to the end date of the other). An overlapping relationship is currently regarded as
    --  invalid, although it may be possible to merge the relationships instead. Contiguously
    --  adjacent relationships are merged with the updated relationship where possible.
    --
      begin
      -- Find relationship(s) whose effective date range would overlap with the updated relationship
      --  or which contiguously precedes the updated relationship.
        select START_DATE, END_DATE, ITM_ID, rowid
        into dSTART_DATE1, dEND_DATE1, nLOCR_ITM_ID1, xLOCR_ROWID1
        from T_LOCATION_RELATIONSHIPS
        where LOC_ID_FROM = pnLOC_ID_FROM
        and LOC_ID_TO = pnLOC_ID_TO
        and LOCRT_CODE = psLOCRT_CODE
        and START_DATE < dEND_DATE_NEW
        and END_DATE >= dSTART_DATE_NEW
        and START_DATE != pdSTART_DATE;
      exception
        when TOO_MANY_ROWS
        then
        -- One or more of the found relationships must overlap with the updated relationship.
          P_MESSAGE.DISPLAY_MESSAGE(sComponent, 18, 'Overlapping location relationship already exists');
      --
        when NO_DATA_FOUND
        then null;
      end;
    --
      if dEND_DATE1 > dSTART_DATE_NEW
      then
      -- Overlapping relationship - report as invalid.
        P_MESSAGE.DISPLAY_MESSAGE(sComponent, 18, 'Overlapping location relationship already exists');
      end if;
    --
      begin
      -- Find relationship whose effective date range contiguously follows the updated relationship.
        select END_DATE, ITM_ID, rowid
        into dEND_DATE2, nLOCR_ITM_ID2, xLOCR_ROWID2
        from T_LOCATION_RELATIONSHIPS
        where LOC_ID_FROM = pnLOC_ID_FROM
        and LOC_ID_TO = pnLOC_ID_TO
        and LOCRT_CODE = psLOCRT_CODE
        and START_DATE = dEND_DATE_NEW;
      exception
        when NO_DATA_FOUND
        then null;
      end;
    --
      if xLOCR_ROWID1 is not null and nLOCR_ITM_ID1 is null
      then
      -- Relationship with effective date range contiguously preceding the updated relationship,
      --  which has no associated general data item, so it can be safely deleted - delete it and
      --  adjust the new start date of the updated relationship.
        delete from T_LOCATION_RELATIONSHIPS
        where rowid = xLOCR_ROWID1;
      --
        dSTART_DATE_NEW := dSTART_DATE1;
      end if;
    --
      if xLOCR_ROWID2 is not null and nLOCR_ITM_ID2 is null
      then
      -- Relationship with effective date range contiguously following the updated relationship,
      --  which has no associated general data item, so it can be safely deleted - delete it and
      --  adjust the new end date of the updated relationship.
        delete from T_LOCATION_RELATIONSHIPS
        where rowid = xLOCR_ROWID2;
      --
        dEND_DATE_NEW := dEND_DATE2;
      end if;
    --
      update T_LOCATION_RELATIONSHIPS
      set START_DATE = dSTART_DATE_NEW,
        END_DATE = dEND_DATE_NEW,
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCR_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 6, 'Location relationship has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end UPDATE_LOCATION_RELATIONSHIP1;
--
-- ----------------------------------------
-- DELETE_LOCATION_RELATIONSHIP1
-- ----------------------------------------
--
  procedure DELETE_LOCATION_RELATIONSHIP1
   (pnLOC_ID_FROM in P_BASE.tmnLOC_ID,
    pnLOC_ID_TO in P_BASE.tmnLOC_ID,
    psLOCRT_CODE in P_BASE.tmsLOCRT_CODE,
    pdSTART_DATE in P_BASE.tmdDate,
    pnVERSION_NBR in P_BASE.tnLOCR_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCR_VERSION_NBR;
    xLOCR_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_LOCATION_RELATIONSHIP1',
      to_char(pnLOC_ID_FROM) || '~' || to_char(pnLOC_ID_TO) || '~' ||
        psLOCRT_CODE || '~' || to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCR_ROWID
    from T_LOCATION_RELATIONSHIPS
    where LOC_ID_FROM = pnLOC_ID_FROM
    and LOC_ID_TO = pnLOC_ID_TO
    and LOCRT_CODE = psLOCRT_CODE
    and START_DATE = pdSTART_DATE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_LOCATION_RELATIONSHIPS where rowid = xLOCR_ROWID;
    --
      if nITM_ID is not null
      then P_TEXT.DELETE_TEXT(nITM_ID);
      end if;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 6, 'Location relationship has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_LOCATION_RELATIONSHIP1;
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- INSERT_LOCATION_TYPE
-- ----------------------------------------
--
  procedure INSERT_LOCATION_TYPE
   (psCODE in P_BASE.tmsLOCT_CODE,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText,
    pnDISPLAY_SEQ in P_BASE.tnLOCT_DISPLAY_SEQ := null,
    psACTIVE_FLAG in P_BASE.tmsLOCT_ACTIVE_FLAG := 'Y')
  is
    nITM_ID P_BASE.tnITM_ID;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_LOCATION_TYPE',
      psCODE || '~' || to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_TEXT.SET_TEXT(nITM_ID, 'LOCT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into T_LOCATION_TYPES (CODE, DISPLAY_SEQ, ACTIVE_FLAG, ITM_ID)
    values (psCODE, pnDISPLAY_SEQ, psACTIVE_FLAG, nITM_ID);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_LOCATION_TYPE;
--
-- ----------------------------------------
-- UPDATE_LOCATION_TYPE
-- ----------------------------------------
--
  procedure UPDATE_LOCATION_TYPE
   (psCODE in P_BASE.tmsLOCT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCT_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnLOCT_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsLOCT_ACTIVE_FLAG := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCT_VERSION_NBR;
    xLOCT_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_LOCATION_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnDISPLAY_SEQ) || '~' ||
        psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCT_ROWID
    from T_LOCATION_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psDescription is not null
      then P_TEXT.SET_TEXT(nITM_ID, 'LOCT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update T_LOCATION_TYPES
      set DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Location type has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end UPDATE_LOCATION_TYPE;
--
-- ----------------------------------------
-- SET_LOCATION_TYPE
-- ----------------------------------------
--
  procedure SET_LOCATION_TYPE
   (psCODE in P_BASE.tmsLOCT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCT_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnLOCT_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsLOCT_ACTIVE_FLAG := null)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCATION_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnDISPLAY_SEQ) || '~' ||
        psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    if pnVERSION_NBR is null
    then
      INSERT_LOCATION_TYPE(psCODE, psLANG_CODE, psDescription,
                           case when pnDISPLAY_SEQ = -1e6 then null else pnDISPLAY_SEQ end,
                           nvl(psACTIVE_FLAG, 'Y'));
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_LOCATION_TYPE(psCODE, pnVERSION_NBR, psLANG_CODE, psDescription,
                           pnDISPLAY_SEQ, psACTIVE_FLAG);
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_LOCATION_TYPE;
--
-- ----------------------------------------
-- DELETE_LOCATION_TYPE
-- ----------------------------------------
--
  procedure DELETE_LOCATION_TYPE
   (psCODE in P_BASE.tmsLOCT_CODE,
    pnVERSION_NBR in P_BASE.tnLOCT_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCT_VERSION_NBR;
    xLOCT_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_LOCATION_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCT_ROWID
    from T_LOCATION_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_LOCATION_TYPES where rowid = xLOCT_ROWID;
    --
      P_TEXT.DELETE_TEXT(nITM_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Location type has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_LOCATION_TYPE;
--
-- ----------------------------------------
-- SET_LOCT_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_LOCT_DESCRIPTION
   (psCODE in P_BASE.tmsLOCT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCT_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCT_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_LOCT_TEXT(psCODE, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_LOCT_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_LOCT_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_LOCT_DESCRIPTION
   (psCODE in P_BASE.tmsLOCT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCT_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_LOCT_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_LOCT_TEXT(psCODE, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_LOCT_DESCRIPTION;
--
-- ----------------------------------------
-- SET_LOCT_TEXT
-- ----------------------------------------
--
  procedure SET_LOCT_TEXT
   (psCODE in P_BASE.tmsLOCT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCT_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCT_VERSION_NBR;
    xLOCT_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCT_ROWID
    from T_LOCATION_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'LOCT', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_LOCATION_TYPES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Location type has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_LOCT_TEXT;
--
-- ----------------------------------------
-- REMOVE_LOCT_TEXT
-- ----------------------------------------
--
  procedure REMOVE_LOCT_TEXT
   (psCODE in P_BASE.tmsLOCT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCT_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCT_VERSION_NBR;
    xLOCT_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_LOCT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCT_ROWID
    from T_LOCATION_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_LOCATION_TYPES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Location type has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_LOCT_TEXT;
--
-- ----------------------------------------
-- INSERT_LOCATION
-- ----------------------------------------
--
  procedure INSERT_LOCATION
   (pnID out P_BASE.tnLOC_ID,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psName in P_BASE.tmsText,
    psLOCT_CODE in P_BASE.tmsLOCT_CODE,
    psCountryCode in P_BASE.tsCountryCode := null,
    pdSTART_DATE in P_BASE.tdDate := null,
    pdEND_DATE in P_BASE.tdDate := null,
    psACTIVE_FLAG in P_BASE.tmsLOC_ACTIVE_FLAG := 'Y')
  is
    nITM_ID P_BASE.tnITM_ID;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_LOCATION',
      '~' || psLOCT_CODE || '~' || psCountryCode || '~' ||
        to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psName)) || ':' || psName);
  --
  -- Special processing for countries.
  --
    if psLOCT_CODE = 'COUNTRY'
    then
      if psCountryCode is null
      then
        P_MESSAGE.DISPLAY_MESSAGE(sComponent, 8, 'Country code must be specified for new country');
      else
      --
      -- Check for existing country with same country code and overlapping effective date range.
      --
        declare
          sDummy varchar2(1);
        begin
          select 'x'
          into sDummy
          from T_LOCATION_ATTRIBUTES LOCA
          inner join T_LOCATIONS LOC
            on LOC.ID = LOCA.LOC_ID
          where LOCA.CHAR_VALUE = psCountryCode
          and LOCA.LOCAT_CODE = gsCOUNTRY_LOCAT_CODE
          and LOC.START_DATE < nvl(pdEND_DATE, P_BASE.gdMAX_DATE)
          and LOC.END_DATE > nvl(pdSTART_DATE, P_BASE.gdMIN_DATE);
        --
          raise TOO_MANY_ROWS;
        exception
          when NO_DATA_FOUND then null;
        --
          when TOO_MANY_ROWS
          then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 9, 'Country with this code already exists');
        end;
      end if;
    elsif psCountryCode is not null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 10, 'Country code can only be specified for countries');
    end if;
  --
  -- Generate new location code.
  --
    select LOC_SEQ.nextval into pnID from DUAL;
  --
    pnID := mod(pnID * gnLOC_ID_MULTIPLIER + gnLOC_ID_INCREMENT, 1e8) +
      (gnLOC_ID_CHECK_INCREMENT -
        mod(mod(pnID * gnLOC_ID_MULTIPLIER + gnLOC_ID_INCREMENT, 1e8) * gnLOC_ID_CHECK_MULTIPLIER,
            gnLOC_ID_CHECK_MODULUS)) * 1e8;
  --
    P_UTILITY.TRACE_CONTEXT
     (to_char(pnID) || '~' || psLOCT_CODE || '~' || psCountryCode || '~' ||
        to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        psLANG_CODE || '~' || to_char(length(psName)) || ':' || psName);
  --
    P_TEXT.SET_TEXT(nITM_ID, 'LOC', 'NAME', nSEQ_NBR, psLANG_CODE, psName);
  --
    insert into T_LOCATIONS
     (ID, LOCT_CODE,
      START_DATE, END_DATE, ACTIVE_FLAG,
      ITM_ID)
    values
     (pnID, psLOCT_CODE,
      nvl(pdSTART_DATE, P_BASE.gdMIN_DATE), nvl(pdEND_DATE, P_BASE.gdMAX_DATE), psACTIVE_FLAG,
      nITM_ID);
  --
  -- Create location attribute for country code if necessary.
  --
    if psLOCT_CODE = 'COUNTRY'
    then INSERT_LOCATION_ATTRIBUTE(pnID, gsCOUNTRY_LOCAT_CODE, psCountryCode);
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_LOCATION;
--
-- ----------------------------------------
-- INSERT_LOCATION_WITH_ID
-- ----------------------------------------
--
  procedure INSERT_LOCATION_WITH_ID
   (pnID in P_BASE.tnLOC_ID,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psName in P_BASE.tmsText,
    psLOCT_CODE in P_BASE.tmsLOCT_CODE,
    psCountryCode in P_BASE.tsCountryCode := null,
    pdSTART_DATE in P_BASE.tdDate := null,
    pdEND_DATE in P_BASE.tdDate := null,
    psACTIVE_FLAG in P_BASE.tmsLOC_ACTIVE_FLAG := 'Y')
  is
    nITM_ID P_BASE.tnITM_ID;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_LOCATION_WITH_ID',
      to_char(pnID) || '~' || psLOCT_CODE || '~' || psCountryCode || '~' ||
        to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psName)) || ':' || psName);
  --
  -- Validate supplied location id.
  --
    CHECK_LOCATION_ID(pnID);
  --
  -- Special processing for countries.
  --
    if psLOCT_CODE = 'COUNTRY'
    then
      if psCountryCode is null
      then
        P_MESSAGE.DISPLAY_MESSAGE(sComponent, 8, 'Country code must be specified for new country');
      else
      --
      -- Check for existing country with same country code and overlapping effective date range.
      --
        declare
          sDummy varchar2(1);
        begin
          select 'x'
          into sDummy
          from T_LOCATION_ATTRIBUTES LOCA
          inner join T_LOCATIONS LOC
            on LOC.ID = LOCA.LOC_ID
          where LOCA.CHAR_VALUE = psCountryCode
          and LOCA.LOCAT_CODE = gsCOUNTRY_LOCAT_CODE
          and LOC.START_DATE < nvl(pdEND_DATE, P_BASE.gdMAX_DATE)
          and LOC.END_DATE > nvl(pdSTART_DATE, P_BASE.gdMIN_DATE);
        --
          raise TOO_MANY_ROWS;
        exception
          when NO_DATA_FOUND then null;
        --
          when TOO_MANY_ROWS
          then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 9, 'Country with this code already exists');
        end;
      end if;
    elsif psCountryCode is not null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 10, 'Country code can only be specified for countries');
    end if;
  --
    P_TEXT.SET_TEXT(nITM_ID, 'LOC', 'NAME', nSEQ_NBR, psLANG_CODE, psName);
  --
    insert into T_LOCATIONS
     (ID, LOCT_CODE,
      START_DATE, END_DATE, ACTIVE_FLAG,
      ITM_ID)
    values
     (pnID, psLOCT_CODE,
      nvl(pdSTART_DATE, P_BASE.gdMIN_DATE), nvl(pdEND_DATE, P_BASE.gdMAX_DATE), psACTIVE_FLAG,
      nITM_ID);
  --
  -- Create location attribute for country code if necessary.
  --
    if psLOCT_CODE = 'COUNTRY'
    then INSERT_LOCATION_ATTRIBUTE(pnID, gsCOUNTRY_LOCAT_CODE, psCountryCode);
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_LOCATION_WITH_ID;
--
-- ----------------------------------------
-- UPDATE_LOCATION
-- ----------------------------------------
--
  procedure UPDATE_LOCATION
   (pnID in P_BASE.tmnLOC_ID,
    pnVERSION_NBR in out P_BASE.tnLOC_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psName in P_BASE.tsText := null,
    pnLOCTV_ID in P_BASE.tnLOCTV_ID := -1,
    psCountryCode in P_BASE.tsCountryCode := null,
    pdSTART_DATE in P_BASE.tdDate := P_BASE.gdFALSE_DATE,
    pdEND_DATE in P_BASE.tdDate := P_BASE.gdFALSE_DATE,
    psACTIVE_FLAG in P_BASE.tsLOC_ACTIVE_FLAG := null)
  is
    sLOCT_CODE P_BASE.tsLOCT_CODE;
    nLOCTV_ID P_BASE.tnLOCTV_ID;
    dSTART_DATE P_BASE.tdDate;
    dEND_DATE P_BASE.tdDate;
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOC_VERSION_NBR;
    xLOC_ROWID rowid;
    dSTART_DATE_NEW P_BASE.tdDate;
    dEND_DATE_NEW P_BASE.tdDate;
    sCOUNTRY_CODE P_BASE.tsCountryCode;
    nLOCA_VERSION_NBR P_BASE.tnLOCA_VERSION_NBR;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_LOCATION',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        to_char(pnLOCTV_ID) || '~' || psCountryCode || '~' ||
        to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psName)) || ':' || psName);
  --
    select LOCT_CODE, LOCTV_ID, START_DATE, END_DATE, ITM_ID, VERSION_NBR, rowid
    into sLOCT_CODE, nLOCTV_ID, dSTART_DATE, dEND_DATE, nITM_ID, nVERSION_NBR, xLOC_ROWID
    from T_LOCATIONS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
    --
    -- Determine new values for dates.
    --
      if pdSTART_DATE = P_BASE.gdFALSE_DATE
      then dSTART_DATE_NEW := dSTART_DATE;
      else dSTART_DATE_NEW := nvl(pdSTART_DATE, P_BASE.gdMIN_DATE);
      end if;
    --
      if pdEND_DATE = P_BASE.gdFALSE_DATE
      then dEND_DATE_NEW := dEND_DATE;
      else dEND_DATE_NEW := nvl(pdEND_DATE, P_BASE.gdMAX_DATE);
      end if;
    --
    -- Special processing for countries.
    --
      if sLOCT_CODE = 'COUNTRY'
      then
      --
      -- Check if country code or effective date range might be being changed.
      --
        if psCountryCode is not null
          or dSTART_DATE_NEW != dSTART_DATE
          or dEND_DATE_NEW != dEND_DATE
        then
        --
        -- Get existing country code details.
        --
          select CHAR_VALUE, VERSION_NBR
          into sCOUNTRY_CODE, nLOCA_VERSION_NBR
          from T_LOCATION_ATTRIBUTES
          where LOC_ID = pnID
          and LOCAT_CODE = gsCOUNTRY_LOCAT_CODE;
        --
        -- Check if country code or effective date range are being changed.
        --
          if psCountryCode != sCOUNTRY_CODE
            or dSTART_DATE_NEW != dSTART_DATE
            or dEND_DATE_NEW != dEND_DATE
          then
          --
          -- Check for existing country with same country code and overlapping effective date range.
          --
            declare
              sDummy varchar2(1);
            begin
              select 'x'
              into sDummy
              from T_LOCATION_ATTRIBUTES LOCA
              inner join T_LOCATIONS LOC
                on LOC.ID = LOCA.LOC_ID
              where LOCA.CHAR_VALUE = nvl(psCountryCode, sCOUNTRY_CODE)
              and LOCA.LOCAT_CODE = gsCOUNTRY_LOCAT_CODE
              and START_DATE < dEND_DATE_NEW
              and END_DATE > dSTART_DATE_NEW
              and ID != pnID;
            --
              raise TOO_MANY_ROWS;
            exception
              when NO_DATA_FOUND then null;
            --
              when TOO_MANY_ROWS
              then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 9, 'Country with this code already exists');
            end;
          end if;
        end if;
      --
        if psCountryCode != sCOUNTRY_CODE
        then UPDATE_LOCATION_ATTRIBUTE(pnID, gsCOUNTRY_LOCAT_CODE, nLOCA_VERSION_NBR,
                                       psCountryCode);
        end if;
      elsif psCountryCode is not null
      then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 10, 'Country code can only be specified for countries');
      end if;
    --
    --
    --
      if pnLOCTV_ID != -1
        and pnLOCTV_ID != nLOCTV_ID
      then
      --
      -- Check that location type association is valid
      --
        declare
          sDummy varchar2(1);
        begin
          select 'x'
          into sDummy
          from T_LOCATION_TYPE_VARIANTS LOCTV
          inner join T_LOCATION_RELATIONSHIPS LOCR
            on LOCR.LOC_ID_FROM = LOCTV.LOC_ID
            and LOCR.LOC_ID_TO = pnID
            and LOCR.LOCRT_CODE = LOCTV.LOCRT_CODE
          where LOCTV.ID = pnLOCTV_ID
          and LOCTV.LOCT_CODE = sLOCT_CODE;
        exception
          when NO_DATA_FOUND
          then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 11, 'Invalid location type variant for this location');
        end;
      end if;
    --
      if psName is not null
      then P_TEXT.SET_TEXT(nITM_ID, 'LOC', 'NAME', nSEQ_NBR, psLANG_CODE, psName);
      end if;
    --
      update T_LOCATIONS
      set LOCTV_ID = case when pnLOCTV_ID = -1 then LOCTV_ID else pnLOCTV_ID end,
        START_DATE = dSTART_DATE_NEW,
        END_DATE = dEND_DATE_NEW,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOC_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'Location has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end UPDATE_LOCATION;
--
-- ----------------------------------------
-- SET_LOCATION
-- ----------------------------------------
--
  procedure SET_LOCATION
   (pnID in out P_BASE.tnLOC_ID,
    pnVERSION_NBR in out P_BASE.tnLOC_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psName in P_BASE.tsText := null,
    psLOCT_CODE in P_BASE.tsLOCT_CODE := null,
    pnLOCTV_ID in P_BASE.tnLOCTV_ID := -1,
    psCountryCode in P_BASE.tsCountryCode := null,
    pdSTART_DATE in P_BASE.tdDate := P_BASE.gdFALSE_DATE,
    pdEND_DATE in P_BASE.tdDate := P_BASE.gdFALSE_DATE,
    psACTIVE_FLAG in P_BASE.tsLOC_ACTIVE_FLAG := null)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCATION',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psLOCT_CODE || '~' ||
        to_char(pnLOCTV_ID) || '~' || psCountryCode || '~' ||
        to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psName)) || ':' || psName);
  --
    if pnVERSION_NBR is null
    then
      INSERT_LOCATION(pnID, psLANG_CODE, psName, psLOCT_CODE, psCountryCode,
                      case when pdSTART_DATE = P_BASE.gdFALSE_DATE then null else pdSTART_DATE end,
                      case when pdEND_DATE = P_BASE.gdFALSE_DATE then null else pdEND_DATE end,
                      nvl(psACTIVE_FLAG, 'Y'));
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_LOCATION(pnID, pnVERSION_NBR, psLANG_CODE, psName, pnLOCTV_ID, psCountryCode,
                      pdSTART_DATE, pdEND_DATE, psACTIVE_FLAG);
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_LOCATION;
--
-- ----------------------------------------
-- DELETE_LOCATION
-- ----------------------------------------
--
  procedure DELETE_LOCATION
   (pnID in P_BASE.tmnLOC_ID,
    pnVERSION_NBR in P_BASE.tnLOC_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOC_VERSION_NBR;
    xLOC_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_LOCATION',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOC_ROWID
    from T_LOCATIONS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_LOCATIONS where rowid = xLOC_ROWID;
    --
      P_TEXT.DELETE_TEXT(nITM_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'Location has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_LOCATION;
--
-- ----------------------------------------
-- SET_LOC_NAME
-- ----------------------------------------
--
  procedure SET_LOC_NAME
   (pnID in P_BASE.tmnLOC_ID,
    pnVERSION_NBR in out P_BASE.tnLOC_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE,
    psName in P_BASE.tsText)
  is
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOC_NAME',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psName)) || ':' || psName);
  --
    SET_LOC_TEXT(pnID, pnVERSION_NBR, 'NAME', nSEQ_NBR, psLANG_CODE, psName);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_LOC_NAME;
--
-- ----------------------------------------
-- REMOVE_LOC_NAME
-- ----------------------------------------
--
  procedure REMOVE_LOC_NAME
   (pnID in P_BASE.tmnLOC_ID,
    pnVERSION_NBR in out P_BASE.tnLOC_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_LOC_NAME',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_LOC_TEXT(pnID, pnVERSION_NBR, 'NAME', 1, psLANG_CODE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_LOC_NAME;
--
-- ----------------------------------------
-- SET_LOC_TEXT
-- ----------------------------------------
--
  procedure SET_LOC_TEXT
   (pnID in P_BASE.tmnLOC_ID,
    pnVERSION_NBR in out P_BASE.tnLOC_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE,
    psText in P_BASE.tsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOC_VERSION_NBR;
    xLOC_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOC_TEXT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOC_ROWID
    from T_LOCATIONS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'LOC', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_LOCATIONS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOC_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'Location has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_LOC_TEXT;
--
-- ----------------------------------------
-- REMOVE_LOC_TEXT
-- ----------------------------------------
--
  procedure REMOVE_LOC_TEXT
   (pnID in P_BASE.tmnLOC_ID,
    pnVERSION_NBR in out P_BASE.tnLOC_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOC_VERSION_NBR;
    xLOC_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_LOC_TEXT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOC_ROWID
    from T_LOCATIONS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_LOCATIONS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOC_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'Location has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_LOC_TEXT;
--
-- ----------------------------------------
-- INSERT_LOCATION_ATTRIBUTE_TYPE
-- ----------------------------------------
--
  procedure INSERT_LOCATION_ATTRIBUTE_TYPE
   (psCODE in P_BASE.tmsLOCAT_CODE,
    psDATA_TYPE in P_BASE.tmsLOCAT_DATA_TYPE,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText,
    pnDISPLAY_SEQ in P_BASE.tnLOCAT_DISPLAY_SEQ := null,
    psACTIVE_FLAG in P_BASE.tsLOCAT_ACTIVE_FLAG := 'Y')
  is
    nITM_ID P_BASE.tnITM_ID;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_LOCATION_ATTRIBUTE_TYPE',
      psCODE || '~' || psDATA_TYPE || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_TEXT.SET_TEXT(nITM_ID, 'LOCAT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into T_LOCATION_ATTRIBUTE_TYPES (CODE, DATA_TYPE, DISPLAY_SEQ, ACTIVE_FLAG, ITM_ID)
    values (psCODE, psDATA_TYPE, pnDISPLAY_SEQ, psACTIVE_FLAG, nITM_ID);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_LOCATION_ATTRIBUTE_TYPE;
--
-- ----------------------------------------
-- UPDATE_LOCATION_ATTRIBUTE_TYPE
-- ----------------------------------------
--
  procedure UPDATE_LOCATION_ATTRIBUTE_TYPE
   (psCODE in P_BASE.tmsLOCAT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCAT_VERSION_NBR,
    psDATA_TYPE in P_BASE.tsLOCAT_DATA_TYPE := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnLOCAT_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsLOCAT_ACTIVE_FLAG := null)
  is
    sDATA_TYPE P_BASE.tsLOCAT_DATA_TYPE;
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCAT_VERSION_NBR;
    xLOCAT_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_LOCATION_ATTRIBUTE_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psDATA_TYPE || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    select DATA_TYPE, ITM_ID, VERSION_NBR, rowid
    into sDATA_TYPE, nITM_ID, nVERSION_NBR, xLOCAT_ROWID
    from T_LOCATION_ATTRIBUTE_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
    --
    -- Check if data type is to be changed and location attributes of this type already exist.
    --
      if psDATA_TYPE != sDATA_TYPE
      then
        declare
          sDummy varchar2(1);
        begin
          select 'x' into sDummy from T_LOCATION_ATTRIBUTES where LOCAT_CODE = psCODE;
        --
          raise TOO_MANY_ROWS;
        exception
          when NO_DATA_FOUND then null;
        --
          when TOO_MANY_ROWS
          then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 12, 'Cannot update data type of location attribute type already in use');
        end;
      end if;
    --
      if psDescription is not null
      then P_TEXT.SET_TEXT(nITM_ID, 'LOCAT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update T_LOCATION_ATTRIBUTE_TYPES
      set DATA_TYPE = nvl(psDATA_TYPE, DATA_TYPE),
        DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCAT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 3, 'Location attribute type has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end UPDATE_LOCATION_ATTRIBUTE_TYPE;
--
-- ----------------------------------------
-- SET_LOCATION_ATTRIBUTE_TYPE
-- ----------------------------------------
--
  procedure SET_LOCATION_ATTRIBUTE_TYPE
   (psCODE in P_BASE.tmsLOCAT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCAT_VERSION_NBR,
    psDATA_TYPE in P_BASE.tsLOCAT_DATA_TYPE := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnLOCAT_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsLOCAT_ACTIVE_FLAG := null)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCATION_ATTRIBUTE_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psDATA_TYPE || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    if pnVERSION_NBR is null
    then
      INSERT_LOCATION_ATTRIBUTE_TYPE
       (psCODE, psDATA_TYPE, psLANG_CODE, psDescription,
        case when pnDISPLAY_SEQ = -1e6 then null else pnDISPLAY_SEQ end, nvl(psACTIVE_FLAG, 'Y'));
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_LOCATION_ATTRIBUTE_TYPE
       (psCODE, pnVERSION_NBR, psDATA_TYPE, psLANG_CODE, psDescription,
        pnDISPLAY_SEQ, psACTIVE_FLAG);
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_LOCATION_ATTRIBUTE_TYPE;
--
-- ----------------------------------------
-- DELETE_LOCATION_ATTRIBUTE_TYPE
-- ----------------------------------------
--
  procedure DELETE_LOCATION_ATTRIBUTE_TYPE
   (psCODE in P_BASE.tmsLOCAT_CODE,
    pnVERSION_NBR in P_BASE.tnLOCAT_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCAT_VERSION_NBR;
    xLOCAT_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_LOCATION_ATTRIBUTE_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCAT_ROWID
    from T_LOCATION_ATTRIBUTE_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_LOCATION_ATTRIBUTE_TYPES where rowid = xLOCAT_ROWID;
    --
      P_TEXT.DELETE_TEXT(nITM_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 3, 'Location attribute type has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_LOCATION_ATTRIBUTE_TYPE;
--
-- ----------------------------------------
-- SET_LOCAT_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_LOCAT_DESCRIPTION
   (psCODE in P_BASE.tmsLOCAT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCAT_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCAT_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_LOCAT_TEXT(psCODE, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_LOCAT_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_LOCAT_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_LOCAT_DESCRIPTION
   (psCODE in P_BASE.tmsLOCAT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCAT_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_LOCAT_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_LOCAT_TEXT(psCODE, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_LOCAT_DESCRIPTION;
--
-- ----------------------------------------
-- SET_LOCAT_TEXT
-- ----------------------------------------
--
  procedure SET_LOCAT_TEXT
   (psCODE in P_BASE.tmsLOCAT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCAT_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCAT_VERSION_NBR;
    xLOCAT_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCAT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCAT_ROWID
    from T_LOCATION_ATTRIBUTE_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'LOCAT', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_LOCATION_ATTRIBUTE_TYPES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCAT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 3, 'Location attribute type has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_LOCAT_TEXT;
--
-- ----------------------------------------
-- REMOVE_LOCAT_TEXT
-- ----------------------------------------
--
  procedure REMOVE_LOCAT_TEXT
   (psCODE in P_BASE.tmsLOCAT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCAT_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCAT_VERSION_NBR;
    xLOCAT_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_LOCAT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCAT_ROWID
    from T_LOCATION_ATTRIBUTE_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_LOCATION_ATTRIBUTE_TYPES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCAT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 3, 'Location attribute type has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_LOCAT_TEXT;
--
-- ----------------------------------------
-- INSERT_LOCATION_ATTRIBUTE
-- ----------------------------------------
--
  procedure INSERT_LOCATION_ATTRIBUTE
   (pnLOC_ID in P_BASE.tmnLOC_ID,
    psLOCAT_CODE in P_BASE.tmsLOCAT_CODE,
    psCHAR_VALUE in P_BASE.tsLOCA_CHAR_VALUE := null,
    pnNUM_VALUE in P_BASE.tnLOCA_NUM_VALUE := null,
    pdDATE_VALUE in P_BASE.tdLOCA_DATE_VALUE := null)
  is
    sDATA_TYPE P_BASE.tsLOCAT_DATA_TYPE;
    sACTIVE_FLAG P_BASE.tsLOCAT_ACTIVE_FLAG;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_LOCATION_ATTRIBUTE',
      to_char(pnLOC_ID) || '~' || psLOCAT_CODE || '~' || psCHAR_VALUE || '~' ||
        to_char(pnNUM_VALUE) || '~' || to_char(pdDATE_VALUE, 'YYYY-MM-DD HH24:MI:SS'));
  --
    select DATA_TYPE, ACTIVE_FLAG
    into sDATA_TYPE, sACTIVE_FLAG
    from T_LOCATION_ATTRIBUTE_TYPES
    where CODE = psLOCAT_CODE;
  --
    if sACTIVE_FLAG = 'N'
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 13, 'Inactive location attribute type');
    end if;
  --
    case
      when sDATA_TYPE = 'C' and psCHAR_VALUE is not null then null;
      when sDATA_TYPE = 'N' and pnNUM_VALUE is not null then null;
      when sDATA_TYPE = 'D' and pdDATE_VALUE is not null then null;
      else P_MESSAGE.DISPLAY_MESSAGE(sComponent, 14, 'Attribute of the correct type must be specified');
    end case;
  --
    insert into T_LOCATION_ATTRIBUTES (LOC_ID, LOCAT_CODE, CHAR_VALUE, NUM_VALUE, DATE_VALUE)
    values (pnLOC_ID, psLOCAT_CODE, psCHAR_VALUE, pnNUM_VALUE, pdDATE_VALUE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_LOCATION_ATTRIBUTE;
--
-- ----------------------------------------
-- UPDATE_LOCATION_ATTRIBUTE
-- ----------------------------------------
--
  procedure UPDATE_LOCATION_ATTRIBUTE
   (pnLOC_ID in P_BASE.tmnLOC_ID,
    psLOCAT_CODE in P_BASE.tmsLOCAT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCA_VERSION_NBR,
    psCHAR_VALUE in P_BASE.tsLOCA_CHAR_VALUE := null,
    pnNUM_VALUE in P_BASE.tnLOCA_NUM_VALUE := null,
    pdDATE_VALUE in P_BASE.tdLOCA_DATE_VALUE := null)
  is
    sCHAR_VALUE P_BASE.tsLOCA_CHAR_VALUE;
    nVERSION_NBR P_BASE.tnLOCA_VERSION_NBR;
    xLOCA_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_LOCATION_ATTRIBUTE',
      to_char(pnLOC_ID) || '~' || psLOCAT_CODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psCHAR_VALUE || '~' || to_char(pnNUM_VALUE) || '~' ||
        to_char(pdDATE_VALUE, 'YYYY-MM-DD HH24:MI:SS'));
  --
    select CHAR_VALUE, VERSION_NBR, rowid
    into sCHAR_VALUE, nVERSION_NBR, xLOCA_ROWID
    from T_LOCATION_ATTRIBUTES
    where LOC_ID = pnLOC_ID
    and LOCAT_CODE = psLOCAT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
    --
    -- Special processing for country code.
    --
      if psLOCAT_CODE = gsCOUNTRY_LOCAT_CODE
        and psCHAR_VALUE != sCHAR_VALUE
      then
        declare
          sDummy varchar2(1);
        begin
          select 'x'
          into sDummy
          from T_LOCATIONS LOC1
          inner join T_LOCATION_ATTRIBUTES LOCA
            on LOCA.LOC_ID != LOC1.ID
            and LOCA.CHAR_VALUE = psCHAR_VALUE
            and LOCA.LOCAT_CODE = gsCOUNTRY_LOCAT_CODE
          inner join T_LOCATIONS LOC2
            on LOC2.ID = LOCA.LOC_ID
            and LOC2.START_DATE < LOC1.END_DATE
            and LOC2.END_DATE > LOC1.START_DATE
          where LOC1.ID = pnLOC_ID;
        --
          raise TOO_MANY_ROWS;
        exception
          when NO_DATA_FOUND then null;
        --
          when TOO_MANY_ROWS
          then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 9, 'Country with this code already exists');
        end;
      end if;
    --
      update T_LOCATION_ATTRIBUTES
      set CHAR_VALUE = psCHAR_VALUE,
        NUM_VALUE = pnNUM_VALUE,
        DATE_VALUE = pdDATE_VALUE,
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCA_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 4, 'Location attribute has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end UPDATE_LOCATION_ATTRIBUTE;
--
-- ----------------------------------------
-- SET_LOCATION_ATTRIBUTE
-- ----------------------------------------
--
  procedure SET_LOCATION_ATTRIBUTE
   (pnLOC_ID in P_BASE.tmnLOC_ID,
    psLOCAT_CODE in P_BASE.tmsLOCAT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCA_VERSION_NBR,
    psCHAR_VALUE in P_BASE.tsLOCA_CHAR_VALUE := null,
    pnNUM_VALUE in P_BASE.tnLOCA_NUM_VALUE := null,
    pdDATE_VALUE in P_BASE.tdLOCA_DATE_VALUE := null)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCATION_ATTRIBUTE',
      to_char(pnLOC_ID) || '~' || psLOCAT_CODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psCHAR_VALUE || '~' || to_char(pnNUM_VALUE) || '~' ||
        to_char(pdDATE_VALUE, 'YYYY-MM-DD HH24:MI:SS'));
  --
    if pnVERSION_NBR is null
    then
      INSERT_LOCATION_ATTRIBUTE
       (pnLOC_ID, psLOCAT_CODE, psCHAR_VALUE, pnNUM_VALUE, pdDATE_VALUE);
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_LOCATION_ATTRIBUTE
       (pnLOC_ID, psLOCAT_CODE, pnVERSION_NBR, psCHAR_VALUE, pnNUM_VALUE, pdDATE_VALUE);
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_LOCATION_ATTRIBUTE;
--
-- ----------------------------------------
-- DELETE_LOCATION_ATTRIBUTE
-- ----------------------------------------
--
  procedure DELETE_LOCATION_ATTRIBUTE
   (pnLOC_ID in P_BASE.tmnLOC_ID,
    psLOCAT_CODE in P_BASE.tmsLOCAT_CODE,
    pnVERSION_NBR in P_BASE.tnLOCA_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCA_VERSION_NBR;
    xLOCA_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_LOCATION_ATTRIBUTE',
      to_char(pnLOC_ID) || '~' || psLOCAT_CODE || '~' || to_char(pnVERSION_NBR));
  --
    if psLOCAT_CODE = gsCOUNTRY_LOCAT_CODE
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 15, 'Cannot delete the primary country code');
    end if;
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCA_ROWID
    from T_LOCATION_ATTRIBUTES
    where LOC_ID = pnLOC_ID
    and LOCAT_CODE = psLOCAT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_LOCATION_ATTRIBUTES where rowid = xLOCA_ROWID;
    --
      if nITM_ID is not null
      then P_TEXT.DELETE_TEXT(nITM_ID);
      end if;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 4, 'Location attribute has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_LOCATION_ATTRIBUTE;
--
-- ----------------------------------------
-- SET_LOCA_TEXT
-- ----------------------------------------
--
  procedure SET_LOCA_TEXT
   (pnLOC_ID in P_BASE.tmnLOC_ID,
    psLOCAT_CODE in P_BASE.tmsLOCAT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCA_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCA_VERSION_NBR;
    xLOCA_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCA_TEXT',
      to_char(pnLOC_ID) || '~' || psLOCAT_CODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCA_ROWID
    from T_LOCATION_ATTRIBUTES
    where LOC_ID = pnLOC_ID
    and LOCAT_CODE = psLOCAT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'LOCA', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_LOCATION_ATTRIBUTES
      set ITM_ID = nITM_ID,
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCA_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 4, 'Location attribute has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_LOCA_TEXT;
--
-- ----------------------------------------
-- REMOVE_LOCA_TEXT
-- ----------------------------------------
--
  procedure REMOVE_LOCA_TEXT
   (pnLOC_ID in P_BASE.tmnLOC_ID,
    psLOCAT_CODE in P_BASE.tmsLOCAT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCA_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCA_VERSION_NBR;
    xLOCA_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_LOCA_TEXT',
      to_char(pnLOC_ID) || '~' || psLOCAT_CODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCA_ROWID
    from T_LOCATION_ATTRIBUTES
    where LOC_ID = pnLOC_ID
    and LOCAT_CODE = psLOCAT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_LOCATION_ATTRIBUTES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCA_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 4, 'Location attribute has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_LOCA_TEXT;
--
-- ----------------------------------------
-- INSERT_LOC_RELATIONSHIP_TYPE
-- ----------------------------------------
--
  procedure INSERT_LOC_RELATIONSHIP_TYPE
   (psCODE in P_BASE.tmsLOCRT_CODE,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText,
    pnDISPLAY_SEQ in P_BASE.tnLOCRT_DISPLAY_SEQ := null,
    psACTIVE_FLAG in P_BASE.tsLOCRT_ACTIVE_FLAG := 'Y')
  is
    nITM_ID P_BASE.tnITM_ID;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_LOC_RELATIONSHIP_TYPE',
      psCODE || '~' || to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_TEXT.SET_TEXT(nITM_ID, 'LOCRT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into T_LOCATION_RELATIONSHIP_TYPES (CODE, DISPLAY_SEQ, ACTIVE_FLAG, ITM_ID)
    values (psCODE, pnDISPLAY_SEQ, psACTIVE_FLAG, nITM_ID);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_LOC_RELATIONSHIP_TYPE;
--
-- ----------------------------------------
-- UPDATE_LOC_RELATIONSHIP_TYPE
-- ----------------------------------------
--
  procedure UPDATE_LOC_RELATIONSHIP_TYPE
   (psCODE in P_BASE.tmsLOCRT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCRT_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnLOCRT_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsLOCRT_ACTIVE_FLAG := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCRT_VERSION_NBR;
    xLOCRT_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_LOC_RELATIONSHIP_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCRT_ROWID
    from T_LOCATION_RELATIONSHIP_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psDescription is not null
      then P_TEXT.SET_TEXT(nITM_ID, 'LOCRT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update T_LOCATION_RELATIONSHIP_TYPES
      set DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCRT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 5, 'Location relationship type has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end UPDATE_LOC_RELATIONSHIP_TYPE;
--
-- ----------------------------------------
-- SET_LOC_RELATIONSHIP_TYPE
-- ----------------------------------------
--
  procedure SET_LOC_RELATIONSHIP_TYPE
   (psCODE in P_BASE.tmsLOCRT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCRT_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnLOCRT_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsLOCRT_ACTIVE_FLAG := null)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOC_RELATIONSHIP_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    if pnVERSION_NBR is null
    then
      INSERT_LOCATION_ATTRIBUTE_TYPE
       (psCODE, psLANG_CODE, psDescription,
        case when pnDISPLAY_SEQ = -1e6 then null else pnDISPLAY_SEQ end, nvl(psACTIVE_FLAG, 'Y'));
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_LOCATION_ATTRIBUTE_TYPE
       (psCODE, pnVERSION_NBR, psLANG_CODE, psDescription, pnDISPLAY_SEQ, psACTIVE_FLAG);
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_LOC_RELATIONSHIP_TYPE;
--
-- ----------------------------------------
-- DELETE_LOC_RELATIONSHIP_TYPE
-- ----------------------------------------
--
  procedure DELETE_LOC_RELATIONSHIP_TYPE
   (psCODE in P_BASE.tmsLOCRT_CODE,
    pnVERSION_NBR in P_BASE.tnLOCRT_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCRT_VERSION_NBR;
    xLOCRT_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_LOC_RELATIONSHIP_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCRT_ROWID
    from T_LOCATION_RELATIONSHIP_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_LOCATION_RELATIONSHIP_TYPES where rowid = xLOCRT_ROWID;
    --
      P_TEXT.DELETE_TEXT(nITM_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 5, 'Location relationship type has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_LOC_RELATIONSHIP_TYPE;
--
-- ----------------------------------------
-- SET_LOCRT_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_LOCRT_DESCRIPTION
   (psCODE in P_BASE.tmsLOCRT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCRT_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCRT_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_LOCRT_TEXT(psCODE, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_LOCRT_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_LOCRT_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_LOCRT_DESCRIPTION
   (psCODE in P_BASE.tmsLOCRT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCRT_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_LOCRT_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_LOCRT_TEXT(psCODE, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_LOCRT_DESCRIPTION;
--
-- ----------------------------------------
-- SET_LOCRT_TEXT
-- ----------------------------------------
--
  procedure SET_LOCRT_TEXT
   (psCODE in P_BASE.tmsLOCRT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCRT_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCRT_VERSION_NBR;
    xLOCRT_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCRT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCRT_ROWID
    from T_LOCATION_RELATIONSHIP_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'LOCRT', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_LOCATION_RELATIONSHIP_TYPES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCRT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 5, 'Location relationship type has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_LOCRT_TEXT;
--
-- ----------------------------------------
-- REMOVE_LOCRT_TEXT
-- ----------------------------------------
--
  procedure REMOVE_LOCRT_TEXT
   (psCODE in P_BASE.tmsLOCRT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCRT_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCRT_VERSION_NBR;
    xLOCRT_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_LOCRT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCRT_ROWID
    from T_LOCATION_RELATIONSHIP_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_LOCATION_RELATIONSHIP_TYPES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCRT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 5, 'Location relationship type has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_LOCRT_TEXT;
--
-- ----------------------------------------
-- INSERT_LOCATION_RELATIONSHIP
-- ----------------------------------------
--
  procedure INSERT_LOCATION_RELATIONSHIP
   (pnLOC_ID_FROM in P_BASE.tmnLOC_ID,
    pnLOC_ID_TO in P_BASE.tmnLOC_ID,
    psLOCRT_CODE in P_BASE.tmsLOCRT_CODE,
    pdSTART_DATE in P_BASE.tdDate := null,
    pdEND_DATE in P_BASE.tdDate := null)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_LOCATION_RELATIONSHIP',
      to_char(pnLOC_ID_FROM) || '~' || to_char(pnLOC_ID_TO) || '~' ||
        psLOCRT_CODE || '~' || to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS'));
  --
    if psLOCRT_CODE = 'WITHIN'
    then
      INSERT_LOCATION_WITHIN(pnLOC_ID_FROM, pnLOC_ID_TO, pdSTART_DATE, pdEND_DATE);
    else
      INSERT_LOCATION_RELATIONSHIP1
       (pnLOC_ID_FROM, pnLOC_ID_TO, psLOCRT_CODE, pdSTART_DATE, pdEND_DATE);
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_LOCATION_RELATIONSHIP;
--
-- ----------------------------------------
-- UPDATE_LOCATION_RELATIONSHIP
-- ----------------------------------------
--
  procedure UPDATE_LOCATION_RELATIONSHIP
   (pnLOC_ID_FROM in P_BASE.tmnLOC_ID,
    pnLOC_ID_TO in P_BASE.tmnLOC_ID,
    psLOCRT_CODE in P_BASE.tmsLOCRT_CODE,
    pdSTART_DATE in P_BASE.tmdDate,
    pnVERSION_NBR in out P_BASE.tnLOCR_VERSION_NBR,
    pdSTART_DATE_NEW in P_BASE.tdDate := P_BASE.gdFALSE_DATE,
    pdEND_DATE in P_BASE.tdDate := P_BASE.gdFALSE_DATE)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_LOCATION_RELATIONSHIP',
      to_char(pnLOC_ID_FROM) || '~' || to_char(pnLOC_ID_TO) || '~' ||
        psLOCRT_CODE || '~' || to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pnVERSION_NBR) || '~' || to_char(pdSTART_DATE_NEW, 'YYYY-MM-DD HH24:MI:SS') ||
        '~' || to_char(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS'));
  --
    if psLOCRT_CODE = 'WITHIN'
    then
      UPDATE_LOCATION_WITHIN
       (pnLOC_ID_FROM, pnLOC_ID_TO, pdSTART_DATE, pnVERSION_NBR, pdSTART_DATE_NEW, pdEND_DATE);
    else
      UPDATE_LOCATION_RELATIONSHIP1
       (pnLOC_ID_FROM, pnLOC_ID_TO, psLOCRT_CODE, pdSTART_DATE,
        pnVERSION_NBR, pdSTART_DATE_NEW, pdEND_DATE);
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end UPDATE_LOCATION_RELATIONSHIP;
--
-- ----------------------------------------
-- DELETE_LOCATION_RELATIONSHIP
-- ----------------------------------------
--
  procedure DELETE_LOCATION_RELATIONSHIP
   (pnLOC_ID_FROM in P_BASE.tmnLOC_ID,
    pnLOC_ID_TO in P_BASE.tmnLOC_ID,
    psLOCRT_CODE in P_BASE.tmsLOCRT_CODE,
    pdSTART_DATE in P_BASE.tmdDate,
    pnVERSION_NBR in P_BASE.tnLOCR_VERSION_NBR)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_LOCATION_RELATIONSHIP',
      to_char(pnLOC_ID_FROM) || '~' || to_char(pnLOC_ID_TO) || '~' ||
        psLOCRT_CODE || '~' || to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pnVERSION_NBR));
  --
    if psLOCRT_CODE = 'WITHIN'
    then
      DELETE_LOCATION_WITHIN(pnLOC_ID_FROM, pnLOC_ID_TO, pdSTART_DATE, pnVERSION_NBR);
    else
      DELETE_LOCATION_RELATIONSHIP1
       (pnLOC_ID_FROM, pnLOC_ID_TO, psLOCRT_CODE, pdSTART_DATE, pnVERSION_NBR);
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_LOCATION_RELATIONSHIP;
--
-- ----------------------------------------
-- INSERT_LOCATION_WITHIN
-- ----------------------------------------
--
  procedure INSERT_LOCATION_WITHIN
   (pnLOC_ID_FROM in P_BASE.tmnLOC_ID,
    pnLOC_ID_TO in P_BASE.tmnLOC_ID,
    pdSTART_DATE in P_BASE.tdDate := null,
    pdEND_DATE in P_BASE.tdDate := null)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_LOCATION_WITHIN',
      to_char(pnLOC_ID_FROM) || '~' || to_char(pnLOC_ID_TO) || '~' ||
        to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS'));
  --
  -- Insert the requested relationship
  --
    INSERT_LOCATION_RELATIONSHIP1
     (pnLOC_ID_FROM, pnLOC_ID_TO, 'WITHIN', pdSTART_DATE, pdEND_DATE);
  --
  -- Insert transitive relationships above the requested one in the hierarchy.
  --
    for rLOCR in
     (select LOCR1.LOC_ID_FROM, LOCR1.START_DATE, LOCR1.END_DATE
      from
       (select LOC_ID_FROM,
          greatest(START_DATE, nvl(pdSTART_DATE, P_BASE.gdMIN_DATE)) as START_DATE,
          least(END_DATE, nvl(pdEND_DATE, P_BASE.gdMAX_DATE)) as END_DATE
        from T_LOCATION_RELATIONSHIPS
        where LOC_ID_TO = pnLOC_ID_FROM
        and LOCRT_CODE = 'WITHIN'
        and START_DATE <= nvl(pdEND_DATE, P_BASE.gdMAX_DATE)
        and END_DATE >=  nvl(pdSTART_DATE, P_BASE.gdMIN_DATE)) LOCR1
      where not exists
       (select null
        from T_LOCATION_RELATIONSHIPS LOCR2
        where LOCR2.LOC_ID_FROM = LOCR1.LOC_ID_FROM
        and LOCR2.LOC_ID_TO = pnLOC_ID_TO
        and LOCR2.LOCRT_CODE = 'WITHIN'
        and LOCR2.START_DATE < LOCR1.END_DATE
        and LOCR2.END_DATE > LOCR1.START_DATE))
    loop
      INSERT_LOCATION_RELATIONSHIP1
       (rLOCR.LOC_ID_FROM, pnLOC_ID_TO, 'WITHIN', rLOCR.START_DATE, rLOCR.END_DATE);
    end loop;
  --
  -- Insert transitive relationships below the requested one in the hierarchy.
  --
    for rLOCR in
     (select LOCR3.LOC_ID_FROM, LOCR3.LOC_ID_TO, LOCR3.START_DATE, LOCR3.END_DATE
      from
       (select LOCR1.LOC_ID_FROM, LOCR2.LOC_ID_TO,
          greatest(LOCR1.START_DATE, LOCR2.START_DATE) as START_DATE,
          greatest(LOCR1.END_DATE, LOCR2.END_DATE) as END_DATE
        from T_LOCATION_RELATIONSHIPS LOCR1
        inner join T_LOCATION_RELATIONSHIPS LOCR2
          on LOCR2.LOC_ID_FROM = LOCR1.LOC_ID_TO
          and LOCR2.LOCRT_CODE = 'WITHIN'
          and LOCR2.START_DATE < LOCR1.END_DATE
          and LOCR2.END_DATE > LOCR1.START_DATE
        where LOCR1.LOC_ID_TO = pnLOC_ID_TO
        and LOCR1.LOCRT_CODE = 'WITHIN') LOCR3
      where not exists
       (select null
        from T_LOCATION_RELATIONSHIPS LOCR4
        where LOCR4.LOC_ID_FROM = LOCR3.LOC_ID_FROM
        and LOCR4.LOC_ID_TO = LOCR3.LOC_ID_TO
        and LOCR4.LOCRT_CODE = 'WITHIN'
        and LOCR4.START_DATE < LOCR3.END_DATE
        and LOCR4.END_DATE > LOCR3.START_DATE))
    loop
      INSERT_LOCATION_RELATIONSHIP1
       (rLOCR.LOC_ID_FROM, rLOCR.LOC_ID_TO, 'WITHIN', rLOCR.START_DATE, rLOCR.END_DATE);
    end loop;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_LOCATION_WITHIN;
--
-- ----------------------------------------
-- UPDATE_LOCATION_WITHIN
-- ----------------------------------------
--
  procedure UPDATE_LOCATION_WITHIN
   (pnLOC_ID_FROM in P_BASE.tmnLOC_ID,
    pnLOC_ID_TO in P_BASE.tmnLOC_ID,
    pdSTART_DATE in P_BASE.tmdDate,
    pnVERSION_NBR in out P_BASE.tnLOCR_VERSION_NBR,
    pdSTART_DATE_NEW in P_BASE.tdDate := P_BASE.gdFALSE_DATE,
    pdEND_DATE in P_BASE.tdDate := P_BASE.gdFALSE_DATE)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_LOCATION_WITHIN',
      to_char(pnLOC_ID_FROM) || '~' || to_char(pnLOC_ID_TO) || '~' ||
        to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' || to_char(pnVERSION_NBR) || '~' ||
        to_char(pdSTART_DATE_NEW, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS'));
  --
    UPDATE_LOCATION_RELATIONSHIP1
     (pnLOC_ID_FROM, pnLOC_ID_TO, 'WITHIN', pdSTART_DATE, pnVERSION_NBR, pdSTART_DATE_NEW, pdEND_DATE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end UPDATE_LOCATION_WITHIN;
--
-- ----------------------------------------
-- DELETE_LOCATION_WITHIN
-- ----------------------------------------
--
  procedure DELETE_LOCATION_WITHIN
   (pnLOC_ID_FROM in P_BASE.tmnLOC_ID,
    pnLOC_ID_TO in P_BASE.tmnLOC_ID,
    pdSTART_DATE in P_BASE.tmdDate,
    pnVERSION_NBR in P_BASE.tnLOCR_VERSION_NBR)
  is
    dEND_DATE P_BASE.tdDate;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_LOCATION_WITHIN',
      to_char(pnLOC_ID_FROM) || '~' || to_char(pnLOC_ID_TO) || '~' ||
        to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' || to_char(pnVERSION_NBR));
  --
    select END_DATE
    into dEND_DATE
    from T_LOCATION_RELATIONSHIPS
    where LOC_ID_FROM = pnLOC_ID_FROM
    and LOC_ID_TO = pnLOC_ID_TO
    and LOCRT_CODE = 'WITHIN'
    and START_DATE = pdSTART_DATE;
  --
    DELETE_LOCATION_RELATIONSHIP1
     (pnLOC_ID_FROM, pnLOC_ID_TO, 'WITHIN', pdSTART_DATE, pnVERSION_NBR);
  --
  -- Delete transitive relationships invalidated by the deletion.
  --
    for rLOCR in
     (select LOC_ID_FROM, LOC_ID_TO, START_DATE, VERSION_NBR
      from T_LOCATION_RELATIONSHIPS
      where LOC_ID_FROM = pnLOC_ID_TO
      and LOCRT_CODE = 'WITHIN'
      and START_DATE >= pdSTART_DATE
      and END_DATE >= dEND_DATE)
    loop
      DELETE_LOCATION_RELATIONSHIP1
       (pnLOC_ID_FROM, rLOCR.LOC_ID_TO, 'WITHIN', rLOCR.START_DATE, rLOCR.VERSION_NBR);
    end loop;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_LOCATION_WITHIN;
--
-- ----------------------------------------
-- SET_LOCR_TEXT
-- ----------------------------------------
--
  procedure SET_LOCR_TEXT
   (pnLOC_ID_FROM in P_BASE.tmnLOC_ID,
    pnLOC_ID_TO in P_BASE.tmnLOC_ID,
    psLOCRT_CODE in P_BASE.tmsLOCRT_CODE,
    pdSTART_DATE in P_BASE.tmdDate,
    pnVERSION_NBR in out P_BASE.tnLOCR_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCR_VERSION_NBR;
    xLOCR_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCR_TEXT',
      to_char(pnLOC_ID_FROM) || '~' || to_char(pnLOC_ID_TO) || '~' ||
        psLOCRT_CODE || '~' || to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' ||
        psLANG_CODE || '~' || to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCR_ROWID
    from T_LOCATION_RELATIONSHIPS
    where LOC_ID_FROM = pnLOC_ID_FROM
    and LOC_ID_TO = pnLOC_ID_TO
    and LOCRT_CODE = psLOCRT_CODE
    and START_DATE = pdSTART_DATE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'LOCR', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_LOCATION_RELATIONSHIPS
      set ITM_ID = nITM_ID,
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCR_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 6, 'Location relationship has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_LOCR_TEXT;
--
-- ----------------------------------------
-- REMOVE_LOCR_TEXT
-- ----------------------------------------
--
  procedure REMOVE_LOCR_TEXT
   (pnLOC_ID_FROM in P_BASE.tmnLOC_ID,
    pnLOC_ID_TO in P_BASE.tmnLOC_ID,
    psLOCRT_CODE in P_BASE.tmsLOCRT_CODE,
    pdSTART_DATE in P_BASE.tmdDate,
    pnVERSION_NBR in out P_BASE.tnLOCR_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCR_VERSION_NBR;
    xLOCR_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_LOCR_TEXT',
      to_char(pnLOC_ID_FROM) || '~' || to_char(pnLOC_ID_TO) || '~' || psLOCRT_CODE ||
        '~' || to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' || to_char(pnVERSION_NBR) ||
        '~' || psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCR_ROWID
    from T_LOCATION_RELATIONSHIPS
    where LOC_ID_FROM = pnLOC_ID_FROM
    and LOC_ID_TO = pnLOC_ID_TO
    and LOCRT_CODE = psLOCRT_CODE
    and START_DATE = pdSTART_DATE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_LOCATION_RELATIONSHIPS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCR_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 6, 'Location relationship has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_LOCR_TEXT;
--
-- ----------------------------------------
-- INSERT_LOC_TYPE_RELATIONSHIP
-- ----------------------------------------
--
  procedure INSERT_LOC_TYPE_RELATIONSHIP
   (psLOCT_CODE_FROM in P_BASE.tmsLOCT_CODE,
    psLOCT_CODE_TO in P_BASE.tmsLOCT_CODE,
    psLOCRT_CODE in P_BASE.tmsLOCRT_CODE)
  is
    sACTIVE_FLAG P_BASE.tsLOCRT_ACTIVE_FLAG;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_LOC_TYPE_RELATIONSHIP',
      psLOCT_CODE_FROM || '~' || psLOCT_CODE_TO || '~' || psLOCRT_CODE);
  --
    select ACTIVE_FLAG into sACTIVE_FLAG from T_LOCATION_RELATIONSHIP_TYPES where CODE = psLOCRT_CODE;
  --
    if sACTIVE_FLAG = 'N'
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 16, 'Inactive location relationship type');
    end if;
  --
    insert into T_LOCATION_TYPE_RELATIONSHIPS (LOCT_CODE_FROM, LOCT_CODE_TO, LOCRT_CODE)
    values (psLOCT_CODE_FROM, psLOCT_CODE_TO, psLOCRT_CODE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_LOC_TYPE_RELATIONSHIP;
--
-- ----------------------------------------
-- DELETE_LOC_TYPE_RELATIONSHIP
-- ----------------------------------------
--
  procedure DELETE_LOC_TYPE_RELATIONSHIP
   (psLOCT_CODE_FROM in P_BASE.tmsLOCT_CODE,
    psLOCT_CODE_TO in P_BASE.tmsLOCT_CODE,
    psLOCRT_CODE in P_BASE.tmsLOCRT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCTR_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCTR_VERSION_NBR;
    xLOCTR_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_LOC_TYPE_RELATIONSHIP',
      psLOCT_CODE_FROM || '~' || psLOCT_CODE_TO || '~' || psLOCRT_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCTR_ROWID
    from T_LOCATION_TYPE_RELATIONSHIPS
    where LOCT_CODE_FROM = psLOCT_CODE_FROM
    and LOCT_CODE_TO = psLOCT_CODE_TO
    and LOCRT_CODE = psLOCRT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_LOCATION_TYPE_RELATIONSHIPS where rowid = xLOCTR_ROWID;
    --
      if nITM_ID is not null
      then P_TEXT.DELETE_TEXT(nITM_ID);
      end if;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 5, 'Location relationship type has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_LOC_TYPE_RELATIONSHIP;
--
-- ----------------------------------------
-- SET_LOCTR_TEXT
-- ----------------------------------------
--
  procedure SET_LOCTR_TEXT
   (psLOCT_CODE_FROM in P_BASE.tmsLOCT_CODE,
    psLOCT_CODE_TO in P_BASE.tmsLOCT_CODE,
    psLOCRT_CODE in P_BASE.tmsLOCRT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCTR_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCTR_VERSION_NBR;
    xLOCTR_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCTR_TEXT',
      psLOCT_CODE_FROM || '~' || psLOCT_CODE_TO || '~' || psLOCRT_CODE || '~' ||
        to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' ||
        psLANG_CODE || '~' || to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCTR_ROWID
    from T_LOCATION_TYPE_RELATIONSHIPS
    where LOCT_CODE_FROM = psLOCT_CODE_FROM
    and LOCT_CODE_TO = psLOCT_CODE_TO
    and LOCRT_CODE = psLOCRT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'LOCR', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_LOCATION_TYPE_RELATIONSHIPS
      set ITM_ID = nITM_ID,
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCTR_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 6, 'Location relationship has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_LOCTR_TEXT;
--
-- ----------------------------------------
-- REMOVE_LOCTR_TEXT
-- ----------------------------------------
--
  procedure REMOVE_LOCTR_TEXT
   (psLOCT_CODE_FROM in P_BASE.tmsLOCT_CODE,
    psLOCT_CODE_TO in P_BASE.tmsLOCT_CODE,
    psLOCRT_CODE in P_BASE.tmsLOCRT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCTR_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCTR_VERSION_NBR;
    xLOCTR_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_LOCTR_TEXT',
      psLOCT_CODE_FROM || '~' || psLOCT_CODE_TO || '~' || psLOCRT_CODE || '~' ||
        to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCTR_ROWID
    from T_LOCATION_TYPE_RELATIONSHIPS
    where LOCT_CODE_FROM = psLOCT_CODE_FROM
    and LOCT_CODE_TO = psLOCT_CODE_TO
    and LOCRT_CODE = psLOCRT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_LOCATION_TYPE_RELATIONSHIPS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCTR_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 6, 'Location relationship has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_LOCTR_TEXT;
--
-- ----------------------------------------
-- INSERT_LOCATION_TYPE_VARIANT
-- ----------------------------------------
--
  procedure INSERT_LOCATION_TYPE_VARIANT
   (pnID out P_BASE.tnLOCTV_ID,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText,
    psLOCT_CODE in P_BASE.tmsLOCT_CODE,
    pnLOC_ID in P_BASE.tmnLOC_ID,
    psLOCRT_CODE in P_BASE.tmsLOCRT_CODE,
    pnDISPLAY_SEQ in P_BASE.tnLOCTV_DISPLAY_SEQ := null,
    psACTIVE_FLAG in P_BASE.tsLOCTV_ACTIVE_FLAG := 'Y')
  is
    nITM_ID P_BASE.tnITM_ID;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_LOCATION_TYPE_VARIANT',
      psLOCT_CODE || '~' || to_char(pnLOC_ID) || '~' || psLOCRT_CODE || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_TEXT.SET_TEXT(nITM_ID, 'LOCTV', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into T_LOCATION_TYPE_VARIANTS
     (ID, LOCT_CODE, LOC_ID, LOCRT_CODE, DISPLAY_SEQ, ACTIVE_FLAG,
      ITM_ID)
    values
     (LOCTV_SEQ.nextval, psLOCT_CODE, pnLOC_ID, psLOCRT_CODE, pnDISPLAY_SEQ, psACTIVE_FLAG,
      nITM_ID)
    returning ID into pnID;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_LOCATION_TYPE_VARIANT;
--
-- ----------------------------------------
-- UPDATE_LOCATION_TYPE_VARIANT
-- ----------------------------------------
--
  procedure UPDATE_LOCATION_TYPE_VARIANT
   (pnID in P_BASE.tmnLOCTV_ID,
    pnVERSION_NBR in out P_BASE.tnLOCTV_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnLOCTV_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsLOCTV_ACTIVE_FLAG := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCTV_VERSION_NBR;
    xLOCTV_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_LOCATION_TYPE_VARIANT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCTV_ROWID
    from T_LOCATION_TYPE_VARIANTS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psDescription is not null
      then P_TEXT.SET_TEXT(nITM_ID, 'LOCTV', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update T_LOCATION_TYPE_VARIANTS
      set DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCTV_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 7, 'Location type variant has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end UPDATE_LOCATION_TYPE_VARIANT;
--
-- ----------------------------------------
-- SET_LOCATION_TYPE_VARIANT
-- ----------------------------------------
--
  procedure SET_LOCATION_TYPE_VARIANT
   (pnID in out P_BASE.tnLOCTV_ID,
    pnVERSION_NBR in out P_BASE.tnLOCTV_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    psLOCT_CODE in P_BASE.tsLOCT_CODE := null,
    pnLOC_ID in P_BASE.tnLOC_ID := null,
    psLOCRT_CODE in P_BASE.tsLOCRT_CODE := null,
    pnDISPLAY_SEQ in P_BASE.tnLOCTV_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsLOCTV_ACTIVE_FLAG := null)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCATION_TYPE_VARIANT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psLOCT_CODE || '~' || to_char(pnLOC_ID) || '~' || psLOCRT_CODE || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    if pnVERSION_NBR is null
    then
      INSERT_LOCATION_TYPE_VARIANT
       (pnID, psLANG_CODE, psDescription, psLOCT_CODE, pnLOC_ID, psLOCRT_CODE,
        case when pnDISPLAY_SEQ = -1e6 then null else pnDISPLAY_SEQ end, nvl(psACTIVE_FLAG, 'Y'));
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_LOCATION_TYPE_VARIANT
       (pnID, pnVERSION_NBR, psLANG_CODE, psDescription, pnDISPLAY_SEQ, psACTIVE_FLAG);
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_LOCATION_TYPE_VARIANT;
--
-- ----------------------------------------
-- DELETE_LOCATION_TYPE_VARIANT
-- ----------------------------------------
--
  procedure DELETE_LOCATION_TYPE_VARIANT
   (pnID in P_BASE.tmnLOCTV_ID,
    pnVERSION_NBR in P_BASE.tnLOCTV_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCTV_VERSION_NBR;
    xLOCTV_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_LOCATION_TYPE_VARIANT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCTV_ROWID
    from T_LOCATION_TYPE_VARIANTS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_LOCATION_TYPE_VARIANTS where rowid = xLOCTV_ROWID;
    --
      P_TEXT.DELETE_TEXT(nITM_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 7, 'Location type variant has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_LOCATION_TYPE_VARIANT;
--
-- ----------------------------------------
-- SET_LOCTV_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_LOCTV_DESCRIPTION
   (pnID in P_BASE.tmnLOCTV_ID,
    pnVERSION_NBR in out P_BASE.tnLOCTV_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCTV_DESCRIPTION',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_LOCTV_TEXT(pnID, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_LOCTV_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_LOCTV_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_LOCTV_DESCRIPTION
   (pnID in P_BASE.tmnLOCTV_ID,
    pnVERSION_NBR in out P_BASE.tnLOCTV_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_LOCTV_DESCRIPTION',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_LOCTV_TEXT(pnID, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_LOCTV_DESCRIPTION;
--
-- ----------------------------------------
-- SET_LOCTV_TEXT
-- ----------------------------------------
--
  procedure SET_LOCTV_TEXT
   (pnID in P_BASE.tmnLOCTV_ID,
    pnVERSION_NBR in out P_BASE.tnLOCTV_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCTV_VERSION_NBR;
    xLOCTV_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCTV_TEXT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCTV_ROWID
    from T_LOCATION_TYPE_VARIANTS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'LOCTV', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_LOCATION_TYPE_VARIANTS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCTV_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 7, 'Location type variant has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_LOCTV_TEXT;
--
-- ----------------------------------------
-- REMOVE_LOCTV_TEXT
-- ----------------------------------------
--
  procedure REMOVE_LOCTV_TEXT
   (pnID in P_BASE.tmnLOCTV_ID,
    pnVERSION_NBR in out P_BASE.tnLOCTV_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCTV_VERSION_NBR;
    xLOCTV_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_LOCTV_TEXT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCTV_ROWID
    from T_LOCATION_TYPE_VARIANTS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_LOCATION_TYPE_VARIANTS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCTV_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 7, 'Location type variant has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_LOCTV_TEXT;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sComponent != 'LOC'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'Component code mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
  select CHAR_VALUE
  into gsCOUNTRY_LOCAT_CODE
  from T_SYSTEM_PARAMETERS
  where CODE = 'COUNTRY LOCAT CODE';
--
  select NUM_VALUE
  into gnLOC_ID_MULTIPLIER
  from T_SYSTEM_PARAMETERS
  where CODE = 'LOCATION ID MULTIPLIER';
--
  select NUM_VALUE
  into gnLOC_ID_INCREMENT
  from T_SYSTEM_PARAMETERS
  where CODE = 'LOCATION ID INCREMENT';
--
  select NUM_VALUE
  into gnLOC_ID_CHECK_MULTIPLIER
  from T_SYSTEM_PARAMETERS
  where CODE = 'LOCATION ID CHECK MULTIPLIER';
--
  select NUM_VALUE
  into gnLOC_ID_CHECK_INCREMENT
  from T_SYSTEM_PARAMETERS
  where CODE = 'LOCATION ID CHECK INCREMENT';
--
  select NUM_VALUE
  into gnLOC_ID_CHECK_MODULUS
  from T_SYSTEM_PARAMETERS
  where CODE = 'LOCATION ID CHECK MODULUS';
--
end P_LOCATION;
/

show errors
