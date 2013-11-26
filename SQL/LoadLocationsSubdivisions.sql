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
      nvl(LSD.ACTIVE_FLAG, 'Y') as ACTIVE_FLAG,
      nvl(LSD.LOCR_START_DATE, P_BASE.MIN_DATE) as LOCR_START_DATE,
      nvl(LSD.LOCR_END_DATE, P_BASE.MAX_DATE) as LOCR_END_DATE,
      LSD.COU_CODE_PREV,
      nvl(LSD.COU_START_DATE_PREV, P_BASE.MIN_DATE) as COU_START_DATE_PREV,
      COU.ID as COU_ID,
      LID.ID,
      count(distinct LOCTV.ID) as LOCTV_COUNT,
      max(LOCTV.ID) as LOCTV_ID
    from S_LOCATION_SUBDIVISIONS LSD
    left outer join
     (select LOC.ID, LOC.START_DATE,
        LOCA1.CHAR_VALUE as ISO_COUNTRY_CODE, LOCA2.CHAR_VALUE as UNHCR_COUNTRY_CODE
      from T_LOCATIONS LOC
      inner join T_LOCATION_ATTRIBUTES LOCA1
        on LOCA1.LOC_ID = LOC.ID
        and LOCA1.LOCAT_CODE = 'ISO3166A3'
      inner join T_LOCATION_ATTRIBUTES LOCA2
        on LOCA2.LOC_ID = LOC.ID
        and LOCA2.LOCAT_CODE = 'HCRCC') COU
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
    left outer join S_LOCATION_IDS LID
      on LID.LOCT_CODE = LSD.LOCT_CODE
      and (LID.LOCTV_DESCRIPTION_EN = LOCTV.DESCRIPTION
        or (LID.LOCTV_DESCRIPTION_EN is null
          and LOCTV.DESCRIPTION is null))
      and LID.NAME_EN = LSD.LOCATION_NAME_EN
      and LID.ISO_COUNTRY_CODE = COU.ISO_COUNTRY_CODE
      and nvl(LID.START_DATE, P_BASE.MIN_DATE) = COU.START_DATE
    group by LSD.COU_CODE,
      LSD.COU_START_DATE,
      LSD.LOCATION_NAME_EN,
      LSD.MSRP_CODE,
      LSD.HLEVEL,
      LSD.LOCT_CODE,
      LSD.LOC_TYPE_DESCRIPTION_EN,
      LSD.LOC_START_DATE,
      LSD.LOC_END_DATE,
      LSD.ACTIVE_FLAG,
      LSD.LOCR_START_DATE,
      LSD.LOCR_END_DATE,
      LSD.COU_CODE_PREV,
      LSD.COU_START_DATE_PREV,
      COU.ID,
      LID.ID
    order by COU_CODE_PREV nulls first, COU_START_DATE_PREV nulls first, COU_CODE, COU_START_DATE)
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
      --
      -- This is the first or only country in which this location occurs - create the loction and
      --  its attributes and location type variants along with its 'WITHIN' relationship to its
      --  country.
      --
        iCount1 := iCount1 + 1;
        if rSDIV.ID is null
        then
          P_LOCATION.INSERT_LOCATION
           (nLOC_ID, 'en', rSDIV.LOCATION_NAME_EN, rSDIV.LOCT_CODE,
            pdSTART_DATE => rSDIV.LOC_START_DATE, pdEND_DATE => rSDIV.LOC_END_DATE,
            psACTIVE_FLAG => rSDIV.ACTIVE_FLAG);
        else
          P_LOCATION.INSERT_LOCATION_WITH_ID
           (rSDIV.ID, 'en', rSDIV.LOCATION_NAME_EN, rSDIV.LOCT_CODE,
            pdSTART_DATE => rSDIV.LOC_START_DATE, pdEND_DATE => rSDIV.LOC_END_DATE,
            psACTIVE_FLAG => rSDIV.ACTIVE_FLAG);
          nLOC_ID := rSDIV.ID;
        end if;
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
      --
      -- This location exists in a previous country - use the existing location and link it to this
      --  country with a 'WITHIN' relationship.
      --
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
-- Link locations in an administrative hierarchy where defined.
--
  for rSDIV in
   (with Q_LOCATION as
     (select LOCR.LOC_ID_FROM as COU_ID, LOC.LOCATION_NAME_EN,
        nvl(LOCTV.LOCTV_DESCRIPTION_EN, LOCT.LOC_TYPE_DESCRIPTION_EN) as LOC_TYPE_DESCRIPTION_EN,
        LOC.ID, LOC.START_DATE, LOC.END_DATE
      from T_LOCATION_RELATIONSHIPS LOCR
      inner join
       (select LOC.ID, LOC.LOCT_CODE, LOC.LOCTV_ID, LOC.START_DATE, LOC.END_DATE,
          TXT.TEXT as LOCATION_NAME_EN
        from T_LOCATIONS LOC
        inner join T_TEXT_ITEMS TXT
          on TXT.ITM_ID = LOC.ITM_ID
          and TXT.TXTT_CODE = 'NAME'
          and TXT.SEQ_NBR = 1
          and TXT.LANG_CODE = 'en') LOC
        on LOC.ID = LOCR.LOC_ID_TO
      inner join
       (select LOCT.CODE, TXT.TEXT as LOC_TYPE_DESCRIPTION_EN
        from LOCATION_TYPES LOCT
        inner join T_TEXT_ITEMS TXT
          on TXT.ITM_ID = LOCT.ITM_ID
          and TXT.TXTT_CODE = 'DESCR'
          and TXT.SEQ_NBR = 1
          and TXT.LANG_CODE = 'en') LOCT
        on LOCT.CODE = LOC.LOCT_CODE
      left outer join
       (select LOCTV.ID, TXT.TEXT as LOCTV_DESCRIPTION_EN
        from T_LOCATION_TYPE_VARIANTS LOCTV
        inner join T_TEXT_ITEMS TXT
          on TXT.ITM_ID = LOCTV.ITM_ID
          and TXT.TXTT_CODE = 'DESCR'
          and TXT.SEQ_NBR = 1
          and TXT.LANG_CODE = 'en') LOCTV
        on LOCTV.ID = LOC.LOCTV_ID
      where LOCR.LOCRT_CODE = 'WITHIN')
  --
    select LOC1.ID as LOC_ID_TO, LOC2.ID as LOC_ID_FROM,
      nvl(LSD.LOCR_START_DATE, greatest(LOC1.START_DATE, LOC2.START_DATE)) as LOCR_START_DATE,
      nvl(LSD.LOCR_END_DATE, greatest(LOC1.END_DATE, LOC2.END_DATE)) as LOCR_END_DATE
    from S_LOCATION_SUBDIVISIONS LSD
    inner join
     (select LOCA.CHAR_VALUE as COU_CODE, COU.ID
      from T_LOCATIONS COU
      inner join T_LOCATION_ATTRIBUTES LOCA
        on LOCA.LOC_ID = COU.ID
        and LOCA.LOCAT_CODE = 'HCRCC'
      where COU.LOCT_CODE = 'COUNTRY') COU
      on COU.COU_CODE = LSD.COU_CODE
    inner join Q_LOCATION LOC1
      on LOC1.COU_ID = COU.ID
      and LOC1.LOCATION_NAME_EN = LSD.LOCATION_NAME_EN
      and LOC1.LOC_TYPE_DESCRIPTION_EN = LSD.LOC_TYPE_DESCRIPTION_EN
    left outer join Q_LOCATION LOC2
      on LOC2.COU_ID = COU.ID
      and LOC2.LOCATION_NAME_EN = trim(regexp_replace(LSD.LOCATION_NAME_FROM, ':.*$', ''))
      and (rtrim(ltrim(regexp_substr(LSD.LOCATION_NAME_FROM, ':.*$'), ': ')) is null
        or LOC2.LOC_TYPE_DESCRIPTION_EN = rtrim(ltrim(regexp_substr(LSD.LOCATION_NAME_FROM, ':.*$'), ': ')))
    where LSD.LOCATION_NAME_FROM is not null
    order by LSD.COU_CODE, LSD.LOCATION_NAME_FROM)
  loop
    P_LOCATION.INSERT_LOCATION_RELATIONSHIP
     (rSDIV.LOC_ID_FROM, rSDIV.LOC_ID_TO, 'ADMIN',
      pdSTART_DATE => rSDIV.LOCR_START_DATE, pdEND_DATE => rSDIV.LOCR_END_DATE);
    iCount2 := iCount2 + 1;
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
