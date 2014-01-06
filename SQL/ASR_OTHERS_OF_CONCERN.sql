--
-- ASR_OTHERS_OF_CONCERN - Others of concern
--
create or replace view ASR_OTHERS_OF_CONCERN as
with Q_ASR_OTHERS_OF_CONCERN as
 (select ASR_YEAR, LOC_ID_ASYLUM_COUNTRY, LOC_ID_ORIGIN_COUNTRY, STG_ID_PRIMARY,
    OOCPOP_START_VALUE,
    OOCPOP_START_STC_ID, OOCPOP_START_VERSION_NBR, OOCPOP_START_ITM_ID,
    OOCPOP_AH_START_VALUE,
    OOCPOP_AH_START_STC_ID, OOCPOP_AH_START_VERSION_NBR, OOCPOP_AH_START_ITM_ID,
    OOCARR_VALUE,
    OOCARR_STC_ID, OOCARR_VERSION_NBR, OOCARR_ITM_ID,
    OOCOTHINC_VALUE,
    OOCOTHINC_STC_ID, OOCOTHINC_VERSION_NBR, OOCOTHINC_ITM_ID,
    OOCRTN_VALUE,
    OOCRTN_STC_ID, OOCRTN_VERSION_NBR, OOCRTN_ITM_ID,
    OOCOTHDEC_VALUE,
    OOCOTHDEC_STC_ID, OOCOTHDEC_VERSION_NBR, OOCOTHDEC_ITM_ID,
    OOCPOP_END_VALUE,
    OOCPOP_END_STC_ID, OOCPOP_END_VERSION_NBR, OOCPOP_END_ITM_ID,
    OOCPOP_AH_END_VALUE,
    OOCPOP_AH_END_STC_ID, OOCPOP_AH_END_VERSION_NBR, OOCPOP_AH_END_ITM_ID
  from
   (select extract(year from STC.START_DATE) as ASR_YEAR,
      STC.LOC_ID_ASYLUM_COUNTRY, STC.LOC_ID_ORIGIN_COUNTRY, STC.STG_ID_PRIMARY,
      replace(STC.STCT_CODE, '-', '_') ||
        case
          when extract(day from STC.END_DATE) = 2 then '_START'
          when extract(day from STC.START_DATE) = 31 then '_END'
        end as COLUMN_NAME,
      STC.VALUE,
      STC.ID as STC_ID,
      STC.VERSION_NBR,
      STC.ITM_ID
    from T_STATISTIC_TYPES_IN_GROUPS STTIG
    inner join T_STATISTICS STC
      on STC.STCT_CODE = STTIG.STCT_CODE
    where STTIG.STTG_CODE = 'OOC')
  pivot
   (sum(VALUE) as VALUE, max(STC_ID) as STC_ID, max(VERSION_NBR) as VERSION_NBR,
      max(ITM_ID) as ITM_ID
    for COLUMN_NAME
    in ('OOCPOP_START' as OOCPOP_START,
        'OOCPOP_AH_START' as OOCPOP_AH_START,
        'OOCARR' as OOCARR,
        'OOCOTHINC' as OOCOTHINC,
        'OOCRTN' as OOCRTN,
        'OOCOTHDEC' as OOCOTHDEC,
        'OOCPOP_END' as OOCPOP_END,
        'OOCPOP_AH_END' as OOCPOP_AH_END))),
--
Q_LOCATIONS as
 (select ID, NAME
  from
   (select LOC.ID, TXT.TEXT as NAME,
      row_number() over
       (partition by LOC.ID
        order by LANG.ACTIVE_FLAG desc, nvl(ULP.PREF_SEQ, LANG.DISPLAY_SEQ + 1e5)) as RANK
    from T_LOCATIONS LOC
    inner join T_TEXT_ITEMS TXT
      on TXT.ITM_ID = LOC.ITM_ID
      and TXT.TXTT_CODE = 'NAME'
      and TXT.SEQ_NBR = 1
    inner join T_LANGUAGES LANG
      on LANG.CODE = TXT.LANG_CODE
    left outer join T_USER_LANGUAGE_PREFERENCES ULP
      on ULP.LANG_CODE = TXT.LANG_CODE
      and ULP.USERID = sys_context('PSR', 'USERID'))
  where RANK = 1),
