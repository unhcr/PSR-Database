create table S_LANGUAGES
 (CODE varchar2(2),
  NAME_EN varchar2(1000),
  DISPLAY_SEQ number(5),
  ACTIVE_FLAG varchar2(1),
  NAME_FR varchar2(1000),
  NAME_ES varchar2(1000),
  NAME_RU varchar2(1000),
  NAME_AR varchar2(1000),
  NAME_ZH varchar2(1000),
  NOTES varchar2(4000))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset UTF8
    badfile 'LANGUAGES.bad'
    nodiscardfile
    logfile PSRLOG:'LANGUAGES.log'
    skip 1
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (CODE char(4000),
      NAME_EN char(4000),
      DISPLAY_SEQ char(4000),
      ACTIVE_FLAG char(4000),
      NAME_FR char(4000),
      NAME_ES char(4000),
      NAME_RU char(4000),
      NAME_AR char(4000),
      NAME_ZH char(4000),
      NOTES char(4000)))
  location ('LANGUAGES.csv'))
reject limit unlimited;

grant select on S_LANGUAGES to PSR_STAGE;
