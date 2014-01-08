@dropall
@drop

spool RebuildInfrastructure.log

purge recyclebin;

@@BuildInfrastructure

@@FinaliseInfrastructure

commit;

spool off
