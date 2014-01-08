create table S_ASR_DEMOGRAPHICS_2000
 (STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(3),
  LOCATION_NAME varchar2(1000),
  NEW_LOCATION_NAME varchar2(1000),
  URBAN_RURAL_STATUS varchar2(3),
  ACCOMMODATION_TYPE varchar2(100),
  DISPLACEMENT_STATUS varchar2(20),
  COU_CODE_ORIGIN varchar2(10),
  PPG_NAME varchar2(1000),
  F0 varchar2(40),
  F5 varchar2(40),
  F12 varchar2(40),
  F18 varchar2(40),
  F60 varchar2(40),
  FOTHER varchar2(40),
  FTOTAL varchar2(40),
  M0 varchar2(40),
  M5 varchar2(40),
  M12 varchar2(40),
  M18 varchar2(40),
  M60 varchar2(40),
  MOTHER varchar2(40),
  MTOTAL varchar2(40),
  TOTAL varchar2(40),
  BASIS varchar2(5))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_DEMOGRAPHICS_2000.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_DEMOGRAPHICS_2000.log'
    skip 0
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      FILLER2 char(4000),
      FILLER3 char(4000),
      COU_CODE_ASYLUM char(4000),
      LOCATION_NAME char(4000),
      DISPLACEMENT_STATUS char(4000),
      URBAN_RURAL_STATUS char(4000),
      COU_CODE_ORIGIN char(4000),
      F0 char(4000),
      F5 char(4000),
      F18 char(4000),
      F60 char(4000),
      FOTHER char(4000),
      FTOTAL char(4000),
      M0 char(4000),
      M5 char(4000),
      M18 char(4000),
      M60 char(4000),
      MOTHER char(4000),
      MTOTAL char(4000),
      FILLER4 char(4000),
      TOTAL char(4000),
      BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2000',
      NEW_LOCATION_NAME from null,
      ACCOMMODATION_TYPE from null,
      PPG_NAME from null,
      F12 from null,
      M12 from null))
  location ('ASR_DEMOGRAPHICS_2000.csv'))
reject limit unlimited;

create table S_ASR_DEMOGRAPHICS_2001
 (STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(3),
  LOCATION_NAME varchar2(1000),
  NEW_LOCATION_NAME varchar2(1000),
  URBAN_RURAL_STATUS varchar2(3),
  ACCOMMODATION_TYPE varchar2(100),
  DISPLACEMENT_STATUS varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  PPG_NAME varchar2(1000),
  F0 varchar2(40),
  F5 varchar2(40),
  F12 varchar2(40),
  F18 varchar2(40),
  F60 varchar2(40),
  FOTHER varchar2(40),
  FTOTAL varchar2(40),
  M0 varchar2(40),
  M5 varchar2(40),
  M12 varchar2(40),
  M18 varchar2(40),
  M60 varchar2(40),
  MOTHER varchar2(40),
  MTOTAL varchar2(40),
  TOTAL varchar2(40),
  BASIS varchar2(5))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_DEMOGRAPHICS_2001.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_DEMOGRAPHICS_2001.log'
    skip 0
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      FILLER2 char(4000),
      COU_CODE_ASYLUM char(4000),
      LOCATION_NAME char(4000),
      DISPLACEMENT_STATUS char(4000),
      URBAN_RURAL_STATUS char(4000),
      COU_CODE_ORIGIN char(4000),
      F0 char(4000),
      F5 char(4000),
      F18 char(4000),
      F60 char(4000),
      FOTHER char(4000),
      FTOTAL char(4000),
      M0 char(4000),
      M5 char(4000),
      M18 char(4000),
      M60 char(4000),
      MOTHER char(4000),
      MTOTAL char(4000),
      TOTAL char(4000),
      BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2001',
      NEW_LOCATION_NAME from null,
      ACCOMMODATION_TYPE from null,
      PPG_NAME from null,
      F12 from null,
      M12 from null))
  location ('ASR_DEMOGRAPHICS_2001.csv'))
reject limit unlimited;

create table S_ASR_DEMOGRAPHICS_2002
 (STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(3),
  LOCATION_NAME varchar2(1000),
  NEW_LOCATION_NAME varchar2(1000),
  URBAN_RURAL_STATUS varchar2(3),
  ACCOMMODATION_TYPE varchar2(100),
  DISPLACEMENT_STATUS varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  PPG_NAME varchar2(1000),
  F0 varchar2(40),
  F5 varchar2(40),
  F12 varchar2(40),
  F18 varchar2(40),
  F60 varchar2(40),
  FOTHER varchar2(40),
  FTOTAL varchar2(40),
  M0 varchar2(40),
  M5 varchar2(40),
  M12 varchar2(40),
  M18 varchar2(40),
  M60 varchar2(40),
  MOTHER varchar2(40),
  MTOTAL varchar2(40),
  TOTAL varchar2(40),
  BASIS varchar2(10))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_DEMOGRAPHICS_2002.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_DEMOGRAPHICS_2002.log'
    skip 0
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      FILLER2 char(4000),
      FILLER3 char(4000),
      FILLER4 char(4000),
      FILLER5 char(4000),
      COU_CODE_ASYLUM char(4000),
      URBAN_RURAL_STATUS char(4000),
      LOCATION_NAME char(4000),
      DISPLACEMENT_STATUS char(4000),
      COU_CODE_ORIGIN char(4000),
      F0 char(4000),
      F5 char(4000),
      F18 char(4000),
      F60 char(4000),
      FOTHER char(4000),
      FTOTAL char(4000),
      M0 char(4000),
      M5 char(4000),
      M18 char(4000),
      M60 char(4000),
      MOTHER char(4000),
      MTOTAL char(4000),
      TOTAL char(4000),
      FILLER6 char(4000),
      FILLER7 char(4000),
      BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2002',
      NEW_LOCATION_NAME from null,
      ACCOMMODATION_TYPE from null,
      PPG_NAME from null,
      F12 from null,
      M12 from null))
  location ('ASR_DEMOGRAPHICS_2002.csv'))
reject limit unlimited;

