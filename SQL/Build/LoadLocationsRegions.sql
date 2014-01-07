set serveroutput on

declare
  type tanLOC_ID is table of P_BASE.tnLOC_ID index by pls_integer;
  anLOC_ID tanLOC_ID;
  nLOC_ID P_BASE.tnLOC_ID;
  nLOC_VERSION_NBR P_BASE.tnLOC_VERSION_NBR;
  nTXT_SEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  iCount pls_integer := 0;
--
  procedure INSERT_LOCATION_WITHIN
   (pnLOC_ID_FROM in P_BASE.tmnLOC_ID,
    pnLOC_ID_TO in P_BASE.tmnLOC_ID,
    pdSTART_DATE in P_BASE.tdDate,
    pdEND_DATE in P_BASE.tdDate)
  is
    sDummy varchar2(1);
  begin
    begin
      select 'x'
      into sDummy
      from T_LOCATION_RELATIONSHIPS
      where LOC_ID_FROM = pnLOC_ID_FROM
      and LOC_ID_TO = pnLOC_ID_TO
      and LOCRT_CODE = 'WITHIN'
      and START_DATE < nvl(pdEND_DATE, P_BASE.gdMAX_DATE)
      and END_DATE > nvl(pdSTART_DATE, P_BASE.gdMIN_DATE);
    --
      return;
    exception
      when NO_DATA_FOUND
      then null;
    end;
  --
    P_LOCATION.INSERT_LOCATION_WITHIN(pnLOC_ID_FROM, pnLOC_ID_TO, pdSTART_DATE, pdEND_DATE);
  end INSERT_LOCATION_WITHIN;
begin
  for rLOC in
   (select REG.KEY, REG.NAME_EN, REG.LOCT_CODE, REG.START_DATE, REG.END_DATE,
      nvl(REG.ACTIVE_FLAG, 'Y') as ACTIVE_FLAG, REG.NAME_FR, REG.UNSDNUM, REG.HCRCD, REG.DISPLAYSEQ,
      REG.RSKEY, REG.NOTES, LID.ID
    from S_LOCATION_REGIONS REG
    left outer join S_LOCATION_IDS LID
      on LID.LOCT_CODE = REG.LOCT_CODE
      and LID.NAME_EN = REG.NAME_EN
      and nvl(LID.START_DATE, P_BASE.MIN_DATE) = nvl(REG.START_DATE, P_BASE.MIN_DATE)
    order by REG.KEY)
  loop
    iCount := iCount + 1;
  --
    if rLOC.ID is null
    then
      P_LOCATION.INSERT_LOCATION
       (nLOC_ID, 'en', rLOC.NAME_EN, rLOC.LOCT_CODE,
        pdSTART_DATE => rLOC.START_DATE, pdEND_DATE => rLOC.END_DATE,
        psACTIVE_FLAG => rLOC.ACTIVE_FLAG);
    else
      P_LOCATION.INSERT_LOCATION_WITH_ID
       (rLOC.ID, 'en', rLOC.NAME_EN, rLOC.LOCT_CODE,
        pdSTART_DATE => rLOC.START_DATE, pdEND_DATE => rLOC.END_DATE,
        psACTIVE_FLAG => rLOC.ACTIVE_FLAG);
      nLOC_ID := rLOC.ID;
    end if;
  --
    anLOC_ID(rLOC.KEY) := nLOC_ID;
    nLOC_VERSION_NBR := 1;
  --
    if rLOC.NAME_FR is not null
    then P_LOCATION.SET_LOC_NAME(nLOC_ID, nLOC_VERSION_NBR, 'fr', rLOC.NAME_FR);
    end if;
  --
    if rLOC.UNSDNUM is not null
    then P_LOCATION.INSERT_LOCATION_ATTRIBUTE(nLOC_ID, 'UNSDNUM', rLOC.UNSDNUM);
    end if;
  --
    if rLOC.HCRCD is not null
    then P_LOCATION.INSERT_LOCATION_ATTRIBUTE(nLOC_ID, 'HCRCD', rLOC.HCRCD);
    end if;
  --
    if rLOC.DISPLAYSEQ is not null
    then P_LOCATION.INSERT_LOCATION_ATTRIBUTE(nLOC_ID, 'DISPLAYSEQ', pnNUM_VALUE => rLOC.DISPLAYSEQ);
    end if;
  --
    if rLOC.RSKEY is not null
    then P_LOCATION.INSERT_LOCATION_ATTRIBUTE(nLOC_ID, 'RSKEY', rLOC.RSKEY);
    end if;
  --
    if rLOC.NOTES is not null
    then
      nTXT_SEQ_NBR := null;
      P_LOCATION.SET_LOC_TEXT(nLOC_ID, nLOC_VERSION_NBR, 'NOTE', nTXT_SEQ_NBR, 'en', rLOC.NOTES);
    end if;
  end loop;
