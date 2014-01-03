create or replace package body P_ASR is
--
-- ========================================
-- Private global variables
-- ========================================
--
-- Location identifier for "Stateless" origin.
--
  gnLOC_ID_STATELESS P_BASE.tnLOC_ID;
--
-- ========================================
-- Private program units
-- ========================================
--
-- ----------------------------------------
-- SET_STATISTIC
-- ----------------------------------------
--
  procedure SET_STATISTIC
   (pnSTC_ID in out P_BASE.tnSTC_ID,
    pnVERSION_NBR in out P_BASE.tnSTC_VERSION_NBR,
    pnSTG_ID_TABLE in P_BASE.tmnSTG_ID,
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
    pnSTG_ID_PRIMARY in P_BASE.tmnSTG_ID,
    pnPPG_ID in P_BASE.tnPPG_ID := null,
    pnVALUE in P_BASE.tmnSTC_VALUE)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_STATISTIC',
      to_char(pnSTC_ID) || '~' || to_char(pnVERSION_NBR) || '~' || psSTCT_CODE || '~' ||
        to_char(pnSTG_ID_PRIMARY) || '~' || to_char(pnSTG_ID_TABLE) || '~' ||
        to_char(pdSTART_DATE, 'YYYY-MM-DD')  || '~' || to_char(pdEND_DATE, 'YYYY-MM-DD')  || '~' ||
        to_char(pnDST_ID) || '~' ||
        to_char(pnLOC_ID_ASYLUM_COUNTRY) || '~' || to_char(pnLOC_ID_ASYLUM) || '~' ||
        to_char(pnLOC_ID_ORIGIN_COUNTRY) || '~' || to_char(pnLOC_ID_ORIGIN) || '~' ||
        to_char(pnDIM_ID1) || '~' || to_char(pnDIM_ID2) || '~' || to_char(pnDIM_ID3) || '~' ||
        to_char(pnDIM_ID4) || '~' || to_char(pnDIM_ID5) || '~' || psSEX_CODE || '~' ||
        to_char(pnAGR_ID) || '~' || to_char(pnPPG_ID) || '~' || to_char(pnVALUE));
  --
    if pnSTC_ID is null
    then
      if pnVALUE is not null
      then
        P_STATISTIC.INSERT_STATISTIC
         (pnSTC_ID, psSTCT_CODE, pdSTART_DATE, pdEND_DATE, pnDST_ID,
          pnLOC_ID_ASYLUM_COUNTRY, pnLOC_ID_ASYLUM, pnLOC_ID_ORIGIN_COUNTRY, pnLOC_ID_ORIGIN,
          pnDIM_ID1, pnDIM_ID2, pnDIM_ID3, pnDIM_ID4, pnDIM_ID5, psSEX_CODE, pnAGR_ID,
          pnSTG_ID_PRIMARY, pnPPG_ID, pnVALUE);
      --
        P_STATISTIC.INSERT_STATISTIC_IN_GROUP(pnSTC_ID, pnSTG_ID_TABLE);
      end if;
    elsif pnVALUE is not null
    then
      P_STATISTIC.UPDATE_STATISTIC(pnSTC_ID, pnVERSION_NBR, pnVALUE);
    else
      P_STATISTIC.DELETE_STATISTIC(pnSTC_ID, pnVERSION_NBR);
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
-- GET_TABLE_STATISTIC_GROUP (1)
-- ----------------------------------------
--
-- Get the identifier and version number of the statistic group representing all the statistics in
-- a given ASR table for a given year and country. For refugee/refugee-like returns statistics, the
-- country in question is the country of origin (i.e. the country returned to); for other statistic
-- types it is the country of asylum/residence. If the required statistic group does not exist, it
-- is created.
--
-- Parameters:
--  pnSTG_ID - Statistic group identifier (returned).
--  pnVERSION_NBR - Update version number of statistic group record (returned).
--  pnASR_YEAR - Year of ASR statistics (mandatory).
--  psSTTG_CODE - Statistic type group code representing all the statistics in an ASR table
--    (mandatory).
--  pnLOC_ID_ASYLUM_COUNTRY - Location identifier of country of asylum (must be null for returnee
--    statistics, mandatory otherwise).
--  pnLOC_ID_ORIGIN_COUNTRY - Location identifier of country of return (mandatory for returnee
--    statistics only, must be null for other statistic types).
--
  procedure GET_TABLE_STATISTIC_GROUP
   (pnSTG_ID out P_BASE.tnSTG_ID,
    pnVERSION_NBR out P_BASE.tnSTG_VERSION_NBR,
    pnASR_YEAR in P_BASE.tmnYear,
    psSTTG_CODE in P_BASE.tmsSTTG_CODE,
    pnLOC_ID_ASYLUM_COUNTRY in P_BASE.tnLOC_ID := null,
    pnLOC_ID_ORIGIN_COUNTRY in P_BASE.tnLOC_ID := null)
  is
    dSTART_DATE P_BASE.tdDate := to_date(to_char(pnASR_YEAR) || '-01-01', 'YYYY-MM-DD');
    dEND_DATE P_BASE.tdDate := to_date(to_char(pnASR_YEAR + 1) || '-01-01', 'YYYY-MM-DD');
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.GET_TABLE_STATISTIC_GROUP',
      '~~' || to_char(pnASR_YEAR) || '~' || psSTTG_CODE || '~' ||
        to_char(pnLOC_ID_ASYLUM_COUNTRY) || '~' || to_char(pnLOC_ID_ORIGIN_COUNTRY));
  --
    begin
      select ID, VERSION_NBR
      into pnSTG_ID, pnVERSION_NBR
      from T_STATISTIC_GROUPS
      where START_DATE = dSTART_DATE
      and END_DATE = dEND_DATE
      and STTG_CODE = psSTTG_CODE
      and ((LOC_ID_ASYLUM_COUNTRY = pnLOC_ID_ASYLUM_COUNTRY
          and LOC_ID_ORIGIN_COUNTRY is null)
        or (LOC_ID_ORIGIN_COUNTRY = pnLOC_ID_ORIGIN_COUNTRY
          and LOC_ID_ASYLUM_COUNTRY is null))
      and DST_ID is null
      and LOC_ID_ASYLUM is null
      and LOC_ID_ORIGIN is null
      and DIM_ID1 is null
      and DIM_ID2 is null
      and DIM_ID3 is null
      and DIM_ID4 is null
      and DIM_ID5 is null
      and SEX_CODE is null
      and AGR_ID is null
      and SEQ_NBR is null;
    exception
      when NO_DATA_FOUND
      then
        P_STATISTIC_GROUP.INSERT_STATISTIC_GROUP
         (pnSTG_ID, dSTART_DATE, dEND_DATE, psSTTG_CODE,
          pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
          pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY);
      --
        pnVERSION_NBR := 1;
    end;
  --
    P_UTILITY.TRACE_CONTEXT
     (to_char(pnSTG_ID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        to_char(pnASR_YEAR) || '~' || psSTTG_CODE || '~' ||
        to_char(pnLOC_ID_ASYLUM_COUNTRY) || '~' || to_char(pnLOC_ID_ORIGIN_COUNTRY));
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end GET_TABLE_STATISTIC_GROUP;
--
-- ----------------------------------------
-- GET_TABLE_STATISTIC_GROUP (2)
-- ----------------------------------------
--
-- Given the identifer of the statistic group representing a row in an ASR table (the primary
-- statistic group), get the identifier and version number of the statistic group covering all
-- the statistics in that ASR table for the given row's year and country.
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
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.GET_TABLE_STATISTIC_GROUP',
      '~~' || to_char(pnSTG_ID_PRIMARY));
  --
    select STG2.ID, STG2.VERSION_NBR
    into pnSTG_ID, pnVERSION_NBR
    from T_STATISTIC_GROUPS STG1
    inner join T_STATISTIC_GROUPS STG2
      on STG2.START_DATE = trunc(STG1.START_DATE, 'YYYY')
      and STG2.END_DATE = add_months(trunc(STG1.START_DATE, 'YYYY'), 12)
      and STG2.STTG_CODE = STG1.STTG_CODE
      and ((STG2.LOC_ID_ASYLUM_COUNTRY = STG1.LOC_ID_ASYLUM_COUNTRY
          and STG2.LOC_ID_ORIGIN_COUNTRY is null)
        or (STG2.LOC_ID_ORIGIN_COUNTRY = STG1.LOC_ID_ORIGIN_COUNTRY
          and STG2.LOC_ID_ASYLUM_COUNTRY is null))
      and STG2.DST_ID is null
      and STG2.LOC_ID_ASYLUM is null
      and STG2.LOC_ID_ORIGIN is null
      and STG2.DIM_ID1 is null
      and STG2.DIM_ID2 is null
      and STG2.DIM_ID3 is null
      and STG2.DIM_ID4 is null
      and STG2.DIM_ID5 is null
      and STG2.SEX_CODE is null
      and STG2.AGR_ID is null
      and STG2.SEQ_NBR is null
    where STG1.ID = pnSTG_ID_PRIMARY;
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
  -- Get identifier and version number of statistic group representing the whole returnee table for
  --  this year and country, creating a new statistic group for this purpose if necessary.
  --
    GET_TABLE_STATISTIC_GROUP(nSTG_ID_TABLE, nSTG_VERSION_NBR_TABLE, pnASR_YEAR, 'RETURNEE',
                              pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY);
  --
  -- Create new statistic group representing this returnee table row.
  --
    P_STATISTIC_GROUP.INSERT_STATISTIC_GROUP
     (nSTG_ID_PRIMARY, dSTART_DATE, dEND_DATE, 'RETURNEE',
      pnDST_ID => pnDST_ID,
      pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
      pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY);
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
  -- Create statistics for the REFRTN and REFRTN-AH statistic types and link them to the statistic
  --  group for the table.
  --
    if pnREFRTN_VALUE is not null
    then
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, 'REFRTN', dSTART_DATE, dEND_DATE,
        pnDST_ID => pnDST_ID,
        pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
        pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY,
        pnVALUE => pnREFRTN_VALUE);
    --
      P_STATISTIC.INSERT_STATISTIC_IN_GROUP(nSTC_ID, nSTG_ID_TABLE);
    end if;
  --
    if pnREFRTN_AH_VALUE is not null
    then
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, 'REFRTN-AH', dSTART_DATE, dEND_DATE,
        pnDST_ID => pnDST_ID,
        pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
        pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY,
        pnVALUE => pnREFRTN_AH_VALUE);
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
   (pnASR_YEAR in P_BASE.tmnYear,
    pnLOC_ID_ORIGIN_COUNTRY in P_BASE.tmnLOC_ID,
    pnLOC_ID_ASYLUM_COUNTRY in P_BASE.tnLOC_ID,
    pnDST_ID in P_BASE.tmnDST_ID,
    psSOURCE in P_BASE.tsSTGA_CHAR_VALUE,
    psBASIS in P_BASE.tsSTGA_CHAR_VALUE,
    pnREFRTN_VALUE in P_BASE.tnSTC_VALUE,
    pnREFRTN_AH_VALUE in P_BASE.tnSTC_VALUE,
    pnSTG_ID_PRIMARY in P_BASE.tmnSTG_ID,
    pnSTG_VERSION_NBR in P_BASE.tmnSTG_VERSION_NBR,
    pnSTGA_VERSION_NBR_SOURCE in P_BASE.tnSTGA_VERSION_NBR,
    pnSTGA_VERSION_NBR_BASIS in P_BASE.tnSTGA_VERSION_NBR,
    pnREFRTN_STC_ID in P_BASE.tnSTC_ID,
    pnREFRTN_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR,
    pnREFRTN_AH_STC_ID in P_BASE.tnSTC_ID,
    pnREFRTN_AH_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR)
  is
    dSTART_DATE P_BASE.tdDate := to_date(to_char(pnASR_YEAR) || '-01-01', 'YYYY-MM-DD');
    dEND_DATE P_BASE.tdDate := to_date(to_char(pnASR_YEAR + 1) || '-01-01', 'YYYY-MM-DD');
    nSTG_VERSION_NBR P_BASE.tnSTG_VERSION_NBR := pnSTG_VERSION_NBR;
    nSTGA_VERSION_NBR_SOURCE P_BASE.tnSTGA_VERSION_NBR := pnSTGA_VERSION_NBR_SOURCE;
    nSTGA_VERSION_NBR_BASIS P_BASE.tnSTGA_VERSION_NBR := pnSTGA_VERSION_NBR_BASIS;
  --
    nSTG_ID_TABLE P_BASE.tnSTG_ID;
    nSTG_VERSION_NBR_TABLE P_BASE.tnSTG_VERSION_NBR;
  --
    nSTC_ID P_BASE.tnSTC_ID;
    nSTC_VERSION_NBR P_BASE.tnSTC_VERSION_NBR;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_ASR_RETURNEES',
      to_char(pnASR_YEAR) || '~' || to_char(pnLOC_ID_ORIGIN_COUNTRY) || '~' ||
        to_char(pnLOC_ID_ASYLUM_COUNTRY) || '~' || to_char(pnDST_ID) || '~' ||
        psSOURCE || '~' || psBASIS || '~' ||
        to_char(pnREFRTN_VALUE) || '~' || to_char(pnREFRTN_AH_VALUE) || '~' ||
        to_char(pnSTG_ID_PRIMARY) || '~' || to_char(pnSTG_VERSION_NBR) || '~' ||
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
  -- Get identifier and version number of statistic group representing the whole returnee table for
  --  this year and country.
  --
    GET_TABLE_STATISTIC_GROUP(nSTG_ID_TABLE, nSTG_VERSION_NBR_TABLE, pnASR_YEAR, 'RETURNEE',
                              pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY);
  --
  -- Insert, update or delete statistic group attributes for the source and basis.
  --
    SET_STG_ATTRIBUTE(pnSTG_ID_PRIMARY, 'SOURCE', nSTGA_VERSION_NBR_SOURCE, psSOURCE);
    SET_STG_ATTRIBUTE(pnSTG_ID_PRIMARY, 'BASIS', nSTGA_VERSION_NBR_BASIS, psBASIS);
  --
  -- Insert, update or delete statistics for the REFRTN and REFRTN-AH statistic types.
  --
    nSTC_ID := pnREFRTN_STC_ID;
    nSTC_VERSION_NBR := pnREFRTN_VERSION_NBR;
    SET_STATISTIC
     (nSTC_ID, nSTC_VERSION_NBR, nSTG_ID_TABLE,
      'REFRTN', dSTART_DATE, dEND_DATE,
      pnDST_ID => pnDST_ID,
      pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
      pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
      pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY, 
      pnVALUE => pnREFRTN_VALUE);
  -- 
    nSTC_ID := pnREFRTN_AH_STC_ID;
    nSTC_VERSION_NBR := pnREFRTN_AH_VERSION_NBR;
    SET_STATISTIC
     (nSTC_ID, nSTC_VERSION_NBR, nSTG_ID_TABLE,
      'REFRTN-AH', dSTART_DATE, dEND_DATE,
      pnDST_ID => pnDST_ID,
      pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
      pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
      pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY, 
      pnVALUE => pnREFRTN_AH_VALUE);
  --
  -- Update primary statistic group and statistic group representing the whole returnee table to
  --  record latest update time and user.
  --
    P_STATISTIC_GROUP.UPDATE_STATISTIC_GROUP(pnSTG_ID_PRIMARY, nSTG_VERSION_NBR);
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
    nREFRTN_VERSION_NBR P_BASE.tnSTC_VERSION_NBR := pnREFRTN_VERSION_NBR;
    nREFRTN_AH_VERSION_NBR P_BASE.tnSTC_VERSION_NBR := pnREFRTN_AH_VERSION_NBR;
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
  -- Delete the REFRTN and REFRTN-AH statistics.
  --
    if pnREFRTN_STC_ID is not null
    then P_STATISTIC.DELETE_STATISTIC(pnREFRTN_STC_ID, nREFRTN_VERSION_NBR);
    end if;
  --
    if pnREFRTN_AH_STC_ID is not null
    then P_STATISTIC.DELETE_STATISTIC(pnREFRTN_AH_STC_ID, nREFRTN_AH_VERSION_NBR);
    end if;
  --
  -- Delete the source and basis statistic group attributes and the primary statistic group.
  --
    if pnSTG_ID_PRIMARY is not null
    then
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
  -- Get identifier and version number of statistic group representing the whole stateless table for
  --  this year and country, creating a new statistic group for this purpose if necessary.
  --
    GET_TABLE_STATISTIC_GROUP(nSTG_ID_TABLE, nSTG_VERSION_NBR_TABLE, pnASR_YEAR, 'STATELESS',
                              pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY);
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
  --  group for the table.
  --
    if pnSTAPOP_START_VALUE is not null
    then
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, 'STAPOP', dSTART_DATE_START, dEND_DATE_START,
        pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => gnLOC_ID_STATELESS,
        pnDIM_ID1 => pnDIM_ID_SPOPTYPE,
        pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY,
        pnVALUE => pnSTAPOP_START_VALUE);
    --
      P_STATISTIC.INSERT_STATISTIC_IN_GROUP(nSTC_ID, nSTG_ID_TABLE);
    end if;
  --
    if pnSTAPOP_AH_START_VALUE is not null
    then
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, 'STAPOP-AH', dSTART_DATE_START, dEND_DATE_START,
        pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => gnLOC_ID_STATELESS,
        pnDIM_ID1 => pnDIM_ID_SPOPTYPE,
        pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY,
        pnVALUE => pnSTAPOP_AH_START_VALUE);
    --
      P_STATISTIC.INSERT_STATISTIC_IN_GROUP(nSTC_ID, nSTG_ID_TABLE);
    end if;
  --
    if pnNATLOSS_VALUE is not null
    then
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, 'NATLOSS', dSTART_DATE_START, dEND_DATE_END,
        pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => gnLOC_ID_STATELESS,
        pnDIM_ID1 => pnDIM_ID_SPOPTYPE,
        pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY,
        pnVALUE => pnNATLOSS_VALUE);
    --
      P_STATISTIC.INSERT_STATISTIC_IN_GROUP(nSTC_ID, nSTG_ID_TABLE);
    end if;
  --
    if pnSTAOTHINC_VALUE is not null
    then
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, 'STAOTHINC', dSTART_DATE_START, dEND_DATE_END,
        pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => gnLOC_ID_STATELESS,
        pnDIM_ID1 => pnDIM_ID_SPOPTYPE,
        pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY,
        pnVALUE => pnSTAOTHINC_VALUE);
    --
      P_STATISTIC.INSERT_STATISTIC_IN_GROUP(nSTC_ID, nSTG_ID_TABLE);
    end if;
  --
    if pnNATACQ_VALUE is not null
    then
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, 'NATACQ', dSTART_DATE_START, dEND_DATE_END,
        pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => gnLOC_ID_STATELESS,
        pnDIM_ID1 => pnDIM_ID_SPOPTYPE,
        pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY,
        pnVALUE => pnNATACQ_VALUE);
    --
      P_STATISTIC.INSERT_STATISTIC_IN_GROUP(nSTC_ID, nSTG_ID_TABLE);
    end if;
  --
    if pnSTAOTHDEC_VALUE is not null
    then
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, 'STAOTHDEC', dSTART_DATE_START, dEND_DATE_END,
        pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => gnLOC_ID_STATELESS,
        pnDIM_ID1 => pnDIM_ID_SPOPTYPE,
        pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY,
        pnVALUE => pnSTAOTHDEC_VALUE);
    --
      P_STATISTIC.INSERT_STATISTIC_IN_GROUP(nSTC_ID, nSTG_ID_TABLE);
    end if;
  --
    if pnSTAPOP_END_VALUE is not null
    then
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, 'STAPOP', dSTART_DATE_END, dEND_DATE_END,
        pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => gnLOC_ID_STATELESS,
        pnDIM_ID1 => pnDIM_ID_SPOPTYPE,
        pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY,
        pnVALUE => pnSTAPOP_END_VALUE);
    --
      P_STATISTIC.INSERT_STATISTIC_IN_GROUP(nSTC_ID, nSTG_ID_TABLE);
    end if;
  --
    if pnSTAPOP_AH_END_VALUE is not null
    then
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, 'STAPOP-AH', dSTART_DATE_END, dEND_DATE_END,
        pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => gnLOC_ID_STATELESS,
        pnDIM_ID1 => pnDIM_ID_SPOPTYPE,
        pnSTG_ID_PRIMARY => nSTG_ID_PRIMARY,
        pnVALUE => pnSTAPOP_AH_END_VALUE);
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
  end INSERT_ASR_STATELESS;