create table S_ASR_DEMOGRAPHICS_2003
 (STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(3),
  LOCATION_NAME varchar2(1000),
  NEW_LOCATION_NAME varchar2(1000),
  URBAN_RURAL_STATUS varchar2(1),
  ACCOMMODATION_TYPE varchar2(100),
  DISPLACEMENT_STATUS varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  PPG_NAME varchar2(1000),
  F0 varchar2(40),
  F5 varchar2(40),
  F12 varchar2(40),
  F18 varchar2(40),
  F60 varchar2(40),
  FOTHER varchar2(40),
  FTOTAL varchar2(40),
  M0 varchar2(40),
  M5 varchar2(40),
  M12 varchar2(40),
  M18 varchar2(40),
  M60 varchar2(40),
  MOTHER varchar2(40),
  MTOTAL varchar2(40),
  TOTAL varchar2(40),
  BASIS varchar2(5))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_DEMOGRAPHICS_2003.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_DEMOGRAPHICS_2003.log'
    skip 0
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      FILLER2 char(4000),
      FILLER3 char(4000),
      FILLER4 char(4000),
      FILLER5 char(4000),
      COU_CODE_ASYLUM char(4000),
      URBAN_RURAL_STATUS char(4000),
      LOCATION_NAME char(4000),
      DISPLACEMENT_STATUS char(4000),
      COU_CODE_ORIGIN char(4000),
      F0 char(4000),
      F5 char(4000),
      F18 char(4000),
      F60 char(4000),
      FOTHER char(4000),
      FTOTAL char(4000),
      M0 char(4000),
      M5 char(4000),
      M18 char(4000),
      M60 char(4000),
      MOTHER char(4000),
      MTOTAL char(4000),
      TOTAL char(4000),
      BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2003',
      NEW_LOCATION_NAME from null,
      ACCOMMODATION_TYPE from null,
      PPG_NAME from null,
      F12 from null,
      M12 from null))
  location ('ASR_DEMOGRAPHICS_2003.csv'))
reject limit unlimited;

create table S_ASR_DEMOGRAPHICS_2004
 (STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(3),
  LOCATION_NAME varchar2(1000),
  NEW_LOCATION_NAME varchar2(1000),
  URBAN_RURAL_STATUS varchar2(1),
  ACCOMMODATION_TYPE varchar2(100),
  DISPLACEMENT_STATUS varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  PPG_NAME varchar2(1000),
  F0 varchar2(40),
  F5 varchar2(40),
  F12 varchar2(40),
  F18 varchar2(40),
  F60 varchar2(40),
  FOTHER varchar2(40),
  FTOTAL varchar2(40),
  M0 varchar2(40),
  M5 varchar2(40),
  M12 varchar2(40),
  M18 varchar2(40),
  M60 varchar2(40),
  MOTHER varchar2(40),
  MTOTAL varchar2(40),
  TOTAL varchar2(40),
  BASIS varchar2(5))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_DEMOGRAPHICS_2004.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_DEMOGRAPHICS_2004.log'
    skip 0
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      FILLER2 char(4000),
      FILLER3 char(4000),
      FILLER4 char(4000),
      FILLER5 char(4000),
      COU_CODE_ASYLUM char(4000),
      URBAN_RURAL_STATUS char(4000),
      LOCATION_NAME char(4000),
      DISPLACEMENT_STATUS char(4000),
      COU_CODE_ORIGIN char(4000),
      F0 char(4000),
      F5 char(4000),
      F18 char(4000),
      F60 char(4000),
      FOTHER char(4000),
      FTOTAL char(4000),
      M0 char(4000),
      M5 char(4000),
      M18 char(4000),
      M60 char(4000),
      MOTHER char(4000),
      MTOTAL char(4000),
      TOTAL char(4000),
      BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2004',
      NEW_LOCATION_NAME from null,
      ACCOMMODATION_TYPE from null,
      PPG_NAME from null,
      F12 from null,
      M12 from null))
  location ('ASR_DEMOGRAPHICS_2004.csv'))
reject limit unlimited;

create table S_ASR_DEMOGRAPHICS_2005
 (STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(3),
  LOCATION_NAME varchar2(1000),
  NEW_LOCATION_NAME varchar2(1000),
  URBAN_RURAL_STATUS varchar2(1),
  ACCOMMODATION_TYPE varchar2(100),
  DISPLACEMENT_STATUS varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  PPG_NAME varchar2(1000),
  F0 varchar2(40),
  F5 varchar2(40),
  F12 varchar2(40),
  F18 varchar2(40),
  F60 varchar2(40),
  FOTHER varchar2(40),
  FTOTAL varchar2(40),
  M0 varchar2(40),
  M5 varchar2(40),
  M12 varchar2(40),
  M18 varchar2(40),
  M60 varchar2(40),
  MOTHER varchar2(40),
  MTOTAL varchar2(40),
  TOTAL varchar2(40),
  BASIS varchar2(5))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_DEMOGRAPHICS_2005.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_DEMOGRAPHICS_2005.log'
    skip 0
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      FILLER2 char(4000),
      FILLER3 char(4000),
      FILLER4 char(4000),
      FILLER5 char(4000),
      COU_CODE_ASYLUM char(4000),
      URBAN_RURAL_STATUS char(4000),
      LOCATION_NAME char(4000),
      DISPLACEMENT_STATUS char(4000),
      COU_CODE_ORIGIN char(4000),
      F0 char(4000),
      F5 char(4000),
      F18 char(4000),
      F60 char(4000),
      FOTHER char(4000),
      FTOTAL char(4000),
      M0 char(4000),
      M5 char(4000),
      M18 char(4000),
      M60 char(4000),
      MOTHER char(4000),
      MTOTAL char(4000),
      TOTAL char(4000),
      BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2005',
      NEW_LOCATION_NAME from null,
      ACCOMMODATION_TYPE from null,
      PPG_NAME from null,
      F12 from null,
      M12 from null))
  location ('ASR_DEMOGRAPHICS_2005.csv'))
reject limit unlimited;

