create table S_TEXT_TYPES 
 (CODE varchar2(10),
  DESCRIPTION_EN varchar2(1000),
  DISPLAY_SEQ number(5),
  DESCRIPTION_FR varchar2(1000),
  DESCRIPTION_ES varchar2(1000),
  DESCRIPTION_RU varchar2(1000),
  DESCRIPTION_AR varchar2(1000),
  DESCRIPTION_ZH varchar2(1000),
  NOTES varchar2(4000))
organization external
 (type oracle_loader
  default DIRECTORY PSRDATA
  access parameters 
   (records delimited by '\r\n'
    characterset UTF16
    badfile 'TEXT_TYPES.bad'
    nodiscardfile
    logfile PSRLOG:'TEXT_TYPES.log'
    skip 1 
    fields terminated by X'0009'
    lrtrim
    missing field values are null
     (CODE char(4000),
      DESCRIPTION_EN char(4000),
      DISPLAY_SEQ char(4000),
      DESCRIPTION_FR char(4000),
      DESCRIPTION_ES char(4000),
      DESCRIPTION_RU char(4000),
      DESCRIPTION_AR char(4000),
      DESCRIPTION_ZH char(4000),
      NOTES char(4000)))
  location ('TEXT_TYPES.tsv'))
reject limit unlimited;

grant select on S_TEXT_TYPES to PSR_STAGE;
