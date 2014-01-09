create table S_ASR_REFUGEES_2000
 (STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  DISPLACEMENT_STATUS varchar2(100),
  POP_START varchar2(40),
  POP_AH_START varchar2(40),
  ARR_GRP varchar2(40),
  ARR_IND varchar2(40),
  ARR_RESTL varchar2(40),
  BIRTH varchar2(40),
  REFOTHINC varchar2(40),
  TOTAL_INCREASE varchar2(40),
  VOLREP varchar2(40),
  VOLREP_AH varchar2(40),
  RESTL varchar2(40),
  RESTL_AH varchar2(40),
  CESSATION varchar2(40),
  NATURLZN varchar2(40),
  DEATH varchar2(40),
  REFOTHDEC varchar2(40),
  TOTAL_DECREASE varchar2(40),
  POP_END varchar2(40),
  POP_AH_END varchar2(40),
  SOURCE_BASIS varchar2(20))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_REFUGEES_2000.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_REFUGEES_2000.log'
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (COU_CODE_ASYLUM char(4000),
      COU_CODE_ORIGIN char(4000),
      FILLER1 char(4000),
      FILLER2 char(4000),
      POP_START char(4000),
      POP_AH_START char(4000),
      ARR_GRP char(4000),
      ARR_IND char(4000),
      ARR_RESTL char(4000),
      REFOTHINC char(4000),
      TOTAL_INCREASE char(4000),
      VOLREP char(4000),
      VOLREP_AH char(4000),
      FILLER3 char(4000),
      FILLER4 char(4000),
      FILLER5 char(4000),
      FILLER6 char(4000),
      RESTL char(4000),
      RESTL_AH char(4000),
      CESSATION char(4000),
      NATURLZN char(4000),
      REFOTHDEC char(4000),
      TOTAL_DECREASE char(4000),
      POP_END char(4000),
      POP_AH_END char(4000),
      SOURCE_BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2000',
      DISPLACEMENT_STATUS from constant 'REF',
      BIRTH from null,
      DEATH from null))
  location ('ASR_REFUGEES_2000.csv'))
reject limit unlimited;

create table S_ASR_REFUGEES_2001
 (STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  DISPLACEMENT_STATUS varchar2(100),
  POP_START varchar2(40),
  POP_AH_START varchar2(40),
  ARR_GRP varchar2(40),
  ARR_IND varchar2(40),
  ARR_RESTL varchar2(40),
  BIRTH varchar2(40),
  REFOTHINC varchar2(40),
  TOTAL_INCREASE varchar2(40),
  VOLREP varchar2(40),
  VOLREP_AH varchar2(40),
  RESTL varchar2(40),
  RESTL_AH varchar2(40),
  CESSATION varchar2(40),
  NATURLZN varchar2(40),
  DEATH varchar2(40),
  REFOTHDEC varchar2(40),
  TOTAL_DECREASE varchar2(40),
  POP_END varchar2(40),
  POP_AH_END varchar2(40),
  SOURCE_BASIS varchar2(20))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_REFUGEES_2001.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_REFUGEES_2001.log'
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      FILLER2 char(4000),
      COU_CODE_ASYLUM char(4000),
      COU_CODE_ORIGIN char(4000),
      POP_START char(4000),
      POP_AH_START char(4000),
      ARR_GRP char(4000),
      ARR_IND char(4000),
      ARR_RESTL char(4000),
      REFOTHINC char(4000),
      TOTAL_INCREASE char(4000),
      VOLREP char(4000),
      VOLREP_AH char(4000),
      FILLER3 char(4000),
      FILLER4 char(4000),
      FILLER5 char(4000),
      FILLER6 char(4000),
      RESTL char(4000),
      RESTL_AH char(4000),
      CESSATION char(4000),
      NATURLZN char(4000),
      REFOTHDEC char(4000),
      TOTAL_DECREASE char(4000),
      POP_END char(4000),
      POP_AH_END char(4000),
      SOURCE_BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2001',
      DISPLACEMENT_STATUS from constant 'REF',
      BIRTH from null,
      DEATH from null))
  location ('ASR_REFUGEES_2001.csv'))
reject limit unlimited;

create table S_ASR_REFUGEES_2002
 (STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  DISPLACEMENT_STATUS varchar2(100),
  POP_START varchar2(40),
  POP_AH_START varchar2(40),
  ARR_GRP varchar2(40),
  ARR_IND varchar2(40),
  ARR_RESTL varchar2(40),
  BIRTH varchar2(40),
  REFOTHINC varchar2(40),
  TOTAL_INCREASE varchar2(40),
  VOLREP varchar2(40),
  VOLREP_AH varchar2(40),
  RESTL varchar2(40),
  RESTL_AH varchar2(40),
  CESSATION varchar2(40),
  NATURLZN varchar2(40),
  DEATH varchar2(40),
  REFOTHDEC varchar2(40),
  TOTAL_DECREASE varchar2(40),
  POP_END varchar2(40),
  POP_AH_END varchar2(40),
  SOURCE_BASIS varchar2(20))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_REFUGEES_2002.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_REFUGEES_2002.log'
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      FILLER2 char(4000),
      FILLER3 char(4000),
      FILLER4 char(4000),
      COU_CODE_ASYLUM char(4000),
      COU_CODE_ORIGIN char(4000),
      POP_START char(4000),
      POP_AH_START char(4000),
      ARR_GRP char(4000),
      ARR_IND char(4000),
      ARR_RESTL char(4000),
      REFOTHINC char(4000),
      TOTAL_INCREASE char(4000),
      VOLREP char(4000),
      VOLREP_AH char(4000),
      FILLER5 char(4000),
      FILLER6 char(4000),
      FILLER7 char(4000),
      FILLER8 char(4000),
      RESTL char(4000),
      RESTL_AH char(4000),
      CESSATION char(4000),
      NATURLZN char(4000),
      REFOTHDEC char(4000),
      TOTAL_DECREASE char(4000),
      POP_END char(4000),
      POP_AH_END char(4000),
      SOURCE_BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2002',
      DISPLACEMENT_STATUS from constant 'REF',
      BIRTH from null,
      DEATH from null))
  location ('ASR_REFUGEES_2002.csv'))
