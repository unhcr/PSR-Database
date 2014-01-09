create table S_ASR_RSD_2000
 (STATSYEAR varchar2(4),
  DISPLACEMENT_STATUS varchar2(3),
  COU_CODE_ASYLUM varchar2(3),
  RSD_TYPE varchar2(20),
  PROCEDURE_LEVEL varchar2(3),
  APPLICATION_IND_GROUP varchar2(1),
  APPLICATION_GROUP_SIZE varchar2(40),
  RSD_LEVEL varchar2(3),
  DECISION_IND_GROUP varchar2(1),
  DECISION_GROUP_SIZE varchar2(40),
  COU_CODE_ORIGIN varchar2(3),
  ASY_START varchar2(40),
  ASY_AH_START varchar2(40),
  ASYAPP varchar2(40),
  ASYREC_CV varchar2(40),
  ASYREC_CP varchar2(40),
  ASYREJ varchar2(40),
  ASYOTHCL varchar2(40),
  TOTAL_DECISIONS varchar2(40),
  ASY_END varchar2(40),
  ASY_AH_END varchar2(40))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_RSD_2000.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_RSD_2000.log'
    skip 0
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      COU_CODE_ASYLUM char(4000),
      RSD_TYPE char(4000),
      RSD_LEVEL char(4000),
      FILLER2 char(4000),
      COU_CODE_ORIGIN char(4000),
      ASY_START char(4000),
      ASY_AH_START char(4000),
      ASYAPP char(4000),
      ASYREC_CV char(4000),
      ASYREC_CP char(4000),
      ASYREJ char(4000),
      ASYOTHCL char(4000),
      TOTAL_DECISIONS char(4000),
      ASY_END char(4000),
      ASY_AH_END char(4000))
    column transforms
     (STATSYEAR from constant '2000',
      DISPLACEMENT_STATUS from constant 'ASY',
      PROCEDURE_LEVEL from null,
      APPLICATION_IND_GROUP from null,
      APPLICATION_GROUP_SIZE from null,
      DECISION_IND_GROUP from null,
      DECISION_GROUP_SIZE from null))
  location ('ASR_RSD_2000.csv'))
reject limit unlimited;

create table S_ASR_RSD_2001
 (STATSYEAR varchar2(4),
  DISPLACEMENT_STATUS varchar2(3),
  COU_CODE_ASYLUM varchar2(3),
  RSD_TYPE varchar2(1),
  PROCEDURE_LEVEL varchar2(3),
  APPLICATION_IND_GROUP varchar2(1),
  APPLICATION_GROUP_SIZE varchar2(40),
  RSD_LEVEL varchar2(2),
  DECISION_IND_GROUP varchar2(1),
  DECISION_GROUP_SIZE varchar2(40),
  COU_CODE_ORIGIN varchar2(3),
  ASY_START varchar2(40),
  ASY_AH_START varchar2(40),
  ASYAPP varchar2(40),
  ASYREC_CV varchar2(40),
  ASYREC_CP varchar2(40),
  ASYREJ varchar2(40),
  ASYOTHCL varchar2(40),
  TOTAL_DECISIONS varchar2(40),
  ASY_END varchar2(40),
  ASY_AH_END varchar2(40))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_RSD_2001.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_RSD_2001.log'
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
      DECISION_IND_GROUP char(4000),
      COU_CODE_ASYLUM char(4000),
      RSD_TYPE char(4000),
      RSD_LEVEL char(4000),
      FILLER6 char(4000),
      FILLER7 char(4000),
      COU_CODE_ORIGIN char(4000),
      ASY_START char(4000),
      ASY_AH_START char(4000),
      ASYAPP char(4000),
      ASYREC_CV char(4000),
      ASYREC_CP char(4000),
      ASYREJ char(4000),
      ASYOTHCL char(4000),
      TOTAL_DECISIONS char(4000),
      ASY_END char(4000),
      ASY_AH_END char(4000))
    column transforms
     (STATSYEAR from constant '2001',
      DISPLACEMENT_STATUS from constant 'ASY',
      PROCEDURE_LEVEL from null,
      APPLICATION_IND_GROUP from null,
      APPLICATION_GROUP_SIZE from null,
      DECISION_GROUP_SIZE from null))
  location ('ASR_RSD_2001.csv'))
reject limit unlimited;

create table S_ASR_RSD_2002
 (STATSYEAR varchar2(4),
  DISPLACEMENT_STATUS varchar2(3),
  COU_CODE_ASYLUM varchar2(3),
  RSD_TYPE varchar2(1),
  PROCEDURE_LEVEL varchar2(3),
  APPLICATION_IND_GROUP varchar2(1),
  APPLICATION_GROUP_SIZE varchar2(40),
  RSD_LEVEL varchar2(2),
  DECISION_IND_GROUP varchar2(1),
  DECISION_GROUP_SIZE varchar2(40),
  COU_CODE_ORIGIN varchar2(3),
  ASY_START varchar2(40),
  ASY_AH_START varchar2(40),
  ASYAPP varchar2(40),
  ASYREC_CV varchar2(40),
  ASYREC_CP varchar2(40),
  ASYREJ varchar2(40),
  ASYOTHCL varchar2(40),
  TOTAL_DECISIONS varchar2(40),
  ASY_END varchar2(40),
  ASY_AH_END varchar2(40))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_RSD_2002.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_RSD_2002.log'
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
      APPLICATION_IND_GROUP char(4000),
      DECISION_IND_GROUP char(4000),
      COU_CODE_ASYLUM char(4000),
      RSD_TYPE char(4000),
      FILLER6 char(4000),
      RSD_LEVEL char(4000),
      COU_CODE_ORIGIN char(4000),
      ASY_START char(4000),
      ASY_AH_START char(4000),
      ASYAPP char(4000),
      ASYREC_CV char(4000),
      ASYREC_CP char(4000),
      ASYREJ char(4000),
      ASYOTHCL char(4000),
      TOTAL_DECISIONS char(4000),
      ASY_END char(4000),
      ASY_AH_END char(4000))
    column transforms
     (STATSYEAR from constant '2002',
      DISPLACEMENT_STATUS from constant 'ASY',
      PROCEDURE_LEVEL from null,
      APPLICATION_GROUP_SIZE from null,
      DECISION_GROUP_SIZE from null))
  location ('ASR_RSD_2002.csv'))
