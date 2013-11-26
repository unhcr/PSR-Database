create table S_PPG_MSRP 
 (CODE varchar2(5),
  START_DATE date,
  END_DATE date,
  ACTIVE_FLAG varchar2(1),
  DESCRIPTION varchar2(1000))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'PPG_MSRP.bad'
    nodiscardfile
    logfile PSRLOG:'PPG_MSRP.log'
    skip 1 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (CODE char(4000),
      START_DATE date "YYYY-MM-DD",
      END_DATE date "YYYY-MM-DD",
      ACTIVE_FLAG char(4000),
      DESCRIPTION char(4000)))
  location ('PPG_MSRP.csv'))
reject limit unlimited;
  
grant select on S_PPG_MSRP to PSR_STAGE;
