create or replace package body P_STATISTIC is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- INSERT_STATISTIC
-- ----------------------------------------
--
  procedure INSERT_STATISTIC
   (pnID out P_BASE.tnSTC_ID,
    psSTCT_CODE in P_BASE.tmsSTCT_CODE,
    pdSTART_DATE in P_BASE.tmdDate,
    pdEND_DATE in P_BASE.tmdDate,
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
    pnSTG_ID_PRIMARY in P_BASE.tnSTG_ID := null,
    pnPPG_ID in P_BASE.tnPPG_ID := null,
    pnVALUE in P_BASE.tmnSTC_VALUE)
  is
    sDST_ID_FLAG P_BASE.tsFlag;
    sLOC_ID_ASYLUM_COUNTRY_FLAG P_BASE.tsFlag;
    sLOC_ID_ASYLUM_FLAG P_BASE.tsFlag;
    sLOC_ID_ORIGIN_COUNTRY_FLAG P_BASE.tsFlag;
    sLOC_ID_ORIGIN_FLAG P_BASE.tsFlag;
    sDIM_ID1_FLAG P_BASE.tsFlag;
    sDIMT_CODE1 P_BASE.tsDIMT_CODE;
    sDIM_ID2_FLAG P_BASE.tsFlag;
    sDIMT_CODE2 P_BASE.tsDIMT_CODE;
    sDIM_ID3_FLAG P_BASE.tsFlag;
    sDIMT_CODE3 P_BASE.tsDIMT_CODE;
    sDIM_ID4_FLAG P_BASE.tsFlag;
    sDIMT_CODE4 P_BASE.tsDIMT_CODE;
    sDIM_ID5_FLAG P_BASE.tsFlag;
    sDIMT_CODE5 P_BASE.tsDIMT_CODE;
    sSEX_CODE_FLAG P_BASE.tsFlag;
    sAGR_ID_FLAG P_BASE.tsFlag;
  --
    nSTG_SEQ_NBR P_BASE.tnSTG_SEQ_NBR;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_STATISTIC',
      '~' || psSTCT_CODE || '~' ||
        to_char(pdSTART_DATE, 'YYYY-MM-DD')  || '~' || to_char(pdEND_DATE, 'YYYY-MM-DD')  || '~' ||
        to_char(pnDST_ID) || '~' ||
        to_char(pnLOC_ID_ASYLUM_COUNTRY) || '~' || to_char(pnLOC_ID_ASYLUM) || '~' ||
        to_char(pnLOC_ID_ORIGIN_COUNTRY) || '~' || to_char(pnLOC_ID_ORIGIN) || '~' ||
        to_char(pnDIM_ID1) || '~' || to_char(pnDIM_ID2) || '~' || to_char(pnDIM_ID3) || '~' ||
        to_char(pnDIM_ID4) || '~' || to_char(pnDIM_ID5) || '~' || psSEX_CODE || '~' ||
        to_char(pnAGR_ID) || '~' || to_char(pnSTG_ID_PRIMARY) || '~' || to_char(pnPPG_ID) || '~' ||
        to_char(pnVALUE));
  --
    select DST_ID_FLAG, LOC_ID_ASYLUM_COUNTRY_FLAG, LOC_ID_ASYLUM_FLAG,
      LOC_ID_ORIGIN_COUNTRY_FLAG, LOC_ID_ORIGIN_FLAG,
      DIM_ID1_FLAG, DIMT_CODE1, DIM_ID2_FLAG, DIMT_CODE2, DIM_ID3_FLAG, DIMT_CODE3,
      DIM_ID4_FLAG, DIMT_CODE4, DIM_ID5_FLAG, DIMT_CODE5, SEX_CODE_FLAG, AGR_ID_FLAG
    into sDST_ID_FLAG, sLOC_ID_ASYLUM_COUNTRY_FLAG, sLOC_ID_ASYLUM_FLAG,
      sLOC_ID_ORIGIN_COUNTRY_FLAG, sLOC_ID_ORIGIN_FLAG,
      sDIM_ID1_FLAG, sDIMT_CODE1, sDIM_ID2_FLAG, sDIMT_CODE2, sDIM_ID3_FLAG, sDIMT_CODE3,
      sDIM_ID4_FLAG, sDIMT_CODE4, sDIM_ID5_FLAG, sDIMT_CODE5, sSEX_CODE_FLAG, sAGR_ID_FLAG
    from T_STATISTIC_TYPES
    where CODE = psSTCT_CODE
    and ACTIVE_FLAG = 'Y';
  --
    if sDST_ID_FLAG = 'M' and pnDST_ID is null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'Displacement status must be specified');
    elsif sDST_ID_FLAG = 'N' and pnDST_ID is not null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 3, 'Displacement status must not be specified');
    end if;
  --
    if sLOC_ID_ASYLUM_COUNTRY_FLAG = 'M' and pnLOC_ID_ASYLUM_COUNTRY is null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 4, 'Asylum country must be specified');
    elsif sLOC_ID_ASYLUM_COUNTRY_FLAG = 'N' and pnLOC_ID_ASYLUM_COUNTRY is not null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 5, 'Asylum country must not be specified');
    end if;
  --
    if sLOC_ID_ASYLUM_FLAG = 'M' and pnLOC_ID_ASYLUM is null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 6, 'Asylum location must be specified');
    elsif sLOC_ID_ASYLUM_FLAG = 'N' and pnLOC_ID_ASYLUM is not null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 7, 'Asylum location must not be specified');
    end if;
  --
    if sLOC_ID_ORIGIN_COUNTRY_FLAG = 'M' and pnLOC_ID_ORIGIN_COUNTRY is null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 8, 'Origin country must be specified');
    elsif sLOC_ID_ORIGIN_COUNTRY_FLAG = 'N' and pnLOC_ID_ORIGIN_COUNTRY is not null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 9, 'Origin country must not be specified');
    end if;
  --
    if sLOC_ID_ORIGIN_FLAG = 'M' and pnLOC_ID_ORIGIN is null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 10, 'Origin location must be specified');
    elsif sLOC_ID_ORIGIN_FLAG = 'N' and pnLOC_ID_ORIGIN is not null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 11, 'Origin location must not be specified');
    end if;
  --
    if sDIM_ID1_FLAG = 'M' and pnDIM_ID1 is null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 12, 'Generic dimension 1 must be specified');
    elsif sDIM_ID1_FLAG = 'N' and pnDIM_ID1 is not null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 13, 'Generic dimension 1 must not be specified');
    end if;
  --
    if sDIM_ID2_FLAG = 'M' and pnDIM_ID2 is null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 14, 'Generic dimension 2 must be specified');
    elsif sDIM_ID2_FLAG = 'N' and pnDIM_ID2 is not null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 15, 'Generic dimension 2 must not be specified');
    end if;
  --
    if sDIM_ID3_FLAG = 'M' and pnDIM_ID3 is null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 16, 'Generic dimension 3 must be specified');
    elsif sDIM_ID3_FLAG = 'N' and pnDIM_ID3 is not null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 17, 'Generic dimension 3 must not be specified');
    end if;
  --
    if sDIM_ID4_FLAG = 'M' and pnDIM_ID4 is null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 18, 'Generic dimension 4 must be specified');
    elsif sDIM_ID4_FLAG = 'N' and pnDIM_ID4 is not null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 19, 'Generic dimension 4 must not be specified');
    end if;
  --
    if sDIM_ID5_FLAG = 'M' and pnDIM_ID5 is null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 20, 'Generic dimension 5 must be specified');
    elsif sDIM_ID5_FLAG = 'N' and pnDIM_ID5 is not null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 21, 'Generic dimension 5 must not be specified');
    end if;
  --
    if sSEX_CODE_FLAG = 'M' and psSEX_CODE is null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 22, 'Sex must be specified');
    elsif sSEX_CODE_FLAG = 'N' and psSEX_CODE is not null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 23, 'Sex must not be specified');
    end if;
  --
    if sAGR_ID_FLAG = 'M' and pnAGR_ID is null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 24, 'Age range must be specified');
    elsif sAGR_ID_FLAG = 'N' and pnAGR_ID is not null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 25, 'Age range must not be specified');
    end if;
  --
    if pnSTG_ID_PRIMARY is not null
    then
      select SEQ_NBR
      into nSTG_SEQ_NBR
      from T_STATISTIC_GROUPS
      where ID = pnSTG_ID_PRIMARY;
    end if;
  --
    insert into T_STATISTICS
     (ID, STCT_CODE, START_DATE, END_DATE, DST_ID,
      LOC_ID_ASYLUM_COUNTRY, LOC_ID_ASYLUM, LOC_ID_ORIGIN_COUNTRY, LOC_ID_ORIGIN,
      DIM_ID1, DIM_ID2, DIM_ID3, DIM_ID4, DIM_ID5,
      SEX_CODE, AGR_ID, STG_SEQ_NBR, STG_ID_PRIMARY, PPG_ID, VALUE)
    values
     (STC_SEQ.nextval, psSTCT_CODE, pdSTART_DATE, pdEND_DATE, pnDST_ID,
      pnLOC_ID_ASYLUM_COUNTRY, pnLOC_ID_ASYLUM, pnLOC_ID_ORIGIN_COUNTRY, pnLOC_ID_ORIGIN,
      pnDIM_ID1, pnDIM_ID2, pnDIM_ID3, pnDIM_ID4, pnDIM_ID5,
      psSEX_CODE, pnAGR_ID, nSTG_SEQ_NBR, pnSTG_ID_PRIMARY, pnPPG_ID, pnVALUE)
    returning ID into pnID;
  --
    P_UTILITY.TRACE_CONTEXT
     (to_char(pnID) || '~' || psSTCT_CODE || '~' ||
        to_char(pdSTART_DATE, 'YYYY-MM-DD')  || '~' || to_char(pdEND_DATE, 'YYYY-MM-DD')  || '~' ||
        to_char(pnDST_ID) || '~' ||
        to_char(pnLOC_ID_ASYLUM_COUNTRY) || '~' || to_char(pnLOC_ID_ASYLUM) || '~' ||
        to_char(pnLOC_ID_ORIGIN_COUNTRY) || '~' || to_char(pnLOC_ID_ORIGIN) || '~' ||
        to_char(pnDIM_ID1) || '~' || to_char(pnDIM_ID2) || '~' || to_char(pnDIM_ID3) || '~' ||
        to_char(pnDIM_ID4) || '~' || to_char(pnDIM_ID5) || '~' || psSEX_CODE || '~' ||
        to_char(pnAGR_ID) || '~' || to_char(pnSTG_ID_PRIMARY) || '~' || to_char(pnPPG_ID) || '~' ||
        to_char(pnVALUE));
  --
    if pnSTG_ID_PRIMARY is not null
    then INSERT_STATISTIC_IN_GROUP(pnID, pnSTG_ID_PRIMARY);
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_STATISTIC;
--
-- ----------------------------------------
-- UPDATE_STATISTIC
-- ----------------------------------------
--
  procedure UPDATE_STATISTIC
   (pnID in P_BASE.tmnSTC_ID,
    pnVERSION_NBR in out P_BASE.tnSTC_VERSION_NBR,
    pnVALUE in P_BASE.tnSTC_VALUE)
  is
    nVERSION_NBR P_BASE.tnSTC_VERSION_NBR;
    xSTC_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_STATISTIC',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnVALUE));
  --
    select VERSION_NBR, rowid
    into nVERSION_NBR, xSTC_ROWID
    from T_STATISTICS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      update T_STATISTICS
      set VALUE = pnVALUE
      where rowid = xSTC_ROWID;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Statistic has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end UPDATE_STATISTIC;
