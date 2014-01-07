-- Test set-up
-- ===========

define eh = "exception when others then dbms_output.put_line(substr(sqlerrm, case when substr(sqlerrm, 12, 5) = 'ORA-2' then 12 else 1 end))"

set echo on serveroutput on feedback off recsepchar "." sqlprompt "        " sqlnumber off

column LONG_TEXT format A150
column CHAR_VALUE format A30

spool test_SYSTEM_USER.log

-- Set system users
-- ================

-- Success cases
-- -------------

execute SYSTEM_USER.SET_SYSTEM_USER('USER1', 'en', 'User 1'); &eh
execute SYSTEM_USER.SET_SYSTEM_USER('USER2', 'fr', unistr('Utilisateur 2 fran\00E7ais'), psLOCKED_FLAG => 'Y'); &eh
execute SYSTEM_USER.SET_SYSTEM_USER('USER3', 'en', 'User template', psTEMPLATE_FLAG => 'Y'); &eh
execute SYSTEM_USER.SET_SYSTEM_USER('USER4', 'en', 'Locked template', 'Y', 'Y'); &eh
execute SYSTEM_USER.SET_SYSTEM_USER('USER1', psLANG_CODE => 'en', psName => 'User 1b'); &eh
execute SYSTEM_USER.SET_SYSTEM_USER('USER3', null, null, 'Y'); &eh
execute SYSTEM_USER.SET_SYSTEM_USER('USER2', psTEMPLATE_FLAG => 'Y'); &eh

select USR.USERID, USR.LOCKED_FLAG, USR.TEMPLATE_FLAG, USR.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from SYSTEM_USERS USR
join TEXT_ITEMS TXI
  on TXI.TXT_ID = USR.TXT_ID
where USR.USERID like 'USER%'
order by USR.USERID, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Error cases
-- -----------

execute SYSTEM_USER.SET_SYSTEM_USER('USER5'); &eh
-- USR-0008: Name must be specified for new user

execute SYSTEM_USER.SET_SYSTEM_USER('USER5', 'en', ''); &eh
-- USR-0008: Name must be specified for new user

execute SYSTEM_USER.SET_SYSTEM_USER('USER5', 'xx', 'User 5'); &eh
-- USR-0010: Unknown name language

execute SYSTEM_USER.SET_SYSTEM_USER('USER4', 'xx', 'User 4'); &eh
-- USR-0010: Unknown name language

execute SYSTEM_USER.SET_SYSTEM_USER('USER5', 'la', 'User 5'); &eh
-- USR-0011: Inactive name language

execute SYSTEM_USER.SET_SYSTEM_USER('USER4', 'la', 'User 4'); &eh
-- USR-0011: Inactive name language

execute SYSTEM_USER.SET_SYSTEM_USER('USER5', 'en', 'User 5', 'X'); &eh
-- ORA-02290: check constraint (PSR.CH_USR_LOCKED_FLAG) violated

execute SYSTEM_USER.SET_SYSTEM_USER('USER4', 'en', 'User 4', 'X'); &eh
-- ORA-02290: check constraint (PSR.CH_USR_LOCKED_FLAG) violated

execute SYSTEM_USER.SET_SYSTEM_USER('USER5', 'en', 'User 5', psTEMPLATE_FLAG => 'X'); &eh
-- ORA-02290: check constraint (PSR.CH_USR_TEMPLATE_FLAG) violated

execute SYSTEM_USER.SET_SYSTEM_USER('USER4', 'en', 'User 4', psTEMPLATE_FLAG => 'X'); &eh
-- ORA-02290: check constraint (PSR.CH_USR_TEMPLATE_FLAG) violated

execute SYSTEM_USER.SET_SYSTEM_USER('USER5', 'en', 'User 5', 'YY'); &eh
-- ORA-12899: value too large for column "PSR"."SYSTEM_USERS"."LOCKED_FLAG" (actual: 2, maximum: 1)

execute SYSTEM_USER.SET_SYSTEM_USER('USER4', 'en', 'User 4', 'YY'); &eh
-- ORA-12899: value too large for column "PSR"."SYSTEM_USERS"."LOCKED_FLAG" (actual: 2, maximum: 1)

execute SYSTEM_USER.SET_SYSTEM_USER('USER5', 'en', 'User 5', psTEMPLATE_FLAG => 'YY'); &eh
-- ORA-12899: value too large for column "PSR"."SYSTEM_USERS"."TEMPLATE_FLAG" (actual: 2, maximum: 1)

execute SYSTEM_USER.SET_SYSTEM_USER('USER4', 'en', 'User 4', psTEMPLATE_FLAG => 'YY'); &eh
-- ORA-12899: value too large for column "PSR"."SYSTEM_USERS"."TEMPLATE_FLAG" (actual: 2, maximum: 1)

execute SYSTEM_USER.SET_SYSTEM_USER('USER5', null, 'User 5'); &eh
-- USR-0010: Unknown name language

execute SYSTEM_USER.SET_SYSTEM_USER('USER4', null, 'User 4'); &eh
-- USR-0010: Unknown name language

execute SYSTEM_USER.SET_SYSTEM_USER('USER5', 'xx', 'User 5'); &eh
-- USR-0010: Unknown name language

execute SYSTEM_USER.SET_SYSTEM_USER('USER4', 'xx', 'User 4'); &eh
-- USR-0010: Unknown name language

execute SYSTEM_USER.SET_SYSTEM_USER('USER5', 'la', 'User 5'); &eh
-- USR-0011: Inactive name language

execute SYSTEM_USER.SET_SYSTEM_USER('USER4', 'la', 'User 4'); &eh
-- USR-0011: Inactive name language

execute SYSTEM_USER.SET_SYSTEM_USER('USER5', 'en'); &eh
-- USR-0008: Name must be specified for new user

