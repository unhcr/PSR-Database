create or replace package body P_POPULATION_PLANNING_GROUP is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- INSERT_PPG
-- ----------------------------------------
--
  procedure INSERT_PPG
   (pnID out P_BASE.tnPPG_ID,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText,
    pnLOC_ID in P_BASE.tmnLOC_ID,
    psPPG_CODE in P_BASE.tmsPPG_CODE,
    pdSTART_DATE in P_BASE.tdDate := null,
    pdEND_DATE in P_BASE.tdDate := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.INSERT_PPG',
      to_char(pnLOC_ID) || '~' || psPPG_CODE || '~' ||
        to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
  -- Check that the associated location is active for the whole of the given effective date range.
  --
    declare
      sDummy varchar2(1);
    begin
      select 'x'
      into sDummy
      from T_LOCATIONS
      where ID = pnLOC_ID
      and START_DATE <= nvl(pdSTART_DATE, P_BASE.gdMIN_DATE)
      and END_DATE >= nvl(pdEND_DATE, P_BASE.gdMAX_DATE);
    end;
  --
  -- Check for an existing PPG with the same code and overlapping effective date range.
  --
    declare
      sDummy varchar2(1);
    begin
      select 'x'
      into sDummy
      from T_POPULATION_PLANNING_GROUPS
      where PPG_CODE = psPPG_CODE
      and START_DATE < nvl(pdEND_DATE, P_BASE.gdMAX_DATE)
      and END_DATE > nvl(pdSTART_DATE, P_BASE.gdMIN_DATE);
    --
      raise TOO_MANY_ROWS;
    exception
      when NO_DATA_FOUND then null;
    --
      when TOO_MANY_ROWS
      then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'PPG with overlapping dates already exists');
    end;
  --
    P_TEXT.SET_TEXT(nITM_ID, 'PPG', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into T_POPULATION_PLANNING_GROUPS
     (ID, LOC_ID, PPG_CODE,
      START_DATE, END_DATE, ITM_ID)
    values
     (PPG_SEQ.nextval, pnLOC_ID, psPPG_CODE,
      nvl(pdSTART_DATE, P_BASE.gdMIN_DATE), nvl(pdEND_DATE, P_BASE.gdMAX_DATE), nITM_ID)
    returning ID into pnID;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_PPG;
--
-- ----------------------------------------
-- UPDATE_PPG
-- ----------------------------------------
--
  procedure UPDATE_PPG
   (pnID in P_BASE.tmnPPG_ID,
    pnVERSION_NBR in out P_BASE.tnPPG_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnLOC_ID in P_BASE.tnLOC_ID := null,
    psPPG_CODE in P_BASE.tsPPG_CODE := null,
    pdSTART_DATE in P_BASE.tdDate := P_BASE.gdFALSE_DATE,
    pdEND_DATE in P_BASE.tdDate := P_BASE.gdFALSE_DATE)
  is
    nLOC_ID P_BASE.tnLOC_ID;
    sPPG_CODE P_BASE.tsPPG_CODE;
    dSTART_DATE P_BASE.tdDate;
    dEND_DATE P_BASE.tdDate;
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPPG_VERSION_NBR;
    xPPG_ROWID rowid;
    dSTART_DATE_NEW P_BASE.tdDate;
    dEND_DATE_NEW P_BASE.tdDate;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.UPDATE_PPG',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||to_char(pnLOC_ID) || '~' ||
        psPPG_CODE || '~' || to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    select LOC_ID, PPG_CODE, START_DATE, END_DATE, ITM_ID, VERSION_NBR, rowid
    into nLOC_ID, sPPG_CODE, dSTART_DATE, dEND_DATE, nITM_ID, nVERSION_NBR, xPPG_ROWID
    from T_POPULATION_PLANNING_GROUPS
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
    -- If associated location or dates are being changed, check that the location is active for the
    --   whole of the effective date range.
    --
      if pnLOC_ID != nLOC_ID or dSTART_DATE_NEW != dSTART_DATE or dEND_DATE_NEW != dEND_DATE
      then
        declare
          sDummy varchar2(1);
        begin
          select 'x'
          into sDummy
          from T_LOCATIONS
          where ID = pnLOC_ID
          and START_DATE < dSTART_DATE_NEW
          and END_DATE > dEND_DATE_NEW;
        end;
      end if;
    --
    -- If dates are being changed, check for PPG with the same code and overlapping effective dates.
    --
      if dSTART_DATE_NEW != dSTART_DATE or dEND_DATE_NEW != dEND_DATE
      then
        declare
          sDummy varchar2(1);
        begin
          select 'x'
          into sDummy
          from T_POPULATION_PLANNING_GROUPS
          where PPG_CODE = psPPG_CODE
          and START_DATE < dEND_DATE_NEW
          and END_DATE > dSTART_DATE_NEW
          and ID != pnID;
        --
          raise TOO_MANY_ROWS;
        exception
          when NO_DATA_FOUND then null;
        --
          when TOO_MANY_ROWS
          then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'PPG with overlapping dates already exists');
        end;
      end if;
    --
      if psDescription is not null
      then P_TEXT.SET_TEXT(nITM_ID, 'PPG', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update T_POPULATION_PLANNING_GROUPS
      set LOC_ID = nvl(pnLOC_ID, LOC_ID),
        PPG_CODE = nvl(psPPG_CODE, PPG_CODE),
        START_DATE = dSTART_DATE_NEW,
        END_DATE = dEND_DATE_NEW,
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xPPG_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'PPG has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end UPDATE_PPG;
--
-- ----------------------------------------
-- SET_PPG
-- ----------------------------------------
--
  procedure SET_PPG
   (pnID in out P_BASE.tnPPG_ID,
    pnVERSION_NBR in out P_BASE.tnPPG_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnLOC_ID in P_BASE.tnLOC_ID := null,
    psPPG_CODE in P_BASE.tsPPG_CODE := null,
    pdSTART_DATE in P_BASE.tdDate := P_BASE.gdFALSE_DATE,
    pdEND_DATE in P_BASE.tdDate := P_BASE.gdFALSE_DATE)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_LOCATION',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||to_char(pnLOC_ID) || '~' ||
        psPPG_CODE || '~' || to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    if pnVERSION_NBR is null
    then
      INSERT_PPG(pnID, psLANG_CODE, psDescription, pnLOC_ID, psPPG_CODE,
                 case when pdSTART_DATE = P_BASE.gdFALSE_DATE then null else pdSTART_DATE end,
                 case when pdEND_DATE = P_BASE.gdFALSE_DATE then null else pdEND_DATE end);
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_PPG(pnID, pnVERSION_NBR, psLANG_CODE, psDescription, pnLOC_ID, psPPG_CODE,
                 pdSTART_DATE, pdEND_DATE);
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_PPG;
--
-- ----------------------------------------
-- DELETE_PPG
-- ----------------------------------------
--
  procedure DELETE_PPG
   (pnID in P_BASE.tmnPPG_ID,
    pnVERSION_NBR in P_BASE.tnPPG_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPPG_VERSION_NBR;
    xPPG_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.DELETE_SYSTEM_PARAMETER',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xPPG_ROWID
    from T_POPULATION_PLANNING_GROUPS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_POPULATION_PLANNING_GROUPS where rowid = xPPG_ROWID;
    --
      P_TEXT.DELETE_TEXT(nITM_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'PPG has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_PPG;
--
-- ----------------------------------------
-- SET_PPG_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_PPG_DESCRIPTION
   (pnID in P_BASE.tmnPPG_ID,
    pnVERSION_NBR in out P_BASE.tnPPG_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_PPG_DESCRIPTION',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_PPG_TEXT(pnID, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_PPG_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_PPG_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_PPG_DESCRIPTION
   (pnID in P_BASE.tmnPPG_ID,
    pnVERSION_NBR in out P_BASE.tnPPG_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.REMOVE_PPG_DESCRIPTION',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psLANG_CODE);
  --
    REMOVE_PPG_TEXT(pnID, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_PPG_DESCRIPTION;
--
-- ----------------------------------------
-- SET_PPG_TEXT
-- ----------------------------------------
--
  procedure SET_PPG_TEXT
   (pnID in P_BASE.tmnPPG_ID,
    pnVERSION_NBR in out P_BASE.tnPPG_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPPG_VERSION_NBR;
    xPPG_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_PPG_TEXT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xPPG_ROWID
    from T_POPULATION_PLANNING_GROUPS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'PPG', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_POPULATION_PLANNING_GROUPS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xPPG_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'PPG has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_PPG_TEXT;
--
-- ----------------------------------------
-- REMOVE_PPG_TEXT
-- ----------------------------------------
--
  procedure REMOVE_PPG_TEXT
   (pnID in P_BASE.tmnPPG_ID,
    pnVERSION_NBR in out P_BASE.tnPPG_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPPG_VERSION_NBR;
    xPPG_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.REMOVE_PPG_TEXT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xPPG_ROWID
    from T_POPULATION_PLANNING_GROUPS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_POPULATION_PLANNING_GROUPS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xPPG_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'PPG has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_PPG_TEXT;
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
  if sComponent != 'PPG'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 3, 'Component code mismatch');
  end if;
--
end P_POPULATION_PLANNING_GROUP;
/

show errors
