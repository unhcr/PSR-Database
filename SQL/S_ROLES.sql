create table S_ROLES
 (DESCRIPTION_EN varchar2(1000),
  COUNTRY_FLAG varchar2(1),
  DISPLAY_SEQ number(5),
  ACTIVE_FLAG varchar2(1),
  DESCRIPTION_FR varchar2(1000),
  NOTES varchar2(4000))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ROLES.bad'
    nodiscardfile
    logfile PSRLOG:'ROLES.log'
    skip 1 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (DESCRIPTION_EN char(4000),
      COUNTRY_FLAG char(4000),
      DISPLAY_SEQ char(4000),
      ACTIVE_FLAG char(4000),
      DESCRIPTION_FR char(4000),
      NOTES char(4000)))
  location ('ROLES.csv'))
reject limit unlimited;
  
grant select on S_ROLES to PSR_STAGE;
