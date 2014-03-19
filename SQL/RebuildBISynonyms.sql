@@dropall
@drop

spool RebuildSynonyms.log

purge recyclebin;

begin
  for rSYN in
   (select replace(TABLE_NAME, 'BI_', 'PSR_') EXT_NAME, TABLE_NAME
    from ALL_TAB_PRIVS
    where TABLE_SCHEMA = '&1'
    )
  loop
    execute immediate 'create synonym ' || rSYN.EXT_NAME || ' for &1..' || rSYN.TABLE_NAME;
  end loop;
end;
/

spool off





