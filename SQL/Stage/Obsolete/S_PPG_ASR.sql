create table S_PPG_ASR 
 (CODE varchar2(5),
  DESCRIPTION varchar2(1000),
  OPERATION varchar2(1000))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'PPG_ASR.bad'
    nodiscardfile
    logfile PSRLOG:'PPG_ASR.log'
    skip 1 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (CODE char(4000),
      DESCRIPTION char(4000),
      OPERATION char(4000)))
  location ('PPG_ASR.csv'))
reject limit unlimited;

grant select on S_PPG_ASR to PSR_STAGE;
