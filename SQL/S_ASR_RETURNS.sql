create table S_ASR_RETURNS_REFUGEES_2000
 (STATSYEAR varchar2(4),
  COU_CODE_ORIGIN varchar2(3),
  COU_CODE_ASYLUM varchar2(3),
  DST_CODE varchar2(3),
  RETURN varchar2(40),
  RETURN_AH varchar2(40),
  SOURCE_BASIS varchar2(10))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_RETURNS_REFUGEES_2000.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_RETURNS_REFUGEES_2000.log'
    skip 0
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (COU_CODE_ORIGIN char(4000),
      COU_CODE_ASYLUM char(4000),
      FILLER1 char(4000),
      FILLER2 char(4000),
      RETURN char(4000),
      RETURN_AH char(4000),
      FILLER3 char(4000),
      FILLER4 char(4000),
      FILLER5 char(4000),
      FILLER6 char(4000),
      FILLER7 char(4000),
      FILLER8 char(4000),
      FILLER9 char(4000),
      FILLER10 char(4000),
      SOURCE_BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2000',
      DST_CODE from constant 'REF'))
  location ('ASR_RETURNS_REFUGEES_2000.csv'))
reject limit unlimited;

create table S_ASR_RETURNS_REFUGEES_2001
 (STATSYEAR varchar2(4),
  COU_CODE_ORIGIN varchar2(3),
  COU_CODE_ASYLUM varchar2(3),
  DST_CODE varchar2(3),
  RETURN varchar2(40),
  RETURN_AH varchar2(40),
  SOURCE_BASIS varchar2(10))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_RETURNS_REFUGEES_2001.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_RETURNS_REFUGEES_2001.log'
    skip 0
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      FILLER2 char(4000),
      COU_CODE_ORIGIN char(4000),
      COU_CODE_ASYLUM char(4000),
      RETURN char(4000),
      RETURN_AH char(4000),
      FILLER3 char(4000),
      FILLER4 char(4000),
      FILLER5 char(4000),
      FILLER6 char(4000),
      FILLER7 char(4000),
      FILLER8 char(4000),
      FILLER9 char(4000),
      FILLER10 char(4000),
      SOURCE_BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2001',
      DST_CODE from constant 'REF'))
  location ('ASR_RETURNS_REFUGEES_2001.csv'))
reject limit unlimited;

create table S_ASR_RETURNS_REFUGEES_2002
 (STATSYEAR varchar2(4),
  COU_CODE_ORIGIN varchar2(3),
  COU_CODE_ASYLUM varchar2(3),
  DST_CODE varchar2(3),
  RETURN varchar2(40),
  RETURN_AH varchar2(40),
  SOURCE_BASIS varchar2(10))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_RETURNS_REFUGEES_2002.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_RETURNS_REFUGEES_2002.log'
    skip 0
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      FILLER2 char(4000),
      FILLER3 char(4000),
      FILLER4 char(4000),
      COU_CODE_ORIGIN char(4000),
      COU_CODE_ASYLUM char(4000),
      RETURN char(4000),
      RETURN_AH char(4000),
      FILLER5 char(4000),
      FILLER6 char(4000),
      FILLER7 char(4000),
      FILLER8 char(4000),
      FILLER9 char(4000),
      FILLER10 char(4000),
      FILLER11 char(4000),
      FILLER12 char(4000),
      SOURCE_BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2002',
      DST_CODE from constant 'REF'))
  location ('ASR_RETURNS_REFUGEES_2002.csv'))
reject limit unlimited;

create table S_ASR_RETURNS_REFUGEES_2003
 (STATSYEAR varchar2(4),
  COU_CODE_ORIGIN varchar2(3),
  COU_CODE_ASYLUM varchar2(3),
  DST_CODE varchar2(3),
  RETURN varchar2(40),
  RETURN_AH varchar2(40),
  SOURCE_BASIS varchar2(10))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_RETURNS_REFUGEES_2003.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_RETURNS_REFUGEES_2003.log'
    skip 0
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      COU_CODE_ORIGIN char(4000),
      COU_CODE_ASYLUM char(4000),
      RETURN char(4000),
      RETURN_AH char(4000),
      FILLER2 char(4000),
      FILLER3 char(4000),
      FILLER4 char(4000),
      FILLER5 char(4000),
      FILLER6 char(4000),
      FILLER7 char(4000),
      FILLER8 char(4000),
      FILLER9 char(4000),
      SOURCE_BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2003',
      DST_CODE from constant 'REF'))
  location ('ASR_RETURNS_REFUGEES_2003.csv'))
