CREATE OR REPLACE PACKAGE BODY "P_PF" is

--
-- ========================================
-- Private program units
-- ========================================
--
-- Wrapper for P_STATISTIC.SET_STATISTIC procedure, adding functionality to create a linkage to the
-- statistic group covering all the statistics in that PF table for the given row's year and
-- country.
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
    pnLOC_ID_ORIGIN_COUNTRY in P_BASE.tnLOC_ID := -1,
    pnDIM_ID1 in P_BASE.tnDIM_ID := -1,
    pnPPG_ID in P_BASE.tnPPG_ID := -1,
    pnSTG_ID_PRIMARY in P_BASE.tmnSTG_ID,
    pnSTG_ID_PFCOUNTRY in P_BASE.tmnSTG_ID)
  is
    bNewStatistic boolean := (pnSTC_ID is null);
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_STATISTIC',
      to_char(pnSTC_ID) || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnVALUE) || '~' ||
        to_char(pdSTART_DATE, 'YYYY-MM-DD')  || '~' || to_char(pdEND_DATE, 'YYYY-MM-DD')  || '~' ||
        psSTCT_CODE || '~' || to_char(pnDST_ID) || '~' ||
        to_char(pnLOC_ID_ASYLUM_COUNTRY) || '~' ||
        to_char(pnLOC_ID_ORIGIN_COUNTRY) || '~' ||
        to_char(pnPPG_ID) || '~' ||
        to_char(pnSTG_ID_PRIMARY) || '~' || to_char(pnSTG_ID_PFCOUNTRY));
  --
    P_STATISTIC.SET_STATISTIC
     (pnSTC_ID => pnSTC_ID,
      pnVERSION_NBR =>  pnVERSION_NBR,
      pnVALUE => pnVALUE,
      pdSTART_DATE => pdSTART_DATE,
      pdEND_DATE =>  pdEND_DATE,
      psSTCT_CODE => psSTCT_CODE,
      pnDST_ID => pnDST_ID,
      pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY ,
      pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
      pnDIM_ID1 => pnDIM_ID1,
      pnPPG_ID => pnPPG_ID,
      pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY );
  --
    if bNewStatistic
    then P_STATISTIC.INSERT_STATISTIC_IN_GROUP(pnSTC_ID, pnSTG_ID_PFCOUNTRY);
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_STATISTIC;
--
-- ----------------------------------------
-- GET_COUNTRY_STATISTIC_GROUP
-- ----------------------------------------
--
-- Given the identifer of the statistic group representing a row in an PF table (the primary
-- statistic group), get the identifier and version number of the statistic group covering all
-- the statistics in PF for the given row's year and country. If the required 
-- statistic group does not exist, it is created.
--
-- Parameters:
--  pnSTG_ID - Identifier of statistic group covering the whole table (returned).
--  pnVERSION_NBR - Update version number of statistic group record covering the whole table
--    (returned).
--  pnSTG_ID_PRIMARY - Identifier of the primary statistic group for the PF table row.

--
  procedure GET_COUNTRY_STATISTIC_GROUP
   (pnSTG_ID out P_BASE.tnSTG_ID,
    pnVERSION_NBR out P_BASE.tnSTG_VERSION_NBR,
    pnSTG_ID_PRIMARY in P_BASE.tnSTG_ID := null,
    pnLOC_ID_ASYLUM_COUNTRY in P_BASE.tnLOC_ID := null,
    pdSTART_DATE in P_BASE.tdDate := null,
    pdEND_DATE in P_BASE.tdDate := null
)
  is
    dSTART_DATE P_BASE.tdDate := pdSTART_DATE;
    dEND_DATE P_BASE.tdDate   := pdEND_DATE;
    sSTTG_CODE P_BASE.tmsSTTG_CODE := 'PF';
    nLOC_ID_ASYLUM_COUNTRY P_BASE.tnLOC_ID := pnLOC_ID_ASYLUM_COUNTRY;
    nCountGroup number;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.GET_COUNTRY_STATISTIC_GROUP',
      '~~' || to_char(pnSTG_ID_PRIMARY) ||
      '~~' || to_char(pnLOC_ID_ASYLUM_COUNTRY) ||
      '~~' || to_char(pdSTART_DATE) ||
      '~~' || to_char(pdEND_DATE) 
       );
  --
    if (pnSTG_ID_PRIMARY is null 
        and (pnLOC_ID_ASYLUM_COUNTRY is null or pdSTART_DATE is null  or pdEND_DATE is null)
        ) 
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Incorrect parameters');
    end if;
 
  --
    if pnSTG_ID_PRIMARY is not null
    then 
        select STG1.START_DATE, STG1.END_DATE, STG1.LOC_ID_ASYLUM_COUNTRY
          into dSTART_DATE, dEND_DATE, nLOC_ID_ASYLUM_COUNTRY
          from T_STATISTIC_GROUPS STG1
         where STG1.ID = pnSTG_ID_PRIMARY; 
    end if;

    select max(STG2.ID), max(STG2.VERSION_NBR), count(*)  -- use max to avoid no_data_found
      into pnSTG_ID, pnVERSION_NBR, nCountGroup
      from T_STATISTIC_GROUPS STG2
     where STG2.START_DATE = dSTART_DATE
       and STG2.END_DATE   = dEND_DATE
       and nvl(STG2.STTG_CODE, 'x') = sSTTG_CODE
       and STG2.LOC_ID_ASYLUM_COUNTRY = nLOC_ID_ASYLUM_COUNTRY
       and nvl(STG2.DST_ID, 0) = 0
       and nvl(STG2.LOC_ID_ASYLUM, 0) = 0
       and nvl(STG2.LOC_ID_ORIGIN, 0) = 0
       and nvl(STG2.DIM_ID1, 0) = 0
       and nvl(STG2.DIM_ID2, 0) = 0
       and nvl(STG2.DIM_ID3, 0) = 0
       and nvl(STG2.DIM_ID4, 0) = 0
       and nvl(STG2.DIM_ID5, 0) = 0
       and nvl(STG2.SEX_CODE, 'x') = 'x'
       and nvl(STG2.AGR_ID, 0) = 0
       and STG2.SEQ_NBR is null;
  -- 
    if nCountGroup > 1 
    then
        raise_application_error(-20101, 'Multiple PF statistic groups found for that country and year');
    end if;
  --
  -- Create new statistic group covering the whole table when it doesn't already exist.
  --
    if pnSTG_ID is null
    then
      P_STATISTIC_GROUP.INSERT_STATISTIC_GROUP
       (pnSTG_ID, dSTART_DATE, dEND_DATE, sSTTG_CODE,
        pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY);
    --
      pnVERSION_NBR := 1;
    end if;
  --
    P_UTILITY.TRACE_CONTEXT
     (to_char(pnSTG_ID) || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnSTG_ID_PRIMARY));
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end GET_COUNTRY_STATISTIC_GROUP;
--
--
-- ----------------------------------------
-- DELETE_PF_ROW
-- ----------------------------------------
--
  procedure DELETE_PF_ROW
   (pnSTG_ID_PRIMARY in P_BASE.tmnSTG_ID,
    pnSTG_VERSION_NBR in P_BASE.tmnSTG_VERSION_NBR)
  is
    nSTG_VERSION_NBR P_BASE.tnSTG_VERSION_NBR := pnSTG_VERSION_NBR;
  --
    nSTG_ID_PFCOUNTRY P_BASE.tnSTG_ID;
    nSTG_VERSION_NBR_TABLE P_BASE.tnSTG_VERSION_NBR;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_PF_ROW',
      to_char(pnSTG_ID_PRIMARY)  || '~' || to_char(pnSTG_VERSION_NBR));
  --
  -- Get identifier and version number of statistic group representing the whole table for
  --  this PF table, year and country.
  --
    GET_COUNTRY_STATISTIC_GROUP(nSTG_ID_PFCOUNTRY, nSTG_VERSION_NBR_TABLE, pnSTG_ID_PRIMARY);
  --
  -- Delete the whole set of statistics in this PF table row.
  --
    for rSTC in
     (select ID, VERSION_NBR
      from T_STATISTICS
      where STG_ID_PRIMARY = pnSTG_ID_PRIMARY)
    loop
      P_STATISTIC.DELETE_STATISTIC(rSTC.ID, rSTC.VERSION_NBR);
    end loop;
  --
  -- Delete the primary statistic group.
  --
    P_STATISTIC_GROUP.DELETE_STATISTIC_GROUP(pnSTG_ID_PRIMARY, nSTG_VERSION_NBR);
  --  -- Update the statistic group for the whole PF table to record latest update details.
  --
    P_STATISTIC_GROUP.UPDATE_STATISTIC_GROUP(nSTG_ID_PFCOUNTRY, nSTG_VERSION_NBR_TABLE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_PF_ROW;
--
-- ----------------------------------------
-- SET_FOCAL_POINT
-- ----------------------------------------
-- 
procedure SET_FOCAL_POINT
  (pnPF_YEAR in P_BASE.tmnYear
 , pnLOC_ID_ASYLUM_COUNTRY in P_BASE.tmnLOC_ID
 , psFOCAL_POINT_NAME in  P_BASE.tsSTGA_CHAR_VALUE
 , pnNAME_VERSION_NBR in out P_BASE.tnSTGA_VERSION_NBR
 , psFOCAL_POINT_EMAIL in  P_BASE.tsSTGA_CHAR_VALUE
 , pnEMAIL_VERSION_NBR in out P_BASE.tnSTGA_VERSION_NBR
 )
is
     dSTART_DATE P_BASE.tdDate := to_date(to_char(pnPF_YEAR) || '-01-01', 'YYYY-MM-DD');
     dEND_DATE P_BASE.tdDate := to_date(to_char(pnPF_YEAR + 1) || '-01-01', 'YYYY-MM-DD');
     nSTG_ID_PFCOUNTRY P_BASE.tnSTG_ID;
     nSTG_VERSION P_BASE.tnSTG_VERSION_NBR;
begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_FOCAL_POINT',
      to_char(pnPF_YEAR)  || '~' || to_char(pnLOC_ID_ASYLUM_COUNTRY));
