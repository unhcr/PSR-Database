create or replace package body P_ASR is
--
-- ========================================
-- Private global variables
-- ========================================
--
  gnDST_ID_STATELESS P_BASE.tnDST_ID;  -- Displacement status identifier for "Stateless".
  gnDST_ID_OOC P_BASE.tnDST_ID;  -- Displacement status identifier for "Others of concern".
  gnLOC_ID_STATELESS P_BASE.tnLOC_ID;  -- Location identifier for "Stateless" origin.
--
-- ========================================
-- Private program units
-- ========================================
--
-- Wrapper for P_STATISTIC.SET_STATISTIC procedure, adding functionality to create a linkage to the
-- statistic group covering all the statistics in that ASR table for the given row's year and
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
    pnSTG_ID_PRIMARY in P_BASE.tmnSTG_ID,
    pnSTG_ID_TABLE in P_BASE.tmnSTG_ID)
  is
    bNewStatistic boolean := (pnSTC_ID is null);
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_STATISTIC',
      to_char(pnSTC_ID) || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnVALUE) || '~' ||
        to_char(pdSTART_DATE, 'YYYY-MM-DD')  || '~' || to_char(pdEND_DATE, 'YYYY-MM-DD')  || '~' ||
        psSTCT_CODE || '~' || to_char(pnDST_ID) || '~' ||
        to_char(pnLOC_ID_ASYLUM_COUNTRY) || '~' || to_char(pnLOC_ID_ASYLUM) || '~' ||
        to_char(pnLOC_ID_ORIGIN_COUNTRY) || '~' || to_char(pnLOC_ID_ORIGIN) || '~' ||
        to_char(pnDIM_ID1) || '~' || to_char(pnDIM_ID2) || '~' || to_char(pnDIM_ID3) || '~' ||
        to_char(pnDIM_ID4) || '~' || to_char(pnDIM_ID5) || '~' ||
        psSEX_CODE || '~' || to_char(pnAGR_ID) || '~' || to_char(pnPPG_ID) || '~' ||
        to_char(pnSTG_ID_PRIMARY) || '~' || to_char(pnSTG_ID_TABLE));
  --
    P_STATISTIC.SET_STATISTIC
     (pnSTC_ID, pnVERSION_NBR, pnVALUE, pdSTART_DATE, pdEND_DATE, psSTCT_CODE, pnDST_ID,
      pnLOC_ID_ASYLUM_COUNTRY, pnLOC_ID_ASYLUM, pnLOC_ID_ORIGIN_COUNTRY, pnLOC_ID_ORIGIN,
      pnDIM_ID1, pnDIM_ID2, pnDIM_ID3, pnDIM_ID4, pnDIM_ID5, psSEX_CODE, pnAGR_ID, pnPPG_ID,
      pnSTG_ID_PRIMARY);
  --
    if bNewStatistic
    then P_STATISTIC.INSERT_STATISTIC_IN_GROUP(pnSTC_ID, pnSTG_ID_TABLE);
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_STATISTIC;
--
-- ----------------------------------------
-- SET_STG_ATTRIBUTE
-- ----------------------------------------
--
  procedure SET_STG_ATTRIBUTE
   (pnSTG_ID in P_BASE.tmnSTG_ID,
    psSTGAT_CODE in P_BASE.tmsSTGAT_CODE,
    pnVERSION_NBR in out P_BASE.tnSTGA_VERSION_NBR,
    psCHAR_VALUE in P_BASE.tsSTGA_CHAR_VALUE)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_STG_ATTRIBUTE',
      to_char(pnSTG_ID) || '~' || psSTGAT_CODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psCHAR_VALUE);
  --
    if pnVERSION_NBR is not null or psCHAR_VALUE is not null
    then P_STATISTIC_GROUP.SET_STG_ATTRIBUTE(pnSTG_ID, psSTGAT_CODE, pnVERSION_NBR, psCHAR_VALUE);
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_STG_ATTRIBUTE;
--
-- ----------------------------------------
-- GET_TABLE_STATISTIC_GROUP
-- ----------------------------------------
--
-- Given the identifer of the statistic group representing a row in an ASR table (the primary
-- statistic group), get the identifier and version number of the statistic group covering all
-- the statistics in that ASR table for the given row's year and country. If the required table
-- statistic group does not exist, it is created.
--
-- Parameters:
--  pnSTG_ID - Identifier of statistic group covering the whole table (returned).
--  pnVERSION_NBR - Update version number of statistic group record covering the whole table
--    (returned).
--  pnSTG_ID_PRIMARY - Identifier of the primary statistic group for the ASR table row (mandatory).
--
  procedure GET_TABLE_STATISTIC_GROUP
   (pnSTG_ID out P_BASE.tnSTG_ID,
    pnVERSION_NBR out P_BASE.tnSTG_VERSION_NBR,
    pnSTG_ID_PRIMARY in P_BASE.tmnSTG_ID)
  is
    dSTART_DATE P_BASE.tdDate;
    dEND_DATE P_BASE.tdDate;
    sSTTG_CODE P_BASE.tmsSTTG_CODE;
    nLOC_ID_ASYLUM_COUNTRY P_BASE.tnLOC_ID;
    nLOC_ID_ORIGIN_COUNTRY P_BASE.tnLOC_ID;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.GET_TABLE_STATISTIC_GROUP',
      '~~' || to_char(pnSTG_ID_PRIMARY));
  --
    select STG1.START_DATE, STG1.END_DATE, STG1.STTG_CODE,
      case
        when STG1.STTG_CODE != 'RETURNEE' then STG1.LOC_ID_ASYLUM_COUNTRY
      end as LOC_ID_ASYLUM_COUNTRY,
      case
        when STG1.STTG_CODE = 'RETURNEE' then STG1.LOC_ID_ORIGIN_COUNTRY
      end as LOC_ID_ORIGIN_COUNTRY,
      STG2.ID, STG2.VERSION_NBR
    into dSTART_DATE, dEND_DATE, sSTTG_CODE,
      nLOC_ID_ASYLUM_COUNTRY, nLOC_ID_ORIGIN_COUNTRY,
      pnSTG_ID, pnVERSION_NBR
    from T_STATISTIC_GROUPS STG1
    left outer join T_STATISTIC_GROUPS STG2
      on STG2.START_DATE = STG1.START_DATE
      and STG2.END_DATE = STG1.END_DATE
      and nvl(STG2.STTG_CODE, 'x') = STG1.STTG_CODE
      and ((STG2.LOC_ID_ASYLUM_COUNTRY = STG1.LOC_ID_ASYLUM_COUNTRY
          and STG2.LOC_ID_ORIGIN_COUNTRY is null)
        or (STG2.LOC_ID_ORIGIN_COUNTRY = STG1.LOC_ID_ORIGIN_COUNTRY
          and STG2.LOC_ID_ASYLUM_COUNTRY is null))
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
      and STG2.SEQ_NBR is null
    where STG1.ID = pnSTG_ID_PRIMARY;
  --
  -- Create new statistic group covering the whole table when it doesn't already exist.
  --
    if pnSTG_ID is null
    then
      P_STATISTIC_GROUP.INSERT_STATISTIC_GROUP
       (pnSTG_ID, dSTART_DATE, dEND_DATE, sSTTG_CODE,
        pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => nLOC_ID_ORIGIN_COUNTRY);
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
  end GET_TABLE_STATISTIC_GROUP;
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- DELETE_ASR_ROW
-- ----------------------------------------
--
  procedure DELETE_ASR_ROW
   (pnSTG_ID_PRIMARY in P_BASE.tmnSTG_ID,
    pnSTG_VERSION_NBR in P_BASE.tmnSTG_VERSION_NBR)
  is
    nSTG_VERSION_NBR P_BASE.tnSTG_VERSION_NBR := pnSTG_VERSION_NBR;
  --
    nSTG_ID_TABLE P_BASE.tnSTG_ID;
    nSTG_VERSION_NBR_TABLE P_BASE.tnSTG_VERSION_NBR;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_ASR_ROW',
      to_char(pnSTG_ID_PRIMARY)  || '~' || to_char(pnSTG_VERSION_NBR));
  --
  -- Get identifier and version number of statistic group representing the whole table for
  --  this ASR table, year and country.
  --
    GET_TABLE_STATISTIC_GROUP(nSTG_ID_TABLE, nSTG_VERSION_NBR_TABLE, pnSTG_ID_PRIMARY);
  --
  -- Delete the whole set of statistics in this ASR table row.
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
  --
  -- Update the statistic group for the whole ASR table to record latest update details.
  --
    P_STATISTIC_GROUP.UPDATE_STATISTIC_GROUP(nSTG_ID_TABLE, nSTG_VERSION_NBR_TABLE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_ASR_ROW;
--
-- ----------------------------------------
-- INSERT_ASR_RETURNEES
-- ----------------------------------------
--
  procedure INSERT_ASR_RETURNEES
   (pnASR_YEAR in P_BASE.tmnYear,
    pnLOC_ID_ORIGIN_COUNTRY in P_BASE.tmnLOC_ID,
    pnLOC_ID_ASYLUM_COUNTRY in P_BASE.tnLOC_ID,
    pnDST_ID in P_BASE.tmnDST_ID,
    psSOURCE in P_BASE.tsSTGA_CHAR_VALUE,
    psBASIS in P_BASE.tsSTGA_CHAR_VALUE,
    pnREFRTN_VALUE in P_BASE.tnSTC_VALUE,
    pnREFRTN_AH_VALUE in P_BASE.tnSTC_VALUE)
  is
    dSTART_DATE P_BASE.tdDate := to_date(to_char(pnASR_YEAR) || '-01-01', 'YYYY-MM-DD');
    dEND_DATE P_BASE.tdDate := to_date(to_char(pnASR_YEAR + 1) || '-01-01', 'YYYY-MM-DD');
  --
    nSTG_ID_TABLE P_BASE.tnSTG_ID;
    nSTG_VERSION_NBR_TABLE P_BASE.tnSTG_VERSION_NBR;
    nSTG_ID_PRIMARY P_BASE.tnSTG_ID;
    nSTC_ID P_BASE.tnSTC_ID;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_ASR_RETURNEES',
      to_char(pnASR_YEAR)  || '~' || to_char(pnLOC_ID_ORIGIN_COUNTRY) || '~' ||
        to_char(pnLOC_ID_ASYLUM_COUNTRY) || '~' || to_char(pnDST_ID) || '~' ||
        psSOURCE || '~' || psBASIS || '~' ||
        to_char(pnREFRTN_VALUE) || '~' || to_char(pnREFRTN_AH_VALUE));
  --
  -- Check that UNHCR-assisted value is not greater than total value.
  --
    if pnREFRTN_AH_VALUE > pnREFRTN_VALUE
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'UNHCR-assisted value may not be greater than total value');
    end if;
  --
  -- Create new statistic group representing this returnee table row.
  --
    P_STATISTIC_GROUP.INSERT_STATISTIC_GROUP
     (nSTG_ID_PRIMARY, dSTART_DATE, dEND_DATE, 'RETURNEE', pnDST_ID,
      pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
      pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY);
  --
  -- Get identifier and version number of statistic group representing the whole returnee table for
  --  this year and country, creating a new statistic group for this purpose if necessary.
  --
    GET_TABLE_STATISTIC_GROUP(nSTG_ID_TABLE, nSTG_VERSION_NBR_TABLE, nSTG_ID_PRIMARY);
  --
  -- Create statistic group attributes for the source and basis.
  --
    if psSOURCE is not null
    then P_STATISTIC_GROUP.INSERT_STG_ATTRIBUTE(nSTG_ID_PRIMARY, 'SOURCE', psSOURCE);
    end if;
  --
    if psBASIS is not null
    then P_STATISTIC_GROUP.INSERT_STG_ATTRIBUTE(nSTG_ID_PRIMARY, 'BASIS', psBASIS);
    end if;
  --
  -- Create statistics for each of the returnee statistic types and link them to the statistic
  --  groups for the returnee table row and the whole returnee table.
  --
    if pnREFRTN_VALUE is not null
    then
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, pnREFRTN_VALUE,
        dSTART_DATE, dEND_DATE, 'REFRTN', pnDST_ID,
        pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
        pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY);
    --
      P_STATISTIC.INSERT_STATISTIC_IN_GROUP(nSTC_ID, nSTG_ID_TABLE);
    end if;
  --
    if pnREFRTN_AH_VALUE is not null
    then
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, pnREFRTN_AH_VALUE,
        dSTART_DATE, dEND_DATE, 'REFRTN-AH', pnDST_ID,
        pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
        pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY);
    --
      P_STATISTIC.INSERT_STATISTIC_IN_GROUP(nSTC_ID, nSTG_ID_TABLE);
    end if;
  --
  -- Update the statistic group for the whole returnee table to record latest update time and user.
  --
    P_STATISTIC_GROUP.UPDATE_STATISTIC_GROUP(nSTG_ID_TABLE, nSTG_VERSION_NBR_TABLE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_ASR_RETURNEES;
--
-- ----------------------------------------
-- UPDATE_ASR_RETURNEES
-- ----------------------------------------
--
  procedure UPDATE_ASR_RETURNEES
   (pnSTG_ID_PRIMARY in P_BASE.tmnSTG_ID,
    pnLOC_ID_ASYLUM_COUNTRY in P_BASE.tnLOC_ID,
    pnDST_ID in P_BASE.tmnDST_ID,
    psSOURCE in P_BASE.tsSTGA_CHAR_VALUE,
    psBASIS in P_BASE.tsSTGA_CHAR_VALUE,
    pnREFRTN_VALUE in P_BASE.tnSTC_VALUE,
    pnREFRTN_AH_VALUE in P_BASE.tnSTC_VALUE,
    pnSTG_VERSION_NBR in P_BASE.tmnSTG_VERSION_NBR,
    pnSTGA_VERSION_NBR_SOURCE in P_BASE.tnSTGA_VERSION_NBR,
    pnSTGA_VERSION_NBR_BASIS in P_BASE.tnSTGA_VERSION_NBR,
    pnREFRTN_STC_ID in P_BASE.tnSTC_ID,
    pnREFRTN_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR,
    pnREFRTN_AH_STC_ID in P_BASE.tnSTC_ID,
    pnREFRTN_AH_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR)
  is
    nSTG_VERSION_NBR P_BASE.tnSTG_VERSION_NBR := pnSTG_VERSION_NBR;
    nSTGA_VERSION_NBR_SOURCE P_BASE.tnSTGA_VERSION_NBR := pnSTGA_VERSION_NBR_SOURCE;
    nSTGA_VERSION_NBR_BASIS P_BASE.tnSTGA_VERSION_NBR := pnSTGA_VERSION_NBR_BASIS;
  --
    dSTART_DATE P_BASE.tdDate;
    dEND_DATE P_BASE.tdDate;
    nLOC_ID_ORIGIN_COUNTRY P_BASE.tnLOC_ID;
  --
    nSTG_ID_TABLE P_BASE.tnSTG_ID;
    nSTG_VERSION_NBR_TABLE P_BASE.tnSTG_VERSION_NBR;
  --
    nSTC_ID P_BASE.tnSTC_ID;
    nSTC_VERSION_NBR P_BASE.tnSTC_VERSION_NBR;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_ASR_RETURNEES',
      to_char(pnSTG_ID_PRIMARY) || '~' ||
        to_char(pnLOC_ID_ASYLUM_COUNTRY) || '~' || to_char(pnDST_ID) || '~' ||
        psSOURCE || '~' || psBASIS || '~' ||
        to_char(pnREFRTN_VALUE) || '~' || to_char(pnREFRTN_AH_VALUE) || '~' ||
        to_char(pnSTG_VERSION_NBR) || '~' ||
        to_char(pnSTGA_VERSION_NBR_SOURCE) || '~' || to_char(pnSTGA_VERSION_NBR_BASIS) || '~' ||
        to_char(pnREFRTN_STC_ID) || '~' || to_char(pnREFRTN_VERSION_NBR) || '~' ||
        to_char(pnREFRTN_AH_STC_ID) || '~' || to_char(pnREFRTN_AH_VERSION_NBR));
  --
  -- Check that UNHCR-assisted value is not greater than total value.
  --
    if pnREFRTN_AH_VALUE > pnREFRTN_VALUE
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'UNHCR-assisted value may not be greater than total value');
    end if;
  --
  -- Get primary statistics group details for this returnees table row.
  --
    select START_DATE, END_DATE, LOC_ID_ORIGIN_COUNTRY
    into dSTART_DATE, dEND_DATE, nLOC_ID_ORIGIN_COUNTRY
    from T_STATISTIC_GROUPS
    where ID = pnSTG_ID_PRIMARY;
  --
  -- Get identifier and version number of statistic group representing the whole returnee table for
  --  this year and country.
  --
    GET_TABLE_STATISTIC_GROUP(nSTG_ID_TABLE, nSTG_VERSION_NBR_TABLE, pnSTG_ID_PRIMARY);
  --
  -- Insert, update or delete statistic group attributes for the source and basis.
  --
    SET_STG_ATTRIBUTE(pnSTG_ID_PRIMARY, 'SOURCE', nSTGA_VERSION_NBR_SOURCE, psSOURCE);
    SET_STG_ATTRIBUTE(pnSTG_ID_PRIMARY, 'BASIS', nSTGA_VERSION_NBR_BASIS, psBASIS);
  --
  -- Insert, update or delete statistics for each of the returnee statistic types.
  --
    nSTC_ID := pnREFRTN_STC_ID;
    nSTC_VERSION_NBR := pnREFRTN_VERSION_NBR;
    SET_STATISTIC
     (nSTC_ID, nSTC_VERSION_NBR, pnREFRTN_VALUE,
      dSTART_DATE, dEND_DATE, 'REFRTN', pnDST_ID,
      pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
      pnLOC_ID_ORIGIN_COUNTRY => nLOC_ID_ORIGIN_COUNTRY,
      pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
      pnSTG_ID_TABLE => nSTG_ID_TABLE);
  -- 
    nSTC_ID := pnREFRTN_AH_STC_ID;
    nSTC_VERSION_NBR := pnREFRTN_AH_VERSION_NBR;
    SET_STATISTIC
     (nSTC_ID, nSTC_VERSION_NBR, pnREFRTN_AH_VALUE,
      dSTART_DATE, dEND_DATE, 'REFRTN-AH', pnDST_ID,
      pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
      pnLOC_ID_ORIGIN_COUNTRY => nLOC_ID_ORIGIN_COUNTRY,
      pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY, 
      pnSTG_ID_TABLE => nSTG_ID_TABLE);
  --
  -- Update primary statistic group with changes to dimensions and to record latest update details.
  --
    P_STATISTIC_GROUP.UPDATE_STATISTIC_GROUP
     (pnSTG_ID_PRIMARY, nSTG_VERSION_NBR,
      pnDST_ID => pnDST_ID,
      pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY);
  --
  -- Update statistic group representing the whole returnee table to record latest update details.
  --
    P_STATISTIC_GROUP.UPDATE_STATISTIC_GROUP(nSTG_ID_TABLE, nSTG_VERSION_NBR_TABLE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end UPDATE_ASR_RETURNEES;
--
-- ----------------------------------------
-- DELETE_ASR_RETURNEES
-- ----------------------------------------
--
  procedure DELETE_ASR_RETURNEES
   (pnSTG_ID_PRIMARY in P_BASE.tmnSTG_ID,
    pnSTG_VERSION_NBR in P_BASE.tmnSTG_VERSION_NBR,
    pnSTGA_VERSION_NBR_SOURCE in P_BASE.tnSTGA_VERSION_NBR,
    pnSTGA_VERSION_NBR_BASIS in P_BASE.tnSTGA_VERSION_NBR,
    pnREFRTN_STC_ID in P_BASE.tnSTC_ID,
    pnREFRTN_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR,
    pnREFRTN_AH_STC_ID in P_BASE.tnSTC_ID,
    pnREFRTN_AH_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR)
  is
    nSTG_VERSION_NBR P_BASE.tnSTG_VERSION_NBR := pnSTG_VERSION_NBR;
    nSTGA_VERSION_NBR_SOURCE P_BASE.tnSTGA_VERSION_NBR := pnSTGA_VERSION_NBR_SOURCE;
    nSTGA_VERSION_NBR_BASIS P_BASE.tnSTGA_VERSION_NBR := pnSTGA_VERSION_NBR_BASIS;
  --
    nSTG_ID_TABLE P_BASE.tnSTG_ID;
    nSTG_VERSION_NBR_TABLE P_BASE.tnSTG_VERSION_NBR;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_ASR_RETURNEES',
      to_char(pnSTG_ID_PRIMARY)  || '~' || to_char(pnSTG_VERSION_NBR) || '~' ||
        to_char(pnSTGA_VERSION_NBR_SOURCE) || '~' || to_char(pnSTGA_VERSION_NBR_BASIS) || '~' ||
        to_char(pnREFRTN_STC_ID) || '~' || to_char(pnREFRTN_VERSION_NBR) || '~' ||
        to_char(pnREFRTN_AH_STC_ID) || '~' || to_char(pnREFRTN_AH_VERSION_NBR));
  --
  -- Get identifier and version number of statistic group representing the whole returnee table for
  --  this year and country.
  --
    GET_TABLE_STATISTIC_GROUP(nSTG_ID_TABLE, nSTG_VERSION_NBR_TABLE, pnSTG_ID_PRIMARY);
  --
  -- Delete the statistics for each of the returnee statistic types.
  --
    if pnREFRTN_STC_ID is not null
    then P_STATISTIC.DELETE_STATISTIC(pnREFRTN_STC_ID, pnREFRTN_VERSION_NBR);
    end if;
  --
    if pnREFRTN_AH_STC_ID is not null
    then P_STATISTIC.DELETE_STATISTIC(pnREFRTN_AH_STC_ID, pnREFRTN_AH_VERSION_NBR);
    end if;
  --
  -- Delete the source and basis statistic group attributes and the primary statistic group.
  --
    if nSTGA_VERSION_NBR_SOURCE is not null
    then
      P_STATISTIC_GROUP.DELETE_STG_ATTRIBUTE(pnSTG_ID_PRIMARY, 'SOURCE', nSTGA_VERSION_NBR_SOURCE);
    end if;
  --
    if nSTGA_VERSION_NBR_BASIS is not null
    then
      P_STATISTIC_GROUP.DELETE_STG_ATTRIBUTE(pnSTG_ID_PRIMARY, 'BASIS', nSTGA_VERSION_NBR_BASIS);
    end if;
  --
    P_STATISTIC_GROUP.DELETE_STATISTIC_GROUP(pnSTG_ID_PRIMARY, nSTG_VERSION_NBR);
  --
  -- Update the statistic group for the whole returnee table to record latest update details.
  --
    P_STATISTIC_GROUP.UPDATE_STATISTIC_GROUP(nSTG_ID_TABLE, nSTG_VERSION_NBR_TABLE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_ASR_RETURNEES;
--
-- ----------------------------------------
-- INSERT_ASR_STATELESS
-- ----------------------------------------
--
  procedure INSERT_ASR_STATELESS
   (pnASR_YEAR in P_BASE.tmnYear,
    pnLOC_ID_ASYLUM_COUNTRY in P_BASE.tmnLOC_ID,
    pnDIM_ID_SPOPTYPE in P_BASE.tmnDIM_ID,
    psLANG_CODE in P_BASE.tsLANG_CODE,
    psSUBGROUP_NAME in P_BASE.tsText,
    psSOURCE in P_BASE.tsSTGA_CHAR_VALUE,
    psBASIS in P_BASE.tsSTGA_CHAR_VALUE,
    pnSTAPOP_START_VALUE in P_BASE.tnSTC_VALUE,
    pnSTAPOP_AH_START_VALUE in P_BASE.tnSTC_VALUE,
    pnNATLOSS_VALUE in P_BASE.tnSTC_VALUE,
    pnSTAOTHINC_VALUE in P_BASE.tnSTC_VALUE,
    pnNATACQ_VALUE in P_BASE.tnSTC_VALUE,
    pnSTAOTHDEC_VALUE in P_BASE.tnSTC_VALUE,
    pnSTAPOP_END_VALUE in P_BASE.tnSTC_VALUE,
    pnSTAPOP_AH_END_VALUE in P_BASE.tnSTC_VALUE)
  is
    dSTART_DATE_START P_BASE.tdDate := to_date(to_char(pnASR_YEAR) || '-01-01', 'YYYY-MM-DD');
    dEND_DATE_START P_BASE.tdDate := to_date(to_char(pnASR_YEAR) || '-01-02', 'YYYY-MM-DD');
    dSTART_DATE_END P_BASE.tdDate := to_date(to_char(pnASR_YEAR) || '-12-31', 'YYYY-MM-DD');
    dEND_DATE_END P_BASE.tdDate := to_date(to_char(pnASR_YEAR + 1) || '-01-01', 'YYYY-MM-DD');
  --
    nSTG_ID_TABLE P_BASE.tnSTG_ID;
    nSTG_VERSION_NBR_TABLE P_BASE.tnSTG_VERSION_NBR;
    nSTG_ID_PRIMARY P_BASE.tnSTG_ID;
    nSTG_VERSION_NBR_PRIMARY P_BASE.tnSTG_VERSION_NBR;
    nTXT_SEQ_NBR_PRIMARY P_BASE.tnTXT_SEQ_NBR;
    nSTC_ID P_BASE.tnSTC_ID;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_ASR_STATELESS',
      to_char(pnASR_YEAR)  || '~' || to_char(pnLOC_ID_ASYLUM_COUNTRY) || '~' ||
        to_char(pnDIM_ID_SPOPTYPE) || '~' || psSOURCE || '~' || psBASIS || '~' ||
        to_char(pnSTAPOP_START_VALUE) || '~' || to_char(pnSTAPOP_AH_START_VALUE) || '~' ||
        to_char(pnNATLOSS_VALUE) || '~' || to_char(pnSTAOTHINC_VALUE) || '~' ||
        to_char(pnNATACQ_VALUE) || '~' || to_char(pnSTAOTHDEC_VALUE) || '~' ||
        to_char(pnSTAPOP_END_VALUE) || '~' || to_char(pnSTAPOP_AH_END_VALUE) || '~' ||
        psLANG_CODE || '~' || to_char(length(psSUBGROUP_NAME)) || ':' || psSUBGROUP_NAME);
  --
  -- Check that UNHCR-assisted values are not greater than total values.
  --
    if pnSTAPOP_AH_START_VALUE > pnSTAPOP_START_VALUE
      or pnSTAPOP_AH_END_VALUE > pnSTAPOP_END_VALUE
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'UNHCR-assisted value may not be greater than total value');
    end if;
  --
  -- Create new statistic group representing this stateless table row.
  --
    P_STATISTIC_GROUP.INSERT_STATISTIC_GROUP
     (nSTG_ID_PRIMARY, dSTART_DATE_START, dEND_DATE_END, 'STATELESS',
      pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
      pnLOC_ID_ORIGIN_COUNTRY => gnLOC_ID_STATELESS,
      pnDIM_ID1 => pnDIM_ID_SPOPTYPE,
      psLANG_CODE => psLANG_CODE,
      psSUBGROUP_NAME => psSUBGROUP_NAME);
  --
  -- Get identifier and version number of statistic group representing the whole stateless table for
  --  this year and country, creating a new statistic group for this purpose if necessary.
  --
    GET_TABLE_STATISTIC_GROUP(nSTG_ID_TABLE, nSTG_VERSION_NBR_TABLE, nSTG_ID_PRIMARY);
  --
  -- Create statistic group attributes for the source and basis.
  --
    if psSOURCE is not null
    then P_STATISTIC_GROUP.INSERT_STG_ATTRIBUTE(nSTG_ID_PRIMARY, 'SOURCE', psSOURCE);
    end if;
  --
    if psBASIS is not null
    then P_STATISTIC_GROUP.INSERT_STG_ATTRIBUTE(nSTG_ID_PRIMARY, 'BASIS', psBASIS);
    end if;
  --
  -- Create statistics for each of the stateless statistic types and link them to the statistic
  --  group for the stateless table row and the whole stateless table.
  --
    if pnSTAPOP_START_VALUE is not null
    then
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, pnSTAPOP_START_VALUE,
        dSTART_DATE_START, dEND_DATE_START, 'STAPOP', gnDST_ID_STATELESS,
        pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => gnLOC_ID_STATELESS,
        pnDIM_ID1 => pnDIM_ID_SPOPTYPE,
        pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY);
    --
      P_STATISTIC.INSERT_STATISTIC_IN_GROUP(nSTC_ID, nSTG_ID_TABLE);
    end if;
  --
    if pnSTAPOP_AH_START_VALUE is not null
    then
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, pnSTAPOP_AH_START_VALUE,
        dSTART_DATE_START, dEND_DATE_START, 'STAPOP-AH', gnDST_ID_STATELESS,
        pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => gnLOC_ID_STATELESS,
        pnDIM_ID1 => pnDIM_ID_SPOPTYPE,
        pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY);
    --
      P_STATISTIC.INSERT_STATISTIC_IN_GROUP(nSTC_ID, nSTG_ID_TABLE);
    end if;
  --
    if pnNATLOSS_VALUE is not null
    then
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, pnNATLOSS_VALUE,
        dSTART_DATE_START, dEND_DATE_END, 'NATLOSS', gnDST_ID_STATELESS,
        pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => gnLOC_ID_STATELESS,
        pnDIM_ID1 => pnDIM_ID_SPOPTYPE,
        pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY);
    --
      P_STATISTIC.INSERT_STATISTIC_IN_GROUP(nSTC_ID, nSTG_ID_TABLE);
    end if;
  --
    if pnSTAOTHINC_VALUE is not null
    then
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, pnSTAOTHINC_VALUE,
        dSTART_DATE_START, dEND_DATE_END, 'STAOTHINC', gnDST_ID_STATELESS,
        pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => gnLOC_ID_STATELESS,
        pnDIM_ID1 => pnDIM_ID_SPOPTYPE,
        pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY);
    --
      P_STATISTIC.INSERT_STATISTIC_IN_GROUP(nSTC_ID, nSTG_ID_TABLE);
    end if;
  --
    if pnNATACQ_VALUE is not null
    then
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, pnNATACQ_VALUE,
        dSTART_DATE_START, dEND_DATE_END, 'NATACQ', gnDST_ID_STATELESS,
        pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => gnLOC_ID_STATELESS,
        pnDIM_ID1 => pnDIM_ID_SPOPTYPE,
        pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY);
    --
      P_STATISTIC.INSERT_STATISTIC_IN_GROUP(nSTC_ID, nSTG_ID_TABLE);
    end if;
  --
    if pnSTAOTHDEC_VALUE is not null
    then
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, pnSTAOTHDEC_VALUE,
        dSTART_DATE_START, dEND_DATE_END, 'STAOTHDEC', gnDST_ID_STATELESS,
        pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => gnLOC_ID_STATELESS,
        pnDIM_ID1 => pnDIM_ID_SPOPTYPE,
        pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY);
    --
      P_STATISTIC.INSERT_STATISTIC_IN_GROUP(nSTC_ID, nSTG_ID_TABLE);
    end if;
  --
    if pnSTAPOP_END_VALUE is not null
    then
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, pnSTAPOP_END_VALUE,
        dSTART_DATE_END, dEND_DATE_END, 'STAPOP', gnDST_ID_STATELESS,
        pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => gnLOC_ID_STATELESS,
        pnDIM_ID1 => pnDIM_ID_SPOPTYPE,
        pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY);
    --
      P_STATISTIC.INSERT_STATISTIC_IN_GROUP(nSTC_ID, nSTG_ID_TABLE);
    end if;
  --
    if pnSTAPOP_AH_END_VALUE is not null
    then
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, pnSTAPOP_AH_END_VALUE,
        dSTART_DATE_END, dEND_DATE_END, 'STAPOP-AH', gnDST_ID_STATELESS,
        pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => gnLOC_ID_STATELESS,
        pnDIM_ID1 => pnDIM_ID_SPOPTYPE,
        pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY);
    --
      P_STATISTIC.INSERT_STATISTIC_IN_GROUP(nSTC_ID, nSTG_ID_TABLE);
    end if;
  --
  -- Update the statistic group for the whole stateless table to record latest update details.
  --
    P_STATISTIC_GROUP.UPDATE_STATISTIC_GROUP(nSTG_ID_TABLE, nSTG_VERSION_NBR_TABLE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_ASR_STATELESS;
--
-- ----------------------------------------
-- UPDATE_ASR_STATELESS
-- ----------------------------------------
--
  procedure UPDATE_ASR_STATELESS
   (pnSTG_ID_PRIMARY in P_BASE.tmnSTG_ID,
    pnDIM_ID_SPOPTYPE in P_BASE.tmnDIM_ID,
    psLANG_CODE in P_BASE.tsLANG_CODE,
    psSUBGROUP_NAME in P_BASE.tsText,
    psSOURCE in P_BASE.tsSTGA_CHAR_VALUE,
    psBASIS in P_BASE.tsSTGA_CHAR_VALUE,
    pnSTAPOP_START_VALUE in P_BASE.tnSTC_VALUE,
    pnSTAPOP_AH_START_VALUE in P_BASE.tnSTC_VALUE,
    pnNATLOSS_VALUE in P_BASE.tnSTC_VALUE,
    pnSTAOTHINC_VALUE in P_BASE.tnSTC_VALUE,
    pnNATACQ_VALUE in P_BASE.tnSTC_VALUE,
    pnSTAOTHDEC_VALUE in P_BASE.tnSTC_VALUE,
    pnSTAPOP_END_VALUE in P_BASE.tnSTC_VALUE,
    pnSTAPOP_AH_END_VALUE in P_BASE.tnSTC_VALUE,
    pnSTG_VERSION_NBR in P_BASE.tmnSTG_VERSION_NBR,
    pnSTGA_VERSION_NBR_SOURCE in P_BASE.tnSTGA_VERSION_NBR,
    pnSTGA_VERSION_NBR_BASIS in P_BASE.tnSTGA_VERSION_NBR,
    pnSTAPOP_START_STC_ID in P_BASE.tnSTC_ID,
    pnSTAPOP_START_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR,
    pnSTAPOP_AH_START_STC_ID in P_BASE.tnSTC_ID,
    pnSTAPOP_AH_START_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR,
    pnNATLOSS_STC_ID in P_BASE.tnSTC_ID,
    pnNATLOSS_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR,
    pnSTAOTHINC_STC_ID in P_BASE.tnSTC_ID,
    pnSTAOTHINC_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR,
    pnNATACQ_STC_ID in P_BASE.tnSTC_ID,
    pnNATACQ_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR,
    pnSTAOTHDEC_STC_ID in P_BASE.tnSTC_ID,
    pnSTAOTHDEC_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR,
    pnSTAPOP_END_STC_ID in P_BASE.tnSTC_ID,
    pnSTAPOP_END_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR,
    pnSTAPOP_AH_END_STC_ID in P_BASE.tnSTC_ID,
    pnSTAPOP_AH_END_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR)
  is
    nSTG_VERSION_NBR P_BASE.tnSTG_VERSION_NBR := pnSTG_VERSION_NBR;
    nSTGA_VERSION_NBR_SOURCE P_BASE.tnSTGA_VERSION_NBR := pnSTGA_VERSION_NBR_SOURCE;
    nSTGA_VERSION_NBR_BASIS P_BASE.tnSTGA_VERSION_NBR := pnSTGA_VERSION_NBR_BASIS;
  --
    dSTART_DATE_START P_BASE.tdDate;
    dEND_DATE_START P_BASE.tdDate;
    dSTART_DATE_END P_BASE.tdDate;
    dEND_DATE_END P_BASE.tdDate;
    nLOC_ID_ASYLUM_COUNTRY P_BASE.tnLOC_ID;
  --
    nSTG_ID_TABLE P_BASE.tnSTG_ID;
    nSTG_VERSION_NBR_TABLE P_BASE.tnSTG_VERSION_NBR;
  --
    nSTC_ID P_BASE.tnSTC_ID;
    nSTC_VERSION_NBR P_BASE.tnSTC_VERSION_NBR;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_ASR_STATELESS',
      to_char(pnSTG_ID_PRIMARY) || '~' ||
        to_char(pnDIM_ID_SPOPTYPE) || '~' || psSOURCE || '~' || psBASIS || '~' ||
        to_char(pnSTAPOP_START_VALUE) || '~' || to_char(pnSTAPOP_AH_START_VALUE) || '~' ||
        to_char(pnNATLOSS_VALUE) || '~' || to_char(pnSTAOTHINC_VALUE) || '~' ||
        to_char(pnNATACQ_VALUE) || '~' || to_char(pnSTAOTHDEC_VALUE) || '~' ||
        to_char(pnSTAPOP_END_VALUE) || '~' || to_char(pnSTAPOP_AH_END_VALUE) || '~' ||
        to_char(pnSTG_VERSION_NBR) || '~' ||
        to_char(pnSTGA_VERSION_NBR_SOURCE) || '~' || to_char(pnSTGA_VERSION_NBR_BASIS) || '~' ||
        to_char(pnSTAPOP_START_STC_ID) || '~' || to_char(pnSTAPOP_START_VERSION_NBR) || '~' ||
        to_char(pnSTAPOP_AH_START_STC_ID) || '~' || to_char(pnSTAPOP_AH_START_VERSION_NBR) || '~' ||
        to_char(pnNATLOSS_STC_ID) || '~' || to_char(pnNATLOSS_VERSION_NBR) || '~' ||
        to_char(pnSTAOTHINC_STC_ID) || '~' || to_char(pnSTAOTHINC_VERSION_NBR) || '~' ||
        to_char(pnNATACQ_STC_ID) || '~' || to_char(pnNATACQ_VERSION_NBR) || '~' ||
        to_char(pnSTAOTHDEC_STC_ID) || '~' || to_char(pnSTAOTHDEC_VERSION_NBR) || '~' ||
        to_char(pnSTAPOP_END_STC_ID) || '~' || to_char(pnSTAPOP_END_VERSION_NBR) || '~' ||
        to_char(pnSTAPOP_AH_END_STC_ID) || '~' || to_char(pnSTAPOP_AH_END_VERSION_NBR) || '~' ||
        psLANG_CODE || '~' || to_char(length(psSUBGROUP_NAME)) || ':' || psSUBGROUP_NAME);
  --
  -- Check that UNHCR-assisted values are not greater than total values.
  --
    if pnSTAPOP_AH_START_VALUE > pnSTAPOP_START_VALUE
      or pnSTAPOP_AH_END_VALUE > pnSTAPOP_END_VALUE
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'UNHCR-assisted value may not be greater than total value');
    end if;
  --
  -- Get primary statistics group details for this stateless table row.
  --
    select START_DATE, START_DATE + 1, END_DATE - 1, END_DATE, LOC_ID_ASYLUM_COUNTRY
    into dSTART_DATE_START, dEND_DATE_START, dSTART_DATE_END, dEND_DATE_END, nLOC_ID_ASYLUM_COUNTRY
    from T_STATISTIC_GROUPS
    where ID = pnSTG_ID_PRIMARY;
  --
  -- Get identifier and version number of statistic group representing the whole stateless table for
  --  this year and country.
  --
    GET_TABLE_STATISTIC_GROUP(nSTG_ID_TABLE, nSTG_VERSION_NBR_TABLE, pnSTG_ID_PRIMARY);
  --
  -- Insert, update or delete statistic group attributes for the source and basis.
  --
    SET_STG_ATTRIBUTE(pnSTG_ID_PRIMARY, 'SOURCE', nSTGA_VERSION_NBR_SOURCE, psSOURCE);
    SET_STG_ATTRIBUTE(pnSTG_ID_PRIMARY, 'BASIS', nSTGA_VERSION_NBR_BASIS, psBASIS);
  --
  -- Insert, update or delete statistics for each of the stateless statistic types.
  -- 
    nSTC_ID := pnSTAPOP_START_STC_ID;
    nSTC_VERSION_NBR := pnSTAPOP_START_VERSION_NBR;
    SET_STATISTIC
     (nSTC_ID, nSTC_VERSION_NBR, pnSTAPOP_START_VALUE,
      dSTART_DATE_START, dEND_DATE_START, 'STAPOP', gnDST_ID_STATELESS,
      pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
      pnLOC_ID_ORIGIN_COUNTRY => gnLOC_ID_STATELESS,
      pnDIM_ID1 => pnDIM_ID_SPOPTYPE,
      pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
      pnSTG_ID_TABLE => nSTG_ID_TABLE);
  -- 
    nSTC_ID := pnSTAPOP_AH_START_STC_ID;
    nSTC_VERSION_NBR := pnSTAPOP_AH_START_VERSION_NBR;
    SET_STATISTIC
     (nSTC_ID, nSTC_VERSION_NBR, pnSTAPOP_AH_START_VALUE,
      dSTART_DATE_START, dEND_DATE_START, 'STAPOP-AH', gnDST_ID_STATELESS,
      pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
      pnLOC_ID_ORIGIN_COUNTRY => gnLOC_ID_STATELESS,
      pnDIM_ID1 => pnDIM_ID_SPOPTYPE,
      pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
      pnSTG_ID_TABLE => nSTG_ID_TABLE);
  -- 
    nSTC_ID := pnNATLOSS_STC_ID;
    nSTC_VERSION_NBR := pnNATLOSS_VERSION_NBR;
    SET_STATISTIC
     (nSTC_ID, nSTC_VERSION_NBR, pnNATLOSS_VALUE,
      dSTART_DATE_START, dEND_DATE_END, 'NATLOSS', gnDST_ID_STATELESS,
      pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
      pnLOC_ID_ORIGIN_COUNTRY => gnLOC_ID_STATELESS,
      pnDIM_ID1 => pnDIM_ID_SPOPTYPE,
      pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
      pnSTG_ID_TABLE => nSTG_ID_TABLE);
  -- 
    nSTC_ID := pnSTAOTHINC_STC_ID;
    nSTC_VERSION_NBR := pnSTAOTHINC_VERSION_NBR;
    SET_STATISTIC
     (nSTC_ID, nSTC_VERSION_NBR, pnSTAOTHINC_VALUE,
      dSTART_DATE_START, dEND_DATE_END, 'STAOTHINC', gnDST_ID_STATELESS,
      pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
      pnLOC_ID_ORIGIN_COUNTRY => gnLOC_ID_STATELESS,
      pnDIM_ID1 => pnDIM_ID_SPOPTYPE,
      pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
      pnSTG_ID_TABLE => nSTG_ID_TABLE);
  -- 
    nSTC_ID := pnNATACQ_STC_ID;
    nSTC_VERSION_NBR := pnNATACQ_VERSION_NBR;
    SET_STATISTIC
     (nSTC_ID, nSTC_VERSION_NBR, pnNATACQ_VALUE,
      dSTART_DATE_START, dEND_DATE_END, 'NATACQ', gnDST_ID_STATELESS,
      pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
      pnLOC_ID_ORIGIN_COUNTRY => gnLOC_ID_STATELESS,
      pnDIM_ID1 => pnDIM_ID_SPOPTYPE,
      pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
      pnSTG_ID_TABLE => nSTG_ID_TABLE);
  -- 
    nSTC_ID := pnSTAOTHDEC_STC_ID;
    nSTC_VERSION_NBR := pnSTAOTHDEC_VERSION_NBR;
    SET_STATISTIC
     (nSTC_ID, nSTC_VERSION_NBR, pnSTAOTHDEC_VALUE,
      dSTART_DATE_START, dEND_DATE_END, 'STAOTHDEC', gnDST_ID_STATELESS,
      pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
      pnLOC_ID_ORIGIN_COUNTRY => gnLOC_ID_STATELESS,
      pnDIM_ID1 => pnDIM_ID_SPOPTYPE,
      pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
      pnSTG_ID_TABLE => nSTG_ID_TABLE);
  -- 
    nSTC_ID := pnSTAPOP_END_STC_ID;
    nSTC_VERSION_NBR := pnSTAPOP_END_VERSION_NBR;
    SET_STATISTIC
     (nSTC_ID, nSTC_VERSION_NBR, pnSTAPOP_END_VALUE,
      dSTART_DATE_END, dEND_DATE_END, 'STAPOP', gnDST_ID_STATELESS,
      pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
      pnLOC_ID_ORIGIN_COUNTRY => gnLOC_ID_STATELESS,
      pnDIM_ID1 => pnDIM_ID_SPOPTYPE,
      pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
      pnSTG_ID_TABLE => nSTG_ID_TABLE);
  -- 
    nSTC_ID := pnSTAPOP_AH_END_STC_ID;
    nSTC_VERSION_NBR := pnSTAPOP_AH_END_VERSION_NBR;
    SET_STATISTIC
     (nSTC_ID, nSTC_VERSION_NBR, pnSTAPOP_AH_END_VALUE,
      dSTART_DATE_END, dEND_DATE_END, 'STAPOP-AH', gnDST_ID_STATELESS,
      pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
      pnLOC_ID_ORIGIN_COUNTRY => gnLOC_ID_STATELESS,
      pnDIM_ID1 => pnDIM_ID_SPOPTYPE,
      pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
      pnSTG_ID_TABLE => nSTG_ID_TABLE);
  --
  -- Update primary statistic group with changes to dimensions and/or subgroup name and to record
  --  latest update details.
  --
    P_STATISTIC_GROUP.UPDATE_STATISTIC_GROUP
     (pnSTG_ID_PRIMARY, nSTG_VERSION_NBR,
      pnDIM_ID1 => pnDIM_ID_SPOPTYPE,
      psLANG_CODE => psLANG_CODE,
      psSUBGROUP_NAME => psSUBGROUP_NAME);
  --
  -- Update statistic group representing the whole stateless table to record latest update details.
  --
    P_STATISTIC_GROUP.UPDATE_STATISTIC_GROUP(nSTG_ID_TABLE, nSTG_VERSION_NBR_TABLE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end UPDATE_ASR_STATELESS;
--
-- ----------------------------------------
-- DELETE_ASR_STATELESS
-- ----------------------------------------
--
  procedure DELETE_ASR_STATELESS
   (pnSTG_ID_PRIMARY in P_BASE.tmnSTG_ID,
    pnSTG_VERSION_NBR in P_BASE.tmnSTG_VERSION_NBR,
    pnSTGA_VERSION_NBR_SOURCE in P_BASE.tnSTGA_VERSION_NBR,
    pnSTGA_VERSION_NBR_BASIS in P_BASE.tnSTGA_VERSION_NBR,
    pnSTAPOP_START_STC_ID in P_BASE.tnSTC_ID,
    pnSTAPOP_START_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR,
    pnSTAPOP_AH_START_STC_ID in P_BASE.tnSTC_ID,
    pnSTAPOP_AH_START_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR,
    pnNATLOSS_STC_ID in P_BASE.tnSTC_ID,
    pnNATLOSS_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR,
    pnSTAOTHINC_STC_ID in P_BASE.tnSTC_ID,
    pnSTAOTHINC_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR,
    pnNATACQ_STC_ID in P_BASE.tnSTC_ID,
    pnNATACQ_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR,
    pnSTAOTHDEC_STC_ID in P_BASE.tnSTC_ID,
    pnSTAOTHDEC_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR,
    pnSTAPOP_END_STC_ID in P_BASE.tnSTC_ID,
    pnSTAPOP_END_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR,
    pnSTAPOP_AH_END_STC_ID in P_BASE.tnSTC_ID,
    pnSTAPOP_AH_END_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR)
  is
    nSTG_VERSION_NBR P_BASE.tnSTG_VERSION_NBR := pnSTG_VERSION_NBR;
    nSTGA_VERSION_NBR_SOURCE P_BASE.tnSTGA_VERSION_NBR := pnSTGA_VERSION_NBR_SOURCE;
    nSTGA_VERSION_NBR_BASIS P_BASE.tnSTGA_VERSION_NBR := pnSTGA_VERSION_NBR_BASIS;
  --
    nSTG_ID_TABLE P_BASE.tnSTG_ID;
    nSTG_VERSION_NBR_TABLE P_BASE.tnSTG_VERSION_NBR;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_ASR_STATELESS',
      to_char(pnSTG_ID_PRIMARY) || '~' || to_char(pnSTG_VERSION_NBR) || '~' ||
        to_char(pnSTGA_VERSION_NBR_SOURCE) || '~' || to_char(pnSTGA_VERSION_NBR_BASIS) || '~' ||
        to_char(pnSTAPOP_START_STC_ID) || '~' || to_char(pnSTAPOP_START_VERSION_NBR) || '~' ||
        to_char(pnSTAPOP_AH_START_STC_ID) || '~' || to_char(pnSTAPOP_AH_START_VERSION_NBR) || '~' ||
        to_char(pnNATLOSS_STC_ID) || '~' || to_char(pnNATLOSS_VERSION_NBR) || '~' ||
        to_char(pnSTAOTHINC_STC_ID) || '~' || to_char(pnSTAOTHINC_VERSION_NBR) || '~' ||
        to_char(pnNATACQ_STC_ID) || '~' || to_char(pnNATACQ_VERSION_NBR) || '~' ||
        to_char(pnSTAOTHDEC_STC_ID) || '~' || to_char(pnSTAOTHDEC_VERSION_NBR) || '~' ||
        to_char(pnSTAPOP_END_STC_ID) || '~' || to_char(pnSTAPOP_END_VERSION_NBR) || '~' ||
        to_char(pnSTAPOP_AH_END_STC_ID) || '~' || to_char(pnSTAPOP_AH_END_VERSION_NBR));
  --
  -- Get identifier and version number of statistic group representing the whole stateless table for
  --  this year and country.
  --
    GET_TABLE_STATISTIC_GROUP(nSTG_ID_TABLE, nSTG_VERSION_NBR_TABLE, pnSTG_ID_PRIMARY);
  --
  -- Delete the statistics for each of the stateless statistic types.
  --
    if pnSTAPOP_START_STC_ID is not null
    then P_STATISTIC.DELETE_STATISTIC(pnSTAPOP_START_STC_ID, pnSTAPOP_START_VERSION_NBR);
    end if;
  --
    if pnSTAPOP_AH_START_STC_ID is not null
    then P_STATISTIC.DELETE_STATISTIC(pnSTAPOP_AH_START_STC_ID, pnSTAPOP_AH_START_VERSION_NBR);
    end if;
  --
    if pnNATLOSS_STC_ID is not null
    then P_STATISTIC.DELETE_STATISTIC(pnNATLOSS_STC_ID, pnNATLOSS_VERSION_NBR);
    end if;
  --
    if pnSTAOTHINC_STC_ID is not null
    then P_STATISTIC.DELETE_STATISTIC(pnSTAOTHINC_STC_ID, pnSTAOTHINC_VERSION_NBR);
    end if;
  --
    if pnNATACQ_STC_ID is not null
    then P_STATISTIC.DELETE_STATISTIC(pnNATACQ_STC_ID, pnNATACQ_VERSION_NBR);
    end if;
  --
    if pnSTAOTHDEC_STC_ID is not null
    then P_STATISTIC.DELETE_STATISTIC(pnSTAOTHDEC_STC_ID, pnSTAOTHDEC_VERSION_NBR);
    end if;
  --
    if pnSTAPOP_END_STC_ID is not null
    then P_STATISTIC.DELETE_STATISTIC(pnSTAPOP_END_STC_ID, pnSTAPOP_END_VERSION_NBR);
    end if;
  --
    if pnSTAPOP_AH_END_STC_ID is not null
    then P_STATISTIC.DELETE_STATISTIC(pnSTAPOP_AH_END_STC_ID, pnSTAPOP_AH_END_VERSION_NBR);
    end if;
  --
  -- Delete the source and basis statistic group attributes and the primary statistic group.
  --
    if nSTGA_VERSION_NBR_SOURCE is not null
    then
      P_STATISTIC_GROUP.DELETE_STG_ATTRIBUTE(pnSTG_ID_PRIMARY, 'SOURCE', nSTGA_VERSION_NBR_SOURCE);
    end if;
  --
    if nSTGA_VERSION_NBR_BASIS is not null
    then
      P_STATISTIC_GROUP.DELETE_STG_ATTRIBUTE(pnSTG_ID_PRIMARY, 'BASIS', nSTGA_VERSION_NBR_BASIS);
    end if;
  --
    P_STATISTIC_GROUP.DELETE_STATISTIC_GROUP(pnSTG_ID_PRIMARY, nSTG_VERSION_NBR);
  --
  -- Update the statistic group for the whole stateless table to record latest update details.
  --
    P_STATISTIC_GROUP.UPDATE_STATISTIC_GROUP(nSTG_ID_TABLE, nSTG_VERSION_NBR_TABLE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_ASR_STATELESS;
--
-- ----------------------------------------
-- INSERT_ASR_OOC
-- ----------------------------------------
--
  procedure INSERT_ASR_OOC
   (pnASR_YEAR in P_BASE.tmnYear,
    pnLOC_ID_ASYLUM_COUNTRY in P_BASE.tmnLOC_ID,
    pnLOC_ID_ORIGIN_COUNTRY in P_BASE.tnLOC_ID,
    psLANG_CODE in P_BASE.tsLANG_CODE,
    psSUBGROUP_NAME in P_BASE.tsText,
    psSOURCE in P_BASE.tsSTGA_CHAR_VALUE,
    psBASIS in P_BASE.tsSTGA_CHAR_VALUE,
    pnOOCPOP_START_VALUE in P_BASE.tnSTC_VALUE,
    pnOOCPOP_AH_START_VALUE in P_BASE.tnSTC_VALUE,
    pnOOCARR_VALUE in P_BASE.tnSTC_VALUE,
    pnOOCOTHINC_VALUE in P_BASE.tnSTC_VALUE,
    pnOOCRTN_VALUE in P_BASE.tnSTC_VALUE,
    pnOOCOTHDEC_VALUE in P_BASE.tnSTC_VALUE,
    pnOOCPOP_END_VALUE in P_BASE.tnSTC_VALUE,
    pnOOCPOP_AH_END_VALUE in P_BASE.tnSTC_VALUE)
  is
    dSTART_DATE_START P_BASE.tdDate := to_date(to_char(pnASR_YEAR) || '-01-01', 'YYYY-MM-DD');
    dEND_DATE_START P_BASE.tdDate := to_date(to_char(pnASR_YEAR) || '-01-02', 'YYYY-MM-DD');
    dSTART_DATE_END P_BASE.tdDate := to_date(to_char(pnASR_YEAR) || '-12-31', 'YYYY-MM-DD');
    dEND_DATE_END P_BASE.tdDate := to_date(to_char(pnASR_YEAR + 1) || '-01-01', 'YYYY-MM-DD');
  --
    nSTG_ID_TABLE P_BASE.tnSTG_ID;
    nSTG_VERSION_NBR_TABLE P_BASE.tnSTG_VERSION_NBR;
    nSTG_ID_PRIMARY P_BASE.tnSTG_ID;
    nSTG_VERSION_NBR_PRIMARY P_BASE.tnSTG_VERSION_NBR;
    nTXT_SEQ_NBR_PRIMARY P_BASE.tnTXT_SEQ_NBR;
    nSTC_ID P_BASE.tnSTC_ID;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_ASR_OOC',
      to_char(pnASR_YEAR)  || '~' || to_char(pnLOC_ID_ASYLUM_COUNTRY) || '~' ||
        to_char(pnLOC_ID_ORIGIN_COUNTRY) || '~' || psSOURCE || '~' || psBASIS || '~' ||
        to_char(pnOOCPOP_START_VALUE) || '~' || to_char(pnOOCPOP_AH_START_VALUE) || '~' ||
        to_char(pnOOCARR_VALUE) || '~' || to_char(pnOOCOTHINC_VALUE) || '~' ||
        to_char(pnOOCRTN_VALUE) || '~' || to_char(pnOOCOTHDEC_VALUE) || '~' ||
        to_char(pnOOCPOP_END_VALUE) || '~' || to_char(pnOOCPOP_AH_END_VALUE) || '~' ||
        psLANG_CODE || '~' || to_char(length(psSUBGROUP_NAME)) || ':' || psSUBGROUP_NAME);
  --
  -- Check that UNHCR-assisted values are not greater than total values.
  --
    if pnOOCPOP_AH_START_VALUE > pnOOCPOP_START_VALUE
      or pnOOCPOP_AH_END_VALUE > pnOOCPOP_END_VALUE
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'UNHCR-assisted value may not be greater than total value');
    end if;
  --
  -- Create new statistic group representing this others of concern table row.
  --
    P_STATISTIC_GROUP.INSERT_STATISTIC_GROUP
     (nSTG_ID_PRIMARY, dSTART_DATE_START, dEND_DATE_END, 'OOC',
      pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
      pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
      psLANG_CODE => psLANG_CODE,
      psSUBGROUP_NAME => psSUBGROUP_NAME);
  --
  -- Get identifier and version number of statistic group representing the whole others of concern
  --  table for this year and country, creating a new statistic group for this purpose if necessary.
  --
    GET_TABLE_STATISTIC_GROUP(nSTG_ID_TABLE, nSTG_VERSION_NBR_TABLE, nSTG_ID_PRIMARY);
  --
  -- Create statistic group attributes for the source and basis.
  --
    if psSOURCE is not null
    then P_STATISTIC_GROUP.INSERT_STG_ATTRIBUTE(nSTG_ID_PRIMARY, 'SOURCE', psSOURCE);
    end if;
  --
    if psBASIS is not null
    then P_STATISTIC_GROUP.INSERT_STG_ATTRIBUTE(nSTG_ID_PRIMARY, 'BASIS', psBASIS);
    end if;
  --
  -- Create statistics for each of the others of concern statistic types and link them to the
  --  statistic group for the others of concern table row and the whole others of concern table.
  --
    if pnOOCPOP_START_VALUE is not null
    then
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, pnOOCPOP_START_VALUE,
        dSTART_DATE_START, dEND_DATE_START, 'OOCPOP', gnDST_ID_OOC,
        pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
        pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY);
    --
      P_STATISTIC.INSERT_STATISTIC_IN_GROUP(nSTC_ID, nSTG_ID_TABLE);
    end if;
  --
    if pnOOCPOP_AH_START_VALUE is not null
    then
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, pnOOCPOP_AH_START_VALUE,
        dSTART_DATE_START, dEND_DATE_START, 'OOCPOP-AH', gnDST_ID_OOC,
        pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
        pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY);
    --
      P_STATISTIC.INSERT_STATISTIC_IN_GROUP(nSTC_ID, nSTG_ID_TABLE);
    end if;
  --
    if pnOOCARR_VALUE is not null
    then
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, pnOOCARR_VALUE,
        dSTART_DATE_START, dEND_DATE_END, 'OOCARR', gnDST_ID_OOC,
        pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
        pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY);
    --
      P_STATISTIC.INSERT_STATISTIC_IN_GROUP(nSTC_ID, nSTG_ID_TABLE);
    end if;
  --
    if pnOOCOTHINC_VALUE is not null
    then
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, pnOOCOTHINC_VALUE,
        dSTART_DATE_START, dEND_DATE_END, 'OOCOTHINC', gnDST_ID_OOC,
        pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
        pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY);
    --
      P_STATISTIC.INSERT_STATISTIC_IN_GROUP(nSTC_ID, nSTG_ID_TABLE);
    end if;
  --
    if pnOOCRTN_VALUE is not null
    then
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, pnOOCRTN_VALUE,
        dSTART_DATE_START, dEND_DATE_END, 'OOCRTN', gnDST_ID_OOC,
        pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
        pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY);
    --
      P_STATISTIC.INSERT_STATISTIC_IN_GROUP(nSTC_ID, nSTG_ID_TABLE);
    end if;
  --
    if pnOOCOTHDEC_VALUE is not null
    then
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, pnOOCOTHDEC_VALUE,
        dSTART_DATE_START, dEND_DATE_END, 'OOCOTHDEC', gnDST_ID_OOC,
        pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
        pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY);
    --
      P_STATISTIC.INSERT_STATISTIC_IN_GROUP(nSTC_ID, nSTG_ID_TABLE);
    end if;
  --
    if pnOOCPOP_END_VALUE is not null
    then
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, pnOOCPOP_END_VALUE,
        dSTART_DATE_END, dEND_DATE_END, 'OOCPOP', gnDST_ID_OOC,
        pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
        pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY);
    --
      P_STATISTIC.INSERT_STATISTIC_IN_GROUP(nSTC_ID, nSTG_ID_TABLE);
    end if;
  --
    if pnOOCPOP_AH_END_VALUE is not null
    then
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, pnOOCPOP_AH_END_VALUE,
        dSTART_DATE_END, dEND_DATE_END, 'OOCPOP-AH', gnDST_ID_OOC,
        pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
        pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY);
    --
      P_STATISTIC.INSERT_STATISTIC_IN_GROUP(nSTC_ID, nSTG_ID_TABLE);
    end if;
  --
  -- Update the statistic group for the whole others of concern table to record latest update
  --  details.
  --
    P_STATISTIC_GROUP.UPDATE_STATISTIC_GROUP(nSTG_ID_TABLE, nSTG_VERSION_NBR_TABLE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_ASR_OOC;
--
-- ----------------------------------------
-- UPDATE_ASR_OOC
-- ----------------------------------------
--
  procedure UPDATE_ASR_OOC
   (pnSTG_ID_PRIMARY in P_BASE.tmnSTG_ID,
    pnLOC_ID_ORIGIN_COUNTRY in P_BASE.tnLOC_ID,
    psLANG_CODE in P_BASE.tsLANG_CODE,
    psSUBGROUP_NAME in P_BASE.tsText,
    psSOURCE in P_BASE.tsSTGA_CHAR_VALUE,
    psBASIS in P_BASE.tsSTGA_CHAR_VALUE,
    pnOOCPOP_START_VALUE in P_BASE.tnSTC_VALUE,
    pnOOCPOP_AH_START_VALUE in P_BASE.tnSTC_VALUE,
    pnOOCARR_VALUE in P_BASE.tnSTC_VALUE,
    pnOOCOTHINC_VALUE in P_BASE.tnSTC_VALUE,
    pnOOCRTN_VALUE in P_BASE.tnSTC_VALUE,
    pnOOCOTHDEC_VALUE in P_BASE.tnSTC_VALUE,
    pnOOCPOP_END_VALUE in P_BASE.tnSTC_VALUE,
    pnOOCPOP_AH_END_VALUE in P_BASE.tnSTC_VALUE,
    pnSTG_VERSION_NBR in P_BASE.tmnSTG_VERSION_NBR,
    pnSTGA_VERSION_NBR_SOURCE in P_BASE.tnSTGA_VERSION_NBR,
    pnSTGA_VERSION_NBR_BASIS in P_BASE.tnSTGA_VERSION_NBR,
    pnOOCPOP_START_STC_ID in P_BASE.tnSTC_ID,
    pnOOCPOP_START_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR,
    pnOOCPOP_AH_START_STC_ID in P_BASE.tnSTC_ID,
    pnOOCPOP_AH_START_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR,
    pnOOCARR_STC_ID in P_BASE.tnSTC_ID,
    pnOOCARR_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR,
    pnOOCOTHINC_STC_ID in P_BASE.tnSTC_ID,
    pnOOCOTHINC_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR,
    pnOOCRTN_STC_ID in P_BASE.tnSTC_ID,
    pnOOCRTN_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR,
    pnOOCOTHDEC_STC_ID in P_BASE.tnSTC_ID,
    pnOOCOTHDEC_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR,
    pnOOCPOP_END_STC_ID in P_BASE.tnSTC_ID,
    pnOOCPOP_END_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR,
    pnOOCPOP_AH_END_STC_ID in P_BASE.tnSTC_ID,
    pnOOCPOP_AH_END_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR)
  is
    nSTG_VERSION_NBR P_BASE.tnSTG_VERSION_NBR := pnSTG_VERSION_NBR;
    nSTGA_VERSION_NBR_SOURCE P_BASE.tnSTGA_VERSION_NBR := pnSTGA_VERSION_NBR_SOURCE;
    nSTGA_VERSION_NBR_BASIS P_BASE.tnSTGA_VERSION_NBR := pnSTGA_VERSION_NBR_BASIS;
  --
    dSTART_DATE_START P_BASE.tdDate;
    dEND_DATE_START P_BASE.tdDate;
    dSTART_DATE_END P_BASE.tdDate;
    dEND_DATE_END P_BASE.tdDate;
    nLOC_ID_ASYLUM_COUNTRY P_BASE.tnLOC_ID;
  --
    nSTG_ID_TABLE P_BASE.tnSTG_ID;
    nSTG_VERSION_NBR_TABLE P_BASE.tnSTG_VERSION_NBR;
  --
    nSTC_ID P_BASE.tnSTC_ID;
    nSTC_VERSION_NBR P_BASE.tnSTC_VERSION_NBR;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_ASR_OOC',
      to_char(pnSTG_ID_PRIMARY) || '~' ||
        to_char(pnLOC_ID_ORIGIN_COUNTRY) || '~' || psSOURCE || '~' || psBASIS || '~' ||
        to_char(pnOOCPOP_START_VALUE) || '~' || to_char(pnOOCPOP_AH_START_VALUE) || '~' ||
        to_char(pnOOCARR_VALUE) || '~' || to_char(pnOOCOTHINC_VALUE) || '~' ||
        to_char(pnOOCRTN_VALUE) || '~' || to_char(pnOOCOTHDEC_VALUE) || '~' ||
        to_char(pnOOCPOP_END_VALUE) || '~' || to_char(pnOOCPOP_AH_END_VALUE) || '~' ||
        to_char(pnSTG_VERSION_NBR) || '~' ||
        to_char(pnSTGA_VERSION_NBR_SOURCE) || '~' || to_char(pnSTGA_VERSION_NBR_BASIS) || '~' ||
        to_char(pnOOCPOP_START_STC_ID) || '~' || to_char(pnOOCPOP_START_VERSION_NBR) || '~' ||
        to_char(pnOOCPOP_AH_START_STC_ID) || '~' || to_char(pnOOCPOP_AH_START_VERSION_NBR) || '~' ||
        to_char(pnOOCARR_STC_ID) || '~' || to_char(pnOOCARR_VERSION_NBR) || '~' ||
        to_char(pnOOCOTHINC_STC_ID) || '~' || to_char(pnOOCOTHINC_VERSION_NBR) || '~' ||
        to_char(pnOOCRTN_STC_ID) || '~' || to_char(pnOOCRTN_VERSION_NBR) || '~' ||
        to_char(pnOOCOTHDEC_STC_ID) || '~' || to_char(pnOOCOTHDEC_VERSION_NBR) || '~' ||
        to_char(pnOOCPOP_END_STC_ID) || '~' || to_char(pnOOCPOP_END_VERSION_NBR) || '~' ||
        to_char(pnOOCPOP_AH_END_STC_ID) || '~' || to_char(pnOOCPOP_AH_END_VERSION_NBR) || '~' ||
        psLANG_CODE || '~' || to_char(length(psSUBGROUP_NAME)) || ':' || psSUBGROUP_NAME);
  --
  -- Check that UNHCR-assisted values are not greater than total values.
  --
    if pnOOCPOP_AH_START_VALUE > pnOOCPOP_START_VALUE
      or pnOOCPOP_AH_END_VALUE > pnOOCPOP_END_VALUE
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'UNHCR-assisted value may not be greater than total value');
    end if;
  --
  -- Get primary statistics group details for this others of concern table row.
  --
    select START_DATE, START_DATE + 1, END_DATE - 1, END_DATE, LOC_ID_ASYLUM_COUNTRY
    into dSTART_DATE_START, dEND_DATE_START, dSTART_DATE_END, dEND_DATE_END, nLOC_ID_ASYLUM_COUNTRY
    from T_STATISTIC_GROUPS
    where ID = pnSTG_ID_PRIMARY;
  --
  -- Get identifier and version number of statistic group representing the whole others of concern
  --  table for this year and country.
  --
    GET_TABLE_STATISTIC_GROUP(nSTG_ID_TABLE, nSTG_VERSION_NBR_TABLE, pnSTG_ID_PRIMARY);
  --
  -- Insert, update or delete statistic group attributes for the source and basis.
  --
    SET_STG_ATTRIBUTE(pnSTG_ID_PRIMARY, 'SOURCE', nSTGA_VERSION_NBR_SOURCE, psSOURCE);
    SET_STG_ATTRIBUTE(pnSTG_ID_PRIMARY, 'BASIS', nSTGA_VERSION_NBR_BASIS, psBASIS);
  --
  -- Insert, update or delete statistics for each of the others of concern statistic types.
  -- 
    nSTC_ID := pnOOCPOP_START_STC_ID;
    nSTC_VERSION_NBR := pnOOCPOP_START_VERSION_NBR;
    SET_STATISTIC
     (nSTC_ID, nSTC_VERSION_NBR, pnOOCPOP_START_VALUE,
      dSTART_DATE_START, dEND_DATE_START, 'OOCPOP', gnDST_ID_OOC,
      pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
      pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
      pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
      pnSTG_ID_TABLE => nSTG_ID_TABLE);
  -- 
    nSTC_ID := pnOOCPOP_AH_START_STC_ID;
    nSTC_VERSION_NBR := pnOOCPOP_AH_START_VERSION_NBR;
    SET_STATISTIC
     (nSTC_ID, nSTC_VERSION_NBR, pnOOCPOP_AH_START_VALUE,
      dSTART_DATE_START, dEND_DATE_START, 'OOCPOP-AH', gnDST_ID_OOC,
      pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
      pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
      pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
      pnSTG_ID_TABLE => nSTG_ID_TABLE);
  -- 
    nSTC_ID := pnOOCARR_STC_ID;
    nSTC_VERSION_NBR := pnOOCARR_VERSION_NBR;
    SET_STATISTIC
     (nSTC_ID, nSTC_VERSION_NBR, pnOOCARR_VALUE,
      dSTART_DATE_START, dEND_DATE_END, 'OOCARR', gnDST_ID_OOC,
      pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
      pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
      pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
      pnSTG_ID_TABLE => nSTG_ID_TABLE);
  -- 
    nSTC_ID := pnOOCOTHINC_STC_ID;
    nSTC_VERSION_NBR := pnOOCOTHINC_VERSION_NBR;
    SET_STATISTIC
     (nSTC_ID, nSTC_VERSION_NBR, pnOOCOTHINC_VALUE,
      dSTART_DATE_START, dEND_DATE_END, 'OOCARR', gnDST_ID_OOC,
      pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
      pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
      pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
      pnSTG_ID_TABLE => nSTG_ID_TABLE);
  -- 
    nSTC_ID := pnOOCRTN_STC_ID;
    nSTC_VERSION_NBR := pnOOCRTN_VERSION_NBR;
    SET_STATISTIC
     (nSTC_ID, nSTC_VERSION_NBR, pnOOCRTN_VALUE,
      dSTART_DATE_START, dEND_DATE_END, 'OOCARR', gnDST_ID_OOC,
      pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
      pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
      pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
      pnSTG_ID_TABLE => nSTG_ID_TABLE);
  -- 
    nSTC_ID := pnOOCOTHDEC_STC_ID;
    nSTC_VERSION_NBR := pnOOCOTHDEC_VERSION_NBR;
    SET_STATISTIC
     (nSTC_ID, nSTC_VERSION_NBR, pnOOCOTHDEC_VALUE,
      dSTART_DATE_START, dEND_DATE_END, 'OOCARR', gnDST_ID_OOC,
      pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
      pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
      pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
      pnSTG_ID_TABLE => nSTG_ID_TABLE);
  -- 
    nSTC_ID := pnOOCPOP_END_STC_ID;
    nSTC_VERSION_NBR := pnOOCPOP_END_VERSION_NBR;
    SET_STATISTIC
     (nSTC_ID, nSTC_VERSION_NBR, pnOOCPOP_END_VALUE,
      dSTART_DATE_END, dEND_DATE_END, 'OOCPOP', gnDST_ID_OOC,
      pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
      pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
      pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
      pnSTG_ID_TABLE => nSTG_ID_TABLE);
  -- 
    nSTC_ID := pnOOCPOP_AH_END_STC_ID;
    nSTC_VERSION_NBR := pnOOCPOP_AH_END_VERSION_NBR;
    SET_STATISTIC
     (nSTC_ID, nSTC_VERSION_NBR, pnOOCPOP_AH_END_VALUE,
      dSTART_DATE_END, dEND_DATE_END, 'OOCPOP-AH', gnDST_ID_OOC,
      pnLOC_ID_ASYLUM_COUNTRY => nLOC_ID_ASYLUM_COUNTRY,
      pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
      pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
      pnSTG_ID_TABLE => nSTG_ID_TABLE);
  --
  -- Update primary statistic group and statistic group representing the whole others of concern
  --  table to record latest update time and user.
  --
    P_STATISTIC_GROUP.UPDATE_STATISTIC_GROUP
     (pnSTG_ID_PRIMARY, nSTG_VERSION_NBR,
      pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
      psLANG_CODE => psLANG_CODE,
      psSUBGROUP_NAME => psSUBGROUP_NAME);
  --
  -- Update the statistic group for the whole others of concern table to record latest update
  --  details.
  --
    P_STATISTIC_GROUP.UPDATE_STATISTIC_GROUP(nSTG_ID_TABLE, nSTG_VERSION_NBR_TABLE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end UPDATE_ASR_OOC;
--
-- ----------------------------------------
-- DELETE_ASR_OOC
-- ----------------------------------------
--
  procedure DELETE_ASR_OOC
   (pnSTG_ID_PRIMARY in P_BASE.tmnSTG_ID,
    pnSTG_VERSION_NBR in P_BASE.tmnSTG_VERSION_NBR,
    pnSTGA_VERSION_NBR_SOURCE in P_BASE.tnSTGA_VERSION_NBR,
    pnSTGA_VERSION_NBR_BASIS in P_BASE.tnSTGA_VERSION_NBR,
    pnOOCPOP_START_STC_ID in P_BASE.tnSTC_ID,
    pnOOCPOP_START_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR,
    pnOOCPOP_AH_START_STC_ID in P_BASE.tnSTC_ID,
    pnOOCPOP_AH_START_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR,
    pnOOCARR_STC_ID in P_BASE.tnSTC_ID,
    pnOOCARR_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR,
    pnOOCOTHINC_STC_ID in P_BASE.tnSTC_ID,
    pnOOCOTHINC_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR,
    pnOOCRTN_STC_ID in P_BASE.tnSTC_ID,
    pnOOCRTN_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR,
    pnOOCOTHDEC_STC_ID in P_BASE.tnSTC_ID,
    pnOOCOTHDEC_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR,
    pnOOCPOP_END_STC_ID in P_BASE.tnSTC_ID,
    pnOOCPOP_END_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR,
    pnOOCPOP_AH_END_STC_ID in P_BASE.tnSTC_ID,
    pnOOCPOP_AH_END_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR)
  is
    nSTG_VERSION_NBR P_BASE.tnSTG_VERSION_NBR := pnSTG_VERSION_NBR;
    nSTGA_VERSION_NBR_SOURCE P_BASE.tnSTGA_VERSION_NBR := pnSTGA_VERSION_NBR_SOURCE;
    nSTGA_VERSION_NBR_BASIS P_BASE.tnSTGA_VERSION_NBR := pnSTGA_VERSION_NBR_BASIS;
  --
    nSTG_ID_TABLE P_BASE.tnSTG_ID;
    nSTG_VERSION_NBR_TABLE P_BASE.tnSTG_VERSION_NBR;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_ASR_OOC',
      to_char(pnSTG_ID_PRIMARY) || '~' || to_char(pnSTG_VERSION_NBR) || '~' ||
        to_char(pnSTGA_VERSION_NBR_SOURCE) || '~' || to_char(pnSTGA_VERSION_NBR_BASIS) || '~' ||
        to_char(pnOOCPOP_START_STC_ID) || '~' || to_char(pnOOCPOP_START_VERSION_NBR) || '~' ||
        to_char(pnOOCPOP_AH_START_STC_ID) || '~' || to_char(pnOOCPOP_AH_START_VERSION_NBR) || '~' ||
        to_char(pnOOCARR_STC_ID) || '~' || to_char(pnOOCARR_VERSION_NBR) || '~' ||
        to_char(pnOOCOTHINC_STC_ID) || '~' || to_char(pnOOCOTHINC_VERSION_NBR) || '~' ||
        to_char(pnOOCRTN_STC_ID) || '~' || to_char(pnOOCRTN_VERSION_NBR) || '~' ||
        to_char(pnOOCOTHDEC_STC_ID) || '~' || to_char(pnOOCOTHDEC_VERSION_NBR) || '~' ||
        to_char(pnOOCPOP_END_STC_ID) || '~' || to_char(pnOOCPOP_END_VERSION_NBR) || '~' ||
        to_char(pnOOCPOP_AH_END_STC_ID) || '~' || to_char(pnOOCPOP_AH_END_VERSION_NBR));
  --
  -- Get identifier and version number of statistic group representing the whole others of concern
  --  table for this year and country.
  --
    GET_TABLE_STATISTIC_GROUP(nSTG_ID_TABLE, nSTG_VERSION_NBR_TABLE, pnSTG_ID_PRIMARY);
  --
  -- Delete the statistics for each of the others of concern statistic types.
  --
    if pnOOCPOP_START_STC_ID is not null
    then P_STATISTIC.DELETE_STATISTIC(pnOOCPOP_START_STC_ID, pnOOCPOP_START_VERSION_NBR);
    end if;
  --
    if pnOOCPOP_AH_START_STC_ID is not null
    then P_STATISTIC.DELETE_STATISTIC(pnOOCPOP_AH_START_STC_ID, pnOOCPOP_AH_START_VERSION_NBR);
    end if;
  --
    if pnOOCARR_STC_ID is not null
    then P_STATISTIC.DELETE_STATISTIC(pnOOCARR_STC_ID, pnOOCARR_VERSION_NBR);
    end if;
  --
    if pnOOCOTHINC_STC_ID is not null
    then P_STATISTIC.DELETE_STATISTIC(pnOOCOTHINC_STC_ID, pnOOCOTHINC_VERSION_NBR);
    end if;
  --
    if pnOOCRTN_STC_ID is not null
    then P_STATISTIC.DELETE_STATISTIC(pnOOCRTN_STC_ID, pnOOCRTN_VERSION_NBR);
    end if;
  --
    if pnOOCOTHDEC_STC_ID is not null
    then P_STATISTIC.DELETE_STATISTIC(pnOOCOTHDEC_STC_ID, pnOOCOTHDEC_VERSION_NBR);
    end if;
  --
    if pnOOCPOP_END_STC_ID is not null
    then P_STATISTIC.DELETE_STATISTIC(pnOOCPOP_END_STC_ID, pnOOCPOP_END_VERSION_NBR);
    end if;
  --
    if pnOOCPOP_AH_END_STC_ID is not null
    then P_STATISTIC.DELETE_STATISTIC(pnOOCPOP_AH_END_STC_ID, pnOOCPOP_AH_END_VERSION_NBR);
    end if;
  --
  -- Delete the source and basis statistic group attributes and the primary statistic group.
  --
    if nSTGA_VERSION_NBR_SOURCE is not null
    then
      P_STATISTIC_GROUP.DELETE_STG_ATTRIBUTE(pnSTG_ID_PRIMARY, 'SOURCE', nSTGA_VERSION_NBR_SOURCE);
    end if;
  --
    if nSTGA_VERSION_NBR_BASIS is not null
    then
      P_STATISTIC_GROUP.DELETE_STG_ATTRIBUTE(pnSTG_ID_PRIMARY, 'BASIS', nSTGA_VERSION_NBR_BASIS);
    end if;
  --
    P_STATISTIC_GROUP.DELETE_STATISTIC_GROUP(pnSTG_ID_PRIMARY, nSTG_VERSION_NBR);
  --
  -- Update the statistic group for the whole others of concern table to record latest update time
  --  and user.
  --
    P_STATISTIC_GROUP.UPDATE_STATISTIC_GROUP(nSTG_ID_TABLE, nSTG_VERSION_NBR_TABLE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_ASR_OOC;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sComponent != 'ASR'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'Component code mismatch');
  end if;
--
  if sVersion != 'D1.0'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
  select ID
  into gnDST_ID_STATELESS
  from T_DISPLACEMENT_STATUSES
  where CODE = 'STA'
  and START_DATE <= sysdate
  and END_DATE > sysdate
  and ACTIVE_FLAG = 'Y';
--
  select ID
  into gnDST_ID_OOC
  from T_DISPLACEMENT_STATUSES
  where CODE = 'OOC'
  and START_DATE <= sysdate
  and END_DATE > sysdate
  and ACTIVE_FLAG = 'Y';
--
  select LOC_ID
  into gnLOC_ID_STATELESS
  from T_LOCATION_ATTRIBUTES
  where LOCAT_CODE = 'ISO3166A3'
  and CHAR_VALUE = 'XXA';
--
end P_ASR;
/

show errors
