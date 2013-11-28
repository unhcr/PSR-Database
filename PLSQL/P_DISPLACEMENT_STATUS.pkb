create or replace package body P_DISPLACEMENT_STATUS is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- INSERT_DISPLACEMENT_STATUS
-- ----------------------------------------
--
  procedure INSERT_DISPLACEMENT_STATUS
   (pnID out P_BASE.tnDST_ID,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText,
    psCODE in P_BASE.tmsDST_CODE,
    pdSTART_DATE in P_BASE.tdDate := null,
    pdEND_DATE in P_BASE.tdDate := null,
    pnDISPLAY_SEQ in P_BASE.tnDST_DISPLAY_SEQ := null,
    psACTIVE_FLAG in P_BASE.tmsDST_ACTIVE_FLAG := 'Y')
  is
    nITM_ID P_BASE.tnITM_ID;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.INSERT_DISPLACEMENT_STATUS',
      '~' || psCODE || '~' ||
        to_date(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_date(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
  -- Check for existing displacement status with same code and overlapping effective date range.
  --
    declare
      sDummy varchar2(1);
    begin
      select 'x'
      into sDummy
      from T_DISPLACEMENT_STATUSES
      where CODE = psCODE
      and START_DATE < nvl(pdEND_DATE, P_BASE.gdMAX_DATE)
      and END_DATE > nvl(pdSTART_DATE, P_BASE.gdMIN_DATE);
    --
      raise TOO_MANY_ROWS;
    exception
      when NO_DATA_FOUND then null;
    --
      when TOO_MANY_ROWS
      then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'Displacement status with this code already exists');
    end;
  --
    P_TEXT.SET_TEXT(nITM_ID, 'DST', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into T_DISPLACEMENT_STATUSES
     (ID, CODE,
      START_DATE, END_DATE,
      DISPLAY_SEQ, ACTIVE_FLAG, ITM_ID)
    values
     (DST_SEQ.nextval, psCODE,
      nvl(pdSTART_DATE, P_BASE.gdMIN_DATE), nvl(pdEND_DATE, P_BASE.gdMAX_DATE),
      pnDISPLAY_SEQ, psACTIVE_FLAG, nITM_ID)
    returning ID into pnID;
  --
    P_UTILITY.TRACE_CONTEXT
     (to_char(pnID) || '~' || psCODE || '~' ||
        to_date(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_date(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_DISPLACEMENT_STATUS;
--
-- ----------------------------------------
-- UPDATE_DISPLACEMENT_STATUS
-- ----------------------------------------
--
  procedure UPDATE_DISPLACEMENT_STATUS
   (pnID in P_BASE.tmnDST_ID,
    pnVERSION_NBR in out P_BASE.tnDST_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pdSTART_DATE in P_BASE.tdDate := P_BASE.gdFALSE_DATE,
    pdEND_DATE in P_BASE.tdDate := P_BASE.gdFALSE_DATE,
    pnDISPLAY_SEQ in P_BASE.tnDST_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsDST_ACTIVE_FLAG := null)
  is
    sCODE P_BASE.tsDST_CODE;
    dSTART_DATE P_BASE.tdDate;
    dEND_DATE P_BASE.tdDate;
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnDST_VERSION_NBR;
    xDST_ROWID rowid;
    dSTART_DATE_NEW P_BASE.tdDate;
    dEND_DATE_NEW P_BASE.tdDate;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.UPDATE_DISPLACEMENT_STATUS',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        to_date(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_date(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    select CODE, START_DATE, END_DATE, ITM_ID, VERSION_NBR, rowid
    into sCODE, dSTART_DATE, dEND_DATE, nITM_ID, nVERSION_NBR, xDST_ROWID
    from T_DISPLACEMENT_STATUSES
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
    -- Check if effective date range is being changed.
    --
      if dSTART_DATE_NEW != dSTART_DATE
        or dEND_DATE_NEW != dEND_DATE
      then
      --
      -- Check for existing displacement status with same code and overlapping effective date range.
      --
        declare
          sDummy varchar2(1);
        begin
          select 'x'
          into sDummy
          from T_DISPLACEMENT_STATUSES
          where CODE = sCODE
          and START_DATE < dEND_DATE_NEW
          and END_DATE > dSTART_DATE_NEW
          and ID != pnID;
        --
          raise TOO_MANY_ROWS;
        exception
          when NO_DATA_FOUND then null;
        --
          when TOO_MANY_ROWS
          then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'Displacement status with this code already exists');
        end;
      end if;
    --
      if psDescription is not null
      then P_TEXT.SET_TEXT(nITM_ID, 'DST', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update T_DISPLACEMENT_STATUSES
      set START_DATE = dSTART_DATE_NEW,
        END_DATE = dEND_DATE_NEW,
        DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xDST_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Displacement status has been updated by another user');
    end if;
  --
    P_UTILITY.TRACE_CONTEXT
     (to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        to_date(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_date(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end UPDATE_DISPLACEMENT_STATUS;
--
-- ----------------------------------------
-- SET_DISPLACEMENT_STATUS
-- ----------------------------------------
--
  procedure SET_DISPLACEMENT_STATUS
   (pnID in out P_BASE.tmnDST_ID,
    pnVERSION_NBR in out P_BASE.tnDST_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    psCODE in P_BASE.tsDST_CODE,
    pdSTART_DATE in P_BASE.tdDate := P_BASE.gdFALSE_DATE,
    pdEND_DATE in P_BASE.tdDate := P_BASE.gdFALSE_DATE,
    pnDISPLAY_SEQ in P_BASE.tnDST_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsDST_ACTIVE_FLAG := null)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_DISPLACEMENT_STATUS',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psCODE || '~' ||
        to_date(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_date(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    if pnVERSION_NBR is null
    then
      INSERT_DISPLACEMENT_STATUS
       (pnID, psLANG_CODE, psDescription, psCODE,
        case when pdSTART_DATE = P_BASE.gdFALSE_DATE then null else pdSTART_DATE end,
        case when pdEND_DATE = P_BASE.gdFALSE_DATE then null else pdEND_DATE end,
        case when pnDISPLAY_SEQ = -1e6 then null else pnDISPLAY_SEQ end,
        nvl(psACTIVE_FLAG, 'Y'));
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_DISPLACEMENT_STATUS
       (pnID, pnVERSION_NBR, psLANG_CODE, psDescription, pdSTART_DATE, pdEND_DATE,
        pnDISPLAY_SEQ, psACTIVE_FLAG);
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
  end SET_DISPLACEMENT_STATUS;
--
-- ----------------------------------------
-- DELETE_DISPLACEMENT_STATUS
-- ----------------------------------------
--
  procedure DELETE_DISPLACEMENT_STATUS
   (pnID in P_BASE.tmnDST_ID,
    pnVERSION_NBR in P_BASE.tnDST_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnDST_VERSION_NBR;
    xDST_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.DELETE_DISPLACEMENT_STATUS',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xDST_ROWID
    from T_DISPLACEMENT_STATUSES
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_DISPLACEMENT_STATUSES where rowid = xDST_ROWID;
    --
      P_TEXT.DELETE_TEXT(nITM_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Displacement status has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_DISPLACEMENT_STATUS;
--
-- ----------------------------------------
-- SET_DST_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_DST_DESCRIPTION
   (pnID in P_BASE.tmnDST_ID,
    pnVERSION_NBR in out P_BASE.tnDST_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_DST_DESCRIPTION',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_DST_TEXT(pnID, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_DST_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_DST_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_DST_DESCRIPTION
   (pnID in P_BASE.tmnDST_ID,
    pnVERSION_NBR in out P_BASE.tnDST_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.REMOVE_DST_DESCRIPTION',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_DST_TEXT(pnID, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_DST_DESCRIPTION;
--
-- ----------------------------------------
-- SET_DST_TEXT
-- ----------------------------------------
--
  procedure SET_DST_TEXT
   (pnID in P_BASE.tmnDST_ID,
    pnVERSION_NBR in out P_BASE.tnDST_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnDST_VERSION_NBR;
    xDST_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_DST_TEXT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' ||
        psLANG_CODE || '~' || to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xDST_ROWID
    from T_DISPLACEMENT_STATUSES
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'DST', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_DISPLACEMENT_STATUSES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xDST_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Displacement status has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_DST_TEXT;
--
-- ----------------------------------------
-- REMOVE_DST_TEXT
-- ----------------------------------------
--
  procedure REMOVE_DST_TEXT
   (pnID in P_BASE.tmnDST_ID,
    pnVERSION_NBR in out P_BASE.tnDST_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnDST_VERSION_NBR;
    xDST_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.REMOVE_DST_TEXT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xDST_ROWID
    from T_DISPLACEMENT_STATUSES
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_DISPLACEMENT_STATUSES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xDST_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Displacement status has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_DST_TEXT;
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
  if sComponent != 'DST'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 3, 'Component code mismatch');
  end if;
--
end P_DISPLACEMENT_STATUS;
/

show errors
