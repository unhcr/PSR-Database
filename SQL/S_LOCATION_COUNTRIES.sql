create table S_LOCATION_COUNTRIES 
 (KEY integer,
  ISO3166A3 varchar2(3),
  ISO_NAME_EN varchar2(1000),
  LOCT_CODE varchar2(10),
  START_DATE date,
  END_DATE date,
  ISO3166A2 varchar2(2),
  ISO3166NUM varchar2(3),
  HCRCC varchar2(3),
  ISO_NAME_FR varchar2(1000),
  ISO_FULL_NAME_EN varchar2(1000),
  ISO_FULL_NAME_FR varchar2(1000),
  HCR_SHORT_NAME_EN varchar2(1000),
  HCR_SHORT_NAME_FR varchar2(1000),
  HCR_LONG_NAME_EN varchar2(1000),
  HCR_FORMAL_NAME_EN varchar2(1000),
  HCR_NATIONALITY varchar2(1000),
  GAWCC varchar2(5),
  GAACC varchar2(5),
  GAHCC varchar2(5),
  UNSD_FROM varchar2(3),
  HCRRESP_FROM1 varchar2(10),
  HCRRESP_FROM2 varchar2(10),
  CSPLIT_FROM_KEY integer,
  CMERGE_TO_KEY integer,
  CCHANGE_FROM_KEY integer,
  NOTES varchar2(4000))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'LOCATION_COUNTRIES.bad'
    nodiscardfile
    logfile PSRLOG:'LOCATION_COUNTRIES.log'
    skip 1 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (KEY char(4000),
      ISO3166A3 char(4000),
      ISO_NAME_EN char(4000),
      LOCT_CODE char(4000),
      START_DATE date "YYYY-MM-DD",
      END_DATE date "YYYY-MM-DD",
      ISO3166A2 char(4000),
      ISO3166NUM char(4000),
      HCRCC char(4000),
      ISO_NAME_FR char(4000),
      ISO_FULL_NAME_EN char(4000),
      ISO_FULL_NAME_FR char(4000),
      HCR_SHORT_NAME_EN char(4000),
      HCR_SHORT_NAME_FR char(4000),
      HCR_LONG_NAME_EN char(4000),
      HCR_FORMAL_NAME_EN char(4000),
      HCR_NATIONALITY char(4000),
      GAWCC char(4000),
      GAACC char(4000),
      GAHCC char(4000),
      UNSD_FROM char(4000),
      HCRRESP_FROM1 char(4000),
      HCRRESP_FROM2 char(4000),
      CSPLIT_FROM_KEY char(4000),
      CSPLIT_DESC char(4000),
      CMERGE_TO_KEY char(4000),
      CMERGE_DESC char(4000),
      CCHANGE_FROM_KEY char(4000),
      CCHANGE_DESC char(4000),
      NOTES char(4000)))
  location ('LOCATION_COUNTRIES.csv'))
reject limit unlimited;

grant select on S_LOCATION_COUNTRIES to PSR_STAGE;
