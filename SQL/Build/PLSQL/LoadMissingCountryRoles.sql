declare
  nCount pls_integer := 0;
begin
  nCount := 0;
--
  for rRLC in
   (
    select  ROL_ID, LOC_ID from
    ( select 7 as ROL_ID from dual
      union 
      select 8 from dual
    ) r 
    join 
    (select id LOC_ID  FRom countries
        where unhcr_country_code in 
        ('ABW'
        ,'ANT'
        ,'ARG'
        ,'AUL'
        ,'BAH'
        ,'BAR'
        ,'BEL'
        ,'BES'
        ,'BHS'
        ,'BOL'
        ,'BRU'
        ,'BUL'
        ,'BVI'
        ,'BZE'
        ,'CAY'
        ,'CHL'
        ,'CUB'
        ,'CUW'
        ,'CZE'
        ,'DEN'
        ,'DMA'
        ,'EST'
        ,'FIJ'
        ,'FIN'
        ,'FSM'
        ,'GRN'
        ,'GUA'
        ,'GUY'
        ,'HKG'
        ,'HON'
        ,'HUN'
        ,'ICE'
        ,'JAM'
        ,'KOS'
        ,'KUW'
        ,'LAO'
        ,'LCA'
        ,'LES'
        ,'LIE'
        ,'LTU'
        ,'LUX'
        ,'LVA'
        ,'MAD'
        ,'MCO'
        ,'MSR'
        ,'NET'
        ,'NIC'
        ,'NOR'
        ,'NRU'
        ,'NZL'
        ,'OMN'
        ,'PAR'
        ,'PER'
        ,'PLW'
        ,'POL'
        ,'QAT'
        ,'ROM'
        ,'SAL'
        ,'SAU'
        ,'SIN'
        ,'SOL'
        ,'STK'
        ,'SUR'
        ,'SVK'
        ,'SVN'
        ,'SWA'
        ,'SWE'
        ,'SWI'
        ,'SXM'
        ,'TCI'
        ,'TON'
        ,'TRT'
        ,'URU'
        ,'VAN'
        ,'VCT'
		,'RSA'
        )
     ) on 1=1
    )
  loop
    nCount := nCount + 1;
    P_ROLE.INSERT_ROLE_COUNTRY(rRLC.ROL_ID, rRLC.LOC_ID);
  end loop;
--
  dbms_output.put_line(to_char(nCount) || ' ROLE_COUNTRIES records inserted');
end;
/

show errors
