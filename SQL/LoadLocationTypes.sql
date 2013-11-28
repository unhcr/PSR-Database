set serveroutput on

declare
  nVERSION_NBR P_BASE.tnLOCT_VERSION_NBR;
  nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  nCount pls_integer := 0;
begin
  for rLOCT in
   (select CODE, DESCRIPTION_EN, DISPLAY_SEQ, DESCRIPTION_FR, NOTES
    from STAGE.S_LOCATION_TYPES)
  loop
    nCount := nCount + 1;
  --
    P_LOCATION.INSERT_LOCATION_TYPE(rLOCT.CODE, 'en', rLOCT.DESCRIPTION_EN, rLOCT.DISPLAY_SEQ);
    nVERSION_NBR := 1;
  --
    if rLOCT.DESCRIPTION_FR is not null
    then
      P_LOCATION.SET_LOCT_DESCRIPTION(rLOCT.CODE, nVERSION_NBR, 'fr', rLOCT.DESCRIPTION_FR);
    end if;
  --
    if rLOCT.NOTES is not null
    then
      nSEQ_NBR := null;
      P_LOCATION.SET_LOCT_TEXT(rLOCT.CODE, nVERSION_NBR, 'NOTE', nSEQ_NBR, 'en', rLOCT.NOTES);
    end if;
  end loop;
--
  dbms_output.put_line(to_char(nCount) || ' LOCATION_TYPES records inserted');
end;
/
