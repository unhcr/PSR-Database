create table S_LOCATION_REGION_NAMES 
 (KEY integer,
  NAME_EN varchar2(1000),
  TXTT_CODE varchar2(10),
  ALT_NAME_EN varchar2(1000))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'LOCATION_REGION_NAMES.bad'
    nodiscardfile
    logfile PSRLOG:'LOCATION_REGION_NAMES.log'
    skip 1 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (KEY char(4000),
      NAME_EN char(4000),
      TXTT_CODE char(4000),
      ALT_NAME_EN char(4000)))
  location ('LOCATION_REGION_NAMES.csv'))
reject limit unlimited;

grant select on S_LOCATION_REGION_NAMES to PSR_STAGE;
