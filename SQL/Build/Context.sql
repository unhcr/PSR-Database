begin
  for rCTX in
   (select 'create or replace context ' || user || ' using P_CONTEXT' as STATEMENT
    from DUAL)
  loop
    execute immediate rCTX.STATEMENT;
  end loop;
end;
/
