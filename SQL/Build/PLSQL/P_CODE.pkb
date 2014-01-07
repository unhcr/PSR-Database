create or replace package body P_CODE is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- INSERT_CODE_TYPE
-- ----------------------------------------
--
  procedure INSERT_CODE_TYPE
   (psCODE in P_BASE.tmsCDET_CODE,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText,
    pnDISPLAY_SEQ in P_BASE.tnCDET_DISPLAY_SEQ := null,
    psACTIVE_FLAG in P_BASE.tmsCDET_ACTIVE_FLAG := 'Y')
  is
    nITM_ID P_BASE.tnITM_ID;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_CODE_TYPE',
      psCODE || '~' || to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_TEXT.SET_TEXT(nITM_ID, 'CDET', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into T_CODE_TYPES (CODE, DISPLAY_SEQ, ACTIVE_FLAG, ITM_ID)
    values (psCODE, pnDISPLAY_SEQ, psACTIVE_FLAG, nITM_ID);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_CODE_TYPE;
--
-- ----------------------------------------
-- UPDATE_CODE_TYPE
-- ----------------------------------------
--
  procedure UPDATE_CODE_TYPE
   (psCODE in P_BASE.tmsCDET_CODE,
    pnVERSION_NBR in out P_BASE.tnCDET_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnCDET_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsCDET_ACTIVE_FLAG := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnCDET_VERSION_NBR;
    xCDET_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_CODE_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnDISPLAY_SEQ) ||
        '~' || psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xCDET_ROWID
    from T_CODE_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psDescription is not null
      then P_TEXT.SET_TEXT(nITM_ID, 'CDET', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update T_CODE_TYPES
      set DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xCDET_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Code type has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end UPDATE_CODE_TYPE;
--
-- ----------------------------------------
-- SET_CODE_TYPE
-- ----------------------------------------
--
  procedure SET_CODE_TYPE
   (psCODE in P_BASE.tmsCDET_CODE,
    pnVERSION_NBR in out P_BASE.tnCDET_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnCDET_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsCDET_ACTIVE_FLAG := null)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_CODE_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnDISPLAY_SEQ) || '~' ||
        psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    if pnVERSION_NBR is null
    then
      INSERT_CODE_TYPE(psCODE, psLANG_CODE, psDescription,
                       case when pnDISPLAY_SEQ = -1e6 then null else pnDISPLAY_SEQ end,
                       nvl(psACTIVE_FLAG, 'Y'));
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_CODE_TYPE(psCODE, pnVERSION_NBR, psLANG_CODE, psDescription,
                       pnDISPLAY_SEQ, psACTIVE_FLAG);
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_CODE_TYPE;
--
-- ----------------------------------------
-- DELETE_CODE_TYPE
-- ----------------------------------------
--
  procedure DELETE_CODE_TYPE
   (psCODE in P_BASE.tmsCDET_CODE,
    pnVERSION_NBR in P_BASE.tnCDET_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnCDET_VERSION_NBR;
    xCDET_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_CODE_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xCDET_ROWID
    from T_CODE_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_CODE_TYPES where rowid = xCDET_ROWID;
    --
      P_TEXT.DELETE_TEXT(nITM_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Code type has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_CODE_TYPE;
--
-- ----------------------------------------
-- SET_CDET_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_CDET_DESCRIPTION
   (psCODE in P_BASE.tmsCDET_CODE,
    pnVERSION_NBR in out P_BASE.tnCDET_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_CDET_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_CDET_TEXT(psCODE, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_CDET_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_CDET_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_CDET_DESCRIPTION
   (psCODE in P_BASE.tmsCDET_CODE,
    pnVERSION_NBR in out P_BASE.tnCDET_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_CDET_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_CDET_TEXT(psCODE, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_CDET_DESCRIPTION;
--
-- ----------------------------------------
-- SET_CDET_TEXT
-- ----------------------------------------
--
  procedure SET_CDET_TEXT
   (psCODE in P_BASE.tmsCDET_CODE,
    pnVERSION_NBR in out P_BASE.tnCDET_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnCDET_VERSION_NBR;
    xCDET_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_CDET_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' || to_char(pnSEQ_NBR) ||
        '~' || psLANG_CODE || '~' || to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xCDET_ROWID
    from T_CODE_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'CDET', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_CODE_TYPES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xCDET_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Code type has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_CDET_TEXT;
--
-- ----------------------------------------
-- REMOVE_CDET_TEXT
-- ----------------------------------------
--
  procedure REMOVE_CDET_TEXT
   (psCODE in P_BASE.tmsCDET_CODE,
    pnVERSION_NBR in out P_BASE.tnCDET_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnCDET_VERSION_NBR;
    xCDET_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_CDET_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xCDET_ROWID
    from T_CODE_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_CODE_TYPES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xCDET_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Code type has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_CDET_TEXT;
--
-- ----------------------------------------
-- INSERT_CODE
-- ----------------------------------------
--
  procedure INSERT_CODE
   (psCDET_CODE in P_BASE.tmsCDET_CODE,
    psCODE in P_BASE.tmsCDE_CODE,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText,
    pnDISPLAY_SEQ in P_BASE.tnCDE_DISPLAY_SEQ := null,
    psACTIVE_FLAG in P_BASE.tmsCDE_ACTIVE_FLAG := 'Y')
  is
    nITM_ID P_BASE.tnITM_ID;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_CODE',
      psCDET_CODE || '~' || psCODE || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
  -- Check for existing code with same type and code.
  --
    declare
      sDummy varchar2(1);
    begin
      select 'x' into sDummy from T_CODES where CDET_CODE = psCDET_CODE and CODE = psCODE;
    --
      raise TOO_MANY_ROWS;
    exception
      when NO_DATA_FOUND then null;
    --
      when TOO_MANY_ROWS
      then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 3, 'Generic code already exists');
    end;
  --
    P_TEXT.SET_TEXT(nITM_ID, 'CDE', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into T_CODES (CDET_CODE, CODE, DISPLAY_SEQ, ACTIVE_FLAG, ITM_ID)
    values (psCDET_CODE, psCODE, pnDISPLAY_SEQ, psACTIVE_FLAG, nITM_ID);
  --
    P_UTILITY.TRACE_CONTEXT
     (psCDET_CODE || '~' || psCODE || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_CODE;
--
-- ----------------------------------------
-- UPDATE_CODE
-- ----------------------------------------
--
  procedure UPDATE_CODE
   (psCDET_CODE in P_BASE.tmsCDET_CODE,
    psCODE in P_BASE.tmsCDE_CODE,
    pnVERSION_NBR in out P_BASE.tnCDE_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnCDE_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsCDE_ACTIVE_FLAG := null)
  is
    sCDET_CODE P_BASE.tsCDET_CODE;
    sCODE P_BASE.tsCDE_CODE;
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnCDE_VERSION_NBR;
    xCDE_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_CODE',
      psCDET_CODE || '~' || psCODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    select CDET_CODE, CODE, ITM_ID, VERSION_NBR, rowid
    into sCDET_CODE, sCODE, nITM_ID, nVERSION_NBR, xCDE_ROWID
    from T_CODES
    where CDET_CODE = psCDET_CODE
    and CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psDescription is not null
      then P_TEXT.SET_TEXT(nITM_ID, 'CDE', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update T_CODES
      set DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xCDE_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'Generic code has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end UPDATE_CODE;
--
-- ----------------------------------------
-- SET_CODE
-- ----------------------------------------
--
  procedure SET_CODE
   (psCDET_CODE in P_BASE.tmsCDET_CODE,
    psCODE in P_BASE.tmsCDE_CODE,
    pnVERSION_NBR in out P_BASE.tnCDE_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnCDE_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsCDE_ACTIVE_FLAG := null)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_CODE',
      psCDET_CODE || '~' || psCODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    if pnVERSION_NBR is null
    then
      INSERT_CODE
       (psLANG_CODE, psDescription,
        case when pnDISPLAY_SEQ = -1e6 then null else pnDISPLAY_SEQ end,
        nvl(psACTIVE_FLAG, 'Y'));
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_CODE
       (psCDET_CODE, psCODE, pnVERSION_NBR, psLANG_CODE, psDescription, pnDISPLAY_SEQ, psACTIVE_FLAG);
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_CODE;
--
-- ----------------------------------------
-- DELETE_CODE
-- ----------------------------------------
--
  procedure DELETE_CODE
   (psCDET_CODE in P_BASE.tmsCDET_CODE,
    psCODE in P_BASE.tmsCDE_CODE,
    pnVERSION_NBR in P_BASE.tnCDE_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnCDE_VERSION_NBR;
    xCDE_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_CODE',
      psCDET_CODE || '~' || psCODE || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xCDE_ROWID
    from T_CODES
    where CDET_CODE = psCDET_CODE
    and CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_CODES where rowid = xCDE_ROWID;
    --
      P_TEXT.DELETE_TEXT(nITM_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'Generic code has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_CODE;
--
-- ----------------------------------------
-- SET_CDE_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_CDE_DESCRIPTION
   (psCDET_CODE in P_BASE.tmsCDET_CODE,
    psCODE in P_BASE.tmsCDE_CODE,
    pnVERSION_NBR in out P_BASE.tnCDE_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_CDE_DESCRIPTION',
      psCDET_CODE || '~' || psCODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_CDE_TEXT(psCDET_CODE, psCODE, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_CDE_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_CDE_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_CDE_DESCRIPTION
   (psCDET_CODE in P_BASE.tmsCDET_CODE,
    psCODE in P_BASE.tmsCDE_CODE,
    pnVERSION_NBR in out P_BASE.tnCDE_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_CDE_DESCRIPTION',
      psCDET_CODE || '~' || psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_CDE_TEXT(psCDET_CODE, psCODE, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_CDE_DESCRIPTION;
--
-- ----------------------------------------
-- SET_CDE_TEXT
-- ----------------------------------------
--
  procedure SET_CDE_TEXT
   (psCDET_CODE in P_BASE.tmsCDET_CODE,
    psCODE in P_BASE.tmsCDE_CODE,
    pnVERSION_NBR in out P_BASE.tnCDE_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnCDE_VERSION_NBR;
    xCDE_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_CDE_TEXT',
      psCDET_CODE || '~' || psCODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' ||
        psLANG_CODE || '~' || to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xCDE_ROWID
    from T_CODES
    where CDET_CODE = psCDET_CODE
    and CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'CDE', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_CODES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xCDE_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'Generic code has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_CDE_TEXT;
--
-- ----------------------------------------
-- REMOVE_CDE_TEXT
-- ----------------------------------------
--
  procedure REMOVE_CDE_TEXT
   (psCDET_CODE in P_BASE.tmsCDET_CODE,
    psCODE in P_BASE.tmsCDE_CODE,
    pnVERSION_NBR in out P_BASE.tnCDE_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnCDE_VERSION_NBR;
    xCDE_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_CDE_TEXT',
      psCDET_CODE || '~' || psCODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xCDE_ROWID
    from T_CODES
    where CDET_CODE = psCDET_CODE
    and CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_CODES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xCDE_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'Generic code has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_CDE_TEXT;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sComponent != 'CDE'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'Component code mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
end P_CODE;
/

show errors
