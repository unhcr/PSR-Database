create or replace package body P_REFSCOUT_XML is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- CHARTBYASYLUM
-- ----------------------------------------
--
  function CHARTBYASYLUM
    return XMLType
  is
    xELEMENT XMLType;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.CHARTBYASYLUM');
  --
    with
      -- Definitions of selection criteria and aggregations for required Statistic Types
      Q_STATISTIC_TYPE_DEFINITIONS
       (STCT_CODE, DST_CODE, ORIENTATION, DISPLAY_SEQ, DISPLAY_NAME) as
       (select 'POCPOP'    STCT_CODE, 'REF' DST_CODE, 'A' ORIENTATION, 1  DISPLAY_SEQ, 'Refugees' DISPLAY_NAME from DUAL union all
        select 'POCASSIST' STCT_CODE, 'REF' DST_CODE, 'A' ORIENTATION, 2  DISPLAY_SEQ, 'Refugees Assisted' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'ROC' DST_CODE, 'A' ORIENTATION, 3  DISPLAY_SEQ, 'Pers. refugees-like' DISPLAY_NAME from DUAL union all
        select 'POCASSIST' STCT_CODE, 'ROC' DST_CODE, 'A' ORIENTATION, 4  DISPLAY_SEQ, 'Pers. refugees-like Assisted' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'REF' DST_CODE, 'A' ORIENTATION, 5  DISPLAY_SEQ, 'Refugees incl refugee-like' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'ROC' DST_CODE, 'A' ORIENTATION, 5  DISPLAY_SEQ, 'Refugees incl refugee-like' DISPLAY_NAME from DUAL union all
        select 'POCASSIST' STCT_CODE, 'REF' DST_CODE, 'A' ORIENTATION, 6  DISPLAY_SEQ, 'Refugees incl refugee-like Assist.' DISPLAY_NAME from DUAL union all
        select 'POCASSIST' STCT_CODE, 'ROC' DST_CODE, 'A' ORIENTATION, 6  DISPLAY_SEQ, 'Refugees incl refugee-like Assist.' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'ASY' DST_CODE, 'A' ORIENTATION, 7  DISPLAY_SEQ, 'Asylum Seekers' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'RTN' DST_CODE, 'A' ORIENTATION, 8  DISPLAY_SEQ, 'Returned Refugees' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'IDP' DST_CODE, 'A' ORIENTATION, 9  DISPLAY_SEQ, 'IDPs Prot. Assist. excl IDP-like' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'IOC' DST_CODE, 'A' ORIENTATION, 10 DISPLAY_SEQ, 'Pers. IDP-like' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'IDP' DST_CODE, 'A' ORIENTATION, 11 DISPLAY_SEQ, 'IDPs Prot. Assisted' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'IOC' DST_CODE, 'A' ORIENTATION, 11 DISPLAY_SEQ, 'IDPs Prot. Assisted' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'RDP' DST_CODE, 'A' ORIENTATION, 12 DISPLAY_SEQ, 'Returned IDPs' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'STA' DST_CODE, 'A' ORIENTATION, 13 DISPLAY_SEQ, 'Stateless excl stateless-like' DISPLAY_NAME from DUAL union all
        select ''          STCT_CODE, ''    DST_CODE, 'A' ORIENTATION, 14 DISPLAY_SEQ, 'Pers. Stateless-like' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'STA' DST_CODE, 'A' ORIENTATION, 15 DISPLAY_SEQ, 'Stateless persons' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'OOC' DST_CODE, 'A' ORIENTATION, 16 DISPLAY_SEQ, 'Various' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'REF' DST_CODE, 'A' ORIENTATION, 17 DISPLAY_SEQ, 'Tot. Pop. of Concern' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'ROC' DST_CODE, 'A' ORIENTATION, 17 DISPLAY_SEQ, 'Tot. Pop. of Concern' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'ASY' DST_CODE, 'A' ORIENTATION, 17 DISPLAY_SEQ, 'Tot. Pop. of Concern' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'RTN' DST_CODE, 'A' ORIENTATION, 17 DISPLAY_SEQ, 'Tot. Pop. of Concern' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'IDP' DST_CODE, 'A' ORIENTATION, 17 DISPLAY_SEQ, 'Tot. Pop. of Concern' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'IOC' DST_CODE, 'A' ORIENTATION, 17 DISPLAY_SEQ, 'Tot. Pop. of Concern' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'STA' DST_CODE, 'A' ORIENTATION, 17 DISPLAY_SEQ, 'Tot. Pop. of Concern' DISPLAY_NAME from DUAL),
      -- Statistics aggregated to Statistic Type, Country of Asylum and Origin
      Q_STATISTICS
       (DISPLAY_NAME, DISPLAY_SEQ, LOC_ID1, LOC_ID2, VALUE) as
       (select STD.DISPLAY_NAME, STD.DISPLAY_SEQ,
          decode(STD.ORIENTATION, 'A', STC.LOC_ID_COUNTRY, 'O', STC.LOC_ID_ORIGIN) LOC_ID1,
          decode(STD.ORIENTATION, 'A', STC.LOC_ID_ORIGIN, 'O', STC.LOC_ID_COUNTRY) LOC_ID2,
          nvl(sum(STC.VALUE), 0) VALUE
        from Q_STATISTIC_TYPE_DEFINITIONS STD
        left outer join
         (select STCT_CODE, LOC_ID_COUNTRY, LOC_ID_ORIGIN, DST_CODE,
            VALUE
          from T_STATISTICS
          where DST_CODE in ('REF', 'ROC', 'ASY', 'IDP', 'IOC', 'RDP', 'STA', 'OOC')
          union all
          select STCT_CODE, LOC_ID_COUNTRY, LOC_ID_ORIGIN, 'RTN' DST_CODE,
            greatest(nvl(RETURNEES, REPATRIATED), nvl(REPATRIATED, RETURNEES)) VALUE
          from
           (select STCT_CODE,
              LOC_ID_COUNTRY,
              LOC_ID_ORIGIN,
              sum(decode(DST_CODE, 'RET', VALUE)) RETURNEES,
              sum(decode(DST_CODE, 'RPT', VALUE)) REPATRIATED
            from T_STATISTICS
            where DST_CODE in ('RET', 'RPT')
            and STCT_CODE = 'POCPOP'
            group by STCT_CODE, LOC_ID_COUNTRY, LOC_ID_ORIGIN)) STC
          on STC.STCT_CODE = STD.STCT_CODE
          and STC.DST_CODE = STD.DST_CODE
        group by STD.DISPLAY_NAME, STD.DISPLAY_SEQ,
          decode(STD.ORIENTATION, 'A', STC.LOC_ID_COUNTRY, 'O', STC.LOC_ID_ORIGIN),
          decode(STD.ORIENTATION, 'A', STC.LOC_ID_ORIGIN, 'O', STC.LOC_ID_COUNTRY)),
      -- Statistics aggregated to Statistic Type and Country of Asylum
      Q_COUNTRY_STATISTICS
       (DISPLAY_NAME, DISPLAY_SEQ, LOC_ID, COUNTRY_NAME, VALUE, ELEMENT) as
       (select STC.DISPLAY_NAME, STC.DISPLAY_SEQ, COU.ID,
          nvl(COU.NAME, 'Various') COUNTRY_NAME,
          nvl(sum(STC.VALUE), 0) VALUE,
          xmlelement
           (name "country",
            xmlattributes
             (nvl(COU.ISO3166_ALPHA3_CODE, 'VAR') as "key",
              nvl(COU.NAME, 'Various') as "name",
              nvl(sum(STC.VALUE), 0) as "value",
              nvl(LOCA.CHAR_VALUE, 'Various') as "bureau")) ELEMENT
        from Q_STATISTICS STC
        left outer join COUNTRIES COU
          on COU.ID = STC.LOC_ID1
        left outer join LOCATION_RELATIONSHIPS LOCR
          on LOCR.LOC_ID_TO = COU.ID
          and LOCR.LOCRT_CODE = 'RESP'
        left outer join LOCATION_ATTRIBUTES LOCA
          on LOCA.LOC_ID = LOCR.LOC_ID_FROM
          and LOCA.LOCAT_CODE = 'HCRBC'
        group by STC.DISPLAY_NAME, STC.DISPLAY_SEQ, COU.ID, COU.NAME, COU.ISO3166_ALPHA3_CODE, LOCA.CHAR_VALUE),
      -- Statistics aggregated to Statistic Type and UN Region
      Q_REGION_STATISTICS
       (DISPLAY_NAME, DISPLAY_SEQ, LOC_ID, REGION_NAME, VALUE, ELEMENT) as
       (select STC.DISPLAY_NAME, STC.DISPLAY_SEQ, LOC.ID LOC_ID, LOC.NAME REGION_NAME, sum(STC.VALUE) VALUE,
          xmlelement
           (name "region",
            xmlattributes
             (nvl(LOC.NAME, 'Various') as "name",
              sum(STC.VALUE) as "value"),
            xmlagg(STC.ELEMENT order by STC.COUNTRY_NAME)) ELEMENT
        from Q_COUNTRY_STATISTICS STC
        left outer join LOCATION_RELATIONSHIPS LOCR
          on LOCR.LOC_ID_TO = STC.LOC_ID
          and LOCR.LOCRT_CODE = 'WITHIN'
        left outer join LOCATIONS LOC
          on LOC.ID = LOCR.LOC_ID_FROM
        group by STC.DISPLAY_NAME, STC.DISPLAY_SEQ, LOC.ID, LOC.NAME),
      -- Statistics aggregated to Statistic Type and UN Major Area
      Q_MAJORAREA_STATISTICS
       (DISPLAY_NAME, DISPLAY_SEQ, LOC_ID, MAJORAREA_NAME, VALUE, ELEMENT) as
       (select STC.DISPLAY_NAME, STC.DISPLAY_SEQ, LOC.ID LOC_ID, LOC.NAME MAJORAREA_NAME, sum(STC.VALUE) VALUE,
          xmlelement
           (name "majorarea",
            xmlattributes
             (nvl(LOC.NAME, 'Various') as "name",
              sum(STC.VALUE) as "value"),
            xmlagg(STC.ELEMENT order by STC.REGION_NAME)) ELEMENT
        from Q_REGION_STATISTICS STC
        left outer join LOCATION_RELATIONSHIPS LOCR
          on LOCR.LOC_ID_TO = STC.LOC_ID
          and LOCR.LOCRT_CODE = 'WITHIN'
        left outer join LOCATIONS LOC
          on LOC.ID = LOCR.LOC_ID_FROM
        group by STC.DISPLAY_NAME, STC.DISPLAY_SEQ, LOC.ID, LOC.NAME),
      -- Statistics aggregated to Statistic Type
      Q_WORLD_STATISTICS
       (DISPLAY_SEQ, ELEMENT) as
       (select DISPLAY_SEQ,
          xmlelement
           (name "serie",
            xmlattributes
             ('name' as "xField",
              'value' as "yField",
              DISPLAY_NAME as "displayName"),
            xmlelement
             (name "world",
              xmlattributes
               ('World' as "name",
                sum(VALUE) as "value"),
              xmlagg(ELEMENT order by MAJORAREA_NAME))) ELEMENT
        from Q_MAJORAREA_STATISTICS
        group by DISPLAY_NAME, DISPLAY_SEQ)
    --
    select xmlroot(xmlelement(name "root", xmlagg(ELEMENT order by DISPLAY_SEQ)), version '1.0')
    into xELEMENT
    from Q_WORLD_STATISTICS;
  --
    return xELEMENT;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end CHARTBYASYLUM;
