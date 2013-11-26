@@PreserveLocationIds

@dropall
@drop

spool Rebuild.log

purge recyclebin;

@@BuildInfrastructure

@@LoadData

--prompt InitTests
--prompt =========
--@InitTests

commit;

--execute dbms_stats.gather_schema_stats(user);

spool off
