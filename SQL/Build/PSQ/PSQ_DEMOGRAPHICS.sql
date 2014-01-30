--
-- V_PSQ_DEMOGRAPHICS_DATA
--
create or replace view V_PSQ_DEMOGRAPHICS_DATA as
with Q_DEMOGRAPHICS as
 (select ASR_YEAR, DST_ID, LOC_ID_ASYLUM_COUNTRY, LOC_ID_ASYLUM, LOC_ID_ORIGIN_COUNTRY,
    REDACTION_LIMIT,
    F0_VALUE, F5_VALUE, F12_VALUE, F18_VALUE, F60_VALUE,
    case when STCT_CODE = 'POCPOPS' then FOTHER_VALUE end as FOTHER_VALUE,
    M0_VALUE, M5_VALUE, M12_VALUE, M18_VALUE, M60_VALUE,
    case when STCT_CODE = 'POCPOPS' then MOTHER_VALUE end as MOTHER_VALUE,
    case when STCT_CODE = 'POCPOPN' then TOTAL_VALUE end as TOTAL_VALUE
  from
   (select extract(year from STC.START_DATE) as ASR_YEAR, STC.STCT_CODE, STC.DST_ID,
      STC.LOC_ID_ASYLUM_COUNTRY, STC.LOC_ID_ASYLUM, STC.LOC_ID_ORIGIN_COUNTRY,
      max(STGA.REDACTION_LIMIT) over
       (partition by extract(year from STC.START_DATE), STC.STCT_CODE, STC.DST_ID,
          STC.LOC_ID_ASYLUM_COUNTRY, STC.LOC_ID_ASYLUM, STC.LOC_ID_ORIGIN_COUNTRY)
        as REDACTION_LIMIT,
      STC.SEX_CODE || nvl(to_char(AGR.AGE_FROM), 'X') as DATA_POINT,
      STC.VALUE
    from T_STATISTIC_TYPES_IN_GROUPS STTIG
    inner join T_STATISTICS STC
      on STC.STCT_CODE = STTIG.STCT_CODE
    left outer join
     (select STIG.STC_ID, max(STGA.NUM_VALUE) REDACTION_LIMIT
      from T_STATISTICS_IN_GROUPS STIG
      inner join T_STC_GROUP_ATTRIBUTES STGA
        on STGA.STG_ID = STIG.STG_ID
        and STGA.STGAT_CODE = 'REDACTLMT'
      group by STIG.STC_ID) STGA
      on STGA.STC_ID = STC.ID
    left outer join T_AGE_RANGES AGR
      on AGR.ID = STC.AGR_ID
    where STTIG.STTG_CODE = 'DEMOGR')
  pivot
   (sum(VALUE) as VALUE
    for DATA_POINT
    in ('F0' as F0, 'F5' as F5, 'F12' as F12, 'F18' as F18, 'F60' as F60, 'FX' as FOTHER,
        'M0' as M0, 'M5' as M5, 'M12' as M12, 'M18' as M18, 'M60' as M60, 'MX' as MOTHER,
        'X' as TOTAL))),
--
Q_COU as
 (select LOC.ID as LOC_ID, LOC.ITM_ID,
    LOCA1.CHAR_VALUE as ISO3166_NUMERIC_CODE, LOCA2.CHAR_VALUE as ISO3166_ALPHA3_CODE,
    REG.UNSD_GSR_ITM_ID, REG.UNSD_GSR_ORDER_SEQ,
    REG.UNSD_MGR_ITM_ID, REG.UNSD_MGR_ORDER_SEQ,
    REG.UNHCR_ROP_ITM_ID, REG.UNHCR_ROP_ORDER_SEQ,
    REG.UNHCR_BUR_ITM_ID, REG.UNHCR_BUR_ORDER_SEQ
  from T_LOCATIONS LOC
  left outer join T_LOCATION_ATTRIBUTES LOCA1
    on LOCA1.LOC_ID = LOC.ID
    and LOCA1.LOCAT_CODE = 'ISO3166NUM'
  left outer join T_LOCATION_ATTRIBUTES LOCA2
    on LOCA2.LOC_ID = LOC.ID
    and LOCA2.LOCAT_CODE = 'ISO3166A3'
  left outer join PSQ_COUNTRY_REGIONS REG
    on REG.COU_ID = LOC.ID)