execute SYSTEM_USER.SET_SYSTEM_USER('USER4', 'en'); &eh
-- USR-0009: Name language cannot be specified without name

execute SYSTEM_USER.SET_SYSTEM_USER('USER4'); &eh
-- USR-0003: Nothing to be updated

execute SYSTEM_USER.SET_SYSTEM_USER('USER1', 'en', rpad('User 1a ', 1001, 'x')); &eh
-- ORA-12899: value too large for column "PSR"."TEXT_ITEMS"."TEXT" (actual: 1001, maximum: 1000)

-- Set system user names
-- =====================

-- Success cases
-- -------------

execute SYSTEM_USER.SET_USR_NAME('USER1', 'fr', unistr('Utilisateur 1 fran\00E7ais')); &eh
execute SYSTEM_USER.SET_USR_NAME('USER1', 'fr', unistr('Utilisateur 1 fran\00E7aise')); &eh

select USR.USERID, USR.LOCKED_FLAG, USR.TEMPLATE_FLAG, USR.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from SYSTEM_USERS USR
join TEXT_ITEMS TXI
  on TXI.TXT_ID = USR.TXT_ID
where USR.USERID like 'USER%'
order by USR.USERID, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Error cases
-- -----------

execute SYSTEM_USER.SET_USR_NAME('USER1', 'xx', 'User 1x'); &eh
-- TXT-0004: Unknown text language

execute SYSTEM_USER.SET_USR_NAME('USER1', 'la', 'Latin user 1'); &eh
-- TXT-0005: Inactive text language

execute SYSTEM_USER.SET_USR_NAME('XXX', 'en', 'User x'); &eh
-- ORA-01403: no data found

execute SYSTEM_USER.SET_USR_NAME('USER1', 'ru', ''); &eh
-- TXT-0001: Text must be specified

-- Remove system user names
-- ========================

-- Error cases
-- -----------

execute SYSTEM_USER.REMOVE_USR_NAME('XXX', 'fr'); &eh
-- ORA-01403: no data found

execute SYSTEM_USER.REMOVE_USR_NAME('USER2', 'fr'); &eh
-- TXT-0012: Cannot delete last mandatory text item

execute SYSTEM_USER.REMOVE_USR_NAME('USER2', 'en'); &eh
-- TXT-0011: No text to delete

-- Success cases
-- -------------

execute SYSTEM_USER.REMOVE_USR_NAME('USER1', 'fr'); &eh

select USR.USERID, USR.LOCKED_FLAG, USR.TEMPLATE_FLAG, USR.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from SYSTEM_USERS USR
join TEXT_ITEMS TXI
  on TXI.TXT_ID = USR.TXT_ID
where USR.USERID like 'USER%'
order by USR.USERID, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Set system user general text
-- ============================

-- Success cases
-- -------------

variable TXI_SEQ_NBR number
execute :TXI_SEQ_NBR := null; SYSTEM_USER.SET_USR_TEXT('USER1', 'NOTE', :TXI_SEQ_NBR, 'en', 'English note'); &eh
execute SYSTEM_USER.SET_USR_TEXT('USER1', 'NOTE', :TXI_SEQ_NBR, 'fr', 'French note'); &eh
execute :TXI_SEQ_NBR := null; SYSTEM_USER.SET_USR_TEXT('USER1', 'NOTE', :TXI_SEQ_NBR, 'es', 'New Spanish note'); &eh
execute :TXI_SEQ_NBR := 1; SYSTEM_USER.SET_USR_TEXT('USER1', 'NOTE', :TXI_SEQ_NBR, 'fr', 'Updated French note'); &eh
execute :TXI_SEQ_NBR := 2; SYSTEM_USER.SET_USR_TEXT('USER1', 'NOTE', :TXI_SEQ_NBR, 'es', rpad('Updated Spanish note ', 1001, unistr('\00F1'))); &eh

select USR.USERID, USR.LOCKED_FLAG, USR.TEMPLATE_FLAG, USR.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from SYSTEM_USERS USR
join TEXT_ITEMS TXI
  on TXI.TXT_ID = USR.TXT_ID
where USR.USERID like 'USER%'
order by USR.USERID, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Error cases
-- -----------

execute :TXI_SEQ_NBR := null; SYSTEM_USER.SET_USR_TEXT('USER1', 'NOTE', :TXI_SEQ_NBR, 'xx', 'Unknown note'); &eh
-- TXT-0004: Unknown text language

execute :TXI_SEQ_NBR := null; SYSTEM_USER.SET_USR_TEXT('USER1', 'NOTE', :TXI_SEQ_NBR, 'la', 'Latin note'); &eh
-- TXT-0005: Inactive text language

execute :TXI_SEQ_NBR := null; SYSTEM_USER.SET_USR_TEXT('XXX', 'NOTE', :TXI_SEQ_NBR, 'fr', 'French note'); &eh
-- ORA-01403: no data found

execute :TXI_SEQ_NBR := null; SYSTEM_USER.SET_USR_TEXT('USER1', 'XXXX', :TXI_SEQ_NBR, 'fr', 'French note'); &eh
-- TXT-0002: Unknown text type

execute :TXI_SEQ_NBR := null; SYSTEM_USER.SET_USR_TEXT('USER1', 'NAME', :TXI_SEQ_NBR, 'fr', 'French name'); &eh
-- TXT-0008: Only one text item of this type allowed

execute :TXI_SEQ_NBR := 1; SYSTEM_USER.SET_USR_TEXT('USER2', 'NOTE', :TXI_SEQ_NBR, 'fr', 'French note'); &eh
-- TXT-0009: No existing text of this type

