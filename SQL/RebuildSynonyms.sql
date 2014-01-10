@@dropall
@drop

spool RebuildSynonyms.log

purge recyclebin;

begin
  for rSYN in
   (select distinct TABLE_NAME
    from ALL_TAB_PRIVS
    where TABLE_SCHEMA = '&1'
    order by TABLE_NAME)
  loop
    execute immediate 'create synonym ' || rSYN.TABLE_NAME || ' for &1..' || rSYN.TABLE_NAME;
  end loop;
end;
/

spool off
