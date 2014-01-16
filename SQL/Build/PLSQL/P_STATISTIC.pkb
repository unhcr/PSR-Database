create or replace package body P_STATISTIC is
--
-- ========================================
-- Private program units
-- ========================================
--
-- ----------------------------------------
-- VALIDATE_STATISTIC_DIMENSIONS
-- ----------------------------------------
--
  procedure VALIDATE_STATISTIC_DIMENSIONS
   (psSTCT_CODE in P_BASE.tmsSTCT_CODE,
    pnDST_ID in P_BASE.tnDST_ID,
    pnLOC_ID_ASYLUM_COUNTRY in P_BASE.tnLOC_ID,
    pnLOC_ID_ASYLUM in P_BASE.tnLOC_ID,
    pnLOC_ID_ORIGIN_COUNTRY in P_BASE.tnLOC_ID,
    pnLOC_ID_ORIGIN in P_BASE.tnLOC_ID,
    pnDIM_ID1 in P_BASE.tnDIM_ID,
    pnDIM_ID2 in P_BASE.tnDIM_ID,
    pnDIM_ID3 in P_BASE.tnDIM_ID,
    pnDIM_ID4 in P_BASE.tnDIM_ID,
    pnDIM_ID5 in P_BASE.tnDIM_ID,
    psSEX_CODE in P_BASE.tsSEX_CODE,
    pnAGR_ID in P_BASE.tnAGR_ID)
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
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.VALIDATE_STATISTIC_DIMENSIONS',
      psSTCT_CODE || '~' || to_char(pnDST_ID) || '~' ||
        to_char(pnLOC_ID_ASYLUM_COUNTRY) || '~' || to_char(pnLOC_ID_ASYLUM) || '~' ||
        to_char(pnLOC_ID_ORIGIN_COUNTRY) || '~' || to_char(pnLOC_ID_ORIGIN) || '~' ||
        to_char(pnDIM_ID1) || '~' || to_char(pnDIM_ID2) || '~' || to_char(pnDIM_ID3) || '~' ||
        to_char(pnDIM_ID4) || '~' || to_char(pnDIM_ID5) || '~' ||
        psSEX_CODE || '~' || to_char(pnAGR_ID));
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
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 3, 'Displacement status must be specified');
    elsif sDST_ID_FLAG = 'N' and pnDST_ID != -1
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 4, 'Displacement status must not be specified');
    end if;
  --
    if sLOC_ID_ASYLUM_COUNTRY_FLAG = 'M' and pnLOC_ID_ASYLUM_COUNTRY is null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 5, 'Asylum country must be specified');
    elsif sLOC_ID_ASYLUM_COUNTRY_FLAG = 'N' and pnLOC_ID_ASYLUM_COUNTRY != -1
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 6, 'Asylum country must not be specified');
    end if;
  --
    if sLOC_ID_ASYLUM_FLAG = 'M' and pnLOC_ID_ASYLUM is null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 7, 'Asylum location must be specified');
    elsif sLOC_ID_ASYLUM_FLAG = 'N' and pnLOC_ID_ASYLUM != -1
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 8, 'Asylum location must not be specified');
    end if;
  --
    if sLOC_ID_ORIGIN_COUNTRY_FLAG = 'M' and pnLOC_ID_ORIGIN_COUNTRY is null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 9, 'Origin country must be specified');
    elsif sLOC_ID_ORIGIN_COUNTRY_FLAG = 'N' and pnLOC_ID_ORIGIN_COUNTRY != -1
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 10, 'Origin country must not be specified');
    end if;
  --
    if sLOC_ID_ORIGIN_FLAG = 'M' and pnLOC_ID_ORIGIN is null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 11, 'Origin location must be specified');
    elsif sLOC_ID_ORIGIN_FLAG = 'N' and pnLOC_ID_ORIGIN != -1
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 12, 'Origin location must not be specified');
    end if;
  --
    if sDIM_ID1_FLAG = 'M' and pnDIM_ID1 is null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 13, 'Generic dimension 1 must be specified');
    elsif sDIM_ID1_FLAG = 'N' and pnDIM_ID1 != -1
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 14, 'Generic dimension 1 must not be specified');
    end if;
  --
    if sDIM_ID2_FLAG = 'M' and pnDIM_ID2 is null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 15, 'Generic dimension 2 must be specified');
    elsif sDIM_ID2_FLAG = 'N' and pnDIM_ID2 != -1
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 16, 'Generic dimension 2 must not be specified');
    end if;
  --
    if sDIM_ID3_FLAG = 'M' and pnDIM_ID3 is null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 17, 'Generic dimension 3 must be specified');
    elsif sDIM_ID3_FLAG = 'N' and pnDIM_ID3 != -1
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 18, 'Generic dimension 3 must not be specified');
    end if;
  --
    if sDIM_ID4_FLAG = 'M' and pnDIM_ID4 is null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 19, 'Generic dimension 4 must be specified');
    elsif sDIM_ID4_FLAG = 'N' and pnDIM_ID4 != -1
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 20, 'Generic dimension 4 must not be specified');
    end if;
  --
    if sDIM_ID5_FLAG = 'M' and pnDIM_ID5 is null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 21, 'Generic dimension 5 must be specified');
    elsif sDIM_ID5_FLAG = 'N' and pnDIM_ID5 != -1
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 22, 'Generic dimension 5 must not be specified');
    end if;
  --
    if sSEX_CODE_FLAG = 'M' and psSEX_CODE is null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 23, 'Sex must be specified');
    elsif sSEX_CODE_FLAG = 'N' and psSEX_CODE != 'x'
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 24, 'Sex must not be specified');
    end if;
  --
    if sAGR_ID_FLAG = 'M' and pnAGR_ID is null
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 25, 'Age range must be specified');
    elsif sAGR_ID_FLAG = 'N' and pnAGR_ID != -1
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 26, 'Age range must not be specified');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end VALIDATE_STATISTIC_DIMENSIONS;
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
   (pnSTC_ID out P_BASE.tnSTC_ID,
    pnVALUE in P_BASE.tmnSTC_VALUE,
    pdSTART_DATE in P_BASE.tmdDate,
    pdEND_DATE in P_BASE.tmdDate,
    psSTCT_CODE in P_BASE.tmsSTCT_CODE,
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
    pnPPG_ID in P_BASE.tnPPG_ID := null,
    pnSTG_ID_PRIMARY in P_BASE.tnSTG_ID := null)
  is
    nSTG_SEQ_NBR P_BASE.tnSTG_SEQ_NBR;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_STATISTIC',
      '~' || to_char(pnVALUE) || '~' ||
        to_char(pdSTART_DATE, 'YYYY-MM-DD') || '~' || to_char(pdEND_DATE, 'YYYY-MM-DD')  || '~' ||
        psSTCT_CODE || '~' || to_char(pnDST_ID) || '~' ||
        to_char(pnLOC_ID_ASYLUM_COUNTRY) || '~' || to_char(pnLOC_ID_ASYLUM) || '~' ||
        to_char(pnLOC_ID_ORIGIN_COUNTRY) || '~' || to_char(pnLOC_ID_ORIGIN) || '~' ||
        to_char(pnDIM_ID1) || '~' || to_char(pnDIM_ID2) || '~' || to_char(pnDIM_ID3) || '~' ||
        to_char(pnDIM_ID4) || '~' || to_char(pnDIM_ID5) || '~' || psSEX_CODE || '~' ||
        to_char(pnAGR_ID) || '~' || to_char(pnSTG_ID_PRIMARY) || '~' || to_char(pnPPG_ID));
  --
    VALIDATE_STATISTIC_DIMENSIONS
     (psSTCT_CODE,
      pnDST_ID, pnLOC_ID_ASYLUM_COUNTRY, pnLOC_ID_ASYLUM, pnLOC_ID_ORIGIN_COUNTRY, pnLOC_ID_ORIGIN,
      pnDIM_ID1, pnDIM_ID2, pnDIM_ID3, pnDIM_ID4, pnDIM_ID5, psSEX_CODE, pnAGR_ID);
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
     (ID, START_DATE, END_DATE, STCT_CODE, DST_ID,
      LOC_ID_ASYLUM_COUNTRY, LOC_ID_ASYLUM, LOC_ID_ORIGIN_COUNTRY, LOC_ID_ORIGIN,
      DIM_ID1, DIM_ID2, DIM_ID3, DIM_ID4, DIM_ID5,
      SEX_CODE, AGR_ID, STG_SEQ_NBR, STG_ID_PRIMARY, PPG_ID, VALUE)
    values
     (STC_SEQ.nextval, pdSTART_DATE, pdEND_DATE, psSTCT_CODE, pnDST_ID,
      pnLOC_ID_ASYLUM_COUNTRY, pnLOC_ID_ASYLUM, pnLOC_ID_ORIGIN_COUNTRY, pnLOC_ID_ORIGIN,
      pnDIM_ID1, pnDIM_ID2, pnDIM_ID3, pnDIM_ID4, pnDIM_ID5,
      psSEX_CODE, pnAGR_ID, nSTG_SEQ_NBR, pnSTG_ID_PRIMARY, pnPPG_ID, pnVALUE)
    returning ID into pnSTC_ID;
  --
    P_UTILITY.TRACE_CONTEXT
     (to_char(pnSTC_ID) || '~' || to_char(pnVALUE) || '~' ||
        to_char(pdSTART_DATE, 'YYYY-MM-DD')  || '~' || to_char(pdEND_DATE, 'YYYY-MM-DD')  || '~' ||
        psSTCT_CODE || '~' || to_char(pnDST_ID) || '~' ||
        to_char(pnLOC_ID_ASYLUM_COUNTRY) || '~' || to_char(pnLOC_ID_ASYLUM) || '~' ||
        to_char(pnLOC_ID_ORIGIN_COUNTRY) || '~' || to_char(pnLOC_ID_ORIGIN) || '~' ||
        to_char(pnDIM_ID1) || '~' || to_char(pnDIM_ID2) || '~' || to_char(pnDIM_ID3) || '~' ||
        to_char(pnDIM_ID4) || '~' || to_char(pnDIM_ID5) || '~' || psSEX_CODE || '~' ||
        to_char(pnAGR_ID) || '~' || to_char(pnSTG_ID_PRIMARY) || '~' || to_char(pnPPG_ID));
  --
    if pnSTG_ID_PRIMARY is not null
    then INSERT_STATISTIC_IN_GROUP(pnSTC_ID, pnSTG_ID_PRIMARY);
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
   (pnSTC_ID in P_BASE.tmnSTC_ID,
    pnVERSION_NBR in out P_BASE.tnSTC_VERSION_NBR,
    pnVALUE in P_BASE.tmnSTC_VALUE,
    pdSTART_DATE in P_BASE.tdDate := null,
    pdEND_DATE in P_BASE.tdDate := null,
    psSTCT_CODE in P_BASE.tsSTCT_CODE := null,
    pnDST_ID in P_BASE.tnDST_ID := null,
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
    pnPPG_ID in P_BASE.tnPPG_ID := -1,
    psForceUpdateFlag in P_BASE.tmsFlag := 'N')
  is
    dSTART_DATE P_BASE.tdDate;
    dEND_DATE P_BASE.tdDate;
    sSTCT_CODE P_BASE.tsSTCT_CODE;
    nDST_ID P_BASE.tnDST_ID;
    nLOC_ID_ASYLUM_COUNTRY P_BASE.tnLOC_ID;
    nLOC_ID_ASYLUM P_BASE.tnLOC_ID;
    nLOC_ID_ORIGIN_COUNTRY P_BASE.tnLOC_ID;
    nLOC_ID_ORIGIN P_BASE.tnLOC_ID;
    nDIM_ID1 P_BASE.tnDIM_ID;
    nDIM_ID2 P_BASE.tnDIM_ID;
    nDIM_ID3 P_BASE.tnDIM_ID;
    nDIM_ID4 P_BASE.tnDIM_ID;
    nDIM_ID5 P_BASE.tnDIM_ID;
    sSEX_CODE P_BASE.tsSEX_CODE;
    nAGR_ID P_BASE.tnAGR_ID;
    nPPG_ID P_BASE.tnPPG_ID;
    nVALUE P_BASE.tnSTC_VALUE;
    nVERSION_NBR P_BASE.tnSTC_VERSION_NBR;
    xSTC_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_STATISTIC',
      to_char(pnSTC_ID) || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnVALUE) || '~' ||
        to_char(pdSTART_DATE, 'YYYY-MM-DD') || '~' || to_char(pdEND_DATE, 'YYYY-MM-DD')  || '~' ||
        psSTCT_CODE || '~' || to_char(pnDST_ID) || '~' ||
        to_char(pnLOC_ID_ASYLUM_COUNTRY) || '~' || to_char(pnLOC_ID_ASYLUM) || '~' ||
        to_char(pnLOC_ID_ORIGIN_COUNTRY) || '~' || to_char(pnLOC_ID_ORIGIN) || '~' ||
        to_char(pnDIM_ID1) || '~' || to_char(pnDIM_ID2) || '~' || to_char(pnDIM_ID3) || '~' ||
        to_char(pnDIM_ID4) || '~' || to_char(pnDIM_ID5) || '~' ||
        psSEX_CODE || '~' || to_char(pnAGR_ID) || '~' || to_char(pnPPG_ID) || '~' ||
        psForceUpdateFlag);
  --
  -- Get current column values for statistic record.
  --
    select START_DATE, END_DATE, STCT_CODE, DST_ID,
      LOC_ID_ASYLUM_COUNTRY, LOC_ID_ASYLUM, LOC_ID_ORIGIN_COUNTRY, LOC_ID_ORIGIN,
      DIM_ID1, DIM_ID2, DIM_ID3, DIM_ID4, DIM_ID5, SEX_CODE, AGR_ID,
      PPG_ID, VALUE, VERSION_NBR, rowid
    into dSTART_DATE, dEND_DATE, sSTCT_CODE, nDST_ID,
      nLOC_ID_ASYLUM_COUNTRY, nLOC_ID_ASYLUM, nLOC_ID_ORIGIN_COUNTRY, nLOC_ID_ORIGIN,
      nDIM_ID1, nDIM_ID2, nDIM_ID3, nDIM_ID4, nDIM_ID5, sSEX_CODE, nAGR_ID,
      nPPG_ID, nVALUE, nVERSION_NBR, xSTC_ROWID
    from T_STATISTICS
    where ID = pnSTC_ID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
    --
    -- Check if an update of the statistic record is required.
    --
      if pnVALUE != nVALUE
        or pdSTART_DATE != dSTART_DATE
        or pdEND_DATE != dSTART_DATE
        or psSTCT_CODE != sSTCT_CODE
        or pnDST_ID != nDST_ID
        or (nvl(pnLOC_ID_ASYLUM_COUNTRY, 0) != -1
          and nvl(pnLOC_ID_ASYLUM_COUNTRY, 0) != nvl(nLOC_ID_ASYLUM_COUNTRY, 0))
        or (nvl(pnLOC_ID_ASYLUM, 0) != -1
          and nvl(pnLOC_ID_ASYLUM, 0) != nvl(nLOC_ID_ASYLUM, 0))
        or (nvl(pnLOC_ID_ORIGIN_COUNTRY, 0) != -1
          and nvl(pnLOC_ID_ORIGIN_COUNTRY, 0) != nvl(nLOC_ID_ORIGIN_COUNTRY, 0))
        or (nvl(pnLOC_ID_ORIGIN, 0) != -1
          and nvl(pnLOC_ID_ORIGIN, 0) != nvl(nLOC_ID_ORIGIN, 0))
        or (nvl(pnDIM_ID1, 0) != -1
          and nvl(pnDIM_ID1, 0) != nvl(nDIM_ID1, 0))
        or (nvl(pnDIM_ID2, 0) != -1
          and nvl(pnDIM_ID2, 0) != nvl(nDIM_ID2, 0))
        or (nvl(pnDIM_ID3, 0) != -1
          and nvl(pnDIM_ID3, 0) != nvl(nDIM_ID3, 0))
        or (nvl(pnDIM_ID4, 0) != -1
          and nvl(pnDIM_ID4, 0) != nvl(nDIM_ID4, 0))
        or (nvl(pnDIM_ID5, 0) != -1
          and nvl(pnDIM_ID5, 0) != nvl(nDIM_ID5, 0))
        or (nvl(psSEX_CODE, 'xx') != 'x'
          and nvl(psSEX_CODE, 'x') != nvl(psSEX_CODE, 'x'))
        or (nvl(pnAGR_ID, 0) != -1
          and nvl(pnAGR_ID, 0) != nvl(nAGR_ID, 0))
        or (nvl(pnPPG_ID, 0) != -1
          and nvl(pnPPG_ID, 0) != nvl(nPPG_ID, 0))
        or psForceUpdateFlag = 'Y'
      then
      --
      -- Check the validity of the updated dimension(s) and update statistic record.
      --
        VALIDATE_STATISTIC_DIMENSIONS
         (nvl(psSTCT_CODE, sSTCT_CODE),
          pnDST_ID, pnLOC_ID_ASYLUM_COUNTRY, pnLOC_ID_ASYLUM, pnLOC_ID_ORIGIN_COUNTRY, pnLOC_ID_ORIGIN,
          pnDIM_ID1, pnDIM_ID2, pnDIM_ID3, pnDIM_ID4, pnDIM_ID5, psSEX_CODE, pnAGR_ID);
      --
        update T_STATISTICS
        set VALUE = pnVALUE,
          START_DATE = nvl(pdSTART_DATE, START_DATE),
          END_DATE = nvl(pdEND_DATE, END_DATE),
          STCT_CODE = nvl(psSTCT_CODE, STCT_CODE),
          DST_ID = nvl(pnDST_ID, DST_ID),
          LOC_ID_ASYLUM_COUNTRY =
            case
              when pnLOC_ID_ASYLUM_COUNTRY = -1 then LOC_ID_ASYLUM_COUNTRY
              else pnLOC_ID_ASYLUM_COUNTRY
            end,
          LOC_ID_ASYLUM =
            case when pnLOC_ID_ASYLUM = -1 then LOC_ID_ASYLUM else pnLOC_ID_ASYLUM end,
          LOC_ID_ORIGIN_COUNTRY =
            case
              when pnLOC_ID_ORIGIN_COUNTRY = -1 then LOC_ID_ORIGIN_COUNTRY
              else pnLOC_ID_ORIGIN_COUNTRY
            end,
          LOC_ID_ORIGIN =
            case when pnLOC_ID_ORIGIN = -1 then LOC_ID_ORIGIN else pnLOC_ID_ORIGIN end,
          DIM_ID1 = case when pnDIM_ID1 = -1 then DIM_ID1 else pnDIM_ID1 end,
          DIM_ID2 = case when pnDIM_ID2 = -1 then DIM_ID2 else pnDIM_ID2 end,
          DIM_ID3 = case when pnDIM_ID3 = -1 then DIM_ID3 else pnDIM_ID3 end,
          DIM_ID4 = case when pnDIM_ID4 = -1 then DIM_ID4 else pnDIM_ID4 end,
          DIM_ID5 = case when pnDIM_ID5 = -1 then DIM_ID5 else pnDIM_ID5 end,
          SEX_CODE = case when psSEX_CODE = 'x' then SEX_CODE else psSEX_CODE end,
          AGR_ID = case when pnAGR_ID = -1 then AGR_ID else pnAGR_ID end,
          PPG_ID = case when pnPPG_ID = -1 then PPG_ID else pnPPG_ID end,
          VERSION_NBR = VERSION_NBR + 1
        where rowid = xSTC_ROWID
        returning VERSION_NBR into pnVERSION_NBR;
      end if;
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
   (pnSTC_ID in out P_BASE.tnSTC_ID,
    pnVERSION_NBR in out P_BASE.tnSTC_VERSION_NBR,
    pnVALUE in P_BASE.tmnSTC_VALUE,
    pdSTART_DATE in P_BASE.tdDate := null,
    pdEND_DATE in P_BASE.tdDate := null,
    psSTCT_CODE in P_BASE.tsSTCT_CODE := null,
    pnDST_ID in P_BASE.tnDST_ID := null,
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
    pnPPG_ID in P_BASE.tnPPG_ID := -1,
    pnSTG_ID_PRIMARY in P_BASE.tnSTG_ID := null)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_STATISTIC',
      to_char(pnSTC_ID) || '~' || to_char(pnVERSION_NBR) || '~' ||  to_char(pnVALUE) || '~' ||
        to_char(pdSTART_DATE, 'YYYY-MM-DD')  || '~' || to_char(pdEND_DATE, 'YYYY-MM-DD')  || '~' ||
        psSTCT_CODE || '~' || to_char(pnDST_ID) || '~' ||
        to_char(pnLOC_ID_ASYLUM_COUNTRY) || '~' || to_char(pnLOC_ID_ASYLUM) || '~' ||
        to_char(pnLOC_ID_ORIGIN_COUNTRY) || '~' || to_char(pnLOC_ID_ORIGIN) || '~' ||
        to_char(pnDIM_ID1) || '~' || to_char(pnDIM_ID2) || '~' || to_char(pnDIM_ID3) || '~' ||
        to_char(pnDIM_ID4) || '~' || to_char(pnDIM_ID5) || '~' ||
        psSEX_CODE || '~' || to_char(pnAGR_ID) || '~' || to_char(pnPPG_ID) || '~' ||
       to_char(pnSTG_ID_PRIMARY));
  --
  --
    if pnVERSION_NBR is null
    then
      if pnSTC_ID is not null
      then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'Version number must be specified');
      else
        INSERT_STATISTIC
         (pnSTC_ID, pnVALUE, pdSTART_DATE, pdEND_DATE, psSTCT_CODE, pnDST_ID,
          case when pnLOC_ID_ASYLUM_COUNTRY = -1 then null else pnLOC_ID_ASYLUM_COUNTRY end,
          case when pnLOC_ID_ASYLUM = -1 then null else pnLOC_ID_ASYLUM end,
          case when pnLOC_ID_ORIGIN_COUNTRY = -1 then null else pnLOC_ID_ORIGIN_COUNTRY end,
          case when pnLOC_ID_ORIGIN = -1 then null else pnLOC_ID_ORIGIN end,
          case when pnDIM_ID1 = -1 then null else pnDIM_ID1 end,
          case when pnDIM_ID2 = -1 then null else pnDIM_ID2 end,
          case when pnDIM_ID3 = -1 then null else pnDIM_ID3 end,
          case when pnDIM_ID4 = -1 then null else pnDIM_ID4 end,
          case when pnDIM_ID5 = -1 then null else pnDIM_ID5 end,
          case when psSEX_CODE = 'x' then null else psSEX_CODE end,
          case when pnAGR_ID = -1 then null else pnAGR_ID end,
          case when pnPPG_ID = -1 then null else pnPPG_ID end,
          pnSTG_ID_PRIMARY);
      --
        pnVERSION_NBR := 1;
      end if;
    elsif pnVALUE is null
    then DELETE_STATISTIC(pnSTC_ID, pnVERSION_NBR);
    else
      UPDATE_STATISTIC
       (pnSTC_ID, pnVERSION_NBR, pnVALUE, pdSTART_DATE, pdEND_DATE, psSTCT_CODE, pnDST_ID,
        pnLOC_ID_ASYLUM_COUNTRY, pnLOC_ID_ASYLUM, pnLOC_ID_ORIGIN_COUNTRY, pnLOC_ID_ORIGIN,
        pnDIM_ID1, pnDIM_ID2, pnDIM_ID3, pnDIM_ID4, pnDIM_ID5, psSEX_CODE, pnAGR_ID, pnPPG_ID);
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
   (pnSTC_ID in P_BASE.tmnSTC_ID,
    pnVERSION_NBR in P_BASE.tnSTC_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnSTC_VERSION_NBR;
    xSTC_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_STATISTIC',
      to_char(pnSTC_ID) || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xSTC_ROWID
    from T_STATISTICS
    where ID = pnSTC_ID
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
   (pnSTC_ID in P_BASE.tmnSTC_ID,
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
      to_char(pnSTC_ID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' ||
        psLANG_CODE || '~' || to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xSTC_ROWID
    from T_STATISTICS
    where ID = pnSTC_ID
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
   (pnSTC_ID in P_BASE.tmnSTC_ID,
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
      to_char(pnSTC_ID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xSTC_ROWID
    from T_STATISTICS
    where ID = pnSTC_ID
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
  if sVersion != 'D1.0'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
end P_STATISTIC;
/

show errors