execute :TXI_SEQ_NBR := 9; SYSTEM_USER.SET_USR_TEXT('USER1', 'NOTE', :TXI_SEQ_NBR, 'fr', 'French note'); &eh
-- TXT-0010: Text item sequence number greater than current maximum

execute :TXI_SEQ_NBR := null; SYSTEM_USER.SET_USR_TEXT('USER1', 'NOTE', :TXI_SEQ_NBR, 'en', ''); &eh
-- TXT-0001: Text must be specified

execute :TXI_SEQ_NBR := 1; SYSTEM_USER.SET_USR_TEXT('XXX', 'NOTE', :TXI_SEQ_NBR, 'fr', 'Updated note'); &eh
-- ORA-01403: no data found

execute :TXI_SEQ_NBR := 1; SYSTEM_USER.SET_USR_TEXT('USER1', 'XXXX', :TXI_SEQ_NBR, 'fr', 'Updated note'); &eh
-- TXT-0002: Unknown text type

execute :TXI_SEQ_NBR := 9; SYSTEM_USER.SET_USR_TEXT('USER1', 'NOTE', :TXI_SEQ_NBR, 'fr', 'Updated note'); &eh
-- TXT-0010: Text item sequence number greater than current maximum

execute :TXI_SEQ_NBR := 1; SYSTEM_USER.SET_USR_TEXT('USER1', 'NOTE', :TXI_SEQ_NBR, 'xx', 'Updated note'); &eh
-- TXT-0004: Unknown text language

execute :TXI_SEQ_NBR := 1; SYSTEM_USER.SET_USR_TEXT('USER1', 'NOTE', :TXI_SEQ_NBR, 'fr', ''); &eh
-- TXT-0001: Text must be specified

-- Remove system user general text
-- ===============================

-- Error cases
-- -----------

execute SYSTEM_USER.REMOVE_USR_TEXT('XXX', 'NOTE', 1, 'en'); &eh
-- ORA-01403: no data found

execute SYSTEM_USER.REMOVE_USR_TEXT('USER1', null); &eh
-- USR-0007: Text type must be specified

execute SYSTEM_USER.REMOVE_USR_TEXT('USER1', 'XXXX', 1, 'en'); &eh
-- ORA-01403: no data found

execute SYSTEM_USER.REMOVE_USR_TEXT('USER1', 'NOTE', 9, 'en'); &eh
-- TXT-0011: No text to delete

execute SYSTEM_USER.REMOVE_USR_TEXT('USER1', 'NOTE', 1, 'xx'); &eh
-- TXT-0011: No text to delete

execute SYSTEM_USER.REMOVE_USR_TEXT('USER2', 'NOTE'); &eh
-- TXT-0011: No text to delete

execute SYSTEM_USER.REMOVE_USR_TEXT('USER1', 'NAME'); &eh
-- TXT-0013: Cannot delete mandatory text type

execute SYSTEM_USER.REMOVE_USR_TEXT('USER1', 'NAME', 1); &eh
-- TXT-0012: Cannot delete last mandatory text item

execute SYSTEM_USER.REMOVE_USR_TEXT('USER2', 'NAME', 1, 'fr'); &eh
-- TXT-0012: Cannot delete last mandatory text item

-- Success cases
-- -------------

execute SYSTEM_USER.REMOVE_USR_TEXT('USER1', 'NOTE', 1, 'en'); &eh
execute SYSTEM_USER.REMOVE_USR_TEXT('USER1', 'NOTE', 1); &eh
execute SYSTEM_USER.REMOVE_USR_TEXT('USER1', 'NOTE'); &eh

select USR.USERID, USR.LOCKED_FLAG, USR.TEMPLATE_FLAG, USR.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from SYSTEM_USERS USR
join TEXT_ITEMS TXI
  on TXI.TXT_ID = USR.TXT_ID
where USR.USERID like 'USER%'
order by USR.USERID, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Set user attribute types
-- ========================

-- Success cases
-- -------------

execute SYSTEM_USER.SET_USER_ATTRIBUTE_TYPE('UATT1', 'N', 'en', 'Test 1'); &eh
execute SYSTEM_USER.SET_USER_ATTRIBUTE_TYPE('UATT2', 'N', 'en', 'Test 2', null, 'N'); &eh
execute SYSTEM_USER.SET_USER_ATTRIBUTE_TYPE('UATT3', 'D', 'en', 'Test 3', 1); &eh
execute SYSTEM_USER.SET_USER_ATTRIBUTE_TYPE('UATT4', 'C', 'en', 'Test 4', 999, 'N'); &eh
execute SYSTEM_USER.SET_USER_ATTRIBUTE_TYPE('UATT5', 'N', 'en', 'Test 5', pnDISPLAY_SEQ => 2); &eh
execute SYSTEM_USER.SET_USER_ATTRIBUTE_TYPE('UATT6', 'D', 'en', 'Test 6', psACTIVE_FLAG => 'N'); &eh
execute SYSTEM_USER.SET_USER_ATTRIBUTE_TYPE('UATT1', 'C'); &eh
execute SYSTEM_USER.SET_USER_ATTRIBUTE_TYPE('UATT1', null, 'en', 'Character attribute type'); &eh
execute SYSTEM_USER.SET_USER_ATTRIBUTE_TYPE('UATT1', null, null, null, 1); &eh
execute SYSTEM_USER.SET_USER_ATTRIBUTE_TYPE('UATT4', null, null, null, null, 'Y'); &eh
execute SYSTEM_USER.SET_USER_ATTRIBUTE_TYPE('UATT1', psLANG_CODE => 'fr', psDescription => 'Texte'); &eh
execute SYSTEM_USER.SET_USER_ATTRIBUTE_TYPE('UATT1', pnDISPLAY_SEQ => 2); &eh
execute SYSTEM_USER.SET_USER_ATTRIBUTE_TYPE('UATT1', psACTIVE_FLAG => 'Y'); &eh
execute SYSTEM_USER.SET_USER_ATTRIBUTE_TYPE('UATT1', pnDISPLAY_SEQ => null); &eh

