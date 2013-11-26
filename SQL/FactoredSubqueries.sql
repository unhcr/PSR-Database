Q_AGE_PROFILES as
 (select CODE, DESCRIPTION, LANG_CODE, DISPLAY_SEQ, ACTIVE_FLAG, ITM_ID, VERSION_NBR
  from
   (select AGP.CODE, TXT.TEXT as DESCRIPTION, TXT.LANG_CODE, AGP.DISPLAY_SEQ, AGP.ACTIVE_FLAG,
      AGP.ITM_ID, AGP.VERSION_NBR,
      row_number() over
       (partition by AGP.CODE
        order by LANG.ACTIVE_FLAG desc, nvl(ULP.PREF_SEQ, LANG.DISPLAY_SEQ + 1e5)) as RANK
    from T_AGE_PROFILES AGP
    inner join T_TEXT_ITEMS TXT
      on TXT.ITM_ID = AGP.ITM_ID
      and TXT.TXTT_CODE = 'DESCR'
      and TXT.SEQ_NBR = 1
    inner join T_LANGUAGES LANG
      on LANG.CODE = TXT.LANG_CODE
    left outer join T_USER_LANGUAGE_PREFERENCES ULP
      on ULP.LANG_CODE = TXT.LANG_CODE
      and ULP.USERID = sys_context('PSR', 'USERID'))
  where RANK = 1)
--
Q_AGE_RANGES as
 (select ID, DESCRIPTION, LANG_CODE, AGP_CODE, AGE_FROM, AGE_TO, ITM_ID, VERSION_NBR
  from
   (select AGR.ID, TXT.TEXT as DESCRIPTION, TXT.LANG_CODE, AGR.AGP_CODE, AGR.AGE_FROM, AGR.AGE_TO,
      AGR.ITM_ID, AGR.VERSION_NBR,
      row_number() over
       (partition by AGR.ID
        order by LANG.ACTIVE_FLAG, nvl(ULP.PREF_SEQ, LANG.DISPLAY_SEQ + 1e5)) as RANK
    from T_AGE_RANGES AGR
    inner join T_TEXT_ITEMS TXT
      on TXT.ITM_ID = AGR.ITM_ID
      and TXT.TXTT_CODE = 'DESCR'
      and TXT.SEQ_NBR = 1
    inner join T_LANGUAGES LANG
      on LANG.CODE = TXT.LANG_CODE
    left outer join T_USER_LANGUAGE_PREFERENCES ULP
      on ULP.LANG_CODE = TXT.LANG_CODE
      and ULP.USERID = sys_context('PSR', 'USERID'))
  where RANK = 1)
--
Q_DESCRIPTIONS as
 (select ITM_ID, LANG_CODE, TAB_ALIAS, TEXT as DESCRIPTION
  from
   (select TXT.ITM_ID, TXT.LANG_CODE, TXT.TAB_ALIAS, TXT.TEXT,
      row_number() over
       (partition by TXT.ITM_ID
        order by LANG.ACTIVE_FLAG desc, nvl(ULP.PREF_SEQ, LANG.DISPLAY_SEQ + 1e5)) as RANK
    from T_TEXT_ITEMS TXT
    inner join T_LANGUAGES LANG
      on LANG.CODE = TXT.LANG_CODE
    left outer join T_USER_LANGUAGE_PREFERENCES ULP
      on ULP.LANG_CODE = TXT.LANG_CODE
      and ULP.USERID = sys_context('PSR', 'USERID')
    where TXT.TXTT_CODE = 'DESCR'
    and TXT.SEQ_NBR = 1)
  where RANK = 1)
