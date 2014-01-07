set serveroutput on

declare
  type tanLOC_ID is table of P_BASE.tnLOC_ID index by pls_integer;
  anLOC_ID tanLOC_ID;
  nLOC_ID P_BASE.tnLOC_ID;
  nVERSION_NBR P_BASE.tnLOC_VERSION_NBR;
  nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  iCount1 pls_integer := 0;
  iCount2 pls_integer := 0;
begin
  for rLOC in
   (select LOC.KEY, LOC.ISO3166A3, LOC.ISO_NAME_EN, LOC.LOCT_CODE, LOC.START_DATE, LOC.END_DATE,
      nvl(LOC.ACTIVE_FLAG, 'Y') as ACTIVE_FLAG, LOC.ISO3166A2, LOC.ISO3166NUM, LOC.HCRCC,
      LOC.ISO_NAME_FR, LOC.ISO_FULL_NAME_EN, LOC.ISO_FULL_NAME_FR,
      LOC.GAWCC, LOC.GAACC, LOC.GAHCC, LOC.NOTES, LID.ID,
      LOCA1.LOC_ID as LOC_ID_UNSD, LOCA2.LOC_ID as LOC_ID_HCRRESP1, LOCA3.LOC_ID as LOC_ID_HCRRESP2
    from S_LOCATION_COUNTRIES LOC
    left outer join S_LOCATION_IDS LID
      on LID.LOCT_CODE = LOC.LOCT_CODE
      and LID.NAME_EN = LOC.ISO_NAME_EN
      and nvl(LID.START_DATE, P_BASE.MIN_DATE) = nvl(LOC.START_DATE, P_BASE.MIN_DATE)
    left outer join T_LOCATION_ATTRIBUTES LOCA1
      on LOCA1.LOCAT_CODE = 'UNSDNUM'
      and LOCA1.CHAR_VALUE = LOC.UNSD_FROM
    left outer join T_LOCATION_ATTRIBUTES LOCA2
      on LOCA2.LOCAT_CODE = 'HCRCD'
      and LOCA2.CHAR_VALUE = LOC.HCRRESP_FROM1
    left outer join T_LOCATION_ATTRIBUTES LOCA3
      on LOCA3.LOCAT_CODE = 'HCRCD'
      and LOCA3.CHAR_VALUE = LOC.HCRRESP_FROM2
    order by LOC.ISO_NAME_EN)
  loop
    iCount1 := iCount1 + 1;
  --
    if rLOC.ID is null
    then
      P_LOCATION.INSERT_LOCATION
       (nLOC_ID, 'en', rLOC.ISO_NAME_EN, rLOC.LOCT_CODE,
        case when rLOC.LOCT_CODE = 'COUNTRY' then rLOC.ISO3166A3 end,
        rLOC.START_DATE, rLOC.END_DATE, rLOC.ACTIVE_FLAG);
    else
      P_LOCATION.INSERT_LOCATION_WITH_ID
       (rLOC.ID, 'en', rLOC.ISO_NAME_EN, rLOC.LOCT_CODE,
        case when rLOC.LOCT_CODE = 'COUNTRY' then rLOC.ISO3166A3 end,
        rLOC.START_DATE, rLOC.END_DATE, rLOC.ACTIVE_FLAG);
      nLOC_ID := rLOC.ID;
    end if;
  --
    anLOC_ID(rLOC.KEY) := nLOC_ID;
    nVERSION_NBR := 1;
  --
    if rLOC.LOCT_CODE != 'COUNTRY' and rLOC.ISO3166A3 is not null
    then P_LOCATION.INSERT_LOCATION_ATTRIBUTE(nLOC_ID, 'ISO3166A3', rLOC.ISO3166A3);
    end if;
  --
    if rLOC.ISO3166A2 is not null
    then P_LOCATION.INSERT_LOCATION_ATTRIBUTE(nLOC_ID, 'ISO3166A2', rLOC.ISO3166A2);
    end if;
  --
    if rLOC.ISO3166NUM is not null
    then P_LOCATION.INSERT_LOCATION_ATTRIBUTE(nLOC_ID, 'ISO3166NUM', rLOC.ISO3166NUM);
    end if;
  --
    if rLOC.HCRCC is not null
    then P_LOCATION.INSERT_LOCATION_ATTRIBUTE(nLOC_ID, 'HCRCC', upper(rLOC.HCRCC));
    end if;
  --
    if rLOC.ISO_NAME_FR is not null
    then P_LOCATION.SET_LOC_NAME(nLOC_ID, nVERSION_NBR, 'fr', rLOC.ISO_NAME_FR);
    end if;
  --
    if rLOC.ISO_FULL_NAME_EN is not null or rLOC.ISO_FULL_NAME_FR is not null
    then
      nSEQ_NBR := null;
    --
      if rLOC.ISO_FULL_NAME_EN is not null
      then P_LOCATION.SET_LOC_TEXT(nLOC_ID, nVERSION_NBR, 'FORMALNAME', nSEQ_NBR, 'en', rLOC.ISO_FULL_NAME_EN);
      end if;
    --
      if rLOC.ISO_FULL_NAME_FR is not null
      then P_LOCATION.SET_LOC_TEXT(nLOC_ID, nVERSION_NBR, 'FORMALNAME', nSEQ_NBR, 'fr', rLOC.ISO_FULL_NAME_FR);
      end if;
    end if;
  --
    if rLOC.GAWCC is not null
    then P_LOCATION.INSERT_LOCATION_ATTRIBUTE(nLOC_ID, 'GAWCC', upper(rLOC.GAWCC));
    end if;
  --
    if rLOC.GAACC is not null
    then P_LOCATION.INSERT_LOCATION_ATTRIBUTE(nLOC_ID, 'GAACC', upper(rLOC.GAACC));
    end if;
  --
    if rLOC.GAHCC is not null
    then P_LOCATION.INSERT_LOCATION_ATTRIBUTE(nLOC_ID, 'GAHCC', upper(rLOC.GAHCC));
    end if;
  --
    if rLOC.NOTES is not null
    then
      nSEQ_NBR := null;
      P_LOCATION.SET_LOC_TEXT(nLOC_ID, nVERSION_NBR, 'NOTE', nSEQ_NBR, 'en', rLOC.NOTES);
    end if;
  --
    if rLOC.LOC_ID_UNSD is not null
    then
      iCount2 := iCount2 + 1;
      P_LOCATION.INSERT_LOCATION_RELATIONSHIP
       (rLOC.LOC_ID_UNSD, nLOC_ID, 'UNSD', rLOC.START_DATE, rLOC.END_DATE);
    --
      P_LOCATION.INSERT_LOCATION_WITHIN
       (rLOC.LOC_ID_UNSD, nLOC_ID, rLOC.START_DATE, rLOC.END_DATE);
    end if;
  --
    if rLOC.LOC_ID_HCRRESP1 is not null
    then
      iCount2 := iCount2 + 1;
      P_LOCATION.INSERT_LOCATION_RELATIONSHIP
       (rLOC.LOC_ID_HCRRESP1, nLOC_ID, 'HCRRESP', rLOC.START_DATE, rLOC.END_DATE);
    end if;
  --
    if rLOC.LOC_ID_HCRRESP2 is not null
    then
      iCount2 := iCount2 + 1;
      P_LOCATION.INSERT_LOCATION_RELATIONSHIP(rLOC.LOC_ID_HCRRESP2, nLOC_ID, 'HCRRESP', rLOC.START_DATE, rLOC.END_DATE);
    end if;
  end loop;