--
select cast(ASR_YEAR as number(4)) as ASR_YEAR,
  cast(COU_CODE_RESIDENCE as varchar2(3)) as COU_CODE_RESIDENCE,
  cast(ISO3166_ALPHA3_CODE_RESIDENCE as varchar2(3)) as ISO3166_ALPHA3_CODE_RESIDENCE,
  ITM_ID_LOC_RESIDENCE_COUNTRY,
  UNSD_GSR_ITM_ID_RESIDENCE, UNSD_GSR_ORDER_SEQ_RESIDENCE,
  UNSD_MGR_ITM_ID_RESIDENCE, UNSD_MGR_ORDER_SEQ_RESIDENCE,
  UNHCR_ROP_ITM_ID_RESIDENCE, UNHCR_ROP_ORDER_SEQ_RESIDENCE,
  UNHCR_BUR_ITM_ID_RESIDENCE, UNHCR_BUR_ORDER_SEQ_RESIDENCE,
  ITM_ID_LOC_RESIDENCE, LOCT_CODE_RESIDENCE, ITM_ID_LOCT_RESIDENCE, ITM_ID_LOCTV_RESIDENCE,
  cast(COU_CODE_ORIGIN as varchar2(3)) as COU_CODE_ORIGIN,
  cast(ISO3166_ALPHA3_CODE_ORIGIN as varchar2(3)) as ISO3166_ALPHA3_CODE_ORIGIN,
  ITM_ID_LOC_ORIGIN_COUNTRY,
  UNSD_GSR_ITM_ID_ORIGIN, UNSD_GSR_ORDER_SEQ_ORIGIN,
  UNSD_MGR_ITM_ID_ORIGIN, UNSD_MGR_ORDER_SEQ_ORIGIN,
  UNHCR_ROP_ITM_ID_ORIGIN, UNHCR_ROP_ORDER_SEQ_ORIGIN,
  UNHCR_BUR_ITM_ID_ORIGIN, UNHCR_BUR_ORDER_SEQ_ORIGIN,
  DST_CODE, ITM_ID_DST, DST_ORDER_SEQ,
  F0_VALUE, F0_REDACTED_FLAG,
  F5_VALUE, F5_REDACTED_FLAG,
  F12_VALUE, F12_REDACTED_FLAG,
  F18_VALUE, F18_REDACTED_FLAG,
  F60_VALUE, F60_REDACTED_FLAG,
  FOTHER_VALUE, FOTHER_REDACTED_FLAG,
  case
    when nvl(F0_VALUE, 0) + nvl(F5_VALUE, 0) + nvl(F12_VALUE, 0) + nvl(F18_VALUE, 0) +
        nvl(F60_VALUE, 0) + nvl(FOTHER_VALUE, 0) >= nvl(REDACTION_LIMIT, 0)
    then nvl(F0_VALUE, 0) + nvl(F5_VALUE, 0) + nvl(F12_VALUE, 0) + nvl(F18_VALUE, 0) +
        nvl(F60_VALUE, 0) + nvl(FOTHER_VALUE, 0)
  end as FTOTAL_VALUE,
  case
    when coalesce(F0_REDACTED_FLAG, F5_REDACTED_FLAG, F12_REDACTED_FLAG,
                  F18_REDACTED_FLAG, F60_REDACTED_FLAG, FOTHER_REDACTED_FLAG) = 1
    then 1
  end as FTOTAL_REDACTED_FLAG,
  M0_VALUE, M0_REDACTED_FLAG,
  M5_VALUE, M5_REDACTED_FLAG,
  M12_VALUE, M12_REDACTED_FLAG,
  M18_VALUE, M18_REDACTED_FLAG,
  M60_VALUE, M60_REDACTED_FLAG,
  MOTHER_VALUE, MOTHER_REDACTED_FLAG,
  case
    when nvl(M0_VALUE, 0) + nvl(M5_VALUE, 0) + nvl(M12_VALUE, 0) + nvl(M18_VALUE, 0) +
        nvl(M60_VALUE, 0) + nvl(MOTHER_VALUE, 0) >= nvl(REDACTION_LIMIT, 0)
    then nvl(M0_VALUE, 0) + nvl(M5_VALUE, 0) + nvl(M12_VALUE, 0) + nvl(M18_VALUE, 0) +
        nvl(M60_VALUE, 0) + nvl(MOTHER_VALUE, 0)
  end as MTOTAL_VALUE,
  case
    when coalesce(M0_REDACTED_FLAG, M5_REDACTED_FLAG, M12_REDACTED_FLAG,
                  M18_REDACTED_FLAG, M60_REDACTED_FLAG, MOTHER_REDACTED_FLAG) = 1
    then 1
  end as MTOTAL_REDACTED_FLAG,
  case
    when TOTAL_VALUE is not null or TOTAL_REDACTED_FLAG = 1 then TOTAL_VALUE
    when nvl(F0_VALUE, 0) + nvl(F5_VALUE, 0) + nvl(F12_VALUE, 0) + nvl(F18_VALUE, 0) +
        nvl(F60_VALUE, 0) + nvl(FOTHER_VALUE, 0) +
        nvl(M0_VALUE, 0) + nvl(M5_VALUE, 0) + nvl(M12_VALUE, 0) + nvl(M18_VALUE, 0) +
        nvl(M60_VALUE, 0) + nvl(MOTHER_VALUE, 0) >= nvl(REDACTION_LIMIT, 0)
    then nvl(F0_VALUE, 0) + nvl(F5_VALUE, 0) + nvl(F12_VALUE, 0) + nvl(F18_VALUE, 0) +
        nvl(F60_VALUE, 0) + nvl(FOTHER_VALUE, 0) +
        nvl(M0_VALUE, 0) + nvl(M5_VALUE, 0) + nvl(M12_VALUE, 0) + nvl(M18_VALUE, 0) +
        nvl(M60_VALUE, 0) + nvl(MOTHER_VALUE, 0)
  end as TOTAL_VALUE,
  case
    when TOTAL_REDACTED_FLAG = 1 then 1
    when coalesce(F0_REDACTED_FLAG, F5_REDACTED_FLAG, F12_REDACTED_FLAG,
                  F18_REDACTED_FLAG, F60_REDACTED_FLAG, FOTHER_REDACTED_FLAG,
                  M0_REDACTED_FLAG, M5_REDACTED_FLAG, M12_REDACTED_FLAG,
                  M18_REDACTED_FLAG, M60_REDACTED_FLAG, MOTHER_REDACTED_FLAG) = 1
    then 1
  end as TOTAL_REDACTED_FLAG
