set serveroutput on size 1000000

declare
  nSTG_ID P_BASE.tnSTG_ID;
  nSTC_ID P_BASE.tnSTC_ID;
--
  iCount1 pls_integer := 0;
  iCount2 pls_integer := 0;
begin
  P_UTILITY.START_MODULE('LoadIDPStatistics');
--
  for rSTC in
   (select STATSYEAR, START_DATE_YEAR, END_DATE_YEAR, START_DATE, END_DATE,
      DST_CODE, DST_ID, COU_CODE_ASYLUM, LOC_ID_ASYLUM_COUNTRY,
      LOCATION_NAME_EN, LOC_TYPE_DESCRIPTION_EN, LOC_ID_ASYLUM1, LOC_COUNT, LOC_ID_ASYLUM2,
      OFFICIAL, DIM_ID1,
      SOURCE, BASIS,
      STTG_CODE, STCT_CODE,
      VALUE,
      row_number() over
       (partition by STATSYEAR, DST_ID, LOC_ID_ASYLUM_COUNTRY,
          nvl(LOC_ID_ASYLUM1, LOC_ID_ASYLUM2), DIM_ID1
        order by START_DATE, STCT_CODE) as STG_CHILD_NUMBER
    from 
     (select STC.STATSYEAR, STC.START_DATE_YEAR, STC.END_DATE_YEAR, STC.START_DATE, STC.END_DATE,
        STC.DST_CODE, DST.ID as DST_ID,
        STC.COU_CODE_ASYLUM, COU.ID as LOC_ID_ASYLUM_COUNTRY,
        STC.LOCATION_NAME_EN, STC.LOC_TYPE_DESCRIPTION_EN,
        LOC1.ID as LOC_ID_ASYLUM1,
        count(distinct LOC2.ID) as LOC_COUNT, max(LOC2.ID) as LOC_ID_ASYLUM2,
        STC.OFFICIAL, DIM.ID as DIM_ID1,
        STC.SOURCE, STC.BASIS,
        STC.STTG_CODE, STC.STCT_CODE,
        STC.VALUE
      from 
       (select STATSYEAR,
          to_date(STATSYEAR || '0101', 'YYYYMMDD') as START_DATE_YEAR,
          add_months(to_date(STATSYEAR || '0101', 'YYYYMMDD'), 12) as END_DATE_YEAR,
          case
            when DATA_POINT in ('POP_END', 'POP_AH_END')
            then to_date(STATSYEAR || '1231', 'YYYYMMDD')
            else to_date(STATSYEAR || '0101', 'YYYYMMDD')
          end as START_DATE,
          case
            when DATA_POINT in ('POP_START', 'POP_AH_START')
            then to_date(STATSYEAR || '0102', 'YYYYMMDD')
            else add_months(to_date(STATSYEAR || '0101', 'YYYYMMDD'), 12)
          end as END_DATE,
          DST_CODE, COU_CODE_ASYLUM, LOCATION_NAME_EN, LOC_TYPE_DESCRIPTION_EN, OFFICIAL,
          SOURCE, BASIS,
          STTG_CODE,
          'IDP' ||
            case STTG_CODE
              when 'IDP' then 'H'
              when 'IDPCNFLCT' then 'C'
              when 'IDPNTRLDIS' then 'D'
            end ||
            case DATA_POINT
              when 'POP_START' then 'POP'
              when 'POP_AH_START' then 'POP-AH'
              when 'IDPNEW' then 'NEW'
              when 'IDPOTHINC' then 'OTHINC'
              when 'RETURN' then 'RTN'
              when 'RETURN_AH' then 'RTN-AH'
              when 'IDPRELOC' then 'RELOC'
              when 'IDPOTHDEC' then 'OTHDEC'
              when 'POP_END' then 'POP'
              when 'POP_AH_END' then 'POP-AH'
            end as STCT_CODE,
          VALUE
        from S_ASR_IDPS where STATSYEAR = &year) STC
      left outer join T_DISPLACEMENT_STATUSES DST
        on DST.CODE = STC.DST_CODE
        and DST.START_DATE < STC.END_DATE_YEAR
        and DST.END_DATE >= STC.END_DATE_YEAR
      left outer join -- Country
       (select LOCA.CHAR_VALUE as UNHCR_COUNTRY_CODE, LOC.START_DATE, LOC.END_DATE, LOC.ID,
          TXT.TEXT as NAME
        from T_LOCATION_ATTRIBUTES LOCA
        inner join T_LOCATIONS LOC
          on LOC.ID = LOCA.LOC_ID
          and LOC.LOCT_CODE = 'COUNTRY'
        inner join T_TEXT_ITEMS TXT
          on TXT.ITM_ID = LOC.ITM_ID
          and TXT.TXTT_CODE = 'NAME'
          and TXT.SEQ_NBR = 1
          and TXT.LANG_CODE = 'en'
        where LOCA.LOCAT_CODE = 'HCRCC') COU
        on COU.UNHCR_COUNTRY_CODE = STC.COU_CODE_ASYLUM
        and COU.START_DATE < STC.END_DATE_YEAR
        and COU.END_DATE >= STC.END_DATE_YEAR
      left outer join -- Asylum location (matching on name and type)
       (select LOCR.LOC_ID_FROM, LOCR.LOCRT_CODE, LOCR.START_DATE, LOCR.END_DATE, LOC.ID,
          LOC.NAME_EN, nvl(LOCTV.DESCRIPTION_EN, LOCT.DESCRIPTION_EN) as LOC_TYPE_DESCRIPTION_EN
        from T_LOCATION_RELATIONSHIPS LOCR
        inner join
         (select LOC.ID, LOC.LOCT_CODE, LOC.LOCTV_ID, LOC.START_DATE, LOC.END_DATE,
            TXT.TEXT as NAME_EN
          from T_LOCATIONS LOC
          inner join T_TEXT_ITEMS TXT
            on TXT.ITM_ID = LOC.ITM_ID
            and TXT.TXTT_CODE = 'NAME'
            and TXT.SEQ_NBR = 1
            and TXT.LANG_CODE = 'en') LOC
          on LOC.ID = LOCR.LOC_ID_TO
        inner join
         (select LOCT.CODE, TXT.TEXT as DESCRIPTION_EN
          from T_LOCATION_TYPES LOCT
          inner join T_TEXT_ITEMS TXT
            on TXT.ITM_ID = LOCT.ITM_ID
            and TXT.TXTT_CODE = 'DESCR'
            and TXT.SEQ_NBR = 1
            and TXT.LANG_CODE = 'en') LOCT
          on LOCT.CODE = LOC.LOCT_CODE
        left outer join
         (select LOCTV.ID, TXT.TEXT as DESCRIPTION_EN
          from T_LOCATION_TYPE_VARIANTS LOCTV
          inner join T_TEXT_ITEMS TXT
            on TXT.ITM_ID = LOCTV.ITM_ID
            and TXT.TXTT_CODE = 'DESCR'
            and TXT.SEQ_NBR = 1
            and TXT.LANG_CODE = 'en') LOCTV
          on LOCTV.ID = LOC.LOCTV_ID) LOC1
        on LOC1.LOC_ID_FROM = COU.ID
        and LOC1.LOCRT_CODE = 'WITHIN'
        and LOC1.START_DATE < STC.END_DATE_YEAR
        and LOC1.END_DATE >= STC.END_DATE_YEAR
        and LOC1.NAME_EN = STC.LOCATION_NAME_EN
        and LOC1.LOC_TYPE_DESCRIPTION_EN = nvl(STC.LOC_TYPE_DESCRIPTION_EN, 'Undefined')
      left outer join -- Asylum location (matching on name only)
       (select LOCR.LOC_ID_FROM, LOCR.LOCRT_CODE, LOCR.START_DATE, LOCR.END_DATE, LOC.ID, LOC.NAME_EN
        from T_LOCATION_RELATIONSHIPS LOCR
        inner join
         (select LOC.ID, LOC.LOCT_CODE, LOC.LOCTV_ID, LOC.START_DATE, LOC.END_DATE,
            TXT.TEXT as NAME_EN
          from T_LOCATIONS LOC
          inner join T_TEXT_ITEMS TXT
            on TXT.ITM_ID = LOC.ITM_ID
            and TXT.TXTT_CODE = 'NAME'
            and TXT.SEQ_NBR = 1
            and TXT.LANG_CODE = 'en') LOC
          on LOC.ID = LOCR.LOC_ID_TO) LOC2
        on LOC2.LOC_ID_FROM = COU.ID
        and LOC2.LOCRT_CODE = 'WITHIN'
        and LOC2.START_DATE < STC.END_DATE_YEAR
        and LOC2.END_DATE >= STC.END_DATE_YEAR
        and LOC2.NAME_EN = nvl(STC.LOCATION_NAME_EN, COU.NAME)
      left outer join T_DIMENSION_VALUES DIM
        on DIM.DIMT_CODE = 'OFFICIAL'
        and DIM.CODE = STC.OFFICIAL
        and DIM.START_DATE < STC.END_DATE_YEAR
        and DIM.END_DATE >= STC.END_DATE_YEAR
      group by STC.STATSYEAR, STC.START_DATE_YEAR, STC.END_DATE_YEAR, STC.START_DATE, STC.END_DATE,
        STC.DST_CODE, DST.ID, STC.COU_CODE_ASYLUM, COU.ID,
        STC.LOCATION_NAME_EN, STC.LOC_TYPE_DESCRIPTION_EN, LOC1.ID,
        STC.OFFICIAL, DIM.ID, STC.SOURCE, STC.BASIS, STC.STTG_CODE, STC.STCT_CODE, STC.VALUE)
    order by STATSYEAR, DST_CODE, COU_CODE_ASYLUM, nvl(LOC_ID_ASYLUM1, LOC_ID_ASYLUM2),
      OFFICIAL, STG_CHILD_NUMBER)
  loop
    P_UTILITY.TRACE_POINT('Trace',
      rSTC.STATSYEAR || '~' || rSTC.STCT_CODE || '~' || rSTC.DST_CODE || '~' ||
        rSTC.COU_CODE_ASYLUM || '~' || rSTC.OFFICIAL || '~' || rSTC.SOURCE || '~' ||
        rSTC.BASIS || '~' || rSTC.LOCATION_NAME_EN || ':' || rSTC.LOC_TYPE_DESCRIPTION_EN || ':' ||
        to_char(rSTC.STG_CHILD_NUMBER));
  --
    if rSTC.DST_ID is null
    then
      dbms_output.put_line
       ('Invalid displacement status: ' || rSTC.STATSYEAR || '~' || rSTC.DST_CODE);
    elsif rSTC.LOC_ID_ASYLUM_COUNTRY is null
    then
      dbms_output.put_line
       ('Invalid country of asylum: ' || rSTC.STATSYEAR || '~' || rSTC.COU_CODE_ASYLUM);
    elsif rSTC.LOC_ID_ASYLUM1 is null and rSTC.LOC_COUNT = 0
    then
      dbms_output.put_line
       ('Invalid asylum location: ' || rSTC.STATSYEAR || '~' || rSTC.COU_CODE_ASYLUM || '~' ||
          rSTC.LOCATION_NAME_EN || ' : ' || rSTC.LOC_TYPE_DESCRIPTION_EN);
    elsif rSTC.LOC_ID_ASYLUM1 is null and rSTC.LOC_COUNT > 1
    then
      dbms_output.put_line
       ('Ambiguous asylum location: ' || rSTC.STATSYEAR || '~' || rSTC.COU_CODE_ASYLUM || '~' ||
          rSTC.LOCATION_NAME_EN || ' : ' || rSTC.LOC_TYPE_DESCRIPTION_EN);
    else
      if rSTC.STG_CHILD_NUMBER = 1
      then
        P_STATISTIC_GROUP.INSERT_STATISTIC_GROUP
         (nSTG_ID, rSTC.START_DATE_YEAR, rSTC.END_DATE_YEAR,
          psSTTG_CODE => rSTC.STTG_CODE,
          pnDST_ID => rSTC.DST_ID,
          pnLOC_ID_ASYLUM_COUNTRY => rSTC.LOC_ID_ASYLUM_COUNTRY,
          pnLOC_ID_ASYLUM => nvl(rSTC.LOC_ID_ASYLUM1, rSTC.LOC_ID_ASYLUM2),
          pnLOC_ID_ORIGIN_COUNTRY => rSTC.LOC_ID_ASYLUM_COUNTRY,
          pnDIM_ID1 => rSTC.DIM_ID1);
        iCount1 := iCount1 + 1;
      --
        if rSTC.SOURCE is not null
        then P_STATISTIC_GROUP.INSERT_STG_ATTRIBUTE(nSTG_ID, 'SOURCE', rSTC.SOURCE);
        end if;
      --
        if rSTC.BASIS is not null
        then P_STATISTIC_GROUP.INSERT_STG_ATTRIBUTE(nSTG_ID, 'BASIS', rSTC.BASIS);
        end if;
      end if;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, rSTC.VALUE, rSTC.START_DATE, rSTC.END_DATE, rSTC.STCT_CODE, rSTC.DST_ID,
        pnLOC_ID_ASYLUM_COUNTRY => rSTC.LOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ASYLUM => nvl(rSTC.LOC_ID_ASYLUM1, rSTC.LOC_ID_ASYLUM2),
        pnLOC_ID_ORIGIN_COUNTRY => rSTC.LOC_ID_ASYLUM_COUNTRY,
        pnDIM_ID1 => case when rSTC.STTG_CODE = 'IDP' then rSTC.DIM_ID1 end,
        pnSTG_ID_PRIMARY => nSTG_ID);
      iCount2 := iCount2 + 1;
    end if;
  end loop;
--
  if iCount1 = 1
  then dbms_output.put_line('1 statistic group record inserted');
  else dbms_output.put_line(to_char(iCount1) || ' statistic group records inserted');
  end if;
--
  if iCount2 = 1
  then dbms_output.put_line('1 statistic record inserted');
  else dbms_output.put_line(to_char(iCount2) || ' statistic records inserted');
  end if;
--
  P_UTILITY.END_MODULE;
end;
/
