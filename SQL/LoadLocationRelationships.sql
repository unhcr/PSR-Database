set serveroutput on

declare
  nLOC_ID_FROM P_BASE.tnLOC_ID;
  nLOC_ID_TO P_BASE.tnLOC_ID;
  iCount pls_integer := 0;
begin
  for rLOCR in
   (select LOCT_CODE_FROM, LOC_NAME_FROM_EN, LOC_CODE_FROM,
      nvl(LOC_START_DATE_FROM, P_BASE.MIN_DATE) as LOC_START_DATE_FROM,
      LOCRT_CODE,
      nvl(LOCR_START_DATE, P_BASE.MIN_DATE) as LOCR_START_DATE,
      nvl(LOCR_END_DATE, P_BASE.MAX_DATE) as LOCR_END_DATE,
      LOCT_CODE_TO, LOC_NAME_TO_EN, LOC_CODE_TO,
      nvl(LOC_START_DATE_TO, P_BASE.MIN_DATE) as LOC_START_DATE_TO
    from S_LOCATION_RELATIONSHIPS)
  loop
    P_UTILITY.TRACE_CONTEXT
     (rLOCR.LOCT_CODE_FROM || '~' || rLOCR.LOC_CODE_FROM || '~' ||
        to_char(rLOCR.LOC_START_DATE_FROM, 'YYYY-MM-DD') || '~' ||
        rLOCR.LOCRT_CODE || '~' ||
        to_char(rLOCR.LOCR_START_DATE, 'YYYY-MM-DD') || '~' ||
        to_char(rLOCR.LOCR_END_DATE, 'YYYY-MM-DD') || '~' ||
        rLOCR.LOCT_CODE_TO || '~' || rLOCR.LOC_CODE_TO || '~' ||
        to_char(rLOCR.LOC_START_DATE_TO, 'YYYY-MM-DD'));
    P_UTILITY.TRACE_POINT('Trace');
  --
    if rLOCR.LOCT_CODE_FROM not in ('COUNTRY', 'HCR-ROF', 'HCR-COP')
    then 
      dbms_output.put_line
       ('Unsupported from location type: ' || rLOCR.LOCT_CODE_FROM);
    elsif rLOCR.LOCT_CODE_TO != 'COUNTRY'
    then 
      dbms_output.put_line
       ('Unsupported to location type: ' || rLOCR.LOCT_CODE_TO);
    else
      select LOC.ID
      into nLOC_ID_FROM
      from T_LOCATION_ATTRIBUTES LOCA
      inner join T_LOCATIONS LOC
        on LOC.ID = LOCA.LOC_ID
      where LOCA.LOCAT_CODE =
        case when rLOCR.LOCT_CODE_FROM = 'COUNTRY' then 'ISO3166A3' else 'HCRCD' end
      and LOCA.CHAR_VALUE = rLOCR.LOC_CODE_FROM
      and LOC.LOCT_CODE = rLOCR.LOCT_CODE_FROM
      and LOC.START_DATE = rLOCR.LOC_START_DATE_FROM;
    --
      select LOC.ID
      into nLOC_ID_TO
      from T_LOCATION_ATTRIBUTES LOCA
      inner join T_LOCATIONS LOC
        on LOC.ID = LOCA.LOC_ID
      where LOCA.LOCAT_CODE = 'ISO3166A3'
      and LOCA.CHAR_VALUE = rLOCR.LOC_CODE_TO
      and LOC.LOCT_CODE = 'COUNTRY'
      and LOC.START_DATE = rLOCR.LOC_START_DATE_TO;
    --
      iCount := iCount + 1;
      P_LOCATION.INSERT_LOCATION_RELATIONSHIP
       (nLOC_ID_FROM, nLOC_ID_TO, rLOCR.LOCRT_CODE, rLOCR.LOCR_START_DATE, rLOCR.LOCR_END_DATE);
    end if;
  end loop;
--
  if iCount = 1
  then dbms_output.put_line('1 LOCATION_RELATIONSHIPS record inserted');
  else dbms_output.put_line(to_char(iCount) || ' LOCATION_RELATIONSHIPS records inserted');
  end if;
end;
/