from
 (select DEM.ASR_YEAR,
    COU1.ISO3166_NUMERIC_CODE as COU_CODE_RESIDENCE,
    COU1.ISO3166_ALPHA3_CODE as ISO3166_ALPHA3_CODE_RESIDENCE,
    COU1.ITM_ID as ITM_ID_LOC_RESIDENCE_COUNTRY,
    COU1.UNSD_GSR_ITM_ID as UNSD_GSR_ITM_ID_RESIDENCE,
    COU1.UNSD_GSR_ORDER_SEQ as UNSD_GSR_ORDER_SEQ_RESIDENCE,
    COU1.UNSD_MGR_ITM_ID as UNSD_MGR_ITM_ID_RESIDENCE,
    COU1.UNSD_MGR_ORDER_SEQ as UNSD_MGR_ORDER_SEQ_RESIDENCE,
    COU1.UNHCR_ROP_ITM_ID as UNHCR_ROP_ITM_ID_RESIDENCE,
    COU1.UNHCR_ROP_ORDER_SEQ as UNHCR_ROP_ORDER_SEQ_RESIDENCE,
    COU1.UNHCR_BUR_ITM_ID as UNHCR_BUR_ITM_ID_RESIDENCE,
    COU1.UNHCR_BUR_ORDER_SEQ as UNHCR_BUR_ORDER_SEQ_RESIDENCE,
    LOC.ITM_ID as ITM_ID_LOC_RESIDENCE,
    LOC.LOCT_CODE as LOCT_CODE_RESIDENCE,
    LOCT.ITM_ID as ITM_ID_LOCT_RESIDENCE,
    LOCTV.ITM_ID as ITM_ID_LOCTV_RESIDENCE,
    nvl(COU2.ISO3166_NUMERIC_CODE, COU2.ISO3166_ALPHA3_CODE) as COU_CODE_ORIGIN,
    COU2.ISO3166_ALPHA3_CODE as ISO3166_ALPHA3_CODE_ORIGIN,
    COU2.ITM_ID as ITM_ID_LOC_ORIGIN_COUNTRY,
    COU2.UNSD_GSR_ITM_ID as UNSD_GSR_ITM_ID_ORIGIN,
    COU2.UNSD_GSR_ORDER_SEQ as UNSD_GSR_ORDER_SEQ_ORIGIN,
    COU2.UNSD_MGR_ITM_ID as UNSD_MGR_ITM_ID_ORIGIN,
    COU2.UNSD_MGR_ORDER_SEQ as UNSD_MGR_ORDER_SEQ_ORIGIN,
    COU2.UNHCR_ROP_ITM_ID as UNHCR_ROP_ITM_ID_ORIGIN,
    COU2.UNHCR_ROP_ORDER_SEQ as UNHCR_ROP_ORDER_SEQ_ORIGIN,
    COU2.UNHCR_BUR_ITM_ID as UNHCR_BUR_ITM_ID_ORIGIN,
    COU2.UNHCR_BUR_ORDER_SEQ as UNHCR_BUR_ORDER_SEQ_ORIGIN,
    DST.ITM_ID as ITM_ID_DST,
    DST.CODE as DST_CODE,
    DST.DISPLAY_SEQ as DST_ORDER_SEQ,
    DEM.REDACTION_LIMIT,
    case
      when abs(sum(DEM.F0_VALUE)) >= nvl(max(DEM.REDACTION_LIMIT), 0) then sum(DEM.F0_VALUE)
    end as F0_VALUE,
    case
      when abs(sum(DEM.F0_VALUE)) < max(DEM.REDACTION_LIMIT) then 1
    end as F0_REDACTED_FLAG,
    case
      when abs(sum(DEM.F5_VALUE)) >= nvl(max(DEM.REDACTION_LIMIT), 0) then sum(DEM.F5_VALUE)
    end as F5_VALUE,
    case
      when abs(sum(DEM.F5_VALUE)) < max(DEM.REDACTION_LIMIT) then 1
    end as F5_REDACTED_FLAG,
    case
      when abs(sum(DEM.F12_VALUE)) >= nvl(max(DEM.REDACTION_LIMIT), 0) then sum(DEM.F12_VALUE)
    end as F12_VALUE,
    case
      when abs(sum(DEM.F12_VALUE)) < max(DEM.REDACTION_LIMIT) then 1
    end as F12_REDACTED_FLAG,
    case
      when abs(sum(DEM.F18_VALUE)) >= nvl(max(DEM.REDACTION_LIMIT), 0) then sum(DEM.F18_VALUE)
    end as F18_VALUE,
    case
      when abs(sum(DEM.F18_VALUE)) < max(DEM.REDACTION_LIMIT) then 1
    end as F18_REDACTED_FLAG,
    case
      when abs(sum(DEM.F60_VALUE)) >= nvl(max(DEM.REDACTION_LIMIT), 0) then sum(DEM.F60_VALUE)
    end as F60_VALUE,
    case
      when abs(sum(DEM.F60_VALUE)) < max(DEM.REDACTION_LIMIT) then 1
    end as F60_REDACTED_FLAG,
    case
      when abs(sum(DEM.FOTHER_VALUE)) >= nvl(max(DEM.REDACTION_LIMIT), 0) then sum(DEM.FOTHER_VALUE)
    end as FOTHER_VALUE,
    case
      when abs(sum(DEM.FOTHER_VALUE)) < max(DEM.REDACTION_LIMIT) then 1
    end as FOTHER_REDACTED_FLAG,
    case
      when abs(sum(DEM.M0_VALUE)) >= nvl(max(DEM.REDACTION_LIMIT), 0) then sum(DEM.M0_VALUE)
    end as M0_VALUE,
    case
      when abs(sum(DEM.M0_VALUE)) < max(DEM.REDACTION_LIMIT) then 1
    end as M0_REDACTED_FLAG,
    case
      when abs(sum(DEM.M5_VALUE)) >= nvl(max(DEM.REDACTION_LIMIT), 0) then sum(DEM.M5_VALUE)
    end as M5_VALUE,
    case
      when abs(sum(DEM.M5_VALUE)) < max(DEM.REDACTION_LIMIT) then 1
    end as M5_REDACTED_FLAG,
    case
      when abs(sum(DEM.M12_VALUE)) >= nvl(max(DEM.REDACTION_LIMIT), 0) then sum(DEM.M12_VALUE)
    end as M12_VALUE,
    case
      when abs(sum(DEM.M12_VALUE)) < max(DEM.REDACTION_LIMIT) then 1
    end as M12_REDACTED_FLAG,
    case
      when abs(sum(DEM.M18_VALUE)) >= nvl(max(DEM.REDACTION_LIMIT), 0) then sum(DEM.M18_VALUE)
    end as M18_VALUE,
    case
      when abs(sum(DEM.M18_VALUE)) < max(DEM.REDACTION_LIMIT) then 1
    end as M18_REDACTED_FLAG,
    case
      when abs(sum(DEM.M60_VALUE)) >= nvl(max(DEM.REDACTION_LIMIT), 0) then sum(DEM.M60_VALUE)
    end as M60_VALUE,
    case
      when abs(sum(DEM.M60_VALUE)) < max(DEM.REDACTION_LIMIT) then 1
    end as M60_REDACTED_FLAG,
    case
      when abs(sum(DEM.MOTHER_VALUE)) >= nvl(max(DEM.REDACTION_LIMIT), 0) then sum(DEM.MOTHER_VALUE)
    end as MOTHER_VALUE,
    case
      when abs(sum(DEM.MOTHER_VALUE)) < max(DEM.REDACTION_LIMIT) then 1
    end as MOTHER_REDACTED_FLAG,
    case
      when abs(sum(DEM.TOTAL_VALUE)) >= nvl(max(DEM.REDACTION_LIMIT), 0) then sum(DEM.TOTAL_VALUE)
    end as TOTAL_VALUE,
    case
      when abs(sum(DEM.TOTAL_VALUE)) < max(DEM.REDACTION_LIMIT) then 1
    end as TOTAL_REDACTED_FLAG
  from Q_DEMOGRAPHICS DEM
  inner join Q_COU COU1
    on COU1.LOC_ID = DEM.LOC_ID_ASYLUM_COUNTRY
  inner join T_LOCATIONS LOC
    on LOC.ID = DEM.LOC_ID_ASYLUM
  inner join T_LOCATION_TYPES LOCT
    on LOCT.CODE = LOC.LOCT_CODE
  left outer join T_LOCATION_TYPE_VARIANTS LOCTV
    on LOCTV.ID = LOC.LOCTV_ID
  left outer join Q_COU COU2
    on COU2.LOC_ID = DEM.LOC_ID_ORIGIN_COUNTRY
  inner join T_DISPLACEMENT_STATUSES DST
    on DST.ID = DEM.DST_ID
  group by DEM.ASR_YEAR,
    COU1.ISO3166_NUMERIC_CODE, COU1.ISO3166_ALPHA3_CODE, COU1.ITM_ID,
    COU1.UNSD_GSR_ITM_ID, COU1.UNSD_GSR_ORDER_SEQ,
    COU1.UNSD_MGR_ITM_ID, COU1.UNSD_MGR_ORDER_SEQ,
    COU1.UNHCR_ROP_ITM_ID, COU1.UNHCR_ROP_ORDER_SEQ,
    COU1.UNHCR_BUR_ITM_ID, COU1.UNHCR_BUR_ORDER_SEQ,
    LOC.ITM_ID, LOC.LOCT_CODE, LOCT.ITM_ID, LOCTV.ITM_ID,
    COU2.ISO3166_NUMERIC_CODE, COU2.ISO3166_ALPHA3_CODE, COU2.ITM_ID,
    COU2.UNSD_GSR_ITM_ID, COU2.UNSD_GSR_ORDER_SEQ,
    COU2.UNSD_MGR_ITM_ID, COU2.UNSD_MGR_ORDER_SEQ,
    COU2.UNHCR_ROP_ITM_ID, COU2.UNHCR_ROP_ORDER_SEQ,
    COU2.UNHCR_BUR_ITM_ID, COU2.UNHCR_BUR_ORDER_SEQ,
    DST.ITM_ID, DST.CODE, DST.DISPLAY_SEQ, DEM.REDACTION_LIMIT);

