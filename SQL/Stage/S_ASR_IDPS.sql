create table S_ASR_IDP_HCR_2006_2013 
 (STTG_CODE varchar2(10),
  STATSYEAR varchar2(4),
  OFFICIAL varchar2(3),
  COU_CODE_ASYLUM varchar2(3),
  LOCATION_NAME varchar2(1000),
  DST_CODE varchar2(3),
  POP_START varchar2(40),
  POP_AH_START varchar2(40),
  IDPNEW varchar2(40),
  IDPOTHINC varchar2(40),
  RETURN varchar2(40),
  RETURN_AH varchar2(40),
  IDPRELOC varchar2(40),
  IDPOTHDEC varchar2(40),
  POP_END varchar2(40),
  POP_AH_END varchar2(40),
  SOURCE varchar2(4),
  BASIS varchar2(5))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_IDP_HCR_2006_2013.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_IDP_HCR_2006_2013.log'
    skip 0 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      FILLER2 char(4000),
      STATSYEAR char(4000),
      COU_CODE_ASYLUM char(4000),
      OFFICIAL char(4000),
      LOCATION_NAME char(4000),
      POP_START char(4000),
      POP_AH_START char(4000),
      IDPNEW char(4000),
      IDPOTHINC char(4000),
      RETURN char(4000),
      RETURN_AH char(4000),
      IDPRELOC char(4000),
      IDPOTHDEC char(4000),
      POP_END char(4000),
      POP_AH_END char(4000),
      SOURCE char(4000),
      BASIS char(4000))
    column transforms
     (STTG_CODE from constant 'IDP',
      DST_CODE from constant 'IDP'))
  location ('ASR_IDP_HCR_2006_2013.csv'))
reject limit unlimited;

create table S_ASR_IDP_LIKE_HCR_2007_2013 
 (STTG_CODE varchar2(10),
  STATSYEAR varchar2(4),
  OFFICIAL varchar2(10),
  COU_CODE_ASYLUM varchar2(3),
  LOCATION_NAME varchar2(1000),
  DST_CODE varchar2(3),
  POP_START varchar2(40),
  POP_AH_START varchar2(40),
  IDPNEW varchar2(40),
  IDPOTHINC varchar2(40),
  RETURN varchar2(40),
  RETURN_AH varchar2(40),
  IDPRELOC varchar2(40),
  IDPOTHDEC varchar2(40),
  POP_END varchar2(40),
  POP_AH_END varchar2(40),
  SOURCE varchar2(4),
  BASIS varchar2(5))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_IDP_LIKE_HCR_2007_2013.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_IDP_LIKE_HCR_2007_2013.log'
    skip 0 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      FILLER2 char(4000),
      STATSYEAR char(4000),
      COU_CODE_ASYLUM char(4000),
      OFFICIAL char(4000),
      LOCATION_NAME char(4000),
      POP_START char(4000),
      POP_AH_START char(4000),
      IDPNEW char(4000),
      IDPOTHINC char(4000),
      RETURN char(4000),
      RETURN_AH char(4000),
      IDPRELOC char(4000),
      IDPOTHDEC char(4000),
      POP_END char(4000),
      POP_AH_END char(4000),
      SOURCE char(4000),
      BASIS char(4000))
    column transforms
     (STTG_CODE from constant 'IDP',
      DST_CODE from constant 'IOC'))
  location ('ASR_IDP_LIKE_HCR_2007_2013.csv'))
reject limit unlimited;

