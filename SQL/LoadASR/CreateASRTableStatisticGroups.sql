set serveroutput on

declare
  nSTG_ID P_BASE.tnSTG_ID;
  nCount1 pls_integer := 0;
  nCount2 pls_integer := 0;
begin
  for rSTC in
   (select STTG_CODE, START_DATE, END_DATE, LOC_ID_ASYLUM_COUNTRY, LOC_ID_ORIGIN_COUNTRY,
      row_number() over
       (partition by STTG_CODE, START_DATE, END_DATE, LOC_ID_ASYLUM_COUNTRY, LOC_ID_ORIGIN_COUNTRY
        order by STC_ID) as SEQ_NBR,
      STC_ID
    from
     (select STTIG.STTG_CODE,
        trunc(STC.START_DATE, 'YYYY') as START_DATE,
        add_months(trunc(STC.START_DATE, 'YYYY'), 12) as END_DATE,
        case
          when STTIG.STTG_CODE != 'RETURNEE'
          then STC.LOC_ID_ASYLUM_COUNTRY
        end as LOC_ID_ASYLUM_COUNTRY,
        case
          when STTIG.STTG_CODE = 'RETURNEE'
          then STC.LOC_ID_ORIGIN_COUNTRY
        end as LOC_ID_ORIGIN_COUNTRY,
        STC.ID as STC_ID
      from T_STATISTIC_TYPES_IN_GROUPS STTIG
      inner join T_STATISTICS STC
        on STC.STCT_CODE = STTIG.STCT_CODE
      where extract(YEAR FROM START_DATE) = &year
	    and STTIG.STTG_CODE in
        ('REFUGEE', 'DEMOGR', 'RSD', 'IDP', 'IDPCNFLCT', 'IDPNTRLDIS', 'RETURNEE', 'STATELESS', 'OOC'))
    order by STTG_CODE, START_DATE, LOC_ID_ASYLUM_COUNTRY, LOC_ID_ORIGIN_COUNTRY, SEQ_NBR)
  loop
    if rSTC.SEQ_NBR = 1
    then
      P_STATISTIC_GROUP.INSERT_STATISTIC_GROUP
       (nSTG_ID, rSTC.START_DATE, rSTC.END_DATE, rSTC.STTG_CODE,
        pnLOC_ID_ASYLUM_COUNTRY => rSTC.LOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => rSTC.LOC_ID_ORIGIN_COUNTRY);
      nCount1 := nCount1 + 1;
    end if;
  --
    P_STATISTIC.INSERT_STATISTIC_IN_GROUP(rSTC.STC_ID, nSTG_ID);
    nCount2 := nCount2 + 1;
  end loop;
--
  dbms_output.put_line(to_char(nCount1) || ' STATISTIC_GROUPS records inserted');
  dbms_output.put_line(to_char(nCount2) || ' STATISTICS_IN_GROUPS records inserted');
end;
/
