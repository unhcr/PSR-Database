set serveroutput on

declare
  nPPG_ID P_BASE.tnPPG_ID;
  nLOC_ID P_BASE.tnLOC_ID;
  iCount pls_integer := 0;
begin
  for rPPG in
   (select PPG.PPG_CODE, PPG.START_DATE, PPG.END_DATE, PPG.DESCRIPTION, PPG.OPERATION,
      LOC1.ID as LOC_ID_ROF,
      count(*) over (partition by PPG.PPG_CODE, PPG.START_DATE, LOC1.ID) as LOC_COUNT_ROF,
      LOC2.ID as LOC_ID_COP,
      count(*) over (partition by PPG.PPG_CODE, PPG.START_DATE, LOC2.ID) as LOC_COUNT_COP
    from S_PPGS PPG
    left outer join T_LOCATION_ATTRIBUTES LOCA1
      on LOCA1.CHAR_VALUE = PPG.OPERATION
      and LOCA1.LOCAT_CODE = 'HCRCD'
    left outer join T_LOCATIONS LOC1
      on LOC1.ID = LOCA1.LOC_ID
      and LOC1.LOCT_CODE = 'HCR-ROF'
      and LOC1.START_DATE <= nvl(PPG.END_DATE, P_BASE.MAX_DATE)
      and LOC1.END_DATE >= nvl(PPG.START_DATE, P_BASE.MIN_DATE)
    left outer join T_LOCATIONS LOC2
      on LOC2.ID = LOCA1.LOC_ID
      and LOC2.LOCT_CODE = 'HCR-COP'
      and LOC2.START_DATE <= nvl(PPG.END_DATE, P_BASE.MAX_DATE)
      and LOC2.END_DATE >= nvl(PPG.START_DATE, P_BASE.MIN_DATE)
    order by PPG.PPG_CODE)
  loop
    iCount := iCount + 1;
  --
    if rPPG.LOC_ID_ROF is not null
    then
      P_POPULATION_PLANNING_GROUP.INSERT_PPG
       (nPPG_ID, 'en', rPPG.DESCRIPTION, rPPG.LOC_ID_ROF, rPPG.PPG_CODE,
        rPPG.START_DATE, rPPG.END_DATE);
    elsif rPPG.LOC_ID_COP is not null
    then
      P_POPULATION_PLANNING_GROUP.INSERT_PPG
       (nPPG_ID, 'en', rPPG.DESCRIPTION, rPPG.LOC_ID_COP, rPPG.PPG_CODE,
        rPPG.START_DATE, rPPG.END_DATE);
    else dbms_output.put_line('No country for operation code: ' || rPPG.OPERATION);
    end if;
  end loop;
--
  dbms_output.put_line(to_char(iCount) || ' POPULATION_PLANNING_GROUPS records inserted');
end;
/