--
-- ----------------------------------------
-- UPDATE_ASR_STATELESS
-- ----------------------------------------
--
  procedure UPDATE_ASR_STATELESS
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
    pnSTAPOP_AH_END_VALUE in P_BASE.tnSTC_VALUE,
    pnSTG_ID_PRIMARY in P_BASE.tmnSTG_ID,
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
    dSTART_DATE_START P_BASE.tdDate := to_date(to_char(pnASR_YEAR) || '-01-01', 'YYYY-MM-DD');
    dEND_DATE_START P_BASE.tdDate := to_date(to_char(pnASR_YEAR) || '-01-02', 'YYYY-MM-DD');
    dSTART_DATE_END P_BASE.tdDate := to_date(to_char(pnASR_YEAR) || '-12-31', 'YYYY-MM-DD');
    dEND_DATE_END P_BASE.tdDate := to_date(to_char(pnASR_YEAR + 1) || '-01-01', 'YYYY-MM-DD');
    nSTG_VERSION_NBR P_BASE.tnSTG_VERSION_NBR := pnSTG_VERSION_NBR;
    nSTGA_VERSION_NBR_SOURCE P_BASE.tnSTGA_VERSION_NBR := pnSTGA_VERSION_NBR_SOURCE;
    nSTGA_VERSION_NBR_BASIS P_BASE.tnSTGA_VERSION_NBR := pnSTGA_VERSION_NBR_BASIS;
  --
    nSTG_ID_TABLE P_BASE.tnSTG_ID;
    nSTG_VERSION_NBR_TABLE P_BASE.tnSTG_VERSION_NBR;
  --
    nSTC_ID P_BASE.tnSTC_ID;
    nSTC_VERSION_NBR P_BASE.tnSTC_VERSION_NBR;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_ASR_STATELESS',
      to_char(pnASR_YEAR) || '~' || to_char(pnLOC_ID_ASYLUM_COUNTRY) || '~' ||
        to_char(pnDIM_ID_SPOPTYPE) || '~' || psSUBGROUP_NAME || '~' ||
        psSOURCE || '~' || psBASIS || '~' ||
        to_char(pnSTAPOP_START_VALUE) || '~' || to_char(pnSTAPOP_AH_START_VALUE) || '~' ||
        to_char(pnNATLOSS_VALUE) || '~' || to_char(pnSTAOTHINC_VALUE) || '~' ||
        to_char(pnNATACQ_VALUE) || '~' || to_char(pnSTAOTHDEC_VALUE) || '~' ||
        to_char(pnSTAPOP_END_VALUE) || '~' || to_char(pnSTAPOP_AH_END_VALUE) || '~' ||
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
  -- Check that UNHCR-assisted values are not greater than total values.
  --
    if pnSTAPOP_AH_START_VALUE > pnSTAPOP_START_VALUE
      or pnSTAPOP_AH_END_VALUE > pnSTAPOP_END_VALUE
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'UNHCR-assisted value may not be greater than total value');
    end if;
  --
  -- Get identifier and version number of statistic group representing the whole returnee table for
  --  this year and country.
  --
    GET_TABLE_STATISTIC_GROUP(nSTG_ID_TABLE, nSTG_VERSION_NBR_TABLE, pnASR_YEAR, 'STATELESS',
                              pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY);
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
     (nSTC_ID, nSTC_VERSION_NBR, nSTG_ID_TABLE,
      'STAPOP', dSTART_DATE_START, dEND_DATE_START,
      pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
      pnLOC_ID_ORIGIN_COUNTRY => gnLOC_ID_STATELESS,
      pnDIM_ID1 => pnDIM_ID_SPOPTYPE,
      pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
      pnVALUE => pnSTAPOP_START_VALUE);
  -- 
    nSTC_ID := pnSTAPOP_AH_START_STC_ID;
    nSTC_VERSION_NBR := pnSTAPOP_AH_START_VERSION_NBR;
    SET_STATISTIC
     (nSTC_ID, nSTC_VERSION_NBR, nSTG_ID_TABLE,
      'STAPOP-AH', dSTART_DATE_START, dEND_DATE_START,
      pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
      pnLOC_ID_ORIGIN_COUNTRY => gnLOC_ID_STATELESS,
      pnDIM_ID1 => pnDIM_ID_SPOPTYPE,
      pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
      pnVALUE => pnSTAPOP_AH_START_VALUE);
  -- 
    nSTC_ID := pnNATLOSS_STC_ID;
    nSTC_VERSION_NBR := pnNATLOSS_VERSION_NBR;
    SET_STATISTIC
     (nSTC_ID, nSTC_VERSION_NBR, nSTG_ID_TABLE,
      'NATLOSS', dSTART_DATE_START, dEND_DATE_END,
      pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
      pnLOC_ID_ORIGIN_COUNTRY => gnLOC_ID_STATELESS,
      pnDIM_ID1 => pnDIM_ID_SPOPTYPE,
      pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
      pnVALUE => pnNATLOSS_VALUE);
  -- 
    nSTC_ID := pnSTAOTHINC_STC_ID;
    nSTC_VERSION_NBR := pnSTAOTHINC_VERSION_NBR;
    SET_STATISTIC
     (nSTC_ID, nSTC_VERSION_NBR, nSTG_ID_TABLE,
      'NATLOSS', dSTART_DATE_START, dEND_DATE_END,
      pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
      pnLOC_ID_ORIGIN_COUNTRY => gnLOC_ID_STATELESS,
      pnDIM_ID1 => pnDIM_ID_SPOPTYPE,
      pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
      pnVALUE => pnSTAOTHINC_VALUE);
  -- 
    nSTC_ID := pnNATACQ_STC_ID;
    nSTC_VERSION_NBR := pnNATACQ_VERSION_NBR;
    SET_STATISTIC
     (nSTC_ID, nSTC_VERSION_NBR, nSTG_ID_TABLE,
      'NATLOSS', dSTART_DATE_START, dEND_DATE_END,
      pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
      pnLOC_ID_ORIGIN_COUNTRY => gnLOC_ID_STATELESS,
      pnDIM_ID1 => pnDIM_ID_SPOPTYPE,
      pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
      pnVALUE => pnNATACQ_VALUE);
  -- 
    nSTC_ID := pnSTAOTHDEC_STC_ID;
    nSTC_VERSION_NBR := pnSTAOTHDEC_VERSION_NBR;
    SET_STATISTIC
     (nSTC_ID, nSTC_VERSION_NBR, nSTG_ID_TABLE,
      'NATLOSS', dSTART_DATE_START, dEND_DATE_END,
      pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
      pnLOC_ID_ORIGIN_COUNTRY => gnLOC_ID_STATELESS,
      pnDIM_ID1 => pnDIM_ID_SPOPTYPE,
      pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
      pnVALUE => pnSTAOTHDEC_VALUE);
  -- 
    nSTC_ID := pnSTAPOP_END_STC_ID;
    nSTC_VERSION_NBR := pnSTAPOP_END_VERSION_NBR;
    SET_STATISTIC
     (nSTC_ID, nSTC_VERSION_NBR, nSTG_ID_TABLE,
      'STAPOP', dSTART_DATE_END, dEND_DATE_END,
      pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
      pnLOC_ID_ORIGIN_COUNTRY => gnLOC_ID_STATELESS,
      pnDIM_ID1 => pnDIM_ID_SPOPTYPE,
      pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
      pnVALUE => pnSTAPOP_END_VALUE);
  -- 
    nSTC_ID := pnSTAPOP_AH_END_STC_ID;
    nSTC_VERSION_NBR := pnSTAPOP_AH_END_VERSION_NBR;
    SET_STATISTIC
     (nSTC_ID, nSTC_VERSION_NBR, nSTG_ID_TABLE,
      'STAPOP-AH', dSTART_DATE_END, dEND_DATE_END,
      pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
      pnLOC_ID_ORIGIN_COUNTRY => gnLOC_ID_STATELESS,
      pnDIM_ID1 => pnDIM_ID_SPOPTYPE,
      pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
      pnVALUE => pnSTAPOP_AH_END_VALUE);
  --
  -- Update primary statistic group and statistic group representing the whole stateless table to
  --  record latest update time and user.
  --
    P_STATISTIC_GROUP.UPDATE_STATISTIC_GROUP(pnSTG_ID_PRIMARY, nSTG_VERSION_NBR,
                                             psLANG_CODE, psSUBGROUP_NAME);
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
  -- Get identifier and version number of statistic group representing the whole returnee table for
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
  -- Update the statistic group for the whole returnee table to record latest update time and user.
  --
    P_STATISTIC_GROUP.UPDATE_STATISTIC_GROUP(nSTG_ID_TABLE, nSTG_VERSION_NBR_TABLE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_ASR_STATELESS;
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
  select LOC_ID
  into gnLOC_ID_STATELESS
  from T_LOCATION_ATTRIBUTES
  where LOCAT_CODE = 'ISO3166A3'
  and CHAR_VALUE = 'XXA';
--
end P_ASR;
/

show errors