--
Q_DIMENSION_TYPES as
 (select CODE, DESCRIPTION, LANG_CODE, DISPLAY_SEQ, ACTIVE_FLAG, ITM_ID, VERSION_NBR
  from
   (select DIMT.CODE, TXT.TEXT as DESCRIPTION, TXT.LANG_CODE, DIMT.DISPLAY_SEQ, DIMT.ACTIVE_FLAG,
      DIMT.ITM_ID, DIMT.VERSION_NBR,
      row_number() over
       (partition by DIMT.CODE
        order by LANG.ACTIVE_FLAG desc, nvl(ULP.PREF_SEQ, LANG.DISPLAY_SEQ + 1e5)) as RANK
    from T_DIMENSION_TYPES DIMT
    inner join T_TEXT_ITEMS TXT
      on TXT.ITM_ID = DIMT.ITM_ID
      and TXT.TXTT_CODE = 'DESCR'
      and TXT.SEQ_NBR = 1
    inner join T_LANGUAGES LANG
      on LANG.CODE = TXT.LANG_CODE
    left outer join T_USER_LANGUAGE_PREFERENCES ULP
      on ULP.LANG_CODE = TXT.LANG_CODE
      and ULP.USERID = sys_context('PSR', 'USERID'))
  where RANK = 1)
--
Q_DIMENSION_VALUES as
 (select ID, DESCRIPTION, LANG_CODE, DIMT_CODE, CODE, DISPLAY_SEQ, ACTIVE_FLAG, ITM_ID, VERSION_NBR
  from
   (select DIM.ID, TXT.TEXT as DESCRIPTION, TXT.LANG_CODE, DIM.DIMT_CODE, DIM.CODE, DIM.DISPLAY_SEQ,
      DIM.ACTIVE_FLAG, DIM.ITM_ID, DIM.VERSION_NBR,
      row_number() over
       (partition by DIM.ID
        order by LANG.ACTIVE_FLAG desc, nvl(ULP.PREF_SEQ, LANG.DISPLAY_SEQ + 1e5)) as RANK
    from T_DIMENSION_VALUES DIM
    inner join T_TEXT_ITEMS TXT
      on TXT.ITM_ID = DIM.ITM_ID
      and TXT.TXTT_CODE = 'DESCR'
      and TXT.SEQ_NBR = 1
    inner join T_LANGUAGES LANG
      on LANG.CODE = TXT.LANG_CODE
    left outer join T_USER_LANGUAGE_PREFERENCES ULP
      on ULP.LANG_CODE = TXT.LANG_CODE
      and ULP.USERID = sys_context('PSR', 'USERID'))
  where RANK = 1)
--
Q_DISPLACEMENT_STATUSES as
 (select CODE, DESCRIPTION, LANG_CODE, DISPLAY_SEQ, ACTIVE_FLAG, ITM_ID, VERSION_NBR
  from
   (select DST.CODE, TXT.TEXT as DESCRIPTION, TXT.LANG_CODE, DST.DISPLAY_SEQ, DST.ACTIVE_FLAG,
      DST.ITM_ID, DST.VERSION_NBR,
      row_number() over
       (partition by DST.CODE
        order by LANG.ACTIVE_FLAG desc, nvl(ULP.PREF_SEQ, LANG.DISPLAY_SEQ + 1e5)) as RANK
    from T_DISPLACEMENT_STATUSES DST
    inner join T_TEXT_ITEMS TXT
      on TXT.ITM_ID = DST.ITM_ID
      and TXT.TXTT_CODE = 'DESCR'
      and TXT.SEQ_NBR = 1
    inner join T_LANGUAGES LANG
      on LANG.CODE = TXT.LANG_CODE
    left outer join T_USER_LANGUAGE_PREFERENCES ULP
      on ULP.LANG_CODE = TXT.LANG_CODE
      and ULP.USERID = sys_context('PSR', 'USERID')
    )
  where RANK = 1)
--
Q_LOCATIONS as
 (select ID, NAME, LANG_CODE, LOCT_CODE, LOCTV_ID, START_DATE, END_DATE, ITM_ID, VERSION_NBR
  from
   (select LOC.ID, TXT.TEXT as NAME, TXT.LANG_CODE, LOC.LOCT_CODE, LOC.LOCTV_ID, LOC.START_DATE,
      LOC.END_DATE, LOC.ITM_ID, LOC.VERSION_NBR,
      row_number() over
       (partition by LOC.ID
        order by LANG.ACTIVE_FLAG desc, nvl(ULP.PREF_SEQ, LANG.DISPLAY_SEQ + 1e5)) as RANK
    from T_LOCATIONS LOC
    inner join T_TEXT_ITEMS TXT
      on TXT.ITM_ID = LOC.ITM_ID
      and TXT.TXTT_CODE = 'NAME'
      and TXT.SEQ_NBR = 1
    inner join T_LANGUAGES LANG
      on LANG.CODE = TXT.LANG_CODE
    left outer join T_USER_LANGUAGE_PREFERENCES ULP
      on ULP.LANG_CODE = TXT.LANG_CODE
      and ULP.USERID = sys_context('PSR', 'USERID'))
  where RANK = 1)