reject limit unlimited;

create table S_ASR_RSD_2003
 (STATSYEAR varchar2(4),
  DISPLACEMENT_STATUS varchar2(3),
  COU_CODE_ASYLUM varchar2(3),
  RSD_TYPE varchar2(1),
  PROCEDURE_LEVEL varchar2(3),
  APPLICATION_IND_GROUP varchar2(1),
  APPLICATION_GROUP_SIZE varchar2(40),
  RSD_LEVEL varchar2(2),
  DECISION_IND_GROUP varchar2(1),
  DECISION_GROUP_SIZE varchar2(40),
  COU_CODE_ORIGIN varchar2(3),
  ASY_START varchar2(40),
  ASY_AH_START varchar2(40),
  ASYAPP varchar2(40),
  ASYREC_CV varchar2(40),
  ASYREC_CP varchar2(40),
  ASYREJ varchar2(40),
  ASYOTHCL varchar2(40),
  TOTAL_DECISIONS varchar2(40),
  ASY_END varchar2(40),
  ASY_AH_END varchar2(40))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_RSD_2003.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_RSD_2003.log'
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
      APPLICATION_IND_GROUP char(4000),
      DECISION_IND_GROUP char(4000),
      COU_CODE_ASYLUM char(4000),
      RSD_TYPE char(4000),
      FILLER6 char(4000),
      RSD_LEVEL char(4000),
      COU_CODE_ORIGIN char(4000),
      ASY_START char(4000),
      ASY_AH_START char(4000),
      ASYAPP char(4000),
      ASYREC_CV char(4000),
      ASYREC_CP char(4000),
      ASYREJ char(4000),
      ASYOTHCL char(4000),
      TOTAL_DECISIONS char(4000),
      ASY_END char(4000),
      ASY_AH_END char(4000))
    column transforms
     (STATSYEAR from constant '2003',
      DISPLACEMENT_STATUS from constant 'ASY',
      PROCEDURE_LEVEL from null,
      APPLICATION_GROUP_SIZE from null,
      DECISION_GROUP_SIZE from null))
  location ('ASR_RSD_2003.csv'))
reject limit unlimited;

create table S_ASR_RSD_2004
 (STATSYEAR varchar2(4),
  DISPLACEMENT_STATUS varchar2(3),
  COU_CODE_ASYLUM varchar2(3),
  RSD_TYPE varchar2(1),
  PROCEDURE_LEVEL varchar2(3),
  APPLICATION_IND_GROUP varchar2(1),
  APPLICATION_GROUP_SIZE varchar2(40),
  RSD_LEVEL varchar2(2),
  DECISION_IND_GROUP varchar2(1),
  DECISION_GROUP_SIZE varchar2(40),
  COU_CODE_ORIGIN varchar2(3),
  ASY_START varchar2(40),
  ASY_AH_START varchar2(40),
  ASYAPP varchar2(40),
  ASYREC_CV varchar2(40),
  ASYREC_CP varchar2(40),
  ASYREJ varchar2(40),
  ASYOTHCL varchar2(40),
  TOTAL_DECISIONS varchar2(40),
  ASY_END varchar2(40),
  ASY_AH_END varchar2(40))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_RSD_2004.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_RSD_2004.log'
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
      APPLICATION_IND_GROUP char(4000),
      DECISION_IND_GROUP char(4000),
      COU_CODE_ASYLUM char(4000),
      RSD_TYPE char(4000),
      FILLER6 char(4000),
      RSD_LEVEL char(4000),
      COU_CODE_ORIGIN char(4000),
      ASY_START char(4000),
      ASY_AH_START char(4000),
      ASYAPP char(4000),
      ASYREC_CV char(4000),
      ASYREC_CP char(4000),
      ASYREJ char(4000),
      ASYOTHCL char(4000),
      TOTAL_DECISIONS char(4000),
      ASY_END char(4000),
      ASY_AH_END char(4000))
    column transforms
     (STATSYEAR from constant '2004',
      DISPLACEMENT_STATUS from constant 'ASY',
      PROCEDURE_LEVEL from null,
      APPLICATION_GROUP_SIZE from null,
      DECISION_GROUP_SIZE from null))
  location ('ASR_RSD_2004.csv'))
reject limit unlimited;