create table S_ASR_DEMOGRAPHICS_2006
 (STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(3),
  LOCATION_NAME varchar2(1000),
  NEW_LOCATION_NAME varchar2(1000),
  URBAN_RURAL_STATUS varchar2(1),
  ACCOMMODATION_TYPE varchar2(100),
  DISPLACEMENT_STATUS varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  PPG_NAME varchar2(1000),
  F0 varchar2(40),
  F5 varchar2(40),
  F12 varchar2(40),
  F18 varchar2(40),
  F60 varchar2(40),
  FOTHER varchar2(40),
  FTOTAL varchar2(40),
  M0 varchar2(40),
  M5 varchar2(40),
  M12 varchar2(40),
  M18 varchar2(40),
  M60 varchar2(40),
  MOTHER varchar2(40),
  MTOTAL varchar2(40),
  TOTAL varchar2(40),
  BASIS varchar2(5))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_DEMOGRAPHICS_2006.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_DEMOGRAPHICS_2006.log'
    skip 0
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      FILLER2 char(4000),
      FILLER3 char(4000),
      FILLER4 char(4000),
      FILLER5 char(4000),
      COU_CODE_ASYLUM char(4000),
      LOCATION_NAME char(4000),
      URBAN_RURAL_STATUS char(4000),
      DISPLACEMENT_STATUS char(4000),
      COU_CODE_ORIGIN char(4000),
      F0 char(4000),
      F5 char(4000),
      F12 char(4000),
      F18 char(4000),
      F60 char(4000),
      FOTHER char(4000),
      FTOTAL char(4000),
      M0 char(4000),
      M5 char(4000),
      M12 char(4000),
      M18 char(4000),
      M60 char(4000),
      MOTHER char(4000),
      MTOTAL char(4000),
      TOTAL char(4000),
      BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2006',
      NEW_LOCATION_NAME from null,
      ACCOMMODATION_TYPE from null,
      PPG_NAME from null))
  location ('ASR_DEMOGRAPHICS_2006.csv'))
reject limit unlimited;

create table S_ASR_DEMOGRAPHICS_2007
 (STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(3),
  LOCATION_NAME varchar2(1000),
  NEW_LOCATION_NAME varchar2(1000),
  URBAN_RURAL_STATUS varchar2(1),
  ACCOMMODATION_TYPE varchar2(100),
  DISPLACEMENT_STATUS varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  PPG_NAME varchar2(1000),
  F0 varchar2(40),
  F5 varchar2(40),
  F12 varchar2(40),
  F18 varchar2(40),
  F60 varchar2(40),
  FOTHER varchar2(40),
  FTOTAL varchar2(40),
  M0 varchar2(40),
  M5 varchar2(40),
  M12 varchar2(40),
  M18 varchar2(40),
  M60 varchar2(40),
  MOTHER varchar2(40),
  MTOTAL varchar2(40),
  TOTAL varchar2(40),
  BASIS varchar2(5))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_DEMOGRAPHICS_2007.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_DEMOGRAPHICS_2007.log'
    skip 0
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      FILLER2 char(4000),
      FILLER3 char(4000),
      FILLER4 char(4000),
      FILLER5 char(4000),
      COU_CODE_ASYLUM char(4000),
      LOCATION_NAME char(4000),
      URBAN_RURAL_STATUS char(4000),
      DISPLACEMENT_STATUS char(4000),
      COU_CODE_ORIGIN char(4000),
      F0 char(4000),
      F5 char(4000),
      F12 char(4000),
      F18 char(4000),
      F60 char(4000),
      FOTHER char(4000),
      FTOTAL char(4000),
      M0 char(4000),
      M5 char(4000),
      M12 char(4000),
      M18 char(4000),
      M60 char(4000),
      MOTHER char(4000),
      MTOTAL char(4000),
      TOTAL char(4000),
      BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2007',
      NEW_LOCATION_NAME from null,
      ACCOMMODATION_TYPE from null,
      PPG_NAME from null))
  location ('ASR_DEMOGRAPHICS_2007.csv'))
reject limit unlimited;

create table S_ASR_DEMOGRAPHICS_2008
 (STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(3),
  LOCATION_NAME varchar2(1000),
  NEW_LOCATION_NAME varchar2(1000),
  URBAN_RURAL_STATUS varchar2(1),
  ACCOMMODATION_TYPE varchar2(100),
  DISPLACEMENT_STATUS varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  PPG_NAME varchar2(1000),
  F0 varchar2(40),
  F5 varchar2(40),
  F12 varchar2(40),
  F18 varchar2(40),
  F60 varchar2(40),
  FOTHER varchar2(40),
  FTOTAL varchar2(40),
  M0 varchar2(40),
  M5 varchar2(40),
  M12 varchar2(40),
  M18 varchar2(40),
  M60 varchar2(40),
  MOTHER varchar2(40),
  MTOTAL varchar2(40),
  TOTAL varchar2(40),
  BASIS varchar2(5))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_DEMOGRAPHICS_2008.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_DEMOGRAPHICS_2008.log'
    skip 0
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      FILLER2 char(4000),
      FILLER3 char(4000),
      FILLER4 char(4000),
      FILLER5 char(4000),
      COU_CODE_ASYLUM char(4000),
      LOCATION_NAME char(4000),
      URBAN_RURAL_STATUS char(4000),
      DISPLACEMENT_STATUS char(4000),
      COU_CODE_ORIGIN char(4000),
      F0 char(4000),
      F5 char(4000),
      F12 char(4000),
      F18 char(4000),
      F60 char(4000),
      FOTHER char(4000),
      FTOTAL char(4000),
      M0 char(4000),
      M5 char(4000),
      M12 char(4000),
      M18 char(4000),
      M60 char(4000),
      MOTHER char(4000),
      MTOTAL char(4000),
      TOTAL char(4000),
      BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2008',
      NEW_LOCATION_NAME from null,
      ACCOMMODATION_TYPE from null,
      PPG_NAME from null))
  location ('ASR_DEMOGRAPHICS_2008.csv'))
reject limit unlimited;