create table S_ASR_IDP_CONFLICT_2006_2013
 (STTG_CODE varchar2(10),
  STATSYEAR varchar2(4),
  OFFICIAL varchar2(10),
  COU_CODE_ASYLUM varchar2(3),
  LOCATION_NAME varchar2(1000),
  DST_CODE varchar2(3),
  POP_START varchar2(40),
  POP_AH_START varchar2(40),
  IDPNEW varchar2(40),
  IDPOTHINC varchar2(40),
  RETURN varchar2(40),
  RETURN_AH varchar2(40),
  IDPRELOC varchar2(40),
  IDPOTHDEC varchar2(40),
  POP_END varchar2(40),
  POP_AH_END varchar2(40),
  SOURCE varchar2(4),
  BASIS varchar2(5))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_IDP_CONFLICT_2006_2013.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_IDP_CONFLICT_2006_2013.log'
    skip 0
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      FILLER2 char(4000),
      STATSYEAR char(4000),
      COU_CODE_ASYLUM char(4000),
      OFFICIAL char(4000),
      LOCATION_NAME char(4000),
      POP_START char(4000),
      POP_AH_START char(4000),
      IDPNEW char(4000),
      IDPOTHINC char(4000),
      RETURN char(4000),
      RETURN_AH char(4000),
      IDPRELOC char(4000),
      IDPOTHDEC char(4000),
      POP_END char(4000),
      POP_AH_END char(4000),
      SOURCE char(4000),
      BASIS char(4000))
    column transforms
     (STTG_CODE from constant 'IDPCNFLCT',
      DST_CODE from constant 'IDP'))
  location ('ASR_IDP_CONFLICT_2006_2013.csv'))
reject limit unlimited;

create table S_ASR_IDP_DISASTER_2011_2013
 (STTG_CODE varchar2(10),
  STATSYEAR varchar2(4),
  OFFICIAL varchar2(10),
  COU_CODE_ASYLUM varchar2(3),
  LOCATION_NAME varchar2(1000),
  DST_CODE varchar2(3),
  POP_START varchar2(40),
  POP_AH_START varchar2(40),
  IDPNEW varchar2(40),
  IDPOTHINC varchar2(40),
  RETURN varchar2(40),
  RETURN_AH varchar2(40),
  IDPRELOC varchar2(40),
  IDPOTHDEC varchar2(40),
  POP_END varchar2(40),
  POP_AH_END varchar2(40),
  SOURCE varchar2(4),
  BASIS varchar2(5))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_IDP_DISASTER_2011_2013.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_IDP_DISASTER_2011_2013.log'
    skip 0 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      FILLER2 char(4000),
      STATSYEAR char(4000),
      COU_CODE_ASYLUM char(4000),
      OFFICIAL char(4000),
      LOCATION_NAME char(4000),
      POP_START char(4000),
      POP_AH_START char(4000),
      IDPNEW char(4000),
      IDPOTHINC char(4000),
      RETURN char(4000),
      RETURN_AH char(4000),
      IDPRELOC char(4000),
      IDPOTHDEC char(4000),
      POP_END char(4000),
      POP_AH_END char(4000),
      SOURCE char(4000),
      BASIS char(4000))
    column transforms
     (STTG_CODE from constant 'IDPNTRLDIS',
      DST_CODE from constant 'IDP'))
  location ('ASR_IDP_DISASTER_2011_2013.csv'))
reject limit unlimited;

create table S_ASR_IDP_HCR_1993_2005 
 (COU_CODE_ASYLUM varchar2(3),
  Y1993 varchar2(40),
  Y1994 varchar2(40),
  Y1995 varchar2(40),
  Y1996 varchar2(40),
  Y1997 varchar2(40),
  Y1998 varchar2(40),
  Y1999 varchar2(40),
  Y2000 varchar2(40),
  Y2001 varchar2(40),
  Y2002 varchar2(40),
  Y2003 varchar2(40),
  Y2004 varchar2(40),
  Y2005 varchar2(40))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_IDP_HCR_1993_2005.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_IDP_HCR_1993_2005.log'
    skip 0 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (COU_CODE_ASYLUM CHAR(4000),
      FILLER1 char(4000),
      Y1993 char(4000),
      Y1994 char(4000),
      Y1995 char(4000),
      Y1996 char(4000),
      Y1997 char(4000),
      Y1998 char(4000),
      Y1999 char(4000),
      Y2000 char(4000),
      Y2001 char(4000),
      Y2002 char(4000),
      Y2003 char(4000),
      Y2004 char(4000),
      Y2005 char(4000)))
  location ('ASR_IDP_HCR_1993_2005.csv'))
reject limit unlimited;

