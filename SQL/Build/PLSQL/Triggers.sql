column CONTEXT_NAME new_value ContextName

select user as CONTEXT_NAME
from DUAL;

create or replace trigger TR_DIP_RBU_AUDIT
before update on T_DATA_ITEM_PERMISSIONS
for each row
begin
  :new.UPDATE_TIMESTAMP := systimestamp;
  :new.UPDATE_USERID := nvl(sys_context('&ContextName', 'USERID'), '*' || user);
end TR_DIP_RBU_AUDIT;
/


create or replace trigger TR_LOC_RBU_AUDIT
before update on T_LOCATIONS
for each row
begin
  :new.UPDATE_TIMESTAMP := systimestamp;
  :new.UPDATE_USERID := nvl(sys_context('&ContextName', 'USERID'), '*' || user);
end TR_LOC_RBU_AUDIT;
/


create or replace trigger TR_LOCA_RBU_AUDIT
before update on T_LOCATION_ATTRIBUTES
for each row
begin
  :new.UPDATE_TIMESTAMP := systimestamp;
  :new.UPDATE_USERID := nvl(sys_context('&ContextName', 'USERID'), '*' || user);
end TR_LOCA_RBU_AUDIT;
/


create or replace trigger TR_LOCR_RBU_AUDIT
before update on T_LOCATION_RELATIONSHIPS
for each row
begin
  :new.UPDATE_TIMESTAMP := systimestamp;
  :new.UPDATE_USERID := nvl(sys_context('&ContextName', 'USERID'), '*' || user);
end TR_LOCR_RBU_AUDIT;
/


create or replace trigger TR_STG_RBU_AUDIT
before update or delete on T_STATISTIC_GROUPS
for each row
DECLARE tmstamp timestamp;
        usr     VARCHAR2(31);
begin
  tmstamp := systimestamp;
  usr     := nvl(sys_context('&ContextName', 'USERID'), '*' || user);
  if UPDATING THEN
	:new.UPDATE_TIMESTAMP := tmstamp;
	:new.UPDATE_USERID := usr;
  end if;
  --  
  insert into T_STATISTIC_GROUPS_AUDIT
   ( 
     ID, 
     START_DATE, 
     END_DATE, 
     STTG_CODE, 
     DST_ID, 
     LOC_ID_ASYLUM_COUNTRY, 
     LOC_ID_ASYLUM, 
     LOC_ID_ORIGIN_COUNTRY, 
     LOC_ID_ORIGIN, 
     DIM_ID1, 
     DIM_ID2, 
     DIM_ID3, 
     DIM_ID4, 
     DIM_ID5, 
     SEX_CODE, 
     AGR_ID, 
     SEQ_NBR, 
     PPG_ID, 
     ITM_ID, 
     UPDATE_TIMESTAMP, 
     UPDATE_USERID, 
     VERSION_NBR,
     END_TIMESTAMP  
    ) 
    select 
     :old.ID, 
     :old.START_DATE, 
     :old.END_DATE, 
     :old.STTG_CODE, 
     :old.DST_ID, 
     :old.LOC_ID_ASYLUM_COUNTRY, 
     :old.LOC_ID_ASYLUM, 
     :old.LOC_ID_ORIGIN_COUNTRY, 
     :old.LOC_ID_ORIGIN, 
     :old.DIM_ID1, 
     :old.DIM_ID2, 
     :old.DIM_ID3, 
     :old.DIM_ID4, 
     :old.DIM_ID5, 
     :old.SEX_CODE, 
     :old.AGR_ID, 
     :old.SEQ_NBR, 
     :old.PPG_ID, 
     :old.ITM_ID, 
     :old.UPDATE_TIMESTAMP, 
     :old.UPDATE_USERID, 
     :old.VERSION_NBR,
     tmstamp
     from dual;
--
  if DELETING THEN
     -- traces the user deleting the row
     insert into T_STATISTIC_GROUPS_AUDIT
       ( 
         ID, 
         UPDATE_TIMESTAMP, 
         UPDATE_USERID, 
         VERSION_NBR,
         END_TIMESTAMP  
        ) 
     select 
        :old.ID, 
        tmstamp,
        usr,
        :old.VERSION_NBR,
        tmstamp
     from dual;
  end if;
--
end TR_STG_RBU_AUDIT;
/


create or replace trigger TR_RLC_RBU_AUDIT
before update on T_ROLE_COUNTRIES
for each row
begin
  :new.UPDATE_TIMESTAMP := systimestamp;
  :new.UPDATE_USERID := nvl(sys_context('&ContextName', 'USERID'), '*' || user);
end TR_RLC_RBU_AUDIT;
/


create or replace trigger TR_ROL_RBU_AUDIT
before update on T_ROLES
for each row
begin
  :new.UPDATE_TIMESTAMP := systimestamp;
  :new.UPDATE_USERID := nvl(sys_context('&ContextName', 'USERID'), '*' || user);
end TR_ROL_RBU_AUDIT;
/


create or replace trigger TR_PIR_RBU_AUDIT
before update on T_PERMISSIONS_IN_ROLES
for each row
begin
  :new.UPDATE_TIMESTAMP := systimestamp;
  :new.UPDATE_USERID := nvl(sys_context('&ContextName', 'USERID'), '*' || user);