select UATT.CODE, UATT.DATA_TYPE, UATT.DISPLAY_SEQ, UATT.ACTIVE_FLAG, UATT.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from USER_ATTRIBUTE_TYPES UATT
join TEXT_ITEMS TXI
  on TXI.TXT_ID = UATT.TXT_ID
where UATT.CODE like 'UATT%'
order by UATT.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Error cases
-- -----------

execute SYSTEM_USER.SET_USER_ATTRIBUTE('USER1', 'UATT1', 'Character attribute'); &eh
execute SYSTEM_USER.SET_USER_ATTRIBUTE_TYPE('UATT1', 'N'); &eh
-- USR-0017: Cannot update data type of user attribute type already in use
execute SYSTEM_USER.REMOVE_USER_ATTRIBUTE('USER1', 'UATT1'); &eh

execute SYSTEM_USER.SET_USER_ATTRIBUTE_TYPE('UATT7', psLANG_CODE => 'en', psDescription => 'Text'); &eh
-- ORA-01400: cannot insert NULL into ("PSR"."USER_ATTRIBUTE_TYPES"."DATA_TYPE")

execute SYSTEM_USER.SET_USER_ATTRIBUTE_TYPE('UATT7', 'C',  'en', ''); &eh
-- USR-0001: Description must be specified for new user attribute type

execute SYSTEM_USER.SET_USER_ATTRIBUTE_TYPE('UATT7', 'C',  'xx', 'Description'); &eh
-- USR-0004: Unknown description language

execute SYSTEM_USER.SET_USER_ATTRIBUTE_TYPE('UATT7', 'C',  'la', 'Description'); &eh
-- USR-0005: Inactive description language

execute SYSTEM_USER.SET_USER_ATTRIBUTE_TYPE('UATT7', 'C',  'en', 'Description', 1e6); &eh
-- ORA-01438: value larger than specified precision allowed for this column

execute SYSTEM_USER.SET_USER_ATTRIBUTE_TYPE('UATT7', 'C',  'en', 'Description', null, 'X'); &eh
-- ORA-02290: check constraint (PSR.CH_UATT_ACTIVE_FLAG) violated

execute SYSTEM_USER.SET_USER_ATTRIBUTE_TYPE('UATT1', 'X'); &eh
-- ORA-02290: check constraint (PSR.CH_UATT_DATA_TYPE) violated

execute SYSTEM_USER.SET_USER_ATTRIBUTE_TYPE('UATT1', 'CC'); &eh
-- ORA-12899: value too large for column "PSR"."USER_ATTRIBUTE_TYPES"."DATA_TYPE" (actual: 2, maximum: 1)

execute SYSTEM_USER.SET_USER_ATTRIBUTE_TYPE('UATT1', null,  'en'); &eh
-- USR-0002: Description language cannot be specified without description text

execute SYSTEM_USER.SET_USER_ATTRIBUTE_TYPE('UATT1', null, 'xx', 'Text'); &eh
-- USR-0004: Unknown description language

execute SYSTEM_USER.SET_USER_ATTRIBUTE_TYPE('UATT1', null, 'la', 'Text'); &eh
-- USR-0005: Inactive description language

execute SYSTEM_USER.SET_USER_ATTRIBUTE_TYPE('UATT1', null, null, 'Text'); &eh
-- USR-0004: Unknown description language

execute SYSTEM_USER.SET_USER_ATTRIBUTE_TYPE('UATT1'); &eh
-- USR-0003: Nothing to be updated

execute SYSTEM_USER.SET_USER_ATTRIBUTE_TYPE('UATT1', pnDISPLAY_SEQ => 1e6); &eh
-- ORA-01438: value larger than specified precision allowed for this column

execute SYSTEM_USER.SET_USER_ATTRIBUTE_TYPE('UATT1', psACTIVE_FLAG => 'X'); &eh
-- ORA-02290: check constraint (PSR.CH_UATT_ACTIVE_FLAG) violated

-- Set user attribute type descriptions
-- ====================================

-- Success cases
-- -------------

execute SYSTEM_USER.SET_UATT_DESCRIPTION('UATT1', 'es', 'Text'); &eh
execute SYSTEM_USER.SET_UATT_DESCRIPTION('UATT1', 'es', 'Texto'); &eh

select UATT.CODE, UATT.DATA_TYPE, UATT.DISPLAY_SEQ, UATT.ACTIVE_FLAG, UATT.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from USER_ATTRIBUTE_TYPES UATT
join TEXT_ITEMS TXI
  on TXI.TXT_ID = UATT.TXT_ID
where UATT.CODE like 'UATT%'
order by UATT.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Error cases
-- -----------

execute SYSTEM_USER.SET_UATT_DESCRIPTION('UATT1', 'xx', 'Text'); &eh
-- TXT-0004: Unknown text language

execute SYSTEM_USER.SET_UATT_DESCRIPTION('UATT1', 'la', 'Latin Text'); &eh
-- TXT-0005: Inactive text language

execute SYSTEM_USER.SET_UATT_DESCRIPTION('XXX', 'en', 'User Attribute Type'); &eh
-- ORA-01403: no data found

execute SYSTEM_USER.SET_UATT_DESCRIPTION('UATT1', 'ru', ''); &eh
-- TXT-0001: Text must be specified

-- Remove user attribute type descriptions
-- =======================================

-- Error cases
-- -----------