--
-- PSQ_DEMOGRAPHICS_DATA
--
create materialized view PSQ_DEMOGRAPHICS_DATA as
select ASR_YEAR,
  COU_CODE_RESIDENCE, ISO3166_ALPHA3_CODE_RESIDENCE, ITM_ID_LOC_RESIDENCE_COUNTRY,
  UNSD_GSR_ITM_ID_RESIDENCE, UNSD_GSR_ORDER_SEQ_RESIDENCE,
  UNSD_MGR_ITM_ID_RESIDENCE, UNSD_MGR_ORDER_SEQ_RESIDENCE,
  UNHCR_ROP_ITM_ID_RESIDENCE, UNHCR_ROP_ORDER_SEQ_RESIDENCE,
  UNHCR_BUR_ITM_ID_RESIDENCE, UNHCR_BUR_ORDER_SEQ_RESIDENCE,
  ITM_ID_LOC_RESIDENCE, LOCT_CODE_RESIDENCE, ITM_ID_LOCT_RESIDENCE, ITM_ID_LOCTV_RESIDENCE,
  COU_CODE_ORIGIN, ISO3166_ALPHA3_CODE_ORIGIN, ITM_ID_LOC_ORIGIN_COUNTRY,
  UNSD_GSR_ITM_ID_ORIGIN, UNSD_GSR_ORDER_SEQ_ORIGIN,
  UNSD_MGR_ITM_ID_ORIGIN, UNSD_MGR_ORDER_SEQ_ORIGIN,
  UNHCR_ROP_ITM_ID_ORIGIN, UNHCR_ROP_ORDER_SEQ_ORIGIN,
  UNHCR_BUR_ITM_ID_ORIGIN, UNHCR_BUR_ORDER_SEQ_ORIGIN,
  DST_CODE, ITM_ID_DST, DST_ORDER_SEQ,
  F0_VALUE, F0_REDACTED_FLAG, F5_VALUE, F5_REDACTED_FLAG, F12_VALUE, F12_REDACTED_FLAG,
  F18_VALUE, F18_REDACTED_FLAG, F60_VALUE, F60_REDACTED_FLAG, FOTHER_VALUE, FOTHER_REDACTED_FLAG,
  FTOTAL_VALUE, FTOTAL_REDACTED_FLAG,
  M0_VALUE, M0_REDACTED_FLAG, M5_VALUE, M5_REDACTED_FLAG, M12_VALUE, M12_REDACTED_FLAG,
  M18_VALUE, M18_REDACTED_FLAG, M60_VALUE, M60_REDACTED_FLAG, MOTHER_VALUE, MOTHER_REDACTED_FLAG,
  MTOTAL_VALUE, MTOTAL_REDACTED_FLAG, TOTAL_VALUE, TOTAL_REDACTED_FLAG