reject limit unlimited;

create table S_ASR_RETURNS_REFUGEES_2004
 (STATSYEAR varchar2(4),
  COU_CODE_ORIGIN varchar2(3),
  COU_CODE_ASYLUM varchar2(3),
  DST_CODE varchar2(3),
  RETURN varchar2(40),
  RETURN_AH varchar2(40),
  SOURCE_BASIS varchar2(10))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_RETURNS_REFUGEES_2004.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_RETURNS_REFUGEES_2004.log'
    skip 0
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      COU_CODE_ORIGIN char(4000),
      COU_CODE_ASYLUM char(4000),
      RETURN char(4000),
      RETURN_AH char(4000),
      FILLER2 char(4000),
      FILLER3 char(4000),
      FILLER4 char(4000),
      FILLER5 char(4000),
      FILLER6 char(4000),
      FILLER7 char(4000),
      FILLER8 char(4000),
      FILLER9 char(4000),
      SOURCE_BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2004',
      DST_CODE from constant 'REF'))
  location ('ASR_RETURNS_REFUGEES_2004.csv'))
reject limit unlimited;

create table S_ASR_RETURNS_REFUGEES_2005
 (STATSYEAR varchar2(4),
  COU_CODE_ORIGIN varchar2(3),
  COU_CODE_ASYLUM varchar2(3),
  DST_CODE varchar2(3),
  RETURN varchar2(40),
  RETURN_AH varchar2(40),
  SOURCE_BASIS varchar2(10))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_RETURNS_REFUGEES_2005.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_RETURNS_REFUGEES_2005.log'
    skip 0
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      COU_CODE_ORIGIN char(4000),
      COU_CODE_ASYLUM char(4000),
      RETURN char(4000),
      RETURN_AH char(4000),
      FILLER2 char(4000),
      FILLER3 char(4000),
      FILLER4 char(4000),
      FILLER5 char(4000),
      FILLER6 char(4000),
      FILLER7 char(4000),
      FILLER8 char(4000),
      FILLER9 char(4000),
      SOURCE_BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2005',
      DST_CODE from constant 'REF'))
  location ('ASR_RETURNS_REFUGEES_2005.csv'))
reject limit unlimited;

create table S_ASR_RETURNS_REFUGEES_2006
 (STATSYEAR varchar2(4),
  COU_CODE_ORIGIN varchar2(3),
  COU_CODE_ASYLUM varchar2(3),
  DST_CODE varchar2(3),
  RETURN varchar2(40),
  RETURN_AH varchar2(40),
  SOURCE varchar2(5),
  BASIS varchar2(5))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_RETURNS_REFUGEES_2006.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_RETURNS_REFUGEES_2006.log'
    skip 0
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      COU_CODE_ORIGIN char(4000),
      COU_CODE_ASYLUM char(4000),
      RETURN char(4000),
      RETURN_AH char(4000),
      SOURCE char(4000),
      BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2006',
      DST_CODE from constant 'REF'))
  location ('ASR_RETURNS_REFUGEES_2006.csv'))
reject limit unlimited;

create table S_ASR_RETURNS_REFUGEES_2007
 (STATSYEAR varchar2(4),
  COU_CODE_ORIGIN varchar2(3),
  COU_CODE_ASYLUM varchar2(3),
  DST_CODE varchar2(3),
  RETURN varchar2(40),
  RETURN_AH varchar2(40),
  SOURCE varchar2(5),
  BASIS varchar2(5))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_RETURNS_REFUGEES_2007.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_RETURNS_REFUGEES_2007.log'
    skip 0
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      COU_CODE_ORIGIN char(4000),
      COU_CODE_ASYLUM char(4000),
      RETURN char(4000),
      RETURN_AH char(4000),
      SOURCE char(4000),
      BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2007',
      DST_CODE from constant 'REF'))
  location ('ASR_RETURNS_REFUGEES_2007.csv'))
reject limit unlimited;