--
Q_LOCATION_TYPES as
 (select CODE, DESCRIPTION, LANG_CODE, DISPLAY_SEQ, ACTIVE_FLAG, ITM_ID, VERSION_NBR
  from
   (select LOCT.CODE, TXT.TEXT as DESCRIPTION, TXT.LANG_CODE, LOCT.DISPLAY_SEQ, LOCT.ACTIVE_FLAG,
      LOCT.ITM_ID, LOCT.VERSION_NBR,
      row_number() over
       (partition by LOCT.CODE
        order by LANG.ACTIVE_FLAG desc, nvl(ULP.PREF_SEQ, LANG.DISPLAY_SEQ + 1e5)) as RANK
    from T_LOCATION_TYPES LOCT
    inner join T_TEXT_ITEMS TXT
      on TXT.ITM_ID = LOCT.ITM_ID
      and TXT.TXTT_CODE = 'DESCR'
      and TXT.SEQ_NBR = 1
    inner join T_LANGUAGES LANG
      on LANG.CODE = TXT.LANG_CODE
    left outer join T_USER_LANGUAGE_PREFERENCES ULP
      on ULP.LANG_CODE = TXT.LANG_CODE
      and ULP.USERID = sys_context('PSR', 'USERID'))
  where RANK = 1)
--
Q_LOCATION_TYPE_VARIANTS as
 (select ID, DESCRIPTION, LANG_CODE, LOCT_CODE, LOC_ID, LOCRT_CODE, DISPLAY_SEQ, ACTIVE_FLAG,
    ITM_ID, VERSION_NBR
  from
    (select LOCTV.ID, TXT.TEXT as DESCRIPTION, TXT.LANG_CODE, LOCTV.LOCT_CODE, LOCTV.LOC_ID,
      LOCTV.LOCRT_CODE, LOCTV.DISPLAY_SEQ, LOCTV.ACTIVE_FLAG, LOCTV.ITM_ID, LOCTV.VERSION_NBR,
      row_number() over
       (partition by LOCTV.ID
        order by LANG.ACTIVE_FLAG desc, nvl(ULP.PREF_SEQ, LANG.DISPLAY_SEQ + 1e5)) as RANK
    from T_LOCATION_TYPE_VARIANTS LOCTV
    inner join T_TEXT_ITEMS TXT
      on TXT.ITM_ID = LOCTV.ITM_ID
      and TXT.TXTT_CODE = 'DESCR'
      and TXT.SEQ_NBR = 1
    inner join T_LANGUAGES LANG
      on LANG.CODE = TXT.LANG_CODE
    left outer join T_USER_LANGUAGE_PREFERENCES ULP
      on ULP.LANG_CODE = TXT.LANG_CODE
      and ULP.USERID = sys_context('PSR', 'USERID'))
  where RANK = 1)
--
Q_NAMES as
 (select ITM_ID, LANG_CODE, TAB_ALIAS, TEXT as NAME
  from
   (select TXT.ITM_ID, TXT.LANG_CODE, TXT.TAB_ALIAS, TXT.TEXT,
      row_number() over
       (partition by TXT.ITM_ID
        order by LANG.ACTIVE_FLAG desc, nvl(ULP.PREF_SEQ, LANG.DISPLAY_SEQ + 1e5)) as RANK
    from T_TEXT_ITEMS TXT
    inner join T_LANGUAGES LANG
      on LANG.CODE = TXT.LANG_CODE
    left outer join T_USER_LANGUAGE_PREFERENCES ULP
      on ULP.LANG_CODE = TXT.LANG_CODE
      and ULP.USERID = sys_context('PSR', 'USERID')
    where TXT.TXTT_CODE = 'NAME'
    and TXT.SEQ_NBR = 1)
  where RANK = 1)
