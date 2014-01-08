set feedback off
set pagesize 0

column NL newline

spool drop.sql

prompt spool drop.log
prompt

select 'drop ' || lower(OBJECT_TYPE) || ' "' || OBJECT_NAME || '"' ||
    case when OBJECT_TYPE = 'TABLE' then ' cascade constraints purge;' else ';' end NL
from USER_OBJECTS
where OBJECT_TYPE in ('SYNONYM', 'PACKAGE', 'PROCEDURE', 'FUNCTION', 'VIEW', 'MATERIALIZED VIEW', 'SEQUENCE', 'CLUSTER')
or (OBJECT_TYPE = 'TABLE'
  and not exists
   (select null
    from USER_MVIEWS
    where MVIEW_NAME = OBJECT_NAME))
order by decode(OBJECT_TYPE,
                'SYNONYM', 1,
                'PACKAGE', 2,
                'PROCEDURE', 3,
                'FUNCTION', 4,
                'VIEW', 5,
                'MATERIALIZED VIEW', 6,
                'SEQUENCE', 7,
                'TABLE', 8,
                'CLUSTER', 9),
  OBJECT_NAME
/

prompt
prompt spool off

spool off

set feedback on
set pagesize 9999