--
-- ----------------------------------------
-- CHARTBYORIGIN
-- ----------------------------------------
--
  function CHARTBYORIGIN
    return XMLType
  is
    xELEMENT XMLType;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.CHARTBYORIGIN');
  --
    with
      -- Definitions of selection criteria and aggregations for required Statistic Types
      Q_STATISTIC_TYPE_DEFINITIONS
       (STCT_CODE, DST_CODE, ORIENTATION, DISPLAY_SEQ, DISPLAY_NAME) as
       (select 'POCPOP'    STCT_CODE, 'REF' DST_CODE, 'O' ORIENTATION, 1  DISPLAY_SEQ, 'Refugees' DISPLAY_NAME from DUAL union all
        select 'POCASSIST' STCT_CODE, 'REF' DST_CODE, 'O' ORIENTATION, 2  DISPLAY_SEQ, 'Refugees Assisted' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'ROC' DST_CODE, 'O' ORIENTATION, 3  DISPLAY_SEQ, 'Pers. refugees-like' DISPLAY_NAME from DUAL union all
        select 'POCASSIST' STCT_CODE, 'ROC' DST_CODE, 'O' ORIENTATION, 4  DISPLAY_SEQ, 'Pers. refugees-like Assisted' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'REF' DST_CODE, 'O' ORIENTATION, 5  DISPLAY_SEQ, 'Refugees incl refugee-like' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'ROC' DST_CODE, 'O' ORIENTATION, 5  DISPLAY_SEQ, 'Refugees incl refugee-like' DISPLAY_NAME from DUAL union all
        select 'POCASSIST' STCT_CODE, 'REF' DST_CODE, 'O' ORIENTATION, 6  DISPLAY_SEQ, 'Refugees incl refugee-like Assist.' DISPLAY_NAME from DUAL union all
        select 'POCASSIST' STCT_CODE, 'ROC' DST_CODE, 'O' ORIENTATION, 6  DISPLAY_SEQ, 'Refugees incl refugee-like Assist.' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'ASY' DST_CODE, 'O' ORIENTATION, 7  DISPLAY_SEQ, 'Asylum Seekers' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'RTN' DST_CODE, 'A' ORIENTATION, 8  DISPLAY_SEQ, 'Returned Refugees' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'IDP' DST_CODE, 'O' ORIENTATION, 9  DISPLAY_SEQ, 'IDPs Prot. Assist. excl IDP-like' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'IOC' DST_CODE, 'O' ORIENTATION, 10 DISPLAY_SEQ, 'Pers. IDP-like' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'IDP' DST_CODE, 'O' ORIENTATION, 11 DISPLAY_SEQ, 'IDPs Prot. Assisted' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'IOC' DST_CODE, 'O' ORIENTATION, 11 DISPLAY_SEQ, 'IDPs Prot. Assisted' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'RDP' DST_CODE, 'O' ORIENTATION, 12 DISPLAY_SEQ, 'Returned IDPs' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'STA' DST_CODE, 'O' ORIENTATION, 13 DISPLAY_SEQ, 'Stateless excl stateless-like' DISPLAY_NAME from DUAL union all
        select ''          STCT_CODE, ''    DST_CODE, 'O' ORIENTATION, 14 DISPLAY_SEQ, 'Pers. Stateless-like' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'STA' DST_CODE, 'O' ORIENTATION, 15 DISPLAY_SEQ, 'Stateless persons' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'OOC' DST_CODE, 'O' ORIENTATION, 16 DISPLAY_SEQ, 'Various' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'REF' DST_CODE, 'O' ORIENTATION, 17 DISPLAY_SEQ, 'Tot. Pop. of Concern' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'ROC' DST_CODE, 'O' ORIENTATION, 17 DISPLAY_SEQ, 'Tot. Pop. of Concern' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'ASY' DST_CODE, 'O' ORIENTATION, 17 DISPLAY_SEQ, 'Tot. Pop. of Concern' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'RTN' DST_CODE, 'A' ORIENTATION, 17 DISPLAY_SEQ, 'Tot. Pop. of Concern' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'IDP' DST_CODE, 'O' ORIENTATION, 17 DISPLAY_SEQ, 'Tot. Pop. of Concern' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'IOC' DST_CODE, 'O' ORIENTATION, 17 DISPLAY_SEQ, 'Tot. Pop. of Concern' DISPLAY_NAME from DUAL union all
        select 'POCPOP'    STCT_CODE, 'STA' DST_CODE, 'O' ORIENTATION, 17 DISPLAY_SEQ, 'Tot. Pop. of Concern' DISPLAY_NAME from DUAL),
      -- Statistics aggregated to Statistic Type, Country of Asylum and Origin
      Q_STATISTICS
       (DISPLAY_NAME, DISPLAY_SEQ, LOC_ID1, LOC_ID2, VALUE) as
       (select STD.DISPLAY_NAME, STD.DISPLAY_SEQ,
          decode(STD.ORIENTATION, 'A', STC.LOC_ID_COUNTRY, 'O', STC.LOC_ID_ORIGIN) LOC_ID1,
          decode(STD.ORIENTATION, 'A', STC.LOC_ID_ORIGIN, 'O', STC.LOC_ID_COUNTRY) LOC_ID2,
          nvl(sum(STC.VALUE), 0) VALUE
        from Q_STATISTIC_TYPE_DEFINITIONS STD
        left outer join
         (select STCT_CODE, LOC_ID_COUNTRY, LOC_ID_ORIGIN, DST_CODE,
            VALUE
          from T_STATISTICS
          where DST_CODE in ('REF', 'ROC', 'ASY', 'IDP', 'IOC', 'RDP', 'STA', 'OOC')
          union all
          select STCT_CODE, LOC_ID_COUNTRY, LOC_ID_ORIGIN, 'RTN' DST_CODE,
            greatest(nvl(RETURNEES, REPATRIATED), nvl(REPATRIATED, RETURNEES)) VALUE
          from
           (select STCT_CODE,
              LOC_ID_COUNTRY,
              LOC_ID_ORIGIN,
              sum(decode(DST_CODE, 'RET', VALUE)) RETURNEES,
              sum(decode(DST_CODE, 'RPT', VALUE)) REPATRIATED
            from T_STATISTICS
            where DST_CODE in ('RET', 'RPT')
            and STCT_CODE = 'POCPOP'
            group by STCT_CODE, LOC_ID_COUNTRY, LOC_ID_ORIGIN)) STC
          on STC.STCT_CODE = STD.STCT_CODE
          and STC.DST_CODE = STD.DST_CODE
        group by STD.DISPLAY_NAME, STD.DISPLAY_SEQ,
          decode(STD.ORIENTATION, 'A', STC.LOC_ID_COUNTRY, 'O', STC.LOC_ID_ORIGIN),
          decode(STD.ORIENTATION, 'A', STC.LOC_ID_ORIGIN, 'O', STC.LOC_ID_COUNTRY)),
      -- Statistics aggregated to Statistic Type and Country of Asylum
      Q_COUNTRY_STATISTICS
       (DISPLAY_NAME, DISPLAY_SEQ, LOC_ID, COUNTRY_NAME, VALUE, ELEMENT) as
       (select STC.DISPLAY_NAME, STC.DISPLAY_SEQ, COU.ID,
          nvl(COU.NAME, 'Various') COUNTRY_NAME,
          nvl(sum(STC.VALUE), 0) VALUE,
          xmlelement
           (name "country",
            xmlattributes
             (nvl(COU.ISO3166_ALPHA3_CODE, 'VAR') as "key",
              nvl(COU.NAME, 'Various') as "name",
              nvl(sum(STC.VALUE), 0) as "value",
              nvl(LOCA.CHAR_VALUE, 'Various') as "bureau")) ELEMENT
        from Q_STATISTICS STC
        left outer join COUNTRIES COU
          on COU.ID = STC.LOC_ID1
        left outer join LOCATION_RELATIONSHIPS LOCR
          on LOCR.LOC_ID_TO = COU.ID
          and LOCR.LOCRT_CODE = 'RESP'
        left outer join LOCATION_ATTRIBUTES LOCA
          on LOCA.LOC_ID = LOCR.LOC_ID_FROM
          and LOCA.LOCAT_CODE = 'HCRBC'
        group by STC.DISPLAY_NAME, STC.DISPLAY_SEQ, COU.ID, COU.NAME, COU.ISO3166_ALPHA3_CODE, LOCA.CHAR_VALUE),
      -- Statistics aggregated to Statistic Type and UN Region
      Q_REGION_STATISTICS
       (DISPLAY_NAME, DISPLAY_SEQ, LOC_ID, REGION_NAME, VALUE, ELEMENT) as
       (select STC.DISPLAY_NAME, STC.DISPLAY_SEQ, LOC.ID LOC_ID, LOC.NAME REGION_NAME, sum(STC.VALUE) VALUE,
          xmlelement
           (name "region",
            xmlattributes
             (nvl(LOC.NAME, 'Various') as "name",
              sum(STC.VALUE) as "value"),
            xmlagg(STC.ELEMENT order by STC.COUNTRY_NAME)) ELEMENT
        from Q_COUNTRY_STATISTICS STC
        left outer join LOCATION_RELATIONSHIPS LOCR
          on LOCR.LOC_ID_TO = STC.LOC_ID
          and LOCR.LOCRT_CODE = 'WITHIN'
        left outer join LOCATIONS LOC
          on LOC.ID = LOCR.LOC_ID_FROM
        group by STC.DISPLAY_NAME, STC.DISPLAY_SEQ, LOC.ID, LOC.NAME),
      -- Statistics aggregated to Statistic Type and UN Major Area
      Q_MAJORAREA_STATISTICS
       (DISPLAY_NAME, DISPLAY_SEQ, LOC_ID, MAJORAREA_NAME, VALUE, ELEMENT) as
       (select STC.DISPLAY_NAME, STC.DISPLAY_SEQ, LOC.ID LOC_ID, LOC.NAME MAJORAREA_NAME, sum(STC.VALUE) VALUE,
          xmlelement
           (name "majorarea",
            xmlattributes
             (nvl(LOC.NAME, 'Various') as "name",
              sum(STC.VALUE) as "value"),
            xmlagg(STC.ELEMENT order by STC.REGION_NAME)) ELEMENT
        from Q_REGION_STATISTICS STC
        left outer join LOCATION_RELATIONSHIPS LOCR
          on LOCR.LOC_ID_TO = STC.LOC_ID
          and LOCR.LOCRT_CODE = 'WITHIN'
        left outer join LOCATIONS LOC
          on LOC.ID = LOCR.LOC_ID_FROM
        group by STC.DISPLAY_NAME, STC.DISPLAY_SEQ, LOC.ID, LOC.NAME),
      -- Statistics aggregated to Statistic Type
      Q_WORLD_STATISTICS
       (DISPLAY_SEQ, ELEMENT) as
       (select DISPLAY_SEQ,
          xmlelement
           (name "serie",
            xmlattributes
             ('name' as "xField",
              'value' as "yField",
              DISPLAY_NAME as "displayName"),
            xmlelement
             (name "world",
              xmlattributes
               ('World' as "name",
                sum(VALUE) as "value"),
              xmlagg(ELEMENT order by MAJORAREA_NAME))) ELEMENT
        from Q_MAJORAREA_STATISTICS
        group by DISPLAY_NAME, DISPLAY_SEQ)
    --
    select xmlroot(xmlelement(name "root", xmlagg(ELEMENT order by DISPLAY_SEQ)), version '1.0')
    into xELEMENT
    from Q_WORLD_STATISTICS;
  --
    return xELEMENT;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end CHARTBYORIGIN;