create table S_ASR_RSD_2005
 (STATSYEAR varchar2(4),
  DISPLACEMENT_STATUS varchar2(3),
  COU_CODE_ASYLUM varchar2(3),
  RSD_TYPE varchar2(1),
  PROCEDURE_LEVEL varchar2(3),
  APPLICATION_IND_GROUP varchar2(1),
  APPLICATION_GROUP_SIZE varchar2(40),
  RSD_LEVEL varchar2(2),
  DECISION_IND_GROUP varchar2(1),
  DECISION_GROUP_SIZE varchar2(40),
  COU_CODE_ORIGIN varchar2(3),
  ASY_START varchar2(40),
  ASY_AH_START varchar2(40),
  ASYAPP varchar2(40),
  ASYREC_CV varchar2(40),
  ASYREC_CP varchar2(40),
  ASYREJ varchar2(40),
  ASYOTHCL varchar2(40),
  TOTAL_DECISIONS varchar2(40),
  ASY_END varchar2(40),
  ASY_AH_END varchar2(40))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_RSD_2005.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_RSD_2005.log'
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
      APPLICATION_IND_GROUP char(4000),
      DECISION_IND_GROUP char(4000),
      COU_CODE_ASYLUM char(4000),
      RSD_TYPE char(4000),
      FILLER6 char(4000),
      RSD_LEVEL char(4000),
      COU_CODE_ORIGIN char(4000),
      ASY_START char(4000),
      ASY_AH_START char(4000),
      ASYAPP char(4000),
      ASYREC_CV char(4000),
      ASYREC_CP char(4000),
      ASYREJ char(4000),
      ASYOTHCL char(4000),
      TOTAL_DECISIONS char(4000),
      ASY_END char(4000),
      ASY_AH_END char(4000))
    column transforms
     (STATSYEAR from constant '2005',
      DISPLACEMENT_STATUS from constant 'ASY',
      PROCEDURE_LEVEL from null,
      APPLICATION_GROUP_SIZE from null,
      DECISION_GROUP_SIZE from null))
  location ('ASR_RSD_2005.csv'))
reject limit unlimited;

create table S_ASR_RSD_2006
 (STATSYEAR varchar2(4),
  DISPLACEMENT_STATUS varchar2(3),
  COU_CODE_ASYLUM varchar2(3),
  RSD_TYPE varchar2(1),
  PROCEDURE_LEVEL varchar2(3),
  APPLICATION_IND_GROUP varchar2(1),
  APPLICATION_GROUP_SIZE varchar2(40),
  RSD_LEVEL varchar2(2),
  DECISION_IND_GROUP varchar2(1),
  DECISION_GROUP_SIZE varchar2(40),
  COU_CODE_ORIGIN varchar2(3),
  ASY_START varchar2(40),
  ASY_AH_START varchar2(40),
  ASYAPP varchar2(40),
  ASYREC_CV varchar2(40),
  ASYREC_CP varchar2(40),
  ASYREJ varchar2(40),
  ASYOTHCL varchar2(40),
  TOTAL_DECISIONS varchar2(40),
  ASY_END varchar2(40),
  ASY_AH_END varchar2(40))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_RSD_2006.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_RSD_2006.log'
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
      RSD_TYPE char(4000),
      PROCEDURE_LEVEL char(4000),
      APPLICATION_IND_GROUP char(4000),
      APPLICATION_GROUP_SIZE char(4000),
      RSD_LEVEL char(4000),
      DECISION_IND_GROUP char(4000),
      DECISION_GROUP_SIZE char(4000),
      COU_CODE_ORIGIN char(4000),
      ASY_START char(4000),
      ASY_AH_START char(4000),
      ASYAPP char(4000),
      ASYREC_CV char(4000),
      ASYREC_CP char(4000),
      ASYREJ char(4000),
      ASYOTHCL char(4000),
      TOTAL_DECISIONS char(4000),
      ASY_END char(4000),
      ASY_AH_END char(4000))
    column transforms
     (STATSYEAR from constant '2006',
      DISPLACEMENT_STATUS from constant 'ASY'))
  location ('ASR_RSD_2006.csv'))
reject limit unlimited;

create table S_ASR_RSD_2007
 (STATSYEAR varchar2(4),
  DISPLACEMENT_STATUS varchar2(3),
  COU_CODE_ASYLUM varchar2(3),
  RSD_TYPE varchar2(1),
  PROCEDURE_LEVEL varchar2(3),
  APPLICATION_IND_GROUP varchar2(1),
  APPLICATION_GROUP_SIZE varchar2(40),
  RSD_LEVEL varchar2(2),
  DECISION_IND_GROUP varchar2(1),
  DECISION_GROUP_SIZE varchar2(40),
  COU_CODE_ORIGIN varchar2(3),
  ASY_START varchar2(40),
  ASY_AH_START varchar2(40),
  ASYAPP varchar2(40),
  ASYREC_CV varchar2(40),
  ASYREC_CP varchar2(40),
  ASYREJ varchar2(40),
  ASYOTHCL varchar2(40),
  TOTAL_DECISIONS varchar2(40),
  ASY_END varchar2(40),
  ASY_AH_END varchar2(40))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_RSD_2007.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_RSD_2007.log'
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
      RSD_TYPE char(4000),
      PROCEDURE_LEVEL char(4000),
      APPLICATION_IND_GROUP char(4000),
      APPLICATION_GROUP_SIZE char(4000),
      RSD_LEVEL char(4000),
      DECISION_IND_GROUP char(4000),
      DECISION_GROUP_SIZE char(4000),
      COU_CODE_ORIGIN char(4000),
      ASY_START char(4000),
      ASY_AH_START char(4000),
      ASYAPP char(4000),
      ASYREC_CV char(4000),
      ASYREC_CP char(4000),
      ASYREJ char(4000),
      ASYOTHCL char(4000),
      TOTAL_DECISIONS char(4000),
      ASY_END char(4000),
      ASY_AH_END char(4000))
    column transforms
     (STATSYEAR from constant '2007',
      DISPLACEMENT_STATUS from constant 'ASY'))
  location ('ASR_RSD_2007.csv'))
reject limit unlimited;