reject limit unlimited;

create table S_ASR_REFUGEES_2003
 (STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  DISPLACEMENT_STATUS varchar2(100),
  POP_START varchar2(40),
  POP_AH_START varchar2(40),
  ARR_GRP varchar2(40),
  ARR_IND varchar2(40),
  ARR_RESTL varchar2(40),
  BIRTH varchar2(40),
  REFOTHINC varchar2(40),
  TOTAL_INCREASE varchar2(40),
  VOLREP varchar2(40),
  VOLREP_AH varchar2(40),
  RESTL varchar2(40),
  RESTL_AH varchar2(40),
  CESSATION varchar2(40),
  NATURLZN varchar2(40),
  DEATH varchar2(40),
  REFOTHDEC varchar2(40),
  TOTAL_DECREASE varchar2(40),
  POP_END varchar2(40),
  POP_AH_END varchar2(40),
  SOURCE_BASIS varchar2(20))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_REFUGEES_2003.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_REFUGEES_2003.log'
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
      COU_CODE_ORIGIN char(4000),
      POP_START char(4000),
      POP_AH_START char(4000),
      ARR_GRP char(4000),
      ARR_IND char(4000),
      ARR_RESTL char(4000),
      REFOTHINC char(4000),
      TOTAL_INCREASE char(4000),
      VOLREP char(4000),
      VOLREP_AH char(4000),
      FILLER6 char(4000),
      FILLER7 char(4000),
      FILLER8 char(4000),
      FILLER9 char(4000),
      RESTL char(4000),
      RESTL_AH char(4000),
      CESSATION char(4000),
      NATURLZN char(4000),
      REFOTHDEC char(4000),
      TOTAL_DECREASE char(4000),
      POP_END char(4000),
      POP_AH_END char(4000),
      SOURCE_BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2003',
      DISPLACEMENT_STATUS from constant 'REF',
      BIRTH from null,
      DEATH from null))
  location ('ASR_REFUGEES_2003.csv'))
reject limit unlimited;

create table S_ASR_REFUGEES_2004
 (STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  DISPLACEMENT_STATUS varchar2(100),
  POP_START varchar2(40),
  POP_AH_START varchar2(40),
  ARR_GRP varchar2(40),
  ARR_IND varchar2(40),
  ARR_RESTL varchar2(40),
  BIRTH varchar2(40),
  REFOTHINC varchar2(40),
  TOTAL_INCREASE varchar2(40),
  VOLREP varchar2(40),
  VOLREP_AH varchar2(40),
  RESTL varchar2(40),
  RESTL_AH varchar2(40),
  CESSATION varchar2(40),
  NATURLZN varchar2(40),
  DEATH varchar2(40),
  REFOTHDEC varchar2(40),
  TOTAL_DECREASE varchar2(40),
  POP_END varchar2(40),
  POP_AH_END varchar2(40),
  SOURCE_BASIS varchar2(20))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_REFUGEES_2004.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_REFUGEES_2004.log'
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
      COU_CODE_ORIGIN char(4000),
      POP_START char(4000),
      POP_AH_START char(4000),
      ARR_GRP char(4000),
      ARR_IND char(4000),
      ARR_RESTL char(4000),
      REFOTHINC char(4000),
      TOTAL_INCREASE char(4000),
      VOLREP char(4000),
      VOLREP_AH char(4000),
      RESTL char(4000),
      RESTL_AH char(4000),
      CESSATION char(4000),
      NATURLZN char(4000),
      REFOTHDEC char(4000),
      TOTAL_DECREASE char(4000),
      POP_END char(4000),
      POP_AH_END char(4000),
      SOURCE_BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2004',
      DISPLACEMENT_STATUS from constant 'REF',
      BIRTH from null,
      DEATH from null))
  location ('ASR_REFUGEES_2004.csv'))
reject limit unlimited;

create table S_ASR_REFUGEES_2005
 (STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  DISPLACEMENT_STATUS varchar2(100),
  POP_START varchar2(40),
  POP_AH_START varchar2(40),
  ARR_GRP varchar2(40),
  ARR_IND varchar2(40),
  ARR_RESTL varchar2(40),
  BIRTH varchar2(40),
  REFOTHINC varchar2(40),
  TOTAL_INCREASE varchar2(40),
  VOLREP varchar2(40),
  VOLREP_AH varchar2(40),
  RESTL varchar2(40),
  RESTL_AH varchar2(40),
  CESSATION varchar2(40),
  NATURLZN varchar2(40),
  DEATH varchar2(40),
  REFOTHDEC varchar2(40),
  TOTAL_DECREASE varchar2(40),
  POP_END varchar2(40),
  POP_AH_END varchar2(40),
  SOURCE_BASIS varchar2(20))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_REFUGEES_2005.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_REFUGEES_2005.log'
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
      COU_CODE_ORIGIN char(4000),
      POP_START char(4000),
      POP_AH_START char(4000),
      ARR_GRP char(4000),
      ARR_IND char(4000),
      ARR_RESTL char(4000),
      REFOTHINC char(4000),
      TOTAL_INCREASE char(4000),
      VOLREP char(4000),
      VOLREP_AH char(4000),
      RESTL char(4000),
      RESTL_AH char(4000),
      CESSATION char(4000),
      NATURLZN char(4000),
      REFOTHDEC char(4000),
      TOTAL_DECREASE char(4000),
      POP_END char(4000),
      POP_AH_END char(4000),
      SOURCE_BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2005',
      DISPLACEMENT_STATUS from constant 'REF',
      BIRTH from null,
      DEATH from null))
  location ('ASR_REFUGEES_2005.csv'))
reject limit unlimited;

