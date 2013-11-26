@dropall
@drop

spool RebuildPSQ.log

purge recyclebin;

@@PSQSynonyms &1

spool off
