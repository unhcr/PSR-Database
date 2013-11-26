declare
  dRunTime date := sysdate;
  hFile utl_file.file_type;
begin
--
-- Preserve current value of LOC_SEQ sequence
--
  hFile := utl_file.fopen('PSRDATA', 'LOC_SEQ.csv', 'w');
  for rSEQ in
   (select LOC_SEQ.nextval
    from DUAL)
  loop
    utl_file.put_line(hFile, to_char(rSEQ.NEXTVAL));
  end loop;
  utl_file.fclose(hFile);
--
  utl_file.fcopy('PSRDATA', 'LOC_SEQ.csv',
                 'PSRARCHIVE', to_char(dRunTime, '"LOC_SEQ_"YYYYMMDD_HH24MISS".csv"'));
--
-- Preserve location ids of all existing locations
--
  hFile := utl_file.fopen('PSRDATA', 'LOCATION_IDS.csv', 'w');
--
  for rCSV in
   (select LOCT_CODE || ',' ||
      case
        when LOCTV_DESCRIPTION_EN like '%,%'
        then '"' || replace(LOCTV_DESCRIPTION_EN, '"', '""') || '"'
        else LOCTV_DESCRIPTION_EN
      end || ',' ||
      case
        when NAME_EN like '%,%' then '"' || replace(NAME_EN, '"', '""') || '"'
        else NAME_EN
      end || ',' ||
      ISO_COUNTRY_CODE || ',' ||
      to_char(case when START_DATE != P_BASE.MIN_DATE then START_DATE end, 'YYYY-MM-DD') || ',' ||
      to_char(ID) as LINE
    from
     (select LOC.LOCT_CODE, LOCTV.DESCRIPTION as LOCTV_DESCRIPTION_EN, TXT.TEXT as NAME_EN,
        COU.ISO_COUNTRY_CODE, nvl(min(COU.START_DATE), LOC.START_DATE) as START_DATE, LOC.ID
      from T_LOCATIONS LOC
      inner join T_TEXT_ITEMS TXT
        on TXT.ITM_ID = LOC.ITM_ID
        and TXT.TXTT_CODE = 'NAME'
        and TXT.SEQ_NBR = 1
        and TXT.LANG_CODE = 'en'
      left outer join
       (select LOCTV.ID, TXT.TEXT as DESCRIPTION
        from T_LOCATION_TYPE_VARIANTS LOCTV
        inner join T_TEXT_ITEMS TXT
          on TXT.ITM_ID = LOCTV.ITM_ID
          and TXT.TXTT_CODE = 'DESCR'
          and TXT.SEQ_NBR = 1
          and TXT.LANG_CODE = 'en') LOCTV
        on LOCTV.ID = LOC.LOCTV_ID
      left outer join
       (select LOCR.LOC_ID_TO, LOCA.CHAR_VALUE as ISO_COUNTRY_CODE, LOC.START_DATE,
          row_number() over (partition by LOCR.LOC_ID_TO order by LOC.START_DATE) as SEQ_NBR
        from T_LOCATION_RELATIONSHIPS LOCR
        inner join T_LOCATIONS LOC
          on LOC.ID = LOCR.LOC_ID_FROM
          and LOC.LOCT_CODE = 'COUNTRY'
        inner join T_LOCATION_ATTRIBUTES LOCA
          on LOCA.LOC_ID = LOC.ID
          and LOCA.LOCAT_CODE = 'ISO3166A3'
        where LOCR.LOCRT_CODE = 'WITHIN') COU
        on COU.LOC_ID_TO = LOC.ID
        and COU.SEQ_NBR = 1
      group by LOC.LOCT_CODE, LOCTV.DESCRIPTION, TXT.TEXT, COU.ISO_COUNTRY_CODE, LOC.START_DATE,
        LOC.ID))
  loop
    utl_file.put_line(hFile, rCSV.LINE);
  end loop;
--
  utl_file.fclose(hFile);
--
  utl_file.fcopy('PSRDATA', 'LOCATION_IDS.csv',
                 'PSRARCHIVE', to_char(dRunTime, '"LOCATION_IDS_"YYYYMMDD_HH24MISS".csv"'));
end;
/
