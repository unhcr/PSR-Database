set serveroutput on

declare
  nROL_ID P_BASE.tnROL_ID;
  nVERSION_NBR P_BASE.tnLOCT_VERSION_NBR;
  nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  nCount pls_integer := 0;
begin
  for rROL in
   (select DESCRIPTION_EN, nvl(COUNTRY_FLAG, 'N') as COUNTRY_FLAG,
      DISPLAY_SEQ, nvl(ACTIVE_FLAG, 'Y') as ACTIVE_FLAG,
      DESCRIPTION_FR, NOTES
    from S_ROLES)
  loop
    nCount := nCount + 1;
  --
    P_ROLE.INSERT_ROLE
     (nROL_ID, 'en', rROL.DESCRIPTION_EN, rROL.COUNTRY_FLAG, rROL.DISPLAY_SEQ, rROL.ACTIVE_FLAG);
    nVERSION_NBR := 1;
  --
    if rROL.DESCRIPTION_FR is not null
    then
      P_ROLE.SET_ROL_DESCRIPTION(nROL_ID, nVERSION_NBR, 'fr', rROL.DESCRIPTION_FR);
    end if;
  --
    if rROL.NOTES is not null
    then
      nSEQ_NBR := null;
      P_ROLE.SET_ROL_TEXT(nROL_ID, nVERSION_NBR, 'NOTE', nSEQ_NBR, 'en', rROL.NOTES);
    end if;
  end loop;
--
  dbms_output.put_line(to_char(nCount) || ' ROLES records inserted');
--
  nCount := 0;
--
  for rRLC in
   (select ROL.ID as ROL_ID, COU.ID as LOC_ID, RLC.NOTES
    from S_ROLE_COUNTRIES RLC
    inner join ROLES ROL
      on ROL.DESCRIPTION = RLC.DESCRIPTION_EN
    inner join COUNTRIES COU
      on COU.ISO3166_ALPHA3_CODE = RLC.ISO_COUNTRY_CODE
      and sysdate between COU.START_DATE and COU.END_DATE)
  loop
    nCount := nCount + 1;
    P_ROLE.INSERT_ROLE_COUNTRY(rRLC.ROL_ID, rRLC.LOC_ID);
  end loop;
--
  dbms_output.put_line(to_char(nCount) || ' ROLE_COUNTRIES records inserted');
end;
/