--
-- ----------------------------------------
-- STATSBYASYLUM
-- ----------------------------------------
--
  function STATSBYASYLUM
    return XMLType
  is
    xELEMENT XMLType;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.STATSBYASYLUM');
  --
    select
      xmlroot
       (xmlelement
         (name "root",
          xmlagg
           (xmlelement
             (name "data",
              xmlattributes
               ('World' as "World",
                LOC2.NAME as "Area",
                LOC1.NAME as "Region",
                STC.LOC_NAME_COUNTRY as "Country",
                LOCA.CHAR_VALUE as "Operation",
                to_char(STC.REFUGEES) as "Refugees",
                to_char(STC.REFUGEES_ASSISTED) as "RefugeesAssisted",
                to_char(STC.REFUGEE_LIKE) as "RefugeesLike",
                to_char(STC.REFUGEE_LIKE_ASSISTED) as "RefugeesLikeAssisted",
                to_char(STC.REFUGEES + STC.REFUGEE_LIKE) as "RefugeesPop",
                to_char(STC.REFUGEES_ASSISTED + STC.REFUGEE_LIKE_ASSISTED) as "RefugeesPopAssisted",
                to_char(STC.ASYLUM_SEEKERS) as "AsylumSeekers",
                to_char(STC.RETURNED) as "ReturnedRefugees",
                to_char(STC.IDPS) as "IDPS",
                to_char(STC.IDP_LIKE) as "IDPLike",
                to_char(STC.IDPS_ASSISTED) as "IDPSAssisted",
                to_char(STC.RETURNED_IDPS) as "ReturnedIDP",
                to_char(STC.STATELESS) as "Stateless",
                '0' as "StatelessLike",
                to_char(STC.STATELESS) as "StatelessPop",
                to_char(STC.OTHERS) as "Various",
                to_char(STC.REFUGEES + STC.REFUGEE_LIKE + STC.ASYLUM_SEEKERS + STC.RETURNED +
                          STC.IDPS + STC.IDP_LIKE + STC.RETURNED_IDPS + STC.STATELESS + STC.OTHERS)
                  as "Population",
                '' as "Notes"))
            order by LOC2.NAME, LOC1.NAME, STC.LOC_NAME_COUNTRY)),
        version '1.0') ELEMENT
    into xELEMENT
    from
     (select LOC_ID_COUNTRY, LOC_NAME_COUNTRY,
        sum(nvl(REFUGEES, 0)) as REFUGEES,
        sum(nvl(REFUGEES_ASSISTED, 0)) as REFUGEES_ASSISTED,
        sum(nvl(REFUGEE_LIKE, 0)) as REFUGEE_LIKE,
        sum(nvl(REFUGEE_LIKE_ASSISTED, 0)) as REFUGEE_LIKE_ASSISTED,
        sum(nvl(ASYLUM_SEEKERS, 0)) as ASYLUM_SEEKERS,
        sum(nvl(RETURNED, 0)) as RETURNED,
        sum(nvl(IDPS, 0)) as IDPS,
        sum(nvl(IDP_LIKE, 0)) as IDP_LIKE,
        sum(nvl(IDPS, 0) + nvl(IDP_LIKE, 0)) as IDPS_ASSISTED,
        sum(nvl(RETURNED_IDPS, 0)) as RETURNED_IDPS,
        sum(nvl(STATELESS, 0)) as STATELESS,
        sum(nvl(OTHERS, 0)) as OTHERS
      from
       (select LOC_ID_COUNTRY, LOC_NAME_COUNTRY,
          REFUGEES,
          REFUGEES_ASSISTED,
          REFUGEE_LIKE,
          REFUGEE_LIKE_ASSISTED,
          ASYLUM_SEEKERS,
          to_number(null) as RETURNED,
          IDPS,
          IDP_LIKE,
          RETURNED_IDPS,
          STATELESS,
          OTHERS
        from COUNTRY_DISPLACED_STATISTICS
        union all
        select LOC_ID_ORIGIN as LOC_ID_COUNTRY, LOC_NAME_ORIGIN as LOC_NAME_COUNTRY,
          to_number(null) as REFUGEES,
          to_number(null) as REFUGEES_ASSISTED,
          to_number(null) as REFUGEE_LIKE,
          to_number(null) as REFUGEE_LIKE_ASSISTED,
          to_number(null) as ASYLUM_SEEKERS,
          RETURNED,
          to_number(null) as IDPS,
          to_number(null) as IDP_LIKE,
          to_number(null) as RETURNED_IDPS,
          to_number(null) as STATELESS,
          to_number(null) as OTHERS
        from COUNTRY_RETURNED_STATISTICS)
      group by LOC_ID_COUNTRY, LOC_NAME_COUNTRY) STC
    join LOCATION_RELATIONSHIPS LOCR1
      on LOCR1.LOC_ID_TO = STC.LOC_ID_COUNTRY
      and LOCR1.LOCRT_CODE = 'WITHIN'
    join LOCATIONS LOC1  -- UN Region
      on LOC1.ID = LOCR1.LOC_ID_FROM
    join LOCATION_RELATIONSHIPS LOCR2
      on LOCR2.LOC_ID_TO = LOC1.ID
      and LOCR2.LOCRT_CODE = 'WITHIN'
    join LOCATIONS LOC2  -- UN Major Area
      on LOC2.ID = LOCR2.LOC_ID_FROM
    join LOCATION_RELATIONSHIPS LOCR3
      on LOCR3.LOC_ID_TO = STC.LOC_ID_COUNTRY
      and LOCR3.LOCRT_CODE = 'RESP'
    join LOCATIONS LOC3  -- UNHCR Bureau / Regional Operation
      on LOC3.ID = LOCR3.LOC_ID_FROM
    join LOCATION_ATTRIBUTES LOCA
      on LOCA.LOC_ID = LOC3.ID
      and LOCA.LOCAT_CODE = 'HCRBC';
  --
    return xELEMENT;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end STATSBYASYLUM;