--
Q_NOTES as
 (select ITM_ID, SEQ_NBR, LANG_CODE, TAB_ALIAS, LONG_TEXT as NOTE
  from
   (select TXT.ITM_ID, TXT.SEQ_NBR, TXT.LANG_CODE, TXT.TAB_ALIAS, TXT.LONG_TEXT,
      row_number() over
       (partition by TXT.ITM_ID, TXT.SEQ_NBR
        order by LANG.ACTIVE_FLAG desc, nvl(ULP.PREF_SEQ, LANG.DISPLAY_SEQ + 1e5)) as RANK
    from T_TEXT_ITEMS TXT
    inner join T_LANGUAGES LANG
      on LANG.CODE = TXT.LANG_CODE
    left outer join T_USER_LANGUAGE_PREFERENCES ULP
      on ULP.LANG_CODE = TXT.LANG_CODE
      and ULP.USERID = sys_context('PSR', 'USERID')
    where TXT.TXTT_CODE = 'NOTE')
  where RANK = 1)
--
Q_POPULATION_PLANNING_GROUPS as
 (select id, DESCRIPTION, LANG_CODE, LOC_ID, PPG_CODE, START_DATE, END_DATE, ITM_ID, VERSION_NBR
  from
   (select PPG.ID, TXT.TEXT as DESCRIPTION, TXT.LANG_CODE, PPG.LOC_ID, PPG.PPG_CODE, PPG.START_DATE,
      PPG.END_DATE, PPG.ITM_ID, PPG.VERSION_NBR,
      row_number() over
       (partition by PPG.ID
        order by LANG.ACTIVE_FLAG desc, nvl(ULP.PREF_SEQ, LANG.DISPLAY_SEQ + 1e5)) as RANK
    from T_POPULATION_PLANNING_GROUPS PPG
    inner join T_TEXT_ITEMS TXT
      on TXT.ITM_ID = PPG.ITM_ID
      and TXT.TXTT_CODE = 'DESCR'
      and TXT.SEQ_NBR = 1
    inner join T_LANGUAGES LANG
      on LANG.CODE = TXT.LANG_CODE
    left outer join T_USER_LANGUAGE_PREFERENCES ULP
      on ULP.LANG_CODE = TXT.LANG_CODE
      and ULP.USERID = sys_context('PSR', 'USERID'))
  where RANK = 1)
--
Q_SEXES as
 (select CODE, DESCRIPTION, LANG_CODE, DISPLAY_SEQ, ITM_ID, VERSION_NBR
  from
   (select SEX.CODE, TXT.TEXT as DESCRIPTION, TXT.LANG_CODE, SEX.DISPLAY_SEQ, SEX.ITM_ID,
      SEX.VERSION_NBR,
      row_number() over
       (partition by SEX.CODE
        order by LANG.ACTIVE_FLAG desc, nvl(ULP.PREF_SEQ, LANG.DISPLAY_SEQ + 1e5)) as RANK
    from T_SEXES SEX
    inner join T_TEXT_ITEMS TXT
      on TXT.ITM_ID = SEX.ITM_ID
      and TXT.TXTT_CODE = 'DESCR'
      and TXT.SEQ_NBR = 1
    inner join T_LANGUAGES LANG
      on LANG.CODE = TXT.LANG_CODE
    left outer join T_USER_LANGUAGE_PREFERENCES ULP
      on ULP.LANG_CODE = TXT.LANG_CODE
      and ULP.USERID = sys_context('PSR', 'USERID'))
  where RANK = 1)
--
Q_STATISTIC_TYPES as
 (select CODE, DESCRIPTION, LANG_CODE, DISPLAY_SEQ, ACTIVE_FLAG, ITM_ID, VERSION_NBR
  from
   (select STCT.CODE, TXT.TEXT as DESCRIPTION, TXT.LANG_CODE, STCT.DISPLAY_SEQ, STCT.ACTIVE_FLAG,
      STCT.ITM_ID, STCT.VERSION_NBR,
      row_number() over
       (partition by STCT.CODE
        order by LANG.ACTIVE_FLAG desc, nvl(ULP.PREF_SEQ, LANG.DISPLAY_SEQ + 1e5)) as RANK
    from T_STATISTIC_TYPES STCT
    inner join T_TEXT_ITEMS TXT
      on TXT.ITM_ID = STCT.ITM_ID
      and TXT.TXTT_CODE = 'DESCR'
      and TXT.SEQ_NBR = 1
    inner join T_LANGUAGES LANG
      on LANG.CODE = TXT.LANG_CODE
    left outer join T_USER_LANGUAGE_PREFERENCES ULP
      on ULP.LANG_CODE = TXT.LANG_CODE
      and ULP.USERID = sys_context('PSR', 'USERID'))
  where RANK = 1)