--
  if iCount = 1
  then dbms_output.put_line('1 LOCATIONS record inserted');
  else dbms_output.put_line(to_char(iCount) || ' LOCATIONS records inserted');
  end if;
--
  iCount := 0;
--
  for rLOC in
   (select KEY, START_DATE, END_DATE,
      UNSD_FROM_KEY, UNSDA_FROM_KEY, HCRRESP_FROM_KEY, RSGEO_FROM_KEY, RSHCR_FROM_KEY
    from S_LOCATION_REGIONS
    order by KEY)
  loop
    if rLOC.UNSD_FROM_KEY is not null
    then
      iCount := iCount + 1;
      P_LOCATION.INSERT_LOCATION_RELATIONSHIP
       (anLOC_ID(rLOC.UNSD_FROM_KEY), anLOC_ID(rLOC.KEY), 'UNSD', rLOC.START_DATE, rLOC.END_DATE);
    --
      INSERT_LOCATION_WITHIN
       (anLOC_ID(rLOC.UNSD_FROM_KEY), anLOC_ID(rLOC.KEY), rLOC.START_DATE, rLOC.END_DATE);
    end if;
  --
    if rLOC.UNSDA_FROM_KEY is not null
    then
      iCount := iCount + 1;
      P_LOCATION.INSERT_LOCATION_RELATIONSHIP
       (anLOC_ID(rLOC.UNSDA_FROM_KEY), anLOC_ID(rLOC.KEY), 'UNSDA', rLOC.START_DATE, rLOC.END_DATE);
    --
      INSERT_LOCATION_WITHIN
       (anLOC_ID(rLOC.UNSDA_FROM_KEY), anLOC_ID(rLOC.KEY), rLOC.START_DATE, rLOC.END_DATE);
    end if;
  --
    if rLOC.HCRRESP_FROM_KEY is not null
    then
      iCount := iCount + 1;
      P_LOCATION.INSERT_LOCATION_RELATIONSHIP
       (anLOC_ID(rLOC.HCRRESP_FROM_KEY), anLOC_ID(rLOC.KEY), 'HCRRESP', rLOC.START_DATE, rLOC.END_DATE);
    end if;
  --
    if rLOC.RSGEO_FROM_KEY is not null
    then
      iCount := iCount + 1;
      P_LOCATION.INSERT_LOCATION_RELATIONSHIP
       (anLOC_ID(rLOC.RSGEO_FROM_KEY), anLOC_ID(rLOC.KEY), 'RSGEO', rLOC.START_DATE, rLOC.END_DATE);
    end if;
  --
    if rLOC.RSHCR_FROM_KEY is not null
    then
      iCount := iCount + 1;
      P_LOCATION.INSERT_LOCATION_RELATIONSHIP
       (anLOC_ID(rLOC.RSHCR_FROM_KEY), anLOC_ID(rLOC.KEY), 'RSHCR', rLOC.START_DATE, rLOC.END_DATE);
    end if;
  end loop;
--
  if iCount = 1
  then dbms_output.put_line('1 LOCATION_RELATIONSHIPS record inserted');
  else dbms_output.put_line(to_char(iCount) || ' LOCATION_RELATIONSHIPS records inserted');
  end if;
--
  iCount := 0;
--
  for rLOC in
   (select KEY, TXTT_CODE, ALT_NAME_EN
    from S_LOCATION_REGION_NAMES)
  loop
    select ID, VERSION_NBR
    into nLOC_ID, nLOC_VERSION_NBR
    from T_LOCATIONS
    where ID = anLOC_ID(rLOC.KEY);
  --
    nTXT_SEQ_NBR := null;
  --
    if rLOC.ALT_NAME_EN is not null
    then
      iCount := iCount + 1;
      P_LOCATION.SET_LOC_TEXT
       (nLOC_ID, nLOC_VERSION_NBR, rLOC.TXTT_CODE, nTXT_SEQ_NBR, 'en', rLOC.ALT_NAME_EN);
    end if;
  end loop;
--
  if iCount = 1
  then dbms_output.put_line('1 additional TEXT_ITEMS record inserted');
  else dbms_output.put_line(to_char(iCount) || ' additional TEXT_ITEMS records inserted');
  end if;
end;
/
