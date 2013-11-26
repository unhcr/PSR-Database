create table S_ACCOM_TYPE_CORRECTIONS 
 (ACCOMMODATION_TYPE varchar2(1000),
  ACMT_CODE varchar2(10))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ACCOM_TYPE_CORRECTIONS.bad'
    nodiscardfile
    logfile PSRLOG:'ACCOM_TYPE_CORRECTIONS.log'
    skip 1 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (ACCOMMODATION_TYPE char(4000),
      ACMT_CODE char(4000)))
  location ('ACCOM_TYPE_CORRECTIONS.csv'))
reject limit unlimited;

grant select on S_ACCOM_TYPE_CORRECTIONS to PSR_STAGE;