create table S_ASR_IDP_RETURNS_1997_2005 
 (COU_CODE_ASYLUM varchar2(3),
  Y1997 varchar2(40),
  Y1998 varchar2(40),
  Y1999 varchar2(40),
  Y2000 varchar2(40),
  Y2001 varchar2(40),
  Y2002 varchar2(40),
  Y2003 varchar2(40),
  Y2004 varchar2(40),
  Y2005 varchar2(40))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by '\r\n'
    characterset WE8MSWIN1252
    badfile 'ASR_IDP_RETURNS_1997_2005.bad'
    nodiscardfile
    logfile PSRLOG:'ASR_IDP_RETURNS_1997_2005.log'
    skip 0 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (COU_CODE_ASYLUM CHAR(4000),
      FILLER1 char(4000),
      Y1997 char(4000),
      Y1998 char(4000),
      Y1999 char(4000),
      Y2000 char(4000),
      Y2001 char(4000),
      Y2002 char(4000),
      Y2003 char(4000),
      Y2004 char(4000),
      Y2005 char(4000)))
  location ('ASR_IDP_RETURNS_1997_2005.csv'))
reject limit unlimited;


create materialized view S_ASR_IDPS_CLEANED build deferred as
select STTG_CODE, STATSYEAR, DST_CODE, COU_CODE_ASYLUM,
  trim(regexp_replace(LOCATION_NAME, ':.*$', '')) as LOCATION_NAME_EN,
  case
    when LOCATION_NAME is null
    then null
    when nvl(rtrim(ltrim(regexp_substr(LOCATION_NAME, ':.*$'), ': ')), 'Point') = 'Point'
    then 'Undefined'
    else rtrim(ltrim(regexp_substr(LOCATION_NAME, ':.*$'), ': '))
  end as LOC_TYPE_DESCRIPTION_EN,
  LOCATION_NAME, ORIGINAL_LOCATION_NAME, CORRECTED_LOCATION_NAME,
  nvl(decode(upper(OFFICIAL), 'YES', 'Y', 'NO', 'N'), 'Y') as OFFICIAL,
  SOURCE, BASIS,
  POP_START, POP_AH_START,
  IDPNEW, IDPOTHINC, RETURN, RETURN_AH, IDPRELOC, IDPOTHDEC,
  POP_END, POP_AH_END
