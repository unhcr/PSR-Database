create user STAGE identified by STAGE quota unlimited on USERS;
grant STANDARD_USER to STAGE;
grant PSR_STAGE to STAGE;

create user PSR1 identified by PSR1 quota unlimited on USERS;
grant STANDARD_USER to PSR1;
grant PSR_STAGE to PSR1;
grant create any context to PSR1;

create user PSR2 identified by PSR2 quota unlimited on USERS;
grant STANDARD_USER to PSR2;
grant PSR_STAGE to PSR2;
grant create any context to PSR2;

create user PSQ identified by PSQ quota unlimited on USERS;
grant PSR_PUBLIC_QUERY to PSQ;
