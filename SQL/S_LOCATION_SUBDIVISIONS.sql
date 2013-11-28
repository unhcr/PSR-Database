create table S_LOCATION_SUBDIVISIONS
 (COU_CODE varchar2(3),
  COU_START_DATE date,
  LOCATION_NAME_EN varchar2(1000),
  MSRP_CODE varchar2(10),
  HLEVEL integer,
  LOCT_CODE varchar2(10),
  LOC_TYPE_DESCRIPTION_EN varchar2(1000),
  LOC_START_DATE date,
  LOC_END_DATE date,
  LOCR_START_DATE date,
  LOCR_END_DATE date,
  COU_CODE_PREV varchar2(3),
  COU_START_DATE_PREV date)
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'LOCATION_SUBDIVISIONS.bad'
    nodiscardfile
    logfile PSRLOG:'LOCATION_SUBDIVISIONS.log'
    skip 1 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (COU_CODE char(4000),
      COU_START_DATE date "YYYY-MM-DD",
      LOCATION_NAME_EN char(4000),
      MSRP_CODE char(4000),
      HLEVEL char(4000),
      LOCT_CODE char(4000),
      LOC_TYPE_DESCRIPTION_EN char(4000),
      LOC_START_DATE date "YYYY-MM-DD",
      LOC_END_DATE date "YYYY-MM-DD",
      LOCR_START_DATE date "YYYY-MM-DD",
      LOCR_END_DATE date "YYYY-MM-DD",
      COU_CODE_PREV char(4000),
      COU_START_DATE_PREV date "YYYY-MM-DD"))
  location ('LOCATION_SUBDIVISIONS.csv'))
reject limit unlimited;

grant select on S_LOCATION_SUBDIVISIONS to PSR_STAGE;