from
 (select ASR.STTG_CODE, ASR.STATSYEAR, ASR.DST_CODE,
    upper(ASR.COU_CODE_ASYLUM) as COU_CODE_ASYLUM,
    ASR.LOCATION_NAME as ORIGINAL_LOCATION_NAME,
    LCOR.CORRECTED_LOCATION_NAME,
    nvl(LCOR.CORRECTED_LOCATION_NAME, replace(ASR.LOCATION_NAME, chr(10), '')) as LOCATION_NAME,
    ASR.OFFICIAL,
    case when SRC.SOURCE is null then upper(ASR.SOURCE) else SRC.CORRECTED_SOURCE end as SOURCE,
    case when BSC.BASIS is null then upper(ASR.BASIS) else BSC.CORRECTED_BASIS end as BASIS,
    to_number(case when ASR.POP_START in ('-', '..') then null
                   else ASR.POP_START end) as POP_START,
    to_number(case when ASR.POP_AH_START in ('-', '..') then null
                   else ASR.POP_AH_START end) as POP_AH_START,
    to_number(case when ASR.IDPNEW in ('-', '..') then null
                   else ASR.IDPNEW end) as IDPNEW,
    to_number(case when ASR.IDPOTHINC in ('-', '..') then null
                   else ASR.IDPOTHINC end) as IDPOTHINC,
    to_number(case when ASR.RETURN in ('-', '..') then null
                   else ASR.RETURN end) as RETURN,
    to_number(case when ASR.RETURN_AH in ('-', '..') then null
                   else ASR.RETURN_AH end) as RETURN_AH,
    to_number(case when ASR.IDPRELOC in ('-', '..') then null
                   else ASR.IDPRELOC end) as IDPRELOC,
    to_number(case when ASR.IDPOTHDEC in ('-', '..') then null
                   else ASR.IDPOTHDEC end) as IDPOTHDEC,
    to_number(case when ASR.POP_END in ('-', '..') then null
                   else ASR.POP_END end) as POP_END,
    to_number(case when ASR.POP_AH_END in ('-', '..') then null
                   else ASR.POP_AH_END end) as POP_AH_END
  from
   (/*select 'IDP' as STTG_CODE, '1993' as STATSYEAR, 'IDP' as DST_CODE,
      COU_CODE_ASYLUM, null as LOCATION_NAME,
      'yes' as OFFICIAL,
      null as POP_START, null as POP_AH_START,
      null as IDPNEW, null as IDPOTHINC,
      null as RETURN, null as RETURN_AH, null as IDPRELOC, null as IDPOTHDEC,
      Y1993 as POP_END, null as POP_AH_END,
      null as SOURCE, null as BASIS
    from S_ASR_IDP_HCR_1993_2005
    union all
    select 'IDP' as STTG_CODE, '1994' as STATSYEAR, 'IDP' as DST_CODE,
      COU_CODE_ASYLUM, null as LOCATION_NAME,
      'yes' as OFFICIAL,
      Y1993 as POP_START, null as POP_AH_START,
      null as IDPNEW, null as IDPOTHINC,
      null as RETURN, null as RETURN_AH, null as IDPRELOC, null as IDPOTHDEC,
      Y1994 as POP_END, null as POP_AH_END,
      null as SOURCE, null as BASIS
    from S_ASR_IDP_HCR_1993_2005
    union all
    select 'IDP' as STTG_CODE, '1995' as STATSYEAR, 'IDP' as DST_CODE,
      COU_CODE_ASYLUM, null as LOCATION_NAME,
      'yes' as OFFICIAL,
      Y1994 as POP_START, null as POP_AH_START,
      null as IDPNEW, null as IDPOTHINC,
      null as RETURN, null as RETURN_AH, null as IDPRELOC, null as IDPOTHDEC,
      Y1995 as POP_END, null as POP_AH_END,
      null as SOURCE, null as BASIS
    from S_ASR_IDP_HCR_1993_2005
    union all
    select 'IDP' as STTG_CODE, '1996' as STATSYEAR, 'IDP' as DST_CODE,
      COU_CODE_ASYLUM, null as LOCATION_NAME,
      'yes' as OFFICIAL,
      Y1995 as POP_START, null as POP_AH_START,
      null as IDPNEW, null as IDPOTHINC,
      null as RETURN, null as RETURN_AH, null as IDPRELOC, null as IDPOTHDEC,
      Y1996 as POP_END, null as POP_AH_END,
      null as SOURCE, null as BASIS
    from S_ASR_IDP_HCR_1993_2005
    union all
    select 'IDP' as STTG_CODE, '1997' as STATSYEAR, 'IDP' as DST_CODE,
      COU_CODE_ASYLUM, null as LOCATION_NAME,
      'yes' as OFFICIAL,
      Y1996 as POP_START, null as POP_AH_START,
      null as IDPNEW, null as IDPOTHINC,
      null as RETURN, null as RETURN_AH, null as IDPRELOC, null as IDPOTHDEC,
      Y1997 as POP_END, null as POP_AH_END,
      null as SOURCE, null as BASIS
    from S_ASR_IDP_HCR_1993_2005
    union all
    select 'IDP' as STTG_CODE, '1997' as STATSYEAR, 'IDP' as DST_CODE,
      COU_CODE_ASYLUM, null as LOCATION_NAME,
      'yes' as OFFICIAL,
      null as POP_START, null as POP_AH_START,
      null as IDPNEW, null as IDPOTHINC,
      Y1997 as RETURN, null as RETURN_AH, null as IDPRELOC, null as IDPOTHDEC,
      null as POP_END, null as POP_AH_END,
      null as SOURCE, null as BASIS
    from S_ASR_IDP_RETURNS_1997_2005
    union all
    select 'IDP' as STTG_CODE, '1998' as STATSYEAR, 'IDP' as DST_CODE,
      COU_CODE_ASYLUM, null as LOCATION_NAME,
      'yes' as OFFICIAL,
      Y1997 as POP_START, null as POP_AH_START,
      null as IDPNEW, null as IDPOTHINC,
      null as RETURN, null as RETURN_AH, null as IDPRELOC, null as IDPOTHDEC,
      Y1998 as POP_END, null as POP_AH_END,
      null as SOURCE, null as BASIS
    from S_ASR_IDP_HCR_1993_2005
    union all
    select 'IDP' as STTG_CODE, '1998' as STATSYEAR, 'IDP' as DST_CODE,
      COU_CODE_ASYLUM, null as LOCATION_NAME,
      'yes' as OFFICIAL,
      null as POP_START, null as POP_AH_START,
      null as IDPNEW, null as IDPOTHINC,
      Y1998 as RETURN, null as RETURN_AH, null as IDPRELOC, null as IDPOTHDEC,
      null as POP_END, null as POP_AH_END,
      null as SOURCE, null as BASIS
    from S_ASR_IDP_RETURNS_1997_2005
    union all
    select 'IDP' as STTG_CODE, '1999' as STATSYEAR, 'IDP' as DST_CODE,
      COU_CODE_ASYLUM, null as LOCATION_NAME,
      'yes' as OFFICIAL,
      Y1998 as POP_START, null as POP_AH_START,
      null as IDPNEW, null as IDPOTHINC,
      null as RETURN, null as RETURN_AH, null as IDPRELOC, null as IDPOTHDEC,
      Y1999 as POP_END, null as POP_AH_END,
      null as SOURCE, null as BASIS
    from S_ASR_IDP_HCR_1993_2005
    union all
    select 'IDP' as STTG_CODE, '1999' as STATSYEAR, 'IDP' as DST_CODE,
      COU_CODE_ASYLUM, null as LOCATION_NAME,
      'yes' as OFFICIAL,
      null as POP_START, null as POP_AH_START,
      null as IDPNEW, null as IDPOTHINC,
      Y1999 as RETURN, null as RETURN_AH, null as IDPRELOC, null as IDPOTHDEC,
      null as POP_END, null as POP_AH_END,
      null as SOURCE, null as BASIS
    from S_ASR_IDP_RETURNS_1997_2005
    union all*/
    select 'IDP' as STTG_CODE, '2000' as STATSYEAR, 'IDP' as DST_CODE,
      COU_CODE_ASYLUM, null as LOCATION_NAME,
      'yes' as OFFICIAL,
      Y1999 as POP_START, null as POP_AH_START,
      null as IDPNEW, null as IDPOTHINC,
      null as RETURN, null as RETURN_AH, null as IDPRELOC, null as IDPOTHDEC,
      Y2000 as POP_END, null as POP_AH_END,
      null as SOURCE, null as BASIS
    from S_ASR_IDP_HCR_1993_2005
    union all
    select 'IDP' as STTG_CODE, '2000' as STATSYEAR, 'IDP' as DST_CODE,
      COU_CODE_ASYLUM, null as LOCATION_NAME,
      'yes' as OFFICIAL,
      null as POP_START, null as POP_AH_START,
      null as IDPNEW, null as IDPOTHINC,
      Y2000 as RETURN, null as RETURN_AH, null as IDPRELOC, null as IDPOTHDEC,
      null as POP_END, null as POP_AH_END,
      null as SOURCE, null as BASIS
    from S_ASR_IDP_RETURNS_1997_2005
    union all
    select 'IDP' as STTG_CODE, '2001' as STATSYEAR, 'IDP' as DST_CODE,
      COU_CODE_ASYLUM, null as LOCATION_NAME,
      'yes' as OFFICIAL,
      Y2000 as POP_START, null as POP_AH_START,
      null as IDPNEW, null as IDPOTHINC,
      null as RETURN, null as RETURN_AH, null as IDPRELOC, null as IDPOTHDEC,
      Y2001 as POP_END, null as POP_AH_END,
      null as SOURCE, null as BASIS
    from S_ASR_IDP_HCR_1993_2005
    union all
    select 'IDP' as STTG_CODE, '2001' as STATSYEAR, 'IDP' as DST_CODE,
      COU_CODE_ASYLUM, null as LOCATION_NAME,
      'yes' as OFFICIAL,
      null as POP_START, null as POP_AH_START,
      null as IDPNEW, null as IDPOTHINC,
      Y2001 as RETURN, null as RETURN_AH, null as IDPRELOC, null as IDPOTHDEC,
      null as POP_END, null as POP_AH_END,
      null as SOURCE, null as BASIS
    from S_ASR_IDP_RETURNS_1997_2005
    union all
    select 'IDP' as STTG_CODE, '2002' as STATSYEAR, 'IDP' as DST_CODE,
      COU_CODE_ASYLUM, null as LOCATION_NAME,
      'yes' as OFFICIAL,
      Y2001 as POP_START, null as POP_AH_START,
      null as IDPNEW, null as IDPOTHINC,
      null as RETURN, null as RETURN_AH, null as IDPRELOC, null as IDPOTHDEC,
      Y2002 as POP_END, null as POP_AH_END,
      null as SOURCE, null as BASIS
    from S_ASR_IDP_HCR_1993_2005
    union all
    select 'IDP' as STTG_CODE, '2002' as STATSYEAR, 'IDP' as DST_CODE,
      COU_CODE_ASYLUM, null as LOCATION_NAME,
      'yes' as OFFICIAL,
      null as POP_START, null as POP_AH_START,
      null as IDPNEW, null as IDPOTHINC,
      Y2002 as RETURN, null as RETURN_AH, null as IDPRELOC, null as IDPOTHDEC,
      null as POP_END, null as POP_AH_END,
      null as SOURCE, null as BASIS
    from S_ASR_IDP_RETURNS_1997_2005
    union all
    select 'IDP' as STTG_CODE, '2003' as STATSYEAR, 'IDP' as DST_CODE,
      COU_CODE_ASYLUM, null as LOCATION_NAME,
      'yes' as OFFICIAL,
      Y2002 as POP_START, null as POP_AH_START,
      null as IDPNEW, null as IDPOTHINC,
      null as RETURN, null as RETURN_AH, null as IDPRELOC, null as IDPOTHDEC,
      Y2003 as POP_END, null as POP_AH_END,
      null as SOURCE, null as BASIS
    from S_ASR_IDP_HCR_1993_2005
    union all
    select 'IDP' as STTG_CODE, '2003' as STATSYEAR, 'IDP' as DST_CODE,
      COU_CODE_ASYLUM, null as LOCATION_NAME,
      'yes' as OFFICIAL,
      null as POP_START, null as POP_AH_START,
      null as IDPNEW, null as IDPOTHINC,
      Y2003 as RETURN, null as RETURN_AH, null as IDPRELOC, null as IDPOTHDEC,
      null as POP_END, null as POP_AH_END,
      null as SOURCE, null as BASIS
    from S_ASR_IDP_RETURNS_1997_2005
    union all
    select 'IDP' as STTG_CODE, '2004' as STATSYEAR, 'IDP' as DST_CODE,
      COU_CODE_ASYLUM, null as LOCATION_NAME,
      'yes' as OFFICIAL,
      Y2003 as POP_START, null as POP_AH_START,
      null as IDPNEW, null as IDPOTHINC,
      null as RETURN, null as RETURN_AH, null as IDPRELOC, null as IDPOTHDEC,
      Y2004 as POP_END, null as POP_AH_END,
      null as SOURCE, null as BASIS
    from S_ASR_IDP_HCR_1993_2005
    union all
    select 'IDP' as STTG_CODE, '2004' as STATSYEAR, 'IDP' as DST_CODE,
      COU_CODE_ASYLUM, null as LOCATION_NAME,
      'yes' as OFFICIAL,
      null as POP_START, null as POP_AH_START,
      null as IDPNEW, null as IDPOTHINC,
      Y2004 as RETURN, null as RETURN_AH, null as IDPRELOC, null as IDPOTHDEC,
      null as POP_END, null as POP_AH_END,
      null as SOURCE, null as BASIS
    from S_ASR_IDP_RETURNS_1997_2005
    union all
    select 'IDP' as STTG_CODE, '2005' as STATSYEAR, 'IDP' as DST_CODE,
      COU_CODE_ASYLUM, null as LOCATION_NAME,
      'yes' as OFFICIAL,
      Y2004 as POP_START, null as POP_AH_START,
      null as IDPNEW, null as IDPOTHINC,
      null as RETURN, null as RETURN_AH, null as IDPRELOC, null as IDPOTHDEC,
      Y2005 as POP_END, null as POP_AH_END,
      null as SOURCE, null as BASIS
    from S_ASR_IDP_HCR_1993_2005
    union all
    select 'IDP' as STTG_CODE, '2005' as STATSYEAR, 'IDP' as DST_CODE,
      COU_CODE_ASYLUM, null as LOCATION_NAME,
      'yes' as OFFICIAL,
      null as POP_START, null as POP_AH_START,
      null as IDPNEW, null as IDPOTHINC,
      Y2005 as RETURN, null as RETURN_AH, null as IDPRELOC, null as IDPOTHDEC,
      null as POP_END, null as POP_AH_END,
      null as SOURCE, null as BASIS
    from S_ASR_IDP_RETURNS_1997_2005
    union all
    select STTG_CODE, STATSYEAR, DST_CODE,
      COU_CODE_ASYLUM, LOCATION_NAME,
      OFFICIAL,
      POP_START, POP_AH_START,
      IDPNEW, IDPOTHINC, RETURN, RETURN_AH, IDPRELOC, IDPOTHDEC,
      POP_END, POP_AH_END,
      SOURCE,
      translate(BASIS, 'A, ', 'A') as BASIS
    from S_ASR_IDP_HCR_2006_2013
    union all
    select STTG_CODE, STATSYEAR, DST_CODE,
      COU_CODE_ASYLUM, LOCATION_NAME,
      OFFICIAL,
      POP_START, POP_AH_START,
      IDPNEW, IDPOTHINC, RETURN, RETURN_AH, IDPRELOC, IDPOTHDEC,
      POP_END, POP_AH_END,
      SOURCE, BASIS
    from S_ASR_IDP_LIKE_HCR_2007_2013
    union all
    select STTG_CODE, STATSYEAR, DST_CODE,
      COU_CODE_ASYLUM, LOCATION_NAME,
      OFFICIAL,
      POP_START, POP_AH_START,
      IDPNEW, IDPOTHINC, RETURN, RETURN_AH, IDPRELOC, IDPOTHDEC,
      POP_END, POP_AH_END,
      SOURCE, BASIS
    from S_ASR_IDP_CONFLICT_2006_2013
    union all
    select STTG_CODE, STATSYEAR, DST_CODE,
      COU_CODE_ASYLUM, LOCATION_NAME,
      OFFICIAL,
      POP_START, POP_AH_START,
      IDPNEW, IDPOTHINC, RETURN, RETURN_AH, IDPRELOC, IDPOTHDEC,
      POP_END, POP_AH_END,
      SOURCE, BASIS
    from S_ASR_IDP_DISASTER_2011_2013) ASR
  left outer join S_LOCATION_NAME_CORRECTIONS LCOR
    on LCOR.COU_CODE = upper(ASR.COU_CODE_ASYLUM)
    and LCOR.LOCATION_NAME = replace(ASR.LOCATION_NAME, chr(10), '')
    and LCOR.NEW_LOCATION_NAME is null
  left outer join S_SOURCE_CORRECTIONS SRC
    on SRC.SOURCE = ASR.SOURCE
  left outer join S_BASIS_CORRECTIONS BSC
    on BSC.BASIS = ASR.BASIS);


