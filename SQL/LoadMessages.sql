set serveroutput on

declare
  nVERSION_NBR P_BASE.tnCOMP_VERSION_NBR;
  nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  iCount pls_integer := 0;
begin
  for rCOMP in
   (select CODE, DESCRIPTION_EN, DISPLAY_SEQ, DESCRIPTION_FR, NOTES
    from S_COMPONENTS)
  loop
    iCount := iCount + 1;
  --
    P_MESSAGE.INSERT_COMPONENT(rCOMP.CODE, 'en', rCOMP.DESCRIPTION_EN, rCOMP.DISPLAY_SEQ);
    nVERSION_NBR := 1;
  --
    if rCOMP.DESCRIPTION_FR is not null
    then P_MESSAGE.SET_COMP_DESCRIPTION(rCOMP.CODE, nVERSION_NBR, 'fr', rCOMP.DESCRIPTION_FR);
    end if;
  --
    if rCOMP.NOTES is not null
    then
      nSEQ_NBR := null;
      P_MESSAGE.SET_COMP_TEXT(rCOMP.CODE, nVERSION_NBR, 'NOTE', nSEQ_NBR, 'en', rCOMP.NOTES);
    end if;
  end loop;
--
  dbms_output.put_line(to_char(iCount) || ' COMPONENTS records inserted');
end;
/

declare
  nMSG_SEQ_NBR P_BASE.tnMSG_SEQ_NBR;
  nVERSION_NBR P_BASE.tnMSG_VERSION_NBR;
  nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  iCount pls_integer := 0;
begin
  for rMSG in
   (select COMP_CODE, MESSAGE_EN, SEVERITY, SEQ_NBR, MESSAGE_FR, NOTES
    from S_MESSAGES)
  loop
    iCount := iCount + 1;
  --
    nMSG_SEQ_NBR := null;
    P_MESSAGE.INSERT_MESSAGE(rMSG.COMP_CODE, nMSG_SEQ_NBR, 'en', rMSG.MESSAGE_EN, rMSG.SEVERITY);
    if nMSG_SEQ_NBR = rMSG.SEQ_NBR
    then null;
    else raise_application_error(-20000, 'Message sequence number mismatch: ' || rMSG.COMP_CODE || '/' || to_char(rMSG.SEQ_NBR));
    end if;
    nVERSION_NBR := 1;
  --
    if rMSG.MESSAGE_FR is not null
    then P_MESSAGE.SET_MSG_MESSAGE(rMSG.COMP_CODE, nMSG_SEQ_NBR, nVERSION_NBR, 'fr', rMSG.MESSAGE_FR);
    end if;
  --
    if rMSG.NOTES is not null
    then
      nSEQ_NBR := null;
      P_MESSAGE.SET_MSG_TEXT(rMSG.COMP_CODE, nMSG_SEQ_NBR, nVERSION_NBR, 'NOTE', nSEQ_NBR, 'en', rMSG.NOTES);
    end if;
  end loop;
--
  dbms_output.put_line(to_char(iCount) || ' MESSAGES records inserted');
end;
/
