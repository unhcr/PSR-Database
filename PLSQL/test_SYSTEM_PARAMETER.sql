-- Test set-up
-- ===========

define eh = "exception when others then dbms_output.put_line('-- ' || sqlerrm)"

variable VERSION_NBR number
variable SEQ_NBR number

set echo on serveroutput on feedback off recsepchar "." sqlprompt "" sqlnumber off

column DESCRIPTION format a119
column DATA_TYPE format A9
column CHAR_VALUE format A50
column LONG_TEXT format A150

spool test_SYSTEM_PARAMETER.log

-- Set system parameters
-- =====================

-- Success cases
-- -------------

execute P_SYSTEM_PARAMETER.INSERT_SYSTEM_PARAMETER('SYP1', 'en', 'Test parameter 1', 'C', 'Character parameter'); &eh
execute :VERSION_NBR := 1; P_SYSTEM_PARAMETER.UPDATE_SYSTEM_PARAMETER('SYP1', :VERSION_NBR, psDATA_TYPE => 'C', psCHAR_VALUE => 'Updated character parameter'); &eh
execute :VERSION_NBR := null; P_SYSTEM_PARAMETER.SET_SYSTEM_PARAMETER('SYP2', :VERSION_NBR, 'en', 'Test parameter 2', 'N', null, 3.14159); &eh
execute P_SYSTEM_PARAMETER.SET_SYSTEM_PARAMETER('SYP2', :VERSION_NBR, psDATA_TYPE => 'N', pnNUM_VALUE => 2.71828); &eh
execute :VERSION_NBR := null; P_SYSTEM_PARAMETER.SET_SYSTEM_PARAMETER('SYP3', :VERSION_NBR, 'en', 'Test parameter 3', 'D', null, null, date '2012-01-01'); &eh
execute P_SYSTEM_PARAMETER.SET_SYSTEM_PARAMETER('SYP3', :VERSION_NBR, psDATA_TYPE => 'C', psCHAR_VALUE => 'Changed data type'); &eh

select CODE, DESCRIPTION, DATA_TYPE, CHAR_VALUE, NUM_VALUE, DATE_VALUE, VERSION_NBR
from SYSTEM_PARAMETERS
where CODE like 'SYP%'
order by CODE;

-- Error cases
-- -----------

execute P_SYSTEM_PARAMETER.INSERT_SYSTEM_PARAMETER('SYP1', 'en', 'Test parameter 1', 'C', 'Updated character parameter'); &eh
-- ORA-00001: unique constraint (PSR.PK_SYP) violated

execute :VERSION_NBR := null; P_SYSTEM_PARAMETER.UPDATE_SYSTEM_PARAMETER('SYP1', :VERSION_NBR, 'en', 'Test parameter 1', 'C', 'Updated character parameter'); &eh
-- ORA-20002: SYP-0001: System parameter has been updated by another user

execute :VERSION_NBR := 1; P_SYSTEM_PARAMETER.SET_SYSTEM_PARAMETER('SYP1', :VERSION_NBR, 'en', 'Test parameter 1', 'C', 'Updated character parameter'); &eh
-- ORA-20002: SYP-0001: System parameter has been updated by another user

execute :VERSION_NBR := null; P_SYSTEM_PARAMETER.SET_SYSTEM_PARAMETER('SYP9', :VERSION_NBR, 'en', 'Test parameter 9', 'CC', 'X'); &eh
-- ORA-12899: value too large for column "PSR"."T_SYSTEM_PARAMETERS"."DATA_TYPE" (actual: 2, maximum: 1)

execute :VERSION_NBR := null; P_SYSTEM_PARAMETER.SET_SYSTEM_PARAMETER('SYP9', :VERSION_NBR, 'en', 'Test parameter 9', 'X', 'X'); &eh
-- ORA-02290: check constraint (PSR.CH_SYP_DATA_TYPE) violated

execute :VERSION_NBR := null; P_SYSTEM_PARAMETER.SET_SYSTEM_PARAMETER('SYP9', :VERSION_NBR, 'en', 'Test parameter 9', 'C'); &eh
-- ORA-02290: check constraint (PSR.CH_SYP_DATA_TYPE) violated

execute :VERSION_NBR := null; P_SYSTEM_PARAMETER.SET_SYSTEM_PARAMETER('SYP9', :VERSION_NBR, 'en', 'Test parameter 9', 'C', null, 999); &eh
-- ORA-02290: check constraint (PSR.CH_SYP_DATA_TYPE) violated

-- Set system parameter text
-- =========================

-- Success cases
-- -------------

