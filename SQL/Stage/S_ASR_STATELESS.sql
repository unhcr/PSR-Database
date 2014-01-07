create table S_ASR_STATELESS_2004_2012
 (STATSYEAR varchar2(4),
  DST_CODE varchar2(3),
  COU_CODE_ASYLUM varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  POPULATION_TYPE varchar2(1000),
  DESCRIPTION varchar2(1000),
  POP_START varchar2(40),
  POP_AH_START varchar2(40),
  NATLOSS varchar2(40),
  STAOTHINC varchar2(40),
  NATACQ varchar2(40),
  STAOTHDEC varchar2(40),
  POP_END varchar2(40),
  POP_AH_END varchar2(40),
  SOURCE varchar2(4),
  BASIS varchar2(5))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_STATELESS_2004_2012.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_STATELESS_2004_2012.log'
    skip 0
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      STATSYEAR char(4000),
      COU_CODE_ASYLUM char(4000),
      COU_CODE_ORIGIN char(4000),
      POPULATION_TYPE char(4000),
      DESCRIPTION char(4000),
      POP_START char(4000),
      POP_AH_START char(4000),
      NATLOSS char(4000),
      STAOTHINC char(4000),
      NATACQ char(4000),
      STAOTHDEC char(4000),
      POP_END char(4000),
      POP_AH_END char(4000),
      SOURCE char(4000),
      BASIS char(4000))
    column transforms
     (DST_CODE from constant 'STA'))
  location ('ASR_STATELESS_2004_2012.csv'))
reject limit unlimited;


create or replace view S_ASR_STATELESS_CLEANED as
select ASR.STATSYEAR, ASR.DST_CODE, 
  upper(ASR.COU_CODE_ASYLUM) as COU_CODE_ASYLUM,
  upper(ASR.COU_CODE_ORIGIN) as COU_CODE_ORIGIN,
  PTC.POPT_CODE, ASR.DESCRIPTION,
  to_number(case when ASR.POP_START in ('-', '..') then null
                 else ASR.POP_START end) as POP_START,
  to_number(case when ASR.POP_AH_START in ('-', '..', ',') then null
                 else ASR.POP_AH_START end) as POP_AH_START,
  to_number(case when ASR.NATLOSS in ('-', '..') then null
                 else ASR.NATLOSS end) as NATLOSS,
  to_number(case when ASR.STAOTHINC in ('-', '..') then null
                 else ASR.STAOTHINC end) as STAOTHINC,
  to_number(case when ASR.NATACQ in ('-', '..') then null
                 else ASR.NATACQ end) as NATACQ,
  to_number(case when ASR.STAOTHDEC in ('-', '..') then null
                 else ASR.STAOTHDEC end) as STAOTHDEC,
  to_number(case when ASR.POP_END in ('-', '..') then null
                 else ASR.POP_END end) as POP_END,
  to_number(case when ASR.POP_AH_END in ('-', '..') then null
                 else ASR.POP_AH_END end) as POP_AH_END,
  case when SRC.SOURCE is null then upper(ASR.SOURCE) else SRC.CORRECTED_SOURCE end as SOURCE,
  case when BSC.BASIS is null then upper(ASR.BASIS) else BSC.CORRECTED_BASIS end as BASIS
from
 (select STATSYEAR, DST_CODE, COU_CODE_ASYLUM, COU_CODE_ORIGIN, DESCRIPTION, POPULATION_TYPE,
    POP_START, POP_AH_START, NATLOSS, STAOTHINC, NATACQ, STAOTHDEC, POP_END, POP_AH_END,
    SOURCE, BASIS
  from S_ASR_STATELESS_2004_2012) ASR
left outer join S_POPULATION_TYPE_CORRECTIONS PTC
  on PTC.POPULATION_TYPE = ASR.POPULATION_TYPE
left outer join S_SOURCE_CORRECTIONS SRC
  on SRC.SOURCE = ASR.SOURCE
