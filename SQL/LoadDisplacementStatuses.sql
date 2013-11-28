set serveroutput on

declare
  nDST_ID P_BASE.tnDST_ID;
  nVERSION_NBR P_BASE.tnDST_VERSION_NBR;
  nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  iCount pls_integer := 0;
begin
  for rDST in
   (select CODE, DESCRIPTION_EN, START_DATE, END_DATE, DISPLAY_SEQ, DESCRIPTION_FR, NOTES
    from STAGE.S_DISPLACEMENT_STATUSES)
  loop
    iCount := iCount + 1;
  --
    P_DISPLACEMENT_STATUS.INSERT_DISPLACEMENT_STATUS
     (nDST_ID, 'en', rDST.DESCRIPTION_EN, rDST.CODE, rDST.START_DATE, rDST.END_DATE, rDST.DISPLAY_SEQ);
    nVERSION_NBR := 1;
  --
    if rDST.DESCRIPTION_FR is not null
    then
      P_DISPLACEMENT_STATUS.SET_DST_DESCRIPTION(nDST_ID, nVERSION_NBR, 'fr', rDST.DESCRIPTION_FR);
    end if;
  --
    if rDST.NOTES is not null
    then
      nSEQ_NBR := null;
      P_DISPLACEMENT_STATUS.SET_DST_TEXT(nDST_ID, nVERSION_NBR, 'NOTE', nSEQ_NBR, 'en', rDST.NOTES);
    end if;
  end loop;
--
  dbms_output.put_line(to_char(iCount) || ' DISPLACEMENT_STATUSES records inserted');
end;
/
