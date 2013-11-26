set serveroutput on

/*
The following SQL was used to populate the LOCATION_TYPE_VARIANTS tab in the Locations.xlsx spreadsheet.

select distinct
  'ADMIN1' as LOCT_CODE,
  ASR.COU_CODE as HCRCC,
  'WITHIN' as LOCRT_CODE,
  trim(regexp_replace(nvl(LCOR.CORRECTED_LOCATION_NAME,
                          nvl(ASR.NEW_LOCATION_NAME, ASR.LOCATION_NAME)),
                      '^[^:]*:', '')) as DESCRIPTION_EN
from
 (select COU_CODE_ASYLUM as COU_CODE, LOCATION_NAME, NEW_LOCATION_NAME
  from STAGE.S_ASR_T3
  union
  select COU_CODE_ORIGIN as COU_CODE, LOCATION_NAME, null as NEW_LOCATION_NAME
  from STAGE.S_ASR_T6) ASR
left outer join STAGE.S_LOCATION_NAME_CORRECTIONS LCOR
  on LCOR.LOCATION_NAME = ASR.LOCATION_NAME
  and (LCOR.NEW_LOCATION_NAME = ASR.NEW_LOCATION_NAME
    or (LCOR.NEW_LOCATION_NAME is null
      and ASR.NEW_LOCATION_NAME is null))
where not regexp_like(trim(regexp_replace(nvl(LCOR.CORRECTED_LOCATION_NAME,
                                              nvl(ASR.NEW_LOCATION_NAME, ASR.LOCATION_NAME)) || ':',
                                          '^[^:]*:', '')),
                      '((Point)|(Dispersed +in +.*) +((country)|(territory))|(to +be +defined)).*',
                      'i')
order by HCRCC, DESCRIPTION_EN;

A few occurrences of LOCT_CODE were then updated from 'ADMIN1' to 'ADMIN2' by reference to ISO 3166-2.
*/

declare
  nLOCTV_ID P_BASE.tnLOCTV_ID;
  nVERSION_NBR P_BASE.tnLOCTV_VERSION_NBR;
  nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  iCount pls_integer := 0;
begin
  for rLOCTV in
   (select LOCTV.LOCT_CODE, LOCTV.HCRCC, LOCTV.LOCRT_CODE, LOCTV.DESCRIPTION_EN, LOCTV.DISPLAY_SEQ,
      LOCTV.DESCRIPTION_FR, NOTES, COU.ID as LOC_ID
    from S_LOCATION_TYPE_VARIANTS LOCTV
    join COUNTRIES COU
      on COU.UNHCR_COUNTRY_CODE = LOCTV.HCRCC)
  loop
    iCount := iCount + 1;
  --
    P_LOCATION.INSERT_LOCATION_TYPE_VARIANT
     (nLOCTV_ID, 'en', rLOCTV.DESCRIPTION_EN,
      rLOCTV.LOCT_CODE, rLOCTV.LOC_ID, rLOCTV.LOCRT_CODE, rLOCTV.DISPLAY_SEQ);
    nVERSION_NBR := 1;
  --
    if rLOCTV.DESCRIPTION_FR is not null
    then
      P_LOCATION.SET_LOCTV_DESCRIPTION(nLOCTV_ID, nVERSION_NBR, 'fr', rLOCTV.DESCRIPTION_FR);
    end if;
  --
    if rLOCTV.NOTES is not null
    then
      nSEQ_NBR := null;
      P_LOCATION.SET_LOCT_TEXT(nLOCTV_ID, nVERSION_NBR, 'NOTE', nSEQ_NBR, 'en', rLOCTV.NOTES);
    end if;
  end loop;
--
  dbms_output.put_line(to_char(iCount) || ' LOCATION_TYPE_VARIANTS records inserted');
end;
/