execute :VERSION_NBR := 2; P_SYSTEM_PARAMETER.SET_SYP_TEXT('SYP3', :VERSION_NBR, 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh
execute P_SYSTEM_PARAMETER.SET_SYP_TEXT('SYP3', :VERSION_NBR, 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
execute :SEQ_NBR := null; P_SYSTEM_PARAMETER.SET_SYP_TEXT('SYP3', :VERSION_NBR, 'NOTE', :SEQ_NBR, 'es', 'New Spanish note'); &eh
execute :SEQ_NBR := 1; P_SYSTEM_PARAMETER.SET_SYP_TEXT('SYP3', :VERSION_NBR, 'NOTE', :SEQ_NBR, 'fr', 'Updated French note'); &eh
execute :SEQ_NBR := 2; P_SYSTEM_PARAMETER.SET_SYP_TEXT('SYP3', :VERSION_NBR, 'NOTE', :SEQ_NBR, 'es', 'Updated Spanish note'); &eh
execute :SEQ_NBR := 2; P_SYSTEM_PARAMETER.SET_SYP_TEXT('SYP3', :VERSION_NBR, 'NOTE', :SEQ_NBR, 'es', rpad('Updated Spanish note ', 1001, unistr('\00F1'))); &eh

select SYP.CODE, SYP.DATA_TYPE, SYP.CHAR_VALUE, SYP.NUM_VALUE, SYP.DATE_VALUE, SYP.ITM_ID, SYP.VERSION_NBR,
  TXT.TXTT_CODE, TXT.SEQ_NBR, TXT.LANG_CODE, TXT.TEXT, TXT.LONG_TEXT
from SYSTEM_PARAMETERS SYP
left outer join TEXT_ITEMS TXT
  on TXT.ITM_ID = SYP.ITM_ID
where SYP.CODE = 'SYP3'
order by SYP.CODE, TXT.TXTT_CODE, TXT.SEQ_NBR, TXT.LANG_CODE;

-- Error cases
-- -----------

execute :VERSION_NBR := null; :SEQ_NBR := null; P_SYSTEM_PARAMETER.SET_SYP_TEXT('SYP3', :VERSION_NBR, 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh
-- ORA-20002: SYP-0001: System parameter has been updated by another user

execute :VERSION_NBR := 1; :SEQ_NBR := null; P_SYSTEM_PARAMETER.SET_SYP_TEXT('SYP3', :VERSION_NBR, 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh
-- ORA-20002: SYP-0001: System parameter has been updated by another user

execute :VERSION_NBR := 8; :SEQ_NBR := null; P_SYSTEM_PARAMETER.SET_SYP_TEXT('XXXX', :VERSION_NBR, 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
-- ORA-01403: no data found

execute :VERSION_NBR := 8; :SEQ_NBR := null; P_SYSTEM_PARAMETER.SET_SYP_TEXT('SYP3', :VERSION_NBR, 'NOTE', :SEQ_NBR, 'xx', 'Unknown note'); &eh
-- ORA-20002: TXT-0003: Unknown text language

execute :VERSION_NBR := 8; :SEQ_NBR := null; P_SYSTEM_PARAMETER.SET_SYP_TEXT('SYP3', :VERSION_NBR, 'NOTE', :SEQ_NBR, 'la', 'Latin note'); &eh
-- ORA-20002: TXT-0004: Inactive text language

execute :VERSION_NBR := 8; :SEQ_NBR := null; P_SYSTEM_PARAMETER.SET_SYP_TEXT('SYP3', :VERSION_NBR, 'XXXX', :SEQ_NBR, 'fr', 'French note'); &eh
-- ORA-20002: TXT-0001: Unknown text type

execute :VERSION_NBR := 8; :SEQ_NBR := null; P_SYSTEM_PARAMETER.SET_SYP_TEXT('SYP3', :VERSION_NBR, 'NAME', :SEQ_NBR, 'fr', 'French note'); &eh
-- ORA-02291: integrity constraint (PSR.FK_TTH_TTP) violated - parent key not found

execute :VERSION_NBR := 2; :SEQ_NBR := 1; P_SYSTEM_PARAMETER.SET_SYP_TEXT('SYP2', :VERSION_NBR, 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
-- ORA-20002: TXT-0008: No existing text of this type

execute :VERSION_NBR := 8; :SEQ_NBR := 9; P_SYSTEM_PARAMETER.SET_SYP_TEXT('SYP3', :VERSION_NBR, 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
-- ORA-20002: TXT-0009: Text item sequence number greater than current maximum

execute :VERSION_NBR := 8; :SEQ_NBR := null; P_SYSTEM_PARAMETER.SET_SYP_TEXT('SYP3', :VERSION_NBR, 'NOTE', :SEQ_NBR, 'en', ''); &eh
-- ORA-06502: PL/SQL: numeric or value error

execute :VERSION_NBR := 8; :SEQ_NBR := 1; P_SYSTEM_PARAMETER.SET_SYP_TEXT('XXXX', :VERSION_NBR, 'NOTE', :SEQ_NBR, 'fr', 'Updated note'); &eh
-- ORA-01403: no data found

execute :VERSION_NBR := 8; :SEQ_NBR := 1; P_SYSTEM_PARAMETER.SET_SYP_TEXT('SYP3', :VERSION_NBR, 'XXXX', :SEQ_NBR, 'fr', 'Updated note'); &eh
-- ORA-20002: TXT-0001: Unknown text type

execute :VERSION_NBR := 8; :SEQ_NBR := 1; P_SYSTEM_PARAMETER.SET_SYP_TEXT('SYP3', :VERSION_NBR, 'NOTE', :SEQ_NBR, 'xx', 'Updated note'); &eh
-- ORA-20002: TXT-0003: Unknown text language

execute :VERSION_NBR := 8; :SEQ_NBR := 1; P_SYSTEM_PARAMETER.SET_SYP_TEXT('SYP3', :VERSION_NBR, 'NOTE', :SEQ_NBR, 'fr', ''); &eh
-- ORA-06502: PL/SQL: numeric or value error

-- Remove system parameter text
-- ====================

-- Error cases
-- -----------

execute :VERSION_NBR := null; P_SYSTEM_PARAMETER.REMOVE_SYP_TEXT('SYP3', :VERSION_NBR, 'NOTE', 1, 'en'); &eh
-- ORA-20002: SYP-0001: System parameter has been updated by another user

execute :VERSION_NBR := 1; P_SYSTEM_PARAMETER.REMOVE_SYP_TEXT('SYP3', :VERSION_NBR, 'NOTE', 1, 'en'); &eh
-- ORA-20002: SYP-0001: System parameter has been updated by another user

execute :VERSION_NBR := 8; P_SYSTEM_PARAMETER.REMOVE_SYP_TEXT('SYP3', :VERSION_NBR, ''); &eh
-- ORA-06502: PL/SQL: numeric or value error

execute P_SYSTEM_PARAMETER.REMOVE_SYP_TEXT('XXXX', :VERSION_NBR, 'NOTE', 1, 'en'); &eh
-- ORA-01403: no data found

execute P_SYSTEM_PARAMETER.REMOVE_SYP_TEXT('SYP3', :VERSION_NBR, 'XXXX', 1, 'en'); &eh
-- ORA-01403: no data found

execute P_SYSTEM_PARAMETER.REMOVE_SYP_TEXT('SYP3', :VERSION_NBR, 'NOTE', 9, 'en'); &eh
-- ORA-20002: TXT-0010: No text to delete

execute P_SYSTEM_PARAMETER.REMOVE_SYP_TEXT('SYP3', :VERSION_NBR, 'NOTE', 1, 'xx'); &eh
-- ORA-20002: TXT-0010: No text to delete

execute :VERSION_NBR := 2; P_SYSTEM_PARAMETER.REMOVE_SYP_TEXT('SYP2', :VERSION_NBR, 'NOTE'); &eh
-- ORA-20002: TXT-0010: No text to delete

-- Success cases
-- -------------

execute :VERSION_NBR := 8; P_SYSTEM_PARAMETER.REMOVE_SYP_TEXT('SYP3', :VERSION_NBR, 'NOTE', 1, 'en'); &eh
execute P_SYSTEM_PARAMETER.REMOVE_SYP_TEXT('SYP3', :VERSION_NBR, 'NOTE', 1); &eh
execute P_SYSTEM_PARAMETER.REMOVE_SYP_TEXT('SYP3', :VERSION_NBR, 'NOTE'); &eh

select SYP.CODE, SYP.DATA_TYPE, SYP.CHAR_VALUE, SYP.NUM_VALUE, SYP.DATE_VALUE, SYP.ITM_ID, SYP.VERSION_NBR,
  TXT.TXTT_CODE, TXT.SEQ_NBR, TXT.LANG_CODE, TXT.TEXT, TXT.LONG_TEXT
from SYSTEM_PARAMETERS SYP
left outer join TEXT_ITEMS TXT
  on TXT.ITM_ID = SYP.ITM_ID
where SYP.CODE = 'SYP3'
order by SYP.CODE, TXT.TXTT_CODE, TXT.SEQ_NBR, TXT.LANG_CODE;

-- Delete system parameters
-- ========================

-- Error cases
-- -----------

execute :VERSION_NBR := 1; P_SYSTEM_PARAMETER.DELETE_SYSTEM_PARAMETER('SYP9', :VERSION_NBR); &eh
-- ORA-01403: no data found

execute :VERSION_NBR := null; P_SYSTEM_PARAMETER.DELETE_SYSTEM_PARAMETER('SYP3', :VERSION_NBR); &eh
-- ORA-20002: SYP-0001: System parameter has been updated by another user

execute :VERSION_NBR := 10; P_SYSTEM_PARAMETER.DELETE_SYSTEM_PARAMETER('SYP3', :VERSION_NBR); &eh
-- ORA-20002: SYP-0001: System parameter has been updated by another user

-- Success cases
-- -------------

execute :VERSION_NBR := 11; P_SYSTEM_PARAMETER.DELETE_SYSTEM_PARAMETER('SYP3', :VERSION_NBR); &eh

select SYP.CODE, SYP.DATA_TYPE, SYP.CHAR_VALUE, SYP.NUM_VALUE, SYP.DATE_VALUE, SYP.VERSION_NBR
from SYSTEM_PARAMETERS SYP
order by SYP.CODE;

set echo off serveroutput off feedback on recsepchar " "

@check_orphan_ITM_ID

rollback;

spool off

@login
