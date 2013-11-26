create table S_STATISTIC_TYPES 
 (CODE varchar2(10),
  DESCRIPTION_EN varchar2(1000),
  DST_CODE_FLAG varchar2(1),
  LOC_ID_ASYLUM_COUNTRY_FLAG varchar2(1),
  LOC_ID_ASYLUM_FLAG varchar2(1),
  LOC_ID_ORIGIN_COUNTRY_FLAG varchar2(1),
  LOC_ID_ORIGIN_FLAG varchar2(1),
  DIM_ID1_FLAG varchar2(1),
  DIMT_CODE1 varchar2(10),
  DIM_ID2_FLAG varchar2(1),
  DIMT_CODE2 varchar2(10),
  DIM_ID3_FLAG varchar2(1),
  DIMT_CODE3 varchar2(10),
  DIM_ID4_FLAG varchar2(1),
  DIMT_CODE4 varchar2(10),
  DIM_ID5_FLAG varchar2(1),
  DIMT_CODE5 varchar2(10),
  SEX_CODE_FLAG varchar2(1),
  AGR_ID_FLAG varchar2(1),
  PGR_ID_SUBGROUP_FLAG varchar2(1),
  STTG_CODE1 varchar2(10),
  STTG_CODE2 varchar2(10),
  STTG_CODE3 varchar2(10),
  STTG_CODE4 varchar2(10),
  DISPLAY_SEQ number(5),
  DESCRIPTION_FR varchar2(1000),
  NOTES varchar2(4000))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'STATISTIC_TYPES.bad'
    nodiscardfile
    logfile PSRLOG:'STATISTIC_TYPES.log'
    skip 1 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (CODE char(4000),
      DESCRIPTION_EN char(4000),
      DST_CODE_FLAG char(4000),
      LOC_ID_ASYLUM_COUNTRY_FLAG char(4000),
      LOC_ID_ASYLUM_FLAG char(4000),
      LOC_ID_ORIGIN_COUNTRY_FLAG char(4000),
      LOC_ID_ORIGIN_FLAG char(4000),
      DIM_ID1_FLAG char(4000),
      DIMT_CODE1 char(4000),
      DIM_ID2_FLAG char(4000),
      DIMT_CODE2 char(4000),
      DIM_ID3_FLAG char(4000),
      DIMT_CODE3 char(4000),
      DIM_ID4_FLAG char(4000),
      DIMT_CODE4 char(4000),
      DIM_ID5_FLAG char(4000),
      DIMT_CODE5 char(4000),
      SEX_CODE_FLAG char(4000),
      AGR_ID_FLAG char(4000),
      PGR_ID_SUBGROUP_FLAG char(4000),
      STTG_CODE1 char(4000),
      STTG_CODE2 char(4000),
      STTG_CODE3 char(4000),
      STTG_CODE4 char(4000),
      DISPLAY_SEQ char(4000),
      DESCRIPTION_FR char(4000),
      NOTES char(4000)))
  location ('STATISTIC_TYPES.csv'))
reject limit unlimited;
  
grant select on S_STATISTIC_TYPES to PSR_STAGE;