left outer join S_BASIS_CORRECTIONS BSC
  on BSC.BASIS = ASR.BASIS;


create materialized view S_ASR_STATELESS build deferred as
select STATSYEAR, DST_CODE, COU_CODE_ASYLUM, COU_CODE_ORIGIN, DESCRIPTION, POPT_CODE,
  SOURCE, BASIS, DATA_POINT, VALUE
from
 (select STATSYEAR, DST_CODE, COU_CODE_ASYLUM, COU_CODE_ORIGIN, DESCRIPTION, POPT_CODE,
    CHARAGG(SOURCE) as SOURCE,
    CHARAGG(BASIS) as BASIS,
    round(sum(POP_START)) as POP_START,
    round(sum(POP_AH_START)) as POP_AH_START,
    round(sum(NATLOSS)) as NATLOSS,
    round(sum(STAOTHINC)) as STAOTHINC,
    round(sum(NATACQ)) as NATACQ,
    round(sum(STAOTHDEC)) as STAOTHDEC,
    round(sum(POP_END)) as POP_END,
    round(sum(POP_AH_END)) as POP_AH_END
  from S_ASR_STATELESS_CLEANED
  group by STATSYEAR, DST_CODE, COU_CODE_ASYLUM, COU_CODE_ORIGIN, DESCRIPTION, POPT_CODE)
unpivot
 (VALUE for DATA_POINT in
   (POP_START, POP_AH_START,
    NATLOSS, STAOTHINC, NATACQ, STAOTHDEC,
    POP_END, POP_AH_END))
where VALUE != 0;


grant select on S_ASR_STATELESS to PSR_STAGE;


/* Verification queries
select sum(ROW_COUNT) as RAW_ROW_COUNT,
  count(*) as AGGREGATED_ROW_COUNT,
  count(case when POP_START != 0 or POP_AH_START != 0 or NATLOSS != 0 or STAOTHINC != 0 or
    NATACQ != 0 or STAOTHDEC != 0 or POP_END != 0 or POP_AH_END != 0 then 1 end)
    as FILTERED_AGGREGATED_ROW_COUNT,
  count(*) * 8 as VALUE_COUNT,
  count(POP_START) + count(POP_AH_START) + count(NATLOSS) + count(STAOTHINC) + count(NATACQ) +
    count(STAOTHDEC) + count(POP_END) + count(POP_AH_END) as NON_NULL_COUNT,
  count(case when POP_START != 0 then 1 end) + count(case when POP_AH_START != 0 then 1 end) +
    count(case when NATLOSS != 0 then 1 end) + count(case when STAOTHINC != 0 then 1 end) +
    count(case when NATACQ != 0 then 1 end) + count(case when STAOTHDEC != 0 then 1 end) +
    count(case when POP_END != 0 then 1 end) + count(case when POP_AH_END != 0 then 1 end)
    as NON_ZERO_COUNT
from
 (select count(*) as ROW_COUNT,
  sum(POP_START) as POP_START, sum(POP_AH_START) as POP_AH_START, sum(NATLOSS) as NATLOSS,
    sum(STAOTHINC) as STAOTHINC, sum(NATACQ) as NATACQ, sum(STAOTHDEC) as STAOTHDEC,
    sum(POP_END) as POP_END, sum(POP_AH_END) as POP_AH_END
  from S_ASR_STATELESS_CLEANED
  group by STATSYEAR, DST_CODE, COU_CODE_ASYLUM, COU_CODE_ORIGIN, DESCRIPTION, POPT_CODE);

select count(*) as KEY_COUNT, sum(ROW_COUNT) as ROW_COUNT
from
 (select count(*) as ROW_COUNT
  from S_ASR_STATELESS
  group by STATSYEAR, DST_CODE, COU_CODE_ASYLUM, COU_CODE_ORIGIN, DESCRIPTION, POPT_CODE);
*/