create table S_ASR_DEMOGRAPHICS_2009
 (STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(3),
  LOCATION_NAME varchar2(1000),
  NEW_LOCATION_NAME varchar2(1000),
  URBAN_RURAL_STATUS varchar2(1),
  ACCOMMODATION_TYPE varchar2(100),
  DISPLACEMENT_STATUS varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  PPG_NAME varchar2(1000),
  F0 varchar2(40),
  F5 varchar2(40),
  F12 varchar2(40),
  F18 varchar2(40),
  F60 varchar2(40),
  FOTHER varchar2(40),
  FTOTAL varchar2(40),
  M0 varchar2(40),
  M5 varchar2(40),
  M12 varchar2(40),
  M18 varchar2(40),
  M60 varchar2(40),
  MOTHER varchar2(40),
  MTOTAL varchar2(40),
  TOTAL varchar2(40),
  BASIS varchar2(5))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_DEMOGRAPHICS_2009.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_DEMOGRAPHICS_2009.log'
    skip 0
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      FILLER2 char(4000),
      FILLER3 char(4000),
      FILLER4 char(4000),
      FILLER5 char(4000),
      COU_CODE_ASYLUM char(4000),
      LOCATION_NAME char(4000),
      URBAN_RURAL_STATUS char(4000),
      DISPLACEMENT_STATUS char(4000),
      COU_CODE_ORIGIN char(4000),
      F0 char(4000),
      F5 char(4000),
      F12 char(4000),
      F18 char(4000),
      F60 char(4000),
      FOTHER char(4000),
      FTOTAL char(4000),
      M0 char(4000),
      M5 char(4000),
      M12 char(4000),
      M18 char(4000),
      M60 char(4000),
      MOTHER char(4000),
      MTOTAL char(4000),
      TOTAL char(4000),
      BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2009',
      NEW_LOCATION_NAME from null,
      ACCOMMODATION_TYPE from null,
      PPG_NAME from null))
  location ('ASR_DEMOGRAPHICS_2009.csv'))
reject limit unlimited;

create table S_ASR_DEMOGRAPHICS_2010
 (STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(3),
  LOCATION_NAME varchar2(1000),
  NEW_LOCATION_NAME varchar2(1000),
  URBAN_RURAL_STATUS varchar2(1),
  ACCOMMODATION_TYPE varchar2(100),
  DISPLACEMENT_STATUS varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  PPG_NAME varchar2(1000),
  F0 varchar2(40),
  F5 varchar2(40),
  F12 varchar2(40),
  F18 varchar2(40),
  F60 varchar2(40),
  FOTHER varchar2(40),
  FTOTAL varchar2(40),
  M0 varchar2(40),
  M5 varchar2(40),
  M12 varchar2(40),
  M18 varchar2(40),
  M60 varchar2(40),
  MOTHER varchar2(40),
  MTOTAL varchar2(40),
  TOTAL varchar2(40),
  BASIS varchar2(5))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_DEMOGRAPHICS_2010.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_DEMOGRAPHICS_2010.log'
    skip 0
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      FILLER2 char(4000),
      FILLER3 char(4000),
      FILLER4 char(4000),
      FILLER5 char(4000),
      COU_CODE_ASYLUM char(4000),
      LOCATION_NAME char(4000),
      NEW_LOCATION_NAME char(4000),
      URBAN_RURAL_STATUS char(4000),
      ACCOMMODATION_TYPE char(4000),
      DISPLACEMENT_STATUS char(4000),
      COU_CODE_ORIGIN char(4000),
      PPG_NAME char(4000),
      F0 char(4000),
      F5 char(4000),
      F12 char(4000),
      F18 char(4000),
      F60 char(4000),
      FOTHER char(4000),
      FTOTAL char(4000),
      M0 char(4000),
      M5 char(4000),
      M12 char(4000),
      M18 char(4000),
      M60 char(4000),
      MOTHER char(4000),
      MTOTAL char(4000),
      TOTAL char(4000),
      BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2010'))
  location ('ASR_DEMOGRAPHICS_2010.csv'))
reject limit unlimited;

create table S_ASR_DEMOGRAPHICS_2011
 (STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(3),
  LOCATION_NAME varchar2(1000),
  NEW_LOCATION_NAME varchar2(1000),
  URBAN_RURAL_STATUS varchar2(1),
  ACCOMMODATION_TYPE varchar2(100),
  DISPLACEMENT_STATUS varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  PPG_NAME varchar2(1000),
  F0 varchar2(40),
  F5 varchar2(40),
  F12 varchar2(40),
  F18 varchar2(40),
  F60 varchar2(40),
  FOTHER varchar2(40),
  FTOTAL varchar2(40),
  M0 varchar2(40),
  M5 varchar2(40),
  M12 varchar2(40),
  M18 varchar2(40),
  M60 varchar2(40),
  MOTHER varchar2(40),
  MTOTAL varchar2(40),
  TOTAL varchar2(40),
  BASIS varchar2(2))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_DEMOGRAPHICS_2011.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_DEMOGRAPHICS_2011.log'
    skip 0
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      FILLER2 char(4000),
      FILLER3 char(4000),
      FILLER4 char(4000),
      FILLER5 char(4000),
      COU_CODE_ASYLUM char(4000),
      LOCATION_NAME char(4000),
      NEW_LOCATION_NAME char(4000),
      URBAN_RURAL_STATUS char(4000),
      ACCOMMODATION_TYPE char(4000),
      DISPLACEMENT_STATUS char(4000),
      COU_CODE_ORIGIN char(4000),
      PPG_NAME char(4000),
      F0 char(4000),
      F5 char(4000),
      F12 char(4000),
      F18 char(4000),
      F60 char(4000),
      FOTHER char(4000),
      FTOTAL char(4000),
      M0 char(4000),
      M5 char(4000),
      M12 char(4000),
      M18 char(4000),
      M60 char(4000),
      MOTHER char(4000),
      MTOTAL char(4000),
      TOTAL char(4000),
      BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2011'))
  location ('ASR_DEMOGRAPHICS_2011.csv'))
reject limit unlimited;

