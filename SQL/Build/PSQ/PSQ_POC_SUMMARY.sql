--
-- V_PSQ_POC_SUMMARY_DATA
--
create or replace view V_PSQ_POC_SUMMARY_DATA as
select ASR_YEAR,
  ITM_ID_RESIDENCE, COU_CODE_RESIDENCE, ISO3166_ALPHA3_CODE_RESIDENCE,
  ITM_ID_ORIGIN, COU_CODE_ORIGIN, ISO3166_ALPHA3_CODE_ORIGIN,
  RF_VALUE, RF_REDACTED_FLAG, RFA_VALUE, RFA_REDACTED_FLAG,
  RL_VALUE, RL_REDACTED_FLAG, RLA_VALUE, RLA_REDACTED_FLAG,
  AS_VALUE, AS_REDACTED_FLAG, ASA_VALUE, ASA_REDACTED_FLAG,
  RT_VALUE, RT_REDACTED_FLAG, RTA_VALUE, RTA_REDACTED_FLAG,
  ID_VALUE, ID_REDACTED_FLAG, IDA_VALUE, IDA_REDACTED_FLAG,
  IL_VALUE, IL_REDACTED_FLAG, ILA_VALUE, ILA_REDACTED_FLAG,
  RD_VALUE, RD_REDACTED_FLAG, RDA_VALUE, RDA_REDACTED_FLAG,
  ST_VALUE, ST_REDACTED_FLAG, STA_VALUE, STA_REDACTED_FLAG,
  OC_VALUE, OC_REDACTED_FLAG, OCA_VALUE, OCA_REDACTED_FLAG
from PSQ_POC_DETAILS_DATA
pivot
 (sum(VALUE) as VALUE, max(REDACTED_FLAG) as REDACTED_FLAG
  for POP_TYPE_CODE
  in ('RF' as RF, 'RFA' as RFA,
      'RL' as RL, 'RLA' as RLA,
      'AS' as "AS", 'ASA' as ASA,
      'RT' as RT, 'RTA' as RTA,
      'ID' as ID, 'IDA' as IDA,
      'IL' as IL, 'ILA' as ILA,
      'RD' as RD, 'RDA' as RDA,
      'ST' as ST, 'STA' as STA,
      'OC' as OC, 'OCA' as OCA));

--
-- PSQ_POC_SUMMARY_DATA
--
create materialized view PSQ_POC_SUMMARY_DATA as
select ASR_YEAR,
  ITM_ID_RESIDENCE, COU_CODE_RESIDENCE, ISO3166_ALPHA3_CODE_RESIDENCE,
  ITM_ID_ORIGIN, COU_CODE_ORIGIN, ISO3166_ALPHA3_CODE_ORIGIN,
  RF_VALUE, RF_REDACTED_FLAG, RFA_VALUE, RFA_REDACTED_FLAG,
  RL_VALUE, RL_REDACTED_FLAG, RLA_VALUE, RLA_REDACTED_FLAG,
  AS_VALUE, AS_REDACTED_FLAG, ASA_VALUE, ASA_REDACTED_FLAG,
  RT_VALUE, RT_REDACTED_FLAG, RTA_VALUE, RTA_REDACTED_FLAG,
  ID_VALUE, ID_REDACTED_FLAG, IDA_VALUE, IDA_REDACTED_FLAG,
  IL_VALUE, IL_REDACTED_FLAG, ILA_VALUE, ILA_REDACTED_FLAG,
  RD_VALUE, RD_REDACTED_FLAG, RDA_VALUE, RDA_REDACTED_FLAG,
  ST_VALUE, ST_REDACTED_FLAG, STA_VALUE, STA_REDACTED_FLAG,
  OC_VALUE, OC_REDACTED_FLAG, OCA_VALUE, OCA_REDACTED_FLAG
from V_PSQ_POC_SUMMARY_DATA;

create index IX_POCS_YEAR on PSQ_POC_SUMMARY_DATA (ASR_YEAR);
create index IX_POCS_COU_RES on PSQ_POC_SUMMARY_DATA (COU_CODE_RESIDENCE);
create index IX_POCS_COU_OGN on PSQ_POC_SUMMARY_DATA (COU_CODE_ORIGIN);

--
-- PSQ_POC_SUMMARY
--
create or replace view PSQ_POC_SUMMARY as
select SUM.ASR_YEAR,
  SUM.COU_CODE_RESIDENCE, SUM.ISO3166_ALPHA3_CODE_RESIDENCE,
  NAM1.NAME as COU_NAME_RESIDENCE,
  SUM.COU_CODE_ORIGIN, SUM.ISO3166_ALPHA3_CODE_ORIGIN,
  nvl(TXT.TEXT, NAM2.NAME) as COU_NAME_ORIGIN,
  SUM.RF_VALUE, SUM.RF_REDACTED_FLAG, SUM.RFA_VALUE, SUM.RFA_REDACTED_FLAG,
  SUM.RL_VALUE, SUM.RL_REDACTED_FLAG, SUM.RLA_VALUE, SUM.RLA_REDACTED_FLAG,
  SUM.AS_VALUE, SUM.AS_REDACTED_FLAG, SUM.ASA_VALUE, SUM.ASA_REDACTED_FLAG,
  SUM.RT_VALUE, SUM.RT_REDACTED_FLAG, SUM.RTA_VALUE, SUM.RTA_REDACTED_FLAG,
  SUM.ID_VALUE, SUM.ID_REDACTED_FLAG, SUM.IDA_VALUE, SUM.IDA_REDACTED_FLAG,
  SUM.IL_VALUE, SUM.IL_REDACTED_FLAG, SUM.ILA_VALUE, SUM.ILA_REDACTED_FLAG,
  SUM.RD_VALUE, SUM.RD_REDACTED_FLAG, SUM.RDA_VALUE, SUM.RDA_REDACTED_FLAG,
  SUM.ST_VALUE, SUM.ST_REDACTED_FLAG, SUM.STA_VALUE, SUM.STA_REDACTED_FLAG,
  SUM.OC_VALUE, SUM.OC_REDACTED_FLAG, SUM.OCA_VALUE, SUM.OCA_REDACTED_FLAG
from PSQ_POC_SUMMARY_DATA SUM
left outer join NAMES NAM1
  on NAM1.ITM_ID = SUM.ITM_ID_RESIDENCE
left outer join NAMES NAM2
  on NAM2.ITM_ID = SUM.ITM_ID_ORIGIN
left outer join T_TEXT_ITEMS TXT
  on TXT.ITM_ID = SUM.ITM_ID_ORIGIN
  and TXT.TXTT_CODE = 'ORIGINNAME'
  and TXT.SEQ_NBR = 1
  and TXT.LANG_CODE = NAM2.LANG_CODE;