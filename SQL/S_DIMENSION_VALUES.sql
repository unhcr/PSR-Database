create table S_DIMENSION_VALUES 
 (DIMT_CODE varchar2(10),
  CODE varchar2(10),
  DESCRIPTION_EN varchar2(1000),
  START_DATE date,
  END_DATE date,
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
    badfile 'DIMENSION_VALUES.bad'
    nodiscardfile
    logfile PSRLOG:'DIMENSION_VALUES.log'
    skip 1 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (DIMT_CODE char(4000),
      CODE char(4000),
      DESCRIPTION_EN char(4000),
      START_DATE date "YYYY-MM-DD",
      END_DATE date "YYYY-MM-DD",
      DISPLAY_SEQ char(4000),
      ACTIVE_FLAG char(4000),
      DESCRIPTION_FR char(4000),
      NOTES char(4000)))
  location ('DIMENSION_VALUES.csv'))
reject limit unlimited;
  
grant select on S_DIMENSION_VALUES to PSR_STAGE;
