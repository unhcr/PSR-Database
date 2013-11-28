create table S_PPG 
 (PPG_CODE varchar2(5),
  START_DATE date,
  END_DATE date,
  DESCRIPTION varchar2(1000),
  OPERATION varchar2(10))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'PPG.bad'
    nodiscardfile
    logfile PSRLOG:'PPG.log'
    skip 1 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (PPG_CODE char(4000),
      START_DATE date "YYYY-MM-DD",
      END_DATE date "YYYY-MM-DD",
      DESCRIPTION char(4000),
      OPERATION char(4000)))
  location ('PPG.csv'))
reject limit unlimited;

grant select on S_PPG to PSR_STAGE;
