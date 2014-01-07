create table S_PPG_FOCUS 
 (CODE varchar2(5),
  DESCRIPTION varchar2(1000),
  START_DATE date,
  END_DATE date,
  GROUPTYPE varchar2(1),
  OPERATION_CODE varchar2(10),
  COUNTRY_GROUPING varchar2(1000),
  OPERATION varchar2(1000))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'PPG_FOCUS.bad'
    nodiscardfile
    logfile PSRLOG:'PPG_FOCUS.log'
    skip 1 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (CODE char(4000),
      DESCRIPTION char(4000),
      START_DATE date "YYYY-MM-DD",
      END_DATE date "YYYY-MM-DD",
      GROUPTYPE char(4000),
      OPERATION_CODE char(4000),
      COUNTRY_GROUPING char(4000),
      OPERATION char(4000)))
  location ('PPG_FOCUS.csv'))
reject limit unlimited;

grant select on S_PPG_FOCUS to PSR_STAGE;