create table S_ASR_DEMOGRAPHICS_2012
 (STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(3),
  LOCATION_NAME varchar2(1000),
  NEW_LOCATION_NAME varchar2(1000),
  URBAN_RURAL_STATUS varchar2(5),
  ACCOMMODATION_TYPE varchar2(100),
  DISPLACEMENT_STATUS varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  PPG_NAME varchar2(1000),
  F0 varchar2(40),
  F5 varchar2(40),
  F12 varchar2(40),
  F18 varchar2(40),
  F60 varchar2(40),
  FOTHER varchar2(40),
  FTOTAL varchar2(40),
  M0 varchar2(40),
  M5 varchar2(40),
  M12 varchar2(40),
  M18 varchar2(40),
  M60 varchar2(40),
  MOTHER varchar2(40),
  MTOTAL varchar2(40),
  TOTAL varchar2(40),
  BASIS varchar2(2))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_DEMOGRAPHICS_2012.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_DEMOGRAPHICS_2012.log'
    skip 0
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      FILLER2 char(4000),
      FILLER3 char(4000),
      FILLER4 char(4000),
      FILLER5 char(4000),
      COU_CODE_ASYLUM char(4000),
      LOCATION_NAME char(4000),
      NEW_LOCATION_NAME char(4000),
      URBAN_RURAL_STATUS char(4000),
      ACCOMMODATION_TYPE char(4000),
      DISPLACEMENT_STATUS char(4000),
      COU_CODE_ORIGIN char(4000),
      PPG_NAME char(4000),
      F0 char(4000),
      F5 char(4000),
      F12 char(4000),
      F18 char(4000),
      F60 char(4000),
      FOTHER char(4000),
      FTOTAL char(4000),
      M0 char(4000),
      M5 char(4000),
      M12 char(4000),
      M18 char(4000),
      M60 char(4000),
      MOTHER char(4000),
      MTOTAL char(4000),
      TOTAL char(4000),
      BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2012'))
  location ('ASR_DEMOGRAPHICS_2012.csv'))
reject limit unlimited;


create materialized view S_ASR_DEMOGRAPHICS_CLEANED build deferred as
select STATSYEAR, DST_CODE, COU_CODE_ASYLUM,
  trim(regexp_replace(LOCATION_NAME, ':.*$', '')) as LOCATION_NAME_EN,
  case
    when nvl(rtrim(ltrim(regexp_substr(LOCATION_NAME, ':.*$'), ': ')), 'Point') = 'Point'
    then 'Undefined'
    else rtrim(ltrim(regexp_substr(LOCATION_NAME, ':.*$'), ': '))
  end as LOC_TYPE_DESCRIPTION_EN,
  LOCATION_NAME, ORIGINAL_LOCATION_NAME, NEW_LOCATION_NAME, CORRECTED_LOCATION_NAME,
  COU_CODE_ORIGIN, URBAN_RURAL_STATUS, ACMT_CODE, PPG_NAME,
  ORIGINAL_PPG_NAME, CORRECTED_PPG_NAME,
  F0, F5, F12, F18, F60,
  case
    when nvl(F0, 0) + nvl(F5, 0) + nvl(F12, 0) + nvl(F18, 0) + nvl(F60, 0) + nvl(FOTHER, 0) = 0
    then FTOTAL
    else FOTHER
  end as FOTHER,
  M0, M5, M12, M18, M60,
  case
    when nvl(M0, 0) + nvl(M5, 0) + nvl(M12, 0) + nvl(M18, 0) + nvl(M60, 0) + nvl(MOTHER, 0) = 0
    then MTOTAL
    else MOTHER
  end as MOTHER,
  case
    when nvl(F0, 0) + nvl(F5, 0) + nvl(F12, 0) + nvl(F18, 0) + nvl(F60, 0) +
      nvl(FOTHER, 0) + nvl(FTOTAL, 0) +
      nvl(M0, 0) + nvl(M5, 0) + nvl(M12, 0) + nvl(M18, 0) + nvl(M60, 0) +
      nvl(MOTHER, 0) + nvl(MTOTAL, 0) = 0
    then TOTAL
  end as TOTAL,
  BASIS
