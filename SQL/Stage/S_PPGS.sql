create table S_PPGS
 (PPG_CODE varchar2(5),
  START_DATE date,
  END_DATE date,
  DESCRIPTION varchar2(1000),
  OPERATION varchar2(10),
  LOCATION_NAME_EN varchar2(1000))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'PPGS.bad'
    nodiscardfile
    logfile PSRLOG:'PPGS.log'
    skip 1 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (PPG_CODE char(4000),
      START_DATE date "YYYY-MM-DD",
      END_DATE date "YYYY-MM-DD",
      DESCRIPTION char(4000),
      OPERATION char(4000),
      LOCATION_NAME_EN char(4000)))
  location ('PPGS.csv'))
reject limit unlimited;

create materialized view S_COUNTRY_PPGS build deferred as
with Q_CPG as
 (select upper(COU.HCRCC) as COU_CODE,
    greatest(coalesce(PPG.START_DATE, COU.START_DATE, date '0001-01-01'),
             coalesce(COU.START_DATE, PPG.START_DATE, date '0001-01-01')) as START_DATE,
    least(coalesce(PPG.END_DATE, COU.END_DATE, timestamp '9999-12-31 23:59:59'),
          coalesce(COU.END_DATE, PPG.END_DATE, timestamp '9999-12-31 23:59:59')) as END_DATE,
    upper(PPG.DESCRIPTION) as DESCRIPTION, PPG.LOCATION_NAME_EN, PPG.OPERATION, PPG.PPG_CODE
  from S_PPGS PPG
  inner join S_LOCATION_COUNTRIES COU
    on (COU.HCRRESP_FROM2 = PPG.OPERATION
      or COU.ISO3166A3 = PPG.OPERATION)
    and nvl(COU.START_DATE, date '0001-01-01') < nvl(PPG.END_DATE, timestamp '9999-12-31 23:59:59')
    and nvl(COU.END_DATE, timestamp '9999-12-31 23:59:59') > nvl(PPG.START_DATE, date '0001-01-01'))
--
select CPG.COU_CODE, CPG.START_DATE, CPG.END_DATE, CPG.DESCRIPTION, CPG.LOCATION_NAME_EN,
  CPG.PPG_CODE
from Q_CPG CPG
where not exists
 (select null
  from Q_CPG CPG1
  where CPG1.COU_CODE = CPG.COU_CODE
  and CPG1.START_DATE < CPG.END_DATE
  and CPG1.END_DATE > CPG.START_DATE
  and CPG1.DESCRIPTION = CPG.DESCRIPTION
  and (nvl(CPG1.LOCATION_NAME_EN, CPG.LOCATION_NAME_EN) is null
    or CPG1.LOCATION_NAME_EN = CPG.LOCATION_NAME_EN)
  and CPG1.OPERATION not like '% RO'
  and CPG.OPERATION like '% RO')
and not exists
 (select null
  from S_LOCATION_RELATIONSHIPS LOCR
  where LOCR.LOC_CODE_FROM = CPG.OPERATION
  and LOCR.LOCT_CODE_FROM = 'HCR-COP'
  and LOCR.LOCRT_CODE = 'HCRRESP')
union all
select upper(COU.HCRCC) as COU_CODE,
  greatest(coalesce(PPG.START_DATE, LOCR.LOCR_START_DATE, date '0001-01-01'),
           coalesce(LOCR.LOCR_START_DATE, PPG.START_DATE, date '0001-01-01')) as START_DATE,
  least(coalesce(PPG.END_DATE, LOCR.LOCR_END_DATE, timestamp '9999-12-31 23:59:59'),
        coalesce(LOCR.LOCR_END_DATE, PPG.END_DATE, timestamp '9999-12-31 23:59:59')) as END_DATE,
  upper(PPG.DESCRIPTION) as DESCRIPTION, PPG.LOCATION_NAME_EN, PPG.PPG_CODE
from S_PPGS PPG
inner join S_LOCATION_RELATIONSHIPS LOCR
  on LOCR.LOC_CODE_FROM = PPG.OPERATION
  and LOCR.LOCRT_CODE = 'HCRRESP'
  and nvl(LOCR.LOCR_START_DATE, date '0001-01-01') < nvl(PPG.END_DATE, timestamp '9999-12-31 23:59:59')
  and nvl(LOCR.LOCR_END_DATE, timestamp '9999-12-31 23:59:59') > nvl(PPG.START_DATE, date '0001-01-01')
inner join S_LOCATION_COUNTRIES COU
  on COU.ISO3166A3 = LOCR.LOC_CODE_TO
  and nvl(COU.START_DATE, date '0001-01-01') < nvl(PPG.END_DATE, timestamp '9999-12-31 23:59:59')
  and nvl(COU.END_DATE, timestamp '9999-12-31 23:59:59') > nvl(PPG.START_DATE, date '0001-01-01');

grant select on S_PPGS to PSR_STAGE;
grant select on S_COUNTRY_PPGS to PSR_STAGE;