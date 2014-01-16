create or replace package body P_STATISTIC_GROUP is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- INSERT_STATISTIC_GROUP
-- ----------------------------------------
--
  procedure INSERT_STATISTIC_GROUP
   (pnSTG_ID out P_BASE.tnSTG_ID,
    pdSTART_DATE in P_BASE.tmdDate,
    pdEND_DATE in P_BASE.tmdDate,
    psSTTG_CODE in P_BASE.tsSTTG_CODE := null,
    pnDST_ID in P_BASE.tnDST_ID := null,
    pnLOC_ID_ASYLUM_COUNTRY in P_BASE.tnLOC_ID := null,
    pnLOC_ID_ASYLUM in P_BASE.tnLOC_ID := null,
    pnLOC_ID_ORIGIN_COUNTRY in P_BASE.tnLOC_ID := null,
    pnLOC_ID_ORIGIN in P_BASE.tnLOC_ID := null,
    pnDIM_ID1 in P_BASE.tnDIM_ID := null,
    pnDIM_ID2 in P_BASE.tnDIM_ID := null,
    pnDIM_ID3 in P_BASE.tnDIM_ID := null,
    pnDIM_ID4 in P_BASE.tnDIM_ID := null,
    pnDIM_ID5 in P_BASE.tnDIM_ID := null,
    psSEX_CODE in P_BASE.tsSEX_CODE := null,
    pnAGR_ID in P_BASE.tnAGR_ID := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psSUBGROUP_NAME in P_BASE.tsText := null,
    pnPPG_ID in P_BASE.tnPPG_ID := null)
  is
    nSTG_SEQ_NBR_MAX P_BASE.tnSTG_SEQ_NBR := null;
    nITM_ID P_BASE.tnITM_ID := null;
    nTXT_SEQ_NBR P_BASE.tnTXT_SEQ_NBR := null;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_STATISTIC_GROUP',
      to_char(pdSTART_DATE, 'YYYY-MM-DD')  || '~' || to_char(pdEND_DATE, 'YYYY-MM-DD') || '~' ||
        to_char(pnDST_ID) || '~' || psSTTG_CODE || '~' ||
        to_char(pnLOC_ID_ASYLUM_COUNTRY) || '~' || to_char(pnLOC_ID_ASYLUM) || '~' ||
        to_char(pnLOC_ID_ORIGIN_COUNTRY) || '~' || to_char(pnLOC_ID_ORIGIN) || '~' ||
        to_char(pnDIM_ID1) || '~' || to_char(pnDIM_ID2) || '~' || to_char(pnDIM_ID3) || '~' ||
        to_char(pnDIM_ID4) || '~' || to_char(pnDIM_ID5) || '~' || psSEX_CODE || '~' ||
        to_char(pnAGR_ID) || '~' || to_char(pnPPG_ID) || '~' ||
        psLANG_CODE || '~' || to_char(length(psSUBGROUP_NAME)) || ':' || psSUBGROUP_NAME);
  --
    if psSUBGROUP_NAME is not null
    then
      select nvl(max(SEQ_NBR), 0) + 1
      into nSTG_SEQ_NBR_MAX
      from T_STATISTIC_GROUPS
      where START_DATE = pdSTART_DATE
      and END_DATE = pdEND_DATE
      and nvl(STTG_CODE, 'x') = nvl(psSTTG_CODE, 'x')
      and nvl(DST_ID, 0) = nvl(pnDST_ID, 0)
      and nvl(LOC_ID_ASYLUM_COUNTRY, 0) = nvl(pnLOC_ID_ASYLUM_COUNTRY, 0)
      and nvl(LOC_ID_ASYLUM, 0) = nvl(pnLOC_ID_ASYLUM, 0)
      and nvl(LOC_ID_ORIGIN_COUNTRY, 0) = nvl(pnLOC_ID_ORIGIN_COUNTRY, 0)
      and nvl(LOC_ID_ORIGIN, 0) = nvl(pnLOC_ID_ORIGIN, 0)
      and nvl(DIM_ID1, 0) = nvl(pnDIM_ID1, 0)
      and nvl(DIM_ID2, 0) = nvl(pnDIM_ID2, 0)
      and nvl(DIM_ID3, 0) = nvl(pnDIM_ID3, 0)
      and nvl(DIM_ID4, 0) = nvl(pnDIM_ID4, 0)
      and nvl(DIM_ID5, 0) = nvl(pnDIM_ID5, 0)
      and nvl(SEX_CODE, 'x') = nvl(psSEX_CODE, 'x')
      and nvl(AGR_ID, 0) = nvl(pnAGR_ID, 0);
    --
      P_TEXT.SET_TEXT(nITM_ID, 'STG', 'PSGRNAME', nTXT_SEQ_NBR, psLANG_CODE, psSUBGROUP_NAME);
    end if;
  --
    insert into T_STATISTIC_GROUPS
     (ID, START_DATE, END_DATE, STTG_CODE, DST_ID,
      LOC_ID_ASYLUM_COUNTRY, LOC_ID_ASYLUM, LOC_ID_ORIGIN_COUNTRY, LOC_ID_ORIGIN,
      DIM_ID1, DIM_ID2, DIM_ID3, DIM_ID4, DIM_ID5, SEX_CODE, AGR_ID,
      SEQ_NBR, PPG_ID, ITM_ID)
    values
     (STG_SEQ.nextval, pdSTART_DATE, pdEND_DATE, psSTTG_CODE, pnDST_ID,
      pnLOC_ID_ASYLUM_COUNTRY, pnLOC_ID_ASYLUM, pnLOC_ID_ORIGIN_COUNTRY, pnLOC_ID_ORIGIN,
      pnDIM_ID1, pnDIM_ID2, pnDIM_ID3, pnDIM_ID4, pnDIM_ID5, psSEX_CODE, pnAGR_ID,
      nSTG_SEQ_NBR_MAX, pnPPG_ID, nITM_ID)
    returning ID into pnSTG_ID;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_STATISTIC_GROUP;
