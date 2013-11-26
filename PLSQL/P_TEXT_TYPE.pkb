create or replace package body P_TEXT_TYPE is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- INSERT_TEXT_TYPE
-- ----------------------------------------
--
  procedure INSERT_TEXT_TYPE
   (psCODE in P_BASE.tmsTXTT_CODE,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText,
    pnDISPLAY_SEQ in P_BASE.tnTXTT_DISPLAY_SEQ := null,
    psACTIVE_FLAG in P_BASE.tmsTXTT_ACTIVE_FLAG := 'Y')
  is
    nITM_ID P_BASE.tnITM_ID;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_TEXT_TYPE',
      psCODE || '~' || to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_TEXT.SET_TEXT(nITM_ID, 'TXTT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into T_TEXT_TYPES (CODE, DISPLAY_SEQ, ACTIVE_FLAG, ITM_ID)
    values (psCODE, pnDISPLAY_SEQ, psACTIVE_FLAG, nITM_ID);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_TEXT_TYPE;
--
-- ----------------------------------------
-- UPDATE_TEXT_TYPE
-- ----------------------------------------
--
  procedure UPDATE_TEXT_TYPE
   (psCODE in P_BASE.tmsTXTT_CODE,
    pnVERSION_NBR in out P_BASE.tnTXTT_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnTXTT_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsTXTT_ACTIVE_FLAG := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnTXTT_VERSION_NBR;
    xTXTT_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_TEXT_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnDISPLAY_SEQ) || '~' ||
        psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xTXTT_ROWID
    from T_TEXT_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psDescription is not null
      then P_TEXT.SET_TEXT(nITM_ID, 'TXTT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update T_TEXT_TYPES
      set DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xTXTT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Text type has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end UPDATE_TEXT_TYPE;
--
-- ----------------------------------------
-- SET_TEXT_TYPE
-- ----------------------------------------
--
  procedure SET_TEXT_TYPE
   (psCODE in P_BASE.tmsTXTT_CODE,
    pnVERSION_NBR in out P_BASE.tnTXTT_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnTXTT_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsTXTT_ACTIVE_FLAG := null)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_TEXT_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnDISPLAY_SEQ) || '~' ||
        psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    if pnVERSION_NBR is null
    then
      INSERT_TEXT_TYPE(psCODE, psLANG_CODE, psDescription,
                       case when pnDISPLAY_SEQ = -1e6 then null else pnDISPLAY_SEQ end,
                       nvl(psACTIVE_FLAG, 'Y'));
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_TEXT_TYPE(psCODE, pnVERSION_NBR, psLANG_CODE, psDescription,
                       pnDISPLAY_SEQ, psACTIVE_FLAG);
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_TEXT_TYPE;
--
-- ----------------------------------------
-- DELETE_TEXT_TYPE
-- ----------------------------------------
--
  procedure DELETE_TEXT_TYPE
   (psCODE in P_BASE.tmsTXTT_CODE,
    pnVERSION_NBR in P_BASE.tnTXTT_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnTXTT_VERSION_NBR;
    xTXTT_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_TEXT_TYPE', psCODE || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xTXTT_ROWID
    from T_TEXT_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_TEXT_TYPES where rowid = xTXTT_ROWID;
    --
      P_TEXT.DELETE_TEXT(nITM_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Text type has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_TEXT_TYPE;
--
-- ----------------------------------------
-- SET_TXTT_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_TXTT_DESCRIPTION
   (psCODE in P_BASE.tmsTXTT_CODE,
    pnVERSION_NBR in out P_BASE.tnTXTT_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_TXTT_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_TXTT_TEXT(psCODE, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_TXTT_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_TXTT_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_TXTT_DESCRIPTION
   (psCODE in P_BASE.tmsTXTT_CODE,
    pnVERSION_NBR in out P_BASE.tnTXTT_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_TXTT_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_TXTT_TEXT(psCODE, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_TXTT_DESCRIPTION;
--
-- ----------------------------------------
-- SET_TXTT_TEXT
-- ----------------------------------------
--
  procedure SET_TXTT_TEXT
   (psCODE in P_BASE.tmsTXTT_CODE,
    pnVERSION_NBR in out P_BASE.tnTXTT_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnTXTT_VERSION_NBR;
    xTXTT_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_TXTT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' || to_char(pnSEQ_NBR) ||
        '~' || psLANG_CODE || '~' || to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xTXTT_ROWID
    from T_TEXT_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'TXTT', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_TEXT_TYPES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xTXTT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Text type has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_TXTT_TEXT;
--
-- ----------------------------------------
-- REMOVE_TXTT_TEXT
-- ----------------------------------------
--
  procedure REMOVE_TXTT_TEXT
   (psCODE in P_BASE.tmsTXTT_CODE,
    pnVERSION_NBR in out P_BASE.tnTXTT_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnTXTT_VERSION_NBR;
    xTXTT_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_TXTT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xTXTT_ROWID
    from T_TEXT_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_TEXT_TYPES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xTXTT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Text type has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_TXTT_TEXT;
--
-- ----------------------------------------
-- INSERT_TEXT_TYPE_PROPERTIES
-- ----------------------------------------
--
  procedure INSERT_TEXT_TYPE_PROPERTIES
   (psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    psTAB_ALIAS in P_BASE.tmsTAB_ALIAS,
    psMANDATORY_FLAG in P_BASE.tmsTTP_MANDATORY_FLAG := 'Y',
    psMULTI_INSTANCE_FLAG in P_BASE.tmsTTP_MULTI_INSTANCE_FLAG := 'N',
    psLONG_TEXT_FLAG in P_BASE.tmsTTP_LONG_TEXT_FLAG := 'N')
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_TEXT_TYPE_PROPERTIES',
      psTXTT_CODE || '~' || psTAB_ALIAS || '~' || psMANDATORY_FLAG || '~' ||
        psMULTI_INSTANCE_FLAG || '~' || psLONG_TEXT_FLAG);
  --
    insert into T_TEXT_TYPE_PROPERTIES
     (TXTT_CODE, TAB_ALIAS, MANDATORY_FLAG, MULTI_INSTANCE_FLAG, LONG_TEXT_FLAG)
    values
     (psTXTT_CODE, psTAB_ALIAS, psMANDATORY_FLAG, psMULTI_INSTANCE_FLAG, psLONG_TEXT_FLAG);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_TEXT_TYPE_PROPERTIES;
--
-- ----------------------------------------
-- UPDATE_TEXT_TYPE_PROPERTIES
-- ----------------------------------------
--
  procedure UPDATE_TEXT_TYPE_PROPERTIES
   (psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    psTAB_ALIAS in P_BASE.tmsTAB_ALIAS,
    pnVERSION_NBR in out P_BASE.tnTTP_VERSION_NBR,
    psMANDATORY_FLAG in P_BASE.tsTTP_MANDATORY_FLAG := null,
    psMULTI_INSTANCE_FLAG in P_BASE.tsTTP_MULTI_INSTANCE_FLAG := null,
    psLONG_TEXT_FLAG in P_BASE.tsTTP_LONG_TEXT_FLAG := null)
  is
    nVERSION_NBR P_BASE.tnTTP_VERSION_NBR;
    xTTP_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_TEXT_TYPE_PROPERTIES',
      psTXTT_CODE || '~' || psTAB_ALIAS || '~' || to_char(pnVERSION_NBR) || '~' ||
        psMANDATORY_FLAG || '~' || psMULTI_INSTANCE_FLAG || '~' || psLONG_TEXT_FLAG);
  --
    select VERSION_NBR, rowid
    into nVERSION_NBR, xTTP_ROWID
    from T_TEXT_TYPE_PROPERTIES
    where TXTT_CODE = psTXTT_CODE
    and TAB_ALIAS = psTAB_ALIAS
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      update T_TEXT_TYPE_PROPERTIES
      set MANDATORY_FLAG = nvl(psMANDATORY_FLAG, MANDATORY_FLAG),
        MULTI_INSTANCE_FLAG = nvl(psMULTI_INSTANCE_FLAG, MULTI_INSTANCE_FLAG),
        LONG_TEXT_FLAG = nvl(psLONG_TEXT_FLAG, LONG_TEXT_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xTTP_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'Text type property has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end UPDATE_TEXT_TYPE_PROPERTIES;
--
-- ----------------------------------------
-- SET_TEXT_TYPE_PROPERTIES
-- ----------------------------------------
--
  procedure SET_TEXT_TYPE_PROPERTIES
   (psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    psTAB_ALIAS in P_BASE.tmsTAB_ALIAS,
    pnVERSION_NBR in out P_BASE.tnTTP_VERSION_NBR,
    psMANDATORY_FLAG in P_BASE.tsTTP_MANDATORY_FLAG := null,
    psMULTI_INSTANCE_FLAG in P_BASE.tsTTP_MULTI_INSTANCE_FLAG := null,
    psLONG_TEXT_FLAG in P_BASE.tsTTP_LONG_TEXT_FLAG := null)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_TEXT_TYPE_PROPERTIES',
      psTXTT_CODE || '~' || psTAB_ALIAS || '~' || to_char(pnVERSION_NBR) || '~' ||
        psMANDATORY_FLAG || '~' || psMULTI_INSTANCE_FLAG || '~' || psLONG_TEXT_FLAG);
  --
    if pnVERSION_NBR is null
    then
      INSERT_TEXT_TYPE_PROPERTIES
       (psTXTT_CODE, psTAB_ALIAS, psMANDATORY_FLAG, psMULTI_INSTANCE_FLAG, psLONG_TEXT_FLAG);
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_TEXT_TYPE_PROPERTIES
       (psTXTT_CODE, psTAB_ALIAS, pnVERSION_NBR,
        psMANDATORY_FLAG, psMULTI_INSTANCE_FLAG, psLONG_TEXT_FLAG);
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_TEXT_TYPE_PROPERTIES;
--
-- ----------------------------------------
-- DELETE_TEXT_TYPE_PROPERTIES
-- ----------------------------------------
--
  procedure DELETE_TEXT_TYPE_PROPERTIES
   (psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    psTAB_ALIAS in P_BASE.tmsTAB_ALIAS,
    pnVERSION_NBR in P_BASE.tnTTP_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnTTP_VERSION_NBR;
    xTTP_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_TEXT_TYPE_PROPERTIES',
      psTXTT_CODE || '~' || psTAB_ALIAS || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xTTP_ROWID
    from T_TEXT_TYPE_PROPERTIES
    where TXTT_CODE = psTXTT_CODE
    and TAB_ALIAS = psTAB_ALIAS
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_TEXT_TYPE_PROPERTIES where rowid = xTTP_ROWID;
    --
      if nITM_ID is not null
      then P_TEXT.DELETE_TEXT(nITM_ID);
      end if;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'Text type property has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_TEXT_TYPE_PROPERTIES;
--
-- ----------------------------------------
-- SET_TTP_TEXT
-- ----------------------------------------
--
  procedure SET_TTP_TEXT
   (psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    psTAB_ALIAS in P_BASE.tmsTAB_ALIAS,
    pnVERSION_NBR in out P_BASE.tnTTP_VERSION_NBR,
    psTXTT_CODE_TEXT in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnTTP_VERSION_NBR;
    xTTP_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_TTP_TEXT',
      psTXTT_CODE || '~' || psTAB_ALIAS || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE_TEXT || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xTTP_ROWID
    from T_TEXT_TYPE_PROPERTIES
    where TXTT_CODE = psTXTT_CODE
    and TAB_ALIAS = psTAB_ALIAS
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'TTP', psTXTT_CODE_TEXT, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_TEXT_TYPE_PROPERTIES
      set ITM_ID = nITM_ID,
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xTTP_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'Text type property has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_TTP_TEXT;
--
-- ----------------------------------------
-- REMOVE_TTP_TEXT
-- ----------------------------------------
--
  procedure REMOVE_TTP_TEXT
   (psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    psTAB_ALIAS in P_BASE.tmsTAB_ALIAS,
    pnVERSION_NBR in out P_BASE.tnTTP_VERSION_NBR,
    psTXTT_CODE_TEXT in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnTTP_VERSION_NBR;
    xTTP_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_TTP_TEXT',
      psTXTT_CODE || '~' || psTAB_ALIAS || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE_TEXT || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xTTP_ROWID
    from T_TEXT_TYPE_PROPERTIES
    where TXTT_CODE = psTXTT_CODE
    and TAB_ALIAS = psTAB_ALIAS
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE_TEXT, pnSEQ_NBR, psLANG_CODE);
    --
      update T_TEXT_TYPE_PROPERTIES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xTTP_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'Text type property has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_TTP_TEXT;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sComponent != 'TTP'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'Component code mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
end P_TEXT_TYPE;
/

show errors
