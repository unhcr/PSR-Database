create or replace view PF_EXTRACT_POC
as
SELECT
          PF_YEAR,
          c.NAME "Country of Asylum",
          ppg.PPG_CODE,
          ppg.DESCRIPTION PPG,
          orig.NAME Origin,
          DST_DESCRIPTION,
          DST_CODE,
          nvl(PFPOCPY_VALUE, PFPOCPY_AH_VALUE) "2013 Total",
          PFPOCPY_AH_VALUE "2013 Assisted",
          nvl(PFPOCCY_VALUE,PFPOCCY_AH_VALUE) "2014 Total",
          PFPOCCY_AH_VALUE "2014 Assisted",
          nvl(PFPOCNY_VALUE,PFPOCNY_AH_VALUE) "2015 Total",
          PFPOCNY_AH_VALUE "2015 Assisted"
          FROM PF_PFPOC poc
          join locations c on poc.LOC_ID_ASYLUM_COUNTRY = c.id
          left outer join POPULATION_PLANNING_GROUPS ppg on poc.PPG_ID = ppg.ID
          left outer join locations orig on poc.LOC_ID_ORIGIN_COUNTRY = orig.ID;

grant select on PF_EXTRACT_POC to PSR_PF_DATA_ENTRY;
-- recreate PSRAPP synonyms