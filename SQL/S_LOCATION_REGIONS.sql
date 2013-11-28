create table S_LOCATION_REGIONS 
 (KEY integer,
  NAME_EN varchar2(1000),
  LOCT_CODE varchar2(10),
  START_DATE date,
  END_DATE date,
  NAME_FR varchar2(1000),
  UNSDNUM varchar2(3),
  HCRCD varchar2(10),
  DISPLAYSEQ number(5),
  RSKEY varchar2(3),
  UNSD_FROM_KEY integer,
  UNSDA_FROM_KEY integer,
  RSGEO_FROM_KEY integer,
  HCRRESP_FROM_KEY integer,
  RSHCR_FROM_KEY integer,
  NOTES varchar2(4000))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'LOCATION_REGIONS.bad'
    nodiscardfile
    logfile PSRLOG:'LOCATION_REGIONS.log'
    skip 1 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (KEY char(4000),
      NAME_EN char(4000),
      LOCT_CODE char(4000),
      START_DATE date "YYYY-MM-DD",
      END_DATE date "YYYY-MM-DD",
      NAME_FR char(4000),
      UNSDNUM char(4000),
      HCRCD char(4000),
      DISPLAYSEQ char(4000),
      RSKEY char(4000),
      UNSD_FROM_KEY char(4000),
      UNSD_DESC char(4000),
      UNSDA_FROM_KEY char(4000),
      UNSDA_DESC char(4000),
      HCRRESP_FROM_KEY char(4000),
      HCRRESP_DESC char(4000),
      RSGEO_FROM_KEY char(4000),
      RSGEO_DESC char(4000),
      RSHCR_FROM_KEY char(4000),
      RSHCR_DESC char(4000),
      NOTES char(4000)))
  location ('LOCATION_REGIONS.csv'))
reject limit unlimited;

grant select on S_LOCATION_REGIONS to PSR_STAGE;
