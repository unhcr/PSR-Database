create table S_LOCATION_NAME_CORRECTIONS 
 (COU_CODE varchar2(3),
  LOCATION_NAME varchar2(1000),
  NEW_LOCATION_NAME varchar2(1000),
  CORRECTED_LOCATION_NAME varchar2(1000))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'LOCATION_NAME_CORRECTIONS.bad'
    nodiscardfile
    logfile PSRLOG:'LOCATION_NAME_CORRECTIONS.log'
    skip 1 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (COU_CODE char(4000),
      LOCATION_NAME char(4000),
      NEW_LOCATION_NAME char(4000),
      CORRECTED_LOCATION_NAME char(4000)))
  location ('LOCATION_NAME_CORRECTIONS.csv'))
reject limit unlimited;

grant select on S_LOCATION_NAME_CORRECTIONS to PSR_STAGE;
