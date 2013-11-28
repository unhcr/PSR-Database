set serveroutput on

declare
  nVERSION_NBR P_BASE.tnSTGAT_VERSION_NBR;
  nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  nCount pls_integer := 0;
begin
  for rSTGAT in
   (select CODE, DESCRIPTION_EN, DATA_TYPE, DISPLAY_SEQ, DESCRIPTION_FR, NOTES
    from STAGE.S_STC_GROUP_ATTRIBUTE_TYPES)
  loop
    nCount := nCount + 1;
  --
    P_STATISTIC_GROUP.INSERT_STG_ATTRIBUTE_TYPE(rSTGAT.CODE, rSTGAT.DATA_TYPE, 'en', rSTGAT.DESCRIPTION_EN, rSTGAT.DISPLAY_SEQ);
    nVERSION_NBR := 1;
  --
    if rSTGAT.DESCRIPTION_FR is not null
    then
      P_STATISTIC_GROUP.SET_STGAT_DESCRIPTION(rSTGAT.CODE, nVERSION_NBR, 'fr', rSTGAT.DESCRIPTION_FR);
    end if;
  --
    if rSTGAT.NOTES is not null
    then
      nSEQ_NBR := null;
      P_STATISTIC_GROUP.SET_STGAT_TEXT(rSTGAT.CODE, nVERSION_NBR, 'NOTE', nSEQ_NBR, 'en', rSTGAT.NOTES);
    end if;
  end loop;
--
  dbms_output.put_line(to_char(nCount) || ' STC_GROUP_ATTRIBUTE_TYPES records inserted');
end;
/
