create table S_LOCATION_TYPE_VARIANTS 
 (LOCT_CODE varchar2(10),
  HCRCC varchar2(3),
  LOCRT_CODE varchar2(10),
  DESCRIPTION_EN varchar2(1000),
  DISPLAY_SEQ number(5),
  DESCRIPTION_FR varchar2(1000),
  NOTES varchar2(4000))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'LOCATION_TYPE_VARIANTS.bad'
    nodiscardfile
    logfile PSRLOG:'LOCATION_TYPE_VARIANTS.log'
    skip 1 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (LOCT_CODE char(4000),
      HCRCC char(4000),
      LOCRT_CODE char(4000),
      DESCRIPTION_EN char(4000),
      DISPLAY_SEQ char(4000),
      DESCRIPTION_FR char(4000),
      NOTES char(4000)))
  location ('LOCATION_TYPE_VARIANTS.csv'))
reject limit unlimited;

grant select on S_LOCATION_TYPE_VARIANTS to PSR_STAGE;