from V_PSQ_DEMOGRAPHICS_DATA;

create index IX_DEM_YEAR on PSQ_DEMOGRAPHICS_DATA (ASR_YEAR);
create index IX_DEM_COU_RES on PSQ_DEMOGRAPHICS_DATA (COU_CODE_RESIDENCE);
create index IX_DEM_COU_OGN on PSQ_DEMOGRAPHICS_DATA (COU_CODE_ORIGIN);
create index IX_DEM_DST on PSQ_DEMOGRAPHICS_DATA (DST_CODE);

--
-- PSQ_DEMOGRAPHICS_COUNTRIES
--
create materialized view PSQ_DEMOGRAPHICS_COUNTRIES as
select distinct nvl(COU_CODE_RESIDENCE, 'XXX') as COU_CODE
from PSQ_DEMOGRAPHICS_DATA;

--
-- PSQ_DEMOGRAPHICS_ORIGINS
--
create materialized view PSQ_DEMOGRAPHICS_ORIGINS as
select distinct nvl(COU_CODE_ORIGIN, 'XXX') as COU_CODE
from PSQ_DEMOGRAPHICS_DATA;

--
-- PSQ_DEMOGRAPHICS_YEARS
--
create materialized view PSQ_DEMOGRAPHICS_YEARS as
select distinct ASR_YEAR
from PSQ_DEMOGRAPHICS_DATA;

