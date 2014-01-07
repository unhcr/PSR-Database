create table S_ASR_T4_2011 
 (TABLE_NUMBER varchar2(5),
  STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  DISPLACEMENT_STATUS varchar2(8),
  UNCONV51 integer,
  OAUCONV69 integer,
  HCRSTAT integer,
  COMPPROT integer,
  TEMPPROT integer,
  OTHER integer,
  UNKNOWN integer,
  TOTAL integer)
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_T4_2011.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_T4_2011.log'
    skip 0 
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
      DISPLACEMENT_STATUS char(4000),
      UNCONV51 char(4000),
      OAUCONV69 char(4000),
      HCRSTAT char(4000),
      COMPPROT char(4000),
      TEMPPROT char(4000),
      OTHER char(4000),
      UNKNOWN char(4000),
      TOTAL char(4000))
    column transforms
     (TABLE_NUMBER from constant '4',
      STATSYEAR from constant '2011'))
  location ('ASR_T4_2011.csv'))
reject limit unlimited;

grant select on S_ASR_T4_2011 to PSR_STAGE;