--
  if iCount1 = 1
  then dbms_output.put_line('1 LOCATIONS record inserted');
  else dbms_output.put_line(to_char(iCount1) || ' LOCATIONS records inserted');
  end if;
--
  for rLOC in
   (select KEY, CSPLIT_FROM_KEY, CMERGE_TO_KEY, CCHANGE_FROM_KEY
    from S_LOCATION_COUNTRIES)
  loop
    if rLOC.CSPLIT_FROM_KEY is not null
    then
      iCount2 := iCount2 + 1;
      P_LOCATION.INSERT_LOCATION_RELATIONSHIP(anLOC_ID(rLOC.CSPLIT_FROM_KEY), anLOC_ID(rLOC.KEY), 'CSPLIT');
    end if;
  --
    if rLOC.CMERGE_TO_KEY is not null
    then
      iCount2 := iCount2 + 1;
      P_LOCATION.INSERT_LOCATION_RELATIONSHIP(anLOC_ID(rLOC.KEY), anLOC_ID(rLOC.CMERGE_TO_KEY), 'CMERGE');
    end if;
  --
    if rLOC.CCHANGE_FROM_KEY is not null
    then
      iCount2 := iCount2 + 1;
      P_LOCATION.INSERT_LOCATION_RELATIONSHIP(anLOC_ID(rLOC.CCHANGE_FROM_KEY), anLOC_ID(rLOC.KEY), 'CCHANGE');
    end if;
  end loop;
--
  if iCount2 = 1
  then dbms_output.put_line('1 LOCATION_RELATIONSHIPS record inserted');
  else dbms_output.put_line(to_char(iCount2) || ' LOCATION_RELATIONSHIPS records inserted');
  end if;
--
  iCount1 := 0;
--
  for rLOC in
   (select KEY, TXTT_CODE, NAME_EN, NAME_FR
    from S_LOCATION_COUNTRY_NAMES)
  loop
    select ID, VERSION_NBR
    into nLOC_ID, nVERSION_NBR
    from T_LOCATIONS
    where ID = anLOC_ID(rLOC.KEY);
  --
    nSEQ_NBR := null;
  --
    if rLOC.NAME_EN is not null
    then
      iCount1 := iCount1 + 1;
      P_LOCATION.SET_LOC_TEXT(nLOC_ID, nVERSION_NBR, rLOC.TXTT_CODE, nSEQ_NBR, 'en', rLOC.NAME_EN);
    end if;
  --
    if rLOC.NAME_FR is not null
    then
      iCount1 := iCount1 + 1;
      P_LOCATION.SET_LOC_TEXT(nLOC_ID, nVERSION_NBR, rLOC.TXTT_CODE, nSEQ_NBR, 'fr', rLOC.NAME_FR);
    end if;
  end loop;
--
  if iCount1 = 1
  then dbms_output.put_line('1 additional TEXT_ITEMS record inserted');
  else dbms_output.put_line(to_char(iCount1) || ' additional TEXT_ITEMS records inserted');
  end if;
end;
/