create table S_ASR_REFUGEES_2006
 (STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  DISPLACEMENT_STATUS varchar2(100),
  POP_START varchar2(40),
  POP_AH_START varchar2(40),
  ARR_GRP varchar2(40),
  ARR_IND varchar2(40),
  ARR_RESTL varchar2(40),
  BIRTH varchar2(40),
  REFOTHINC varchar2(40),
  TOTAL_INCREASE varchar2(40),
  VOLREP varchar2(40),
  VOLREP_AH varchar2(40),
  RESTL varchar2(40),
  RESTL_AH varchar2(40),
  CESSATION varchar2(40),
  NATURLZN varchar2(40),
  DEATH varchar2(40),
  REFOTHDEC varchar2(40),
  TOTAL_DECREASE varchar2(40),
  POP_END varchar2(40),
  POP_AH_END varchar2(40),
  SOURCE varchar2(10),
  BASIS varchar2(10))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_REFUGEES_2006.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_REFUGEES_2006.log'
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
      COU_CODE_ORIGIN char(4000),
      FILLER6 char(4000),
      POP_START char(4000),
      POP_AH_START char(4000),
      ARR_GRP char(4000),
      ARR_IND char(4000),
      ARR_RESTL char(4000),
      BIRTH char(4000),
      REFOTHINC char(4000),
      TOTAL_INCREASE char(4000),
      VOLREP char(4000),
      VOLREP_AH char(4000),
      RESTL char(4000),
      RESTL_AH char(4000),
      CESSATION char(4000),
      NATURLZN char(4000),
      DEATH char(4000),
      REFOTHDEC char(4000),
      TOTAL_DECREASE char(4000),
      POP_END char(4000),
      POP_AH_END char(4000),
      SOURCE char(4000),
      BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2006',
      DISPLACEMENT_STATUS from constant 'REF'))
  location ('ASR_REFUGEES_2006.csv'))
reject limit unlimited;

create table S_ASR_REFUGEES_2007
 (STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  DISPLACEMENT_STATUS varchar2(100),
  POP_START varchar2(40),
  POP_AH_START varchar2(40),
  ARR_GRP varchar2(40),
  ARR_IND varchar2(40),
  ARR_RESTL varchar2(40),
  BIRTH varchar2(40),
  REFOTHINC varchar2(40),
  TOTAL_INCREASE varchar2(40),
  VOLREP varchar2(40),
  VOLREP_AH varchar2(40),
  RESTL varchar2(40),
  RESTL_AH varchar2(40),
  CESSATION varchar2(40),
  NATURLZN varchar2(40),
  DEATH varchar2(40),
  REFOTHDEC varchar2(40),
  TOTAL_DECREASE varchar2(40),
  POP_END varchar2(40),
  POP_AH_END varchar2(40),
  SOURCE varchar2(10),
  BASIS varchar2(10))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_REFUGEES_2007.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_REFUGEES_2007.log'
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
      COU_CODE_ORIGIN char(4000),
      FILLER6 char(4000),
      POP_START char(4000),
      POP_AH_START char(4000),
      ARR_GRP char(4000),
      ARR_IND char(4000),
      ARR_RESTL char(4000),
      BIRTH char(4000),
      REFOTHINC char(4000),
      TOTAL_INCREASE char(4000),
      VOLREP char(4000),
      VOLREP_AH char(4000),
      RESTL char(4000),
      RESTL_AH char(4000),
      CESSATION char(4000),
      NATURLZN char(4000),
      DEATH char(4000),
      REFOTHDEC char(4000),
      TOTAL_DECREASE char(4000),
      POP_END char(4000),
      POP_AH_END char(4000),
      SOURCE char(4000),
      BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2007',
      DISPLACEMENT_STATUS from constant 'REF'))
  location ('ASR_REFUGEES_2007.csv'))
reject limit unlimited;

create table S_ASR_REFUGEES_2008
 (STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  DISPLACEMENT_STATUS varchar2(100),
  POP_START varchar2(40),
  POP_AH_START varchar2(40),
  ARR_GRP varchar2(40),
  ARR_IND varchar2(40),
  ARR_RESTL varchar2(40),
  BIRTH varchar2(40),
  REFOTHINC varchar2(40),
  TOTAL_INCREASE varchar2(40),
  VOLREP varchar2(40),
  VOLREP_AH varchar2(40),
  RESTL varchar2(40),
  RESTL_AH varchar2(40),
  CESSATION varchar2(40),
  NATURLZN varchar2(40),
  DEATH varchar2(40),
  REFOTHDEC varchar2(40),
  TOTAL_DECREASE varchar2(40),
  POP_END varchar2(40),
  POP_AH_END varchar2(40),
  SOURCE varchar2(10),
  BASIS varchar2(10))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_REFUGEES_2008.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_REFUGEES_2008.log'
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
      COU_CODE_ORIGIN char(4000),
      DISPLACEMENT_STATUS char(4000),
      POP_START char(4000),
      POP_AH_START char(4000),
      ARR_GRP char(4000),
      ARR_IND char(4000),
      ARR_RESTL char(4000),
      BIRTH char(4000),
      REFOTHINC char(4000),
      TOTAL_INCREASE char(4000),
      VOLREP char(4000),
      VOLREP_AH char(4000),
      RESTL char(4000),
      RESTL_AH char(4000),
      CESSATION char(4000),
      NATURLZN char(4000),
      DEATH char(4000),
      REFOTHDEC char(4000),
      TOTAL_DECREASE char(4000),
      POP_END char(4000),
      POP_AH_END char(4000),
      SOURCE char(4000),
      BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2008'))
  location ('ASR_REFUGEES_2008.csv', 'ASR_REFUGEE_LIKE_2008.csv'))
reject limit unlimited;

