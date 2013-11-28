drop index IX_POCSE_YEAR;
drop index IX_POCSE_COU_RES;
drop index IX_POCSE_COU_OGN;

execute dbms_mview.refresh('ASR_POC_SUMMARY_EN');

create index IX_POCSE_YEAR on ASR_POC_SUMMARY_EN (ASR_YEAR);
create index IX_POCSE_COU_RES on ASR_POC_SUMMARY_EN (COU_CODE_RESIDENCE);
create index IX_POCSE_COU_OGN on ASR_POC_SUMMARY_EN (COU_CODE_ORIGIN);

drop index IX_POCDE_YEAR;
drop index IX_POCDE_COU_RES;
drop index IX_POCDE_COU_OGN;
drop index IX_POCDE_COU_PTC;

execute dbms_mview.refresh('ASR_POC_DETAILS_EN');

create index IX_POCDE_YEAR on ASR_POC_DETAILS_EN (ASR_YEAR);
create index IX_POCDE_COU_RES on ASR_POC_DETAILS_EN (COU_CODE_RESIDENCE);
create index IX_POCDE_COU_OGN on ASR_POC_DETAILS_EN (COU_CODE_ORIGIN);
create index IX_POCDE_COU_PTC on ASR_POC_DETAILS_EN (POPULATION_TYPE_CODE);

drop index IX_DEME_YEAR;
drop index IX_DEME_COU_RES;
--drop index IX_DEME_COU_OGN;

execute dbms_mview.refresh('ASR_DEMOGRAPHICS_EN');

create index IX_DEME_YEAR on ASR_DEMOGRAPHICS_EN (ASR_YEAR);
create index IX_DEME_COU_RES on ASR_DEMOGRAPHICS_EN (COU_CODE_RESIDENCE);
--create index IX_DEME_COU_OGN on ASR_DEMOGRAPHICS_EN (COU_CODE_ORIGIN);

drop index IX_RSDE_YEAR;
drop index IX_RSDE_COU_ASY;
drop index IX_RSDE_COU_OGN;

execute dbms_mview.refresh('ASR_RSD_EN');

create index IX_RSDE_YEAR on ASR_RSD_EN (ASR_YEAR);
create index IX_RSDE_COU_ASY on ASR_RSD_EN (COU_CODE_ASYLUM);
create index IX_RSDE_COU_OGN on ASR_RSD_EN (COU_CODE_ORIGIN);