create table S_ASR_RSD_2008
 (STATSYEAR varchar2(4),
  DISPLACEMENT_STATUS varchar2(3),
  COU_CODE_ASYLUM varchar2(3),
  RSD_TYPE varchar2(1),
  PROCEDURE_LEVEL varchar2(3),
  APPLICATION_IND_GROUP varchar2(1),
  APPLICATION_GROUP_SIZE varchar2(40),
  RSD_LEVEL varchar2(2),
  DECISION_IND_GROUP varchar2(1),
  DECISION_GROUP_SIZE varchar2(40),
  COU_CODE_ORIGIN varchar2(3),
  ASY_START varchar2(40),
  ASY_AH_START varchar2(40),
  ASYAPP varchar2(40),
  ASYREC_CV varchar2(40),
  ASYREC_CP varchar2(40),
  ASYREJ varchar2(40),
  ASYOTHCL varchar2(40),
  TOTAL_DECISIONS varchar2(40),
  ASY_END varchar2(40),
  ASY_AH_END varchar2(40))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_RSD_2008.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_RSD_2008.log'
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
      RSD_TYPE char(4000),
      PROCEDURE_LEVEL char(4000),
      APPLICATION_IND_GROUP char(4000),
      APPLICATION_GROUP_SIZE char(4000),
      RSD_LEVEL char(4000),
      DECISION_IND_GROUP char(4000),
      DECISION_GROUP_SIZE char(4000),
      COU_CODE_ORIGIN char(4000),
      ASY_START char(4000),
      ASY_AH_START char(4000),
      ASYAPP char(4000),
      ASYREC_CV char(4000),
      ASYREC_CP char(4000),
      ASYREJ char(4000),
      ASYOTHCL char(4000),
      TOTAL_DECISIONS char(4000),
      ASY_END char(4000),
      ASY_AH_END char(4000))
    column transforms
     (STATSYEAR from constant '2008',
      DISPLACEMENT_STATUS from constant 'ASY'))
  location ('ASR_RSD_2008.csv'))
reject limit unlimited;

create table S_ASR_RSD_2009
 (STATSYEAR varchar2(4),
  DISPLACEMENT_STATUS varchar2(3),
  COU_CODE_ASYLUM varchar2(3),
  RSD_TYPE varchar2(1),
  PROCEDURE_LEVEL varchar2(3),
  APPLICATION_IND_GROUP varchar2(1),
  APPLICATION_GROUP_SIZE varchar2(40),
  RSD_LEVEL varchar2(2),
  DECISION_IND_GROUP varchar2(1),
  DECISION_GROUP_SIZE varchar2(40),
  COU_CODE_ORIGIN varchar2(3),
  ASY_START varchar2(40),
  ASY_AH_START varchar2(40),
  ASYAPP varchar2(40),
  ASYREC_CV varchar2(40),
  ASYREC_CP varchar2(40),
  ASYREJ varchar2(40),
  ASYOTHCL varchar2(40),
  TOTAL_DECISIONS varchar2(40),
  ASY_END varchar2(40),
  ASY_AH_END varchar2(40))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_RSD_2009.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_RSD_2009.log'
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
      RSD_TYPE char(4000),
      PROCEDURE_LEVEL char(4000),
      APPLICATION_IND_GROUP char(4000),
      APPLICATION_GROUP_SIZE char(4000),
      RSD_LEVEL char(4000),
      DECISION_IND_GROUP char(4000),
      DECISION_GROUP_SIZE char(4000),
      COU_CODE_ORIGIN char(4000),
      ASY_START char(4000),
      ASY_AH_START char(4000),
      ASYAPP char(4000),
      ASYREC_CV char(4000),
      ASYREC_CP char(4000),
      ASYREJ char(4000),
      ASYOTHCL char(4000),
      TOTAL_DECISIONS char(4000),
      ASY_END char(4000),
      ASY_AH_END char(4000))
    column transforms
     (STATSYEAR from constant '2009',
      DISPLACEMENT_STATUS from constant 'ASY'))
  location ('ASR_RSD_2009.csv'))
reject limit unlimited;

create table S_ASR_RSD_2010
 (STATSYEAR varchar2(4),
  DISPLACEMENT_STATUS varchar2(3),
  COU_CODE_ASYLUM varchar2(3),
  RSD_TYPE varchar2(1),
  PROCEDURE_LEVEL varchar2(3),
  APPLICATION_IND_GROUP varchar2(1),
  APPLICATION_GROUP_SIZE varchar2(40),
  RSD_LEVEL varchar2(2),
  DECISION_IND_GROUP varchar2(1),
  DECISION_GROUP_SIZE varchar2(40),
  COU_CODE_ORIGIN varchar2(3),
  ASY_START varchar2(40),
  ASY_AH_START varchar2(40),
  ASYAPP varchar2(40),
  ASYREC_CV varchar2(40),
  ASYREC_CP varchar2(40),
  ASYREJ varchar2(40),
  ASYOTHCL varchar2(40),
  TOTAL_DECISIONS varchar2(40),
  ASY_END varchar2(40),
  ASY_AH_END varchar2(40))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n' 
    characterset WE8MSWIN1252
    badfile 'ASR_RSD_2010.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_RSD_2010.log'
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
      RSD_TYPE char(4000),
      PROCEDURE_LEVEL char(4000),
      APPLICATION_IND_GROUP char(4000),
      APPLICATION_GROUP_SIZE char(4000),
      RSD_LEVEL char(4000),
      DECISION_IND_GROUP char(4000),
      DECISION_GROUP_SIZE char(4000),
      COU_CODE_ORIGIN char(4000),
      ASY_START char(4000),
      ASY_AH_START char(4000),
      ASYAPP char(4000),
      ASYREC_CV char(4000),
      ASYREC_CP char(4000),
      ASYREJ char(4000),
      ASYOTHCL char(4000),
      TOTAL_DECISIONS char(4000),
      ASY_END char(4000),
      ASY_AH_END char(4000))
    column transforms
     (STATSYEAR from constant '2010',
      DISPLACEMENT_STATUS from constant 'ASY'))
  location ('ASR_RSD_2010.csv'))