--
-- PSQ_DEMOGRAPHICS
--
create or replace view PSQ_DEMOGRAPHICS as
select ASR_YEAR,
  COU_CODE_RESIDENCE, ISO3166_ALPHA3_CODE_RESIDENCE, COU_NAME_RESIDENCE,
  UNSD_GSR_ITM_ID_RESIDENCE, UNSD_GSR_ORDER_SEQ_RESIDENCE,
  UNSD_MGR_ITM_ID_RESIDENCE, UNSD_MGR_ORDER_SEQ_RESIDENCE,
  UNHCR_ROP_ITM_ID_RESIDENCE, UNHCR_ROP_ORDER_SEQ_RESIDENCE,
  UNHCR_BUR_ITM_ID_RESIDENCE, UNHCR_BUR_ORDER_SEQ_RESIDENCE,
  case
    when LOCT_CODE_RESIDENCE = 'ADMIN0' then LOCT_DESCRIPTION_RESIDENCE
    when DUP_NAME_COUNT > 1 then LOC_NAME_RESIDENCE || ' (' || LOCT_DESCRIPTION_RESIDENCE || ')'
    else LOC_NAME_RESIDENCE
  end as LOC_NAME_RESIDENCE,
  case when LOCT_CODE_RESIDENCE = 'ADMIN0' then 2 else 1 end as LOC_ORDER_SEQ,
  COU_CODE_ORIGIN, ISO3166_ALPHA3_CODE_ORIGIN, COU_NAME_ORIGIN,
  UNSD_GSR_ITM_ID_ORIGIN, UNSD_GSR_ORDER_SEQ_ORIGIN,
  UNSD_MGR_ITM_ID_ORIGIN, UNSD_MGR_ORDER_SEQ_ORIGIN,
  UNHCR_ROP_ITM_ID_ORIGIN, UNHCR_ROP_ORDER_SEQ_ORIGIN,
  UNHCR_BUR_ITM_ID_ORIGIN, UNHCR_BUR_ORDER_SEQ_ORIGIN,
  DST_CODE, DST_DESCRIPTION, DST_ORDER_SEQ,
  F0_VALUE, F0_REDACTED_FLAG,
  F5_VALUE, F5_REDACTED_FLAG,
  F12_VALUE, F12_REDACTED_FLAG,
  F18_VALUE, F18_REDACTED_FLAG,
  F60_VALUE, F60_REDACTED_FLAG,
  FOTHER_VALUE, FOTHER_REDACTED_FLAG,
  FTOTAL_VALUE, FTOTAL_REDACTED_FLAG,
  M0_VALUE, M0_REDACTED_FLAG,
  M5_VALUE, M5_REDACTED_FLAG,
  M12_VALUE, M12_REDACTED_FLAG,
  M18_VALUE, M18_REDACTED_FLAG,
  M60_VALUE, M60_REDACTED_FLAG,
  MOTHER_VALUE, MOTHER_REDACTED_FLAG,
  MTOTAL_VALUE, MTOTAL_REDACTED_FLAG,
  TOTAL_VALUE, TOTAL_REDACTED_FLAG