--
-- ----------------------------------------
-- SET_STATISTIC
-- ----------------------------------------
--
  procedure SET_STATISTIC
   (pnID in out P_BASE.tnSTC_ID,
    pnVERSION_NBR in out P_BASE.tnSTC_VERSION_NBR,
    psSTCT_CODE in P_BASE.tsSTCT_CODE := null,
    pdSTART_DATE in P_BASE.tdDate := null,
    pdEND_DATE in P_BASE.tdDate := null,
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
    pnSTG_ID_PRIMARY in P_BASE.tnSTG_ID := null,
    pnPPG_ID in P_BASE.tnPPG_ID := null,
    pnVALUE in P_BASE.tmnSTC_VALUE)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_STATISTIC',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psSTCT_CODE || '~' ||
        to_char(pdSTART_DATE, 'YYYY-MM-DD')  || '~' || to_char(pdEND_DATE, 'YYYY-MM-DD')  || '~' ||
        to_char(pnDST_ID) || '~' ||
        to_char(pnLOC_ID_ASYLUM_COUNTRY) || '~' || to_char(pnLOC_ID_ASYLUM) || '~' ||
        to_char(pnLOC_ID_ORIGIN_COUNTRY) || '~' || to_char(pnLOC_ID_ORIGIN) || '~' ||
        to_char(pnDIM_ID1) || '~' || to_char(pnDIM_ID2) || '~' || to_char(pnDIM_ID3) || '~' ||
        to_char(pnDIM_ID4) || '~' || to_char(pnDIM_ID5) || '~' || psSEX_CODE || '~' ||
        to_char(pnAGR_ID) || '~' || to_char(pnSTG_ID_PRIMARY) || '~' || to_char(pnPPG_ID) || '~' ||
        to_char(pnVALUE));
  --
    if pnVERSION_NBR is null
    then
      INSERT_STATISTIC
       (pnID, psSTCT_CODE, pdSTART_DATE, pdEND_DATE, pnDST_ID,
        pnLOC_ID_ASYLUM_COUNTRY, pnLOC_ID_ASYLUM, pnLOC_ID_ORIGIN_COUNTRY, pnLOC_ID_ORIGIN,
        pnDIM_ID1, pnDIM_ID2, pnDIM_ID3, pnDIM_ID4, pnDIM_ID5,
        psSEX_CODE, pnAGR_ID, pnSTG_ID_PRIMARY, pnPPG_ID,
        pnVALUE);
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_STATISTIC(pnID, pnVERSION_NBR, pnVALUE);
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_STATISTIC;
--
-- ----------------------------------------
-- DELETE_STATISTIC
-- ----------------------------------------
--
  procedure DELETE_STATISTIC
   (pnID in P_BASE.tmnSTC_ID,
    pnVERSION_NBR in P_BASE.tnSTC_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnSTC_VERSION_NBR;
    xSTC_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_STATISTIC',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xSTC_ROWID
    from T_STATISTICS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_STATISTICS where rowid = xSTC_ROWID;
    --
      if nITM_ID is not null
      then P_TEXT.DELETE_TEXT(nITM_ID);
      end if;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Statistic has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_STATISTIC;
--
-- ----------------------------------------
-- SET_STC_TEXT
-- ----------------------------------------
--
  procedure SET_STC_TEXT
   (pnID in P_BASE.tmnSTC_ID,
    pnVERSION_NBR in out P_BASE.tnSTC_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnSTC_VERSION_NBR;
    xSTC_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_STC_TEXT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' ||
        psLANG_CODE || '~' || to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xSTC_ROWID
    from T_STATISTICS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'STC', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_STATISTICS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xSTC_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Statistic has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_STC_TEXT;
--
-- ----------------------------------------
-- REMOVE_STC_TEXT
-- ----------------------------------------
--
  procedure REMOVE_STC_TEXT
   (pnID in P_BASE.tmnSTC_ID,
    pnVERSION_NBR in out P_BASE.tnSTC_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnSTC_VERSION_NBR;
    xSTC_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_STC_TEXT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xSTC_ROWID
    from T_STATISTICS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if nITM_ID is not null
      then P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
      end if;
    --
      update T_STATISTICS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xSTC_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Statistic has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_STC_TEXT;
--
-- ----------------------------------------
-- INSERT_STATISTIC_IN_GROUP
-- ----------------------------------------
--
  procedure INSERT_STATISTIC_IN_GROUP
   (pnSTC_ID in P_BASE.tmnSTC_ID,
    pnSTG_ID in P_BASE.tmnSTG_ID)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_STATISTIC_IN_GROUP',
      to_char(pnSTC_ID) || '~' || to_char(pnSTG_ID));
  --
    insert into T_STATISTICS_IN_GROUPS (STC_ID, STG_ID)
    values (pnSTC_ID, pnSTG_ID);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_STATISTIC_IN_GROUP;
--
-- ----------------------------------------
-- DELETE_STATISTIC_IN_GROUP
-- ----------------------------------------
--
  procedure DELETE_STATISTIC_IN_GROUP
   (pnSTC_ID in P_BASE.tmnSTC_ID,
    pnSTG_ID in P_BASE.tmnSTG_ID)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_STATISTIC_IN_GROUP',
      to_char(pnSTC_ID) || '~' || to_char(pnSTG_ID));
  --
    delete from T_STATISTICS_IN_GROUPS
    where STC_ID = pnSTC_ID
    and STG_ID = pnSTG_ID;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_STATISTIC_IN_GROUP;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sComponent != 'STC'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'Component code mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
end P_STATISTIC;
/

show errors