create table S_ASR_RETURNS_REFUGEES_2008
 (STATSYEAR varchar2(4),
  COU_CODE_ORIGIN varchar2(3),
  COU_CODE_ASYLUM varchar2(3),
  DST_CODE varchar2(3),
  RETURN varchar2(40),
  RETURN_AH varchar2(40),
  SOURCE varchar2(5),
  BASIS varchar2(5))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_RETURNS_REFUGEES_2008.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_RETURNS_REFUGEES_2008.log'
    skip 0
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      COU_CODE_ORIGIN char(4000),
      COU_CODE_ASYLUM char(4000),
      RETURN char(4000),
      RETURN_AH char(4000),
      SOURCE char(4000),
      BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2008',
      DST_CODE from constant 'REF'))
  location ('ASR_RETURNS_REFUGEES_2008.csv'))
reject limit unlimited;

create table S_ASR_RETURNS_REF_LIKE_2008
 (STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  DST_CODE varchar2(3),
  RETURN varchar2(40),
  RETURN_AH varchar2(40),
  SOURCE varchar2(5),
  BASIS varchar2(5))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_RETURNS_REF_LIKE_2008.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_RETURNS_REF_LIKE_2008.log'
    skip 0
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      COU_CODE_ORIGIN char(4000),
      COU_CODE_ASYLUM char(4000),
      RETURN char(4000),
      RETURN_AH char(4000),
      SOURCE char(4000),
      BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2008',
      DST_CODE from constant 'ROC'))
  location ('ASR_RETURNS_REF_LIKE_2008.csv'))
reject limit unlimited;

create table S_ASR_RETURNS_REFUGEES_2009
 (STATSYEAR varchar2(4),
  COU_CODE_ORIGIN varchar2(3),
  COU_CODE_ASYLUM varchar2(3),
  DST_CODE varchar2(3),
  RETURN varchar2(40),
  RETURN_AH varchar2(40),
  SOURCE varchar2(5),
  BASIS varchar2(5))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_RETURNS_REFUGEES_2009.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_RETURNS_REFUGEES_2009.log'
    skip 0
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      COU_CODE_ORIGIN char(4000),
      COU_CODE_ASYLUM char(4000),
      RETURN char(4000),
      RETURN_AH char(4000),
      SOURCE char(4000),
      BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2009',
      DST_CODE from constant 'REF'))
  location ('ASR_RETURNS_REFUGEES_2009.csv'))
reject limit unlimited;

create table S_ASR_RETURNS_REF_LIKE_2009
 (STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  DST_CODE varchar2(3),
  RETURN varchar2(40),
  RETURN_AH varchar2(40),
  SOURCE varchar2(5),
  BASIS varchar2(5))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_RETURNS_REF_LIKE_2009.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_RETURNS_REF_LIKE_2009.log'
    skip 0
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      COU_CODE_ORIGIN char(4000),
      COU_CODE_ASYLUM char(4000),
      RETURN char(4000),
      RETURN_AH char(4000),
      SOURCE char(4000),
      BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2009',
      DST_CODE from constant 'ROC'))
  location ('ASR_RETURNS_REF_LIKE_2009.csv'))
reject limit unlimited;

create table S_ASR_RETURNS_REFUGEES_2010
 (STATSYEAR varchar2(4),
  COU_CODE_ORIGIN varchar2(3),
  COU_CODE_ASYLUM varchar2(3),
  DST_CODE varchar2(3),
  RETURN varchar2(40),
  RETURN_AH varchar2(40),
  SOURCE varchar2(5),
  BASIS varchar2(5))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_RETURNS_REFUGEES_2010.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_RETURNS_REFUGEES_2010.log'
    skip 0
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      COU_CODE_ORIGIN char(4000),
      COU_CODE_ASYLUM char(4000),
      RETURN char(4000),
      RETURN_AH char(4000),
      SOURCE char(4000),
      BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2010',
      DST_CODE from constant 'REF'))
  location ('ASR_RETURNS_REFUGEES_2010.csv'))
reject limit unlimited;