from
 (select DEM.ASR_YEAR,
    DEM.COU_CODE_RESIDENCE, DEM.ISO3166_ALPHA3_CODE_RESIDENCE,
    NAM1.NAME as COU_NAME_RESIDENCE,
    DEM.UNSD_GSR_ITM_ID_RESIDENCE, DEM.UNSD_GSR_ORDER_SEQ_RESIDENCE,
    DEM.UNSD_MGR_ITM_ID_RESIDENCE, DEM.UNSD_MGR_ORDER_SEQ_RESIDENCE,
    DEM.UNHCR_ROP_ITM_ID_RESIDENCE, DEM.UNHCR_ROP_ORDER_SEQ_RESIDENCE,
    DEM.UNHCR_BUR_ITM_ID_RESIDENCE, DEM.UNHCR_BUR_ORDER_SEQ_RESIDENCE,
    NAM2.NAME as LOC_NAME_RESIDENCE,
    DEM.LOCT_CODE_RESIDENCE,
    nvl(DESC2.DESCRIPTION, DESC1.DESCRIPTION) as LOCT_DESCRIPTION_RESIDENCE,
    count(distinct DEM.ITM_ID_LOC_RESIDENCE) over
      (partition by DEM.ASR_YEAR, DEM.COU_CODE_RESIDENCE, NAM2.NAME) as DUP_NAME_COUNT,
    DEM.COU_CODE_ORIGIN, DEM.ISO3166_ALPHA3_CODE_ORIGIN,
    DEM.UNSD_GSR_ITM_ID_ORIGIN, DEM.UNSD_GSR_ORDER_SEQ_ORIGIN,
    DEM.UNSD_MGR_ITM_ID_ORIGIN, DEM.UNSD_MGR_ORDER_SEQ_ORIGIN,
    DEM.UNHCR_ROP_ITM_ID_ORIGIN, DEM.UNHCR_ROP_ORDER_SEQ_ORIGIN,
    DEM.UNHCR_BUR_ITM_ID_ORIGIN, DEM.UNHCR_BUR_ORDER_SEQ_ORIGIN,
    NAM3.NAME as COU_NAME_ORIGIN,
    DEM.DST_CODE,
    nvl(TXT.TEXT, DESC3.DESCRIPTION) as DST_DESCRIPTION,
    DEM.DST_ORDER_SEQ,
    DEM.F0_VALUE, DEM.F0_REDACTED_FLAG,
    DEM.F5_VALUE, DEM.F5_REDACTED_FLAG,
    DEM.F12_VALUE, DEM.F12_REDACTED_FLAG,
    DEM.F18_VALUE, DEM.F18_REDACTED_FLAG,
    DEM.F60_VALUE, DEM.F60_REDACTED_FLAG,
    DEM.FOTHER_VALUE, DEM.FOTHER_REDACTED_FLAG,
    DEM.FTOTAL_VALUE, DEM.FTOTAL_REDACTED_FLAG,
    DEM.M0_VALUE, DEM.M0_REDACTED_FLAG,
    DEM.M5_VALUE, DEM.M5_REDACTED_FLAG,
    DEM.M12_VALUE, DEM.M12_REDACTED_FLAG,
    DEM.M18_VALUE, DEM.M18_REDACTED_FLAG,
    DEM.M60_VALUE, DEM.M60_REDACTED_FLAG,
    DEM.MOTHER_VALUE, DEM.MOTHER_REDACTED_FLAG,
    DEM.MTOTAL_VALUE, DEM.MTOTAL_REDACTED_FLAG,
    DEM.TOTAL_VALUE, DEM.TOTAL_REDACTED_FLAG
  from PSQ_DEMOGRAPHICS_DATA DEM
  inner join NAMES NAM1
    on NAM1.ITM_ID = DEM.ITM_ID_LOC_RESIDENCE_COUNTRY
  inner join NAMES NAM2
    on NAM2.ITM_ID = DEM.ITM_ID_LOC_RESIDENCE
  inner join DESCRIPTIONS DESC1
    on DESC1.ITM_ID = DEM.ITM_ID_LOCT_RESIDENCE
  left outer join DESCRIPTIONS DESC2
    on DESC2.ITM_ID = DEM.ITM_ID_LOCTV_RESIDENCE
  left outer join NAMES NAM3
    on NAM3.ITM_ID = DEM.ITM_ID_LOC_ORIGIN_COUNTRY
  inner join DESCRIPTIONS DESC3
    on DESC3.ITM_ID = DEM.ITM_ID_DST
  left outer join T_TEXT_ITEMS TXT
    on TXT.ITM_ID = DEM.ITM_ID_DST
    and TXT.TXTT_CODE = 'SHORTDESCR'
    and TXT.SEQ_NBR = 1
    and TXT.LANG_CODE = DESC3.LANG_CODE);

