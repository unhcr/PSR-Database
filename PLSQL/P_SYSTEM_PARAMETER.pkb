create or replace package body P_SYSTEM_PARAMETER is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- INSERT_SYSTEM_PARAMETER
-- ----------------------------------------
--
  procedure INSERT_SYSTEM_PARAMETER
   (psCODE in P_BASE.tmsSYP_CODE,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText,
    psDATA_TYPE in P_BASE.tmsSYP_DATA_TYPE,
    psCHAR_VALUE in P_BASE.tsSYP_CHAR_VALUE := null,
    pnNUM_VALUE in P_BASE.tnSYP_NUM_VALUE := null,
    pdDATE_VALUE in P_BASE.tdSYP_DATE_VALUE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.INSERT_SYSTEM_PARAMETER',
      psCODE|| '~' || psDATA_TYPE || '~' || psCHAR_VALUE || '~' || to_char(pnNUM_VALUE) || '~' ||
        to_char(pdDATE_VALUE, 'YYYY-MM-DD HH24:MI:SS') || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    P_TEXT.SET_TEXT(nITM_ID, 'SYP', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into T_SYSTEM_PARAMETERS (CODE, DATA_TYPE, CHAR_VALUE, NUM_VALUE, DATE_VALUE, ITM_ID)
    values (psCODE, psDATA_TYPE, psCHAR_VALUE, pnNUM_VALUE, pdDATE_VALUE, nITM_ID);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_SYSTEM_PARAMETER;
--
-- ----------------------------------------
-- UPDATE_SYSTEM_PARAMETER
-- ----------------------------------------
--
  procedure UPDATE_SYSTEM_PARAMETER
   (psCODE in P_BASE.tmsSYP_CODE,
    pnVERSION_NBR in out P_BASE.tnSYP_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    psDATA_TYPE in P_BASE.tsSYP_DATA_TYPE := null,
    psCHAR_VALUE in P_BASE.tsSYP_CHAR_VALUE := null,
    pnNUM_VALUE in P_BASE.tnSYP_NUM_VALUE := null,
    pdDATE_VALUE in P_BASE.tdSYP_DATE_VALUE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnSYP_VERSION_NBR;
    xSYP_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.UPDATE_SYSTEM_PARAMETER',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psDATA_TYPE || '~' || psCHAR_VALUE || '~' ||
        to_char(pnNUM_VALUE) || '~' || to_char(pdDATE_VALUE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xSYP_ROWID
    from T_SYSTEM_PARAMETERS
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psDescription is not null
      then P_TEXT.SET_TEXT(nITM_ID, 'SYP', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update T_SYSTEM_PARAMETERS
      set DATA_TYPE = nvl(psDATA_TYPE, DATA_TYPE),
        CHAR_VALUE = psCHAR_VALUE,
        NUM_VALUE = pnNUM_VALUE,
        DATE_VALUE = pdDATE_VALUE,
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xSYP_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'System parameter has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end UPDATE_SYSTEM_PARAMETER;
--
-- ----------------------------------------
-- SET_SYSTEM_PARAMETER
-- ----------------------------------------
--
  procedure SET_SYSTEM_PARAMETER
   (psCODE in P_BASE.tmsSYP_CODE,
    pnVERSION_NBR in out P_BASE.tnSYP_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    psDATA_TYPE in P_BASE.tsSYP_DATA_TYPE := null,
    psCHAR_VALUE in P_BASE.tsSYP_CHAR_VALUE := null,
    pnNUM_VALUE in P_BASE.tnSYP_NUM_VALUE := null,
    pdDATE_VALUE in P_BASE.tdSYP_DATE_VALUE := null)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_SYSTEM_PARAMETER',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psDATA_TYPE || '~' || psCHAR_VALUE || '~' ||
        to_char(pnNUM_VALUE) || '~' || to_char(pdDATE_VALUE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    if pnVERSION_NBR is null
    then
      INSERT_SYSTEM_PARAMETER(psCODE, psLANG_CODE, psDescription,
                              psDATA_TYPE, psCHAR_VALUE, pnNUM_VALUE, pdDATE_VALUE);
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_SYSTEM_PARAMETER(psCODE, pnVERSION_NBR, psLANG_CODE, psDescription,
                              psDATA_TYPE, psCHAR_VALUE, pnNUM_VALUE, pdDATE_VALUE);
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_SYSTEM_PARAMETER;
--
-- ----------------------------------------
-- DELETE_SYSTEM_PARAMETER
-- ----------------------------------------
--
  procedure DELETE_SYSTEM_PARAMETER
   (psCODE in P_BASE.tmsSYP_CODE,
    pnVERSION_NBR in P_BASE.tnSYP_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnSYP_VERSION_NBR;
    xSYP_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.DELETE_SYSTEM_PARAMETER',
      psCODE || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xSYP_ROWID
    from T_SYSTEM_PARAMETERS
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_SYSTEM_PARAMETERS where rowid = xSYP_ROWID;
    --
      P_TEXT.DELETE_TEXT(nITM_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'System parameter has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_SYSTEM_PARAMETER;
--
-- ----------------------------------------
-- SET_SYP_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_SYP_DESCRIPTION
   (psCODE in P_BASE.tmsSYP_CODE,
    pnVERSION_NBR in out P_BASE.tnSYP_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_SYP_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_SYP_TEXT(psCODE, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_SYP_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_SYP_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_SYP_DESCRIPTION
   (psCODE in P_BASE.tmsSYP_CODE,
    pnVERSION_NBR in out P_BASE.tnSYP_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.REMOVE_SYP_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_SYP_TEXT(psCODE, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_SYP_DESCRIPTION;
--
-- ----------------------------------------
-- SET_SYP_TEXT
-- ----------------------------------------
--
  procedure SET_SYP_TEXT
   (psCODE in P_BASE.tmsSYP_CODE,
    pnVERSION_NBR in out P_BASE.tnSYP_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnSYP_VERSION_NBR;
    xSYP_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_SYP_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xSYP_ROWID
    from T_SYSTEM_PARAMETERS
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'SYP', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_SYSTEM_PARAMETERS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xSYP_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'System parameter has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_SYP_TEXT;
--
-- ----------------------------------------
-- REMOVE_SYP_TEXT
-- ----------------------------------------
--
  procedure REMOVE_SYP_TEXT
   (psCODE in P_BASE.tmsSYP_CODE,
    pnVERSION_NBR in out P_BASE.tnSYP_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnSYP_VERSION_NBR;
    xSYP_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.REMOVE_SYP_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xSYP_ROWID
    from T_SYSTEM_PARAMETERS
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_SYSTEM_PARAMETERS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xSYP_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'System parameter has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_SYP_TEXT;
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
  if sComponent != 'SYP'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 3, 'Component code mismatch');
  end if;
--
end P_SYSTEM_PARAMETER;
/

show errors
