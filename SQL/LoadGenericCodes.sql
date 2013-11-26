set serveroutput on

declare
  nVERSION_NBR P_BASE.tnCDET_VERSION_NBR;
  nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  iCount pls_integer := 0;
begin
  for rCDET in
   (select CODE, DESCRIPTION_EN, DISPLAY_SEQ, DESCRIPTION_FR, NOTES
    from S_CODE_TYPES)
  loop
    iCount := iCount + 1;
  --
    P_CODE.INSERT_CODE_TYPE(rCDET.CODE, 'en', rCDET.DESCRIPTION_EN, rCDET.DISPLAY_SEQ);
    nVERSION_NBR := 1;
  --
    if rCDET.DESCRIPTION_FR is not null
    then
      P_CODE.SET_CDET_DESCRIPTION(rCDET.CODE, nVERSION_NBR, 'fr', rCDET.DESCRIPTION_FR);
    end if;
  --
    if rCDET.NOTES is not null
    then
      nSEQ_NBR := null;
      P_CODE.SET_CDET_TEXT(rCDET.CODE, nVERSION_NBR, 'NOTE', nSEQ_NBR, 'en', rCDET.NOTES);
    end if;
  end loop;
--
  dbms_output.put_line(to_char(iCount) || ' CODE_TYPES records inserted');
end;
/

declare
  nVERSION_NBR P_BASE.tnCDE_VERSION_NBR;
  nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  iCount pls_integer := 0;
begin
  for rCDE in
   (select CDET_CODE, CODE, DESCRIPTION_EN, DISPLAY_SEQ, DESCRIPTION_FR, NOTES
    from S_CODES)
  loop
    iCount := iCount + 1;
  --
    P_CODE.INSERT_CODE
     (rCDE.CDET_CODE, rCDE.CODE, 'en', rCDE.DESCRIPTION_EN, rCDE.DISPLAY_SEQ);
    nVERSION_NBR := 1;
  --
    if rCDE.DESCRIPTION_FR is not null
    then
      P_CODE.SET_CDE_DESCRIPTION
       (rCDE.CDET_CODE, rCDE.CODE, nVERSION_NBR, 'fr', rCDE.DESCRIPTION_FR);
    end if;
  --
    if rCDE.NOTES is not null
    then
      nSEQ_NBR := null;
      P_CODE.SET_CDE_TEXT
       (rCDE.CDET_CODE, rCDE.CODE, nVERSION_NBR, 'NOTE', nSEQ_NBR, 'en', rCDE.NOTES);
    end if;
  end loop;
--
  dbms_output.put_line(to_char(iCount) || ' CODES records inserted');
end;
/