create table S_ASR_RETURNS_REF_LIKE_2010
 (STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  DST_CODE varchar2(3),
  RETURN varchar2(40),
  RETURN_AH varchar2(40),
  SOURCE varchar2(5),
  BASIS varchar2(5))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_RETURNS_REF_LIKE_2010.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_RETURNS_REF_LIKE_2010.log'
    skip 0
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      COU_CODE_ORIGIN char(4000),
      COU_CODE_ASYLUM char(4000),
      RETURN char(4000),
      RETURN_AH char(4000),
      SOURCE char(4000),
      BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2010',
      DST_CODE from constant 'ROC'))
  location ('ASR_RETURNS_REF_LIKE_2010.csv'))
reject limit unlimited;

create table S_ASR_RETURNS_REFUGEES_2011
 (STATSYEAR varchar2(4),
  COU_CODE_ORIGIN varchar2(3),
  COU_CODE_ASYLUM varchar2(3),
  DST_CODE varchar2(3),
  RETURN varchar2(40),
  RETURN_AH varchar2(40),
  SOURCE varchar2(5),
  BASIS varchar2(5))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_RETURNS_REFUGEES_2011.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_RETURNS_REFUGEES_2011.log'
    skip 0
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      COU_CODE_ORIGIN char(4000),
      COU_CODE_ASYLUM char(4000),
      RETURN char(4000),
      RETURN_AH char(4000),
      SOURCE char(4000),
      BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2011',
      DST_CODE from constant 'REF'))
  location ('ASR_RETURNS_REFUGEES_2011.csv'))
reject limit unlimited;

create table S_ASR_RETURNS_REF_LIKE_2011
 (STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  DST_CODE varchar2(3),
  RETURN varchar2(40),
  RETURN_AH varchar2(40),
  SOURCE varchar2(5),
  BASIS varchar2(5))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_RETURNS_REF_LIKE_2011.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_RETURNS_REF_LIKE_2011.log'
    skip 0
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      COU_CODE_ORIGIN char(4000),
      COU_CODE_ASYLUM char(4000),
      RETURN char(4000),
      RETURN_AH char(4000),
      SOURCE char(4000),
      BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2011',
      DST_CODE from constant 'ROC'))
  location ('ASR_RETURNS_REF_LIKE_2011.csv'))
reject limit unlimited;

create table S_ASR_RETURNS_REFUGEES_2012
 (STATSYEAR varchar2(4),
  COU_CODE_ORIGIN varchar2(3),
  COU_CODE_ASYLUM varchar2(3),
  DST_CODE varchar2(3),
  RETURN varchar2(40),
  RETURN_AH varchar2(40),
  SOURCE varchar2(5),
  BASIS varchar2(5))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_RETURNS_REFUGEES_2012.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_RETURNS_REFUGEES_2012.log'
    skip 0
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      COU_CODE_ORIGIN char(4000),
      COU_CODE_ASYLUM char(4000),
      RETURN char(4000),
      RETURN_AH char(4000),
      SOURCE char(4000),
      BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2012',
      DST_CODE from constant 'REF'))
  location ('ASR_RETURNS_REFUGEES_2012.csv'))
reject limit unlimited;

create table S_ASR_RETURNS_REF_LIKE_2012
 (STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  DST_CODE varchar2(3),
  RETURN varchar2(40),
  RETURN_AH varchar2(40),
  SOURCE varchar2(5),
  BASIS varchar2(5))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_RETURNS_REF_LIKE_2012.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_RETURNS_REF_LIKE_2012.log'
    skip 0
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      COU_CODE_ORIGIN char(4000),
      COU_CODE_ASYLUM char(4000),
      RETURN char(4000),
      RETURN_AH char(4000),
      SOURCE char(4000),
      BASIS char(4000))
    column transforms
     (STATSYEAR from constant '2012',
      DST_CODE from constant 'ROC'))
  location ('ASR_RETURNS_REF_LIKE_2012.csv'))
reject limit unlimited;


create or replace view S_ASR_RETURNS_CLEANED as
select ASR.STATSYEAR, ASR.DST_CODE,
  upper(ASR.COU_CODE_ASYLUM) as COU_CODE_ASYLUM,
  upper(ASR.COU_CODE_ORIGIN) as COU_CODE_ORIGIN,
  to_number(case when ASR.RETURN in ('-', '..') then null
                 else ASR.RETURN end) as RETURN,
  to_number(case when ASR.RETURN_AH in ('-', '..') then null
                 else ASR.RETURN_AH end) as RETURN_AH,
  case when SRC.SOURCE is null then upper(ASR.SOURCE) else SRC.CORRECTED_SOURCE end as SOURCE,
  case when BSC.BASIS is null then upper(ASR.BASIS) else BSC.CORRECTED_BASIS end as BASIS
