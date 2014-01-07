create or replace directory PSRDATA as '/n01/RASRPRD/staging';
grant read, write on directory PSRDATA to PSR_STAGE;

create or replace directory PSRLOG as '/n01/RASRPRD/staging/log';
grant read, write on directory PSRLOG to PSR_STAGE;

create or replace directory PSRARCHIVE as '/n01/RASRPRD/staging/log';
grant read, write on directory PSRARCHIVE to PSR_STAGE;
