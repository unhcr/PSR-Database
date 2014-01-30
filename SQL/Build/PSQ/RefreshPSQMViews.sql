drop index IX_POCD_YEAR;
drop index IX_POCD_COU_RES;
drop index IX_POCD_COU_OGN;
drop index IX_POCD_PTC;

execute dbms_mview.refresh('PSQ_POC_DETAILS_DATA');

create index IX_POCD_YEAR on PSQ_POC_DETAILS_DATA (ASR_YEAR);
create index IX_POCD_COU_RES on PSQ_POC_DETAILS_DATA (COU_CODE_RESIDENCE);
create index IX_POCD_COU_OGN on PSQ_POC_DETAILS_DATA (COU_CODE_ORIGIN);
create index IX_POCD_PTC on PSQ_POC_DETAILS_DATA (POP_TYPE_CODE);

execute dbms_mview.refresh('PSQ_POC_COUNTRIES');

execute dbms_mview.refresh('PSQ_POC_ORIGINS');

execute dbms_mview.refresh('PSQ_POC_YEARS');

drop index IX_POCS_YEAR;
drop index IX_POCS_COU_RES;
drop index IX_POCS_COU_OGN;

execute dbms_mview.refresh('PSQ_POC_SUMMARY_DATA');

create index IX_POCS_YEAR on PSQ_POC_SUMMARY_DATA (ASR_YEAR);
create index IX_POCS_COU_RES on PSQ_POC_SUMMARY_DATA (COU_CODE_RESIDENCE);
create index IX_POCS_COU_OGN on PSQ_POC_SUMMARY_DATA (COU_CODE_ORIGIN);

drop index IX_DEM_YEAR;
drop index IX_DEM_COU_RES;
drop index IX_DEM_COU_OGN;
drop index IX_DEM_DST;

execute dbms_mview.refresh('PSQ_DEMOGRAPHICS_DATA');

create index IX_DEM_YEAR on PSQ_DEMOGRAPHICS_DATA (ASR_YEAR);
create index IX_DEM_COU_RES on PSQ_DEMOGRAPHICS_DATA (COU_CODE_RESIDENCE);
create index IX_DEM_COU_OGN on PSQ_DEMOGRAPHICS_DATA (COU_CODE_ORIGIN);
create index IX_DEM_DST on PSQ_DEMOGRAPHICS_DATA (DST_CODE);

drop index IX_DEME_YEAR;
drop index IX_DEME_COU_RES;
drop index IX_DEME_COU_OGN;
drop index IX_DEME_DST;

execute dbms_mview.refresh('PSQ_DEMOGRAPHICS_COUNTRIES');

execute dbms_mview.refresh('PSQ_DEMOGRAPHICS_ORIGINS');

execute dbms_mview.refresh('PSQ_DEMOGRAPHICS_YEARS');

execute P_CONTEXT.SET_USERID('PUBLIC_ENGLISH');
execute dbms_mview.refresh('PSQ_DEMOGRAPHICS_EN');

create index IX_DEME_YEAR on PSQ_DEMOGRAPHICS_EN (ASR_YEAR);
create index IX_DEME_COU_RES on PSQ_DEMOGRAPHICS_EN (COU_CODE_RESIDENCE);
create index IX_DEME_COU_OGN on PSQ_DEMOGRAPHICS_EN (COU_CODE_ORIGIN);
create index IX_DEME_DST on PSQ_DEMOGRAPHICS_EN (DST_CODE);

drop index IX_DEMF_YEAR;
drop index IX_DEMF_COU_RES;
drop index IX_DEMF_COU_OGN;
drop index IX_DEMF_DST;

execute P_CONTEXT.SET_USERID('PUBLIC_FRENCH');
execute dbms_mview.refresh('PSQ_DEMOGRAPHICS_FR');

create index IX_DEMF_YEAR on PSQ_DEMOGRAPHICS_FR (ASR_YEAR);
create index IX_DEMF_COU_RES on PSQ_DEMOGRAPHICS_FR (COU_CODE_RESIDENCE);
create index IX_DEMF_COU_OGN on PSQ_DEMOGRAPHICS_FR (COU_CODE_ORIGIN);
create index IX_DEMF_DST on PSQ_DEMOGRAPHICS_FR (DST_CODE);

drop index IX_RSD_YEAR;
drop index IX_RSD_COU_ASY;
drop index IX_RSD_COU_OGN;

execute dbms_mview.refresh('PSQ_RSD_DATA');

create index IX_RSD_YEAR on PSQ_RSD_DATA (ASR_YEAR);
create index IX_RSD_COU_ASY on PSQ_RSD_DATA (COU_CODE_ASYLUM);
create index IX_RSD_COU_OGN on PSQ_RSD_DATA (COU_CODE_ORIGIN);

execute dbms_mview.refresh('PSQ_RSD_COUNTRIES');

execute dbms_mview.refresh('PSQ_RSD_ORIGINS');

execute dbms_mview.refresh('PSQ_RSD_YEARS');

drop index IX_RSDE_YEAR;
drop index IX_RSDE_COU_ASY;
drop index IX_RSDE_COU_OGN;

execute P_CONTEXT.SET_USERID('PUBLIC_ENGLISH');
execute dbms_mview.refresh('PSQ_RSD_EN');

create index IX_RSDE_YEAR on PSQ_RSD_EN (ASR_YEAR);
create index IX_RSDE_COU_ASY on PSQ_RSD_EN (COU_CODE_ASYLUM);
create index IX_RSDE_COU_OGN on PSQ_RSD_EN (COU_CODE_ORIGIN);

drop index IX_RSDF_YEAR;
drop index IX_RSDF_COU_ASY;
drop index IX_RSDF_COU_OGN;

execute P_CONTEXT.SET_USERID('PUBLIC_FRENCH');
execute dbms_mview.refresh('PSQ_RSD_FR');

create index IX_RSDF_YEAR on PSQ_RSD_FR (ASR_YEAR);
create index IX_RSDF_COU_ASY on PSQ_RSD_FR (COU_CODE_ASYLUM);
create index IX_RSDF_COU_OGN on PSQ_RSD_FR (COU_CODE_ORIGIN);