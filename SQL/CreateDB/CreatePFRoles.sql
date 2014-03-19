create role PSR_PF_DATA_ENTRY;
grant CONNECT to PSR_PF_DATA_ENTRY;
grant create synonym to PSR_PF_DATA_ENTRY;

create role PSR_INTERNAL_API;
grant CONNECT to PSR_INTERNAL_API;
grant create synonym to PSR_INTERNAL_API;


-- interface with Global Focus Datawarehouse (FOCUS_BI)
create user BI identified by BI;
grant PSR_INTERNAL_API to BI;

create user PSRAPP identified by PSRAPP;
grant PSR_ASR_DATA_ENTRY to PSRAPP;
grant PSR_PF_DATA_ENTRY to PSRAPP;