create table S_ASR_REFUGEES_2009
 (STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  DISPLACEMENT_STATUS varchar2(100),
  POP_START varchar2(40),
  POP_AH_START varchar2(40),
  ARR_GRP varchar2(40),
  ARR_IND varchar2(40),
  ARR_RESTL varchar2(40),
  BIRTH varchar2(40),
  REFOTHINC varchar2(40),
  TOTAL_INCREASE varchar2(40),
  VOLREP varchar2(40),
  VOLREP_AH varchar2(40),
  RESTL varchar2(40),
  RESTL_AH varchar2(40),
  CESSATION varchar2(40),
  NATURLZN varchar2(40),
  DEATH varchar2(40),
  REFOTHDEC varchar2(40),
  TOTAL_DECREASE varchar2(40),
  POP_END varchar2(40),
  POP_AH_END varchar2(40),
  SOURCE varchar2(10),
  BASIS varchar2(10))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_REFUGEES_2009.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_REFUGEES_2009.log'
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
      COU_CODE_ORIGIN char(4000),
      DISPLACEMENT_STATUS char(4000),
      POP_START char(4000),
      POP_AH_START char(4000),
      ARR_GRP char(4000),
      ARR_IND char(4000),
      ARR_RESTL char(4000),
      BIRTH char(4000),
      REFOTHINC char(4000),
      TOTAL_INCREASE char(4000),
      VOLREP char(4000),
      VOLREP_AH char(4000),
      RESTL char(4000),
      RESTL_AH char(4000),
      CESSATION char(4000),
      NATURLZN char(4000),
      DEATH char(4000),
      REFOTHDEC char(4000),
      TOTAL_DECREASE char(4000),
      POP_END char(4000),
      POP_AH_END char(4000),
      SOURCE char(4000),
      BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2009'))
  location ('ASR_REFUGEES_2009.csv', 'ASR_REFUGEE_LIKE_2009.csv'))
reject limit unlimited;

create table S_ASR_REFUGEES_2010
 (STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  DISPLACEMENT_STATUS varchar2(100),
  POP_START varchar2(40),
  POP_AH_START varchar2(40),
  ARR_GRP varchar2(40),
  ARR_IND varchar2(40),
  ARR_RESTL varchar2(40),
  BIRTH varchar2(40),
  REFOTHINC varchar2(40),
  TOTAL_INCREASE varchar2(40),
  VOLREP varchar2(40),
  VOLREP_AH varchar2(40),
  RESTL varchar2(40),
  RESTL_AH varchar2(40),
  CESSATION varchar2(40),
  NATURLZN varchar2(40),
  DEATH varchar2(40),
  REFOTHDEC varchar2(40),
  TOTAL_DECREASE varchar2(40),
  POP_END varchar2(40),
  POP_AH_END varchar2(40),
  SOURCE varchar2(10),
  BASIS varchar2(10))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_REFUGEES_2010.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_REFUGEES_2010.log'
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
      COU_CODE_ORIGIN char(4000),
      DISPLACEMENT_STATUS char(4000),
      POP_START char(4000),
      POP_AH_START char(4000),
      ARR_GRP char(4000),
      ARR_IND char(4000),
      ARR_RESTL char(4000),
      BIRTH char(4000),
      REFOTHINC char(4000),
      TOTAL_INCREASE char(4000),
      VOLREP char(4000),
      VOLREP_AH char(4000),
      RESTL char(4000),
      RESTL_AH char(4000),
      CESSATION char(4000),
      NATURLZN char(4000),
      DEATH char(4000),
      REFOTHDEC char(4000),
      TOTAL_DECREASE char(4000),
      POP_END char(4000),
      POP_AH_END char(4000),
      SOURCE char(4000),
      BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2010'))
  location ('ASR_REFUGEES_2010.csv', 'ASR_REFUGEE_LIKE_2010.csv'))
reject limit unlimited;

create table S_ASR_REFUGEES_2011
 (STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  DISPLACEMENT_STATUS varchar2(100),
  POP_START varchar2(40),
  POP_AH_START varchar2(40),
  ARR_GRP varchar2(40),
  ARR_IND varchar2(40),
  ARR_RESTL varchar2(40),
  BIRTH varchar2(40),
  REFOTHINC varchar2(40),
  TOTAL_INCREASE varchar2(40),
  VOLREP varchar2(40),
  VOLREP_AH varchar2(40),
  RESTL varchar2(40),
  RESTL_AH varchar2(40),
  CESSATION varchar2(40),
  NATURLZN varchar2(40),
  DEATH varchar2(40),
  REFOTHDEC varchar2(40),
  TOTAL_DECREASE varchar2(40),
  POP_END varchar2(40),
  POP_AH_END varchar2(40),
  SOURCE varchar2(10),
  BASIS varchar2(10))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_REFUGEES_2011.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_REFUGEES_2011.log'
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
      COU_CODE_ORIGIN char(4000),
      DISPLACEMENT_STATUS char(4000),
      POP_START char(4000),
      POP_AH_START char(4000),
      ARR_GRP char(4000),
      ARR_IND char(4000),
      ARR_RESTL char(4000),
      BIRTH char(4000),
      REFOTHINC char(4000),
      TOTAL_INCREASE char(4000),
      VOLREP char(4000),
      VOLREP_AH char(4000),
      RESTL char(4000),
      RESTL_AH char(4000),
      CESSATION char(4000),
      NATURLZN char(4000),
      DEATH char(4000),
      REFOTHDEC char(4000),
      TOTAL_DECREASE char(4000),
      POP_END char(4000),
      POP_AH_END char(4000),
      SOURCE char(4000),
      BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2011'))
  location ('ASR_REFUGEES_2011.csv', 'ASR_REFUGEE_LIKE_2011.csv'))
reject limit unlimited;

