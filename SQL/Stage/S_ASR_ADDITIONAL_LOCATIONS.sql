create table S_ASR_ADDITIONAL_LOCATIONS
 (UNHCR_COUNTRY_CODE varchar2(3),
  COUNTRY_NAME varchar2(1000),
  LOCATION_NAME varchar2(1000),
  LOCATION_TYPE_DESCRIPTION varchar2(1000),
  LOCATION_TYPE_CODE varchar2(10))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_ADDITIONAL_LOCATIONS_2011.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_ADDITIONAL_LOCATIONS_2011.log'
    skip 1 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (UNHCR_COUNTRY_CODE char(4000),
      COUNTRY_NAME char(4000),
      LOCATION_NAME char(4000),
      LOCATION_TYPE_DESCRIPTION char(4000),
      LOCATION_TYPE_CODE char(4000)))
  location ('ASR_ADDITIONAL_LOCATIONS_2011.csv'))
reject limit unlimited;

grant select on S_ASR_ADDITIONAL_LOCATIONS to PSR_STAGE;
