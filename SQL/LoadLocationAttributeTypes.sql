set serveroutput on

declare
  nVERSION_NBR P_BASE.tnLOCAT_VERSION_NBR;
  nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  nCount pls_integer := 0;
begin
  for rLOCAT in
   (select CODE, DESCRIPTION_EN, DATA_TYPE, DISPLAY_SEQ, DESCRIPTION_FR, NOTES
    from S_LOCATION_ATTRIBUTE_TYPES)
  loop
    nCount := nCount + 1;
  --
    P_LOCATION.INSERT_LOCATION_ATTRIBUTE_TYPE(rLOCAT.CODE, rLOCAT.DATA_TYPE, 'en', rLOCAT.DESCRIPTION_EN, rLOCAT.DISPLAY_SEQ);
    nVERSION_NBR := 1;
  --
    if rLOCAT.DESCRIPTION_FR is not null
    then
      P_LOCATION.SET_LOCAT_DESCRIPTION(rLOCAT.CODE, nVERSION_NBR, 'fr', rLOCAT.DESCRIPTION_FR);
    end if;
  --
    if rLOCAT.NOTES is not null
    then
      nSEQ_NBR := null;
      P_LOCATION.SET_LOCAT_TEXT(rLOCAT.CODE, nVERSION_NBR, 'NOTE', nSEQ_NBR, 'en', rLOCAT.NOTES);
    end if;
  end loop;
--
  dbms_output.put_line(to_char(nCount) || ' LOCATION_ATTRIBUTE_TYPES records inserted');
end;
/
