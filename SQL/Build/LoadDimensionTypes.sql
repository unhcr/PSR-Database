set serveroutput on

declare
  nVERSION_NBR P_BASE.tnDIMT_VERSION_NBR;
  nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  iCount pls_integer := 0;
begin
  for rDIMT in
   (select CODE, DESCRIPTION_EN, DISPLAY_SEQ, DESCRIPTION_FR, NOTES
    from S_DIMENSION_TYPES)
  loop
    iCount := iCount + 1;
  --
    P_DIMENSION.INSERT_DIMENSION_TYPE(rDIMT.CODE, 'en', rDIMT.DESCRIPTION_EN, rDIMT.DISPLAY_SEQ);
    nVERSION_NBR := 1;
  --
    if rDIMT.DESCRIPTION_FR is not null
    then
      P_DIMENSION.SET_DIMT_DESCRIPTION(rDIMT.CODE, nVERSION_NBR, 'fr', rDIMT.DESCRIPTION_FR);
    end if;
  --
    if rDIMT.NOTES is not null
    then
      nSEQ_NBR := null;
      P_DIMENSION.SET_DIMT_TEXT(rDIMT.CODE, nVERSION_NBR, 'NOTE', nSEQ_NBR, 'en', rDIMT.NOTES);
    end if;
  end loop;
--
  dbms_output.put_line(to_char(iCount) || ' DIMENSION_TYPES records inserted');
end;
/

declare
  nDIM_ID P_BASE.tnDIM_ID;
  nVERSION_NBR P_BASE.tnDIM_VERSION_NBR;
  nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  iCount pls_integer := 0;
begin
  for rDIM in
   (select DIMT_CODE, CODE, DESCRIPTION_EN, DISPLAY_SEQ, START_DATE, END_DATE, DESCRIPTION_FR, NOTES
    from S_DIMENSION_VALUES)
  loop
    iCount := iCount + 1;
  --
    P_DIMENSION.INSERT_DIMENSION_VALUE
     (nDIM_ID, 'en', rDIM.DESCRIPTION_EN, rDIM.DIMT_CODE, rDIM.CODE, rDIM.START_DATE, rDIM.END_DATE,
      rDIM.DISPLAY_SEQ);
    nVERSION_NBR := 1;
  --
    if rDIM.DESCRIPTION_FR is not null
    then
      P_DIMENSION.SET_DIM_DESCRIPTION(nDIM_ID, nVERSION_NBR, 'fr', rDIM.DESCRIPTION_FR);
    end if;
  --
    if rDIM.NOTES is not null
    then
      nSEQ_NBR := null;
      P_DIMENSION.SET_DIM_TEXT(nDIM_ID, nVERSION_NBR, 'NOTE', nSEQ_NBR, 'en', rDIM.NOTES);
    end if;
  end loop;
--
  dbms_output.put_line(to_char(iCount) || ' DIMENSION_VALUES records inserted');
end;
/