reject limit unlimited;

create table S_ASR_RSD_2011 
 (STATSYEAR varchar2(4),
  DISPLACEMENT_STATUS varchar2(3),
  COU_CODE_ASYLUM varchar2(3),
  RSD_TYPE varchar2(1),
  PROCEDURE_LEVEL varchar2(3),
  APPLICATION_IND_GROUP varchar2(1),
  APPLICATION_GROUP_SIZE varchar2(40),
  RSD_LEVEL varchar2(2),
  DECISION_IND_GROUP varchar2(1),
  DECISION_GROUP_SIZE varchar2(40),
  COU_CODE_ORIGIN varchar2(3),
  ASY_START varchar2(40),
  ASY_AH_START varchar2(40),
  ASYAPP varchar2(40),
  ASYREC_CV varchar2(40),
  ASYREC_CP varchar2(40),
  ASYREJ varchar2(40),
  ASYOTHCL varchar2(40),
  TOTAL_DECISIONS varchar2(40),
  ASY_END varchar2(40),
  ASY_AH_END varchar2(40))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n' 
    characterset WE8MSWIN1252
    badfile 'ASR_RSD_2011.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_RSD_2011.log'
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
      RSD_TYPE char(4000),
      PROCEDURE_LEVEL char(4000),
      APPLICATION_IND_GROUP char(4000),
      APPLICATION_GROUP_SIZE char(4000),
      RSD_LEVEL char(4000),
      DECISION_IND_GROUP char(4000),
      DECISION_GROUP_SIZE char(4000),
      COU_CODE_ORIGIN char(4000),
      ASY_START char(4000),
      ASY_AH_START char(4000),
      ASYAPP char(4000),
      ASYREC_CV char(4000),
      ASYREC_CP char(4000),
      ASYREJ char(4000),
      ASYOTHCL char(4000),
      TOTAL_DECISIONS char(4000),
      ASY_END char(4000),
      ASY_AH_END char(4000))
    column transforms
     (STATSYEAR from constant '2011',
      DISPLACEMENT_STATUS from constant 'ASY'))
  location ('ASR_RSD_2011.csv'))
reject limit unlimited;

create table S_ASR_RSD_2012
 (STATSYEAR varchar2(4),
  DISPLACEMENT_STATUS varchar2(3),
  COU_CODE_ASYLUM varchar2(3),
  RSD_TYPE varchar2(1),
  PROCEDURE_LEVEL varchar2(3),
  APPLICATION_IND_GROUP varchar2(1),
  APPLICATION_GROUP_SIZE varchar2(40),
  RSD_LEVEL varchar2(2),
  DECISION_IND_GROUP varchar2(1),
  DECISION_GROUP_SIZE varchar2(40),
  COU_CODE_ORIGIN varchar2(3),
  ASY_START varchar2(40),
  ASY_AH_START varchar2(40),
  ASYAPP varchar2(40),
  ASYREC_CV varchar2(40),
  ASYREC_CP varchar2(40),
  ASYREJ varchar2(40),
  ASYOTHCL varchar2(40),
  TOTAL_DECISIONS varchar2(40),
  ASY_END varchar2(40),
  ASY_AH_END varchar2(40))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_RSD_2012.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_RSD_2012.log'
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
      RSD_TYPE char(4000),
      PROCEDURE_LEVEL char(4000),
      APPLICATION_IND_GROUP char(4000),
      APPLICATION_GROUP_SIZE char(4000),
      RSD_LEVEL char(4000),
      DECISION_IND_GROUP char(4000),
      DECISION_GROUP_SIZE char(4000),
      COU_CODE_ORIGIN char(4000),
      ASY_START char(4000),
      ASY_AH_START char(4000),
      ASYAPP char(4000),
      ASYREC_CV char(4000),
      ASYREC_CP char(4000),
      ASYREJ char(4000),
      ASYOTHCL char(4000),
      TOTAL_DECISIONS char(4000),
      ASY_END char(4000),
      ASY_AH_END char(4000))
    column transforms
     (STATSYEAR from constant '2012',
      DISPLACEMENT_STATUS from constant 'ASY'))
  location ('ASR_RSD_2012.csv'))
reject limit unlimited;

create table S_ASR_RSD_2013
 (STATSYEAR varchar2(4),
  DISPLACEMENT_STATUS varchar2(3),
  COU_CODE_ASYLUM varchar2(3),
  RSD_TYPE varchar2(1),
  PROCEDURE_LEVEL varchar2(3),
  APPLICATION_IND_GROUP varchar2(1),
  APPLICATION_GROUP_SIZE varchar2(40),
  RSD_LEVEL varchar2(2),
  DECISION_IND_GROUP varchar2(1),
  DECISION_GROUP_SIZE varchar2(40),
  COU_CODE_ORIGIN varchar2(3),
  ASY_START varchar2(40),
  ASY_AH_START varchar2(40),
  ASYAPP varchar2(40),
  ASYREC_CV varchar2(40),
  ASYREC_CP varchar2(40),
  ASYREJ varchar2(40),
  ASYOTHCL varchar2(40),
  TOTAL_DECISIONS varchar2(40),
  ASY_END varchar2(40),
  ASY_AH_END varchar2(40))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_RSD_2013.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_RSD_2013.log'
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
      RSD_TYPE char(4000),
      PROCEDURE_LEVEL char(4000),
      APPLICATION_IND_GROUP char(4000),
      APPLICATION_GROUP_SIZE char(4000),
      RSD_LEVEL char(4000),
      DECISION_IND_GROUP char(4000),
      DECISION_GROUP_SIZE char(4000),
      COU_CODE_ORIGIN char(4000),
      ASY_START char(4000),
      ASY_AH_START char(4000),
      ASYAPP char(4000),
      ASYREC_CV char(4000),
      ASYREC_CP char(4000),
      ASYREJ char(4000),
      ASYOTHCL char(4000),
      TOTAL_DECISIONS char(4000),
      ASY_END char(4000),
      ASY_AH_END char(4000))
    column transforms
     (STATSYEAR from constant '2013',
      DISPLACEMENT_STATUS from constant 'ASY'))
  location ('ASR_RSD_2013.csv'))
