create table S_POPULATION_TYPE_CORRECTIONS
 (POPULATION_TYPE varchar2(1000),
  POPT_CODE varchar2(10))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'POPULATION_TYPE_CORRECTIONS.bad'
    nodiscardfile
    logfile PSRLOG:'POPULATION_TYPE_CORRECTIONS.log'
    skip 1
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (POPULATION_TYPE char(4000),
      POPT_CODE char(4000)))
  location ('POPULATION_TYPE_CORRECTIONS.csv'))
reject limit unlimited;

grant select on S_POPULATION_TYPE_CORRECTIONS to PSR_STAGE;
