declare
  sNEXTVAL varchar2(10);
begin
  select to_char(NEXTVAL) into sNEXTVAL from S_LOC_SEQ;
  execute immediate 'drop sequence LOC_SEQ';
  execute immediate 'create sequence LOC_SEQ start with ' || sNEXTVAL || ' maxvalue 99999999';
exception
  when NO_DATA_FOUND
  then null;
end;
/