execute SYSTEM_USER.REMOVE_UATT_DESCRIPTION('XXX', 'fr'); &eh
-- ORA-01403: no data found

execute SYSTEM_USER.REMOVE_UATT_DESCRIPTION('UATT2', 'en'); &eh
-- TXT-0012: Cannot delete last mandatory text item

execute SYSTEM_USER.REMOVE_UATT_DESCRIPTION('UATT1', 'xx'); &eh
-- TXT-0011: No text to delete

-- Success cases
-- -------------

execute SYSTEM_USER.REMOVE_UATT_DESCRIPTION('UATT1', 'fr'); &eh

select UATT.CODE, UATT.DATA_TYPE, UATT.DISPLAY_SEQ, UATT.ACTIVE_FLAG, UATT.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from USER_ATTRIBUTE_TYPES UATT
join TEXT_ITEMS TXI
  on TXI.TXT_ID = UATT.TXT_ID
where UATT.CODE like 'UATT%'
order by UATT.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Set user attribute type text
-- ============================

-- Success cases
-- -------------

variable SEQ_NBR number
execute SYSTEM_USER.SET_UATT_TEXT('UATT1', 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh
execute SYSTEM_USER.SET_UATT_TEXT('UATT1', 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
execute :SEQ_NBR := null; SYSTEM_USER.SET_UATT_TEXT('UATT1', 'NOTE', :SEQ_NBR, 'es', 'New Spanish note'); &eh
execute :SEQ_NBR := 1; SYSTEM_USER.SET_UATT_TEXT('UATT1', 'NOTE', :SEQ_NBR, 'fr', 'Updated French note'); &eh
execute :SEQ_NBR := 2; SYSTEM_USER.SET_UATT_TEXT('UATT1', 'NOTE', :SEQ_NBR, 'es', 'Updated Spanish note'); &eh
execute :SEQ_NBR := 2; SYSTEM_USER.SET_UATT_TEXT('UATT1', 'NOTE', :SEQ_NBR, 'es', rpad('Updated Spanish note ', 1001, unistr('\00F1'))); &eh

select UATT.CODE, UATT.DATA_TYPE, UATT.DISPLAY_SEQ, UATT.ACTIVE_FLAG, UATT.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from USER_ATTRIBUTE_TYPES UATT
join TEXT_ITEMS TXI
  on TXI.TXT_ID = UATT.TXT_ID
where UATT.CODE like 'UATT%'
and TXI.TXTT_CODE != 'DESCR'
order by UATT.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Error cases
-- -----------

execute :SEQ_NBR := null; SYSTEM_USER.SET_UATT_TEXT('UATT1', 'NOTE', :SEQ_NBR, 'xx', 'Unknown note'); &eh
-- TXT-0004: Unknown text language

execute :SEQ_NBR := null; SYSTEM_USER.SET_UATT_TEXT('UATT1', 'NOTE', :SEQ_NBR, 'la', 'Latin note'); &eh
-- TXT-0005: Inactive text language

execute :SEQ_NBR := null; SYSTEM_USER.SET_UATT_TEXT('XXX', 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
-- ORA-01403: no data found

execute :SEQ_NBR := null; SYSTEM_USER.SET_UATT_TEXT('UATT1', 'XXXX', :SEQ_NBR, 'fr', 'French note'); &eh
-- TXT-0002: Unknown text type

execute :SEQ_NBR := null; SYSTEM_USER.SET_UATT_TEXT('UATT1', 'DESCR', :SEQ_NBR, 'fr', 'French note'); &eh
-- TXT-0008: Only one text item of this type allowed

execute :SEQ_NBR := 1; SYSTEM_USER.SET_UATT_TEXT('UATT2', 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
-- TXT-0009: No existing text of this type

execute :SEQ_NBR := 9; SYSTEM_USER.SET_UATT_TEXT('UATT1', 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
-- TXT-0010: Text item sequence number greater than current maximum

execute :SEQ_NBR := null; SYSTEM_USER.SET_UATT_TEXT('UATT1', 'NOTE', :SEQ_NBR, 'en', ''); &eh
-- TXT-0001: Text must be specified

execute :SEQ_NBR := 1; SYSTEM_USER.SET_UATT_TEXT('XXX', 'NOTE', :SEQ_NBR, 'fr', 'Updated note'); &eh
-- ORA-01403: no data found

execute :SEQ_NBR := 1; SYSTEM_USER.SET_UATT_TEXT('UATT1', 'XXXX', :SEQ_NBR, 'fr', 'Updated note'); &eh
-- TXT-0002: Unknown text type

execute :SEQ_NBR := 9; SYSTEM_USER.SET_UATT_TEXT('UATT1', 'NOTE', :SEQ_NBR, 'fr', 'Updated note'); &eh
-- TXT-0010: Text item sequence number greater than current maximum

execute :SEQ_NBR := 1; SYSTEM_USER.SET_UATT_TEXT('UATT1', 'NOTE', :SEQ_NBR, 'xx', 'Updated note'); &eh
-- TXT-0004: Unknown text language

execute :SEQ_NBR := 1; SYSTEM_USER.SET_UATT_TEXT('UATT1', 'NOTE', :SEQ_NBR, 'fr', ''); &eh
-- TXT-0001: Text must be specified

-- Remove user attribute type text
-- ===============================

-- Error cases
-- -----------

execute SYSTEM_USER.REMOVE_UATT_TEXT('XXX', 'NOTE', 1, 'en'); &eh
-- ORA-01403: no data found

execute SYSTEM_USER.REMOVE_UATT_TEXT('UATT1', null); &eh
-- USR-0007: Text type must be specified

execute SYSTEM_USER.REMOVE_UATT_TEXT('UATT1', 'XXXX', 1, 'en'); &eh
-- ORA-01403: no data found

execute SYSTEM_USER.REMOVE_UATT_TEXT('UATT1', 'NOTE', 9, 'en'); &eh
-- TXT-0011: No text to delete

execute SYSTEM_USER.REMOVE_UATT_TEXT('UATT1', 'NOTE', 1, 'xx'); &eh
-- TXT-0011: No text to delete

execute SYSTEM_USER.REMOVE_UATT_TEXT('UATT2', 'NOTE'); &eh
-- TXT-0011: No text to delete

execute SYSTEM_USER.REMOVE_UATT_TEXT('UATT1', 'DESCR'); &eh
-- TXT-0013: Cannot delete mandatory text type

execute SYSTEM_USER.REMOVE_UATT_TEXT('UATT1', 'DESCR', 1); &eh
-- TXT-0012: Cannot delete last mandatory text item

execute SYSTEM_USER.REMOVE_UATT_TEXT('UATT2', 'DESCR', 1, 'en'); &eh
-- TXT-0012: Cannot delete last mandatory text item

-- Success cases
-- -------------

execute SYSTEM_USER.REMOVE_UATT_TEXT('UATT1', 'NOTE', 1, 'en'); &eh
execute SYSTEM_USER.REMOVE_UATT_TEXT('UATT1', 'NOTE', 1); &eh
execute SYSTEM_USER.REMOVE_UATT_TEXT('UATT1', 'NOTE'); &eh

select UATT.CODE, UATT.DATA_TYPE, UATT.DISPLAY_SEQ, UATT.ACTIVE_FLAG, UATT.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from USER_ATTRIBUTE_TYPES UATT
join TEXT_ITEMS TXI
  on TXI.TXT_ID = UATT.TXT_ID
where UATT.CODE like 'UATT%'
order by UATT.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Set user attributes
-- ===================

-- Success cases
-- -------------

execute SYSTEM_USER.SET_USER_ATTRIBUTE('USER1', 'UATT1', 'Character attribute'); &eh
execute SYSTEM_USER.SET_USER_ATTRIBUTE('USER1', 'UATT5', null, 999.99); &eh
execute SYSTEM_USER.SET_USER_ATTRIBUTE('USER1', 'UATT3', pdDATE_VALUE => date '2012-01-26'); &eh
execute SYSTEM_USER.SET_USER_ATTRIBUTE('USER1', 'UATT1', 'Updated character attribute'); &eh
execute SYSTEM_USER.SET_USER_ATTRIBUTE('USER1', 'UATT5', null, 3.14159e5); &eh
execute SYSTEM_USER.SET_USER_ATTRIBUTE('USER1', 'UATT3', pdDATE_VALUE => sysdate); &eh

select USERID, UATT_CODE, CHAR_VALUE, NUM_VALUE, to_char(DATE_VALUE, 'YYYY-MM-DD HH24:MI:SS')
from USER_ATTRIBUTES
order by USERID, UATT_CODE;

-- Error cases
-- -----------

execute SYSTEM_USER.SET_USER_ATTRIBUTE('XXX', 'UATT1', 'Character attribute'); &eh
-- ORA-02291: integrity constraint (PSR.FK_UAT_USR) violated - parent key not found

execute SYSTEM_USER.SET_USER_ATTRIBUTE('USER1', 'XXXX', 'Character attribute'); &eh
-- USR-0019: Unknown user attribute type

execute SYSTEM_USER.SET_USER_ATTRIBUTE('USER1', 'UATT2', null, 0); &eh
-- USR-0020: Inactive user attribute type

execute SYSTEM_USER.SET_USER_ATTRIBUTE('USER1', 'UATT1'); &eh
-- USR-0021: Attribute of the correct type must be specified

execute SYSTEM_USER.SET_USER_ATTRIBUTE('USER1', 'UATT1', pnNUM_VALUE => 1); &eh
-- USR-0021: Attribute of the correct type must be specified

execute SYSTEM_USER.SET_USER_ATTRIBUTE('USER1', 'UATT5', pdDATE_VALUE => sysdate); &eh
-- USR-0021: Attribute of the correct type must be specified

execute SYSTEM_USER.SET_USER_ATTRIBUTE('USER1', 'UATT3', psCHAR_VALUE => 'xx'); &eh
-- USR-0021: Attribute of the correct type must be specified

-- Remove user attribute types
-- ===========================

-- Error cases
-- -----------

execute SYSTEM_USER.DELETE_USER_ATTRIBUTE_TYPE('UATT5'); &eh
-- ORA-02292: integrity constraint (PSR.FK_UAT_UATT) violated - child record found

-- Remove user attributes
-- ======================

-- Error cases
-- -----------

execute SYSTEM_USER.REMOVE_USER_ATTRIBUTE('XXX', 'UATT1'); &eh
-- USR-0018: User attribute does not exist

execute SYSTEM_USER.REMOVE_USER_ATTRIBUTE('USER1', 'XXXX'); &eh
-- USR-0018: User attribute does not exist

-- Success cases
-- -------------

execute SYSTEM_USER.REMOVE_USER_ATTRIBUTE('USER1', 'UATT3'); &eh

select USERID, UATT_CODE, CHAR_VALUE, NUM_VALUE, to_char(DATE_VALUE, 'YYYY-MM-DD HH24:MI:SS')
from USER_ATTRIBUTES
order by USERID, UATT_CODE;

-- Set user attribute text
-- =======================

-- Success cases
-- -------------

execute :SEQ_NBR := null; SYSTEM_USER.SET_UAT_TEXT('USER1', 'UATT1', 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh
execute SYSTEM_USER.SET_UAT_TEXT('USER1', 'UATT1', 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
execute :SEQ_NBR := null; SYSTEM_USER.SET_UAT_TEXT('USER1', 'UATT1', 'NOTE', :SEQ_NBR, 'es', 'New Spanish note'); &eh
execute :SEQ_NBR := 1; SYSTEM_USER.SET_UAT_TEXT('USER1', 'UATT1', 'NOTE', :SEQ_NBR, 'fr', 'Updated French note'); &eh
execute :SEQ_NBR := 2; SYSTEM_USER.SET_UAT_TEXT('USER1', 'UATT1', 'NOTE', :SEQ_NBR, 'es', rpad('Updated Spanish note ', 1001, unistr('\00F1'))); &eh

select UAT.USERID, UAT.UATT_CODE, UAT.CHAR_VALUE, UAT.NUM_VALUE, to_char(UAT.DATE_VALUE, 'YYYY-MM-DD HH24:MI:SS'),
  UAT.TXT_ID, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from USER_ATTRIBUTES UAT
left outer join TEXT_ITEMS TXI
  on TXI.TXT_ID = UAT.TXT_ID
order by UAT.USERID, UAT.UATT_CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Error cases
-- -----------

execute :SEQ_NBR := null; SYSTEM_USER.SET_UAT_TEXT('XXX', 'UATT1', 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
-- ORA-01403: no data found

execute :SEQ_NBR := null; SYSTEM_USER.SET_UAT_TEXT('USER1', 'XXX', 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
-- ORA-01403: no data found

execute :SEQ_NBR := null; SYSTEM_USER.SET_UAT_TEXT('USER1', 'UATT1', 'XXXX', :SEQ_NBR, 'fr', 'French note'); &eh
-- TXT-0002: Unknown text type

execute :SEQ_NBR := null; SYSTEM_USER.SET_UAT_TEXT('USER1', 'UATT1', 'NOTE', :SEQ_NBR, 'xx', 'Unknown note'); &eh
-- TXT-0004: Unknown text language

execute :SEQ_NBR := null; SYSTEM_USER.SET_UAT_TEXT('USER1', 'UATT1', 'NOTE', :SEQ_NBR, 'la', 'Latin note'); &eh
-- TXT-0005: Inactive text language

execute :SEQ_NBR := 1; SYSTEM_USER.SET_UAT_TEXT('USER1', 'UATT5', 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
-- TXT-0006: Cannot specify a text item sequence number without a text identifier

execute :SEQ_NBR := 9; SYSTEM_USER.SET_UAT_TEXT('USER1', 'UATT1', 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
-- TXT-0010: Text item sequence number greater than current maximum

execute :SEQ_NBR := null; SYSTEM_USER.SET_UAT_TEXT('USER1', 'UATT1', 'NOTE', :SEQ_NBR, 'en', ''); &eh
-- TXT-0001: Text must be specified

execute :SEQ_NBR := 1; SYSTEM_USER.SET_UAT_TEXT('XXX', 'UATT1', 'NOTE', :SEQ_NBR, 'fr', 'Updated note'); &eh
-- ORA-01403: no data found

execute :SEQ_NBR := 1; SYSTEM_USER.SET_UAT_TEXT('USER1', 'XXX', 'NOTE', :SEQ_NBR, 'fr', 'Updated note'); &eh
-- ORA-01403: no data found

execute :SEQ_NBR := 1; SYSTEM_USER.SET_UAT_TEXT('USER1', 'UATT1', 'XXXX', :SEQ_NBR, 'fr', 'Updated note'); &eh
-- TXT-0002: Unknown text type

execute :SEQ_NBR := 1; SYSTEM_USER.SET_UAT_TEXT('USER1', 'UATT1', 'NOTE', :SEQ_NBR, 'xx', 'Updated note'); &eh
-- TXT-0004: Unknown text language

execute :SEQ_NBR := 1; SYSTEM_USER.SET_UAT_TEXT('USER1', 'UATT1', 'NOTE', :SEQ_NBR, 'fr', ''); &eh
-- TXT-0001: Text must be specified

-- Remove user attribute text
-- ==========================

-- Error cases
-- -----------

execute SYSTEM_USER.REMOVE_UAT_TEXT('USER1', 'XXX', 'NOTE', 1, 'en'); &eh
-- ORA-01403: no data found

execute SYSTEM_USER.REMOVE_UAT_TEXT('XXX', 'UATT1', 'NOTE', 1, 'en'); &eh
-- ORA-01403: no data found

execute SYSTEM_USER.REMOVE_UAT_TEXT('USER1', 'UATT1', null); &eh
-- USR-0007: Text type must be specified

execute SYSTEM_USER.REMOVE_UAT_TEXT('USER1', 'UATT1', 'XXXX', 1, 'en'); &eh
-- ORA-01403: no data found

execute SYSTEM_USER.REMOVE_UAT_TEXT('USER1', 'UATT1', 'NOTE', 9, 'en'); &eh
-- TXT-0011: No text to delete

execute SYSTEM_USER.REMOVE_UAT_TEXT('USER1', 'UATT1', 'NOTE', 1, 'xx'); &eh
-- TXT-0011: No text to delete

-- Success cases
-- -------------

execute SYSTEM_USER.REMOVE_UAT_TEXT('USER1', 'UATT1', 'NOTE', 1, 'en'); &eh
execute SYSTEM_USER.REMOVE_UAT_TEXT('USER1', 'UATT1', 'NOTE', 1); &eh
execute SYSTEM_USER.REMOVE_UAT_TEXT('USER1', 'UATT1', 'NOTE'); &eh

select UAT.USERID, UAT.UATT_CODE, UAT.CHAR_VALUE, UAT.NUM_VALUE, to_char(UAT.DATE_VALUE, 'YYYY-MM-DD HH24:MI:SS'),
  UAT.TXT_ID, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from USER_ATTRIBUTES UAT
left outer join TEXT_ITEMS TXI
  on TXI.TXT_ID = UAT.TXT_ID
order by UAT.USERID, UAT.UATT_CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Set user language preferences
-- =============================

-- Success cases
-- -------------

execute SYSTEM_USER.SET_USER_LANG_PREFERENCE('USER1', 'en', 1); &eh
execute SYSTEM_USER.SET_USER_LANG_PREFERENCE('USER1', 'fr', 2); &eh
execute SYSTEM_USER.SET_USER_LANG_PREFERENCE('USER2', 'ar', 4); &eh
execute SYSTEM_USER.SET_USER_LANG_PREFERENCE('USER1', 'en', 3); &eh

select USERID, LANG_CODE, PREF_SEQ
from USER_LANGUAGE_PREFERENCES
order by USERID, PREF_SEQ;

-- Error cases
-- -----------

execute SYSTEM_USER.SET_USER_LANG_PREFERENCE('XXX', 'en', 1); &eh
-- ORA-02291: integrity constraint (PSR.FK_ULP_USR) violated - parent key not found

execute SYSTEM_USER.SET_USER_LANG_PREFERENCE('USER1', 'xx', 1); &eh
-- USR-0013: Unknown preference language

execute SYSTEM_USER.SET_USER_LANG_PREFERENCE('USER1', 'la', 1); &eh
-- USR-0014: Inactive preference language

execute SYSTEM_USER.SET_USER_LANG_PREFERENCE('USER1', 'en', 1e6); &eh
-- ORA-01438: value larger than specified precision allowed for this column

execute SYSTEM_USER.SET_USER_LANG_PREFERENCE('USER1', 'en', 2); &eh
-- ORA-00001: unique constraint (PSR.UK_ULP_PREF_SEQ) violated

-- Remove languages
-- ================

-- Error cases
-- -----------

execute LANGUAGE.SET_LANGUAGE('de', 'en', 'German'); &eh
execute SYSTEM_USER.SET_USER_LANG_PREFERENCE('USER1', 'de', 4); &eh
execute LANGUAGE.DELETE_LANGUAGE('de'); &eh
-- ORA-02292: integrity constraint (PSR.FK_ULP_LANG) violated - child record found
execute SYSTEM_USER.REMOVE_USER_LANG_PREFERENCE('USER1', 'de'); &eh
execute LANGUAGE.DELETE_LANGUAGE('de'); &eh

-- Remove user language preferences
-- ================================

-- Error cases
-- -----------

execute SYSTEM_USER.REMOVE_USER_LANG_PREFERENCE('USER1'); &eh
-- USR-0015: Language or preference sequence (or both) must be specified

execute SYSTEM_USER.REMOVE_USER_LANG_PREFERENCE('XXX', 'en'); &eh
-- USR-0016: Language preference does not exist

execute SYSTEM_USER.REMOVE_USER_LANG_PREFERENCE('USER1', 'xx'); &eh
-- USR-0016: Language preference does not exist

execute SYSTEM_USER.REMOVE_USER_LANG_PREFERENCE('USER1', pnPREF_SEQ => 1); &eh
-- USR-0016: Language preference does not exist

execute SYSTEM_USER.REMOVE_USER_LANG_PREFERENCE('USER1', 'en', 1); &eh
-- USR-0016: Language preference does not exist

-- Success cases
-- -------------

execute SYSTEM_USER.REMOVE_USER_LANG_PREFERENCE('USER1', 'en'); &eh
execute SYSTEM_USER.REMOVE_USER_LANG_PREFERENCE('USER1', pnPREF_SEQ => 2); &eh
execute SYSTEM_USER.REMOVE_USER_LANG_PREFERENCE('USER2', 'ar', 4); &eh

select USERID, LANG_CODE, PREF_SEQ
from USER_LANGUAGE_PREFERENCES
order by USERID, PREF_SEQ;

-- Delete user attribute types
-- ===========================

-- Error cases
-- -----------

execute SYSTEM_USER.DELETE_USER_ATTRIBUTE_TYPE('XXX'); &eh
-- USR-0006: User attribute type does not exist

-- Success cases
-- -------------

execute SYSTEM_USER.DELETE_USER_ATTRIBUTE_TYPE('UATT6'); &eh

select UATT.CODE, UATT.DISPLAY_SEQ, UATT.ACTIVE_FLAG, UATT.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from USER_ATTRIBUTE_TYPES UATT
join TEXT_ITEMS TXI
  on TXI.TXT_ID = UATT.TXT_ID
where UATT.CODE like 'UATT%'
order by UATT.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Delete system users
-- ===================

-- Error cases
-- -----------

execute SYSTEM_USER.DELETE_SYSTEM_USER('XXX'); &eh
-- USR-0012: User does not exist

-- Success cases
-- -------------

select *
from USER_ATTRIBUTES
where USERID = 'USER1';

execute SYSTEM_USER.SET_USER_LANG_PREFERENCE('USER1', 'en', 1); &eh

select *
from USER_LANGUAGE_PREFERENCES
where USERID = 'USER1';

execute SYSTEM_USER.DELETE_SYSTEM_USER('USER1'); &eh

select USR.USERID, USR.LOCKED_FLAG, USR.TEMPLATE_FLAG, USR.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from SYSTEM_USERS USR
join TEXT_ITEMS TXI
  on TXI.TXT_ID = USR.TXT_ID
where USR.USERID like 'USER%'
order by USR.USERID, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

select count(*)
from USER_ATTRIBUTES
where USERID = 'USER1';

select count(*)
from USER_LANGUAGE_PREFERENCES
where USERID = 'USER1';

set echo off serveroutput off feedback on

rollback;

@check_orphan_TXT_ID

spool off

@login