end TR_PIR_RBU_AUDIT;
/


create or replace trigger TR_PRM_RBU_AUDIT
before update on T_PERMISSIONS
for each row
begin
  :new.UPDATE_TIMESTAMP := systimestamp;
  :new.UPDATE_USERID := nvl(sys_context('&ContextName', 'USERID'), '*' || user);
end TR_PRM_RBU_AUDIT;
/


create or replace trigger TR_STC_RBU_AUDIT
before update or delete on T_STATISTICS
for each row
DECLARE tmstamp timestamp;
        usr     VARCHAR2(31);
begin
  tmstamp := systimestamp;
  usr     := nvl(sys_context('&ContextName', 'USERID'), '*' || user);
  if UPDATING THEN
	:new.UPDATE_TIMESTAMP := tmstamp;
	:new.UPDATE_USERID := usr;
  end if;
  --  
  insert into T_STATISTICS_AUDIT
   ( 
     ID, 
     START_DATE, 
     END_DATE, 
     STCT_CODE, 
     DST_ID, 
     LOC_ID_ASYLUM_COUNTRY, 
     LOC_ID_ASYLUM, 
     LOC_ID_ORIGIN_COUNTRY, 
     LOC_ID_ORIGIN, 
     DIM_ID1, 
     DIM_ID2, 
     DIM_ID3, 
     DIM_ID4, 
     DIM_ID5, 
     SEX_CODE, 
     AGR_ID, 
     STG_SEQ_NBR, 
     STG_ID_PRIMARY, 
     PPG_ID, 
     VALUE, 
     ITM_ID, 
     UPDATE_TIMESTAMP, 
     UPDATE_USERID, 
     VERSION_NBR,
     END_TIMESTAMP  
    ) 
    select 
     :old.ID, 
     :old.START_DATE, 
     :old.END_DATE, 
     :old.STCT_CODE, 
     :old.DST_ID, 
     :old.LOC_ID_ASYLUM_COUNTRY, 
     :old.LOC_ID_ASYLUM, 
     :old.LOC_ID_ORIGIN_COUNTRY, 
     :old.LOC_ID_ORIGIN, 
     :old.DIM_ID1, 
     :old.DIM_ID2, 
     :old.DIM_ID3, 
     :old.DIM_ID4, 
     :old.DIM_ID5, 
     :old.SEX_CODE, 
     :old.AGR_ID, 
     :old.STG_SEQ_NBR, 
     :old.STG_ID_PRIMARY, 
     :old.PPG_ID, 
     :old.VALUE, 
     :old.ITM_ID, 
     :old.UPDATE_TIMESTAMP, 
     :old.UPDATE_USERID, 
     :old.VERSION_NBR,
     tmstamp
     from dual;
--
  if DELETING THEN
     -- traces the user deleting the row
     insert into T_STATISTICS_AUDIT
       ( 
         ID, 
         UPDATE_TIMESTAMP, 
         UPDATE_USERID, 
         VERSION_NBR,
         END_TIMESTAMP  
        ) 
     select 
        :old.ID, 
        tmstamp,
        usr,
        :old.VERSION_NBR,
        tmstamp
     from dual;
  end if;
--
end TR_STC_RBU_AUDIT;
/


create or replace trigger TR_UIR_RBU_AUDIT
before update on T_USERS_IN_ROLES
for each row
begin
  :new.UPDATE_TIMESTAMP := systimestamp;
  :new.UPDATE_USERID := nvl(sys_context('&ContextName', 'USERID'), '*' || user);
end TR_UIR_RBU_AUDIT;
/


create or replace trigger TR_UIRC_RBU_AUDIT
before update on T_USERS_IN_ROLE_COUNTRIES
for each row
begin
  :new.UPDATE_TIMESTAMP := systimestamp;
  :new.UPDATE_USERID := nvl(sys_context('&ContextName', 'USERID'), '*' || user);
end TR_UIRC_RBU_AUDIT;
/


create or replace trigger TR_USR_RBU_AUDIT
before update on T_SYSTEM_USERS
for each row
begin
  :new.UPDATE_TIMESTAMP := systimestamp;
  :new.UPDATE_USERID := nvl(sys_context('&ContextName', 'USERID'), '*' || user);
end TR_USR_RBU_AUDIT;
/


create or replace trigger TR_TXT_RBU_AUDIT
before update on T_TEXT_ITEMS
for each row
begin
  :new.UPDATE_TIMESTAMP := systimestamp;
  :new.UPDATE_USERID := nvl(sys_context('&ContextName', 'USERID'), '*' || user);
end TR_TXT_RBU_AUDIT;
/


create or replace trigger TR_UAT_RBU_AUDIT
before update on T_USER_ATTRIBUTES
for each row
begin
  :new.UPDATE_TIMESTAMP := systimestamp;
  :new.UPDATE_USERID := nvl(sys_context('&ContextName', 'USERID'), '*' || user);
end TR_UAT_RBU_AUDIT;
/


create or replace trigger TR_ULP_RBU_AUDIT
before update on T_USER_LANGUAGE_PREFERENCES
for each row
begin
  :new.UPDATE_TIMESTAMP := systimestamp;
  :new.UPDATE_USERID := nvl(sys_context('&ContextName', 'USERID'), '*' || user);
end TR_ULP_RBU_AUDIT;
/
