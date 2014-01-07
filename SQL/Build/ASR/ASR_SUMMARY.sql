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
select ASR_YEAR, LOC_ID_RESIDENCE_COUNTRY, ASR_TABLE_CODE,
  START_VALUE, END_VALUE
from
 (select extract(year from START_DATE) as ASR_YEAR,
    case
      when STCT_CODE in ('REFRTN', 'IDPHRTN') then LOC_ID_ORIGIN_COUNTRY
      else LOC_ID_ASYLUM_COUNTRY
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
  for START_END_CODE in ('S' as "START", 'E' as "END"));
