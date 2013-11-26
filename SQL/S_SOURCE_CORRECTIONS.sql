create table S_SOURCE_CORRECTIONS 
 (SOURCE varchar2(1000),
  CORRECTED_SOURCE varchar2(4))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'SOURCE_CORRECTIONS.bad'
    nodiscardfile
    logfile PSRLOG:'SOURCE_CORRECTIONS.log'
    skip 1 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (SOURCE char(4000),
      CORRECTED_SOURCE char(4000)))
  location ('SOURCE_CORRECTIONS.csv'))
reject limit unlimited;

grant select on S_SOURCE_CORRECTIONS to PSR_STAGE;