create table S_ASR_REFUGEES_2012
 (STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  DISPLACEMENT_STATUS varchar2(100),
  POP_START varchar2(40),
  POP_AH_START varchar2(40),
  ARR_GRP varchar2(40),
  ARR_IND varchar2(40),
  ARR_RESTL varchar2(40),
  BIRTH varchar2(40),
  REFOTHINC varchar2(40),
  TOTAL_INCREASE varchar2(40),
  VOLREP varchar2(40),
  VOLREP_AH varchar2(40),
  RESTL varchar2(40),
  RESTL_AH varchar2(40),
  CESSATION varchar2(40),
  NATURLZN varchar2(40),
  DEATH varchar2(40),
  REFOTHDEC varchar2(40),
  TOTAL_DECREASE varchar2(40),
  POP_END varchar2(40),
  POP_AH_END varchar2(40),
  SOURCE varchar2(10),
  BASIS varchar2(10))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_REFUGEES_2012.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_REFUGEES_2012.log'
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
      COU_CODE_ORIGIN char(4000),
      DISPLACEMENT_STATUS char(4000),
      POP_START char(4000),
      POP_AH_START char(4000),
      ARR_GRP char(4000),
      ARR_IND char(4000),
      ARR_RESTL char(4000),
      BIRTH char(4000),
      REFOTHINC char(4000),
      TOTAL_INCREASE char(4000),
      VOLREP char(4000),
      VOLREP_AH char(4000),
      RESTL char(4000),
      RESTL_AH char(4000),
      CESSATION char(4000),
      NATURLZN char(4000),
      DEATH char(4000),
      REFOTHDEC char(4000),
      TOTAL_DECREASE char(4000),
      POP_END char(4000),
      POP_AH_END char(4000),
      SOURCE char(4000),
      BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2012'))
  location ('ASR_REFUGEES_2012.csv', 'ASR_REFUGEE_LIKE_2012.csv'))
reject limit unlimited;

create table S_ASR_REFUGEES_2013
 (STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  DISPLACEMENT_STATUS varchar2(100),
  POP_START varchar2(40),
  POP_AH_START varchar2(40),
  ARR_GRP varchar2(40),
  ARR_TMP varchar2(40),
  ARR_IND varchar2(40),
  ARR_RESTL varchar2(40),
  BIRTH varchar2(40),
  REFOTHINC varchar2(40),
  TOTAL_INCREASE varchar2(40),
  VOLREP varchar2(40),
  VOLREP_AH varchar2(40),
  RESTL varchar2(40),
  RESTL_AH varchar2(40),
  CESSATION varchar2(40),
  NATURLZN varchar2(40),
  DEATH varchar2(40),
  REFOTHDEC varchar2(40),
  TOTAL_DECREASE varchar2(40),
  POP_END varchar2(40),
  POP_AH_END varchar2(40),
  SOURCE varchar2(10),
  BASIS varchar2(10))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_REFUGEES_2013.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_REFUGEES_2013.log'
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
      COU_CODE_ORIGIN char(4000),
      DISPLACEMENT_STATUS char(4000),
      POP_START char(4000),
      POP_AH_START char(4000),
      ARR_GRP char(4000),
      ARR_TMP char(4000),
      ARR_IND char(4000),
      ARR_RESTL char(4000),
      BIRTH char(4000),
      REFOTHINC char(4000),
      TOTAL_INCREASE char(4000),
      VOLREP char(4000),
      VOLREP_AH char(4000),
      RESTL char(4000),
      RESTL_AH char(4000),
      CESSATION char(4000),
      NATURLZN char(4000),
      DEATH char(4000),
      REFOTHDEC char(4000),
      TOTAL_DECREASE char(4000),
      POP_END char(4000),
      POP_AH_END char(4000),
      SOURCE char(4000),
      BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2013'))
  location ('ASR_REFUGEES_2013.csv', 'ASR_REFUGEE_LIKE_2013.csv'))
reject limit unlimited;


