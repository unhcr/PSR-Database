set serveroutput on

declare
  nPPG_ID P_BASE.tnPPG_ID;
  iCount pls_integer := 0;
begin
  for rPPG in
   (select PPG.PPG_CODE,
      nvl(trunc(PPG.START_DATE), COU.START_DATE) as START_DATE,
      nvl(trunc(PPG.END_DATE), COU.END_DATE) as END_DATE,
      PPG.DESCRIPTION,
      COU.ID as LOC_ID
    from STAGE.S_PPG PPG
    left outer join COUNTRIES COU
      on COU.ISO3166_ALPHA3_CODE = PPG.OPERATION
      and COU.START_DATE <= nvl(PPG.START_DATE, P_BASE.gdMIN_DATE)
      and COU.END_DATE >= nvl(PPG.END_DATE, P_BASE.gdMAX_DATE)
    where PPG.OPERATION not like '% RO'
    union all
    select PPG.PPG_CODE,
      nvl(trunc(PPG.START_DATE), LOC.START_DATE) as START_DATE,
      nvl(trunc(PPG.END_DATE), LOC.END_DATE) as END_DATE,
      PPG.DESCRIPTION,
      LOC.ID as LOC_ID
    from STAGE.S_PPG PPG
    left outer join LOCATION_ATTRIBUTES LOCA
      on LOCA.CHAR_VALUE = PPG.OPERATION
      and LOCA.LOCAT_CODE = 'HCRCD'
    left outer join LOCATIONS LOC
      on LOC.ID = LOCA.LOC_ID
      and LOC.LOCT_CODE = 'HCR-ROF'
    where PPG.OPERATION like '% RO'
    order by PPG_CODE)
  loop
    iCount := iCount + 1;
  --
    P_POPULATION_PLANNING_GROUP.INSERT_PPG(nPPG_ID, 'en', rPPG.DESCRIPTION, rPPG.LOC_ID, rPPG.PPG_CODE, rPPG.START_DATE, rPPG.END_DATE);
  end loop;
--
  dbms_output.put_line(to_char(iCount) || ' POPULATION_PLANNING_GROUPS records inserted');
end;
/
