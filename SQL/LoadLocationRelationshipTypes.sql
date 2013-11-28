set serveroutput on

declare
  nVERSION_NBR P_BASE.tnLOCRT_VERSION_NBR;
  nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  nCount pls_integer := 0;
begin
  for rLOCRT in
   (select CODE, DESCRIPTION_EN, DISPLAY_SEQ, DESCRIPTION_FR, NOTES
    from STAGE.S_LOCATION_RELATIONSHIP_TYPES)
  loop
    nCount := nCount + 1;
  --
    P_LOCATION.INSERT_LOC_RELATIONSHIP_TYPE(rLOCRT.CODE, 'en', rLOCRT.DESCRIPTION_EN, rLOCRT.DISPLAY_SEQ);
    nVERSION_NBR := 1;
  --
    if rLOCRT.DESCRIPTION_FR is not null
    then
      P_LOCATION.SET_LOCRT_DESCRIPTION(rLOCRT.CODE, nVERSION_NBR, 'fr', rLOCRT.DESCRIPTION_FR);
    end if;
  --
    if rLOCRT.NOTES is not null
    then
      nSEQ_NBR := null;
      P_LOCATION.SET_LOCRT_TEXT(rLOCRT.CODE, nVERSION_NBR, 'NOTE', nSEQ_NBR, 'en', rLOCRT.NOTES);
    end if;
  end loop;
--
  dbms_output.put_line(to_char(nCount) || ' LOCATION_RELATIONSHIP_TYPES records inserted');
end;
/
