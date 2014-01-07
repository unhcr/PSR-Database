create table S_PPG_CORRECTIONS 
 (STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(10),
  PPG_NAME varchar2(1000),
  CORRECTED_PPG_NAME varchar2(1000))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'PPG_CORRECTIONS.bad'
    nodiscardfile
    logfile PSRLOG:'PPG_CORRECTIONS.log'
    skip 1 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (STATSYEAR char(4000),
      COU_CODE_ASYLUM char(4000),
      PPG_NAME char(4000),
      CORRECTED_PPG_NAME char(4000)))
  location ('PPG_CORRECTIONS.csv'))
reject limit unlimited;

grant select on S_PPG_CORRECTIONS to PSR_STAGE;
