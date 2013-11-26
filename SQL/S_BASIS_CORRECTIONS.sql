create table S_BASIS_CORRECTIONS 
 (BASIS varchar2(1000),
  CORRECTED_BASIS varchar2(4))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'BASIS_CORRECTIONS.bad'
    nodiscardfile
    logfile PSRLOG:'BASIS_CORRECTIONS.log'
    skip 1 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (BASIS char(4000),
      CORRECTED_BASIS char(4000)))
  location ('BASIS_CORRECTIONS.csv'))
reject limit unlimited;

grant select on S_BASIS_CORRECTIONS to PSR_STAGE;
