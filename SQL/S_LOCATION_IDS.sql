create table S_LOCATION_IDS 
 (LOCT_CODE varchar2(10),
  LOCTV_DESCRIPTION_EN varchar2(1000),
  NAME_EN varchar2(1000),
  ISO_COUNTRY_CODE varchar2(3),
  START_DATE date,
  ID number(10))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n'
    badfile 'LOCATION_IDS.bad'
    nodiscardfile
    logfile PSRLOG:'LOCATION_IDS.log'
    skip 0 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (LOCT_CODE char(4000),
      LOCTV_DESCRIPTION_EN char(4000),
      NAME_EN char(4000),
      ISO_COUNTRY_CODE char(4000),
      START_DATE date "YYYY-MM-DD",
      ID char(4000)))
  location ('LOCATION_IDS.csv'))
reject limit unlimited;
  
grant select on S_LOCATION_IDS to PSR_STAGE;