create materialized view S_ASR_IDPS build deferred as
select STTG_CODE, STATSYEAR, DST_CODE, COU_CODE_ASYLUM,
  LOCATION_NAME_EN, LOC_TYPE_DESCRIPTION_EN, OFFICIAL,
  SOURCE, BASIS, DATA_POINT, VALUE
from
 (select STTG_CODE, STATSYEAR, DST_CODE, COU_CODE_ASYLUM,
    LOCATION_NAME_EN, LOC_TYPE_DESCRIPTION_EN, OFFICIAL, 
    CHARAGG(SOURCE) as SOURCE,
    CHARAGG(BASIS) as BASIS,
    round(sum(POP_START)) as POP_START,
    round(sum(POP_AH_START)) as POP_AH_START,
    round(sum(IDPNEW)) as IDPNEW,
    round(sum(IDPOTHINC)) as IDPOTHINC,
    round(sum(RETURN)) as RETURN,
    round(sum(RETURN_AH)) as RETURN_AH,
    round(sum(IDPRELOC)) as IDPRELOC,
    round(sum(IDPOTHDEC)) as IDPOTHDEC,
    round(sum(POP_END)) as POP_END,
    round(sum(POP_AH_END)) as POP_AH_END
  from S_ASR_IDPS_CLEANED
  group by STTG_CODE, STATSYEAR, DST_CODE, COU_CODE_ASYLUM,
    LOCATION_NAME_EN, LOC_TYPE_DESCRIPTION_EN, OFFICIAL)
