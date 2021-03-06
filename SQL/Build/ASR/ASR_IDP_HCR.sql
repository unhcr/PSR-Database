--
-- ASR_IDP_HCR - IDPs and IDP-like protected/assisted by UNHCR
--
create or replace view ASR_IDP_HCR as
with Q_ASR_IDP_HCR as
 (select ASR_YEAR, DST_ID, LOC_ID_ASYLUM_COUNTRY, LOC_ID_ASYLUM, DIM_ID1, STG_ID_PRIMARY,
    IDPHPOP_START_VALUE, IDPHPOP_START_STC_ID, IDPHPOP_START_VERSION_NBR, IDPHPOP_START_ITM_ID,
    IDPHPOP_AH_START_VALUE, IDPHPOP_AH_START_STC_ID, IDPHPOP_AH_START_VERSION_NBR,
    IDPHPOP_AH_START_ITM_ID,
    IDPHNEW_VALUE, IDPHNEW_STC_ID, IDPHNEW_VERSION_NBR, IDPHNEW_ITM_ID,
    IDPHOTHINC_VALUE, IDPHOTHINC_STC_ID, IDPHOTHINC_VERSION_NBR, IDPHOTHINC_ITM_ID,
    IDPHRTN_VALUE, IDPHRTN_STC_ID, IDPHRTN_VERSION_NBR, IDPHRTN_ITM_ID,
    IDPHRTN_AH_VALUE, IDPHRTN_AH_STC_ID, IDPHRTN_AH_VERSION_NBR, IDPHRTN_AH_ITM_ID,
    IDPHRELOC_VALUE, IDPHRELOC_STC_ID, IDPHRELOC_VERSION_NBR, IDPHRELOC_ITM_ID,
    IDPHOTHDEC_VALUE, IDPHOTHDEC_STC_ID, IDPHOTHDEC_VERSION_NBR, IDPHOTHDEC_ITM_ID,
    IDPHPOP_END_VALUE, IDPHPOP_END_STC_ID, IDPHPOP_END_VERSION_NBR, IDPHPOP_END_ITM_ID,
    IDPHPOP_AH_END_VALUE, IDPHPOP_AH_END_STC_ID, IDPHPOP_AH_END_VERSION_NBR, IDPHPOP_AH_END_ITM_ID
  from
   (select to_char(extract(year from STC.START_DATE)) as ASR_YEAR, STC.DST_ID,
      STC.LOC_ID_ASYLUM_COUNTRY, STC.LOC_ID_ASYLUM, STC.DIM_ID1, STC.STG_ID_PRIMARY,
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
    where STTIG.STTG_CODE = 'IDP')
  pivot
   (sum(VALUE) as VALUE, max(STC_ID) as STC_ID, max(VERSION_NBR) as VERSION_NBR,
      max(ITM_ID) as ITM_ID
    for COLUMN_NAME
    in ('IDPHPOP_START' as IDPHPOP_START,
        'IDPHPOP_AH_START' as IDPHPOP_AH_START,
        'IDPHNEW' as IDPHNEW,
        'IDPHOTHINC' as IDPHOTHINC,
        'IDPHRTN' as IDPHRTN,
        'IDPHRTN_AH' as IDPHRTN_AH,
        'IDPHRELOC' as IDPHRELOC,
        'IDPHOTHDEC' as IDPHOTHDEC,
        'IDPHPOP_END' as IDPHPOP_END,
        'IDPHPOP_AH_END' as IDPHPOP_AH_END))),
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
  where RANK = 1),
--
Q_DIMENSION_VALUES as
 (select ID, DESCRIPTION, CODE
  from
   (select DIM.ID, TXT.TEXT DESCRIPTION, DIM.CODE,
      row_number() over
       (partition by DIM.ID
        order by LANG.ACTIVE_FLAG desc, nvl(ULP.PREF_SEQ, LANG.DISPLAY_SEQ + 1e5)) as RANK
    from T_DIMENSION_VALUES DIM
    inner join T_TEXT_ITEMS TXT
      on TXT.ITM_ID = DIM.ITM_ID
      and TXT.TXTT_CODE = 'DESCR'
      and TXT.SEQ_NBR = 1
    inner join T_LANGUAGES LANG
      on LANG.CODE = TXT.LANG_CODE
    left outer join T_USER_LANGUAGE_PREFERENCES ULP
      on ULP.LANG_CODE = TXT.LANG_CODE
      and ULP.USERID = sys_context('PSR', 'USERID'))
  where RANK = 1),
