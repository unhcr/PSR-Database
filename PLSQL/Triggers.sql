create or replace trigger TR_DIP_RBU_AUDIT
before update on T_DATA_ITEM_PERMISSIONS
for each row
begin
  :new.UPDATE_TIMESTAMP := systimestamp;
  :new.UPDATE_USERID := nvl(sys_context('PSR', 'USERID'), '*' || user);
end TR_DIP_RBU_AUDIT;
/


create or replace trigger TR_LOC_RBU_AUDIT
before update on T_LOCATIONS
for each row
begin
  :new.UPDATE_TIMESTAMP := systimestamp;
  :new.UPDATE_USERID := nvl(sys_context('PSR', 'USERID'), '*' || user);
end TR_LOC_RBU_AUDIT;
/


create or replace trigger TR_LOCA_RBU_AUDIT
before update on T_LOCATION_ATTRIBUTES
for each row
begin
  :new.UPDATE_TIMESTAMP := systimestamp;
  :new.UPDATE_USERID := nvl(sys_context('PSR', 'USERID'), '*' || user);
end TR_LOCA_RBU_AUDIT;
/


create or replace trigger TR_LOCR_RBU_AUDIT
before update on T_LOCATION_RELATIONSHIPS
for each row
begin
  :new.UPDATE_TIMESTAMP := systimestamp;
  :new.UPDATE_USERID := nvl(sys_context('PSR', 'USERID'), '*' || user);
end TR_LOCR_RBU_AUDIT;
/


create or replace trigger TR_STG_RBU_AUDIT
before update on T_STATISTIC_GROUPS
for each row
begin
  :new.UPDATE_TIMESTAMP := systimestamp;
  :new.UPDATE_USERID := nvl(sys_context('PSR', 'USERID'), '*' || user);
end TR_STG_RBU_AUDIT;
/


create or replace trigger TR_ROL_RBU_AUDIT
before update on T_ROLES
for each row
begin
  :new.UPDATE_TIMESTAMP := systimestamp;
  :new.UPDATE_USERID := nvl(sys_context('PSR', 'USERID'), '*' || user);
end TR_ROL_RBU_AUDIT;
/


create or replace trigger TR_PIR_RBU_AUDIT
before update on T_PERMISSIONS_IN_ROLES
for each row
begin
  :new.UPDATE_TIMESTAMP := systimestamp;
  :new.UPDATE_USERID := nvl(sys_context('PSR', 'USERID'), '*' || user);
end TR_PIR_RBU_AUDIT;
/


create or replace trigger TR_PRM_RBU_AUDIT
before update on T_PERMISSIONS
for each row
begin
  :new.UPDATE_TIMESTAMP := systimestamp;
  :new.UPDATE_USERID := nvl(sys_context('PSR', 'USERID'), '*' || user);
end TR_PRM_RBU_AUDIT;
/


create or replace trigger TR_STC_RBU_AUDIT
before update on T_STATISTICS
for each row
begin
  :new.UPDATE_TIMESTAMP := systimestamp;
  :new.UPDATE_USERID := nvl(sys_context('PSR', 'USERID'), '*' || user);
end TR_STC_RBU_AUDIT;
/


create or replace trigger TR_UIR_RBU_AUDIT
before update on T_USERS_IN_ROLES
for each row
begin
  :new.UPDATE_TIMESTAMP := systimestamp;
  :new.UPDATE_USERID := nvl(sys_context('PSR', 'USERID'), '*' || user);
end TR_UIR_RBU_AUDIT;
/


create or replace trigger TR_USR_RBU_AUDIT
before update on T_SYSTEM_USERS
for each row
begin
  :new.UPDATE_TIMESTAMP := systimestamp;
  :new.UPDATE_USERID := nvl(sys_context('PSR', 'USERID'), '*' || user);
end TR_USR_RBU_AUDIT;
/


create or replace trigger TR_TXT_RBU_AUDIT
before update on T_TEXT_ITEMS
for each row
begin
  :new.UPDATE_TIMESTAMP := systimestamp;
  :new.UPDATE_USERID := nvl(sys_context('PSR', 'USERID'), '*' || user);
end TR_TXT_RBU_AUDIT;
/


create or replace trigger TR_UAT_RBU_AUDIT
before update on T_USER_ATTRIBUTES
for each row
begin
  :new.UPDATE_TIMESTAMP := systimestamp;
  :new.UPDATE_USERID := nvl(sys_context('PSR', 'USERID'), '*' || user);
end TR_UAT_RBU_AUDIT;
/


create or replace trigger TR_ULP_RBU_AUDIT
before update on T_USER_LANGUAGE_PREFERENCES
for each row
begin
  :new.UPDATE_TIMESTAMP := systimestamp;
  :new.UPDATE_USERID := nvl(sys_context('PSR', 'USERID'), '*' || user);
end TR_ULP_RBU_AUDIT;
/