from
 (select STATSYEAR, COU_CODE_ORIGIN, COU_CODE_ASYLUM, DST_CODE, RETURN, RETURN_AH,
    regexp_replace(upper(SOURCE_BASIS), '^([GNUV]?)/?[CERSV]*$', '\1') as SOURCE,
    regexp_replace(upper(SOURCE_BASIS), '^[GNUV]?/?([CERSV]*)$', '\1') as BASIS
  from S_ASR_RETURNS_REFUGEES_2000
  union all
  select STATSYEAR, COU_CODE_ORIGIN, COU_CODE_ASYLUM, DST_CODE, RETURN, RETURN_AH,
    regexp_replace(upper(SOURCE_BASIS), '^([GNUV]?)/?[CERSV]*$', '\1') as SOURCE,
    regexp_replace(upper(SOURCE_BASIS), '^[GNUV]?/?([CERSV]*)$', '\1') as BASIS
  from S_ASR_RETURNS_REFUGEES_2001
  union all
  select STATSYEAR, COU_CODE_ORIGIN, COU_CODE_ASYLUM, DST_CODE, RETURN, RETURN_AH,
    regexp_replace(upper(SOURCE_BASIS), '^([GNUV]?)/?[CERSV]*$', '\1') as SOURCE,
    regexp_replace(upper(SOURCE_BASIS), '^[GNUV]?/?([CERSV]*)$', '\1') as BASIS
  from S_ASR_RETURNS_REFUGEES_2002
  union all
  select STATSYEAR, COU_CODE_ORIGIN, COU_CODE_ASYLUM, DST_CODE, RETURN, RETURN_AH,
    regexp_replace(upper(SOURCE_BASIS), '^([GNUV]*)/?[CERSV]*$', '\1') as SOURCE,
    regexp_replace(upper(SOURCE_BASIS), '^[GNUV]*/?([CERSV]*)$', '\1') as BASIS
  from S_ASR_RETURNS_REFUGEES_2003
  union all
  select STATSYEAR, COU_CODE_ORIGIN, COU_CODE_ASYLUM, DST_CODE, RETURN, RETURN_AH,
    regexp_replace(upper(SOURCE_BASIS), '^([GNUV]*)/?[CERSV]*$', '\1') as SOURCE,
    regexp_replace(upper(SOURCE_BASIS), '^[GNUV]*/?([CERSV]*)$', '\1') as BASIS
  from S_ASR_RETURNS_REFUGEES_2004
  union all
  select STATSYEAR, COU_CODE_ORIGIN, COU_CODE_ASYLUM, DST_CODE, RETURN, RETURN_AH,
    regexp_replace(upper(SOURCE_BASIS), '^([GNUV]*)/?[CERSV]*$', '\1') as SOURCE,
    regexp_replace(upper(SOURCE_BASIS), '^[GNUV]*/?([CERSV]*)$', '\1') as BASIS
  from S_ASR_RETURNS_REFUGEES_2005
  union all
  select STATSYEAR, COU_CODE_ORIGIN, COU_CODE_ASYLUM, DST_CODE, RETURN, RETURN_AH, SOURCE, BASIS
  from S_ASR_RETURNS_REFUGEES_2006
  union all
  select STATSYEAR, COU_CODE_ORIGIN, COU_CODE_ASYLUM, DST_CODE, RETURN, RETURN_AH, SOURCE, BASIS
  from S_ASR_RETURNS_REFUGEES_2007
  union all
  select STATSYEAR, COU_CODE_ORIGIN, COU_CODE_ASYLUM, DST_CODE, RETURN, RETURN_AH, SOURCE, BASIS
  from S_ASR_RETURNS_REFUGEES_2008
  union all
  select STATSYEAR, COU_CODE_ORIGIN, COU_CODE_ASYLUM, DST_CODE, RETURN, RETURN_AH, SOURCE, BASIS
  from S_ASR_RETURNS_REF_LIKE_2008
  union all
  select STATSYEAR, COU_CODE_ORIGIN, COU_CODE_ASYLUM, DST_CODE, RETURN, RETURN_AH, SOURCE, BASIS
  from S_ASR_RETURNS_REFUGEES_2009
  union all
  select STATSYEAR, COU_CODE_ORIGIN, COU_CODE_ASYLUM, DST_CODE, RETURN, RETURN_AH, SOURCE, BASIS
  from S_ASR_RETURNS_REF_LIKE_2009
  union all
  select STATSYEAR, COU_CODE_ORIGIN, COU_CODE_ASYLUM, DST_CODE, RETURN, RETURN_AH, SOURCE, BASIS
  from S_ASR_RETURNS_REFUGEES_2010
  union all
  select STATSYEAR, COU_CODE_ORIGIN, COU_CODE_ASYLUM, DST_CODE, RETURN, RETURN_AH, SOURCE, BASIS
  from S_ASR_RETURNS_REF_LIKE_2010
  union all
  select STATSYEAR, COU_CODE_ORIGIN, COU_CODE_ASYLUM, DST_CODE, RETURN, RETURN_AH, SOURCE, BASIS
  from S_ASR_RETURNS_REFUGEES_2011
  union all
  select STATSYEAR, COU_CODE_ORIGIN, COU_CODE_ASYLUM, DST_CODE, RETURN, RETURN_AH, SOURCE, BASIS
  from S_ASR_RETURNS_REF_LIKE_2011
  union all
  select STATSYEAR, COU_CODE_ORIGIN, COU_CODE_ASYLUM, DST_CODE, RETURN, RETURN_AH, SOURCE, BASIS
  from S_ASR_RETURNS_REFUGEES_2012
  union all
  select STATSYEAR, COU_CODE_ORIGIN, COU_CODE_ASYLUM, DST_CODE, RETURN, RETURN_AH, SOURCE, BASIS
  from S_ASR_RETURNS_REF_LIKE_2012) ASR
