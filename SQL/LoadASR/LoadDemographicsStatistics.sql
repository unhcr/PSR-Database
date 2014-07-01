set serveroutput on size 1000000

declare
  nSTG_ID P_BASE.tnSTG_ID;
  nSTC_ID P_BASE.tnSTC_ID;
--
  iCount1 pls_integer := 0;
  iCount2 pls_integer := 0;
begin
  P_UTILITY.START_MODULE('LoadDemographicsStatistics');
--
  for rSTC in
   (select STC.STATSYEAR, STC.START_DATE_YEAR, STC.END_DATE_YEAR, STC.START_DATE, STC.END_DATE,
      STC.DST_CODE, DST.ID as DST_ID,
      STC.COU_CODE_ASYLUM, COU.ID as LOC_ID_ASYLUM_COUNTRY,
      STC.LOCATION_NAME_EN, STC.LOC_TYPE_DESCRIPTION_EN,
      LOC1.ID as LOC_ID_ASYLUM1,
      count(distinct LOC2.ID) as LOC_COUNT, max(LOC2.ID) as LOC_ID_ASYLUM2,
      STC.COU_CODE_ORIGIN,
      case
        when STC.COU_CODE_ORIGIN = 'VAR' then null
        else nvl(OGN.ID, -1)
      end as LOC_ID_ORIGIN_COUNTRY,
      STC.URBAN_RURAL_STATUS, DIM1.ID as DIM_ID1,
      STC.ACMT_CODE, DIM2.ID as DIM_ID2,
      STC.BASIS, DIM3.ID as DIM_ID3,
      STC.PPG_NAME, PPG.ID as PPG_ID,
      case when STC.PPG_COUNT > 1 then STC.PPG_NAME end as SUBGROUP_NAME,
      STC.STCT_CODE,
      STC.SEX_CODE,
      STC.AGE_FROM, AGR.ID as AGR_ID,
      STC.VALUE,
      row_number() over
       (partition by STC.STATSYEAR, DST.ID, COU.ID, LOC1.ID, OGN.ID, DIM1.ID, DIM2.ID, DIM3.ID,
          case when STC.PPG_COUNT > 1 then STC.PPG_NAME end
        order by STC.STCT_CODE, STC.SEX_CODE, AGR.ID) as STG_CHILD_NUMBER
    from
     (select STATSYEAR,
        to_date(STATSYEAR || '0101', 'YYYYMMDD') as START_DATE_YEAR,
        add_months(to_date(STATSYEAR || '0101', 'YYYYMMDD'), 12) as END_DATE_YEAR,
        to_date(STATSYEAR || '1231', 'YYYYMMDD') as START_DATE,
        add_months(to_date(STATSYEAR || '0101', 'YYYYMMDD'), 12) as END_DATE,
        DST_CODE, COU_CODE_ASYLUM, LOCATION_NAME_EN, LOC_TYPE_DESCRIPTION_EN, COU_CODE_ORIGIN,
        URBAN_RURAL_STATUS, ACMT_CODE, PPG_NAME,
        count(distinct nvl(PPG_NAME, 'zzz')) over
         (partition by STATSYEAR, DST_CODE, COU_CODE_ASYLUM, LOCATION_NAME_EN,
            LOC_TYPE_DESCRIPTION_EN, COU_CODE_ORIGIN, URBAN_RURAL_STATUS, ACMT_CODE) as PPG_COUNT,
        BASIS,
        case
          when BASIS in ('C', 'R') then 'Y'
          when BASIS in ('E', 'S', 'V') then 'N'
        end as REGISTERED_INDICATOR,
        case nvl(length(DATA_POINT), 0)
          when 0 then 'POCPOPN'
          when 1 then 'POCPOPS'
          else 'POCPOPAS'
        end as STCT_CODE,
        substr(DATA_POINT, 1, 1) as SEX_CODE,
        to_number(substr(DATA_POINT, 2)) as AGE_FROM,
        VALUE
      from S_ASR_DEMOGRAPHICS  where STATSYEAR = &year) STC
    -- Displacement status
    left outer join T_DISPLACEMENT_STATUSES DST
      on DST.CODE = STC.DST_CODE
      and DST.START_DATE < STC.END_DATE_YEAR
      and DST.END_DATE >= STC.END_DATE_YEAR
    -- Country of asylum
    left outer join
     (select LOCA.CHAR_VALUE as UNHCR_COUNTRY_CODE, LOC.START_DATE, LOC.END_DATE, LOC.ID
      from T_LOCATION_ATTRIBUTES LOCA
      inner join T_LOCATIONS LOC
        on LOC.ID = LOCA.LOC_ID
        and LOC.LOCT_CODE = 'COUNTRY'
      where LOCA.LOCAT_CODE = 'HCRCC') COU
      on COU.UNHCR_COUNTRY_CODE = STC.COU_CODE_ASYLUM
      and COU.START_DATE < STC.END_DATE_YEAR
      and COU.END_DATE >= STC.END_DATE_YEAR
    -- Asylum location (matching on name and type)
    left outer join
     (select LOCR.LOC_ID_FROM, LOCR.LOCRT_CODE, LOCR.START_DATE, LOCR.END_DATE, LOC.ID,
        LOC.NAME_EN, nvl(LOCTV.DESCRIPTION_EN, LOCT.DESCRIPTION_EN) as LOC_TYPE_DESCRIPTION_EN
      from T_LOCATION_RELATIONSHIPS LOCR
      inner join
       (select LOC.ID, LOC.LOCT_CODE, LOC.LOCTV_ID, LOC.START_DATE, LOC.END_DATE,
          TXT.TEXT as NAME_EN
        from T_LOCATIONS LOC
        inner join T_TEXT_ITEMS TXT
          on TXT.ITM_ID = LOC.ITM_ID
          and TXT.TXTT_CODE = 'NAME'
          and TXT.SEQ_NBR = 1
          and TXT.LANG_CODE = 'en') LOC
        on LOC.ID = LOCR.LOC_ID_TO
      inner join
       (select LOCT.CODE, TXT.TEXT as DESCRIPTION_EN
        from T_LOCATION_TYPES LOCT
        inner join T_TEXT_ITEMS TXT
          on TXT.ITM_ID = LOCT.ITM_ID
          and TXT.TXTT_CODE = 'DESCR'
          and TXT.SEQ_NBR = 1
          and TXT.LANG_CODE = 'en') LOCT
        on LOCT.CODE = LOC.LOCT_CODE
      left outer join
       (select LOCTV.ID, TXT.TEXT as DESCRIPTION_EN
        from T_LOCATION_TYPE_VARIANTS LOCTV
        inner join T_TEXT_ITEMS TXT
          on TXT.ITM_ID = LOCTV.ITM_ID
          and TXT.TXTT_CODE = 'DESCR'
          and TXT.SEQ_NBR = 1
          and TXT.LANG_CODE = 'en') LOCTV
        on LOCTV.ID = LOC.LOCTV_ID) LOC1
      on LOC1.LOC_ID_FROM = COU.ID
      and LOC1.LOCRT_CODE = 'WITHIN'
      and LOC1.START_DATE < STC.END_DATE_YEAR
      and LOC1.END_DATE >= STC.END_DATE_YEAR
      and LOC1.NAME_EN = STC.LOCATION_NAME_EN
      and LOC1.LOC_TYPE_DESCRIPTION_EN = nvl(STC.LOC_TYPE_DESCRIPTION_EN, 'Undefined')
    -- Asylum location (matching on name only)
    left outer join
     (select LOCR.LOC_ID_FROM, LOCR.LOCRT_CODE, LOCR.START_DATE, LOCR.END_DATE, LOC.ID, LOC.NAME_EN
      from T_LOCATION_RELATIONSHIPS LOCR
      inner join
       (select LOC.ID, LOC.LOCT_CODE, LOC.LOCTV_ID, LOC.START_DATE, LOC.END_DATE,
          TXT.TEXT as NAME_EN
        from T_LOCATIONS LOC
        inner join T_TEXT_ITEMS TXT
          on TXT.ITM_ID = LOC.ITM_ID
          and TXT.TXTT_CODE = 'NAME'
          and TXT.SEQ_NBR = 1
          and TXT.LANG_CODE = 'en') LOC
        on LOC.ID = LOCR.LOC_ID_TO) LOC2
      on LOC2.LOC_ID_FROM = COU.ID
      and LOC2.LOCRT_CODE = 'WITHIN'
      and LOC2.START_DATE < STC.END_DATE_YEAR
      and LOC2.END_DATE >= STC.END_DATE_YEAR
      and LOC2.NAME_EN = STC.LOCATION_NAME_EN
    -- Origin
    left outer join
     (select LOCA.CHAR_VALUE as UNHCR_COUNTRY_CODE, LOC.START_DATE,
        lead(LOC.START_DATE, 1, P_BASE.MAX_DATE) over
         (partition by LOCA.CHAR_VALUE order by LOC.START_DATE) as END_DATE,
        LOC.ID
      from T_LOCATION_ATTRIBUTES LOCA
      inner join T_LOCATIONS LOC
        on LOC.ID = LOCA.LOC_ID
        and LOC.LOCT_CODE in ('COUNTRY', 'OTHORIGIN')
      where LOCA.LOCAT_CODE = 'HCRCC') OGN
      on OGN.UNHCR_COUNTRY_CODE = STC.COU_CODE_ORIGIN
      and OGN.START_DATE < STC.END_DATE_YEAR
      and OGN.END_DATE >= STC.END_DATE_YEAR
    -- Urban/rural indicator
    left outer join T_DIMENSION_VALUES DIM1
      on DIM1.DIMT_CODE = 'UR'
      and DIM1.CODE = STC.URBAN_RURAL_STATUS
      and DIM1.START_DATE < STC.END_DATE_YEAR
      and DIM1.END_DATE >= STC.END_DATE_YEAR
    -- Accommodation type
    left outer join T_DIMENSION_VALUES DIM2
      on DIM2.DIMT_CODE = 'ACMT'
      and DIM2.CODE = STC.ACMT_CODE
      and DIM2.START_DATE < STC.END_DATE_YEAR
      and DIM2.END_DATE >= STC.END_DATE_YEAR
    -- Registered indicator
    left outer join T_DIMENSION_VALUES DIM3
      on DIM3.DIMT_CODE = 'REG'
      and DIM3.CODE = STC.REGISTERED_INDICATOR
      and DIM3.START_DATE < STC.END_DATE_YEAR
      and DIM3.END_DATE >= STC.END_DATE_YEAR
    -- PPGs
    left outer join S_COUNTRY_PPGS CPG1
      on CPG1.COU_CODE = STC.COU_CODE_ASYLUM
      and CPG1.START_DATE < STC.END_DATE_YEAR
      and CPG1.END_DATE >= STC.END_DATE_YEAR
      and CPG1.DESCRIPTION = upper(STC.PPG_NAME)
      and CPG1.LOCATION_NAME_EN = STC.LOCATION_NAME_EN
    left outer join S_COUNTRY_PPGS CPG2
      on CPG2.COU_CODE = STC.COU_CODE_ASYLUM
      and CPG2.START_DATE < STC.END_DATE_YEAR
      and CPG2.END_DATE >= STC.END_DATE_YEAR
      and CPG2.DESCRIPTION = upper(STC.PPG_NAME)
      and CPG2.LOCATION_NAME_EN is null
    left outer join T_POPULATION_PLANNING_GROUPS PPG
      on PPG.PPG_CODE = nvl(CPG1 .PPG_CODE, CPG2.PPG_CODE)
      and PPG.START_DATE < STC.END_DATE_YEAR
      and PPG.END_DATE >= STC.END_DATE_YEAR
    -- Age ranges
    left outer join T_AGE_RANGES AGR
      on AGR.AGP_CODE = case when STATSYEAR <= '2005' then 'STD1' else 'STD' end
      and AGR.AGE_FROM = STC.AGE_FROM
    group by STC.STATSYEAR, STC.START_DATE_YEAR, STC.END_DATE_YEAR, STC.START_DATE, STC.END_DATE,
      STC.DST_CODE, DST.ID, STC.COU_CODE_ASYLUM, COU.ID,
      STC.LOCATION_NAME_EN, STC.LOC_TYPE_DESCRIPTION_EN, LOC1.ID,
      STC.COU_CODE_ORIGIN, OGN.ID,
      STC.URBAN_RURAL_STATUS, DIM1.ID,
      STC.ACMT_CODE, DIM2.ID,
      STC.BASIS, DIM3.ID,
      STC.PPG_NAME, PPG.ID,
      case when STC.PPG_COUNT > 1 then STC.PPG_NAME end,
      STC.STCT_CODE,
      STC.SEX_CODE,
      STC.AGE_FROM, AGR.ID,
      STC.VALUE
    order by STATSYEAR, DST_CODE, COU_CODE_ASYLUM, LOCATION_NAME_EN, LOC_TYPE_DESCRIPTION_EN,
      COU_CODE_ORIGIN, URBAN_RURAL_STATUS, ACMT_CODE, PPG_NAME, STCT_CODE, STG_CHILD_NUMBER)
  loop
    P_UTILITY.TRACE_CONTEXT
     (rSTC.STATSYEAR || '~' || rSTC.STCT_CODE || '~' || rSTC.DST_CODE || '~' ||
        rSTC.COU_CODE_ASYLUM || '~' || rSTC.COU_CODE_ORIGIN || '~' ||
        rSTC.URBAN_RURAL_STATUS || '~' || rSTC.ACMT_CODE || '~' ||
        rSTC.SEX_CODE || '~' || to_char(rSTC.AGE_FROM) || '~' || rSTC.BASIS || '~' ||
        rSTC.LOCATION_NAME_EN || ':' || rSTC.LOC_TYPE_DESCRIPTION_EN || '~' || rSTC.PPG_NAME);
  --
    if rSTC.DST_ID is null
    then
      dbms_output.put_line
       ('Invalid displacement status: ' || rSTC.STATSYEAR || '~' || rSTC.DST_CODE);
    elsif rSTC.LOC_ID_ASYLUM_COUNTRY is null
    then
      dbms_output.put_line
       ('Invalid country of asylum: ' || rSTC.STATSYEAR || '~' || rSTC.COU_CODE_ASYLUM);
    elsif rSTC.LOC_ID_ASYLUM1 is null and rSTC.LOC_COUNT = 0
    then
      dbms_output.put_line
       ('Invalid asylum location: ' || rSTC.STATSYEAR || '~' || rSTC.COU_CODE_ASYLUM || '~' ||
          rSTC.LOCATION_NAME_EN || ' : ' || rSTC.LOC_TYPE_DESCRIPTION_EN);
    elsif rSTC.LOC_ID_ASYLUM1 is null and rSTC.LOC_COUNT > 1
    then
      dbms_output.put_line
       ('Ambiguous asylum location: ' || rSTC.STATSYEAR || '~' || rSTC.COU_CODE_ASYLUM || '~' ||
          rSTC.LOCATION_NAME_EN || ' : ' || rSTC.LOC_TYPE_DESCRIPTION_EN);
    elsif rSTC.LOC_ID_ORIGIN_COUNTRY = -1
    then
      dbms_output.put_line
       ('Invalid origin: ' || rSTC.STATSYEAR || '~' || rSTC.COU_CODE_ORIGIN);
    elsif rSTC.DIM_ID1 is null
    then
      dbms_output.put_line
       ('Invalid urban/rural status: ' || rSTC.STATSYEAR || '~' || rSTC.URBAN_RURAL_STATUS);
    elsif rSTC.AGE_FROM is not null and rSTC.AGR_ID is null
    then
      dbms_output.put_line
       ('Invalid age: ' || rSTC.STATSYEAR || '~' || to_char(rSTC.AGE_FROM));
    elsif rSTC.PPG_NAME is not null and rSTC.PPG_ID is null
    then
      dbms_output.put_line
       ('Invalid PPG name: ' || rSTC.STATSYEAR || '~' || rSTC.COU_CODE_ASYLUM || '~' ||
          rSTC.PPG_NAME);
    else
      if rSTC.STG_CHILD_NUMBER = 1
      then
        P_STATISTIC_GROUP.INSERT_STATISTIC_GROUP
         (nSTG_ID, rSTC.START_DATE_YEAR, rSTC.END_DATE_YEAR,
          psSTTG_CODE => 'DEMOGR',
          pnDST_ID => rSTC.DST_ID,
          pnLOC_ID_ASYLUM_COUNTRY => rSTC.LOC_ID_ASYLUM_COUNTRY,
          pnLOC_ID_ASYLUM => nvl(rSTC.LOC_ID_ASYLUM1, rSTC.LOC_ID_ASYLUM2),
          pnLOC_ID_ORIGIN_COUNTRY => rSTC.LOC_ID_ORIGIN_COUNTRY,
          pnDIM_ID1 => rSTC.DIM_ID1,
          pnDIM_ID2 => rSTC.DIM_ID2,
          pnDIM_ID3 => rSTC.DIM_ID3,
          psLANG_CODE => case when rSTC.SUBGROUP_NAME is not null then 'en' end,
          psSUBGROUP_NAME => rSTC.SUBGROUP_NAME,
          pnPPG_ID => rSTC.PPG_ID);
        iCount1 := iCount1 + 1;
      --
        if rSTC.BASIS is not null
        then P_STATISTIC_GROUP.INSERT_STG_ATTRIBUTE(nSTG_ID, 'BASIS', rSTC.BASIS);
        end if;
      end if;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, rSTC.VALUE, rSTC.START_DATE, rSTC.END_DATE, rSTC.STCT_CODE, rSTC.DST_ID,
        pnLOC_ID_ASYLUM_COUNTRY => rSTC.LOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ASYLUM => nvl(rSTC.LOC_ID_ASYLUM1, rSTC.LOC_ID_ASYLUM2),
        pnLOC_ID_ORIGIN_COUNTRY => rSTC.LOC_ID_ORIGIN_COUNTRY,
        pnDIM_ID1 => rSTC.DIM_ID1,
        pnDIM_ID2 => rSTC.DIM_ID2,
        pnDIM_ID3 => rSTC.DIM_ID3,
        psSEX_CODE => rSTC.SEX_CODE,
        pnAGR_ID => rSTC.AGR_ID,
        pnSTG_ID_PRIMARY => nSTG_ID,
        pnPPG_ID => rSTC.PPG_ID);
      iCount2 := iCount2 + 1;
    end if;
  end loop;
--
  if iCount1 = 1
  then dbms_output.put_line('1 statistic group record inserted');
  else dbms_output.put_line(to_char(iCount1) || ' statistic group records inserted');
  end if;
--
  if iCount2 = 1
  then dbms_output.put_line('1 statistic record inserted');
  else dbms_output.put_line(to_char(iCount2) || ' statistic records inserted');
  end if;
--
  P_UTILITY.END_MODULE;
end;
/
