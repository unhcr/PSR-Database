create or replace package body P_DIMENSION is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- INSERT_DIMENSION_TYPE
-- ----------------------------------------
--
  procedure INSERT_DIMENSION_TYPE
   (psCODE in P_BASE.tmsDIMT_CODE,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText,
    pnDISPLAY_SEQ in P_BASE.tnDIMT_DISPLAY_SEQ := null,
    psACTIVE_FLAG in P_BASE.tmsDIMT_ACTIVE_FLAG := 'Y')
  is
    nITM_ID P_BASE.tnITM_ID;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.INSERT_DIMENSION_TYPE',
      psCODE || '~' || to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_TEXT.SET_TEXT(nITM_ID, 'DIMT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into T_DIMENSION_TYPES (CODE, DISPLAY_SEQ, ACTIVE_FLAG, ITM_ID)
    values (psCODE, pnDISPLAY_SEQ, psACTIVE_FLAG, nITM_ID);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_DIMENSION_TYPE;
--
-- ----------------------------------------
-- UPDATE_DIMENSION_TYPE
-- ----------------------------------------
--
  procedure UPDATE_DIMENSION_TYPE
   (psCODE in P_BASE.tmsDIMT_CODE,
    pnVERSION_NBR in out P_BASE.tnDIMT_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnDIMT_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsDIMT_ACTIVE_FLAG := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnDIMT_VERSION_NBR;
    xDIMT_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.UPDATE_DIMENSION_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnDISPLAY_SEQ) ||
        '~' || psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xDIMT_ROWID
    from T_DIMENSION_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psDescription is not null
      then P_TEXT.SET_TEXT(nITM_ID, 'DIMT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update T_DIMENSION_TYPES
      set DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xDIMT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Dimension type has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end UPDATE_DIMENSION_TYPE;
--
-- ----------------------------------------
-- SET_DIMENSION_TYPE
-- ----------------------------------------
--
  procedure SET_DIMENSION_TYPE
   (psCODE in P_BASE.tmsDIMT_CODE,
    pnVERSION_NBR in out P_BASE.tnDIMT_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnDIMT_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsDIMT_ACTIVE_FLAG := null)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_DIMENSION_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnDISPLAY_SEQ) || '~' ||
        psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    if pnVERSION_NBR is null
    then
      INSERT_DIMENSION_TYPE(psCODE, psLANG_CODE, psDescription,
                            case when pnDISPLAY_SEQ = -1e6 then null else pnDISPLAY_SEQ end,
                            nvl(psACTIVE_FLAG, 'Y'));
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_DIMENSION_TYPE(psCODE, pnVERSION_NBR, psLANG_CODE, psDescription,
                            pnDISPLAY_SEQ, psACTIVE_FLAG);
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_DIMENSION_TYPE;
--
-- ----------------------------------------
-- DELETE_DIMENSION_TYPE
-- ----------------------------------------
--
  procedure DELETE_DIMENSION_TYPE
   (psCODE in P_BASE.tmsDIMT_CODE,
    pnVERSION_NBR in P_BASE.tnDIMT_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnDIMT_VERSION_NBR;
    xDIMT_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.DELETE_DIMENSION_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xDIMT_ROWID
    from T_DIMENSION_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_DIMENSION_TYPES where rowid = xDIMT_ROWID;
    --
      P_TEXT.DELETE_TEXT(nITM_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Dimension type has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_DIMENSION_TYPE;
--
-- ----------------------------------------
-- SET_DIMT_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_DIMT_DESCRIPTION
   (psCODE in P_BASE.tmsDIMT_CODE,
    pnVERSION_NBR in out P_BASE.tnDIMT_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_DIMT_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_DIMT_TEXT(psCODE, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_DIMT_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_DIMT_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_DIMT_DESCRIPTION
   (psCODE in P_BASE.tmsDIMT_CODE,
    pnVERSION_NBR in out P_BASE.tnDIMT_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.REMOVE_DIMT_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_DIMT_TEXT(psCODE, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_DIMT_DESCRIPTION;
--
-- ----------------------------------------
-- SET_DIMT_TEXT
-- ----------------------------------------
--
  procedure SET_DIMT_TEXT
   (psCODE in P_BASE.tmsDIMT_CODE,
    pnVERSION_NBR in out P_BASE.tnDIMT_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnDIMT_VERSION_NBR;
    xDIMT_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_DIMT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' || to_char(pnSEQ_NBR) ||
        '~' || psLANG_CODE || '~' || to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xDIMT_ROWID
    from T_DIMENSION_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'DIMT', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_DIMENSION_TYPES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xDIMT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Dimension type has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_DIMT_TEXT;
--
-- ----------------------------------------
-- REMOVE_DIMT_TEXT
-- ----------------------------------------
--
  procedure REMOVE_DIMT_TEXT
   (psCODE in P_BASE.tmsDIMT_CODE,
    pnVERSION_NBR in out P_BASE.tnDIMT_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnDIMT_VERSION_NBR;
    xDIMT_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.REMOVE_DIMT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xDIMT_ROWID
    from T_DIMENSION_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_DIMENSION_TYPES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xDIMT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Dimension type has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_DIMT_TEXT;
--
-- ----------------------------------------
-- INSERT_DIMENSION_VALUE
-- ----------------------------------------
--
  procedure INSERT_DIMENSION_VALUE
   (pnID out P_BASE.tnDIM_ID,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText,
    psDIMT_CODE in P_BASE.tmsDIMT_CODE,
    psCODE in P_BASE.tmsDIM_CODE,
    pdSTART_DATE in P_BASE.tdDate := null,
    pdEND_DATE in P_BASE.tdDate := null,
    pnDISPLAY_SEQ in P_BASE.tnDIM_DISPLAY_SEQ := null,
    psACTIVE_FLAG in P_BASE.tmsDIM_ACTIVE_FLAG := 'Y')
  is
    nITM_ID P_BASE.tnITM_ID;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.INSERT_DIMENSION_VALUE',
      '~' || psDIMT_CODE || '~' || psCODE || '~' ||
        to_date(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_date(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
  -- Check for existing dimension value with same type and code and overlapping effective date
  --  range.
  --
    declare
      sDummy varchar2(1);
    begin
      select 'x'
      into sDummy
      from T_DIMENSION_VALUES
      where DIMT_CODE = psDIMT_CODE
      and CODE = psCODE
      and START_DATE < nvl(pdEND_DATE, P_BASE.gdMAX_DATE)
      and END_DATE > nvl(pdSTART_DATE, P_BASE.gdMIN_DATE);
    --
      raise TOO_MANY_ROWS;
    exception
      when NO_DATA_FOUND then null;
    --
      when TOO_MANY_ROWS
      then P_MESSAGE.DISPLAY_MESSAGE('DST', 3, 'Dimension value with this type and code already exists');
    end;
  --
    P_TEXT.SET_TEXT(nITM_ID, 'DIM', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into T_DIMENSION_VALUES
     (ID, DIMT_CODE, CODE,
      START_DATE, END_DATE,
      DISPLAY_SEQ, ACTIVE_FLAG, ITM_ID)
    values
     (DIM_SEQ.nextval, psDIMT_CODE, psCODE,
      nvl(pdSTART_DATE, P_BASE.gdMIN_DATE), nvl(pdEND_DATE, P_BASE.gdMAX_DATE),
      pnDISPLAY_SEQ, psACTIVE_FLAG, nITM_ID)
    returning ID into pnID;
  --
    P_UTILITY.TRACE_CONTEXT
     (to_char(pnID) || '~' || psDIMT_CODE || '~' || psCODE || '~' ||
        to_date(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_date(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_DIMENSION_VALUE;
--
-- ----------------------------------------
-- UPDATE_DIMENSION_VALUE
-- ----------------------------------------
--
  procedure UPDATE_DIMENSION_VALUE
   (pnID in P_BASE.tmnDIM_ID,
    pnVERSION_NBR in out P_BASE.tnDIM_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    psCODE in P_BASE.tsDIM_CODE := null,
    pdSTART_DATE in P_BASE.tdDate := P_BASE.gdFALSE_DATE,
    pdEND_DATE in P_BASE.tdDate := P_BASE.gdFALSE_DATE,
    pnDISPLAY_SEQ in P_BASE.tnDIM_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsDIM_ACTIVE_FLAG := null)
  is
    sDIMT_CODE P_BASE.tsDIMT_CODE;
    sCODE P_BASE.tsDIM_CODE;
    dSTART_DATE P_BASE.tdDate;
    dEND_DATE P_BASE.tdDate;
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnDIM_VERSION_NBR;
    xDIM_ROWID rowid;
    dSTART_DATE_NEW P_BASE.tdDate;
    dEND_DATE_NEW P_BASE.tdDate;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.UPDATE_DIMENSION_VALUE',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psCODE || '~' ||
        to_date(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_date(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    select DIMT_CODE, CODE, START_DATE, END_DATE, ITM_ID, VERSION_NBR, rowid
    into sDIMT_CODE, sCODE, dSTART_DATE, dEND_DATE, nITM_ID, nVERSION_NBR, xDIM_ROWID
    from T_DIMENSION_VALUES
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
    -- Check if code or effective date range are being changed.
    --
      if psCODE != sCODE
        or dSTART_DATE_NEW != dSTART_DATE
        or dEND_DATE_NEW != dEND_DATE
      then
      --
      -- Check for existing dimension value with same type and code and overlapping effective date
      --  range.
      --
        declare
          sDummy varchar2(1);
        begin
          select 'x'
          into sDummy
          from T_DIMENSION_VALUES
          where DIMT_CODE = sDIMT_CODE
          and CODE = psCODE
          and START_DATE < dEND_DATE_NEW
          and END_DATE > dSTART_DATE_NEW
          and ID != pnID;
        --
          raise TOO_MANY_ROWS;
        exception
          when NO_DATA_FOUND then null;
        --
          when TOO_MANY_ROWS
          then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 3, 'Dimension value with this type and code already exists');
        end;
      end if;
    --
      if psDescription is not null
      then P_TEXT.SET_TEXT(nITM_ID, 'DIM', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update T_DIMENSION_VALUES
      set CODE = nvl(psCODE, CODE),
        START_DATE = dSTART_DATE_NEW,
        END_DATE = dEND_DATE_NEW,
        DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xDIM_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'Dimension value has been updated by another user');
    end if;
  --
    P_UTILITY.TRACE_CONTEXT
     (to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psCODE || '~' ||
        to_date(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_date(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end UPDATE_DIMENSION_VALUE;
--
-- ----------------------------------------
-- SET_DIMENSION_VALUE
-- ----------------------------------------
--
  procedure SET_DIMENSION_VALUE
   (pnID in out P_BASE.tnDIM_ID,
    pnVERSION_NBR in out P_BASE.tnDIM_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    psDIMT_CODE in P_BASE.tsDIMT_CODE := null,
    psCODE in P_BASE.tsDIM_CODE := null,
    pdSTART_DATE in P_BASE.tdDate := P_BASE.gdFALSE_DATE,
    pdEND_DATE in P_BASE.tdDate := P_BASE.gdFALSE_DATE,
    pnDISPLAY_SEQ in P_BASE.tnDIM_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsDIM_ACTIVE_FLAG := null)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_DIMENSION_VALUE',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psDIMT_CODE || '~' || psCODE || '~' ||
        to_date(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_date(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    if pnVERSION_NBR is null
    then
      INSERT_DIMENSION_VALUE
       (pnID, psLANG_CODE, psDescription, psDIMT_CODE, psCODE,
        case when pdSTART_DATE = P_BASE.gdFALSE_DATE then null else pdSTART_DATE end,
        case when pdEND_DATE = P_BASE.gdFALSE_DATE then null else pdEND_DATE end,
        case when pnDISPLAY_SEQ = -1e6 then null else pnDISPLAY_SEQ end,
        nvl(psACTIVE_FLAG, 'Y'));
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_DIMENSION_VALUE
       (pnID, pnVERSION_NBR, psLANG_CODE, psDescription, psCODE, pdSTART_DATE, pdEND_DATE,
        pnDISPLAY_SEQ, psACTIVE_FLAG);
    end if;
  --
    P_UTILITY.TRACE_CONTEXT
     (to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psDIMT_CODE || '~' || psCODE || '~' ||
        to_date(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_date(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_DIMENSION_VALUE;
--
-- ----------------------------------------
-- DELETE_DIMENSION_VALUE
-- ----------------------------------------
--
  procedure DELETE_DIMENSION_VALUE
   (pnID in P_BASE.tmnDIM_ID,
    pnVERSION_NBR in P_BASE.tnDIM_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnDIM_VERSION_NBR;
    xDIM_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.DELETE_DIMENSION_VALUE',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xDIM_ROWID
    from T_DIMENSION_VALUES
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_DIMENSION_VALUES where rowid = xDIM_ROWID;
    --
      P_TEXT.DELETE_TEXT(nITM_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'Dimension value has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_DIMENSION_VALUE;
--
-- ----------------------------------------
-- SET_DIM_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_DIM_DESCRIPTION
   (pnID in P_BASE.tmnDIM_ID,
    pnVERSION_NBR in out P_BASE.tnDIM_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_DIM_DESCRIPTION',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_DIM_TEXT(pnID, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_DIM_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_DIM_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_DIM_DESCRIPTION
   (pnID in P_BASE.tmnDIM_ID,
    pnVERSION_NBR in out P_BASE.tnDIM_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.REMOVE_DIM_DESCRIPTION',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_DIM_TEXT(pnID, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_DIM_DESCRIPTION;
--
-- ----------------------------------------
-- SET_DIM_TEXT
-- ----------------------------------------
--
  procedure SET_DIM_TEXT
   (pnID in P_BASE.tmnDIM_ID,
    pnVERSION_NBR in out P_BASE.tnDIM_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnDIM_VERSION_NBR;
    xDIM_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_DIM_TEXT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' || to_char(pnSEQ_NBR) ||
        '~' || psLANG_CODE || '~' || to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xDIM_ROWID
    from T_DIMENSION_VALUES
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'DIM', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_DIMENSION_VALUES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xDIM_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'Dimension value has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_DIM_TEXT;
--
-- ----------------------------------------
-- REMOVE_DIM_TEXT
-- ----------------------------------------
--
  procedure REMOVE_DIM_TEXT
   (pnID in P_BASE.tmnDIM_ID,
    pnVERSION_NBR in out P_BASE.tnDIM_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnDIM_VERSION_NBR;
    xDIM_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.REMOVE_DIM_TEXT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xDIM_ROWID
    from T_DIMENSION_VALUES
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_DIMENSION_VALUES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xDIM_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'Dimension value has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_DIM_TEXT;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sModule != $$PLSQL_UNIT
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'Module name mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
  if sComponent != 'DIM'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 3, 'Component code mismatch');
  end if;
--
end P_DIMENSION;
/

show errors
