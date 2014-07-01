set serveroutput on size 1000000

declare
  nSTG_ID P_BASE.tnSTG_ID;
  nSTC_ID P_BASE.tnSTC_ID;
--
  iCount1 pls_integer := 0;
  iCount2 pls_integer := 0;
begin
  P_UTILITY.START_MODULE('LoadReturnsStatistics');
--
  for rSTC in
   (select STC.STATSYEAR, STC.START_DATE, STC.END_DATE,
      STC.DST_CODE, DST.ID as DST_ID,
      STC.COU_CODE_ORIGIN, OGN.ID as LOC_ID_ORIGIN_COUNTRY,
      STC.COU_CODE_ASYLUM,
      case
        when STC.COU_CODE_ASYLUM = 'VAR' then null
        else nvl(COU.ID, -1)
      end as LOC_ID_ASYLUM_COUNTRY,
      STC.SOURCE, STC.BASIS,
      STC.STCT_CODE,
      STC.VALUE,
      row_number() over
       (partition by STC.STATSYEAR, DST.ID, COU.ID, OGN.ID
        order by STC.STCT_CODE) as STG_CHILD_NUMBER
    from 
     (select STATSYEAR,
        to_date(STATSYEAR || '0101', 'YYYYMMDD') as START_DATE,
        add_months(to_date(STATSYEAR || '0101', 'YYYYMMDD'), 12) as END_DATE,
        DST_CODE, COU_CODE_ASYLUM, COU_CODE_ORIGIN, SOURCE, BASIS,
        DATA_POINT as STCT_CODE,
        VALUE
      from S_ASR_RETURNS where STATSYEAR = &year) STC
    left outer join T_DISPLACEMENT_STATUSES DST
      on DST.CODE = STC.DST_CODE
      and DST.START_DATE < STC.END_DATE
      and DST.END_DATE >= STC.END_DATE
    left outer join -- Country of origin
     (select LOCA.CHAR_VALUE as UNHCR_COUNTRY_CODE, LOC.START_DATE, LOC.END_DATE, LOC.ID
      from T_LOCATION_ATTRIBUTES LOCA
      inner join T_LOCATIONS LOC
        on LOC.ID = LOCA.LOC_ID
        and LOC.LOCT_CODE = 'COUNTRY'
      where LOCA.LOCAT_CODE = 'HCRCC') OGN
      on OGN.UNHCR_COUNTRY_CODE = STC.COU_CODE_ORIGIN
      and OGN.START_DATE < STC.END_DATE
      and OGN.END_DATE >= STC.END_DATE
    left outer join -- Country of asylum
     (select LOCA.CHAR_VALUE as UNHCR_COUNTRY_CODE, LOC.START_DATE, LOC.END_DATE, LOC.ID
      from T_LOCATION_ATTRIBUTES LOCA
      inner join T_LOCATIONS LOC
        on LOC.ID = LOCA.LOC_ID
        and LOC.LOCT_CODE = 'COUNTRY'
      where LOCA.LOCAT_CODE = 'HCRCC') COU
      on COU.UNHCR_COUNTRY_CODE = STC.COU_CODE_ASYLUM
      and COU.START_DATE < STC.END_DATE
      and COU.END_DATE >= STC.END_DATE
    order by STATSYEAR, LOC_ID_ASYLUM_COUNTRY, LOC_ID_ORIGIN_COUNTRY, DST_ID, STCT_CODE)
  loop
    P_UTILITY.TRACE_CONTEXT
     (rSTC.STATSYEAR || '~' || rSTC.STCT_CODE || '~' || to_char(rSTC.START_DATE, 'YYYY-MM-DD') ||
        '~' || rSTC.DST_CODE || '~' || rSTC.COU_CODE_ASYLUM || '~' || rSTC.COU_CODE_ORIGIN);
  --
    if rSTC.DST_ID is null
    then
      dbms_output.put_line
       ('Invalid displacement status: ' || rSTC.STATSYEAR || '~' || rSTC.DST_CODE);
    elsif rSTC.LOC_ID_ORIGIN_COUNTRY is null
    then
      dbms_output.put_line
       ('Invalid country of origin: ' || rSTC.STATSYEAR || '~' || rSTC.COU_CODE_ORIGIN);
    elsif rSTC.LOC_ID_ASYLUM_COUNTRY= -1
    then
      dbms_output.put_line
       ('Invalid country of asylum: ' || rSTC.STATSYEAR || '~' || rSTC.COU_CODE_ASYLUM);
    else
      if rSTC.STG_CHILD_NUMBER = 1
      then
        P_STATISTIC_GROUP.INSERT_STATISTIC_GROUP
         (nSTG_ID, rSTC.START_DATE, rSTC.END_DATE,
          psSTTG_CODE => 'RETURNEE',
          pnDST_ID => rSTC.DST_ID,
          pnLOC_ID_ASYLUM_COUNTRY => rSTC.LOC_ID_ASYLUM_COUNTRY,
          pnLOC_ID_ORIGIN_COUNTRY => rSTC.LOC_ID_ORIGIN_COUNTRY);
        iCount1 := iCount1 + 1;
      --
        if rSTC.SOURCE is not null
        then P_STATISTIC_GROUP.INSERT_STG_ATTRIBUTE(nSTG_ID, 'SOURCE', rSTC.SOURCE);
        end if;
      --
        if rSTC.BASIS is not null
        then P_STATISTIC_GROUP.INSERT_STG_ATTRIBUTE(nSTG_ID, 'BASIS', rSTC.BASIS);
        end if;
      end if;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, rSTC.VALUE, rSTC.START_DATE, rSTC.END_DATE, rSTC.STCT_CODE, rSTC.DST_ID,
        pnLOC_ID_ASYLUM_COUNTRY => rSTC.LOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => rSTC.LOC_ID_ORIGIN_COUNTRY,
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
