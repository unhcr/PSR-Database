create table S_CODE_TEXT_ITEMS 
 (CDET_CODE varchar2(10),
  CODE varchar2(10),
  TXTT_CODE varchar2(10),
  TEXT_EN varchar2(1000),
  TEXT_FR varchar2(1000))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'CODE_TEXT_ITEMS.bad'
    nodiscardfile
    logfile PSRLOG:'CODE_TEXT_ITEMS.log'
    skip 1 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (CDET_CODE char(4000),
      CODE char(4000),
      TXTT_CODE char(4000),
      TEXT_EN char(4000),
      TEXT_FR char(4000)))
  location ('CODE_TEXT_ITEMS.csv'))
reject limit unlimited;
  
grant select on S_CODE_TEXT_ITEMS to PSR_STAGE;
