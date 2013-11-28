set serveroutput on

declare
  nVERSION_NBR P_BASE.tnTXTT_VERSION_NBR;
  nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  iCount pls_integer := 0;
begin
  for rTXTT in
   (select A.CODE, A.DESCRIPTION_EN, A.DISPLAY_SEQ,
      A.DESCRIPTION_FR, A.DESCRIPTION_ES, A.DESCRIPTION_RU, A.DESCRIPTION_AR, A.DESCRIPTION_ZH,
      A.NOTES, B.VERSION_NBR
    from STAGE.S_TEXT_TYPES A
    left outer join T_TEXT_TYPES B
      on B.CODE = A.CODE
    order by A.CODE)
  loop
    iCount := iCount + 1;
  --
    nVERSION_NBR := rTXTT.VERSION_NBR;
    P_TEXT_TYPE.SET_TEXT_TYPE
     (rTXTT.CODE, nVERSION_NBR, 'en', rTXTT.DESCRIPTION_EN, rTXTT.DISPLAY_SEQ);
  --
    if rTXTT.DESCRIPTION_FR is not null
    then P_TEXT_TYPE.SET_TXTT_DESCRIPTION(rTXTT.CODE, nVERSION_NBR, 'fr', rTXTT.DESCRIPTION_FR);
    end if;
  --
    if rTXTT.DESCRIPTION_ES is not null
    then P_TEXT_TYPE.SET_TXTT_DESCRIPTION(rTXTT.CODE, nVERSION_NBR, 'es', rTXTT.DESCRIPTION_ES);
    end if;
  --
    if rTXTT.DESCRIPTION_RU is not null
    then P_TEXT_TYPE.SET_TXTT_DESCRIPTION(rTXTT.CODE, nVERSION_NBR, 'ru', rTXTT.DESCRIPTION_RU);
    end if;
  --
    if rTXTT.DESCRIPTION_AR is not null
    then P_TEXT_TYPE.SET_TXTT_DESCRIPTION(rTXTT.CODE, nVERSION_NBR, 'ar', rTXTT.DESCRIPTION_AR);
    end if;
  --
    if rTXTT.DESCRIPTION_ZH is not null
    then P_TEXT_TYPE.SET_TXTT_DESCRIPTION(rTXTT.CODE, nVERSION_NBR, 'zh', rTXTT.DESCRIPTION_ZH);
    end if;
  --
    if rTXTT.NOTES is not null
    then
      nSEQ_NBR := null;
      P_TEXT_TYPE.SET_TXTT_TEXT(rTXTT.CODE, nVERSION_NBR, 'NOTE', nSEQ_NBR, 'en', rTXTT.NOTES);
    end if;
  end loop;
--
  dbms_output.put_line(to_char(iCount) || ' TEXT_TYPES records inserted');
end;
/

declare
  nVERSION_NBR P_BASE.tnTTP_VERSION_NBR;
  nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  iCount pls_integer := 0;
begin
  for rTTP in
   (select A.TXTT_CODE, A.TAB_ALIAS, A.MANDATORY_FLAG, A.MULTI_INSTANCE_FLAG, A.LONG_TEXT_FLAG,
      A.NOTES, B.VERSION_NBR
    from STAGE.S_TEXT_TYPE_PROPERTIES A
    left outer join T_TEXT_TYPE_PROPERTIES B
      on B.TXTT_CODE = A.TXTT_CODE
      and B.TAB_ALIAS = A.TAB_ALIAS
    order by A.TXTT_CODE, A.TAB_ALIAS)
  loop
    iCount := iCount + 1;
  --
    nVERSION_NBR := rTTP.VERSION_NBR;
    P_TEXT_TYPE.SET_TEXT_TYPE_PROPERTIES
     (rTTP.TXTT_CODE, rTTP.TAB_ALIAS, nVERSION_NBR,
      rTTP.MANDATORY_FLAG, rTTP.MULTI_INSTANCE_FLAG, rTTP.LONG_TEXT_FLAG);
  --
    if rTTP.NOTES is not null
    then
      nSEQ_NBR := null;
      P_TEXT_TYPE.SET_TTP_TEXT
       (rTTP.TXTT_CODE, rTTP.TAB_ALIAS, nVERSION_NBR, 'NOTE', nSEQ_NBR, 'en', rTTP.NOTES);
    end if;
  end loop;
--
  dbms_output.put_line(to_char(iCount) || ' TEXT_TYPE_PROPERTIES records inserted');
end;
/