--
    GET_COUNTRY_STATISTIC_GROUP(
        pnSTG_ID => nSTG_ID_PFCOUNTRY
      , pnVERSION_NBR => nSTG_VERSION
      , pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY
      , pdSTART_DATE => dSTART_DATE
      , pdEND_DATE => dEND_DATE);
--
--  Focal Point Name 
    P_STATISTIC_GROUP.SET_STG_ATTRIBUTE (
        pnSTG_ID => nSTG_ID_PFCOUNTRY,
        psSTGAT_CODE => 'FPTNAME',
        pnVERSION_NBR => pnNAME_VERSION_NBR,
        psCHAR_VALUE => psFOCAL_POINT_NAME
    );
--  Focal Point Email 
    P_STATISTIC_GROUP.SET_STG_ATTRIBUTE (
        pnSTG_ID => nSTG_ID_PFCOUNTRY,
        psSTGAT_CODE => 'FPTMAIL',
        pnVERSION_NBR => pnEMAIL_VERSION_NBR,
        psCHAR_VALUE => psFOCAL_POINT_EMAIL
    );
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_FOCAL_POINT;
--
-- ----------------------------------------
-- INSERT_PF_PFPOC
-- ----------------------------------------
-- 
procedure INSERT_PF_PFPOC
  (pnPF_YEAR in P_BASE.tmnYear
 , pnLOC_ID_ORIGIN_COUNTRY in P_BASE.tmnLOC_ID
 , pnLOC_ID_ASYLUM_COUNTRY in P_BASE.tnLOC_ID
 , pnDST_ID in P_BASE.tmnDST_ID
 , pnPPG_ID in P_BASE.tnPPG_ID := null
 , pnPFPOCPY_VALUE in P_BASE.tnSTC_VALUE
 , pnPFPOCPY_AH_VALUE in P_BASE.tnSTC_VALUE
 , pnPFPOCCY_VALUE in P_BASE.tnSTC_VALUE
 , pnPFPOCCY_AH_VALUE in P_BASE.tnSTC_VALUE
 , pnPFPOCNY_VALUE in P_BASE.tnSTC_VALUE
 , pnPFPOCNY_AH_VALUE in P_BASE.tnSTC_VALUE
 )
   is
     dSTART_DATE P_BASE.tdDate := to_date(to_char(pnPF_YEAR) || '-01-01', 'YYYY-MM-DD');
     dEND_DATE P_BASE.tdDate := to_date(to_char(pnPF_YEAR + 1) || '-01-01', 'YYYY-MM-DD');
     nSTG_ID_PFCOUNTRY P_BASE.tnSTG_ID;
     nSTG_VERSION_NBR_TABLE P_BASE.tnSTG_VERSION_NBR;
     nSTG_ID_PRIMARY P_BASE.tnSTG_ID;
     nPFPOCPY_STC_ID P_BASE.tnSTC_ID;
     nPFPOCPY_VERSION_NBR P_BASE.tnSTC_VERSION_NBR;
     nPFPOCPY_AH_STC_ID P_BASE.tnSTC_ID;
     nPFPOCPY_AH_VERSION_NBR P_BASE.tnSTC_VERSION_NBR;
     nPFPOCCY_STC_ID P_BASE.tnSTC_ID;
     nPFPOCCY_VERSION_NBR P_BASE.tnSTC_VERSION_NBR;
     nPFPOCCY_AH_STC_ID P_BASE.tnSTC_ID;
     nPFPOCCY_AH_VERSION_NBR P_BASE.tnSTC_VERSION_NBR;
     nPFPOCNY_STC_ID P_BASE.tnSTC_ID;
     nPFPOCNY_VERSION_NBR P_BASE.tnSTC_VERSION_NBR;
     nPFPOCNY_AH_STC_ID P_BASE.tnSTC_ID;
     nPFPOCNY_AH_VERSION_NBR P_BASE.tnSTC_VERSION_NBR;
  begin
   P_UTILITY.START_MODULE 
   (sVersion || '-' || sComponent || '.INSERT_PF_PFPOC', 
   to_char(pnPF_YEAR)  || '~' || to_char(pnLOC_ID_ORIGIN_COUNTRY) 
   || '~' || to_char(pnLOC_ID_ASYLUM_COUNTRY) 
 || '~' || to_char(pnDST_ID) 
   || '~' || to_char(pnPPG_ID) 
   || '~' || to_char(pnPFPOCPY_VALUE) 
   || '~' || to_char(pnPFPOCPY_AH_VALUE) 
   || '~' || to_char(pnPFPOCCY_VALUE) 
   || '~' || to_char(pnPFPOCCY_AH_VALUE) 
   || '~' || to_char(pnPFPOCNY_VALUE) 
   || '~' || to_char(pnPFPOCNY_AH_VALUE) 
   );
    --
    -- Check that UNHCR-assisted value is not greater than total value.
    --
    if pnPFPOCPY_AH_VALUE > pnPFPOCPY_VALUE
        then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'UNHCR-assisted value may not be greater than total value');
    end if;
    if pnPFPOCCY_AH_VALUE > pnPFPOCCY_VALUE
        then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'UNHCR-assisted value may not be greater than total value');
    end if;
    if pnPFPOCNY_AH_VALUE > pnPFPOCNY_VALUE
        then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'UNHCR-assisted value may not be greater than total value');
    end if;
    --
    -- Create new statistic group representing this PFPOC table row
    --
    P_STATISTIC_GROUP.INSERT_STATISTIC_GROUP
    (nSTG_ID_PRIMARY, dSTART_DATE, dEND_DATE, 'PFPOC',
    pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
    pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY
  , pnDST_ID => pnDST_ID
  , pnPPG_ID => pnPPG_ID
    );
    --
    -- Get identifier and version number of statistic group representing the whole PF data for
    --  this year and country, creating a new statistic group for this purpose if necessary.
    --
  GET_COUNTRY_STATISTIC_GROUP(nSTG_ID_PFCOUNTRY, nSTG_VERSION_NBR_TABLE, nSTG_ID_PRIMARY);
    --
    -- Create statistics and link them to the statistic
    --  group for the table.
    --
    if pnPFPOCPY_VALUE is not null
    then
    SET_STATISTIC
    (nPFPOCPY_STC_ID, pnVERSION_NBR => nPFPOCPY_VERSION_NBR,  psSTCT_CODE => 'PFPOCPY', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
    pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
    pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
    pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY,
    pnPPG_ID => pnPPG_ID,
    pnVALUE => pnPFPOCPY_VALUE,
    pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
    end if;
    --
    if pnPFPOCPY_AH_VALUE is not null
    then
    SET_STATISTIC
    (nPFPOCPY_AH_STC_ID, pnVERSION_NBR => nPFPOCPY_AH_VERSION_NBR,  psSTCT_CODE => 'PFPOCPY-AH', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
    pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
    pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
    pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY,
    pnPPG_ID => pnPPG_ID,
    pnVALUE => pnPFPOCPY_AH_VALUE,
    pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
    end if;
    --
    if pnPFPOCCY_VALUE is not null
    then
    SET_STATISTIC
    (nPFPOCCY_STC_ID, pnVERSION_NBR => nPFPOCCY_VERSION_NBR,  psSTCT_CODE => 'PFPOCCY', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
    pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
    pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
    pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY,
    pnPPG_ID => pnPPG_ID,
    pnVALUE => pnPFPOCCY_VALUE,
    pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
    end if;
    --
    if pnPFPOCCY_AH_VALUE is not null
    then
    SET_STATISTIC
    (nPFPOCCY_AH_STC_ID, pnVERSION_NBR => nPFPOCCY_AH_VERSION_NBR,  psSTCT_CODE => 'PFPOCCY-AH', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
    pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
    pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
    pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY,
    pnPPG_ID => pnPPG_ID,
    pnVALUE => pnPFPOCCY_AH_VALUE,
    pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
    end if;
    --
    if pnPFPOCNY_VALUE is not null
    then
    SET_STATISTIC
    (nPFPOCNY_STC_ID, pnVERSION_NBR => nPFPOCNY_VERSION_NBR,  psSTCT_CODE => 'PFPOCNY', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
    pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
    pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
    pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY,
    pnPPG_ID => pnPPG_ID,
    pnVALUE => pnPFPOCNY_VALUE,
    pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
    end if;
    --
    if pnPFPOCNY_AH_VALUE is not null
    then
    SET_STATISTIC
    (nPFPOCNY_AH_STC_ID, pnVERSION_NBR => nPFPOCNY_AH_VERSION_NBR,  psSTCT_CODE => 'PFPOCNY-AH', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
    pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
    pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
    pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY,
    pnPPG_ID => pnPPG_ID,
    pnVALUE => pnPFPOCNY_AH_VALUE,
    pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
    end if;
    --
    P_UTILITY.END_MODULE;
    exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_PF_PFPOC;
--
-- ----------------------------------------
-- UPDATE_PF_PFPOC
-- ----------------------------------------
-- 
procedure UPDATE_PF_PFPOC
  (pnSTG_ID_PRIMARY in P_BASE.tmnSTG_ID
 , pnSTG_VERSION_NBR in P_BASE.tmnSTG_VERSION_NBR
 , pnLOC_ID_ORIGIN_COUNTRY in P_BASE.tmnLOC_ID
 , pnDST_ID in P_BASE.tmnDST_ID
 , pnPPG_ID in P_BASE.tnPPG_ID := null
 , pnPFPOCPY_VALUE in P_BASE.tnSTC_VALUE
 , pnPFPOCPY_STC_ID in P_BASE.tnSTC_ID
 , pnPFPOCPY_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR
 , pnPFPOCPY_AH_VALUE in P_BASE.tnSTC_VALUE
 , pnPFPOCPY_AH_STC_ID in P_BASE.tnSTC_ID
 , pnPFPOCPY_AH_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR
 , pnPFPOCCY_VALUE in P_BASE.tnSTC_VALUE
 , pnPFPOCCY_STC_ID in P_BASE.tnSTC_ID
 , pnPFPOCCY_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR
 , pnPFPOCCY_AH_VALUE in P_BASE.tnSTC_VALUE
 , pnPFPOCCY_AH_STC_ID in P_BASE.tnSTC_ID
 , pnPFPOCCY_AH_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR
 , pnPFPOCNY_VALUE in P_BASE.tnSTC_VALUE
 , pnPFPOCNY_STC_ID in P_BASE.tnSTC_ID
 , pnPFPOCNY_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR
 , pnPFPOCNY_AH_VALUE in P_BASE.tnSTC_VALUE
 , pnPFPOCNY_AH_STC_ID in P_BASE.tnSTC_ID
 , pnPFPOCNY_AH_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR
 )
  is
     nSTG_VERSION_NBR P_BASE.tnSTG_VERSION_NBR := pnSTG_VERSION_NBR;
     dSTART_DATE P_BASE.tdDate;
     dEND_DATE P_BASE.tdDate;
     nLOC_ID_ASYLUM_COUNTRY P_BASE.tnLOC_ID;
     nPFPOCPY_STC_ID P_BASE.tnSTC_ID := pnPFPOCPY_STC_ID;
     nPFPOCPY_VERSION_NBR P_BASE.tnSTC_VERSION_NBR := pnPFPOCPY_VERSION_NBR;
     nPFPOCPY_AH_STC_ID P_BASE.tnSTC_ID := pnPFPOCPY_AH_STC_ID;
     nPFPOCPY_AH_VERSION_NBR P_BASE.tnSTC_VERSION_NBR := pnPFPOCPY_AH_VERSION_NBR;
     nPFPOCCY_STC_ID P_BASE.tnSTC_ID := pnPFPOCCY_STC_ID;
     nPFPOCCY_VERSION_NBR P_BASE.tnSTC_VERSION_NBR := pnPFPOCCY_VERSION_NBR;
     nPFPOCCY_AH_STC_ID P_BASE.tnSTC_ID := pnPFPOCCY_AH_STC_ID;
     nPFPOCCY_AH_VERSION_NBR P_BASE.tnSTC_VERSION_NBR := pnPFPOCCY_AH_VERSION_NBR;
     nPFPOCNY_STC_ID P_BASE.tnSTC_ID := pnPFPOCNY_STC_ID;
     nPFPOCNY_VERSION_NBR P_BASE.tnSTC_VERSION_NBR := pnPFPOCNY_VERSION_NBR;
     nPFPOCNY_AH_STC_ID P_BASE.tnSTC_ID := pnPFPOCNY_AH_STC_ID;
     nPFPOCNY_AH_VERSION_NBR P_BASE.tnSTC_VERSION_NBR := pnPFPOCNY_AH_VERSION_NBR;
  --
  nSTG_ID_PFCOUNTRY P_BASE.tnSTG_ID;
  nSTG_VERSION_NBR_TABLE P_BASE.tnSTG_VERSION_NBR;
  begin
   P_UTILITY.START_MODULE 
   (sVersion || '-' || sComponent || '.UPDATE_PF_PFPOC', 
   to_char(pnSTG_ID_PRIMARY)
   || '~' || to_char(pnSTG_VERSION_NBR)
 || '~' || to_char(pnDST_ID) 
   || '~' || to_char(pnPPG_ID) 
   || '~' || to_char(pnPFPOCPY_VALUE) 
   || '~' || to_char(pnPFPOCPY_STC_ID) 
   || '~' || to_char(pnPFPOCPY_VERSION_NBR) 
   || '~' || to_char(pnPFPOCPY_AH_VALUE) 
   || '~' || to_char(pnPFPOCPY_AH_STC_ID) 
   || '~' || to_char(pnPFPOCPY_AH_VERSION_NBR) 
   || '~' || to_char(pnPFPOCCY_VALUE) 
   || '~' || to_char(pnPFPOCCY_STC_ID) 
   || '~' || to_char(pnPFPOCCY_VERSION_NBR) 
   || '~' || to_char(pnPFPOCCY_AH_VALUE) 
   || '~' || to_char(pnPFPOCCY_AH_STC_ID) 
   || '~' || to_char(pnPFPOCCY_AH_VERSION_NBR) 
   || '~' || to_char(pnPFPOCNY_VALUE) 
   || '~' || to_char(pnPFPOCNY_STC_ID) 
   || '~' || to_char(pnPFPOCNY_VERSION_NBR) 
   || '~' || to_char(pnPFPOCNY_AH_VALUE) 
   || '~' || to_char(pnPFPOCNY_AH_STC_ID) 
   || '~' || to_char(pnPFPOCNY_AH_VERSION_NBR) 
);
    --
    -- Check that UNHCR-assisted value is not greater than total value.
    --
    if pnPFPOCPY_AH_VALUE > pnPFPOCPY_VALUE
        then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'UNHCR-assisted value may not be greater than total value');
    end if;
    if pnPFPOCCY_AH_VALUE > pnPFPOCCY_VALUE
        then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'UNHCR-assisted value may not be greater than total value');
    end if;
    if pnPFPOCNY_AH_VALUE > pnPFPOCNY_VALUE
        then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'UNHCR-assisted value may not be greater than total value');
    end if;
    --
    -- Get identifier and version number of statistic group representing the whole  whole PF data for
    --  this year and country.
    --
  GET_COUNTRY_STATISTIC_GROUP(nSTG_ID_PFCOUNTRY, nSTG_VERSION_NBR_TABLE, pnSTG_ID_PRIMARY);
   --
   -- Get primary statistics group details for this stateless table row.
   --
   select START_DATE, END_DATE, LOC_ID_ASYLUM_COUNTRY
   into dSTART_DATE, dEND_DATE, nLOC_ID_ASYLUM_COUNTRY
   from T_STATISTIC_GROUPS
   where ID = pnSTG_ID_PRIMARY;
   --
   -- Insert, update or delete statistics.
   --
   SET_STATISTIC
   (nPFPOCPY_STC_ID, nPFPOCPY_VERSION_NBR,
   psSTCT_CODE => 'PFPOCPY', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
   pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
   pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
   pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
   pnPPG_ID => pnPPG_ID,
   pnVALUE => pnPFPOCPY_VALUE,
   pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
   --
   SET_STATISTIC
   (nPFPOCPY_AH_STC_ID, nPFPOCPY_AH_VERSION_NBR,
   psSTCT_CODE => 'PFPOCPY-AH', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
   pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
   pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
   pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
   pnPPG_ID => pnPPG_ID,
   pnVALUE => pnPFPOCPY_AH_VALUE,
   pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
   --
   SET_STATISTIC
   (nPFPOCCY_STC_ID, nPFPOCCY_VERSION_NBR,
   psSTCT_CODE => 'PFPOCCY', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
   pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
   pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
   pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
   pnPPG_ID => pnPPG_ID,
   pnVALUE => pnPFPOCCY_VALUE,
   pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
   --
   SET_STATISTIC
   (nPFPOCCY_AH_STC_ID, nPFPOCCY_AH_VERSION_NBR,
   psSTCT_CODE => 'PFPOCCY-AH', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
   pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
   pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
   pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
   pnPPG_ID => pnPPG_ID,
   pnVALUE => pnPFPOCCY_AH_VALUE,
   pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
   --
   SET_STATISTIC
   (nPFPOCNY_STC_ID, nPFPOCNY_VERSION_NBR,
   psSTCT_CODE => 'PFPOCNY', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
   pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
   pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
   pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
   pnPPG_ID => pnPPG_ID,
   pnVALUE => pnPFPOCNY_VALUE,
   pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
   --
   SET_STATISTIC
   (nPFPOCNY_AH_STC_ID, nPFPOCNY_AH_VERSION_NBR,
   psSTCT_CODE => 'PFPOCNY-AH', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
   pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
   pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
   pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
   pnPPG_ID => pnPPG_ID,
   pnVALUE => pnPFPOCNY_AH_VALUE,
   pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
   --
   -- Update primary statistic group and statistic group representing the whole returnee table to
   --  record latest update time and user.
   --
   P_STATISTIC_GROUP.UPDATE_STATISTIC_GROUP(pnSTG_ID_PRIMARY, nSTG_VERSION_NBR, pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY
   , pnPPG_ID => pnPPG_ID
   , pnDST_ID => pnDST_ID
   );
   --
   -- Update statistic group representing the whole stateless table to record latest update details.
   --
   P_STATISTIC_GROUP.UPDATE_STATISTIC_GROUP(nSTG_ID_PFCOUNTRY, nSTG_VERSION_NBR_TABLE);
   --
    P_UTILITY.END_MODULE;
    exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end UPDATE_PF_PFPOC;
--
-- ----------------------------------------
-- INSERT_PF_RETSTOCK
-- ----------------------------------------
-- 
procedure INSERT_PF_RETSTOCK
  (pnPF_YEAR in P_BASE.tmnYear
 , pnLOC_ID_ORIGIN_COUNTRY in P_BASE.tmnLOC_ID
 , pnLOC_ID_ASYLUM_COUNTRY in P_BASE.tnLOC_ID
 , pnDST_ID in P_BASE.tmnDST_ID
 , pnRETSTOCKPY_VALUE in P_BASE.tnSTC_VALUE
 , pnRETSTOCKCY_VALUE in P_BASE.tnSTC_VALUE
 , pnRETSTOCKNY_VALUE in P_BASE.tnSTC_VALUE
 )
   is
     dSTART_DATE P_BASE.tdDate := to_date(to_char(pnPF_YEAR) || '-01-01', 'YYYY-MM-DD');
     dEND_DATE P_BASE.tdDate := to_date(to_char(pnPF_YEAR + 1) || '-01-01', 'YYYY-MM-DD');
     nSTG_ID_PFCOUNTRY P_BASE.tnSTG_ID;
     nSTG_VERSION_NBR_TABLE P_BASE.tnSTG_VERSION_NBR;
     nSTG_ID_PRIMARY P_BASE.tnSTG_ID;
     nRETSTOCKPY_STC_ID P_BASE.tnSTC_ID;
     nRETSTOCKPY_VERSION_NBR P_BASE.tnSTC_VERSION_NBR;
     nRETSTOCKCY_STC_ID P_BASE.tnSTC_ID;
     nRETSTOCKCY_VERSION_NBR P_BASE.tnSTC_VERSION_NBR;
     nRETSTOCKNY_STC_ID P_BASE.tnSTC_ID;
     nRETSTOCKNY_VERSION_NBR P_BASE.tnSTC_VERSION_NBR;
  begin
   P_UTILITY.START_MODULE 
   (sVersion || '-' || sComponent || '.INSERT_PF_RETSTOCK', 
   to_char(pnPF_YEAR)  || '~' || to_char(pnLOC_ID_ORIGIN_COUNTRY) 
   || '~' || to_char(pnLOC_ID_ASYLUM_COUNTRY) 
 || '~' || to_char(pnDST_ID) 
   || '~' || to_char(pnRETSTOCKPY_VALUE) 
   || '~' || to_char(pnRETSTOCKCY_VALUE) 
   || '~' || to_char(pnRETSTOCKNY_VALUE) 
   );
    --
    -- Check that UNHCR-assisted value is not greater than total value.
    --
    --
    -- Create new statistic group representing this RETSTOCK table row
    --
    P_STATISTIC_GROUP.INSERT_STATISTIC_GROUP
    (nSTG_ID_PRIMARY, dSTART_DATE, dEND_DATE, 'RETSTOCK',
    pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
    pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY
  , pnDST_ID => pnDST_ID
    );
    --
    -- Get identifier and version number of statistic group representing the whole PF data for
    --  this year and country, creating a new statistic group for this purpose if necessary.
    --
  GET_COUNTRY_STATISTIC_GROUP(nSTG_ID_PFCOUNTRY, nSTG_VERSION_NBR_TABLE, nSTG_ID_PRIMARY);
    --
    -- Create statistics and link them to the statistic
    --  group for the table.
    --
    if pnRETSTOCKPY_VALUE is not null
    then
    SET_STATISTIC
    (nRETSTOCKPY_STC_ID, pnVERSION_NBR => nRETSTOCKPY_VERSION_NBR,  psSTCT_CODE => 'RETSTOCKPY', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
    pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
    pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
    pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY,
    pnVALUE => pnRETSTOCKPY_VALUE,
    pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
    end if;
    --
    if pnRETSTOCKCY_VALUE is not null
    then
    SET_STATISTIC
    (nRETSTOCKCY_STC_ID, pnVERSION_NBR => nRETSTOCKCY_VERSION_NBR,  psSTCT_CODE => 'RETSTOCKCY', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
    pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
    pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
    pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY,
    pnVALUE => pnRETSTOCKCY_VALUE,
    pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
    end if;
    --
    if pnRETSTOCKNY_VALUE is not null
    then
    SET_STATISTIC
    (nRETSTOCKNY_STC_ID, pnVERSION_NBR => nRETSTOCKNY_VERSION_NBR,  psSTCT_CODE => 'RETSTOCKNY', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
    pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
    pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
    pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY,
    pnVALUE => pnRETSTOCKNY_VALUE,
    pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
    end if;
    --
    P_UTILITY.END_MODULE;
    exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_PF_RETSTOCK;
--
-- ----------------------------------------
-- UPDATE_PF_RETSTOCK
-- ----------------------------------------
-- 
procedure UPDATE_PF_RETSTOCK
  (pnSTG_ID_PRIMARY in P_BASE.tmnSTG_ID
 , pnSTG_VERSION_NBR in P_BASE.tmnSTG_VERSION_NBR
 , pnLOC_ID_ORIGIN_COUNTRY in P_BASE.tmnLOC_ID
 , pnDST_ID in P_BASE.tmnDST_ID
 , pnRETSTOCKPY_VALUE in P_BASE.tnSTC_VALUE
 , pnRETSTOCKPY_STC_ID in P_BASE.tnSTC_ID
 , pnRETSTOCKPY_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR
 , pnRETSTOCKCY_VALUE in P_BASE.tnSTC_VALUE
 , pnRETSTOCKCY_STC_ID in P_BASE.tnSTC_ID
 , pnRETSTOCKCY_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR
 , pnRETSTOCKNY_VALUE in P_BASE.tnSTC_VALUE
 , pnRETSTOCKNY_STC_ID in P_BASE.tnSTC_ID
 , pnRETSTOCKNY_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR
 )
  is
     nSTG_VERSION_NBR P_BASE.tnSTG_VERSION_NBR := pnSTG_VERSION_NBR;
     dSTART_DATE P_BASE.tdDate;
     dEND_DATE P_BASE.tdDate;
     nLOC_ID_ASYLUM_COUNTRY P_BASE.tnLOC_ID;
     nRETSTOCKPY_STC_ID P_BASE.tnSTC_ID := pnRETSTOCKPY_STC_ID;
     nRETSTOCKPY_VERSION_NBR P_BASE.tnSTC_VERSION_NBR := pnRETSTOCKPY_VERSION_NBR;
     nRETSTOCKCY_STC_ID P_BASE.tnSTC_ID := pnRETSTOCKCY_STC_ID;
     nRETSTOCKCY_VERSION_NBR P_BASE.tnSTC_VERSION_NBR := pnRETSTOCKCY_VERSION_NBR;
     nRETSTOCKNY_STC_ID P_BASE.tnSTC_ID := pnRETSTOCKNY_STC_ID;
     nRETSTOCKNY_VERSION_NBR P_BASE.tnSTC_VERSION_NBR := pnRETSTOCKNY_VERSION_NBR;
  --
  nSTG_ID_PFCOUNTRY P_BASE.tnSTG_ID;
  nSTG_VERSION_NBR_TABLE P_BASE.tnSTG_VERSION_NBR;
  begin
   P_UTILITY.START_MODULE 
   (sVersion || '-' || sComponent || '.UPDATE_PF_RETSTOCK', 
   to_char(pnSTG_ID_PRIMARY)
   || '~' || to_char(pnSTG_VERSION_NBR)
 || '~' || to_char(pnDST_ID) 
   || '~' || to_char(pnRETSTOCKPY_VALUE) 
   || '~' || to_char(pnRETSTOCKPY_STC_ID) 
   || '~' || to_char(pnRETSTOCKPY_VERSION_NBR) 
   || '~' || to_char(pnRETSTOCKCY_VALUE) 
   || '~' || to_char(pnRETSTOCKCY_STC_ID) 
   || '~' || to_char(pnRETSTOCKCY_VERSION_NBR) 
   || '~' || to_char(pnRETSTOCKNY_VALUE) 
   || '~' || to_char(pnRETSTOCKNY_STC_ID) 
   || '~' || to_char(pnRETSTOCKNY_VERSION_NBR) 
);
    --
    -- Check that UNHCR-assisted value is not greater than total value.
    --
    --
    -- Get identifier and version number of statistic group representing the whole  whole PF data for
    --  this year and country.
    --
  GET_COUNTRY_STATISTIC_GROUP(nSTG_ID_PFCOUNTRY, nSTG_VERSION_NBR_TABLE, pnSTG_ID_PRIMARY);
   --
   -- Get primary statistics group details for this stateless table row.
   --
   select START_DATE, END_DATE, LOC_ID_ASYLUM_COUNTRY
   into dSTART_DATE, dEND_DATE, nLOC_ID_ASYLUM_COUNTRY
   from T_STATISTIC_GROUPS
   where ID = pnSTG_ID_PRIMARY;
   --
   -- Insert, update or delete statistics.
   --
   SET_STATISTIC
   (nRETSTOCKPY_STC_ID, nRETSTOCKPY_VERSION_NBR,
   psSTCT_CODE => 'RETSTOCKPY', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
   pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
   pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
   pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
   pnVALUE => pnRETSTOCKPY_VALUE,
   pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
   --
   SET_STATISTIC
   (nRETSTOCKCY_STC_ID, nRETSTOCKCY_VERSION_NBR,
   psSTCT_CODE => 'RETSTOCKCY', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
   pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
   pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
   pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
   pnVALUE => pnRETSTOCKCY_VALUE,
   pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
   --
   SET_STATISTIC
   (nRETSTOCKNY_STC_ID, nRETSTOCKNY_VERSION_NBR,
   psSTCT_CODE => 'RETSTOCKNY', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
   pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
   pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
   pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
   pnVALUE => pnRETSTOCKNY_VALUE,
   pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
   --
   -- Update primary statistic group and statistic group representing the whole returnee table to
   --  record latest update time and user.
   --
   P_STATISTIC_GROUP.UPDATE_STATISTIC_GROUP(pnSTG_ID_PRIMARY, nSTG_VERSION_NBR, pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY
   , pnDST_ID => pnDST_ID
   );
   --
   -- Update statistic group representing the whole stateless table to record latest update details.
   --
   P_STATISTIC_GROUP.UPDATE_STATISTIC_GROUP(nSTG_ID_PFCOUNTRY, nSTG_VERSION_NBR_TABLE);
   --
    P_UTILITY.END_MODULE;
    exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end UPDATE_PF_RETSTOCK;
--
-- ----------------------------------------
-- INSERT_PF_PFDEC
-- ----------------------------------------
-- 
procedure INSERT_PF_PFDEC
  (pnPF_YEAR in P_BASE.tmnYear
 , pnLOC_ID_ORIGIN_COUNTRY in P_BASE.tmnLOC_ID
 , pnLOC_ID_ASYLUM_COUNTRY in P_BASE.tnLOC_ID
 , pnDST_ID in P_BASE.tmnDST_ID
 , pnDIM_ID_DURSLN in P_BASE.tmnDIM_ID
 , pnDUSLNPY_VALUE in P_BASE.tnSTC_VALUE
 , pnDUSLNPY_AH_VALUE in P_BASE.tnSTC_VALUE
 , pnDUSLNCY_VALUE in P_BASE.tnSTC_VALUE
 , pnDUSLNCY_AH_VALUE in P_BASE.tnSTC_VALUE
 , pnDUSLNNY_VALUE in P_BASE.tnSTC_VALUE
 , pnDUSLNNY_AH_VALUE in P_BASE.tnSTC_VALUE
 )
   is
     dSTART_DATE P_BASE.tdDate := to_date(to_char(pnPF_YEAR) || '-01-01', 'YYYY-MM-DD');
     dEND_DATE P_BASE.tdDate := to_date(to_char(pnPF_YEAR + 1) || '-01-01', 'YYYY-MM-DD');
     nSTG_ID_PFCOUNTRY P_BASE.tnSTG_ID;
     nSTG_VERSION_NBR_TABLE P_BASE.tnSTG_VERSION_NBR;
     nSTG_ID_PRIMARY P_BASE.tnSTG_ID;
     nDUSLNPY_STC_ID P_BASE.tnSTC_ID;
     nDUSLNPY_VERSION_NBR P_BASE.tnSTC_VERSION_NBR;
     nDUSLNPY_AH_STC_ID P_BASE.tnSTC_ID;
     nDUSLNPY_AH_VERSION_NBR P_BASE.tnSTC_VERSION_NBR;
     nDUSLNCY_STC_ID P_BASE.tnSTC_ID;
     nDUSLNCY_VERSION_NBR P_BASE.tnSTC_VERSION_NBR;
     nDUSLNCY_AH_STC_ID P_BASE.tnSTC_ID;
     nDUSLNCY_AH_VERSION_NBR P_BASE.tnSTC_VERSION_NBR;
     nDUSLNNY_STC_ID P_BASE.tnSTC_ID;
     nDUSLNNY_VERSION_NBR P_BASE.tnSTC_VERSION_NBR;
     nDUSLNNY_AH_STC_ID P_BASE.tnSTC_ID;
     nDUSLNNY_AH_VERSION_NBR P_BASE.tnSTC_VERSION_NBR;
  begin
   P_UTILITY.START_MODULE 
   (sVersion || '-' || sComponent || '.INSERT_PF_PFDEC', 
   to_char(pnPF_YEAR)  || '~' || to_char(pnLOC_ID_ORIGIN_COUNTRY) 
   || '~' || to_char(pnLOC_ID_ASYLUM_COUNTRY) 
 || '~' || to_char(pnDST_ID) 
 || '~' || to_char(pnDIM_ID_DURSLN) 
   || '~' || to_char(pnDUSLNPY_VALUE) 
   || '~' || to_char(pnDUSLNPY_AH_VALUE) 
   || '~' || to_char(pnDUSLNCY_VALUE) 
   || '~' || to_char(pnDUSLNCY_AH_VALUE) 
   || '~' || to_char(pnDUSLNNY_VALUE) 
   || '~' || to_char(pnDUSLNNY_AH_VALUE) 
   );
    --
    -- Check that UNHCR-assisted value is not greater than total value.
    --
    if pnDUSLNPY_AH_VALUE > pnDUSLNPY_VALUE
        then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'UNHCR-assisted value may not be greater than total value');
    end if;
    if pnDUSLNCY_AH_VALUE > pnDUSLNCY_VALUE
        then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'UNHCR-assisted value may not be greater than total value');
    end if;
    if pnDUSLNNY_AH_VALUE > pnDUSLNNY_VALUE
        then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'UNHCR-assisted value may not be greater than total value');
    end if;
    --
    -- Create new statistic group representing this PFDEC table row
    --
    P_STATISTIC_GROUP.INSERT_STATISTIC_GROUP
    (nSTG_ID_PRIMARY, dSTART_DATE, dEND_DATE, 'PFDEC',
    pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
    pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY
  , pnDST_ID => pnDST_ID
  , pnDIM_ID1 => pnDIM_ID_DURSLN
    );
    --
    -- Get identifier and version number of statistic group representing the whole PF data for
    --  this year and country, creating a new statistic group for this purpose if necessary.
    --
  GET_COUNTRY_STATISTIC_GROUP(nSTG_ID_PFCOUNTRY, nSTG_VERSION_NBR_TABLE, nSTG_ID_PRIMARY);
    --
    -- Create statistics and link them to the statistic
    --  group for the table.
    --
    if pnDUSLNPY_VALUE is not null
    then
    SET_STATISTIC
    (nDUSLNPY_STC_ID, pnVERSION_NBR => nDUSLNPY_VERSION_NBR,  psSTCT_CODE => 'DUSLNPY', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
    pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
    pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
    pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY,
    pnDIM_ID1 => pnDIM_ID_DURSLN,
    pnVALUE => pnDUSLNPY_VALUE,
    pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
    end if;
    --
    if pnDUSLNPY_AH_VALUE is not null
    then
    SET_STATISTIC
    (nDUSLNPY_AH_STC_ID, pnVERSION_NBR => nDUSLNPY_AH_VERSION_NBR,  psSTCT_CODE => 'DUSLNPY-AH', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
    pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
    pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
    pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY,
    pnDIM_ID1 => pnDIM_ID_DURSLN,
    pnVALUE => pnDUSLNPY_AH_VALUE,
    pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
    end if;
    --
    if pnDUSLNCY_VALUE is not null
    then
    SET_STATISTIC
    (nDUSLNCY_STC_ID, pnVERSION_NBR => nDUSLNCY_VERSION_NBR,  psSTCT_CODE => 'DUSLNCY', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
    pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
    pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
    pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY,
    pnDIM_ID1 => pnDIM_ID_DURSLN,
    pnVALUE => pnDUSLNCY_VALUE,
    pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
    end if;
    --
    if pnDUSLNCY_AH_VALUE is not null
    then
    SET_STATISTIC
    (nDUSLNCY_AH_STC_ID, pnVERSION_NBR => nDUSLNCY_AH_VERSION_NBR,  psSTCT_CODE => 'DUSLNCY-AH', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
    pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
    pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
    pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY,
    pnDIM_ID1 => pnDIM_ID_DURSLN,
    pnVALUE => pnDUSLNCY_AH_VALUE,
    pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
    end if;
    --
    if pnDUSLNNY_VALUE is not null
    then
    SET_STATISTIC
    (nDUSLNNY_STC_ID, pnVERSION_NBR => nDUSLNNY_VERSION_NBR,  psSTCT_CODE => 'DUSLNNY', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
    pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
    pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
    pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY,
    pnDIM_ID1 => pnDIM_ID_DURSLN,
    pnVALUE => pnDUSLNNY_VALUE,
    pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
    end if;
    --
    if pnDUSLNNY_AH_VALUE is not null
    then
    SET_STATISTIC
    (nDUSLNNY_AH_STC_ID, pnVERSION_NBR => nDUSLNNY_AH_VERSION_NBR,  psSTCT_CODE => 'DUSLNNY-AH', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
    pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
    pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
    pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY,
    pnDIM_ID1 => pnDIM_ID_DURSLN,
    pnVALUE => pnDUSLNNY_AH_VALUE,
    pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
    end if;
    --
    P_UTILITY.END_MODULE;
    exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_PF_PFDEC;
--
-- ----------------------------------------
-- UPDATE_PF_PFDEC
-- ----------------------------------------
-- 
procedure UPDATE_PF_PFDEC
  (pnSTG_ID_PRIMARY in P_BASE.tmnSTG_ID
 , pnSTG_VERSION_NBR in P_BASE.tmnSTG_VERSION_NBR
 , pnLOC_ID_ORIGIN_COUNTRY in P_BASE.tmnLOC_ID
 , pnDST_ID in P_BASE.tmnDST_ID
 , pnDIM_ID_DURSLN in P_BASE.tmnDIM_ID
 , pnDUSLNPY_VALUE in P_BASE.tnSTC_VALUE
 , pnDUSLNPY_STC_ID in P_BASE.tnSTC_ID
 , pnDUSLNPY_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR
 , pnDUSLNPY_AH_VALUE in P_BASE.tnSTC_VALUE
 , pnDUSLNPY_AH_STC_ID in P_BASE.tnSTC_ID
 , pnDUSLNPY_AH_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR
 , pnDUSLNCY_VALUE in P_BASE.tnSTC_VALUE
 , pnDUSLNCY_STC_ID in P_BASE.tnSTC_ID
 , pnDUSLNCY_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR
 , pnDUSLNCY_AH_VALUE in P_BASE.tnSTC_VALUE
 , pnDUSLNCY_AH_STC_ID in P_BASE.tnSTC_ID
 , pnDUSLNCY_AH_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR
 , pnDUSLNNY_VALUE in P_BASE.tnSTC_VALUE
 , pnDUSLNNY_STC_ID in P_BASE.tnSTC_ID
 , pnDUSLNNY_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR
 , pnDUSLNNY_AH_VALUE in P_BASE.tnSTC_VALUE
 , pnDUSLNNY_AH_STC_ID in P_BASE.tnSTC_ID
 , pnDUSLNNY_AH_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR
 )
  is
     nSTG_VERSION_NBR P_BASE.tnSTG_VERSION_NBR := pnSTG_VERSION_NBR;
     dSTART_DATE P_BASE.tdDate;
     dEND_DATE P_BASE.tdDate;
     nLOC_ID_ASYLUM_COUNTRY P_BASE.tnLOC_ID;
     nDUSLNPY_STC_ID P_BASE.tnSTC_ID := pnDUSLNPY_STC_ID;
     nDUSLNPY_VERSION_NBR P_BASE.tnSTC_VERSION_NBR := pnDUSLNPY_VERSION_NBR;
     nDUSLNPY_AH_STC_ID P_BASE.tnSTC_ID := pnDUSLNPY_AH_STC_ID;
     nDUSLNPY_AH_VERSION_NBR P_BASE.tnSTC_VERSION_NBR := pnDUSLNPY_AH_VERSION_NBR;
     nDUSLNCY_STC_ID P_BASE.tnSTC_ID := pnDUSLNCY_STC_ID;
     nDUSLNCY_VERSION_NBR P_BASE.tnSTC_VERSION_NBR := pnDUSLNCY_VERSION_NBR;
     nDUSLNCY_AH_STC_ID P_BASE.tnSTC_ID := pnDUSLNCY_AH_STC_ID;
     nDUSLNCY_AH_VERSION_NBR P_BASE.tnSTC_VERSION_NBR := pnDUSLNCY_AH_VERSION_NBR;
     nDUSLNNY_STC_ID P_BASE.tnSTC_ID := pnDUSLNNY_STC_ID;
     nDUSLNNY_VERSION_NBR P_BASE.tnSTC_VERSION_NBR := pnDUSLNNY_VERSION_NBR;
     nDUSLNNY_AH_STC_ID P_BASE.tnSTC_ID := pnDUSLNNY_AH_STC_ID;
     nDUSLNNY_AH_VERSION_NBR P_BASE.tnSTC_VERSION_NBR := pnDUSLNNY_AH_VERSION_NBR;
  --
  nSTG_ID_PFCOUNTRY P_BASE.tnSTG_ID;
  nSTG_VERSION_NBR_TABLE P_BASE.tnSTG_VERSION_NBR;
  begin
   P_UTILITY.START_MODULE 
   (sVersion || '-' || sComponent || '.UPDATE_PF_PFDEC', 
   to_char(pnSTG_ID_PRIMARY)
   || '~' || to_char(pnSTG_VERSION_NBR)
 || '~' || to_char(pnDST_ID) 
 || '~' || to_char(pnDIM_ID_DURSLN) 
   || '~' || to_char(pnDUSLNPY_VALUE) 
   || '~' || to_char(pnDUSLNPY_STC_ID) 
   || '~' || to_char(pnDUSLNPY_VERSION_NBR) 
   || '~' || to_char(pnDUSLNPY_AH_VALUE) 
   || '~' || to_char(pnDUSLNPY_AH_STC_ID) 
   || '~' || to_char(pnDUSLNPY_AH_VERSION_NBR) 
   || '~' || to_char(pnDUSLNCY_VALUE) 
   || '~' || to_char(pnDUSLNCY_STC_ID) 
   || '~' || to_char(pnDUSLNCY_VERSION_NBR) 
   || '~' || to_char(pnDUSLNCY_AH_VALUE) 
   || '~' || to_char(pnDUSLNCY_AH_STC_ID) 
   || '~' || to_char(pnDUSLNCY_AH_VERSION_NBR) 
   || '~' || to_char(pnDUSLNNY_VALUE) 
   || '~' || to_char(pnDUSLNNY_STC_ID) 
   || '~' || to_char(pnDUSLNNY_VERSION_NBR) 
   || '~' || to_char(pnDUSLNNY_AH_VALUE) 
   || '~' || to_char(pnDUSLNNY_AH_STC_ID) 
   || '~' || to_char(pnDUSLNNY_AH_VERSION_NBR) 
);
    --
    -- Check that UNHCR-assisted value is not greater than total value.
    --
    if pnDUSLNPY_AH_VALUE > pnDUSLNPY_VALUE
        then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'UNHCR-assisted value may not be greater than total value');
    end if;
    if pnDUSLNCY_AH_VALUE > pnDUSLNCY_VALUE
        then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'UNHCR-assisted value may not be greater than total value');
    end if;
    if pnDUSLNNY_AH_VALUE > pnDUSLNNY_VALUE
        then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'UNHCR-assisted value may not be greater than total value');
    end if;
    --
    -- Get identifier and version number of statistic group representing the whole  whole PF data for
    --  this year and country.
    --
  GET_COUNTRY_STATISTIC_GROUP(nSTG_ID_PFCOUNTRY, nSTG_VERSION_NBR_TABLE, pnSTG_ID_PRIMARY);
   --
   -- Get primary statistics group details for this stateless table row.
   --
   select START_DATE, END_DATE, LOC_ID_ASYLUM_COUNTRY
   into dSTART_DATE, dEND_DATE, nLOC_ID_ASYLUM_COUNTRY
   from T_STATISTIC_GROUPS
   where ID = pnSTG_ID_PRIMARY;
   --
   -- Insert, update or delete statistics.
   --
   SET_STATISTIC
   (nDUSLNPY_STC_ID, nDUSLNPY_VERSION_NBR,
   psSTCT_CODE => 'DUSLNPY', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
   pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
   pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
   pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
    pnDIM_ID1 => pnDIM_ID_DURSLN,
   pnVALUE => pnDUSLNPY_VALUE,
   pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
   --
   SET_STATISTIC
   (nDUSLNPY_AH_STC_ID, nDUSLNPY_AH_VERSION_NBR,
   psSTCT_CODE => 'DUSLNPY-AH', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
   pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
   pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
   pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
    pnDIM_ID1 => pnDIM_ID_DURSLN,
   pnVALUE => pnDUSLNPY_AH_VALUE,
   pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
   --
   SET_STATISTIC
   (nDUSLNCY_STC_ID, nDUSLNCY_VERSION_NBR,
   psSTCT_CODE => 'DUSLNCY', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
   pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
   pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
   pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
    pnDIM_ID1 => pnDIM_ID_DURSLN,
   pnVALUE => pnDUSLNCY_VALUE,
   pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
   --
   SET_STATISTIC
   (nDUSLNCY_AH_STC_ID, nDUSLNCY_AH_VERSION_NBR,
   psSTCT_CODE => 'DUSLNCY-AH', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
   pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
   pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
   pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
    pnDIM_ID1 => pnDIM_ID_DURSLN,
   pnVALUE => pnDUSLNCY_AH_VALUE,
   pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
   --
   SET_STATISTIC
   (nDUSLNNY_STC_ID, nDUSLNNY_VERSION_NBR,
   psSTCT_CODE => 'DUSLNNY', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
   pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
   pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
   pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
    pnDIM_ID1 => pnDIM_ID_DURSLN,
   pnVALUE => pnDUSLNNY_VALUE,
   pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
   --
   SET_STATISTIC
   (nDUSLNNY_AH_STC_ID, nDUSLNNY_AH_VERSION_NBR,
   psSTCT_CODE => 'DUSLNNY-AH', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
   pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
   pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
   pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
    pnDIM_ID1 => pnDIM_ID_DURSLN,
   pnVALUE => pnDUSLNNY_AH_VALUE,
   pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
   --
   -- Update primary statistic group and statistic group representing the whole returnee table to
   --  record latest update time and user.
   --
   P_STATISTIC_GROUP.UPDATE_STATISTIC_GROUP(pnSTG_ID_PRIMARY, nSTG_VERSION_NBR, pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY
   , pnDST_ID => pnDST_ID
   , pnDIM_ID1 => pnDIM_ID_DURSLN
   );
   --
   -- Update statistic group representing the whole stateless table to record latest update details.
   --
   P_STATISTIC_GROUP.UPDATE_STATISTIC_GROUP(nSTG_ID_PFCOUNTRY, nSTG_VERSION_NBR_TABLE);
   --
    P_UTILITY.END_MODULE;
    exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end UPDATE_PF_PFDEC;
--
-- ----------------------------------------
-- INSERT_PF_PFINC
-- ----------------------------------------
-- 
procedure INSERT_PF_PFINC
  (pnPF_YEAR in P_BASE.tmnYear
 , pnLOC_ID_ORIGIN_COUNTRY in P_BASE.tmnLOC_ID
 , pnLOC_ID_ASYLUM_COUNTRY in P_BASE.tnLOC_ID
 , pnDST_ID in P_BASE.tmnDST_ID
 , pnDIM_ID_ARVLTYPE in P_BASE.tmnDIM_ID
 , pnARVLPY_VALUE in P_BASE.tnSTC_VALUE
 , pnARVLPY_AH_VALUE in P_BASE.tnSTC_VALUE
 , pnARVLCY_VALUE in P_BASE.tnSTC_VALUE
 , pnARVLCY_AH_VALUE in P_BASE.tnSTC_VALUE
 , pnARVLNY_VALUE in P_BASE.tnSTC_VALUE
 , pnARVLNY_AH_VALUE in P_BASE.tnSTC_VALUE
 )
   is
     dSTART_DATE P_BASE.tdDate := to_date(to_char(pnPF_YEAR) || '-01-01', 'YYYY-MM-DD');
     dEND_DATE P_BASE.tdDate := to_date(to_char(pnPF_YEAR + 1) || '-01-01', 'YYYY-MM-DD');
     nSTG_ID_PFCOUNTRY P_BASE.tnSTG_ID;
     nSTG_VERSION_NBR_TABLE P_BASE.tnSTG_VERSION_NBR;
     nSTG_ID_PRIMARY P_BASE.tnSTG_ID;
     nARVLPY_STC_ID P_BASE.tnSTC_ID;
     nARVLPY_VERSION_NBR P_BASE.tnSTC_VERSION_NBR;
     nARVLPY_AH_STC_ID P_BASE.tnSTC_ID;
     nARVLPY_AH_VERSION_NBR P_BASE.tnSTC_VERSION_NBR;
     nARVLCY_STC_ID P_BASE.tnSTC_ID;
     nARVLCY_VERSION_NBR P_BASE.tnSTC_VERSION_NBR;
     nARVLCY_AH_STC_ID P_BASE.tnSTC_ID;
     nARVLCY_AH_VERSION_NBR P_BASE.tnSTC_VERSION_NBR;
     nARVLNY_STC_ID P_BASE.tnSTC_ID;
     nARVLNY_VERSION_NBR P_BASE.tnSTC_VERSION_NBR;
     nARVLNY_AH_STC_ID P_BASE.tnSTC_ID;
     nARVLNY_AH_VERSION_NBR P_BASE.tnSTC_VERSION_NBR;
  begin
   P_UTILITY.START_MODULE 
   (sVersion || '-' || sComponent || '.INSERT_PF_PFINC', 
   to_char(pnPF_YEAR)  || '~' || to_char(pnLOC_ID_ORIGIN_COUNTRY) 
   || '~' || to_char(pnLOC_ID_ASYLUM_COUNTRY) 
 || '~' || to_char(pnDST_ID) 
 || '~' || to_char(pnDIM_ID_ARVLTYPE) 
   || '~' || to_char(pnARVLPY_VALUE) 
   || '~' || to_char(pnARVLPY_AH_VALUE) 
   || '~' || to_char(pnARVLCY_VALUE) 
   || '~' || to_char(pnARVLCY_AH_VALUE) 
   || '~' || to_char(pnARVLNY_VALUE) 
   || '~' || to_char(pnARVLNY_AH_VALUE) 
   );
    --
    -- Check that UNHCR-assisted value is not greater than total value.
    --
    if pnARVLPY_AH_VALUE > pnARVLPY_VALUE
        then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'UNHCR-assisted value may not be greater than total value');
    end if;
    if pnARVLCY_AH_VALUE > pnARVLCY_VALUE
        then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'UNHCR-assisted value may not be greater than total value');
    end if;
    if pnARVLNY_AH_VALUE > pnARVLNY_VALUE
        then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'UNHCR-assisted value may not be greater than total value');
    end if;
    --
    -- Create new statistic group representing this PFINC table row
    --
    P_STATISTIC_GROUP.INSERT_STATISTIC_GROUP
    (nSTG_ID_PRIMARY, dSTART_DATE, dEND_DATE, 'PFINC',
    pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
    pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY
  , pnDST_ID => pnDST_ID
  , pnDIM_ID1 => pnDIM_ID_ARVLTYPE
    );
    --
    -- Get identifier and version number of statistic group representing the whole PF data for
    --  this year and country, creating a new statistic group for this purpose if necessary.
    --
  GET_COUNTRY_STATISTIC_GROUP(nSTG_ID_PFCOUNTRY, nSTG_VERSION_NBR_TABLE, nSTG_ID_PRIMARY);
    --
    -- Create statistics and link them to the statistic
    --  group for the table.
    --
    if pnARVLPY_VALUE is not null
    then
    SET_STATISTIC
    (nARVLPY_STC_ID, pnVERSION_NBR => nARVLPY_VERSION_NBR,  psSTCT_CODE => 'ARVLPY', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
    pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
    pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
    pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY,
    pnDIM_ID1 => pnDIM_ID_ARVLTYPE,
    pnVALUE => pnARVLPY_VALUE,
    pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
    end if;
    --
    if pnARVLPY_AH_VALUE is not null
    then
    SET_STATISTIC
    (nARVLPY_AH_STC_ID, pnVERSION_NBR => nARVLPY_AH_VERSION_NBR,  psSTCT_CODE => 'ARVLPY-AH', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
    pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
    pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
    pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY,
    pnDIM_ID1 => pnDIM_ID_ARVLTYPE,
    pnVALUE => pnARVLPY_AH_VALUE,
    pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
    end if;
    --
    if pnARVLCY_VALUE is not null
    then
    SET_STATISTIC
    (nARVLCY_STC_ID, pnVERSION_NBR => nARVLCY_VERSION_NBR,  psSTCT_CODE => 'ARVLCY', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
    pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
    pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
    pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY,
    pnDIM_ID1 => pnDIM_ID_ARVLTYPE,
    pnVALUE => pnARVLCY_VALUE,
    pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
    end if;
    --
    if pnARVLCY_AH_VALUE is not null
    then
    SET_STATISTIC
    (nARVLCY_AH_STC_ID, pnVERSION_NBR => nARVLCY_AH_VERSION_NBR,  psSTCT_CODE => 'ARVLCY-AH', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
    pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
    pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
    pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY,
    pnDIM_ID1 => pnDIM_ID_ARVLTYPE,
    pnVALUE => pnARVLCY_AH_VALUE,
    pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
    end if;
    --
    if pnARVLNY_VALUE is not null
    then
    SET_STATISTIC
    (nARVLNY_STC_ID, pnVERSION_NBR => nARVLNY_VERSION_NBR,  psSTCT_CODE => 'ARVLNY', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
    pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
    pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
    pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY,
    pnDIM_ID1 => pnDIM_ID_ARVLTYPE,
    pnVALUE => pnARVLNY_VALUE,
    pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
    end if;
    --
    if pnARVLNY_AH_VALUE is not null
    then
    SET_STATISTIC
    (nARVLNY_AH_STC_ID, pnVERSION_NBR => nARVLNY_AH_VERSION_NBR,  psSTCT_CODE => 'ARVLNY-AH', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
    pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
    pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
    pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY,
    pnDIM_ID1 => pnDIM_ID_ARVLTYPE,
    pnVALUE => pnARVLNY_AH_VALUE,
    pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
    end if;
    --
    P_UTILITY.END_MODULE;
    exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_PF_PFINC;
--
-- ----------------------------------------
-- UPDATE_PF_PFINC
-- ----------------------------------------
-- 
procedure UPDATE_PF_PFINC
  (pnSTG_ID_PRIMARY in P_BASE.tmnSTG_ID
 , pnSTG_VERSION_NBR in P_BASE.tmnSTG_VERSION_NBR
 , pnLOC_ID_ORIGIN_COUNTRY in P_BASE.tmnLOC_ID
 , pnDST_ID in P_BASE.tmnDST_ID
 , pnDIM_ID_ARVLTYPE in P_BASE.tmnDIM_ID
 , pnARVLPY_VALUE in P_BASE.tnSTC_VALUE
 , pnARVLPY_STC_ID in P_BASE.tnSTC_ID
 , pnARVLPY_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR
 , pnARVLPY_AH_VALUE in P_BASE.tnSTC_VALUE
 , pnARVLPY_AH_STC_ID in P_BASE.tnSTC_ID
 , pnARVLPY_AH_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR
 , pnARVLCY_VALUE in P_BASE.tnSTC_VALUE
 , pnARVLCY_STC_ID in P_BASE.tnSTC_ID
 , pnARVLCY_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR
 , pnARVLCY_AH_VALUE in P_BASE.tnSTC_VALUE
 , pnARVLCY_AH_STC_ID in P_BASE.tnSTC_ID
 , pnARVLCY_AH_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR
 , pnARVLNY_VALUE in P_BASE.tnSTC_VALUE
 , pnARVLNY_STC_ID in P_BASE.tnSTC_ID
 , pnARVLNY_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR
 , pnARVLNY_AH_VALUE in P_BASE.tnSTC_VALUE
 , pnARVLNY_AH_STC_ID in P_BASE.tnSTC_ID
 , pnARVLNY_AH_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR
 )
  is
     nSTG_VERSION_NBR P_BASE.tnSTG_VERSION_NBR := pnSTG_VERSION_NBR;
     dSTART_DATE P_BASE.tdDate;
     dEND_DATE P_BASE.tdDate;
     nLOC_ID_ASYLUM_COUNTRY P_BASE.tnLOC_ID;
     nARVLPY_STC_ID P_BASE.tnSTC_ID := pnARVLPY_STC_ID;
     nARVLPY_VERSION_NBR P_BASE.tnSTC_VERSION_NBR := pnARVLPY_VERSION_NBR;
     nARVLPY_AH_STC_ID P_BASE.tnSTC_ID := pnARVLPY_AH_STC_ID;
     nARVLPY_AH_VERSION_NBR P_BASE.tnSTC_VERSION_NBR := pnARVLPY_AH_VERSION_NBR;
     nARVLCY_STC_ID P_BASE.tnSTC_ID := pnARVLCY_STC_ID;
     nARVLCY_VERSION_NBR P_BASE.tnSTC_VERSION_NBR := pnARVLCY_VERSION_NBR;
     nARVLCY_AH_STC_ID P_BASE.tnSTC_ID := pnARVLCY_AH_STC_ID;
     nARVLCY_AH_VERSION_NBR P_BASE.tnSTC_VERSION_NBR := pnARVLCY_AH_VERSION_NBR;
     nARVLNY_STC_ID P_BASE.tnSTC_ID := pnARVLNY_STC_ID;
     nARVLNY_VERSION_NBR P_BASE.tnSTC_VERSION_NBR := pnARVLNY_VERSION_NBR;
     nARVLNY_AH_STC_ID P_BASE.tnSTC_ID := pnARVLNY_AH_STC_ID;
     nARVLNY_AH_VERSION_NBR P_BASE.tnSTC_VERSION_NBR := pnARVLNY_AH_VERSION_NBR;
  --
  nSTG_ID_PFCOUNTRY P_BASE.tnSTG_ID;
  nSTG_VERSION_NBR_TABLE P_BASE.tnSTG_VERSION_NBR;
  begin
   P_UTILITY.START_MODULE 
   (sVersion || '-' || sComponent || '.UPDATE_PF_PFINC', 
   to_char(pnSTG_ID_PRIMARY)
   || '~' || to_char(pnSTG_VERSION_NBR)
 || '~' || to_char(pnDST_ID) 
 || '~' || to_char(pnDIM_ID_ARVLTYPE) 
   || '~' || to_char(pnARVLPY_VALUE) 
   || '~' || to_char(pnARVLPY_STC_ID) 
   || '~' || to_char(pnARVLPY_VERSION_NBR) 
   || '~' || to_char(pnARVLPY_AH_VALUE) 
   || '~' || to_char(pnARVLPY_AH_STC_ID) 
   || '~' || to_char(pnARVLPY_AH_VERSION_NBR) 
   || '~' || to_char(pnARVLCY_VALUE) 
   || '~' || to_char(pnARVLCY_STC_ID) 
   || '~' || to_char(pnARVLCY_VERSION_NBR) 
   || '~' || to_char(pnARVLCY_AH_VALUE) 
   || '~' || to_char(pnARVLCY_AH_STC_ID) 
   || '~' || to_char(pnARVLCY_AH_VERSION_NBR) 
   || '~' || to_char(pnARVLNY_VALUE) 
   || '~' || to_char(pnARVLNY_STC_ID) 
   || '~' || to_char(pnARVLNY_VERSION_NBR) 
   || '~' || to_char(pnARVLNY_AH_VALUE) 
   || '~' || to_char(pnARVLNY_AH_STC_ID) 
   || '~' || to_char(pnARVLNY_AH_VERSION_NBR) 
);
    --
    -- Check that UNHCR-assisted value is not greater than total value.
    --
    if pnARVLPY_AH_VALUE > pnARVLPY_VALUE
        then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'UNHCR-assisted value may not be greater than total value');
    end if;
    if pnARVLCY_AH_VALUE > pnARVLCY_VALUE
        then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'UNHCR-assisted value may not be greater than total value');
    end if;
    if pnARVLNY_AH_VALUE > pnARVLNY_VALUE
        then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'UNHCR-assisted value may not be greater than total value');
    end if;
    --
    -- Get identifier and version number of statistic group representing the whole  whole PF data for
    --  this year and country.
    --
  GET_COUNTRY_STATISTIC_GROUP(nSTG_ID_PFCOUNTRY, nSTG_VERSION_NBR_TABLE, pnSTG_ID_PRIMARY);
   --
   -- Get primary statistics group details for this stateless table row.
   --
   select START_DATE, END_DATE, LOC_ID_ASYLUM_COUNTRY
   into dSTART_DATE, dEND_DATE, nLOC_ID_ASYLUM_COUNTRY
   from T_STATISTIC_GROUPS
   where ID = pnSTG_ID_PRIMARY;
   --
   -- Insert, update or delete statistics.
   --
   SET_STATISTIC
   (nARVLPY_STC_ID, nARVLPY_VERSION_NBR,
   psSTCT_CODE => 'ARVLPY', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
   pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
   pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
   pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
    pnDIM_ID1 => pnDIM_ID_ARVLTYPE,
   pnVALUE => pnARVLPY_VALUE,
   pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
   --
   SET_STATISTIC
   (nARVLPY_AH_STC_ID, nARVLPY_AH_VERSION_NBR,
   psSTCT_CODE => 'ARVLPY-AH', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
   pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
   pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
   pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
    pnDIM_ID1 => pnDIM_ID_ARVLTYPE,
   pnVALUE => pnARVLPY_AH_VALUE,
   pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
   --
   SET_STATISTIC
   (nARVLCY_STC_ID, nARVLCY_VERSION_NBR,
   psSTCT_CODE => 'ARVLCY', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
   pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
   pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
   pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
    pnDIM_ID1 => pnDIM_ID_ARVLTYPE,
   pnVALUE => pnARVLCY_VALUE,
   pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
   --
   SET_STATISTIC
   (nARVLCY_AH_STC_ID, nARVLCY_AH_VERSION_NBR,
   psSTCT_CODE => 'ARVLCY-AH', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
   pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
   pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
   pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
    pnDIM_ID1 => pnDIM_ID_ARVLTYPE,
   pnVALUE => pnARVLCY_AH_VALUE,
   pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
   --
   SET_STATISTIC
   (nARVLNY_STC_ID, nARVLNY_VERSION_NBR,
   psSTCT_CODE => 'ARVLNY', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
   pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
   pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
   pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
    pnDIM_ID1 => pnDIM_ID_ARVLTYPE,
   pnVALUE => pnARVLNY_VALUE,
   pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
   --
   SET_STATISTIC
   (nARVLNY_AH_STC_ID, nARVLNY_AH_VERSION_NBR,
   psSTCT_CODE => 'ARVLNY-AH', pdSTART_DATE => dSTART_DATE, pdEND_DATE => dEND_DATE,
    pnDST_ID => pnDST_ID,
   pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
   pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
   pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
    pnDIM_ID1 => pnDIM_ID_ARVLTYPE,
   pnVALUE => pnARVLNY_AH_VALUE,
   pnSTG_ID_PFCOUNTRY => nSTG_ID_PFCOUNTRY);
   --
   -- Update primary statistic group and statistic group representing the whole returnee table to
   --  record latest update time and user.
   --
   P_STATISTIC_GROUP.UPDATE_STATISTIC_GROUP(pnSTG_ID_PRIMARY, nSTG_VERSION_NBR, pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY
   , pnDST_ID => pnDST_ID
   , pnDIM_ID1 => pnDIM_ID_ARVLTYPE
   );
   --
   -- Update statistic group representing the whole stateless table to record latest update details.
   --
   P_STATISTIC_GROUP.UPDATE_STATISTIC_GROUP(nSTG_ID_PFCOUNTRY, nSTG_VERSION_NBR_TABLE);
   --
    P_UTILITY.END_MODULE;
    exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end UPDATE_PF_PFINC;
--
end P_PF;
/

show errors