--
-- ASR_IDP_DISASTER - Natural disaster-induced IDPs
--
create or replace view ASR_IDP_DISASTER as
with Q_ASR_IDP_DISASTER as
 (select ASR_YEAR, LOC_ID_ASYLUM_COUNTRY, LOC_ID_ASYLUM, STG_ID_PRIMARY,
    IDPDPOP_START_VALUE, IDPDPOP_START_STC_ID, IDPDPOP_START_VERSION_NBR, IDPDPOP_START_ITM_ID,
    IDPDPOP_AH_START_VALUE, IDPDPOP_AH_START_STC_ID, IDPDPOP_AH_START_VERSION_NBR,
    IDPDPOP_AH_START_ITM_ID,
    IDPDNEW_VALUE, IDPDNEW_STC_ID, IDPDNEW_VERSION_NBR, IDPDNEW_ITM_ID,
    IDPDOTHINC_VALUE, IDPDOTHINC_STC_ID, IDPDOTHINC_VERSION_NBR, IDPDOTHINC_ITM_ID,
    IDPDRTN_VALUE, IDPDRTN_STC_ID, IDPDRTN_VERSION_NBR, IDPDRTN_ITM_ID,
    IDPDRTN_AH_VALUE, IDPDRTN_AH_STC_ID, IDPDRTN_AH_VERSION_NBR, IDPDRTN_AH_ITM_ID,
    IDPDRELOC_VALUE, IDPDRELOC_STC_ID, IDPDRELOC_VERSION_NBR, IDPDRELOC_ITM_ID,
    IDPDOTHDEC_VALUE, IDPDOTHDEC_STC_ID, IDPDOTHDEC_VERSION_NBR, IDPDOTHDEC_ITM_ID,
    IDPDPOP_END_VALUE, IDPDPOP_END_STC_ID, IDPDPOP_END_VERSION_NBR, IDPDPOP_END_ITM_ID,
    IDPDPOP_AH_END_VALUE, IDPDPOP_AH_END_STC_ID, IDPDPOP_AH_END_VERSION_NBR, IDPDPOP_AH_END_ITM_ID
  from
   (select to_char(extract(year from STC.START_DATE)) as ASR_YEAR,
      STC.LOC_ID_ASYLUM_COUNTRY, STC.LOC_ID_ASYLUM, STC.STG_ID_PRIMARY,
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
    where STTIG.STTG_CODE = 'IDPNTRLDIS')
  pivot
   (sum(VALUE) as VALUE, max(STC_ID) as STC_ID, max(VERSION_NBR) as VERSION_NBR,
      max(ITM_ID) as ITM_ID
    for COLUMN_NAME
    in ('IDPDPOP_START' as IDPDPOP_START,
        'IDPDPOP_AH_START' as IDPDPOP_AH_START,
        'IDPDNEW' as IDPDNEW,
        'IDPDOTHINC' as IDPDOTHINC,
        'IDPDRTN' as IDPDRTN,
        'IDPDRTN_AH' as IDPDRTN_AH,
        'IDPDRELOC' as IDPDRELOC,
        'IDPDOTHDEC' as IDPDOTHDEC,
        'IDPDPOP_END' as IDPDPOP_END,
        'IDPDPOP_AH_END' as IDPDPOP_AH_END))),