from
 (select ASR.STATSYEAR,
    nvl(DSC.DST_CODE, upper(ASR.DISPLACEMENT_STATUS)) as DST_CODE,
    upper(ASR.COU_CODE_ASYLUM) as COU_CODE_ASYLUM,
    ASR.LOCATION_NAME as ORIGINAL_LOCATION_NAME,
    ASR.NEW_LOCATION_NAME,
    LCOR.CORRECTED_LOCATION_NAME,
    coalesce(LCOR.CORRECTED_LOCATION_NAME,
             replace(ASR.NEW_LOCATION_NAME, chr(10), ''),
             replace(ASR.LOCATION_NAME, chr(10), '')) as LOCATION_NAME,
    upper(ASR.COU_CODE_ORIGIN) as COU_CODE_ORIGIN,
    ASR.URBAN_RURAL_STATUS,
    case
      when ATC.ACCOMMODATION_TYPE is not null then ATC.ACMT_CODE
      else upper(ASR.ACCOMMODATION_TYPE)
    end as ACMT_CODE,
    ASR.PPG_NAME as ORIGINAL_PPG_NAME,
    PCOR.CORRECTED_PPG_NAME,
    case when PCOR.PPG_NAME is null then ASR.PPG_NAME else PCOR.CORRECTED_PPG_NAME end as PPG_NAME,
    case when BSC.BASIS is null then upper(ASR.BASIS) else BSC.CORRECTED_BASIS end as BASIS,
    to_number(case when ASR.F0 in ('-', '_', '..') then null
                   else ASR.F0 end) as F0,
    to_number(case when ASR.F5 in ('-', '_', '..') then null
                   else ASR.F5 end) as F5,
    to_number(case when ASR.F12 in ('-', '_', '..') then null
                   else ASR.F12 end) as F12,
    to_number(case when ASR.F18 in ('-', '_', '..') then null
                   else ASR.F18 end) as F18,
    to_number(case when ASR.F60 in ('-', '_', '..') then null
                   else ASR.F60 end) as F60,
    to_number(case when ASR.FOTHER in ('-', '_', '..') then null
                   else ASR.FOTHER end) as FOTHER,
    to_number(case when ASR.FTOTAL in ('-', '_', '..') then null
                   else ASR.FTOTAL end) as FTOTAL,
    to_number(case when ASR.M0 in ('-', '_', '..') then null
                   else ASR.M0 end) as M0,
    to_number(case when ASR.M5 in ('-', '_', '..') then null
                   else ASR.M5 end) as M5,
    to_number(case when ASR.M12 in ('-', '_', '..') then null
                   else ASR.M12 end) as M12,
    to_number(case when ASR.M18 in ('-', '_', '..') then null
                   else ASR.M18 end) as M18,
    to_number(case when ASR.M60 in ('-', '_', '..') then null
                   else ASR.M60 end) as M60,
    to_number(case when ASR.MOTHER in ('-', '_', '..') then null
                   else ASR.MOTHER end) as MOTHER,
    to_number(case when ASR.MTOTAL in ('-', '_', '..') then null
                   else ASR.MTOTAL end) as MTOTAL,
    to_number(case when ASR.TOTAL in ('-', '_', '..') then null
                   else ASR.TOTAL end) as TOTAL
  from
   (select STATSYEAR, nvl(DISPLACEMENT_STATUS, 'VAR') as DISPLACEMENT_STATUS,
      COU_CODE_ASYLUM, LOCATION_NAME, NEW_LOCATION_NAME,
      case
        when COU_CODE_ORIGIN = 'HRV/BSN' then 'VAR'
        else nvl(COU_CODE_ORIGIN, 'VAR')
      end as COU_CODE_ORIGIN,
      decode(URBAN_RURAL_STATUS, 'C', 'R', URBAN_RURAL_STATUS) as URBAN_RURAL_STATUS,
      decode(URBAN_RURAL_STATUS, 'C', 'CAMP-CTR', ACCOMMODATION_TYPE) as ACCOMMODATION_TYPE,
      PPG_NAME, upper(replace(BASIS, '/', '')) as BASIS,
      F0, F5, F12, F18, F60, FOTHER, FTOTAL,
      M0, M5, M12, M18, M60, MOTHER, MTOTAL, TOTAL
    from S_ASR_DEMOGRAPHICS_2000
    union all
    select STATSYEAR, DISPLACEMENT_STATUS,
      COU_CODE_ASYLUM, LOCATION_NAME, NEW_LOCATION_NAME, COU_CODE_ORIGIN,
      decode(URBAN_RURAL_STATUS, 'C', 'R', URBAN_RURAL_STATUS) as URBAN_RURAL_STATUS,
      decode(URBAN_RURAL_STATUS, 'C', 'CAMP-CTR', ACCOMMODATION_TYPE) as ACCOMMODATION_TYPE,
      PPG_NAME, BASIS,
      F0, F5, F12, F18, F60, FOTHER, FTOTAL,
      M0, M5, M12, M18, M60, MOTHER, MTOTAL, TOTAL
    from S_ASR_DEMOGRAPHICS_2001
    union all
    select STATSYEAR, DISPLACEMENT_STATUS,
      COU_CODE_ASYLUM, LOCATION_NAME, NEW_LOCATION_NAME, COU_CODE_ORIGIN,
      decode(URBAN_RURAL_STATUS, 'CAM', 'R', 'RUR', 'R', 'URB', 'U') as URBAN_RURAL_STATUS,
      decode(URBAN_RURAL_STATUS, 'CAM', 'CAMP-CTR', ACCOMMODATION_TYPE) as ACCOMMODATION_TYPE,
      PPG_NAME, upper(replace(BASIS, '/', '')) as BASIS,
      F0, F5, F12, F18, F60, FOTHER, FTOTAL,
      M0, M5, M12, M18, M60, MOTHER, MTOTAL, TOTAL
    from S_ASR_DEMOGRAPHICS_2002
    union all
    select STATSYEAR, DISPLACEMENT_STATUS,
      COU_CODE_ASYLUM, LOCATION_NAME, NEW_LOCATION_NAME, COU_CODE_ORIGIN,
      decode(URBAN_RURAL_STATUS, 'C', 'R', URBAN_RURAL_STATUS) as URBAN_RURAL_STATUS,
      decode(URBAN_RURAL_STATUS, 'C', 'CAMP-CTR', ACCOMMODATION_TYPE) as ACCOMMODATION_TYPE,
      PPG_NAME, upper(replace(BASIS, '/', '')) as BASIS,
      F0, F5, F12, F18, F60, FOTHER, FTOTAL,
      M0, M5, M12, M18, M60, MOTHER, MTOTAL, TOTAL
    from S_ASR_DEMOGRAPHICS_2003
    union all
    select STATSYEAR, DISPLACEMENT_STATUS,
      COU_CODE_ASYLUM, LOCATION_NAME, NEW_LOCATION_NAME, COU_CODE_ORIGIN,
      decode(URBAN_RURAL_STATUS, 'C', 'R', URBAN_RURAL_STATUS) as URBAN_RURAL_STATUS,
      decode(URBAN_RURAL_STATUS, 'C', 'CAMP-CTR', ACCOMMODATION_TYPE) as ACCOMMODATION_TYPE,
      PPG_NAME, upper(replace(BASIS, '/', '')) as BASIS,
      F0, F5, F12, F18, F60, FOTHER, FTOTAL,
      M0, M5, M12, M18, M60, MOTHER, MTOTAL, TOTAL
    from S_ASR_DEMOGRAPHICS_2004
    union all
    select STATSYEAR, DISPLACEMENT_STATUS,
      COU_CODE_ASYLUM, LOCATION_NAME, NEW_LOCATION_NAME, COU_CODE_ORIGIN,
      decode(URBAN_RURAL_STATUS, 'C', 'R', URBAN_RURAL_STATUS) as URBAN_RURAL_STATUS,
      decode(URBAN_RURAL_STATUS, 'C', 'CAMP-CTR', ACCOMMODATION_TYPE) as ACCOMMODATION_TYPE,
      PPG_NAME, upper(replace(BASIS, '/', '')) as BASIS,
      F0, F5, F12, F18, F60, FOTHER, FTOTAL,
      M0, M5, M12, M18, M60, MOTHER, MTOTAL, TOTAL
    from S_ASR_DEMOGRAPHICS_2005
    union all
    select STATSYEAR, DISPLACEMENT_STATUS,
      COU_CODE_ASYLUM, LOCATION_NAME, NEW_LOCATION_NAME, COU_CODE_ORIGIN,
      decode(URBAN_RURAL_STATUS, 'C', 'R', URBAN_RURAL_STATUS) as URBAN_RURAL_STATUS,
      decode(URBAN_RURAL_STATUS, 'C', 'CAMP-CTR', ACCOMMODATION_TYPE) as ACCOMMODATION_TYPE,
      PPG_NAME, BASIS,
      F0, F5, F12, F18, F60, FOTHER, FTOTAL,
      M0, M5, M12, M18, M60, MOTHER, MTOTAL,
      TOTAL
    from S_ASR_DEMOGRAPHICS_2006
    union all
    select STATSYEAR, DISPLACEMENT_STATUS,
      COU_CODE_ASYLUM, LOCATION_NAME, NEW_LOCATION_NAME,
      case
        when COU_CODE_ORIGIN in ('COT') then 'ICO'
        else COU_CODE_ORIGIN
      end as COU_CODE_ORIGIN,
      decode(URBAN_RURAL_STATUS, 'C', 'R', URBAN_RURAL_STATUS) as URBAN_RURAL_STATUS,
      decode(URBAN_RURAL_STATUS, 'C', 'CAMP-CTR', ACCOMMODATION_TYPE) as ACCOMMODATION_TYPE,
      PPG_NAME, BASIS,
      F0, F5, F12, F18, F60, FOTHER, FTOTAL,
      M0, M5, M12, M18, M60, MOTHER, MTOTAL,
      TOTAL
    from S_ASR_DEMOGRAPHICS_2007
    union all
    select STATSYEAR, DISPLACEMENT_STATUS,
      COU_CODE_ASYLUM, LOCATION_NAME, NEW_LOCATION_NAME,
      case
        when COU_CODE_ORIGIN in ('OAS', 'OEU', 'OLA') then 'VAR'
        else COU_CODE_ORIGIN
      end as COU_CODE_ORIGIN,
      decode(URBAN_RURAL_STATUS, 'C', 'R', URBAN_RURAL_STATUS) as URBAN_RURAL_STATUS,
      decode(URBAN_RURAL_STATUS, 'C', 'CAMP-CTR', ACCOMMODATION_TYPE) as ACCOMMODATION_TYPE,
      PPG_NAME, BASIS,
      F0, F5, F12, F18, F60, FOTHER, FTOTAL,
      M0, M5, M12, M18, M60, MOTHER, MTOTAL,
      TOTAL
    from S_ASR_DEMOGRAPHICS_2008
    union all
    select STATSYEAR, DISPLACEMENT_STATUS,
      COU_CODE_ASYLUM, LOCATION_NAME, NEW_LOCATION_NAME, COU_CODE_ORIGIN,
      decode(URBAN_RURAL_STATUS, 'C', 'R', URBAN_RURAL_STATUS) as URBAN_RURAL_STATUS,
      decode(URBAN_RURAL_STATUS, 'C', 'CAMP-CTR', ACCOMMODATION_TYPE) as ACCOMMODATION_TYPE,
      PPG_NAME, BASIS,
      F0, F5, F12, F18, F60, FOTHER, FTOTAL,
      M0, M5, M12, M18, M60, MOTHER, MTOTAL,
      TOTAL
    from S_ASR_DEMOGRAPHICS_2009
    union all
    select STATSYEAR, DISPLACEMENT_STATUS,
      COU_CODE_ASYLUM, LOCATION_NAME, NEW_LOCATION_NAME, COU_CODE_ORIGIN,
      URBAN_RURAL_STATUS, ACCOMMODATION_TYPE, PPG_NAME, BASIS,
      F0, F5, F12, F18, F60, FOTHER, FTOTAL,
      M0, M5, M12, M18, M60, MOTHER, MTOTAL,
      TOTAL
    from S_ASR_DEMOGRAPHICS_2010
    union all
    select STATSYEAR, DISPLACEMENT_STATUS,
      COU_CODE_ASYLUM, LOCATION_NAME, NEW_LOCATION_NAME, COU_CODE_ORIGIN,
      URBAN_RURAL_STATUS, ACCOMMODATION_TYPE, PPG_NAME, BASIS,
      F0, F5, F12, F18, F60, FOTHER, FTOTAL,
      M0, M5, M12, M18, M60, MOTHER, MTOTAL,
      TOTAL
    from S_ASR_DEMOGRAPHICS_2011
    union all
    select STATSYEAR, DISPLACEMENT_STATUS,
      COU_CODE_ASYLUM, LOCATION_NAME, NEW_LOCATION_NAME, COU_CODE_ORIGIN,
      decode(URBAN_RURAL_STATUS, 'Urban', 'U', URBAN_RURAL_STATUS) as URBAN_RURAL_STATUS,
      ACCOMMODATION_TYPE, PPG_NAME, BASIS,
      F0, F5, F12, F18, F60, FOTHER, FTOTAL,
      M0, M5, M12, M18, M60, MOTHER, MTOTAL,
      TOTAL
    from S_ASR_DEMOGRAPHICS_2012) ASR
  left outer join S_DST_CODE_CORRECTIONS DSC
    on DSC.DISPLACEMENT_STATUS = ASR.DISPLACEMENT_STATUS
  left outer join S_LOCATION_NAME_CORRECTIONS LCOR
    on LCOR.COU_CODE = upper(ASR.COU_CODE_ASYLUM)
    and LCOR.LOCATION_NAME = replace(ASR.LOCATION_NAME, chr(10), '')
    and (LCOR.NEW_LOCATION_NAME = replace(ASR.NEW_LOCATION_NAME, chr(10), '')
      or (LCOR.NEW_LOCATION_NAME is null
        and ASR.NEW_LOCATION_NAME is null))
  left outer join S_ACCOM_TYPE_CORRECTIONS ATC
    on ATC.ACCOMMODATION_TYPE = ASR.ACCOMMODATION_TYPE
  left outer join S_PPG_CORRECTIONS PCOR
    on PCOR.STATSYEAR = ASR.STATSYEAR
    and PCOR.COU_CODE_ASYLUM = upper(ASR.COU_CODE_ASYLUM)
    and PCOR.PPG_NAME = ASR.PPG_NAME
  left outer join S_BASIS_CORRECTIONS BSC
    on BSC.BASIS = ASR.BASIS);


