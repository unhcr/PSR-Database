--
-- ASR_SUMMARY_FRAMEWORK - ASR summary table framework
--
create or replace view ASR_SUMMARY_FRAMEWORK as
select CDE.CODE,
  TXT1.TEXT as POPULATION_DESCRIPTION,
  TXT2.TEXT as POPULATION_NOTES,
  TXT3.TEXT as ASR_SOURCE,
  CDE.DISPLAY_SEQ
from T_CODES CDE
left outer join TEXT_ITEMS TXT1
  on TXT1.ITM_ID = CDE.ITM_ID
  and TXT1.TXTT_CODE = 'DESCR'
  and TXT1.SEQ_NBR = 1
left outer join TEXT_ITEMS TXT2
  on TXT2.ITM_ID = CDE.ITM_ID
  and TXT2.TXTT_CODE = 'ASRELEMENT'
  and TXT2.SEQ_NBR = 1
left outer join TEXT_ITEMS TXT3
  on TXT3.ITM_ID = CDE.ITM_ID
  and TXT3.TXTT_CODE = 'ASRSOURCE'
  and TXT3.SEQ_NBR = 1
where CDE.CDET_CODE = 'ASRTABLE';

--
-- ASR_SUMMARY_STATISTICS - ASR summary table statistics data
--
create or replace view ASR_SUMMARY_STATISTICS as
select STC.ASR_YEAR, STC.LOC_ID_RESIDENCE_COUNTRY, STC.ASR_TABLE_CODE,
  STC.START_VALUE, STC.END_VALUE, STG.UPDATE_TIMESTAMP, STG.UPDATE_USERID
from
 (select ASR_YEAR, LOC_ID_RESIDENCE_COUNTRY, ASR_TABLE_CODE, START_VALUE, END_VALUE
  from
   (select extract(year from START_DATE) as ASR_YEAR,
      case
        when STCT_CODE = 'REFRTN' then LOC_ID_ORIGIN_COUNTRY else LOC_ID_ASYLUM_COUNTRY
      end as LOC_ID_RESIDENCE_COUNTRY,
      case STCT_CODE
        when 'REFPOP' then 'RF'
        when 'ASYPOP' then 'AS'
        when 'REFRTN' then 'RT'
        when 'IDPHPOP' then 'ID'
        when 'IDPHRTN' then 'RD'
        when 'STAPOP' then 'ST'
        when 'OOCPOP' then 'OC'
      end as ASR_TABLE_CODE,
      case
        when STCT_CODE in ('REFRTN', 'IDPHRTN') then 'E'
        when extract(day from START_DATE) = 1 then 'S'
        else 'E'
      end as START_END_CODE,
      VALUE
    from T_STATISTICS
    where STCT_CODE in ('REFPOP', 'ASYPOP', 'REFRTN', 'IDPHPOP', 'IDPHRTN', 'STAPOP', 'OOCPOP'))
  pivot
   (sum(VALUE) as VALUE
    for START_END_CODE in ('S' as "START", 'E' as "END"))) STC
inner join T_STATISTIC_GROUPS STG
  on STG.START_DATE = to_date(to_char(STC.ASR_YEAR) || '-01-01', 'YYYY-MM-DD')
  and STG.END_DATE = to_date(to_char(STC.ASR_YEAR + 1) || '-01-01', 'YYYY-MM-DD')
  and nvl(STG.STTG_CODE, 'x') =
    case STC.ASR_TABLE_CODE
      when 'RF' then 'REFUGEE'
      when 'AS' then 'RSD'
      when 'RT' then 'RETURNEE'
      when 'ID' then 'IDP'
      when 'RD' then 'IDP'
      when 'ST' then 'STATELESS'
      when 'OC' then 'OOC'
    end
  and nvl(STG.DST_ID, 0) = 0
  and nvl(STG.LOC_ID_ASYLUM_COUNTRY, 0) =
    case when STC.ASR_TABLE_CODE != 'RT' then STC.LOC_ID_RESIDENCE_COUNTRY else 0 end
  and nvl(STG.LOC_ID_ASYLUM, 0) = 0
  and nvl(STG.LOC_ID_ORIGIN_COUNTRY, 0) =
    case when STC.ASR_TABLE_CODE = 'RT' then STC.LOC_ID_RESIDENCE_COUNTRY else 0 end
  and nvl(STG.LOC_ID_ORIGIN, 0) = 0
  and nvl(STG.DIM_ID1, 0) = 0
  and nvl(STG.DIM_ID2, 0) = 0
  and nvl(STG.DIM_ID3, 0) = 0
  and nvl(STG.DIM_ID4, 0) = 0
  and nvl(STG.DIM_ID5, 0) = 0
  and nvl(STG.SEX_CODE, 'x') = 'x'
  and nvl(STG.AGR_ID, 0) = 0
  and STG.SEQ_NBR is null;
