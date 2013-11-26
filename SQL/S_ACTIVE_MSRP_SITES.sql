create table S_ACTIVE_MSRP_SITES 
 (SITE_CODE varchar2(10),
  SITE_NAME varchar2(1000),
  SITE_TYPE varchar2(1000))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ACTIVE_MSRP_SITES.bad'
    nodiscardfile
    logfile PSRLOG:'ACTIVE_MSRP_SITES.log'
    skip 1 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (SITE_CODE char(4000),
      SITE_NAME char(4000),
      SITE_TYPE char(4000)))
  location ('ACTIVE_MSRP_SITES.csv'))
reject limit unlimited;

grant select on S_ACTIVE_MSRP_SITES to PSR_STAGE;
