set serveroutput on

declare
  nLOC_ID P_BASE.tnLOC_ID;
  nVERSION_NBR P_BASE.tnLOC_VERSION_NBR;
  iCount1 pls_integer := 0;
  iCount2 pls_integer := 0;
begin
  for rSDIV in
   (select LSD.COU_CODE,
      nvl(LSD.COU_START_DATE, P_BASE.MIN_DATE) as COU_START_DATE,
      LSD.LOCATION_NAME_EN,
      LSD.MSRP_CODE,
      LSD.HLEVEL,
      LSD.LOCT_CODE,
      LSD.LOC_TYPE_DESCRIPTION_EN,
      nvl(LSD.LOC_START_DATE, P_BASE.MIN_DATE) as LOC_START_DATE,
      nvl(LSD.LOC_END_DATE, P_BASE.MAX_DATE) as LOC_END_DATE,
      nvl(LSD.LOCR_START_DATE, P_BASE.MIN_DATE) as LOCR_START_DATE,
      nvl(LSD.LOCR_END_DATE, P_BASE.MAX_DATE) as LOCR_END_DATE,
      LSD.COU_CODE_PREV,
      nvl(LSD.COU_START_DATE_PREV, P_BASE.MIN_DATE) as COU_START_DATE_PREV,
      COU.ID as COU_ID,
      count(distinct LOCTV.ID) as LOCTV_COUNT,
      max(LOCTV.ID) as LOCTV_ID
    from S_LOCATION_SUBDIVISIONS LSD
    left outer join
     (select LOC.ID, LOC.START_DATE, LOCA.CHAR_VALUE as UNHCR_COUNTRY_CODE
      from T_LOCATIONS LOC
      inner join T_LOCATION_ATTRIBUTES LOCA
        on LOCA.LOC_ID = LOC.ID
        and LOCA.LOCAT_CODE = 'HCRCC') COU
      on COU.UNHCR_COUNTRY_CODE = LSD.COU_CODE
      and COU.START_DATE = nvl(LSD.COU_START_DATE, P_BASE.MIN_DATE)
    left outer join
     (select LOCTV.ID, LOCTV.LOC_ID, LOCTV.LOCT_CODE, LOCTV.LOCRT_CODE, TXT.TEXT as DESCRIPTION
      from T_LOCATION_TYPE_VARIANTS LOCTV
      inner join T_TEXT_ITEMS TXT
        on TXT.ITM_ID = LOCTV.ITM_ID
        and TXT.TXTT_CODE = 'DESCR'
        and TXT.SEQ_NBR = 1
        and TXT.LANG_CODE = 'en') LOCTV
      on LOCTV.LOCT_CODE = LSD.LOCT_CODE
      and LOCTV.LOC_ID = COU.ID
      and LOCTV.LOCRT_CODE = 'WITHIN'
      and LOCTV.DESCRIPTION = LSD.LOC_TYPE_DESCRIPTION_EN
    group by LSD.COU_CODE,
      LSD.COU_START_DATE,
      LSD.LOCATION_NAME_EN,
      LSD.MSRP_CODE,
      LSD.HLEVEL,
      LSD.LOCT_CODE,
      LSD.LOC_TYPE_DESCRIPTION_EN,
      LSD.LOC_START_DATE,
      LSD.LOC_END_DATE,
      LSD.LOCR_START_DATE,
      LSD.LOCR_END_DATE,
      LSD.COU_CODE_PREV,
      LSD.COU_START_DATE_PREV,
      COU.ID
    order by COU_CODE_PREV nulls first, COU_START_DATE_PREV, COU_CODE, COU_START_DATE)
  loop
    P_UTILITY.TRACE_POINT('Trace1', rSDIV.COU_CODE || '~' ||
      to_char(rSDIV.COU_START_DATE, 'YYYY-MM-DD') || '~' ||
      rSDIV.LOCATION_NAME_EN || '~' || rSDIV.LOC_TYPE_DESCRIPTION_EN || '~' ||
      to_char(rSDIV.LOC_START_DATE, 'YYYY-MM-DD') || '~' ||
      to_char(rSDIV.LOC_END_DATE, 'YYYY-MM-DD') || '~' ||
      to_char(rSDIV.LOCR_START_DATE, 'YYYY-MM-DD') || '~' ||
      to_char(rSDIV.LOCR_END_DATE, 'YYYY-MM-DD'));
  --
    if rSDIV.COU_ID is null
    then dbms_output.put_line('Country not found: ' || rSDIV.COU_CODE || '|' ||
                                to_char(rSDIV.COU_START_DATE, 'YYYY-MM-DD'));
    elsif rSDIV.LOCTV_COUNT > 1
    then dbms_output.put_line('Ambiguous location type variant: ' || rSDIV.COU_CODE || '|' ||
                                to_char(rSDIV.COU_START_DATE, 'YYYY-MM-DD') || '|' ||
                                rSDIV.LOCT_CODE || '|' || rSDIV.LOCATION_NAME_EN);
    else
      if rSDIV.COU_CODE_PREV is null
      then
        P_LOCATION.INSERT_LOCATION
         (nLOC_ID, 'en', rSDIV.LOCATION_NAME_EN, rSDIV.LOCT_CODE,
          pdSTART_DATE => rSDIV.LOC_START_DATE, pdEND_DATE => rSDIV.LOC_END_DATE);
        iCount1 := iCount1 + 1;
      --
        if rSDIV.MSRP_CODE is not null
        then
          P_LOCATION.INSERT_LOCATION_ATTRIBUTE(nLOC_ID, 'MSRPLOC', psCHAR_VALUE => rSDIV.MSRP_CODE);
        end if;
      --
        if rSDIV.LOCTV_ID is not null
        then
          nVERSION_NBR := 1;
          P_LOCATION.UPDATE_LOCATION(nLOC_ID, nVERSION_NBR, pnLOCTV_ID => rSDIV.LOCTV_ID);
        end if;
      --
        P_LOCATION.INSERT_LOCATION_RELATIONSHIP
         (rSDIV.COU_ID, nLOC_ID, 'WITHIN',
          pdSTART_DATE => rSDIV.LOCR_START_DATE, pdEND_DATE => rSDIV.LOCR_END_DATE);
        iCount2 := iCount2 + 1;
      else
        P_UTILITY.TRACE_POINT('Trace2', rSDIV.COU_CODE_PREV || '~' ||
          to_char(rSDIV.COU_START_DATE_PREV, 'YYYY-MM-DD') || '~' ||
          rSDIV.LOCATION_NAME_EN || '~' || rSDIV.LOC_TYPE_DESCRIPTION_EN || '~' ||
          to_char(rSDIV.LOC_START_DATE, 'YYYY-MM-DD') || '~' ||
          to_char(rSDIV.LOC_END_DATE, 'YYYY-MM-DD') || '~' ||
          to_char(rSDIV.LOCR_START_DATE, 'YYYY-MM-DD') || '~' ||
          to_char(rSDIV.LOCR_END_DATE, 'YYYY-MM-DD'));
      --
        select LOC.ID
        into nLOC_ID
        from T_LOCATION_ATTRIBUTES LOCA
        inner join T_LOCATIONS COU
          on COU.ID = LOCA.LOC_ID
        inner join T_LOCATION_RELATIONSHIPS LOCR
          on LOCR.LOC_ID_FROM = COU.ID
          and LOCR.LOCRT_CODE = 'WITHIN'
        inner join
         (select LOC.ID, LOC.LOCT_CODE, LOC.LOCTV_ID, TXT.TEXT as NAME
          from T_LOCATIONS LOC
          inner join T_TEXT_ITEMS TXT
            on TXT.ITM_ID = LOC.ITM_ID
            and TXT.TXTT_CODE = 'NAME'
            and TXT.SEQ_NBR = 1
            and TXT.LANG_CODE = 'en') LOC
          on LOC.ID = LOCR.LOC_ID_TO
        inner join
         (select LOCT.CODE, TXT.TEXT as DESCRIPTION
          from T_LOCATION_TYPES LOCT
          inner join T_TEXT_ITEMS TXT
            on TXT.ITM_ID = LOCT.ITM_ID
            and TXT.TXTT_CODE = 'DESCR'
            and TXT.SEQ_NBR = 1
            and TXT.LANG_CODE = 'en') LOCT
          on LOCT.CODE = LOC.LOCT_CODE
        left outer join
         (select LOCTV.ID, TXT.TEXT as DESCRIPTION
          from T_LOCATION_TYPE_VARIANTS LOCTV
          inner join T_TEXT_ITEMS TXT
            on TXT.ITM_ID = LOCTV.ITM_ID
            and TXT.TXTT_CODE = 'DESCR'
            and TXT.SEQ_NBR = 1
            and TXT.LANG_CODE = 'en') LOCTV
          on LOCTV.ID = LOC.LOCTV_ID
        where LOCA.LOCAT_CODE = 'HCRCC'
        and LOCA.CHAR_VALUE = rSDIV.COU_CODE_PREV
        and COU.LOCT_CODE = 'COUNTRY'
        and COU.START_DATE = rSDIV.COU_START_DATE_PREV
        and LOC.NAME = rSDIV.LOCATION_NAME_EN
        and nvl(LOCTV.DESCRIPTION, LOCT.DESCRIPTION) = rSDIV.LOC_TYPE_DESCRIPTION_EN;
      --
        P_LOCATION.INSERT_LOCATION_RELATIONSHIP
         (rSDIV.COU_ID, nLOC_ID, 'WITHIN',
          pdSTART_DATE => rSDIV.LOCR_START_DATE, pdEND_DATE => rSDIV.LOCR_END_DATE);
        iCount2 := iCount2 + 1;
      end if;
    end if;
  end loop;
--
  if iCount1 = 1
  then dbms_output.put_line('1 LOCATIONS record inserted');
  else dbms_output.put_line(to_char(iCount1) || ' LOCATIONS records inserted');
  end if;
--
  if iCount2 = 1
  then dbms_output.put_line('1 LOCATION_RELATIONSHIPS record inserted');
  else dbms_output.put_line(to_char(iCount2) || ' LOCATION_RELATIONSHIPS records inserted');
  end if;
end;
/
