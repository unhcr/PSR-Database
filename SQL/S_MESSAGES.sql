create table S_MESSAGES 
 (COMP_CODE varchar2(10),
  MESSAGE_EN varchar2(1000),
  SEVERITY varchar2(1),
  SEQ_NBR number(5),
  MESSAGE_FR varchar2(1000),
  NOTES varchar2(4000))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'MESSAGES.bad'
    nodiscardfile
    logfile PSRLOG:'MESSAGES.log'
    skip 1 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (COMP_CODE char(4000),
      MESSAGE_EN char(4000),
      SEVERITY char(4000),
      SEQ_NBR char(4000),
      MESSAGE_FR char(4000),
      NOTES char(4000)))
  location ('MESSAGES.csv'))
reject limit unlimited;

grant select on S_MESSAGES to PSR_STAGE;
