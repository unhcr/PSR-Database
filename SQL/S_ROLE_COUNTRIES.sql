create table S_ROLE_COUNTRIES
 (DESCRIPTION_EN varchar2(1000),
  ISO_COUNTRY_CODE varchar2(3),
  NOTES varchar2(4000))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ROLE_COUNTRIES.bad'
    nodiscardfile
    logfile PSRLOG:'ROLE_COUNTRIES.log'
    skip 1 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (DESCRIPTION_EN char(4000),
      ISO_COUNTRY_CODE char(4000),
      NOTES char(4000)))
  location ('ROLE_COUNTRIES.csv'))
reject limit unlimited;
  
grant select on S_ROLE_COUNTRIES to PSR_STAGE;
