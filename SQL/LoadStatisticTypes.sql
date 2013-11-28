set serveroutput on

declare
  nSTTG_VERSION_NBR P_BASE.tnSTTG_VERSION_NBR;
  nSTCT_VERSION_NBR P_BASE.tnSTCT_VERSION_NBR;
  nSTTIG_VERSION_NBR P_BASE.tnSTTIG_VERSION_NBR;
  nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  iCount1 pls_integer := 0;
  iCount2 pls_integer := 0;
  iCount3 pls_integer := 0;
begin
  for rSTTG in
   (select CODE, DESCRIPTION_EN, DISPLAY_SEQ, DESCRIPTION_FR, NOTES
    from STAGE.S_STATISTIC_TYPE_GROUPS)
  loop
    iCount1 := iCount1 + 1;
  --
    P_STATISTIC_TYPE.INSERT_STATISTIC_TYPE_GROUP
     (rSTTG.CODE, 'en', rSTTG.DESCRIPTION_EN, rSTTG.DISPLAY_SEQ);
    nSTTG_VERSION_NBR := 1;
  --
    if rSTTG.DESCRIPTION_FR is not null
    then
      P_STATISTIC_TYPE.SET_STTG_DESCRIPTION
       (rSTTG.CODE, nSTTG_VERSION_NBR, 'fr', rSTTG.DESCRIPTION_FR);
    end if;
  --
    if rSTTG.NOTES is not null
    then
      nSEQ_NBR := null;
      P_STATISTIC_TYPE.SET_STTG_TEXT
       (rSTTG.CODE, nSTTG_VERSION_NBR, 'NOTE', nSEQ_NBR, 'en', rSTTG.NOTES);
    end if;
  end loop;
--
  for rSTCT in
   (select CODE, DESCRIPTION_EN, DST_CODE_FLAG,
      LOC_ID_ASYLUM_COUNTRY_FLAG, LOC_ID_ASYLUM_FLAG,
      LOC_ID_ORIGIN_COUNTRY_FLAG, LOC_ID_ORIGIN_FLAG,
      DIM_ID1_FLAG, DIMT_CODE1, DIM_ID2_FLAG, DIMT_CODE2, DIM_ID3_FLAG, DIMT_CODE3,
      DIM_ID4_FLAG, DIMT_CODE4, DIM_ID5_FLAG, DIMT_CODE5, SEX_CODE_FLAG, AGR_ID_FLAG,
      PGR_ID_SUBGROUP_FLAG, STTG_CODE1, STTG_CODE2, STTG_CODE3, STTG_CODE4,
      DISPLAY_SEQ, DESCRIPTION_FR, NOTES
    from STAGE.S_STATISTIC_TYPES)
  loop
    iCount2 := iCount2 + 1;
  --
    P_STATISTIC_TYPE.INSERT_STATISTIC_TYPE
     (rSTCT.CODE, 'en', rSTCT.DESCRIPTION_EN, rSTCT.DST_CODE_FLAG,
      rSTCT.LOC_ID_ASYLUM_COUNTRY_FLAG, rSTCT.LOC_ID_ASYLUM_FLAG,
      rSTCT.LOC_ID_ORIGIN_COUNTRY_FLAG, rSTCT.LOC_ID_ORIGIN_FLAG,
      rSTCT.DIM_ID1_FLAG, rSTCT.DIMT_CODE1, rSTCT.DIM_ID2_FLAG, rSTCT.DIMT_CODE2,
      rSTCT.DIM_ID3_FLAG, rSTCT.DIMT_CODE3, rSTCT.DIM_ID4_FLAG, rSTCT.DIMT_CODE4,
      rSTCT.DIM_ID5_FLAG, rSTCT.DIMT_CODE5, rSTCT.SEX_CODE_FLAG, rSTCT.AGR_ID_FLAG,
      rSTCT.PGR_ID_SUBGROUP_FLAG, rSTCT.DISPLAY_SEQ);
    nSTCT_VERSION_NBR := 1;
  --
    if rSTCT.STTG_CODE1 is not null
    then
      iCount3 := iCount3 + 1;
      P_STATISTIC_TYPE.INSERT_STATISTIC_TYPE_IN_GROUP(rSTCT.STTG_CODE1, rSTCT.CODE);
    end if;
  --
    if rSTCT.STTG_CODE2 is not null
    then
      iCount3 := iCount3 + 1;
      P_STATISTIC_TYPE.INSERT_STATISTIC_TYPE_IN_GROUP(rSTCT.STTG_CODE2, rSTCT.CODE);
    end if;
  --
    if rSTCT.STTG_CODE3 is not null
    then
      iCount3 := iCount3 + 1;
      P_STATISTIC_TYPE.INSERT_STATISTIC_TYPE_IN_GROUP(rSTCT.STTG_CODE3, rSTCT.CODE);
    end if;
  --
    if rSTCT.STTG_CODE4 is not null
    then
      iCount3 := iCount3 + 1;
      P_STATISTIC_TYPE.INSERT_STATISTIC_TYPE_IN_GROUP(rSTCT.STTG_CODE4, rSTCT.CODE);
    end if;
  --
    if rSTCT.DESCRIPTION_FR is not null
    then
      P_STATISTIC_TYPE.SET_STCT_DESCRIPTION
       (rSTCT.CODE, nSTCT_VERSION_NBR, 'fr', rSTCT.DESCRIPTION_FR);
    end if;
  --
    if rSTCT.NOTES is not null
    then
      nSEQ_NBR := null;
      P_STATISTIC_TYPE.SET_STCT_TEXT
       (rSTCT.CODE, nSTCT_VERSION_NBR, 'NOTE', nSEQ_NBR, 'en', rSTCT.NOTES);
    end if;
  end loop;
--
  for rSTTIG in
   (select STTG_CODE, STCT_CODE, NOTES
    from STAGE.S_STATISTIC_TYPES_IN_GROUPS
    where (STTG_CODE, STCT_CODE) not in
     (select STTG_CODE, STCT_CODE
      from T_STATISTIC_TYPES_IN_GROUPS))
  loop
    iCount3 := iCount3 + 1;
  --
    P_STATISTIC_TYPE.INSERT_STATISTIC_TYPE_IN_GROUP(rSTTIG.STTG_CODE, rSTTIG.STCT_CODE);
    nSTTIG_VERSION_NBR := 1;
  --
    if rSTTIG.NOTES is not null
    then
      nSEQ_NBR := null;
      P_STATISTIC_TYPE.SET_STTIG_TEXT
       (rSTTIG.STTG_CODE, rSTTIG.STCT_CODE, nSTTIG_VERSION_NBR, 'NOTE', nSEQ_NBR, 'en', rSTTIG.NOTES);
    end if;
  end loop;
--
  dbms_output.put_line(to_char(iCount1) || ' STATISTIC_TYPE_GROUPS records inserted');
  dbms_output.put_line(to_char(iCount2) || ' STATISTIC_TYPES records inserted');
  dbms_output.put_line(to_char(iCount3) || ' STATISTIC_TYPES_IN_GROUPS records inserted');
end;
/