reject limit unlimited;


create or replace view S_ASR_RSD_CLEANED as
select ASR.STATSYEAR, ASR.DISPLACEMENT_STATUS as DST_CODE,
  upper(ASR.COU_CODE_ASYLUM) as COU_CODE_ASYLUM,
  RSD_TYPE, PROCEDURE_LEVEL, APPLICATION_IND_GROUP, APPLICATION_GROUP_SIZE,
  RSD_LEVEL, DECISION_IND_GROUP, DECISION_GROUP_SIZE,
  upper(ASR.COU_CODE_ORIGIN) as COU_CODE_ORIGIN,
  to_number(case when ASR.ASY_START in ('-', '..') then null
                 else ASR.ASY_START end) as ASY_START,
  to_number(case when ASR.ASY_AH_START in ('-', '..') then null
                 else ASR.ASY_AH_START end) as ASY_AH_START,
  to_number(case when ASR.ASYAPP in ('-', '..') then null
                 else ASR.ASYAPP end) as ASYAPP,
  to_number(case when ASR.ASYREC_CV in ('-', '..') then null
                 else ASR.ASYREC_CV end) as ASYREC_CV,
  to_number(case when ASR.ASYREC_CP in ('-', '..') then null
                 else ASR.ASYREC_CP end) as ASYREC_CP,
  to_number(case when ASR.ASYREJ in ('-', '..') then null
                 else ASR.ASYREJ end) as ASYREJ,
  to_number(case when ASR.ASYOTHCL in ('-', '..') then null
                 else ASR.ASYOTHCL end) as ASYOTHCL,
  to_number(case when ASR.TOTAL_DECISIONS in ('-', '..') then null
                 else ASR.TOTAL_DECISIONS end) as TOTAL_DECISIONS,
  to_number(case when ASR.ASY_END in ('-', '..') then null
                 else ASR.ASY_END end) as ASY_END,
  to_number(case when ASR.ASY_AH_END in ('-', '..', 's') then null
                 else ASR.ASY_AH_END end) as ASY_AH_END
