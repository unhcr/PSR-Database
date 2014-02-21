@@Build/PreserveLocationIds

@dropall
@drop

spool Rebuild.log

purge recyclebin;

@@BuildInfrastructure

@@LoadData

@@LoadPFData

@@FinaliseInfrastructure

commit;

--execute dbms_stats.gather_schema_stats(user);

spool off