left outer join S_SOURCE_CORRECTIONS SRC
  on SRC.SOURCE = ASR.SOURCE
left outer join S_BASIS_CORRECTIONS BSC
  on BSC.BASIS = ASR.BASIS;


create materialized view S_ASR_RETURNS build deferred as
select STATSYEAR, COU_CODE_ORIGIN, COU_CODE_ASYLUM, DST_CODE, SOURCE, BASIS, DATA_POINT, VALUE
from
 (select STATSYEAR, COU_CODE_ORIGIN, COU_CODE_ASYLUM, DST_CODE,
    STAGE.CHARAGG(SOURCE) as SOURCE,
    STAGE.CHARAGG(BASIS) as BASIS,
    round(sum(RETURN)) as RETURN,
    round(sum(RETURN_AH)) as RETURN_AH
  from S_ASR_RETURNS_CLEANED
  group by STATSYEAR, COU_CODE_ORIGIN, COU_CODE_ASYLUM, DST_CODE)
unpivot
 (VALUE for DATA_POINT in
   (RETURN as 'REFRTN', RETURN_AH as 'REFRTN-AH'))
where VALUE != 0;


grant select on S_ASR_RETURNS to PSR_STAGE;


/* Verification query
select sum(ROW_COUNT) as RAW_ROW_COUNT,
  count(*) as AGGREGATED_ROW_COUNT,
  count(case when RETURN != 0 or RETURN_AH != 0 then 1 end) as FILTERED_AGGREGATED_ROW_COUNT,
  count(*) * 2 as VALUE_COUNT,
  count(RETURN) + count(RETURN_AH) as NON_NULL_COUNT,
  count(case when RETURN != 0 then 1 end) + count(case when RETURN_AH != 0 then 1 end) as NON_ZERO_COUNT
from
 (select count(*) as ROW_COUNT,
    sum(RETURN) as RETURN, sum(RETURN_AH) as RETURN_AH
  from S_ASR_RETURNS_CLEANED
  group by STATSYEAR, COU_CODE_ORIGIN, COU_CODE_ASYLUM, DST_CODE);

select count(*) as KEY_COUNT, sum(ROW_COUNT) as ROW_COUNT
from
 (select count(*) as ROW_COUNT
  from S_ASR_RETURNS
  group by STATSYEAR, COU_CODE_ORIGIN, COU_CODE_ASYLUM, DST_CODE);
*/