create materialized view S_ASR_DEMOGRAPHICS build deferred as
select STATSYEAR, DST_CODE, COU_CODE_ASYLUM, LOCATION_NAME_EN, LOC_TYPE_DESCRIPTION_EN,
  COU_CODE_ORIGIN, URBAN_RURAL_STATUS, ACMT_CODE, PPG_NAME, BASIS, DATA_POINT, VALUE
from
 (select STATSYEAR, DST_CODE, COU_CODE_ASYLUM, LOCATION_NAME_EN, LOC_TYPE_DESCRIPTION_EN,
    COU_CODE_ORIGIN, URBAN_RURAL_STATUS, ACMT_CODE, PPG_NAME,
    CHARAGG(BASIS) as BASIS,
    round(sum(F0)) as F0, round(sum(F5)) as F5, round(sum(F12)) as F12, round(sum(F18)) as F18,
    round(sum(F60)) as F60, round(sum(FOTHER)) as FOTHER,
    round(sum(M0)) as M0, round(sum(M5)) as M5, round(sum(M12)) as M12, round(sum(M18)) as M18,
    round(sum(M60)) as M60, round(sum(MOTHER)) as MOTHER, round(sum(TOTAL)) as TOTAL
  from S_ASR_DEMOGRAPHICS_CLEANED
  group by STATSYEAR, DST_CODE, COU_CODE_ASYLUM, LOCATION_NAME_EN, LOC_TYPE_DESCRIPTION_EN,
    COU_CODE_ORIGIN, URBAN_RURAL_STATUS, ACMT_CODE, PPG_NAME)
