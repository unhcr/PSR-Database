create table S_ASR_OOC_2006_2012
 (STATSYEAR varchar2(4),
  DST_CODE varchar2(3),
  COU_CODE_ASYLUM varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  DESCRIPTION varchar2(1000),
  POP_START varchar2(40),
  POP_AH_START varchar2(40),
  OOCARR varchar2(40),
  OOCOTHINC varchar2(40),
  OOCRTN varchar2(40),
  OOCOTHDEC varchar2(40),
  POP_END varchar2(40),
  POP_AH_END varchar2(40),
  SOURCE varchar2(3),
  BASIS varchar2(2))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_OOC_2006_2012.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_OOC_2006_2012.log'
    skip 0 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      FILLER2 char(4000),
      STATSYEAR char(4000),
      COU_CODE_ASYLUM char(4000),
      COU_CODE_ORIGIN char(4000),
      DESCRIPTION char(4000),
      POP_START char(4000),
      POP_AH_START char(4000),
      OOCARR char(4000),
      OOCOTHINC char(4000),
      OOCRTN char(4000),
      OOCOTHDEC char(4000),
      POP_END char(4000),
      POP_AH_END char(4000),
      SOURCE char(4000),
      BASIS char(4000))
    column transforms
     (DST_CODE from constant 'OOC'))
  location ('ASR_OOC_2006_2012.csv'))
reject limit unlimited;


create or replace view S_ASR_OOC_CLEANED as
select ASR.STATSYEAR, ASR.DST_CODE, 
  upper(ASR.COU_CODE_ASYLUM) as COU_CODE_ASYLUM,
  upper(ASR.COU_CODE_ORIGIN) as COU_CODE_ORIGIN,
  ASR.DESCRIPTION,
  to_number(case when ASR.POP_START in ('-', '..') then null
                 else ASR.POP_START end) as POP_START,
  to_number(case when ASR.POP_AH_START in ('-', '..', ',') then null
                 else ASR.POP_AH_START end) as POP_AH_START,
  to_number(case when ASR.OOCARR in ('-', '..') then null
                 else ASR.OOCARR end) as OOCARR,
  to_number(case when ASR.OOCOTHINC in ('-', '..') then null
                 else ASR.OOCOTHINC end) as OOCOTHINC,
  to_number(case when ASR.OOCRTN in ('-', '..') then null
                 else ASR.OOCRTN end) as OOCRTN,
  to_number(case when ASR.OOCOTHDEC in ('-', '..') then null
                 else ASR.OOCOTHDEC end) as OOCOTHDEC,
  to_number(case when ASR.POP_END in ('-', '..') then null
                 else ASR.POP_END end) as POP_END,
  to_number(case when ASR.POP_AH_END in ('-', '..') then null
                 else ASR.POP_AH_END end) as POP_AH_END,
  case when SRC.SOURCE is null then upper(ASR.SOURCE) else SRC.CORRECTED_SOURCE end as SOURCE,
  case when BSC.BASIS is null then upper(ASR.BASIS) else BSC.CORRECTED_BASIS end as BASIS
from
 (select STATSYEAR, DST_CODE, COU_CODE_ASYLUM, COU_CODE_ORIGIN, DESCRIPTION,
    POP_START, POP_AH_START, OOCARR, OOCOTHINC, OOCRTN, OOCOTHDEC, POP_END, POP_AH_END,
    SOURCE, BASIS
  from S_ASR_OOC_2006_2012) ASR
left outer join S_SOURCE_CORRECTIONS SRC
  on SRC.SOURCE = ASR.SOURCE
left outer join S_BASIS_CORRECTIONS BSC
  on BSC.BASIS = ASR.BASIS;


create materialized view S_ASR_OOC build deferred as
select STATSYEAR, DST_CODE, COU_CODE_ASYLUM, COU_CODE_ORIGIN, DESCRIPTION,
  SOURCE, BASIS, DATA_POINT, VALUE
from
 (select STATSYEAR, DST_CODE, COU_CODE_ASYLUM, COU_CODE_ORIGIN, DESCRIPTION,
    STAGE.CHARAGG(SOURCE) as SOURCE,
    STAGE.CHARAGG(BASIS) as BASIS,
    round(sum(POP_START)) as POP_START,
    round(sum(POP_AH_START)) as POP_AH_START,
    round(sum(OOCARR)) as OOCARR,
    round(sum(OOCOTHINC)) as OOCOTHINC,
    round(sum(OOCRTN)) as OOCRTN,
    round(sum(OOCOTHDEC)) as OOCOTHDEC,
    round(sum(POP_END)) as POP_END,
    round(sum(POP_AH_END)) as POP_AH_END
  from S_ASR_OOC_CLEANED
  group by STATSYEAR, DST_CODE, COU_CODE_ASYLUM, COU_CODE_ORIGIN, DESCRIPTION)
unpivot
 (VALUE for DATA_POINT in
   (POP_START, POP_AH_START,
    OOCARR, OOCOTHINC, OOCRTN, OOCOTHDEC,
    POP_END, POP_AH_END))
where VALUE != 0;


grant select on S_ASR_OOC to PSR_STAGE;


/* Verification queries
select sum(ROW_COUNT) as RAW_ROW_COUNT,
  count(*) as AGGREGATED_ROW_COUNT,
  count(case when POP_START != 0 or POP_AH_START != 0 or OOCARR != 0 or OOCOTHINC != 0 or
    OOCRTN != 0 or OOCOTHDEC != 0 or POP_END != 0 or POP_AH_END != 0 then 1 end)
    as FILTERED_AGGREGATED_ROW_COUNT,
  count(*) * 8 as VALUE_COUNT,
  count(POP_START) + count(POP_AH_START) + count(OOCARR) + count(OOCOTHINC) + count(OOCRTN) +
    count(OOCOTHDEC) + count(POP_END) + count(POP_AH_END) as NON_NULL_COUNT,
  count(case when POP_START != 0 then 1 end) + count(case when POP_AH_START != 0 then 1 end) +
    count(case when OOCARR != 0 then 1 end) + count(case when OOCOTHINC != 0 then 1 end) +
    count(case when OOCRTN != 0 then 1 end) + count(case when OOCOTHDEC != 0 then 1 end) +
    count(case when POP_END != 0 then 1 end) + count(case when POP_AH_END != 0 then 1 end)
    as NON_ZERO_COUNT
from
 (select count(*) as ROW_COUNT,
  sum(POP_START) as POP_START, sum(POP_AH_START) as POP_AH_START, sum(OOCARR) as OOCARR,
    sum(OOCOTHINC) as OOCOTHINC, sum(OOCRTN) as OOCRTN, sum(OOCOTHDEC) as OOCOTHDEC,
    sum(POP_END) as POP_END, sum(POP_AH_END) as POP_AH_END
  from S_ASR_OOC_CLEANED
  group by STATSYEAR, DST_CODE, COU_CODE_ASYLUM, COU_CODE_ORIGIN, DESCRIPTION);

select count(*) as KEY_COUNT, sum(ROW_COUNT) as ROW_COUNT
from
 (select count(*) as ROW_COUNT
  from S_ASR_OOC
  group by STATSYEAR, DST_CODE, COU_CODE_ASYLUM, COU_CODE_ORIGIN, DESCRIPTION);
*/