--
Q_LOCATIONS as
 (select ID, NAME, LOCT_CODE, LOCTV_ID
  from
   (select LOC.ID, TXT.TEXT as NAME, LOC.LOCT_CODE, LOC.LOCTV_ID,
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
Q_LOCATION_TYPES as
 (select CODE, DESCRIPTION
  from
   (select LOCT.CODE, TXT.TEXT DESCRIPTION,
      row_number() over
       (partition by LOCT.CODE
        order by LANG.ACTIVE_FLAG desc, nvl(ULP.PREF_SEQ, LANG.DISPLAY_SEQ + 1e5)) as RANK
    from T_LOCATION_TYPES LOCT
    inner join T_TEXT_ITEMS TXT
      on TXT.ITM_ID = LOCT.ITM_ID
      and TXT.TXTT_CODE = 'DESCR'
      and TXT.SEQ_NBR = 1
    inner join T_LANGUAGES LANG
      on LANG.CODE = TXT.LANG_CODE
    left outer join T_USER_LANGUAGE_PREFERENCES ULP
      on ULP.LANG_CODE = TXT.LANG_CODE
      and ULP.USERID = sys_context('PSR', 'USERID'))
  where RANK = 1),
--
Q_LOCATION_TYPE_VARIANTS as
 (select ID, DESCRIPTION
  from
    (select LOCTV.ID, TXT.TEXT DESCRIPTION,
      row_number() over
       (partition by LOCTV.ID
        order by LANG.ACTIVE_FLAG desc, nvl(ULP.PREF_SEQ, LANG.DISPLAY_SEQ + 1e5)) as RANK
    from T_LOCATION_TYPE_VARIANTS LOCTV
    inner join T_TEXT_ITEMS TXT
      on TXT.ITM_ID = LOCTV.ITM_ID
      and TXT.TXTT_CODE = 'DESCR'
      and TXT.SEQ_NBR = 1
    inner join T_LANGUAGES LANG
      on LANG.CODE = TXT.LANG_CODE
    left outer join T_USER_LANGUAGE_PREFERENCES ULP
      on ULP.LANG_CODE = TXT.LANG_CODE
      and ULP.USERID = sys_context('PSR', 'USERID'))
  where RANK = 1)
--
select cast(IDP.ASR_YEAR as number(4)) as ASR_YEAR, IDP.LOC_ID_ASYLUM_COUNTRY,
  IDP.LOC_ID_ASYLUM, LOC.NAME as LOC_NAME_ASYLUM,
  nvl(LOCTV.DESCRIPTION, LOCT.DESCRIPTION) as LOC_TYPE_DESCRIPTION,
  IDP.STG_ID_PRIMARY, STG.VERSION_NBR as STG_VERSION_NBR, STG.ITM_ID as STG_ITM_ID,
  STGA1.CHAR_VALUE as SOURCE, STGA1.VERSION_NBR as STGA_VERSION_NBR_SOURCE,
  STGA1.ITM_ID as STGA_ITM_ID_SOURCE,
  STGA2.CHAR_VALUE as BASIS, STGA2.VERSION_NBR as STGA_VERSION_NBR_BASIS,
  STGA2.ITM_ID as STGA_ITM_ID_BASIS,
  IDP.IDPDPOP_START_VALUE, IDP.IDPDPOP_START_STC_ID, IDP.IDPDPOP_START_VERSION_NBR,
  IDP.IDPDPOP_START_ITM_ID,
  IDP.IDPDPOP_AH_START_VALUE, IDP.IDPDPOP_AH_START_STC_ID, IDP.IDPDPOP_AH_START_VERSION_NBR,
  IDP.IDPDPOP_AH_START_ITM_ID,
  IDP.IDPDNEW_VALUE, IDP.IDPDNEW_STC_ID, IDP.IDPDNEW_VERSION_NBR, IDP.IDPDNEW_ITM_ID,
  IDP.IDPDOTHINC_VALUE, IDP.IDPDOTHINC_STC_ID, IDP.IDPDOTHINC_VERSION_NBR, IDP.IDPDOTHINC_ITM_ID,
  IDP.IDPDRTN_VALUE, IDP.IDPDRTN_STC_ID, IDP.IDPDRTN_VERSION_NBR, IDP.IDPDRTN_ITM_ID,
  IDP.IDPDRTN_AH_VALUE, IDP.IDPDRTN_AH_STC_ID, IDP.IDPDRTN_AH_VERSION_NBR, IDP.IDPDRTN_AH_ITM_ID,
  IDP.IDPDRELOC_VALUE, IDP.IDPDRELOC_STC_ID, IDP.IDPDRELOC_VERSION_NBR, IDP.IDPDRELOC_ITM_ID,
  IDP.IDPDOTHDEC_VALUE, IDP.IDPDOTHDEC_STC_ID, IDP.IDPDOTHDEC_VERSION_NBR, IDP.IDPDOTHDEC_ITM_ID,
  IDP.IDPDPOP_END_VALUE, IDP.IDPDPOP_END_STC_ID, IDP.IDPDPOP_END_VERSION_NBR,
  IDP.IDPDPOP_END_ITM_ID,
  IDP.IDPDPOP_AH_END_VALUE, IDP.IDPDPOP_AH_END_STC_ID, IDP.IDPDPOP_AH_END_VERSION_NBR,
  IDP.IDPDPOP_AH_END_ITM_ID,
  STG.UPDATE_TIMESTAMP, STG.UPDATE_USERID
from Q_ASR_IDP_DISASTER IDP
inner join Q_LOCATIONS LOC
  on LOC.ID = IDP.LOC_ID_ASYLUM
inner join Q_LOCATION_TYPES LOCT
  on LOCT.CODE = LOC.LOCT_CODE
left outer join Q_LOCATION_TYPE_VARIANTS LOCTV
  on LOCTV.ID = LOC.LOCTV_ID
left outer join T_STATISTIC_GROUPS STG
  on STG.ID = IDP.STG_ID_PRIMARY
left outer join T_STC_GROUP_ATTRIBUTES STGA1
  on STGA1.STG_ID = STG.ID
  and STGA1.STGAT_CODE = 'SOURCE'
left outer join T_STC_GROUP_ATTRIBUTES STGA2
  on STGA2.STG_ID = STG.ID
  and STGA2.STGAT_CODE = 'BASIS';