/*
--
-- ----------------------------------------
-- STATSBYFLOW
-- ----------------------------------------
--
  function STATSBYFLOW
    return taText pipelined
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.STATSBYFLOW');
  --
    pipe row('<?xml version="1.0" encoding="iso-8859-1"?>');
    pipe row('<root>');
  --
    for rXML in
     (select
        xmlelement
         (name "data",
          xmlattributes
           ('World' as "World",
            LOC2.NAME as "Area",
            LOC1.NAME as "Region",
            COU.NAME as "Country",
            LOCA.CHAR_VALUE as "Operation",
            to_char(sum(decode(STC.DST_CODE, 'REF', STC.VALUE, 0))) as "Refugees",
            to_char(sum(decode(STC.DST_CODE, 'REF', STC.VALUE, 0))) as "RefugeesAssisted",
            to_char(sum(decode(STC.DST_CODE, 'ROC', STC.VALUE, 0))) as "RefugeesLike",
            to_char(sum(decode(STC.DST_CODE, 'ROC', STC.VALUE, 0))) as "RefugeesLikeAssisted",
            to_char(sum(decode(STC.DST_CODE, 'REF', STC.VALUE, 'ROC', STC.VALUE, 0))) as "RefugeesPop",
            to_char(sum(decode(STC.DST_CODE, 'REF', STC.VALUE, 'ROC', STC.VALUE, 0))) as "RefugeesPopAssisted",
            to_char(sum(decode(STC.DST_CODE, 'ASY', STC.VALUE, 0))) as "AsylumSeekers",
            to_char(sum(decode(STC.DST_CODE, 'RET', STC.VALUE, 0))) as "ReturnedRefugees",
            to_char(sum(decode(STC.DST_CODE, 'IDP', STC.VALUE, 0))) as "IDPS",
            to_char(sum(decode(STC.DST_CODE, 'IOC', STC.VALUE, 0))) as "IDPLike",
            to_char(sum(decode(STC.DST_CODE, 'IDP', STC.VALUE, 0))) as "IDPSAssisted",
            to_char(sum(decode(STC.DST_CODE, 'RDP', STC.VALUE, 0))) as "ReturnedIDP",
            to_char(sum(decode(STC.DST_CODE, 'STA', STC.VALUE, 0))) as "Stateless",
            to_char(sum(decode(STC.DST_CODE, 'STA', STC.VALUE, 0))) as "StatelessLike",
            to_char(sum(decode(STC.DST_CODE, 'STA', STC.VALUE, 0))) as "StatelessPop",
            to_char(sum(decode(STC.DST_CODE, 'OOC', STC.VALUE, 0))) as "Various",
            to_char(sum(STC.VALUE)) as "Population",
            '' as "Notes")) ELEMENT
      from COUNTRY_DISPLACED_STATISTICS STC
      join LOCATION_RELATIONSHIPS LOCR1
        on LOCR1.LOC_ID_TO = STC.LOC_ID_COUNTRY
        and LOCR1.LOCRT_CODE = 'WITHIN'
      join LOCATIONS LOC1  -- UN Subregion
        on LOC1.ID = LOCR1.LOC_ID_FROM
      join LOCATION_RELATIONSHIPS LOCR2
        on LOCR2.LOC_ID_TO = LOC1.ID
        and LOCR2.LOCRT_CODE = 'WITHIN'
      join LOCATIONS LOC2  -- UN Region
        on LOC2.ID = LOCR2.LOC_ID_FROM
      join LOCATION_RELATIONSHIPS LOCR3
        on LOCR3.LOC_ID_TO = COU.ID
        and LOCR3.LOCRT_CODE = 'RESP'
      join LOCATIONS LOC3  -- UNHCR Bureau / Regional Operation
        on LOC3.ID = LOCR3.LOC_ID_FROM
      join LOCATION_ATTRIBUTES LOCA
        on LOCA.LOC_ID = LOC3.ID
        and LOCA.LOCAT_CODE = 'HCRBC'
      order by LOC2.NAME, LOC1.NAME, COU.NAME)
    loop
      pipe row(rXML.ELEMENT.getStringVal);
    end loop;
  --
    pipe row('</root>');
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end STATSBYFLOW;
*/
--
-- ----------------------------------------
-- STATSBYORIGIN
-- ----------------------------------------
--
  function STATSBYORIGIN
    return XMLType
  is
    xELEMENT XMLType;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.STATSBYORIGIN');
  --
    select
      xmlroot
       (xmlelement
         (name "root",
          xmlagg
           (xmlelement
             (name "data",
              xmlattributes
               ('World' as "World",
                nvl(decode(LOCA2.CHAR_VALUE, 'TIB', 'Asia', 'CHY', 'Europe', 'KOS', 'Europe', 'STA', 'Stateless', LOC2.NAME), 'Various') as "Area",
                nvl(decode(LOCA2.CHAR_VALUE, 'TIB', 'Various', 'CHY', 'Eastern Europe', 'KOS', 'Southern Europe', 'STA', 'Stateless', LOC1.NAME), 'Various') as "Region",
                nvl(decode(LOCA2.CHAR_VALUE, 'CHY', 'Russian Federation', 'KOS', 'Serbia', 'STA', 'Stateless', nvl(STC.LOC_NAME_ORIGIN, LOC4.NAME)), 'Various') as "Country",
                nvl(decode(LOCA2.CHAR_VALUE, 'TIB', 'RBAP', 'CHY', 'RBE', 'KOS', 'RBE', 'STA', 'Stateless', LOCA1.CHAR_VALUE), 'Various') as "Operation",
                to_char(STC.REFUGEES) as "Refugees",
                to_char(STC.REFUGEES_ASSISTED) as "RefugeesAssisted",
                to_char(STC.REFUGEE_LIKE) as "RefugeesLike",
                to_char(STC.REFUGEE_LIKE_ASSISTED) as "RefugeesLikeAssisted",
                to_char(STC.REFUGEES + STC.REFUGEE_LIKE) as "RefugeesPop",
                to_char(STC.REFUGEES_ASSISTED + STC.REFUGEE_LIKE_ASSISTED) as "RefugeesPopAssisted",
                to_char(STC.ASYLUM_SEEKERS) as "AsylumSeekers",
                to_char(STC.RETURNED) as "ReturnedRefugees",
                to_char(STC.IDPS) as "IDPS",
                to_char(STC.IDP_LIKE) as "IDPLike",
                to_char(STC.IDPS_ASSISTED) as "IDPSAssisted",
                to_char(STC.RETURNED_IDPS) as "ReturnedIDP",
                to_char(STC.STATELESS) as "Stateless",
                '0' as "StatelessLike",
                to_char(STC.STATELESS) as "StatelessPop",
                to_char(STC.OTHERS) as "Various",
                to_char(STC.REFUGEES + STC.REFUGEE_LIKE + STC.ASYLUM_SEEKERS + STC.RETURNED +
                          STC.IDPS + STC.IDP_LIKE + STC.RETURNED_IDPS + STC.STATELESS + STC.OTHERS)
                  as "Population",
                '' as "Notes"))
            order by LOC2.NAME, LOC1.NAME, STC.LOC_NAME_ORIGIN)),
        version '1.0') ELEMENT
    into xELEMENT
    from
     (select LOC_ID_ORIGIN, LOC_NAME_ORIGIN,
        sum(nvl(REFUGEES, 0)) as REFUGEES,
        sum(nvl(REFUGEES_ASSISTED, 0)) as REFUGEES_ASSISTED,
        sum(nvl(REFUGEE_LIKE, 0)) as REFUGEE_LIKE,
        sum(nvl(REFUGEE_LIKE_ASSISTED, 0)) as REFUGEE_LIKE_ASSISTED,
        sum(nvl(ASYLUM_SEEKERS, 0)) as ASYLUM_SEEKERS,
        sum(nvl(RETURNED, 0)) as RETURNED,
        sum(nvl(IDPS, 0)) as IDPS,
        sum(nvl(IDP_LIKE, 0)) as IDP_LIKE,
        sum(nvl(IDPS, 0) + nvl(IDP_LIKE, 0)) as IDPS_ASSISTED,
        sum(nvl(RETURNED_IDPS, 0)) as RETURNED_IDPS,
        sum(nvl(STATELESS, 0)) as STATELESS,
        sum(nvl(OTHERS, 0)) as OTHERS
      from
       (select LOC_ID_ORIGIN, LOC_NAME_ORIGIN,
          REFUGEES,
          REFUGEES_ASSISTED,
          REFUGEE_LIKE,
          REFUGEE_LIKE_ASSISTED,
          ASYLUM_SEEKERS,
          to_number(null) as RETURNED,
          IDPS,
          IDP_LIKE,
          RETURNED_IDPS,
          STATELESS,
          OTHERS
        from COUNTRY_DISPLACED_STATISTICS
        union all
        select LOC_ID_ORIGIN, LOC_NAME_ORIGIN,
          to_number(null) as REFUGEES,
          to_number(null) as REFUGEES_ASSISTED,
          to_number(null) as REFUGEE_LIKE,
          to_number(null) as REFUGEE_LIKE_ASSISTED,
          to_number(null) as ASYLUM_SEEKERS,
          RETURNED,
          to_number(null) as IDPS,
          to_number(null) as IDP_LIKE,
          to_number(null) as RETURNED_IDPS,
          to_number(null) as STATELESS,
          to_number(null) as OTHERS
        from COUNTRY_RETURNED_STATISTICS)
      group by LOC_ID_ORIGIN, LOC_NAME_ORIGIN) STC
    left outer join LOCATION_RELATIONSHIPS LOCR1
      on LOCR1.LOC_ID_TO = STC.LOC_ID_ORIGIN
      and LOCR1.LOCRT_CODE = 'WITHIN'
    left outer join LOCATIONS LOC1  -- UN Region
      on LOC1.ID = LOCR1.LOC_ID_FROM
    left outer join LOCATION_RELATIONSHIPS LOCR2
      on LOCR2.LOC_ID_TO = LOC1.ID
      and LOCR2.LOCRT_CODE = 'WITHIN'
    left outer join LOCATIONS LOC2  -- UN Major Area
      on LOC2.ID = LOCR2.LOC_ID_FROM
    left outer join LOCATION_RELATIONSHIPS LOCR3
      on LOCR3.LOC_ID_TO = STC.LOC_ID_ORIGIN
      and LOCR3.LOCRT_CODE = 'RESP'
    left outer join LOCATIONS LOC3  -- UNHCR Bureau / Regional Operation
      on LOC3.ID = LOCR3.LOC_ID_FROM
    left outer join LOCATION_ATTRIBUTES LOCA1
      on LOCA1.LOC_ID = LOC3.ID
      and LOCA1.LOCAT_CODE = 'HCRBC'
    left outer join LOCATIONS LOC4  -- Other origins
      on LOC4.ID = STC.LOC_ID_ORIGIN
      and LOC4.LOCT_CODE = 'OTHORIGIN'
    left outer join LOCATION_ATTRIBUTES LOCA2
      on LOCA2.LOC_ID = LOC4.ID
      and LOCA2.LOCAT_CODE = 'HCRCC';
  --
    return xELEMENT;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end STATSBYORIGIN;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sModule != $$PLSQL_UNIT
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'Module name mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
  if sComponent != 'RSX'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 3, 'Component code mismatch');
  end if;
--
end P_REFSCOUT_XML;
/

show errors
