declare
  nITM_ID number;
  nTXT_SEQ_NBR number;
begin
  nITM_ID := null;
  nTXT_SEQ_NBR := null;
  P_TEXT.SET_TEXT(nITM_ID, 'SEX', 'DESCR', nTXT_SEQ_NBR, 'en', 'Female');
  insert into T_SEXES (CODE, DISPLAY_SEQ, ITM_ID) values ('F', 1, nITM_ID);
  P_TEXT.SET_TEXT(nITM_ID, 'SEX', 'DESCR', nTXT_SEQ_NBR, 'fr', 'femelle');
  P_TEXT.SET_TEXT(nITM_ID, 'SEX', 'DESCR', nTXT_SEQ_NBR, 'es', 'femenino');
  P_TEXT.SET_TEXT(nITM_ID, 'SEX', 'DESCR', nTXT_SEQ_NBR, 'ru', unistr('\0436\0435\043D\0449\0438\043D\0430'));
  P_TEXT.SET_TEXT(nITM_ID, 'SEX', 'DESCR', nTXT_SEQ_NBR, 'ar', unistr('\0623\0646\062B\0649'));
  P_TEXT.SET_TEXT(nITM_ID, 'SEX', 'DESCR', nTXT_SEQ_NBR, 'zh', unistr('\5973'));
--
  nITM_ID := null;
  nTXT_SEQ_NBR := null;
  P_TEXT.SET_TEXT(nITM_ID, 'SEX', 'DESCR', nTXT_SEQ_NBR, 'en', 'Male');
  insert into T_SEXES (CODE, DISPLAY_SEQ, ITM_ID) values ('M', 2, nITM_ID);
  P_TEXT.SET_TEXT(nITM_ID, 'SEX', 'DESCR', nTXT_SEQ_NBR, 'fr', unistr('m\00E2le'));
  P_TEXT.SET_TEXT(nITM_ID, 'SEX', 'DESCR', nTXT_SEQ_NBR, 'es', 'masculino');
  P_TEXT.SET_TEXT(nITM_ID, 'SEX', 'DESCR', nTXT_SEQ_NBR, 'ru', unistr('\043C\0443\0436\0447\0438\043D\0430'));
  P_TEXT.SET_TEXT(nITM_ID, 'SEX', 'DESCR', nTXT_SEQ_NBR, 'ar', unistr('\0630\0643\0631'));
  P_TEXT.SET_TEXT(nITM_ID, 'SEX', 'DESCR', nTXT_SEQ_NBR, 'zh', unistr('\7537'));
end;
/