unpivot
 (VALUE for DATA_POINT in
   (POP_START, POP_AH_START,
    IDPNEW, IDPOTHINC, RETURN, RETURN_AH, IDPRELOC, IDPOTHDEC,
    POP_END, POP_AH_END))
where VALUE != 0;


grant select on S_ASR_IDPS_CLEANED to PSR_STAGE;
grant select on S_ASR_IDPS to PSR_STAGE;


/* Verification queries
select sum(ROW_COUNT) as RAW_ROW_COUNT,
  count(*) as RAW_AGGREGATED_ROW_COUNT,
  count(
    case
      when POP_START != 0 or POP_AH_START != 0 or
        IDPNEW != 0 or IDPOTHINC != 0 or
        RETURN != 0 or RETURN_AH != 0 or IDPRELOC != 0 or IDPOTHDEC != 0 or
        POP_END != 0 or POP_AH_END != 0
      then 1
    end) as FILTERED_AGGREGATED_ROW_COUNT,
  count(*) * 10 as VALUE_COUNT,
  count(POP_START) + count(POP_AH_START) +
    count(IDPNEW) + count(IDPOTHINC) +
    count(RETURN) + count(RETURN_AH) + count(IDPRELOC) + count(IDPOTHDEC) +
    count(POP_END) + count(POP_AH_END) as NON_NULL_COUNT,
  count(case when POP_START != 0 then 1 end) + count(case when POP_AH_START != 0 then 1 end) +
    count(case when IDPNEW != 0 then 1 end) + count(case when IDPOTHINC != 0 then 1 end) +
    count(case when RETURN != 0 then 1 end) + count(case when RETURN_AH != 0 then 1 end) +
    count(case when IDPRELOC != 0 then 1 end) + count(case when IDPOTHDEC != 0 then 1 end) +
    count(case when POP_END != 0 then 1 end) + count(case when POP_AH_END != 0 then 1 end) as NON_ZERO_COUNT
from
 (select STTG_CODE, STATSYEAR, DST_CODE, COU_CODE_ASYLUM, LOCATION_NAME_EN, LOC_TYPE_DESCRIPTION_EN,
    OFFICIAL,
    count(*) as ROW_COUNT,
    sum(POP_START) as POP_START, sum(POP_AH_START) as POP_AH_START,
    sum(IDPNEW) as IDPNEW, sum(IDPOTHINC) as IDPOTHINC,
    sum(RETURN) as RETURN, sum(RETURN_AH) as RETURN_AH,
    sum(IDPRELOC) as IDPRELOC, sum(IDPOTHDEC) as IDPOTHDEC,
    sum(POP_END) as POP_END, sum(POP_AH_END) as POP_AH_END
  from S_ASR_IDPS_CLEANED
  group by STTG_CODE, STATSYEAR, DST_CODE, COU_CODE_ASYLUM, LOCATION_NAME_EN, LOC_TYPE_DESCRIPTION_EN,
    OFFICIAL);

select count(*) as KEY_COUNT, sum(ROW_COUNT) as ROW_COUNT
from
 (select count(*) as ROW_COUNT
  from S_ASR_IDPS
  group by STTG_CODE, STATSYEAR, DST_CODE, COU_CODE_ASYLUM, LOCATION_NAME_EN, LOC_TYPE_DESCRIPTION_EN,
    OFFICIAL);
*/