--
-- ----------------------------------------
-- UPDATE_STATISTIC_GROUP
-- ----------------------------------------
--
  procedure UPDATE_STATISTIC_GROUP
   (pnSTG_ID in P_BASE.tmnSTG_ID,
    pnVERSION_NBR in out P_BASE.tnSTG_VERSION_NBR,
    pdSTART_DATE in P_BASE.tdDate := P_BASE.gdFALSE_DATE,
    pdEND_DATE in P_BASE.tdDate := P_BASE.gdFALSE_DATE,
    psSTTG_CODE in P_BASE.tsSTTG_CODE := 'xxxxxxxxxxx',
    pnDST_ID in P_BASE.tnDST_ID := -1,
    pnLOC_ID_ASYLUM_COUNTRY in P_BASE.tnLOC_ID := -1,
    pnLOC_ID_ASYLUM in P_BASE.tnLOC_ID := -1,
    pnLOC_ID_ORIGIN_COUNTRY in P_BASE.tnLOC_ID := -1,
    pnLOC_ID_ORIGIN in P_BASE.tnLOC_ID := -1,
    pnDIM_ID1 in P_BASE.tnDIM_ID := -1,
    pnDIM_ID2 in P_BASE.tnDIM_ID := -1,
    pnDIM_ID3 in P_BASE.tnDIM_ID := -1,
    pnDIM_ID4 in P_BASE.tnDIM_ID := -1,
    pnDIM_ID5 in P_BASE.tnDIM_ID := -1,
    psSEX_CODE in P_BASE.tsSEX_CODE := 'x',
    pnAGR_ID in P_BASE.tnAGR_ID := -1,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psSUBGROUP_NAME in P_BASE.tsText := null,
    pnPPG_ID in P_BASE.tnPPG_ID := -1)
  is
    nSTG_SEQ_NBR P_BASE.tnSTG_SEQ_NBR;
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnSTG_VERSION_NBR;
    xSTG_ROWID rowid;
    nTXT_SEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_STATISTIC_GROUP',
      to_char(pnSTG_ID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        to_char(pdSTART_DATE, 'YYYY-MM-DD')  || '~' || to_char(pdEND_DATE, 'YYYY-MM-DD') || '~' ||
        psSTTG_CODE || '~' || to_char(pnDST_ID) || '~' ||
        to_char(pnLOC_ID_ASYLUM_COUNTRY) || '~' || to_char(pnLOC_ID_ASYLUM) || '~' ||
        to_char(pnLOC_ID_ORIGIN_COUNTRY) || '~' || to_char(pnLOC_ID_ORIGIN) || '~' ||
        to_char(pnDIM_ID1) || '~' || to_char(pnDIM_ID2) || '~' || to_char(pnDIM_ID3) || '~' ||
        to_char(pnDIM_ID4) || '~' || to_char(pnDIM_ID5) || '~' ||
        psSEX_CODE || '~' || to_char(pnAGR_ID) || '~' || to_char(pnPPG_ID) || '~' ||
        psLANG_CODE || '~' || to_char(length(psSUBGROUP_NAME)) || ':' || psSUBGROUP_NAME);
  --
    select SEQ_NBR, ITM_ID, VERSION_NBR, rowid
    into nSTG_SEQ_NBR, nITM_ID, nVERSION_NBR, xSTG_ROWID
    from T_STATISTIC_GROUPS
    where ID = pnSTG_ID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psSUBGROUP_NAME is not null
      then
        if nSTG_SEQ_NBR is not null
        then P_TEXT.SET_TEXT(nITM_ID, 'STG', 'PSGRNAME', nTXT_SEQ_NBR, psLANG_CODE, psSUBGROUP_NAME);
        else P_MESSAGE.DISPLAY_MESSAGE(sComponent, 4, 'Statistic group has no population subgroup');
        end if;
      end if;
    --
      update T_STATISTIC_GROUPS
      set START_DATE =
          case when pdSTART_DATE = P_BASE.gdFALSE_DATE then START_DATE else pdSTART_DATE end,
        END_DATE = case when pdEND_DATE = P_BASE.gdFALSE_DATE then END_DATE else pdEND_DATE end,
        STTG_CODE = case when psSTTG_CODE = 'xxxxxxxxxxx' then STTG_CODE else psSTTG_CODE end,
        DST_ID = case when pnDST_ID = -1 then DST_ID else pnDST_ID end,
        LOC_ID_ASYLUM_COUNTRY =
          case
            when pnLOC_ID_ASYLUM_COUNTRY = -1 then LOC_ID_ASYLUM_COUNTRY
            else pnLOC_ID_ASYLUM_COUNTRY
          end,
        LOC_ID_ASYLUM = case when pnLOC_ID_ASYLUM = -1 then LOC_ID_ASYLUM else pnLOC_ID_ASYLUM end,
        LOC_ID_ORIGIN_COUNTRY =
          case
            when pnLOC_ID_ORIGIN_COUNTRY = -1 then LOC_ID_ORIGIN_COUNTRY
            else pnLOC_ID_ORIGIN_COUNTRY
          end,
        LOC_ID_ORIGIN = case when pnLOC_ID_ORIGIN = -1 then LOC_ID_ORIGIN else pnLOC_ID_ORIGIN end,
        DIM_ID1 = case when pnDIM_ID1 = -1 then DIM_ID1 else pnDIM_ID1 end,
        DIM_ID2 = case when pnDIM_ID2 = -1 then DIM_ID2 else pnDIM_ID2 end,
        DIM_ID3 = case when pnDIM_ID3 = -1 then DIM_ID3 else pnDIM_ID3 end,
        DIM_ID4 = case when pnDIM_ID4 = -1 then DIM_ID4 else pnDIM_ID4 end,
        DIM_ID5 = case when pnDIM_ID5 = -1 then DIM_ID5 else pnDIM_ID5 end,
        SEX_CODE = case when psSEX_CODE = 'x' then SEX_CODE else psSEX_CODE end,
        AGR_ID = case when pnAGR_ID = -1 then AGR_ID else pnAGR_ID end,
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xSTG_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Statistic group has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end UPDATE_STATISTIC_GROUP;
--
-- ----------------------------------------
-- SET_STATISTIC_GROUP
-- ----------------------------------------
--
  procedure SET_STATISTIC_GROUP
   (pnSTG_ID in out P_BASE.tnSTG_ID,
    pnVERSION_NBR in out P_BASE.tnSTG_VERSION_NBR,
    pdSTART_DATE in P_BASE.tdDate := null,
    pdEND_DATE in P_BASE.tdDate := null,
    psSTTG_CODE in P_BASE.tsSTTG_CODE := null,
    pnDST_ID in P_BASE.tnDST_ID := null,
    pnLOC_ID_ASYLUM_COUNTRY in P_BASE.tnLOC_ID := null,
    pnLOC_ID_ASYLUM in P_BASE.tnLOC_ID := null,
    pnLOC_ID_ORIGIN_COUNTRY in P_BASE.tnLOC_ID := null,
    pnLOC_ID_ORIGIN in P_BASE.tnLOC_ID := null,
    pnDIM_ID1 in P_BASE.tnDIM_ID := null,
    pnDIM_ID2 in P_BASE.tnDIM_ID := null,
    pnDIM_ID3 in P_BASE.tnDIM_ID := null,
    pnDIM_ID4 in P_BASE.tnDIM_ID := null,
    pnDIM_ID5 in P_BASE.tnDIM_ID := null,
    psSEX_CODE in P_BASE.tsSEX_CODE := null,
    pnAGR_ID in P_BASE.tnAGR_ID := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psSUBGROUP_NAME in P_BASE.tsText := null,
    pnPPG_ID in P_BASE.tnPPG_ID := -1)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_STATISTIC_GROUP',
      to_char(pnSTG_ID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        to_char(pdSTART_DATE, 'YYYY-MM-DD')  || '~' || to_char(pdEND_DATE, 'YYYY-MM-DD')  || '~' ||
        psSTTG_CODE || '~' || to_char(pnDST_ID) || '~' ||
        to_char(pnLOC_ID_ASYLUM_COUNTRY) || '~' || to_char(pnLOC_ID_ASYLUM) || '~' ||
        to_char(pnLOC_ID_ORIGIN_COUNTRY) || '~' || to_char(pnLOC_ID_ORIGIN) || '~' ||
        to_char(pnDIM_ID1) || '~' || to_char(pnDIM_ID2) || '~' || to_char(pnDIM_ID3) || '~' ||
        to_char(pnDIM_ID4) || '~' || to_char(pnDIM_ID5) || '~' ||
        psSEX_CODE || '~' || to_char(pnAGR_ID) || '~' || to_char(pnPPG_ID) || '~' ||
        psLANG_CODE || '~' || to_char(length(psSUBGROUP_NAME)) || ':' || psSUBGROUP_NAME);
  --
    if pnVERSION_NBR is null
    then
      INSERT_STATISTIC_GROUP
       (pnSTG_ID, pdSTART_DATE, pdEND_DATE, psSTTG_CODE, pnDST_ID,
        pnLOC_ID_ASYLUM_COUNTRY, pnLOC_ID_ASYLUM, pnLOC_ID_ORIGIN_COUNTRY, pnLOC_ID_ORIGIN,
        pnDIM_ID1, pnDIM_ID2, pnDIM_ID3, pnDIM_ID4, pnDIM_ID5, psSEX_CODE, pnAGR_ID,
        psLANG_CODE, psSUBGROUP_NAME, pnPPG_ID);
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_STATISTIC_GROUP
       (pnSTG_ID, pnVERSION_NBR,
        nvl(pdSTART_DATE, P_BASE.gdFALSE_DATE), nvl(pdEND_DATE, P_BASE.gdFALSE_DATE),
        nvl(psSTTG_CODE, 'xxxxxxxxxxx'), nvl(pnDST_ID, -1),
        nvl(pnLOC_ID_ASYLUM_COUNTRY, -1), nvl(pnLOC_ID_ASYLUM, -1),
        nvl(pnLOC_ID_ORIGIN_COUNTRY, -1), nvl(pnLOC_ID_ORIGIN, -1),
        nvl(pnDIM_ID1, -1), nvl(pnDIM_ID2, -1), nvl(pnDIM_ID3, -1),
        nvl(pnDIM_ID4, -1), nvl(pnDIM_ID5, -1),
        nvl(psSEX_CODE, 'x'), nvl(pnAGR_ID, -1),
        psLANG_CODE, psSUBGROUP_NAME, pnPPG_ID);
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_STATISTIC_GROUP;
--
-- ----------------------------------------
-- DELETE_STATISTIC_GROUP
-- ----------------------------------------
--
  procedure DELETE_STATISTIC_GROUP
   (pnSTG_ID in P_BASE.tmnSTG_ID,
    pnVERSION_NBR in P_BASE.tnSTG_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnSTG_VERSION_NBR;
    xSTG_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_STATISTIC_GROUP',
      to_char(pnSTG_ID) || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xSTG_ROWID
    from T_STATISTIC_GROUPS
    where ID = pnSTG_ID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_STATISTIC_GROUPS where rowid = xSTG_ROWID;
    --
      if nITM_ID is not null
      then P_TEXT.DELETE_TEXT(nITM_ID);
      end if;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Statistic group has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_STATISTIC_GROUP;
--
-- ----------------------------------------
-- SET_STG_TEXT
-- ----------------------------------------
--
  procedure SET_STG_TEXT
   (pnSTG_ID in P_BASE.tmnSTG_ID,
    pnVERSION_NBR in out P_BASE.tnSTG_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE,
    psText in P_BASE.tsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnSTG_VERSION_NBR;
    xSTG_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_STG_TEXT',
      to_char(pnSTG_ID) || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xSTG_ROWID
    from T_STATISTIC_GROUPS
    where ID = pnSTG_ID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'STG', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_STATISTIC_GROUPS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xSTG_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Statistic group has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_STG_TEXT;
--
-- ----------------------------------------
-- REMOVE_STG_TEXT
-- ----------------------------------------
--
  procedure REMOVE_STG_TEXT
   (pnSTG_ID in P_BASE.tmnSTG_ID,
    pnVERSION_NBR in out P_BASE.tnSTG_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnSTG_VERSION_NBR;
    xSTG_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_STG_TEXT',
      to_char(pnSTG_ID) || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xSTG_ROWID
    from T_STATISTIC_GROUPS
    where ID = pnSTG_ID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_STATISTIC_GROUPS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xSTG_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Statistic group has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_STG_TEXT;
--
-- ----------------------------------------
-- INSERT_STG_ATTRIBUTE_TYPE
-- ----------------------------------------
--
  procedure INSERT_STG_ATTRIBUTE_TYPE
   (psCODE in P_BASE.tmsSTGAT_CODE,
    psDATA_TYPE in P_BASE.tmsSTGAT_DATA_TYPE,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText,
    pnDISPLAY_SEQ in P_BASE.tnSTGAT_DISPLAY_SEQ := null,
    psACTIVE_FLAG in P_BASE.tsSTGAT_ACTIVE_FLAG := 'Y')
  is
    nITM_ID P_BASE.tnITM_ID;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_STG_ATTRIBUTE_TYPE',
      psCODE || '~' || psDATA_TYPE || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_TEXT.SET_TEXT(nITM_ID, 'STGAT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into T_STC_GROUP_ATTRIBUTE_TYPES (CODE, DATA_TYPE, DISPLAY_SEQ, ACTIVE_FLAG, ITM_ID)
    values (psCODE, psDATA_TYPE, pnDISPLAY_SEQ, psACTIVE_FLAG, nITM_ID);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_STG_ATTRIBUTE_TYPE;
--
-- ----------------------------------------
-- UPDATE_STG_ATTRIBUTE_TYPE
-- ----------------------------------------
--
  procedure UPDATE_STG_ATTRIBUTE_TYPE
   (psCODE in P_BASE.tmsSTGAT_CODE,
    pnVERSION_NBR in out P_BASE.tnSTGAT_VERSION_NBR,
    psDATA_TYPE in P_BASE.tsSTGAT_DATA_TYPE := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnSTGAT_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsSTGAT_ACTIVE_FLAG := null)
  is
    sDATA_TYPE P_BASE.tsSTGAT_DATA_TYPE;
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnSTGAT_VERSION_NBR;
    xSTGAT_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_STG_ATTRIBUTE_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psDATA_TYPE || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    select DATA_TYPE, ITM_ID, VERSION_NBR, rowid
    into sDATA_TYPE, nITM_ID, nVERSION_NBR, xSTGAT_ROWID
    from T_STC_GROUP_ATTRIBUTE_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
    --
    -- Check if data type is to be changed and statistic group attributes of this type already
    --  exist.
    --
      if psDATA_TYPE != sDATA_TYPE
      then
        declare
          sDummy varchar2(1);
        begin
          select 'x' into sDummy from T_STC_GROUP_ATTRIBUTES where STGAT_CODE = psCODE;
        --
          raise TOO_MANY_ROWS;
        exception
          when NO_DATA_FOUND then null;
        --
          when TOO_MANY_ROWS
          then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 5, 'Cannot update data type of statistic group attribute type already in use');
        end;
      end if;
    --
      if psDescription is not null
      then P_TEXT.SET_TEXT(nITM_ID, 'STGAT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update T_STC_GROUP_ATTRIBUTE_TYPES
      set DATA_TYPE = nvl(psDATA_TYPE, DATA_TYPE),
        DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xSTGAT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'Statistic group attribute type has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end UPDATE_STG_ATTRIBUTE_TYPE;
--
-- ----------------------------------------
-- SET_STG_ATTRIBUTE_TYPE
-- ----------------------------------------
--
  procedure SET_STG_ATTRIBUTE_TYPE
   (psCODE in P_BASE.tmsSTGAT_CODE,
    pnVERSION_NBR in out P_BASE.tnSTGAT_VERSION_NBR,
    psDATA_TYPE in P_BASE.tsSTGAT_DATA_TYPE := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnSTGAT_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsSTGAT_ACTIVE_FLAG := null)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_STG_ATTRIBUTE_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psDATA_TYPE || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    if pnVERSION_NBR is null
    then
      INSERT_STG_ATTRIBUTE_TYPE
       (psCODE, psDATA_TYPE, psLANG_CODE, psDescription,
        case when pnDISPLAY_SEQ = -1e6 then null else pnDISPLAY_SEQ end, nvl(psACTIVE_FLAG, 'Y'));
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_STG_ATTRIBUTE_TYPE
       (psCODE, pnVERSION_NBR, psDATA_TYPE, psLANG_CODE, psDescription,
        pnDISPLAY_SEQ, psACTIVE_FLAG);
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_STG_ATTRIBUTE_TYPE;
--
-- ----------------------------------------
-- DELETE_STG_ATTRIBUTE_TYPE
-- ----------------------------------------
--
  procedure DELETE_STG_ATTRIBUTE_TYPE
   (psCODE in P_BASE.tmsSTGAT_CODE,
    pnVERSION_NBR in P_BASE.tnSTGAT_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnSTGAT_VERSION_NBR;
    xSTGAT_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_STG_ATTRIBUTE_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xSTGAT_ROWID
    from T_STC_GROUP_ATTRIBUTE_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_STC_GROUP_ATTRIBUTE_TYPES where rowid = xSTGAT_ROWID;
    --
      P_TEXT.DELETE_TEXT(nITM_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'Statistic group attribute type has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_STG_ATTRIBUTE_TYPE;
--
-- ----------------------------------------
-- SET_STGAT_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_STGAT_DESCRIPTION
   (psCODE in P_BASE.tmsSTGAT_CODE,
    pnVERSION_NBR in out P_BASE.tnSTGAT_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_STGAT_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_STGAT_TEXT(psCODE, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_STGAT_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_STGAT_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_STGAT_DESCRIPTION
   (psCODE in P_BASE.tmsSTGAT_CODE,
    pnVERSION_NBR in out P_BASE.tnSTGAT_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_STGAT_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_STGAT_TEXT(psCODE, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_STGAT_DESCRIPTION;
--
-- ----------------------------------------
-- SET_STGAT_TEXT
-- ----------------------------------------
--
  procedure SET_STGAT_TEXT
   (psCODE in P_BASE.tmsSTGAT_CODE,
    pnVERSION_NBR in out P_BASE.tnSTGAT_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnSTGAT_VERSION_NBR;
    xSTGAT_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_STGAT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xSTGAT_ROWID
    from T_STC_GROUP_ATTRIBUTE_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'STGAT', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_STC_GROUP_ATTRIBUTE_TYPES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xSTGAT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'Statistic group attribute type has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_STGAT_TEXT;
--
-- ----------------------------------------
-- REMOVE_STGAT_TEXT
-- ----------------------------------------
--
  procedure REMOVE_STGAT_TEXT
   (psCODE in P_BASE.tmsSTGAT_CODE,
    pnVERSION_NBR in out P_BASE.tnSTGAT_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnSTGAT_VERSION_NBR;
    xSTGAT_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_STGAT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xSTGAT_ROWID
    from T_STC_GROUP_ATTRIBUTE_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_STC_GROUP_ATTRIBUTE_TYPES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xSTGAT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'Statistic group attribute type has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_STGAT_TEXT;
--
-- ----------------------------------------
-- INSERT_STG_ATTRIBUTE
-- ----------------------------------------
--
  procedure INSERT_STG_ATTRIBUTE
   (pnSTG_ID in P_BASE.tmnSTG_ID,
    psSTGAT_CODE in P_BASE.tmsSTGAT_CODE,
    psCHAR_VALUE in P_BASE.tsSTGA_CHAR_VALUE := null,
    pnNUM_VALUE in P_BASE.tnSTGA_NUM_VALUE := null,
    pdDATE_VALUE in P_BASE.tdSTGA_DATE_VALUE := null)
  is
    sDATA_TYPE P_BASE.tsSTGAT_DATA_TYPE;
    sACTIVE_FLAG P_BASE.tsSTGAT_ACTIVE_FLAG;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_STG_ATTRIBUTE',
      to_char(pnSTG_ID) || '~' || psSTGAT_CODE || '~' || psCHAR_VALUE || '~' ||
        to_char(pnNUM_VALUE) || '~' || to_char(pdDATE_VALUE, 'YYYY-MM-DD HH24:MI:SS'));
  --
    select DATA_TYPE, ACTIVE_FLAG
    into sDATA_TYPE, sACTIVE_FLAG
    from T_STC_GROUP_ATTRIBUTE_TYPES
    where CODE = psSTGAT_CODE;
  --
    if sACTIVE_FLAG = 'N'
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 6, 'Inactive statistic group attribute type');
    end if;
  --
    case
      when sDATA_TYPE = 'C' and psCHAR_VALUE is not null then null;
      when sDATA_TYPE = 'N' and pnNUM_VALUE is not null then null;
      when sDATA_TYPE = 'D' and pdDATE_VALUE is not null then null;
      else P_MESSAGE.DISPLAY_MESSAGE(sComponent, 7, 'Attribute of the correct type must be specified');
    end case;
  --
    insert into T_STC_GROUP_ATTRIBUTES (STG_ID, STGAT_CODE, CHAR_VALUE, NUM_VALUE, DATE_VALUE)
    values (pnSTG_ID, psSTGAT_CODE, psCHAR_VALUE, pnNUM_VALUE, pdDATE_VALUE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_STG_ATTRIBUTE;
--
-- ----------------------------------------
-- UPDATE_STG_ATTRIBUTE
-- ----------------------------------------
--
  procedure UPDATE_STG_ATTRIBUTE
   (pnSTG_ID in P_BASE.tmnSTG_ID,
    psSTGAT_CODE in P_BASE.tmsSTGAT_CODE,
    pnVERSION_NBR in out P_BASE.tnSTGA_VERSION_NBR,
    psCHAR_VALUE in P_BASE.tsSTGA_CHAR_VALUE := null,
    pnNUM_VALUE in P_BASE.tnSTGA_NUM_VALUE := null,
    pdDATE_VALUE in P_BASE.tdSTGA_DATE_VALUE := null)
  is
    nVERSION_NBR P_BASE.tnSTGA_VERSION_NBR;
    xSTGA_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_STG_ATTRIBUTE',
      to_char(pnSTG_ID) || '~' || psSTGAT_CODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psCHAR_VALUE || '~' || to_char(pnNUM_VALUE) || '~' ||
        to_char(pdDATE_VALUE, 'YYYY-MM-DD HH24:MI:SS'));
  --
    select VERSION_NBR, rowid
    into nVERSION_NBR, xSTGA_ROWID
    from T_STC_GROUP_ATTRIBUTES
    where STG_ID = pnSTG_ID
    and STGAT_CODE = psSTGAT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      update T_STC_GROUP_ATTRIBUTES
      set CHAR_VALUE = psCHAR_VALUE,
        NUM_VALUE = pnNUM_VALUE,
        DATE_VALUE = pdDATE_VALUE,
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xSTGA_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 3, 'Statistic group attribute has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end UPDATE_STG_ATTRIBUTE;
--
-- ----------------------------------------
-- SET_STG_ATTRIBUTE
-- ----------------------------------------
--
  procedure SET_STG_ATTRIBUTE
   (pnSTG_ID in P_BASE.tmnSTG_ID,
    psSTGAT_CODE in P_BASE.tmsSTGAT_CODE,
    pnVERSION_NBR in out P_BASE.tnSTGA_VERSION_NBR,
    psCHAR_VALUE in P_BASE.tsSTGA_CHAR_VALUE := null,
    pnNUM_VALUE in P_BASE.tnSTGA_NUM_VALUE := null,
    pdDATE_VALUE in P_BASE.tdSTGA_DATE_VALUE := null)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_STG_ATTRIBUTE',
      to_char(pnSTG_ID) || '~' || psSTGAT_CODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psCHAR_VALUE || '~' || to_char(pnNUM_VALUE) || '~' ||
        to_char(pdDATE_VALUE, 'YYYY-MM-DD HH24:MI:SS'));
  --
    if pnVERSION_NBR is null
    then
      INSERT_STG_ATTRIBUTE(pnSTG_ID, psSTGAT_CODE,
                           psCHAR_VALUE, pnNUM_VALUE, pdDATE_VALUE);
    --
      pnVERSION_NBR := 1;
    elsif psCHAR_VALUE is null and pnNUM_VALUE is null and pdDATE_VALUE is null
    then
      DELETE_STG_ATTRIBUTE(pnSTG_ID, psSTGAT_CODE, pnVERSION_NBR);
    else
      UPDATE_STG_ATTRIBUTE(pnSTG_ID, psSTGAT_CODE, pnVERSION_NBR,
                           psCHAR_VALUE, pnNUM_VALUE, pdDATE_VALUE);
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_STG_ATTRIBUTE;
--
-- ----------------------------------------
-- DELETE_STG_ATTRIBUTE
-- ----------------------------------------
--
  procedure DELETE_STG_ATTRIBUTE
   (pnSTG_ID in P_BASE.tmnSTG_ID,
    psSTGAT_CODE in P_BASE.tmsSTGAT_CODE,
    pnVERSION_NBR in P_BASE.tnSTGA_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnSTGA_VERSION_NBR;
    xSTGA_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_STG_ATTRIBUTE',
      to_char(pnSTG_ID) || '~' || psSTGAT_CODE || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xSTGA_ROWID
    from T_STC_GROUP_ATTRIBUTES
    where STG_ID = pnSTG_ID
    and STGAT_CODE = psSTGAT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_STC_GROUP_ATTRIBUTES where rowid = xSTGA_ROWID;
    --
      if nITM_ID is not null
      then P_TEXT.DELETE_TEXT(nITM_ID);
      end if;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 3, 'Statistic group attribute has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_STG_ATTRIBUTE;
--
-- ----------------------------------------
-- SET_STGA_TEXT
-- ----------------------------------------
--
  procedure SET_STGA_TEXT
   (pnSTG_ID in P_BASE.tmnSTG_ID,
    psSTGAT_CODE in P_BASE.tmsSTGAT_CODE,
    pnVERSION_NBR in out P_BASE.tnSTGA_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnSTGA_VERSION_NBR;
    xSTGA_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_STGA_TEXT',
      to_char(pnSTG_ID) || '~' || psSTGAT_CODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xSTGA_ROWID
    from T_STC_GROUP_ATTRIBUTES
    where STG_ID = pnSTG_ID
    and STGAT_CODE = psSTGAT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'STGA', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_STC_GROUP_ATTRIBUTES
      set ITM_ID = nITM_ID,
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xSTGA_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 3, 'Statistic group attribute has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_STGA_TEXT;
--
-- ----------------------------------------
-- REMOVE_STGA_TEXT
-- ----------------------------------------
--
  procedure REMOVE_STGA_TEXT
   (pnSTG_ID in P_BASE.tmnSTG_ID,
    psSTGAT_CODE in P_BASE.tmsSTGAT_CODE,
    pnVERSION_NBR in out P_BASE.tnSTGA_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnSTGA_VERSION_NBR;
    xSTGA_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_STGA_TEXT',
      to_char(pnSTG_ID) || '~' || psSTGAT_CODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xSTGA_ROWID
    from T_STC_GROUP_ATTRIBUTES
    where STG_ID = pnSTG_ID
    and STGAT_CODE = psSTGAT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_STC_GROUP_ATTRIBUTES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xSTGA_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 3, 'Statistic group attribute has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_STGA_TEXT;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sComponent != 'STG'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'Component code mismatch');
  end if;
--
  if sVersion != 'D1.0'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
end P_STATISTIC_GROUP;
/

show errors
