create table S_DST_CODE_CORRECTIONS 
 (DISPLACEMENT_STATUS varchar2(1000),
  DST_CODE varchar2(3))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'DST_CODE_CORRECTIONS.bad'
    nodiscardfile
    logfile PSRLOG:'DST_CODE_CORRECTIONS.log'
    skip 1 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (DISPLACEMENT_STATUS char(4000),
      DST_CODE char(4000)))
  location ('DST_CODE_CORRECTIONS.csv'))
reject limit unlimited;

grant select on S_DST_CODE_CORRECTIONS to PSR_STAGE;
