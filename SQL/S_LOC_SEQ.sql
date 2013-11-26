create table S_LOC_SEQ 
 (NEXTVAL number)
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n'
    badfile 'LOC_SEQ.bad'
    nodiscardfile
    logfile PSRLOG:'LOC_SEQ.log'
    skip 0 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (NEXTVAL char(4000)))
  location ('LOC_SEQ.csv'))
reject limit unlimited;
  
grant select on S_LOC_SEQ to PSR_STAGE;