unpivot
 (VALUE for DATA_POINT in
   (F0 as 'F0',
    F5 as 'F5',
    F12 as 'F12',
    F18 as 'F18',
    F60 as 'F60',
    FOTHER as 'F',
    M0 as 'M0',
    M5 as 'M5',
    M12 as 'M12',
    M18 as 'M18',
    M60 as 'M60',
    MOTHER as 'M',
    TOTAL as ''))
where VALUE != 0;


grant select on S_ASR_DEMOGRAPHICS_CLEANED to PSR_STAGE;
grant select on S_ASR_DEMOGRAPHICS to PSR_STAGE;


/* Verification queries
select sum(ROW_COUNT) as RAW_ROW_COUNT,
  count(*) as RAW_AGGREGATED_ROW_COUNT,
  count(
    case
      when F0 != 0 or F5 != 0 or F12 != 0 or F18 != 0 or F60 != 0 or FOTHER != 0 or
        M0 != 0 or M5 != 0 or M12 != 0 or M18 != 0 or M60 != 0 or MOTHER != 0 or TOTAL != 0
      then 1
    end) as FILTERED_AGGREGATED_ROW_COUNT,
  count(*) * 15 as VALUE_COUNT,
  count(F0) + count(F5) + count(F12) + count(F18) + count(F60) + count(FOTHER) +
    count(M0) + count(M5) + count(M12) + count(M18) + count(M60) + count(MOTHER) +
    count(TOTAL) as NON_NULL_COUNT,
  count(case when F0 != 0 then 1 end) + count(case when F5 != 0 then 1 end) +
    count(case when F12 != 0 then 1 end) + count(case when F18 != 0 then 1 end) +
    count(case when F60 != 0 then 1 end) + count(case when FOTHER != 0 then 1 end) +
    count(case when M0 != 0 then 1 end) + count(case when M5 != 0 then 1 end) +
    count(case when M12 != 0 then 1 end) + count(case when M18 != 0 then 1 end) +
    count(case when M60 != 0 then 1 end) + count(case when MOTHER != 0 then 1 end) +
    count(case when TOTAL != 0 then 1 end) as NON_ZERO_COUNT
from
 (select STATSYEAR, DST_CODE, COU_CODE_ASYLUM, LOCATION_NAME_EN, LOC_TYPE_DESCRIPTION_EN,
    COU_CODE_ORIGIN, URBAN_RURAL_STATUS, ACMT_CODE, PPG_NAME,
    count(*) as ROW_COUNT,
    sum(F0) as F0, sum(F5) as F5, sum(F12) as F12, sum(F18) as F18, sum(F60) as F60,
    sum(FOTHER) as FOTHER,
    sum(M0) as M0, sum(M5) as M5, sum(M12) as M12, sum(M18) as M18, sum(M60) as M60,
    sum(MOTHER) as MOTHER, sum(TOTAL) as TOTAL
  from S_ASR_DEMOGRAPHICS_CLEANED
  group by STATSYEAR, DST_CODE, COU_CODE_ASYLUM, LOCATION_NAME_EN, LOC_TYPE_DESCRIPTION_EN,
    COU_CODE_ORIGIN, URBAN_RURAL_STATUS, ACMT_CODE, PPG_NAME);

select count(*) as KEY_COUNT, sum(ROW_COUNT) as ROW_COUNT
from
 (select count(*) as ROW_COUNT
  from S_ASR_DEMOGRAPHICS
  group by STATSYEAR, DST_CODE, COU_CODE_ASYLUM, LOCATION_NAME_EN, LOC_TYPE_DESCRIPTION_EN,
    COU_CODE_ORIGIN, URBAN_RURAL_STATUS, ACMT_CODE, PPG_NAME);
*/