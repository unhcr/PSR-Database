create or replace package body P_ROLE is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- INSERT_ROLE
-- ----------------------------------------
--
  procedure INSERT_ROLE
   (pnID out P_BASE.tnROL_ID,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText,
    psCOUNTRY_FLAG in P_BASE.tmsROL_COUNTRY_FLAG := 'N',
    pnDISPLAY_SEQ in P_BASE.tnROL_DISPLAY_SEQ := null,
    psACTIVE_FLAG in P_BASE.tmsROL_ACTIVE_FLAG := 'Y')
  is
    nITM_ID P_BASE.tnITM_ID;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_ROLE',
      '~' || psCOUNTRY_FLAG || '~' || to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_TEXT.SET_TEXT(nITM_ID, 'ROL', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into T_ROLES
     (ID, COUNTRY_FLAG, DISPLAY_SEQ, ACTIVE_FLAG, ITM_ID)
    values
     (ROL_SEQ.nextval, psCOUNTRY_FLAG, pnDISPLAY_SEQ, psACTIVE_FLAG, nITM_ID)
    returning ID into pnID;
  --
    P_UTILITY.TRACE_CONTEXT
     (to_char(pnID) || '~' || psCOUNTRY_FLAG || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_ROLE;
--
-- ----------------------------------------
-- UPDATE_ROLE
-- ----------------------------------------
--
  procedure UPDATE_ROLE
   (pnID in P_BASE.tmnROL_ID,
    pnVERSION_NBR in out P_BASE.tnROL_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnROL_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsROL_ACTIVE_FLAG := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnROL_VERSION_NBR;
    xROL_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_ROLE',
      to_char(pnID) || '~' || to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xROL_ROWID
    from T_ROLES
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psDescription is not null
      then P_TEXT.SET_TEXT(nITM_ID, 'ROL', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update T_ROLES
      set DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xROL_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Role has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end UPDATE_ROLE;
--
-- ----------------------------------------
-- SET_ROLE
-- ----------------------------------------
--
  procedure SET_ROLE
   (pnID in out P_BASE.tnROL_ID,
    pnVERSION_NBR in out P_BASE.tnROL_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    psCOUNTRY_FLAG in P_BASE.tsROL_COUNTRY_FLAG := null,
    pnDISPLAY_SEQ in P_BASE.tnROL_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsROL_ACTIVE_FLAG := null)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_ROLE',
      to_char(pnID) || '~' || psCOUNTRY_FLAG || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    if pnVERSION_NBR is null
    then
      INSERT_ROLE
       (pnID, psLANG_CODE, psDescription, nvl(psCOUNTRY_FLAG, 'N'),
        case when pnDISPLAY_SEQ = -1e6 then null else pnDISPLAY_SEQ end,
        nvl(psACTIVE_FLAG, 'Y'));
    --
      pnVERSION_NBR := 1;
    else
      if psCOUNTRY_FLAG is not null
      then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'The country orientation of a role cannot be updated');
      else
        UPDATE_ROLE(pnID, pnVERSION_NBR, psLANG_CODE, psDescription, pnDISPLAY_SEQ, psACTIVE_FLAG);
      end if;
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_ROLE;
--
-- ----------------------------------------
-- DELETE_ROLE
-- ----------------------------------------
--
  procedure DELETE_ROLE
   (pnID in P_BASE.tmnROL_ID,
    pnVERSION_NBR in P_BASE.tnROL_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnROL_VERSION_NBR;
    xROL_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_ROLE',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xROL_ROWID
    from T_ROLES
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_ROLES where rowid = xROL_ROWID;
    --
      P_TEXT.DELETE_TEXT(nITM_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Role has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_ROLE;
--
-- ----------------------------------------
-- SET_ROL_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_ROL_DESCRIPTION
   (pnID in P_BASE.tmnROL_ID,
    pnVERSION_NBR in out P_BASE.tnROL_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_ROL_DESCRIPTION',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_ROL_TEXT(pnID, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_ROL_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_ROL_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_ROL_DESCRIPTION
   (pnID in P_BASE.tmnROL_ID,
    pnVERSION_NBR in out P_BASE.tnROL_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_ROL_DESCRIPTION',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_ROL_TEXT(pnID, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_ROL_DESCRIPTION;
--
-- ----------------------------------------
-- SET_ROL_TEXT
-- ----------------------------------------
--
  procedure SET_ROL_TEXT
   (pnID in P_BASE.tmnROL_ID,
    pnVERSION_NBR in out P_BASE.tnROL_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnROL_VERSION_NBR;
    xROL_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_ROL_TEXT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' ||
        psLANG_CODE || '~' || to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xROL_ROWID
    from T_ROLES
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'ROL', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_ROLES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xROL_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Role has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_ROL_TEXT;
--
-- ----------------------------------------
-- REMOVE_ROL_TEXT
-- ----------------------------------------
--
  procedure REMOVE_ROL_TEXT
   (pnID in P_BASE.tmnROL_ID,
    pnVERSION_NBR in out P_BASE.tnROL_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnROL_VERSION_NBR;
    xROL_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_ROL_TEXT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xROL_ROWID
    from T_ROLES
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_ROLES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xROL_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Role has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_ROL_TEXT;
--
-- ----------------------------------------
-- INSERT_ROLE_COUNTRY
-- ----------------------------------------
--
  procedure INSERT_ROLE_COUNTRY
   (pnROL_ID in P_BASE.tmnROL_ID,
    pnLOC_ID in P_BASE.tmnLOC_ID)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_ROLE_COUNTRY',
      to_char(pnROL_ID) || '~' || to_char(pnLOC_ID));
  --
  -- Check that specified location is a country.
  --
    declare
      sDummy varchar2(1);
    begin
      select 'x' into sDummy from T_LOCATIONS where ID = pnLOC_ID and LOCT_CODE = 'COUNTRY';
    exception
      when NO_DATA_FOUND
      then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 3, 'Location must be a country');
    end;
  --
    insert into T_ROLE_COUNTRIES (ROL_ID, LOC_ID) values (pnROL_ID, pnLOC_ID);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_ROLE_COUNTRY;
--
-- ----------------------------------------
-- DELETE_ROLE_COUNTRY
-- ----------------------------------------
--
  procedure DELETE_ROLE_COUNTRY
   (pnROL_ID in P_BASE.tmnROL_ID,
    pnLOC_ID in P_BASE.tmnLOC_ID)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_ROLE_COUNTRY',
      to_char(pnROL_ID) || '~' || to_char(pnLOC_ID));
  --
    delete from T_ROLE_COUNTRIES where ROL_ID = pnROL_ID and LOC_ID = pnLOC_ID;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_ROLE_COUNTRY;
--
-- ----------------------------------------
-- INSERT_PERMISSION
-- ----------------------------------------
--
  procedure INSERT_PERMISSION
   (pnID out P_BASE.tnPRM_ID,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText,
    psWRITE_FLAG in P_BASE.tmsPRM_WRITE_FLAG := 'Y',
    psANNOTATE_FLAG in P_BASE.tmsPRM_ANNOTATE_FLAG := 'Y',
    pnDISPLAY_SEQ in P_BASE.tnPRM_DISPLAY_SEQ := null,
    psACTIVE_FLAG in P_BASE.tmsPRM_ACTIVE_FLAG := 'Y')
  is
    nITM_ID P_BASE.tnITM_ID;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_PERMISSION',
      '~' || psWRITE_FLAG || '~' || psANNOTATE_FLAG || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_TEXT.SET_TEXT(nITM_ID, 'PRM', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into T_PERMISSIONS
     (ID, WRITE_FLAG, ANNOTATE_FLAG, DISPLAY_SEQ, ACTIVE_FLAG, ITM_ID)
    values
     (PRM_SEQ.nextval, psWRITE_FLAG, psANNOTATE_FLAG, pnDISPLAY_SEQ, psACTIVE_FLAG, nITM_ID)
    returning ID into pnID;
  --
    P_UTILITY.TRACE_CONTEXT
     (to_char(pnID) || '~' || psWRITE_FLAG || '~' || psANNOTATE_FLAG || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_PERMISSION;
--
-- ----------------------------------------
-- UPDATE_PERMISSION
-- ----------------------------------------
--
  procedure UPDATE_PERMISSION
   (pnID in P_BASE.tmnPRM_ID,
    pnVERSION_NBR in out P_BASE.tnPRM_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    psWRITE_FLAG in P_BASE.tsPRM_WRITE_FLAG := null,
    psANNOTATE_FLAG in P_BASE.tsPRM_ANNOTATE_FLAG := null,
    pnDISPLAY_SEQ in P_BASE.tnPRM_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsPRM_ACTIVE_FLAG := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPRM_VERSION_NBR;
    xPRM_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_PERMISSION',
      to_char(pnID) || '~' || psWRITE_FLAG || '~' || psANNOTATE_FLAG || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xPRM_ROWID
    from T_PERMISSIONS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psDescription is not null
      then P_TEXT.SET_TEXT(nITM_ID, 'PRM', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update T_PERMISSIONS
      set WRITE_FLAG = nvl(psWRITE_FLAG, WRITE_FLAG),
        ANNOTATE_FLAG = nvl(psANNOTATE_FLAG, ANNOTATE_FLAG),
        DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xPRM_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 4, 'Permission has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end UPDATE_PERMISSION;
--
-- ----------------------------------------
-- SET_PERMISSION
-- ----------------------------------------
--
  procedure SET_PERMISSION
   (pnID in out P_BASE.tnPRM_ID,
    pnVERSION_NBR in out P_BASE.tnPRM_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    psWRITE_FLAG in P_BASE.tsPRM_WRITE_FLAG := null,
    psANNOTATE_FLAG in P_BASE.tsPRM_ANNOTATE_FLAG := null,
    pnDISPLAY_SEQ in P_BASE.tnPRM_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsPRM_ACTIVE_FLAG := null)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_PERMISSION',
      to_char(pnID) || '~' || psWRITE_FLAG || '~' || psANNOTATE_FLAG || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    if pnVERSION_NBR is null
    then
      INSERT_PERMISSION
       (pnID, psLANG_CODE, psDescription, nvl(psWRITE_FLAG, 'Y'), nvl(psANNOTATE_FLAG, 'Y'),
        case when pnDISPLAY_SEQ = -1e6 then null else pnDISPLAY_SEQ end,
        nvl(psACTIVE_FLAG, 'Y'));
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_PERMISSION
       (pnID, pnVERSION_NBR, psLANG_CODE, psDescription, psWRITE_FLAG, psANNOTATE_FLAG,
        pnDISPLAY_SEQ, psACTIVE_FLAG);
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_PERMISSION;
--
-- ----------------------------------------
-- DELETE_PERMISSION
-- ----------------------------------------
--
  procedure DELETE_PERMISSION
   (pnID in P_BASE.tmnPRM_ID,
    pnVERSION_NBR in P_BASE.tnPRM_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPRM_VERSION_NBR;
    xPRM_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_PERMISSION',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xPRM_ROWID
    from T_PERMISSIONS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_PERMISSIONS where rowid = xPRM_ROWID;
    --
      P_TEXT.DELETE_TEXT(nITM_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 4, 'Permission has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_PERMISSION;
--
-- ----------------------------------------
-- SET_PRM_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_PRM_DESCRIPTION
   (pnID in P_BASE.tmnPRM_ID,
    pnVERSION_NBR in out P_BASE.tnPRM_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_PRM_DESCRIPTION',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_PRM_TEXT(pnID, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_PRM_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_PRM_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_PRM_DESCRIPTION
   (pnID in P_BASE.tmnPRM_ID,
    pnVERSION_NBR in out P_BASE.tnPRM_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_PRM_DESCRIPTION',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_PRM_TEXT(pnID, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_PRM_DESCRIPTION;
--
-- ----------------------------------------
-- SET_PRM_TEXT
-- ----------------------------------------
--
  procedure SET_PRM_TEXT
   (pnID in P_BASE.tmnPRM_ID,
    pnVERSION_NBR in out P_BASE.tnPRM_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPRM_VERSION_NBR;
    xPRM_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_PRM_TEXT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' ||
        psLANG_CODE || '~' || to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xPRM_ROWID
    from T_PERMISSIONS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'PRM', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_PERMISSIONS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xPRM_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 4, 'Permission has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_PRM_TEXT;
--
-- ----------------------------------------
-- REMOVE_PRM_TEXT
-- ----------------------------------------
--
  procedure REMOVE_PRM_TEXT
   (pnID in P_BASE.tmnPRM_ID,
    pnVERSION_NBR in out P_BASE.tnPRM_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPRM_VERSION_NBR;
    xPRM_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_PRM_TEXT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xPRM_ROWID
    from T_PERMISSIONS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_PERMISSIONS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xPRM_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 4, 'Permission has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_PRM_TEXT;
--
-- ----------------------------------------
-- INSERT_PERMISSION_IN_ROLE
-- ----------------------------------------
--
  procedure INSERT_PERMISSION_IN_ROLE
   (pnPRM_ID in P_BASE.tmnPRM_ID,
    pnROL_ID in P_BASE.tmnROL_ID)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_PERMISSION_IN_ROLE',
      to_char(pnPRM_ID) || '~' || to_char(pnROL_ID));
  --
    insert into T_PERMISSIONS_IN_ROLES (PRM_ID, ROL_ID) values (pnPRM_ID, pnROL_ID);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_PERMISSION_IN_ROLE;
--
-- ----------------------------------------
-- DELETE_PERMISSION_IN_ROLE
-- ----------------------------------------
--
  procedure DELETE_PERMISSION_IN_ROLE
   (pnPRM_ID in P_BASE.tmnPRM_ID,
    pnROL_ID in P_BASE.tmnROL_ID)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_PERMISSION_IN_ROLE',
      to_char(pnPRM_ID) || '~' || to_char(pnROL_ID));
  --
    delete from T_PERMISSIONS_IN_ROLES where PRM_ID = pnPRM_ID and ROL_ID = pnROL_ID;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_PERMISSION_IN_ROLE;
--
-- ----------------------------------------
-- INSERT_DATA_ITEM_PERMISSION
-- ----------------------------------------
--
  procedure INSERT_DATA_ITEM_PERMISSION
   (pnITM_ID in P_BASE.tmnITM_ID,
    pnPRM_ID in P_BASE.tmnPRM_ID)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_DATA_ITEM_PERMISSION',
      to_char(pnITM_ID) || '~' || to_char(pnPRM_ID));
  --
    insert into T_DATA_ITEM_PERMISSIONS (ITM_ID, PRM_ID) values (pnITM_ID, pnPRM_ID);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_DATA_ITEM_PERMISSION;
--
-- ----------------------------------------
-- DELETE_DATA_ITEM_PERMISSION
-- ----------------------------------------
--
  procedure DELETE_DATA_ITEM_PERMISSION
   (pnITM_ID in P_BASE.tmnITM_ID,
    pnPRM_ID in P_BASE.tmnPRM_ID)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_DATA_ITEM_PERMISSION',
      to_char(pnITM_ID) || '~' || to_char(pnPRM_ID));
  --
    delete from T_DATA_ITEM_PERMISSIONS where ITM_ID = pnITM_ID and PRM_ID = pnPRM_ID;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_DATA_ITEM_PERMISSION;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sComponent != 'ROL'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'Component code mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
end P_ROLE;
/

show errors
