set serveroutput on size 1000000

declare
  nSTG_ID P_BASE.tnSTG_ID;
  nSTC_ID P_BASE.tnSTC_ID;
--
  iCount1 pls_integer := 0;
  iCount2 pls_integer := 0;
begin
  P_UTILITY.START_MODULE('LoadRSDStatistics');
--
  for rSTC in
   (select STC.STATSYEAR, STC.START_DATE_YEAR, STC.END_DATE_YEAR, STC.START_DATE, STC.END_DATE,
      STC.DST_CODE, DST.ID as DST_ID,
      STC.COU_CODE_ASYLUM, COU.ID as LOC_ID_ASYLUM_COUNTRY,
      STC.COU_CODE_ORIGIN,
      case
        when STC.COU_CODE_ORIGIN = 'VAR' then null
        else nvl(OGN.ID, -1)
      end as LOC_ID_ORIGIN_COUNTRY,
      STC.RSD_TYPE, DIM1.ID as DIM_ID1,
      STC.RSD_LEVEL, DIM2.ID as DIM_ID2,
      STC.STCT_CODE,
      STC.VALUE,
      row_number() over
       (partition by STC.STATSYEAR, DST.ID, COU.ID, OGN.ID, DIM1.ID, DIM2.ID
        order by STC.START_DATE, STC.STCT_CODE) as STG_CHILD_NUMBER
    from 
     (select STATSYEAR,
        to_date(STATSYEAR || '0101', 'YYYYMMDD') as START_DATE_YEAR,
        add_months(to_date(STATSYEAR || '0101', 'YYYYMMDD'), 12) as END_DATE_YEAR,
        case
          when DATA_POINT in ('ASY_END', 'ASY_AH_END')
          then to_date(STATSYEAR || '1231', 'YYYYMMDD')
          else to_date(STATSYEAR || '0101', 'YYYYMMDD')
        end as START_DATE,
        case
          when DATA_POINT in ('ASY_START', 'ASY_AH_START')
          then to_date(STATSYEAR || '0102', 'YYYYMMDD')
          else add_months(to_date(STATSYEAR || '0101', 'YYYYMMDD'), 12)
        end as END_DATE,
        DST_CODE, COU_CODE_ASYLUM, RSD_TYPE, RSD_LEVEL, COU_CODE_ORIGIN,
        case
          when DATA_POINT in ('ASY_START', 'ASY_END') then 'ASYPOP'
          when DATA_POINT in ('ASY_AH_START', 'ASY_AH_END') then 'ASYPOP-AH'
          else replace(DATA_POINT, '_', '-')
        end as STCT_CODE,
        VALUE
      from S_ASR_RSD  where STATSYEAR = &year) STC
    left outer join T_DISPLACEMENT_STATUSES DST
      on DST.CODE = STC.DST_CODE
      and DST.START_DATE < STC.END_DATE_YEAR
      and DST.END_DATE >= STC.END_DATE_YEAR
    left outer join -- Country of asylum
     (select LOCA.CHAR_VALUE as UNHCR_COUNTRY_CODE, LOC.START_DATE, LOC.END_DATE, LOC.ID
      from T_LOCATION_ATTRIBUTES LOCA
      inner join T_LOCATIONS LOC
        on LOC.ID = LOCA.LOC_ID
        and LOC.LOCT_CODE = 'COUNTRY'
      where LOCA.LOCAT_CODE = 'HCRCC') COU
      on COU.UNHCR_COUNTRY_CODE = STC.COU_CODE_ASYLUM
      and COU.START_DATE < STC.END_DATE_YEAR
      and COU.END_DATE >= STC.END_DATE_YEAR
    left outer join -- Origin
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
    left outer join T_DIMENSION_VALUES DIM1
      on DIM1.DIMT_CODE = 'RSDTYPE'
      and DIM1.CODE = STC.RSD_TYPE
      and DIM1.START_DATE < STC.END_DATE_YEAR
      and DIM1.END_DATE >= STC.END_DATE_YEAR
    left outer join T_DIMENSION_VALUES DIM2
      on DIM2.DIMT_CODE = 'RSDLEVEL'
      and DIM2.CODE = STC.RSD_LEVEL
      and DIM2.START_DATE < STC.END_DATE_YEAR
      and DIM2.END_DATE >= STC.END_DATE_YEAR
    order by STATSYEAR, LOC_ID_ASYLUM_COUNTRY, LOC_ID_ORIGIN_COUNTRY, DST_ID, DIM_ID1, DIM_ID2,
      START_DATE, STCT_CODE)
  loop
    P_UTILITY.TRACE_CONTEXT
     (rSTC.STATSYEAR || '~' || rSTC.STCT_CODE || '~' || to_char(rSTC.START_DATE, 'YYYY-MM-DD') ||
        '~' || rSTC.DST_CODE || '~' || rSTC.COU_CODE_ASYLUM || '~' || rSTC.COU_CODE_ORIGIN || '~' ||
        rSTC.RSD_TYPE || '~' || rSTC.RSD_LEVEL);
  --
    if rSTC.DST_ID is null
    then
      dbms_output.put_line
       ('Invalid displacement status: ' || rSTC.STATSYEAR || '~' || rSTC.DST_CODE);
    elsif rSTC.LOC_ID_ASYLUM_COUNTRY is null
    then
      dbms_output.put_line
       ('Invalid country of asylum: ' || rSTC.STATSYEAR || '~' || rSTC.COU_CODE_ASYLUM);
    elsif rSTC.LOC_ID_ORIGIN_COUNTRY = -1
    then
      dbms_output.put_line
       ('Invalid origin: ' || rSTC.STATSYEAR || '~' || rSTC.COU_CODE_ORIGIN);
    else
      if rSTC.STG_CHILD_NUMBER = 1
      then
        P_STATISTIC_GROUP.INSERT_STATISTIC_GROUP
         (nSTG_ID, rSTC.START_DATE_YEAR, rSTC.END_DATE_YEAR,
          psSTTG_CODE => 'RSD',
          pnDST_ID => rSTC.DST_ID,
          pnLOC_ID_ASYLUM_COUNTRY => rSTC.LOC_ID_ASYLUM_COUNTRY,
          pnLOC_ID_ORIGIN_COUNTRY => rSTC.LOC_ID_ORIGIN_COUNTRY,
          pnDIM_ID1 => rSTC.DIM_ID1,
          pnDIM_ID2 => rSTC.DIM_ID2);
        iCount1 := iCount1 + 1;
      end if;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, rSTC.VALUE, rSTC.START_DATE, rSTC.END_DATE, rSTC.STCT_CODE, rSTC.DST_ID,
        pnLOC_ID_ASYLUM_COUNTRY => rSTC.LOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => rSTC.LOC_ID_ORIGIN_COUNTRY,
        pnDIM_ID1 => rSTC.DIM_ID1,
        pnDIM_ID2 => rSTC.DIM_ID2,
        pnSTG_ID_PRIMARY => nSTG_ID);
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
