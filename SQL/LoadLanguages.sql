set serveroutput on

declare
  nVERSION_NBR P_BASE.tnLANG_VERSION_NBR;
  nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  iCount pls_integer := 0;
begin
  for rLANG in
   (select A.CODE, A.NAME_EN, A.DISPLAY_SEQ, A.ACTIVE_FLAG,
      A.NAME_FR, A.NAME_ES, A.NAME_RU, A.NAME_AR, A.NAME_ZH,
      A.NOTES, B.VERSION_NBR
    from S_LANGUAGES A
    left outer join T_LANGUAGES B
      on B.CODE = A.CODE
    order by A.CODE)
  loop
    iCount := iCount + 1;
  --
    nVERSION_NBR := rLANG.VERSION_NBR;
    P_LANGUAGE.SET_LANGUAGE(rLANG.CODE, nVERSION_NBR, 'en', rLANG.NAME_EN, rLANG.DISPLAY_SEQ, rLANG.ACTIVE_FLAG);
  --
    if rLANG.NAME_FR is not null
    then
      P_LANGUAGE.SET_LANG_DESCRIPTION(rLANG.CODE, nVERSION_NBR, 'fr', rLANG.NAME_FR);
    end if;
  --
    if rLANG.NAME_ES is not null
    then
      P_LANGUAGE.SET_LANG_DESCRIPTION(rLANG.CODE, nVERSION_NBR, 'es', rLANG.NAME_ES);
    end if;
  --
    if rLANG.NAME_RU is not null
    then
      P_LANGUAGE.SET_LANG_DESCRIPTION(rLANG.CODE, nVERSION_NBR, 'ru', rLANG.NAME_RU);
    end if;
  --
    if rLANG.NAME_AR is not null
    then
      P_LANGUAGE.SET_LANG_DESCRIPTION(rLANG.CODE, nVERSION_NBR, 'ar', rLANG.NAME_AR);
    end if;
  --
    if rLANG.NAME_ZH is not null
    then
      P_LANGUAGE.SET_LANG_DESCRIPTION(rLANG.CODE, nVERSION_NBR, 'zh', rLANG.NAME_ZH);
    end if;
  --
    if rLANG.NOTES is not null
    then
      nSEQ_NBR := null;
      P_LANGUAGE.SET_LANG_TEXT(rLANG.CODE, nVERSION_NBR, 'NOTE', nSEQ_NBR, 'en', rLANG.NOTES);
    end if;
  end loop;
--
  dbms_output.put_line(to_char(iCount) || ' LANGUAGES records inserted');
end;
/