from
 (select STATSYEAR, DISPLACEMENT_STATUS, COU_CODE_ASYLUM,
    case when RSD_TYPE = 'V' then 'J' else substr(RSD_TYPE, 1, 1) end as RSD_TYPE,
    PROCEDURE_LEVEL, APPLICATION_IND_GROUP, APPLICATION_GROUP_SIZE,
    RSD_LEVEL, DECISION_IND_GROUP, DECISION_GROUP_SIZE,
    COU_CODE_ORIGIN,
    ASY_START, ASY_AH_START,
    ASYAPP, ASYREC_CV, ASYREC_CP, ASYREJ, ASYOTHCL, TOTAL_DECISIONS,
    ASY_END, ASY_AH_END
  from S_ASR_RSD_2000
  union all
  select STATSYEAR, DISPLACEMENT_STATUS, COU_CODE_ASYLUM,
    case when RSD_TYPE = 'V' then 'J' else RSD_TYPE end as RSD_TYPE,
    PROCEDURE_LEVEL, APPLICATION_IND_GROUP, APPLICATION_GROUP_SIZE,
    RSD_LEVEL, DECISION_IND_GROUP, DECISION_GROUP_SIZE,
    case when COU_CODE_ORIGIN = 'GUB' then 'GNB' else COU_CODE_ORIGIN end as COU_CODE_ORIGIN,
    ASY_START, ASY_AH_START,
    ASYAPP, ASYREC_CV, ASYREC_CP, ASYREJ, ASYOTHCL, TOTAL_DECISIONS,
    ASY_END, ASY_AH_END
  from S_ASR_RSD_2001
  union all
  select STATSYEAR, DISPLACEMENT_STATUS, COU_CODE_ASYLUM,
    case when RSD_TYPE = 'V' then 'J' else RSD_TYPE end as RSD_TYPE,
    PROCEDURE_LEVEL, APPLICATION_IND_GROUP, APPLICATION_GROUP_SIZE,
    RSD_LEVEL, DECISION_IND_GROUP, DECISION_GROUP_SIZE,
    COU_CODE_ORIGIN,
    ASY_START, ASY_AH_START,
    ASYAPP, ASYREC_CV, ASYREC_CP, ASYREJ, ASYOTHCL, TOTAL_DECISIONS,
    ASY_END, ASY_AH_END
  from S_ASR_RSD_2002
  union all
  select STATSYEAR, DISPLACEMENT_STATUS, COU_CODE_ASYLUM,
    case when RSD_TYPE = 'V' then 'J' else RSD_TYPE end as RSD_TYPE,
    PROCEDURE_LEVEL, APPLICATION_IND_GROUP, APPLICATION_GROUP_SIZE,
    upper(RSD_LEVEL) as RSD_LEVEL,
    DECISION_IND_GROUP, DECISION_GROUP_SIZE,
    COU_CODE_ORIGIN,
    ASY_START, ASY_AH_START,
    ASYAPP, ASYREC_CV, ASYREC_CP, ASYREJ, ASYOTHCL, TOTAL_DECISIONS,
    ASY_END, ASY_AH_END
  from S_ASR_RSD_2003
  union all
  select STATSYEAR, DISPLACEMENT_STATUS, COU_CODE_ASYLUM,
    case when RSD_TYPE = 'B' then 'J' else RSD_TYPE end as RSD_TYPE,
    PROCEDURE_LEVEL, APPLICATION_IND_GROUP, APPLICATION_GROUP_SIZE,
    RSD_LEVEL, DECISION_IND_GROUP, DECISION_GROUP_SIZE,
    COU_CODE_ORIGIN,
    ASY_START, ASY_AH_START,
    ASYAPP, ASYREC_CV, ASYREC_CP, ASYREJ, ASYOTHCL, TOTAL_DECISIONS,
    ASY_END, ASY_AH_END
  from S_ASR_RSD_2004
  union all
  select STATSYEAR, DISPLACEMENT_STATUS, COU_CODE_ASYLUM,
    case when RSD_TYPE = 'B' then 'J' else RSD_TYPE end as RSD_TYPE,
    PROCEDURE_LEVEL, APPLICATION_IND_GROUP, APPLICATION_GROUP_SIZE,
    RSD_LEVEL, DECISION_IND_GROUP, DECISION_GROUP_SIZE,
    COU_CODE_ORIGIN,
    ASY_START, ASY_AH_START,
    ASYAPP, ASYREC_CV, ASYREC_CP, ASYREJ, ASYOTHCL, TOTAL_DECISIONS,
    ASY_END, ASY_AH_END
  from S_ASR_RSD_2005
  union all
  select STATSYEAR, DISPLACEMENT_STATUS, COU_CODE_ASYLUM,
    RSD_TYPE, PROCEDURE_LEVEL, APPLICATION_IND_GROUP, APPLICATION_GROUP_SIZE,
    RSD_LEVEL, DECISION_IND_GROUP, DECISION_GROUP_SIZE,
    COU_CODE_ORIGIN,
    ASY_START, ASY_AH_START,
    ASYAPP, ASYREC_CV, ASYREC_CP, ASYREJ, ASYOTHCL, TOTAL_DECISIONS,
    ASY_END, ASY_AH_END
  from S_ASR_RSD_2006
  union all
  select STATSYEAR, DISPLACEMENT_STATUS, COU_CODE_ASYLUM,
    RSD_TYPE, PROCEDURE_LEVEL, APPLICATION_IND_GROUP, APPLICATION_GROUP_SIZE,
    RSD_LEVEL, DECISION_IND_GROUP, DECISION_GROUP_SIZE,
    COU_CODE_ORIGIN,
    ASY_START, ASY_AH_START,
    ASYAPP, ASYREC_CV, ASYREC_CP, ASYREJ, ASYOTHCL, TOTAL_DECISIONS,
    ASY_END, ASY_AH_END
  from S_ASR_RSD_2007
  union all
  select STATSYEAR, DISPLACEMENT_STATUS, COU_CODE_ASYLUM,
    RSD_TYPE, PROCEDURE_LEVEL, APPLICATION_IND_GROUP, APPLICATION_GROUP_SIZE,
    RSD_LEVEL, DECISION_IND_GROUP, DECISION_GROUP_SIZE,
    COU_CODE_ORIGIN,
    ASY_START, ASY_AH_START,
    ASYAPP, ASYREC_CV, ASYREC_CP, ASYREJ, ASYOTHCL, TOTAL_DECISIONS,
    ASY_END, ASY_AH_END
  from S_ASR_RSD_2008
  union all
  select STATSYEAR, DISPLACEMENT_STATUS, COU_CODE_ASYLUM,
    RSD_TYPE, PROCEDURE_LEVEL, APPLICATION_IND_GROUP, APPLICATION_GROUP_SIZE,
    RSD_LEVEL, DECISION_IND_GROUP, DECISION_GROUP_SIZE,
    case when COU_CODE_ORIGIN = 'BRB' then 'BAR' else COU_CODE_ORIGIN end as COU_CODE_ORIGIN,
    ASY_START, ASY_AH_START,
    ASYAPP, ASYREC_CV, ASYREC_CP, ASYREJ, ASYOTHCL, TOTAL_DECISIONS,
    ASY_END, ASY_AH_END
  from S_ASR_RSD_2009
  union all
  select STATSYEAR, DISPLACEMENT_STATUS, COU_CODE_ASYLUM,
    RSD_TYPE, PROCEDURE_LEVEL, APPLICATION_IND_GROUP, APPLICATION_GROUP_SIZE,
    RSD_LEVEL, DECISION_IND_GROUP, DECISION_GROUP_SIZE,
    COU_CODE_ORIGIN,
    ASY_START, ASY_AH_START,
    ASYAPP, ASYREC_CV, ASYREC_CP, ASYREJ, ASYOTHCL, TOTAL_DECISIONS,
    ASY_END, ASY_AH_END
  from S_ASR_RSD_2010
  union all
  select STATSYEAR, DISPLACEMENT_STATUS, COU_CODE_ASYLUM,
    RSD_TYPE, PROCEDURE_LEVEL, APPLICATION_IND_GROUP, APPLICATION_GROUP_SIZE,
    RSD_LEVEL, DECISION_IND_GROUP, DECISION_GROUP_SIZE,
    COU_CODE_ORIGIN,
    ASY_START, ASY_AH_START,
    ASYAPP, ASYREC_CV, ASYREC_CP, ASYREJ, ASYOTHCL, TOTAL_DECISIONS,
    ASY_END, ASY_AH_END
  from S_ASR_RSD_2011
  union all
  select STATSYEAR, DISPLACEMENT_STATUS, COU_CODE_ASYLUM,
    RSD_TYPE, PROCEDURE_LEVEL, APPLICATION_IND_GROUP, APPLICATION_GROUP_SIZE,
    RSD_LEVEL, DECISION_IND_GROUP, DECISION_GROUP_SIZE,
    COU_CODE_ORIGIN,
    ASY_START, ASY_AH_START,
    ASYAPP, ASYREC_CV, ASYREC_CP, ASYREJ, ASYOTHCL, TOTAL_DECISIONS,
    ASY_END, ASY_AH_END
  from S_ASR_RSD_2012
  union all
  select STATSYEAR, DISPLACEMENT_STATUS, COU_CODE_ASYLUM,
    RSD_TYPE, PROCEDURE_LEVEL, APPLICATION_IND_GROUP, APPLICATION_GROUP_SIZE,
    RSD_LEVEL, DECISION_IND_GROUP, DECISION_GROUP_SIZE,
    COU_CODE_ORIGIN,
    ASY_START, ASY_AH_START,
    ASYAPP, ASYREC_CV, ASYREC_CP, ASYREJ, ASYOTHCL, TOTAL_DECISIONS,
    ASY_END, ASY_AH_END
  from S_ASR_RSD_2013) ASR;


