@dropall
@drop

spool RebuildPSQ.log

purge recyclebin;

@@Build/PSQ/PSQSynonyms &1

spool off