create or replace view S_ASR_REFUGEES_CLEANED as
select ASR.STATSYEAR,
  nvl(DSC.DST_CODE, nvl(upper(ASR.DISPLACEMENT_STATUS), 'REF')) as DST_CODE,
  upper(ASR.COU_CODE_ASYLUM) as COU_CODE_ASYLUM,
  upper(ASR.COU_CODE_ORIGIN) as COU_CODE_ORIGIN,
  to_number(case when ASR.POP_START in ('-', '.', '\', '`', '..') then null
                 else ASR.POP_START end) as POP_START,
  to_number(case when ASR.POP_AH_START in ('-', '.', '\', '`', '..') then null
                 else ASR.POP_AH_START end) as POP_AH_START,
  to_number(case when ASR.ARR_GRP in ('-', '.', '\', '`', '..') then null
                 else ASR.ARR_GRP end) as ARR_GRP,
  to_number(case when ASR.ARR_TMP in ('-', '.', '\', '`', '..') then null
                 else ASR.ARR_TMP end) as ARR_TMP,
  to_number(case when ASR.ARR_IND in ('-', '.', '\', '`', '..') then null
                 else ASR.ARR_IND end) as ARR_IND,
  to_number(case when ASR.ARR_RESTL in ('-', '.', '\', '`', '..') then null
                 else ASR.ARR_RESTL end) as ARR_RESTL,
  to_number(case when ASR.BIRTH in ('-', '.', '\', '`', '..') then null
                 else ASR.BIRTH end) as BIRTH,
  to_number(case when ASR.REFOTHINC in ('-', '.', '\', '`', '..') then null
                 else ASR.REFOTHINC end) as REFOTHINC,
  to_number(case when ASR.TOTAL_INCREASE in ('-', '.', '\', '`', '..') then null
                 else ASR.TOTAL_INCREASE end) as TOTAL_INCREASE,
  to_number(case when ASR.VOLREP in ('-', '.', '\', '`', '..') then null
                 else ASR.VOLREP end) as VOLREP,
  to_number(case when ASR.VOLREP_AH in ('-', '.', '\', '`', '..') then null
                 else ASR.VOLREP_AH end) as VOLREP_AH,
  to_number(case when ASR.RESTL in ('-', '.', '\', '`', '..') then null
                 else ASR.RESTL end) as RESTL,
  to_number(case when ASR.RESTL_AH in ('-', '.', '\', '`', '..') then null
                 else ASR.RESTL_AH end) as RESTL_AH,
  to_number(case when ASR.CESSATION in ('-', '.', '\', '`', '..') then null
                 else ASR.CESSATION end) as CESSATION,
  to_number(case when ASR.NATURLZN in ('-', '.', '\', '`', '..') then null
                 else ASR.NATURLZN end) as NATURLZN,
  to_number(case when ASR.DEATH in ('-', '.', '\', '`', '..') then null
                 else ASR.DEATH end) as DEATH,
  to_number(case when ASR.REFOTHDEC in ('-', '.', '\', '`', '..') then null
                 else ASR.REFOTHDEC end) as REFOTHDEC,
  to_number(case when ASR.TOTAL_DECREASE in ('-', '.', '\', '`', '..') then null
                 else ASR.TOTAL_DECREASE end) as TOTAL_DECREASE,
  to_number(case when ASR.POP_END in ('-', '.', '\', '`', '..') then null
                 else ASR.POP_END end) as POP_END,
  to_number(case when ASR.POP_AH_END in ('-', '.', '\', '`', '..') then null
                 else ASR.POP_AH_END end) as POP_AH_END,
  case when SRC.SOURCE is null then upper(ASR.SOURCE) else SRC.CORRECTED_SOURCE end as SOURCE,
  case when BSC.BASIS is null then upper(ASR.BASIS) else BSC.CORRECTED_BASIS end as BASIS
from
 (select STATSYEAR, DISPLACEMENT_STATUS, COU_CODE_ASYLUM, COU_CODE_ORIGIN,
    POP_START, POP_AH_START,
    ARR_GRP, null as ARR_TMP, ARR_IND, ARR_RESTL, BIRTH, REFOTHINC, TOTAL_INCREASE,
    VOLREP, VOLREP_AH, RESTL, RESTL_AH, CESSATION, NATURLZN, DEATH, REFOTHDEC, TOTAL_DECREASE,
    POP_END, POP_AH_END,
    regexp_replace(upper(SOURCE_BASIS), '^([GNUV]*)/?[CERSV]*$', '\1') as SOURCE,
    regexp_replace(upper(SOURCE_BASIS), '^[GNUV]*/?([CERSV]*)$', '\1') as BASIS
  from S_ASR_REFUGEES_2000
  union all
  select STATSYEAR, DISPLACEMENT_STATUS, COU_CODE_ASYLUM, COU_CODE_ORIGIN,
    POP_START, POP_AH_START,
    ARR_GRP, null as ARR_TMP, ARR_IND, ARR_RESTL, BIRTH, REFOTHINC, TOTAL_INCREASE,
    VOLREP, VOLREP_AH, RESTL, RESTL_AH, CESSATION, NATURLZN, DEATH, REFOTHDEC, TOTAL_DECREASE,
    POP_END, POP_AH_END,
    regexp_replace(upper(SOURCE_BASIS), '^([GNUV]?)[CERSV]*$', '\1') as SOURCE,
    regexp_replace(upper(SOURCE_BASIS), '^[GNUV]?([CERSV]*)$', '\1') as BASIS
  from S_ASR_REFUGEES_2001
  union all
  select STATSYEAR, DISPLACEMENT_STATUS, COU_CODE_ASYLUM, COU_CODE_ORIGIN,
    POP_START, POP_AH_START,
    ARR_GRP, null as ARR_TMP, ARR_IND, ARR_RESTL, BIRTH, REFOTHINC, TOTAL_INCREASE,
    VOLREP, VOLREP_AH, RESTL, RESTL_AH, CESSATION, NATURLZN, DEATH, REFOTHDEC, TOTAL_DECREASE,
    POP_END, POP_AH_END,
    regexp_replace(upper(SOURCE_BASIS), '^([GNUV]?)[CERSV]*$', '\1') as SOURCE,
    regexp_replace(upper(SOURCE_BASIS), '^[GNUV]?([CERSV]*)$', '\1') as BASIS
  from S_ASR_REFUGEES_2002
  union all
  select STATSYEAR, DISPLACEMENT_STATUS, COU_CODE_ASYLUM, COU_CODE_ORIGIN,
    POP_START, POP_AH_START,
    ARR_GRP, null as ARR_TMP, ARR_IND, ARR_RESTL, BIRTH, REFOTHINC, TOTAL_INCREASE,
    VOLREP, VOLREP_AH, RESTL, RESTL_AH, CESSATION, NATURLZN, DEATH, REFOTHDEC, TOTAL_DECREASE,
    POP_END, POP_AH_END,
    regexp_replace(upper(SOURCE_BASIS), '^([GNUV]*)/?[CERSV]*$', '\1') as SOURCE,
    regexp_replace(upper(SOURCE_BASIS), '^[GNUV]*/?([CERSV]*)$', '\1') as BASIS
  from S_ASR_REFUGEES_2003
  union all
  select STATSYEAR, DISPLACEMENT_STATUS, COU_CODE_ASYLUM, COU_CODE_ORIGIN,
    POP_START, POP_AH_START,
    ARR_GRP, null as ARR_TMP, ARR_IND, ARR_RESTL, BIRTH, REFOTHINC, TOTAL_INCREASE,
    VOLREP, VOLREP_AH, RESTL, RESTL_AH, CESSATION, NATURLZN, DEATH, REFOTHDEC, TOTAL_DECREASE,
    POP_END, POP_AH_END,
    regexp_replace(upper(SOURCE_BASIS), '^([GNUV]*)/?[CERSV]*$', '\1') as SOURCE,
    regexp_replace(upper(SOURCE_BASIS), '^[GNUV]*/?([CERSV]*)$', '\1') as BASIS
  from S_ASR_REFUGEES_2004
  union all
  select STATSYEAR, DISPLACEMENT_STATUS, COU_CODE_ASYLUM, COU_CODE_ORIGIN,
    POP_START, POP_AH_START,
    ARR_GRP, null as ARR_TMP, ARR_IND, ARR_RESTL, BIRTH, REFOTHINC, TOTAL_INCREASE,
    VOLREP, VOLREP_AH, RESTL, RESTL_AH, CESSATION, NATURLZN, DEATH, REFOTHDEC, TOTAL_DECREASE,
    POP_END, POP_AH_END,
    regexp_replace(upper(SOURCE_BASIS), '^([GNUV]*)/?[CERSV]*$', '\1') as SOURCE,
    regexp_replace(upper(SOURCE_BASIS), '^[GNUV]*/?([CERSV]*)$', '\1') as BASIS
  from S_ASR_REFUGEES_2005
  union all
  select STATSYEAR, DISPLACEMENT_STATUS, COU_CODE_ASYLUM, COU_CODE_ORIGIN,
    POP_START, POP_AH_START,
    ARR_GRP, null as ARR_TMP, ARR_IND, ARR_RESTL, BIRTH, REFOTHINC, TOTAL_INCREASE,
    VOLREP, VOLREP_AH, RESTL, RESTL_AH, CESSATION, NATURLZN, DEATH, REFOTHDEC, TOTAL_DECREASE,
    POP_END, POP_AH_END,
    SOURCE, BASIS
  from S_ASR_REFUGEES_2006
  union all
  select STATSYEAR, DISPLACEMENT_STATUS, COU_CODE_ASYLUM, COU_CODE_ORIGIN,
    POP_START, POP_AH_START,
    ARR_GRP, null as ARR_TMP, ARR_IND, ARR_RESTL, BIRTH, REFOTHINC, TOTAL_INCREASE,
    VOLREP, VOLREP_AH, RESTL, RESTL_AH, CESSATION, NATURLZN, DEATH, REFOTHDEC, TOTAL_DECREASE,
    POP_END, POP_AH_END,
    SOURCE, BASIS
  from S_ASR_REFUGEES_2007
  where COU_CODE_ASYLUM != 'VAR'
  union all
  select STATSYEAR, DISPLACEMENT_STATUS, COU_CODE_ASYLUM, COU_CODE_ORIGIN,
    POP_START, POP_AH_START,
    ARR_GRP, null as ARR_TMP, ARR_IND, ARR_RESTL, BIRTH, REFOTHINC, TOTAL_INCREASE,
    VOLREP, VOLREP_AH, RESTL, RESTL_AH, CESSATION, NATURLZN, DEATH, REFOTHDEC, TOTAL_DECREASE,
    POP_END, POP_AH_END,
    SOURCE, BASIS
  from S_ASR_REFUGEES_2008
  union all
  select STATSYEAR, DISPLACEMENT_STATUS, COU_CODE_ASYLUM, COU_CODE_ORIGIN,
    POP_START, POP_AH_START,
    ARR_GRP, null as ARR_TMP, ARR_IND, ARR_RESTL, BIRTH, REFOTHINC, TOTAL_INCREASE,
    VOLREP, VOLREP_AH, RESTL, RESTL_AH, CESSATION, NATURLZN, DEATH, REFOTHDEC, TOTAL_DECREASE,
    POP_END, POP_AH_END,
    SOURCE, BASIS
  from S_ASR_REFUGEES_2009
  union all
  select STATSYEAR, DISPLACEMENT_STATUS, COU_CODE_ASYLUM, COU_CODE_ORIGIN,
    POP_START, POP_AH_START,
    ARR_GRP, null as ARR_TMP, ARR_IND, ARR_RESTL, BIRTH, REFOTHINC, TOTAL_INCREASE,
    VOLREP, VOLREP_AH, RESTL, RESTL_AH, CESSATION, NATURLZN, DEATH, REFOTHDEC, TOTAL_DECREASE,
    POP_END, POP_AH_END,
    SOURCE, BASIS
  from S_ASR_REFUGEES_2010
  union all
  select STATSYEAR, DISPLACEMENT_STATUS, COU_CODE_ASYLUM, COU_CODE_ORIGIN,
    POP_START, POP_AH_START,
    ARR_GRP, null as ARR_TMP, ARR_IND, ARR_RESTL, BIRTH, REFOTHINC, TOTAL_INCREASE,
    VOLREP, VOLREP_AH, RESTL, RESTL_AH, CESSATION, NATURLZN, DEATH, REFOTHDEC, TOTAL_DECREASE,
    POP_END, POP_AH_END,
    SOURCE, BASIS
  from S_ASR_REFUGEES_2011
  union all
  select STATSYEAR, DISPLACEMENT_STATUS, COU_CODE_ASYLUM, COU_CODE_ORIGIN,
    POP_START, POP_AH_START,
    ARR_GRP, null as ARR_TMP, ARR_IND, ARR_RESTL, BIRTH, REFOTHINC, TOTAL_INCREASE,
    VOLREP, VOLREP_AH, RESTL, RESTL_AH, CESSATION, NATURLZN, DEATH, REFOTHDEC, TOTAL_DECREASE,
    POP_END, POP_AH_END,
    SOURCE, BASIS
  from S_ASR_REFUGEES_2012
  union all
  select STATSYEAR, DISPLACEMENT_STATUS, COU_CODE_ASYLUM, COU_CODE_ORIGIN,
    POP_START, POP_AH_START,
    ARR_GRP, ARR_TMP, ARR_IND, ARR_RESTL, BIRTH, REFOTHINC, TOTAL_INCREASE,
    VOLREP, VOLREP_AH, RESTL, RESTL_AH, CESSATION, NATURLZN, DEATH, REFOTHDEC, TOTAL_DECREASE,
    POP_END, POP_AH_END,
    SOURCE, BASIS
  from S_ASR_REFUGEES_2013) ASR
left outer join S_DST_CODE_CORRECTIONS DSC
  on DSC.DISPLACEMENT_STATUS = ASR.DISPLACEMENT_STATUS
left outer join S_SOURCE_CORRECTIONS SRC
  on SRC.SOURCE = ASR.SOURCE
left outer join S_BASIS_CORRECTIONS BSC
  on BSC.BASIS = ASR.BASIS;


create materialized view S_ASR_REFUGEES build deferred as
select STATSYEAR, DST_CODE, COU_CODE_ASYLUM, COU_CODE_ORIGIN, SOURCE, BASIS, DATA_POINT, VALUE
from
 (select STATSYEAR, DST_CODE, COU_CODE_ASYLUM, COU_CODE_ORIGIN,
    CHARAGG(SOURCE) as SOURCE,
    CHARAGG(BASIS) as BASIS,
    round(sum(POP_START)) as POP_START,
    round(sum(POP_AH_START)) as POP_AH_START,
    round(sum(ARR_GRP)) as ARR_GRP,
    round(sum(ARR_TMP)) as ARR_TMP,
    round(sum(ARR_IND)) as ARR_IND,
    round(sum(ARR_RESTL)) as ARR_RESTL,
    round(sum(BIRTH)) as BIRTH,
    round(sum(REFOTHINC)) as REFOTHINC,
    round(sum(VOLREP)) as VOLREP,
    round(sum(VOLREP_AH)) as VOLREP_AH,
    round(sum(RESTL)) as RESTL,
    round(sum(RESTL_AH)) as RESTL_AH,
    round(sum(CESSATION)) as CESSATION,
    round(sum(NATURLZN)) as NATURLZN,
    round(sum(DEATH)) as DEATH,
    round(sum(REFOTHDEC)) as REFOTHDEC,
    round(sum(POP_END)) as POP_END,
    round(sum(POP_AH_END)) as POP_AH_END
  from S_ASR_REFUGEES_CLEANED
  group by STATSYEAR, DST_CODE, COU_CODE_ASYLUM, COU_CODE_ORIGIN)
unpivot
 (VALUE for DATA_POINT in
   (POP_START, POP_AH_START,
    ARR_GRP, ARR_TMP, ARR_IND, ARR_RESTL, BIRTH, REFOTHINC,
    VOLREP, VOLREP_AH, RESTL, RESTL_AH, CESSATION, NATURLZN, DEATH, REFOTHDEC,
    POP_END, POP_AH_END))
where VALUE != 0;


grant select on S_ASR_REFUGEES to PSR_STAGE;


/* Verification queries
select sum(ROW_COUNT) as RAW_ROW_COUNT,
  count(*) as AGGREGATED_ROW_COUNT,
  count(
    case
      when POP_START != 0 or POP_AH_START != 0 or
        ARR_GRP != 0 or ARR_IND != 0 or ARR_RESTL != 0 or BIRTH != 0 or REFOTHINC != 0 or
        VOLREP != 0 or VOLREP_AH != 0 or RESTL != 0 or RESTL_AH != 0 or CESSATION != 0 or
        NATURLZN != 0 or DEATH != 0 or REFOTHDEC != 0 or
        POP_END != 0 or POP_AH_END != 0
      then 1
    end) as FILTERED_AGGREGATED_ROW_COUNT,
  count(*) * 17 as VALUE_COUNT,
  count(POP_START) + count(POP_AH_START) + count(ARR_GRP) + count(ARR_IND) + count(ARR_RESTL) +
    count(BIRTH) + count(REFOTHINC) + count(VOLREP) + count(VOLREP_AH) + count(RESTL) +
    count(RESTL_AH) + count(CESSATION) + count(NATURLZN) + count(DEATH) + count(REFOTHDEC) +
    count(POP_END) + count(POP_AH_END) as NON_NULL_COUNT,
  count(case when POP_START != 0 then 1 end) + count(case when POP_AH_START != 0 then 1 end) +
    count(case when ARR_GRP != 0 then 1 end) + count(case when ARR_IND != 0 then 1 end) +
    count(case when ARR_RESTL != 0 then 1 end) + count(case when BIRTH != 0 then 1 end) +
    count(case when REFOTHINC != 0 then 1 end) + count(case when VOLREP != 0 then 1 end) +
    count(case when VOLREP_AH != 0 then 1 end) + count(case when RESTL != 0 then 1 end) +
    count(case when RESTL_AH != 0 then 1 end) + count(case when CESSATION != 0 then 1 end) +
    count(case when NATURLZN != 0 then 1 end) + count(case when DEATH != 0 then 1 end) +
    count(case when REFOTHDEC != 0 then 1 end) + count(case when POP_END != 0 then 1 end) +
    count(case when POP_AH_END != 0 then 1 end) as NON_ZERO_COUNT
from
 (select STATSYEAR, DST_CODE, COU_CODE_ASYLUM, COU_CODE_ORIGIN, count(*) as ROW_COUNT,
    sum(POP_START) as POP_START, sum(POP_AH_START) as POP_AH_START, sum(ARR_GRP) as ARR_GRP,
    sum(ARR_IND) as ARR_IND, sum(ARR_RESTL) as ARR_RESTL, sum(BIRTH) as BIRTH,
    sum(REFOTHINC) as REFOTHINC, sum(VOLREP) as VOLREP, sum(VOLREP_AH) as VOLREP_AH,
    sum(RESTL) as RESTL, sum(RESTL_AH) as RESTL_AH, sum(CESSATION) as CESSATION,
    sum(NATURLZN) as NATURLZN, sum(DEATH) as DEATH, sum(REFOTHDEC) as REFOTHDEC,
    sum(POP_END) as POP_END, sum(POP_AH_END) as POP_AH_END
  from S_ASR_REFUGEES_CLEANED
  group by STATSYEAR, DST_CODE, COU_CODE_ASYLUM, COU_CODE_ORIGIN);

select count(*) as KEY_COUNT, sum(ROW_COUNT) as ROW_COUNT
from
 (select count(*) as ROW_COUNT
  from S_ASR_REFUGEES
  group by STATSYEAR, DST_CODE, COU_CODE_ASYLUM, COU_CODE_ORIGIN);
*/