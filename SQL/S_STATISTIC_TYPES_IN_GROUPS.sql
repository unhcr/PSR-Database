create table S_STATISTIC_TYPES_IN_GROUPS 
 (STCT_CODE varchar2(10),
  STTG_CODE varchar2(10),
  NOTES varchar2(4000))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile PSRDATA:'STATISTIC_TYPES_IN_GROUPS.bad'
    nodiscardfile
    logfile PSRLOG:'STATISTIC_TYPES_IN_GROUPS.log'
    skip 1 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (STCT_CODE char(4000),
      STTG_CODE char(4000),
      NOTES char(4000)))
  location ('STATISTIC_TYPES_IN_GROUPS.csv'))
reject limit unlimited;
  
grant select on S_STATISTIC_TYPES_IN_GROUPS to PSR_STAGE;
