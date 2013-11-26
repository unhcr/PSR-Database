create table S_PPG_FOCUS_USAGE 
 (MSRP_OPERATION varchar2(10),
  OPERATION_NAME varchar2(1000),
  MSRP_PPG varchar2(10),
  PPG_DESCRIPTION varchar2(1000),
  PLANNING_YEAR number(4),
  PLANNING_STAGE varchar2(100))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'PPG_FOCUS_USAGE.bad'
    nodiscardfile
    logfile PSRLOG:'PPG_FOCUS_USAGE.log'
    skip 1 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (MSRP_OPERATION char(4000),
      OPERATION_NAME char(4000),
      MSRP_PPG char(4000),
      PPG_DESCRIPTION char(4000),
      PLANNING_YEAR char(4000),
      PLANNING_STAGE char(4000)))
  location ('PPG_FOCUS_USAGE.csv'))
reject limit unlimited;

grant select on S_PPG_FOCUS_USAGE to PSR_STAGE;