create materialized view S_ASR_RSD build deferred as
select STATSYEAR, DST_CODE, COU_CODE_ASYLUM, RSD_TYPE, RSD_LEVEL, COU_CODE_ORIGIN,
  DATA_POINT, VALUE
from
 (select STATSYEAR, DST_CODE, COU_CODE_ASYLUM, RSD_TYPE, RSD_LEVEL, COU_CODE_ORIGIN,
    round(sum(ASY_START)) as ASY_START,
    round(sum(ASY_AH_START)) as ASY_AH_START,
    round(sum(ASYAPP)) as ASYAPP,
    round(sum(ASYREC_CV)) as ASYREC_CV,
    round(sum(ASYREC_CP)) as ASYREC_CP,
    round(sum(ASYREJ)) as ASYREJ,
    round(sum(ASYOTHCL)) as ASYOTHCL,
    round(sum(ASY_END)) as ASY_END,
    round(sum(ASY_AH_END)) as ASY_AH_END
  from S_ASR_RSD_CLEANED
  group by STATSYEAR, DST_CODE, COU_CODE_ASYLUM, RSD_TYPE, RSD_LEVEL, COU_CODE_ORIGIN)
unpivot
 (VALUE for DATA_POINT in
   (ASY_START, ASY_AH_START,
    ASYAPP, ASYREC_CV, ASYREC_CP, ASYREJ, ASYOTHCL,
    ASY_END, ASY_AH_END))
where VALUE != 0;


grant select on S_ASR_RSD to PSR_STAGE;


/* Verification queries
select sum(ROW_COUNT) as RAW_ROW_COUNT,
  count(*) as AGGREGATED_ROW_COUNT,
  count(
    case
      when ASY_START != 0 or ASY_AH_START != 0 or
        ASYAPP != 0 or ASYREC_CV != 0 or ASYREC_CP != 0 or ASYREJ != 0 or ASYOTHCL != 0 or
        ASY_END != 0 or ASY_AH_END != 0
      then 1
    end) as FILTERED_AGGREGATED_ROW_COUNT,
  count(*) * 9 as VALUE_COUNT,
  count(ASY_START) + count(ASY_AH_START) + count(ASYAPP) + count(ASYREC_CV) + count(ASYREC_CP) +
    count(ASYREJ) + count(ASYOTHCL) + count(ASY_END) + count(ASY_AH_END) as NON_NULL_COUNT,
  count(case when ASY_START != 0 then 1 end) + count(case when ASY_AH_START != 0 then 1 end) +
    count(case when ASYAPP != 0 then 1 end) + count(case when ASYREC_CV != 0 then 1 end) +
    count(case when ASYREC_CP != 0 then 1 end) + count(case when ASYREJ != 0 then 1 end) +
    count(case when ASYOTHCL != 0 then 1 end) + count(case when ASY_END != 0 then 1 end) +
    count(case when ASY_AH_END != 0 then 1 end) as NON_ZERO_COUNT
from
 (select count(*) as ROW_COUNT,
    sum(ASY_START) as ASY_START, sum(ASY_AH_START) as ASY_AH_START, sum(ASYAPP) as ASYAPP,
    sum(ASYREC_CV) as ASYREC_CV, sum(ASYREC_CP) as ASYREC_CP, sum(ASYREJ) as ASYREJ,
    sum(ASYOTHCL) as ASYOTHCL, sum(ASY_END) as ASY_END, sum(ASY_AH_END) as ASY_AH_END
  from S_ASR_RSD_CLEANED
  group by STATSYEAR, DST_CODE, COU_CODE_ASYLUM, RSD_TYPE, RSD_LEVEL, COU_CODE_ORIGIN);

select count(*) as KEY_COUNT, sum(ROW_COUNT) as ROW_COUNT
from
 (select count(*) as ROW_COUNT
  from S_ASR_RSD
  group by STATSYEAR, DST_CODE, COU_CODE_ASYLUM, RSD_TYPE, RSD_LEVEL, COU_CODE_ORIGIN);
*/