--
Q_DISPLACEMENT_STATUSES as
 (select ID, DESCRIPTION, CODE
  from
   (select DST.ID, TXT.TEXT DESCRIPTION, DST.CODE,
      row_number() over
       (partition by DST.ID
        order by LANG.ACTIVE_FLAG desc, nvl(ULP.PREF_SEQ, LANG.DISPLAY_SEQ + 1e5)) as RANK
    from T_DISPLACEMENT_STATUSES DST
    inner join T_TEXT_ITEMS TXT
      on TXT.ITM_ID = DST.ITM_ID
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
  IDP.DST_ID, DST.DESCRIPTION as DST_DESCRIPTION, DST.CODE as DST_CODE,
  IDP.LOC_ID_ASYLUM, LOC.NAME as LOC_NAME_ASYLUM,
  nvl(LOCTV.DESCRIPTION, LOCT.DESCRIPTION) as LOC_TYPE_DESCRIPTION,
  IDP.DIM_ID1 as DIM_ID_OFFICIAL, DIM.CODE as OFFICIAL_CODE,
  DIM.DESCRIPTION as OFFICIAL_DESCRIPTION,
  IDP.STG_ID_PRIMARY, STG.VERSION_NBR as STG_VERSION_NBR, STG.ITM_ID as STG_ITM_ID,
  STGA1.CHAR_VALUE as SOURCE, STGA1.VERSION_NBR as STGA_VERSION_NBR_SOURCE,
  STGA1.ITM_ID as STGA_ITM_ID_SOURCE,
  STGA2.CHAR_VALUE as BASIS, STGA2.VERSION_NBR as STGA_VERSION_NBR_BASIS,
  STGA2.ITM_ID as STGA_ITM_ID_BASIS,
  IDP.IDPHPOP_START_VALUE, IDP.IDPHPOP_START_STC_ID, IDP.IDPHPOP_START_VERSION_NBR,
  IDP.IDPHPOP_START_ITM_ID,
  IDP.IDPHPOP_AH_START_VALUE, IDP.IDPHPOP_AH_START_STC_ID, IDP.IDPHPOP_AH_START_VERSION_NBR,
  IDP.IDPHPOP_AH_START_ITM_ID,
  IDP.IDPHNEW_VALUE, IDP.IDPHNEW_STC_ID, IDP.IDPHNEW_VERSION_NBR, IDP.IDPHNEW_ITM_ID,
  IDP.IDPHOTHINC_VALUE, IDP.IDPHOTHINC_STC_ID, IDP.IDPHOTHINC_VERSION_NBR, IDP.IDPHOTHINC_ITM_ID,
  IDP.IDPHRTN_VALUE, IDP.IDPHRTN_STC_ID, IDP.IDPHRTN_VERSION_NBR, IDP.IDPHRTN_ITM_ID,
  IDP.IDPHRTN_AH_VALUE, IDP.IDPHRTN_AH_STC_ID, IDP.IDPHRTN_AH_VERSION_NBR, IDP.IDPHRTN_AH_ITM_ID,
  IDP.IDPHRELOC_VALUE, IDP.IDPHRELOC_STC_ID, IDP.IDPHRELOC_VERSION_NBR, IDP.IDPHRELOC_ITM_ID,
  IDP.IDPHOTHDEC_VALUE, IDP.IDPHOTHDEC_STC_ID, IDP.IDPHOTHDEC_VERSION_NBR, IDP.IDPHOTHDEC_ITM_ID,
  IDP.IDPHPOP_END_VALUE, IDP.IDPHPOP_END_STC_ID, IDP.IDPHPOP_END_VERSION_NBR,
  IDP.IDPHPOP_END_ITM_ID,
  IDP.IDPHPOP_AH_END_VALUE, IDP.IDPHPOP_AH_END_STC_ID, IDP.IDPHPOP_AH_END_VERSION_NBR,
  IDP.IDPHPOP_AH_END_ITM_ID,
  STG.UPDATE_TIMESTAMP, STG.UPDATE_USERID
from Q_ASR_IDP_HCR IDP
inner join Q_DISPLACEMENT_STATUSES DST
  on DST.ID = IDP.DST_ID
inner join Q_LOCATIONS LOC
  on LOC.ID = IDP.LOC_ID_ASYLUM
inner join Q_LOCATION_TYPES LOCT
  on LOCT.CODE = LOC.LOCT_CODE
left outer join Q_LOCATION_TYPE_VARIANTS LOCTV
  on LOCTV.ID = LOC.LOCTV_ID
inner join Q_DIMENSION_VALUES DIM
  on DIM.ID = IDP.DIM_ID1
left outer join T_STATISTIC_GROUPS STG
  on STG.ID = IDP.STG_ID_PRIMARY
left outer join T_STC_GROUP_ATTRIBUTES STGA1
  on STGA1.STG_ID = STG.ID
  and STGA1.STGAT_CODE = 'SOURCE'
left outer join T_STC_GROUP_ATTRIBUTES STGA2
  on STGA2.STG_ID = STG.ID
  and STGA2.STGAT_CODE = 'BASIS';