--
-- PSQ_DEMOGRAPHICS_EN
--
execute P_CONTEXT.SET_USERID('PUBLIC_ENGLISH');

create materialized view PSQ_DEMOGRAPHICS_EN as
select ASR_YEAR,
  COU_CODE_RESIDENCE, ISO3166_ALPHA3_CODE_RESIDENCE, COU_NAME_RESIDENCE,
  LOC_NAME_RESIDENCE,
  COU_CODE_ORIGIN, ISO3166_ALPHA3_CODE_ORIGIN, COU_NAME_ORIGIN,
  DST_CODE, DST_DESCRIPTION,
  F0_VALUE, F0_REDACTED_FLAG, F5_VALUE, F5_REDACTED_FLAG, F12_VALUE, F12_REDACTED_FLAG,
  F18_VALUE, F18_REDACTED_FLAG, F60_VALUE, F60_REDACTED_FLAG, FOTHER_VALUE, FOTHER_REDACTED_FLAG,
  FTOTAL_VALUE, FTOTAL_REDACTED_FLAG,
  M0_VALUE, M0_REDACTED_FLAG, M5_VALUE, M5_REDACTED_FLAG, M12_VALUE, M12_REDACTED_FLAG,
  M18_VALUE, M18_REDACTED_FLAG, M60_VALUE, M60_REDACTED_FLAG, MOTHER_VALUE, MOTHER_REDACTED_FLAG,
  MTOTAL_VALUE, MTOTAL_REDACTED_FLAG, TOTAL_VALUE, TOTAL_REDACTED_FLAG
from PSQ_DEMOGRAPHICS;

create index IX_DEME_YEAR on PSQ_DEMOGRAPHICS_EN (ASR_YEAR);
create index IX_DEME_COU_RES on PSQ_DEMOGRAPHICS_EN (COU_CODE_RESIDENCE);
create index IX_DEME_COU_OGN on PSQ_DEMOGRAPHICS_EN (COU_CODE_ORIGIN);
create index IX_DEME_DST on PSQ_DEMOGRAPHICS_EN (DST_CODE);

--
-- PSQ_DEMOGRAPHICS_FR
--
execute P_CONTEXT.SET_USERID('PUBLIC_FRENCH');

create materialized view PSQ_DEMOGRAPHICS_FR as
select ASR_YEAR,
  COU_CODE_RESIDENCE, ISO3166_ALPHA3_CODE_RESIDENCE, COU_NAME_RESIDENCE,
  LOC_NAME_RESIDENCE,
  COU_CODE_ORIGIN, ISO3166_ALPHA3_CODE_ORIGIN, COU_NAME_ORIGIN,
  DST_CODE, DST_DESCRIPTION,
  F0_VALUE, F0_REDACTED_FLAG, F5_VALUE, F5_REDACTED_FLAG, F12_VALUE, F12_REDACTED_FLAG,
  F18_VALUE, F18_REDACTED_FLAG, F60_VALUE, F60_REDACTED_FLAG, FOTHER_VALUE, FOTHER_REDACTED_FLAG,
  FTOTAL_VALUE, FTOTAL_REDACTED_FLAG,
  M0_VALUE, M0_REDACTED_FLAG, M5_VALUE, M5_REDACTED_FLAG, M12_VALUE, M12_REDACTED_FLAG,
  M18_VALUE, M18_REDACTED_FLAG, M60_VALUE, M60_REDACTED_FLAG, MOTHER_VALUE, MOTHER_REDACTED_FLAG,
  MTOTAL_VALUE, MTOTAL_REDACTED_FLAG, TOTAL_VALUE, TOTAL_REDACTED_FLAG
from PSQ_DEMOGRAPHICS;

create index IX_DEMF_YEAR on PSQ_DEMOGRAPHICS_FR (ASR_YEAR);
create index IX_DEMF_COU_RES on PSQ_DEMOGRAPHICS_FR (COU_CODE_RESIDENCE);
create index IX_DEMF_COU_OGN on PSQ_DEMOGRAPHICS_FR (COU_CODE_ORIGIN);
create index IX_DEMF_DST on PSQ_DEMOGRAPHICS_FR (DST_CODE);

execute P_CONTEXT.CLEAR_CONTEXT;
