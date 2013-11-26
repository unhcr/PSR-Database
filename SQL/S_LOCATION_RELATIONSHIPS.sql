create table S_LOCATION_RELATIONSHIPS 
 (LOCT_CODE_FROM varchar2(10),
  LOC_NAME_FROM_EN varchar2(1000),
  LOC_CODE_FROM varchar2(10),
  LOC_START_DATE_FROM date,
  LOCRT_CODE varchar2(10),
  LOCR_START_DATE date,
  LOCR_END_DATE date,
  LOCT_CODE_TO varchar2(10),
  LOC_NAME_TO_EN varchar2(100),
  LOC_CODE_TO varchar2(10),
  LOC_START_DATE_TO date)
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'LOCATION_RELATIONSHIPS.bad'
    nodiscardfile
    logfile PSRLOG:'LOCATION_RELATIONSHIPS.log'
    skip 1 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (LOCT_CODE_FROM char(4000),
      LOC_NAME_FROM_EN char(4000),
      LOC_CODE_FROM char(4000),
      LOC_START_DATE_FROM date "YYYY-MM-DD",
      LOCRT_CODE char(4000),
      LOCR_START_DATE date "YYYY-MM-DD",
      LOCR_END_DATE date "YYYY-MM-DD",
      LOCT_CODE_TO char(4000),
      LOC_NAME_TO_EN char(4000),
      LOC_CODE_TO char(4000),
      LOC_START_DATE_TO date "YYYY-MM-DD"))
  location ('LOCATION_RELATIONSHIPS.csv'))
reject limit unlimited;

grant select on S_LOCATION_RELATIONSHIPS to PSR_STAGE;