--
Q_STATISTIC_TYPE_GROUPS as
 (select CODE, DESCRIPTION, LANG_CODE, DISPLAY_SEQ, ACTIVE_FLAG, ITM_ID, VERSION_NBR
  from
   (select STTG.CODE, TXT.TEXT as DESCRIPTION, TXT.LANG_CODE, STTG.DISPLAY_SEQ, STTG.ACTIVE_FLAG,
      STTG.ITM_ID, STTG.VERSION_NBR,
      row_number() over
       (partition by STTG.CODE
        order by LANG.ACTIVE_FLAG desc, nvl(ULP.PREF_SEQ, LANG.DISPLAY_SEQ + 1e5)) as RANK
    from T_STATISTIC_TYPE_GROUPS STTG
    inner join T_TEXT_ITEMS TXT
      on TXT.ITM_ID = STTG.ITM_ID
      and TXT.TXTT_CODE = 'DESCR'
      and TXT.SEQ_NBR = 1
    inner join T_LANGUAGES LANG
      on LANG.CODE = TXT.LANG_CODE
    left outer join T_USER_LANGUAGE_PREFERENCES ULP
      on ULP.LANG_CODE = TXT.LANG_CODE
      and ULP.USERID = sys_context('PSR', 'USERID'))
  where RANK = 1)
--
Q_TEXT_ITEMS as
 (select ITM_ID, TXTT_CODE, SEQ_NBR, LANG_CODE, TAB_ALIAS, TEXT, LONG_TEXT
  from
   (select TXT.ITM_ID, TXT.TXTT_CODE, TXT.SEQ_NBR, TXT.LANG_CODE, TXT.TAB_ALIAS, TXT.TEXT,
      TXT.LONG_TEXT,
      row_number() over
       (partition by TXT.ITM_ID, TXT.TXTT_CODE, TXT.SEQ_NBR
        order by LANG.ACTIVE_FLAG desc, nvl(ULP.PREF_SEQ, LANG.DISPLAY_SEQ + 1e5)) as RANK
    from T_TEXT_ITEMS TXT
    inner join T_LANGUAGES LANG
      on LANG.CODE = TXT.LANG_CODE
    left outer join T_USER_LANGUAGE_PREFERENCES ULP
      on ULP.LANG_CODE = TXT.LANG_CODE
      and ULP.USERID = sys_context('PSR', 'USERID'))
  where RANK = 1)
--
Q_TIME_PERIOD_TYPES as
 (select CODE, DESCRIPTION, LANG_CODE, DISPLAY_SEQ, ACTIVE_FLAG, ITM_ID, VERSION_NBR
  from
   (select PERT.CODE, TXT.TEXT as DESCRIPTION, TXT.LANG_CODE, PERT.DISPLAY_SEQ, PERT.ACTIVE_FLAG,
      PERT.ITM_ID, PERT.VERSION_NBR,
      row_number() over
       (partition by PERT.CODE
        order by LANG.ACTIVE_FLAG desc, nvl(ULP.PREF_SEQ, LANG.DISPLAY_SEQ + 1e5)) as RANK
    from T_TIME_PERIOD_TYPES PERT
    inner join T_TEXT_ITEMS TXT
      on TXT.ITM_ID = PERT.ITM_ID
      and TXT.TXTT_CODE = 'DESCR'
      and TXT.SEQ_NBR = 1
    inner join T_LANGUAGES LANG
      on LANG.CODE = TXT.LANG_CODE
    left outer join T_USER_LANGUAGE_PREFERENCES ULP
      on ULP.LANG_CODE = TXT.LANG_CODE
      and ULP.USERID = sys_context('PSR', 'USERID'))
  where RANK = 1)
--