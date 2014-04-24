CREATE OR REPLACE VIEW PF_COUNTRY_INFO AS
select * from 
(
select sg.id stg_id
     , EXTRACT(YEAR FROM sg.start_date) PF_YEAR
     , sg.loc_id_asylum_country
     , sga.STGAT_CODE
     , sga.CHAR_VALUE
     , sga.VERSION_NBR
  from T_STATISTIC_GROUPS sg
  join T_STC_GROUP_ATTRIBUTES sga on sg.id = sga.stg_id
where sg.sttg_code = 'PF'
)
 pivot
   ( max(CHAR_VALUE) , max(VERSION_NBR)  as VER_NBR
    for STGAT_CODE
    in ('PFSTATUS' as STATUS, 'FPTNAME' as FPTNAME, 'FPTMAIL' as FPTMAIL)
)
;

grant select on PF_COUNTRY_INFO to PSR_PF_DATA_ENTRY;

