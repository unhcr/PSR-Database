create table S_PERMISSIONS
 (DESCRIPTION_EN varchar2(1000),
  WRITE_FLAG varchar2(1),
  ANNOTATE_FLAG varchar2(1),
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
    badfile 'PERMISSIONS.bad'
    nodiscardfile
    logfile PSRLOG:'PERMISSIONS.log'
    skip 1 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (DESCRIPTION_EN char(4000),
      WRITE_FLAG char(4000),
      ANNOTATE_FLAG char(4000),
      DISPLAY_SEQ char(4000),
      ACTIVE_FLAG char(4000),
      DESCRIPTION_FR char(4000),
      NOTES char(4000)))
  location ('PERMISSIONS.csv'))
reject limit unlimited;
  
grant select on S_PERMISSIONS to PSR_STAGE;