--
Q_STATISTIC_GROUPS as
 (select ID, VERSION_NBR, ITM_ID, UPDATE_TIMESTAMP, UPDATE_USERID, POPULATION_SUBGROUP_NAME
  from
   (select STG.ID, STG.VERSION_NBR, STG.ITM_ID, STG.UPDATE_TIMESTAMP, STG.UPDATE_USERID,
      TXT.TEXT as POPULATION_SUBGROUP_NAME,
      row_number() over
       (partition by STG.ID
        order by LANG.ACTIVE_FLAG desc, nvl(ULP.PREF_SEQ, LANG.DISPLAY_SEQ + 1e5)) as RANK
    from T_STATISTIC_GROUPS STG
    inner join T_TEXT_ITEMS TXT
      on TXT.ITM_ID = STG.ITM_ID
      and TXT.TXTT_CODE = 'PSGRNAME'
      and TXT.SEQ_NBR = 1
    inner join T_LANGUAGES LANG
      on LANG.CODE = TXT.LANG_CODE
    left outer join T_USER_LANGUAGE_PREFERENCES ULP
      on ULP.LANG_CODE = TXT.LANG_CODE
      and ULP.USERID = sys_context('PSR', 'USERID'))
  where RANK = 1)
--
select cast(OOC.ASR_YEAR as number(4)) as ASR_YEAR, OOC.LOC_ID_ASYLUM_COUNTRY,
  OOC.LOC_ID_ORIGIN_COUNTRY, LOC2.NAME as LOC_NAME_ORIGIN_COUNTRY,
  OOC.STG_ID_PRIMARY, STG.POPULATION_SUBGROUP_NAME,
  STG.VERSION_NBR as STG_VERSION_NBR, STG.ITM_ID as STG_ITM_ID,
  STGA1.CHAR_VALUE as SOURCE, STGA1.VERSION_NBR as STGA_VERSION_NBR_SOURCE,
  STGA1.ITM_ID as STGA_ITM_ID_SOURCE,
  STGA2.CHAR_VALUE as BASIS, STGA2.VERSION_NBR as STGA_VERSION_NBR_BASIS,
  STGA2.ITM_ID as STGA_ITM_ID_BASIS,
  OOC.OOCPOP_START_VALUE,
  OOC.OOCPOP_START_STC_ID, OOC.OOCPOP_START_VERSION_NBR, OOC.OOCPOP_START_ITM_ID,
  OOC.OOCPOP_AH_START_VALUE,
  OOC.OOCPOP_AH_START_STC_ID, OOC.OOCPOP_AH_START_VERSION_NBR, OOC.OOCPOP_AH_START_ITM_ID,
  OOC.OOCARR_VALUE,
  OOC.OOCARR_STC_ID, OOC.OOCARR_VERSION_NBR, OOC.OOCARR_ITM_ID,
  OOC.OOCOTHINC_VALUE,
  OOC.OOCOTHINC_STC_ID, OOC.OOCOTHINC_VERSION_NBR, OOC.OOCOTHINC_ITM_ID,
  OOC.OOCRTN_VALUE,
  OOC.OOCRTN_STC_ID, OOC.OOCRTN_VERSION_NBR, OOC.OOCRTN_ITM_ID,
  OOC.OOCOTHDEC_VALUE,
  OOC.OOCOTHDEC_STC_ID, OOC.OOCOTHDEC_VERSION_NBR, OOC.OOCOTHDEC_ITM_ID,
  OOC.OOCPOP_END_VALUE,
  OOC.OOCPOP_END_STC_ID, OOC.OOCPOP_END_VERSION_NBR, OOC.OOCPOP_END_ITM_ID,
  OOC.OOCPOP_AH_END_VALUE,
  OOC.OOCPOP_AH_END_STC_ID, OOC.OOCPOP_AH_END_VERSION_NBR, OOC.OOCPOP_AH_END_ITM_ID,
  STG.UPDATE_TIMESTAMP, STG.UPDATE_USERID
from Q_ASR_OTHERS_OF_CONCERN OOC
inner join Q_LOCATIONS LOC1
  on LOC1.ID = OOC.LOC_ID_ASYLUM_COUNTRY
left outer join Q_LOCATIONS LOC2
  on LOC2.ID = OOC.LOC_ID_ORIGIN_COUNTRY
left outer join Q_STATISTIC_GROUPS STG
  on STG.ID = OOC.STG_ID_PRIMARY
left outer join T_STC_GROUP_ATTRIBUTES STGA1
  on STGA1.STG_ID = STG.ID
  and STGA1.STGAT_CODE = 'SOURCE'
left outer join T_STC_GROUP_ATTRIBUTES STGA2
  on STGA2.STG_ID = STG.ID
  and STGA2.STGAT_CODE = 'BASIS';
