-- Test set-up
-- ===========

define eh = "exception when others then dbms_output.put_line(substr(sqlerrm, case when substr(sqlerrm, 12, 5) = 'ORA-2' then 12 else 1 end))"

set echo on serveroutput on feedback off recsepchar "." sqlprompt "        " sqlnumber off

column LONG_TEXT format A150

spool test_TEXT_TYPE.log

-- Set text types
-- ==============

-- Success cases
-- -------------

execute TEXT_TYPE.SET_TEXT_TYPE('TXTT1', 'en', 'Test 1'); &eh
execute TEXT_TYPE.SET_TEXT_TYPE('TXTT2', 'en', 'Test 2', null, 'N'); &eh
execute TEXT_TYPE.SET_TEXT_TYPE('TXTT3', 'en', 'Test 3', 1); &eh
execute TEXT_TYPE.SET_TEXT_TYPE('TXTT4', 'en', 'Test 4', 999, 'N'); &eh
execute TEXT_TYPE.SET_TEXT_TYPE('TXTT5', 'en', 'Test 5', pnDISPLAY_SEQ => 2); &eh
execute TEXT_TYPE.SET_TEXT_TYPE('TXTT6', 'en', 'Test 6', psACTIVE_FLAG => 'N'); &eh
execute TEXT_TYPE.SET_TEXT_TYPE('TXTT1', 'en', 'Text!'); &eh
execute TEXT_TYPE.SET_TEXT_TYPE('TXTT1', null, null, 1); &eh
execute TEXT_TYPE.SET_TEXT_TYPE('TXTT1', null, null, null, 'N'); &eh
execute TEXT_TYPE.SET_TEXT_TYPE('TXTT1', psLANG_CODE => 'en', psDescription => 'Text'); &eh
execute TEXT_TYPE.SET_TEXT_TYPE('TXTT1', pnDISPLAY_SEQ => 2); &eh
execute TEXT_TYPE.SET_TEXT_TYPE('TXTT1', psACTIVE_FLAG => 'Y'); &eh
execute TEXT_TYPE.SET_TEXT_TYPE('TXTT1', pnDISPLAY_SEQ => null); &eh


select TXTT.CODE, TXTT.DISPLAY_SEQ, TXTT.ACTIVE_FLAG, TXTT.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from TEXT_TYPES TXTT
join TEXT_ITEMS TXI
  on TXI.TXT_ID = TXTT.TXT_ID
where TXTT.CODE like 'TXTT%'
order by TXTT.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Error cases
-- -----------

execute TEXT_TYPE.SET_TEXT_TYPE('TXTT9', 'en', ''); &eh
-- TXTT-0001: Description must be specified for new text type

execute TEXT_TYPE.SET_TEXT_TYPE('TXTT9', 'xx', 'Text type description'); &eh
-- TXTT-0004: Unknown description language

execute TEXT_TYPE.SET_TEXT_TYPE('TXTT9', 'la', 'Text type description'); &eh
-- TXTT-0005: Inactive description language

execute TEXT_TYPE.SET_TEXT_TYPE('TXTT9', 'en', 'Text type description', 1e6); &eh
-- ORA-01438: value larger than specified precision allowed for this column

execute TEXT_TYPE.SET_TEXT_TYPE('TXTT9', 'en', 'Text type description', null, 'X'); &eh
-- ORA-02290: check constraint (PSR.CH_TXTT_ACTIVE_FLAG) violated

execute TEXT_TYPE.SET_TEXT_TYPE('TXTT1', 'en'); &eh
-- TXTT-0002: Description language cannot be specified without description text

execute TEXT_TYPE.SET_TEXT_TYPE('TXTT1', 'xx', 'Text type description'); &eh
-- TXTT-0004: Unknown description language

execute TEXT_TYPE.SET_TEXT_TYPE('TXTT1', 'la', 'Text type description'); &eh
-- TXTT-0005: Inactive description language

execute TEXT_TYPE.SET_TEXT_TYPE('TXTT1', null, 'Text type description'); &eh
-- TXTT-0004: Unknown description language

execute TEXT_TYPE.SET_TEXT_TYPE('TXTT1'); &eh
-- TXTT-0003: Nothing to be updated

execute TEXT_TYPE.SET_TEXT_TYPE('TXTT1', pnDISPLAY_SEQ => 1e6); &eh
-- ORA-01438: value larger than specified precision allowed for this column

execute TEXT_TYPE.SET_TEXT_TYPE('TXTT1', psACTIVE_FLAG => 'X'); &eh
-- ORA-02290: check constraint (PSR.CH_TXTT_ACTIVE_FLAG) violated

-- Set text type descriptions
-- ==========================

-- Success cases
-- -------------

execute TEXT_TYPE.SET_TXTT_DESCRIPTION('TXTT1', 'fr', 'Text'); &eh
execute TEXT_TYPE.SET_TXTT_DESCRIPTION('TXTT1', 'fr', 'Texte'); &eh

select TXTT.CODE, TXTT.DISPLAY_SEQ, TXTT.ACTIVE_FLAG, TXTT.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from TEXT_TYPES TXTT
join TEXT_ITEMS TXI
  on TXI.TXT_ID = TXTT.TXT_ID
where TXTT.CODE = 'TXTT1'
order by TXTT.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Error cases
-- -----------

execute TEXT_TYPE.SET_TXTT_DESCRIPTION('TXTT1', 'xx', 'Text'); &eh
-- TXT-0004: Unknown text language

execute TEXT_TYPE.SET_TXTT_DESCRIPTION('TXTT1', 'la', 'Latin Text'); &eh
-- TXT-0005: Inactive text language

execute TEXT_TYPE.SET_TXTT_DESCRIPTION('XXX', 'en', 'Component'); &eh
-- ORA-01403: no data found

execute TEXT_TYPE.SET_TXTT_DESCRIPTION('TXTT1', 'ru', ''); &eh
-- TXT-0001: Text must be specified

-- Remove text type descriptions
-- =============================

-- Error cases
-- -----------

execute TEXT_TYPE.REMOVE_TXTT_DESCRIPTION('XXX', 'fr'); &eh
-- ORA-01403: no data found

execute TEXT_TYPE.REMOVE_TXTT_DESCRIPTION('TXTT2', 'en'); &eh
-- TXT-0012: Cannot delete last mandatory text item

execute TEXT_TYPE.REMOVE_TXTT_DESCRIPTION('TXTT1', 'xx'); &eh
-- TXT-0011: No text to delete

-- Success cases
-- -------------

execute TEXT_TYPE.REMOVE_TXTT_DESCRIPTION('TXTT1', 'fr'); &eh

select TXTT.CODE, TXTT.DISPLAY_SEQ, TXTT.ACTIVE_FLAG, TXTT.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from TEXT_TYPES TXTT
join TEXT_ITEMS TXI
  on TXI.TXT_ID = TXTT.TXT_ID
where TXTT.CODE = 'TXTT1'
order by TXTT.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Set text type text
-- ==================

-- Success cases
-- -------------

variable SEQ_NBR number
execute TEXT_TYPE.SET_TXTT_TEXT('TXTT1', 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh
execute TEXT_TYPE.SET_TXTT_TEXT('TXTT1', 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
execute :SEQ_NBR := null; TEXT_TYPE.SET_TXTT_TEXT('TXTT1', 'NOTE', :SEQ_NBR, 'es', 'New Spanish note'); &eh
execute :SEQ_NBR := 1; TEXT_TYPE.SET_TXTT_TEXT('TXTT1', 'NOTE', :SEQ_NBR, 'fr', 'Updated French note'); &eh
execute :SEQ_NBR := 2; TEXT_TYPE.SET_TXTT_TEXT('TXTT1', 'NOTE', :SEQ_NBR, 'es', 'Updated Spanish note'); &eh
execute :SEQ_NBR := 2; TEXT_TYPE.SET_TXTT_TEXT('TXTT1', 'NOTE', :SEQ_NBR, 'es', rpad('Updated Spanish note ', 1001, unistr('\00F1'))); &eh

select TXTT.CODE, TXTT.DISPLAY_SEQ, TXTT.ACTIVE_FLAG, TXTT.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from TEXT_TYPES TXTT
join TEXT_ITEMS TXI
  on TXI.TXT_ID = TXTT.TXT_ID
where TXTT.CODE = 'TXTT1'
order by TXTT.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Error cases
-- -----------

execute :SEQ_NBR := null; TEXT_TYPE.SET_TXTT_TEXT('TXTT1', 'NOTE', :SEQ_NBR, 'xx', 'Unknown note'); &eh
-- TXT-0004: Unknown text language

execute :SEQ_NBR := null; TEXT_TYPE.SET_TXTT_TEXT('TXTT1', 'NOTE', :SEQ_NBR, 'la', 'Latin note'); &eh
-- TXT-0005: Inactive text language

execute :SEQ_NBR := null; TEXT_TYPE.SET_TXTT_TEXT('XXX', 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
-- ORA-01403: no data found

execute :SEQ_NBR := null; TEXT_TYPE.SET_TXTT_TEXT('TXTT1', 'XXXX', :SEQ_NBR, 'fr', 'French note'); &eh
-- TXT-0002: Unknown text type

execute :SEQ_NBR := null; TEXT_TYPE.SET_TXTT_TEXT('TXTT1', 'DESCR', :SEQ_NBR, 'fr', 'French note'); &eh
-- TXT-0008: Only one text item of this type allowed

execute :SEQ_NBR := 1; TEXT_TYPE.SET_TXTT_TEXT('TXTT2', 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
-- TXT-0009: No existing text of this type

execute :SEQ_NBR := 9; TEXT_TYPE.SET_TXTT_TEXT('TXTT1', 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
-- TXT-0010: Text item sequence number greater than current maximum

execute :SEQ_NBR := null; TEXT_TYPE.SET_TXTT_TEXT('TXTT1', 'NOTE', :SEQ_NBR, 'en', ''); &eh
-- TXT-0001: Text must be specified

execute :SEQ_NBR := 1; TEXT_TYPE.SET_TXTT_TEXT('XXX', 'NOTE', :SEQ_NBR, 'fr', 'Updated note'); &eh
-- ORA-01403: no data found

execute :SEQ_NBR := 1; TEXT_TYPE.SET_TXTT_TEXT('TXTT1', 'XXXX', :SEQ_NBR, 'fr', 'Updated note'); &eh
-- TXT-0002: Unknown text type

execute :SEQ_NBR := 9; TEXT_TYPE.SET_TXTT_TEXT('TXTT1', 'NOTE', :SEQ_NBR, 'fr', 'Updated note'); &eh
-- TXT-0010: Text item sequence number greater than current maximum

execute :SEQ_NBR := 1; TEXT_TYPE.SET_TXTT_TEXT('TXTT1', 'NOTE', :SEQ_NBR, 'xx', 'Updated note'); &eh
-- TXT-0004: Unknown text language

execute :SEQ_NBR := 1; TEXT_TYPE.SET_TXTT_TEXT('TXTT1', 'NOTE', :SEQ_NBR, 'fr', ''); &eh
-- TXT-0001: Text must be specified

-- Remove text type text
-- =====================

-- Error cases
-- -----------

execute TEXT_TYPE.REMOVE_TXTT_TEXT('XXX', 'NOTE', 1, 'en'); &eh
-- ORA-01403: no data found

execute TEXT_TYPE.REMOVE_TXTT_TEXT('TXTT1', null); &eh
-- TXTT-0007: Text type must be specified

execute TEXT_TYPE.REMOVE_TXTT_TEXT('TXTT1', 'XXXX', 1, 'en'); &eh
-- ORA-01403: no data found

execute TEXT_TYPE.REMOVE_TXTT_TEXT('TXTT1', 'NOTE', 9, 'en'); &eh
-- TXT-0011: No text to delete

execute TEXT_TYPE.REMOVE_TXTT_TEXT('TXTT1', 'NOTE', 1, 'xx'); &eh
-- TXT-0011: No text to delete

execute TEXT_TYPE.REMOVE_TXTT_TEXT('TXTT2', 'NOTE'); &eh
-- TXT-0011: No text to delete

execute TEXT_TYPE.REMOVE_TXTT_TEXT('TXTT1', 'DESCR'); &eh
-- TXT-0013: Cannot delete mandatory text type

execute TEXT_TYPE.REMOVE_TXTT_TEXT('TXTT1', 'DESCR', 1); &eh
-- TXT-0012: Cannot delete last mandatory text item

execute TEXT_TYPE.REMOVE_TXTT_TEXT('TXTT1', 'DESCR', 1, 'en'); &eh
-- TXT-0012: Cannot delete last mandatory text item

-- Success cases
-- -------------

execute TEXT_TYPE.REMOVE_TXTT_TEXT('TXTT1', 'NOTE', 1, 'en'); &eh
execute TEXT_TYPE.REMOVE_TXTT_TEXT('TXTT1', 'NOTE', 1); &eh
execute TEXT_TYPE.REMOVE_TXTT_TEXT('TXTT1', 'NOTE'); &eh

select TXTT.CODE, TXTT.DISPLAY_SEQ, TXTT.ACTIVE_FLAG, TXTT.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from TEXT_TYPES TXTT
join TEXT_ITEMS TXI
  on TXI.TXT_ID = TXTT.TXT_ID
where TXTT.CODE = 'TXTT1'
order by TXTT.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Delete text types
-- =================

-- Error cases
-- -----------

execute TEXT_TYPE.DELETE_TEXT_TYPE('XXX'); &eh
-- TXTT-0006: Text type does not exist

-- Success cases
-- -------------

execute TEXT_TYPE.DELETE_TEXT_TYPE('TXTT6'); &eh

select TXTT.CODE, TXTT.DISPLAY_SEQ, TXTT.ACTIVE_FLAG, TXTT.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from TEXT_TYPES TXTT
join TEXT_ITEMS TXI
  on TXI.TXT_ID = TXTT.TXT_ID
where TXTT.CODE like 'TXTT%'
order by TXTT.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Set text type properties
-- ========================

-- Success cases
-- -------------

execute TEXT_TYPE.SET_TEXT_TYPE_PROPERTIES('TXTT1', 'TXTT'); &eh
execute TEXT_TYPE.SET_TEXT_TYPE_PROPERTIES('TXTT2', 'TXTT', 'Y'); &eh
execute TEXT_TYPE.SET_TEXT_TYPE_PROPERTIES('TXTT3', 'TXTT', null, 'N'); &eh
execute TEXT_TYPE.SET_TEXT_TYPE_PROPERTIES('TXTT4', 'TXTT', psLONG_TEXT_FLAG => 'N'); &eh
execute TEXT_TYPE.SET_TEXT_TYPE_PROPERTIES('TXTT1', 'TXTT', 'N', 'Y', 'Y'); &eh
execute TEXT_TYPE.SET_TEXT_TYPE_PROPERTIES('TXTT1', 'TXTT'); &eh
execute TEXT_TYPE.SET_TEXT_TYPE_PROPERTIES('TXTT2', 'TXTT', 'N'); &eh
execute TEXT_TYPE.SET_TEXT_TYPE_PROPERTIES('TXTT3', 'TXTT', null, 'Y'); &eh
execute TEXT_TYPE.SET_TEXT_TYPE_PROPERTIES('TXTT4', 'TXTT', psLONG_TEXT_FLAG => 'Y'); &eh

select TXP.TXTT_CODE, TXP.TAB_ALIAS, TXP.MANDATORY_FLAG, TXP.MULTI_INSTANCE_FLAG, TXP.LONG_TEXT_FLAG, TXP.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from TEXT_TYPE_PROPERTIES TXP
left outer join TEXT_ITEMS TXI
  on TXI.TXT_ID = TXP.TXT_ID
where TXP.TXTT_CODE like 'TXTT%'
order by TXP.TXTT_CODE, TXP.TAB_ALIAS, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Error cases
-- -----------

execute TEXT_TYPE.SET_TEXT_TYPE_PROPERTIES('TXTT9', 'TXTT'); &eh
-- ORA-02291: integrity constraint (PSR.FK_TTP_TXTT) violated - parent key not found

execute TEXT_TYPE.SET_TEXT_TYPE_PROPERTIES('TXTT1', 'XXX'); &eh
-- ORA-02291: integrity constraint (PSR.FK_TTP_TAB) violated - parent key not found

execute TEXT_TYPE.SET_TEXT_TYPE_PROPERTIES('TXTT1', 'TXTT', 'X'); &eh
-- ORA-02290: check constraint (PSR.CH_TTP_MANDATORY_FLAG) violated

execute TEXT_TYPE.SET_TEXT_TYPE_PROPERTIES('TXTT1', 'TXTT', null, 'X'); &eh
-- ORA-02290: check constraint (PSR.CH_TTP_MULTI_INSTANCE_FLAG) violated

execute TEXT_TYPE.SET_TEXT_TYPE_PROPERTIES('TXTT1', 'TXTT', null, null, 'X'); &eh
-- ORA-02290: check constraint (PSR.CH_TTP_LONG_TEXT_FLAG) violated

-- Set text type properties text
-- =============================

-- Success cases
-- -------------

execute :SEQ_NBR := null; TEXT_TYPE.SET_TXP_TEXT('TXTT1', 'TXTT', 'NOTE', :SEQ_NBR, 'en', 'Initial English note'); &eh
execute TEXT_TYPE.SET_TXP_TEXT('TXTT1', 'TXTT', 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
execute :SEQ_NBR := null; TEXT_TYPE.SET_TXP_TEXT('TXTT1', 'TXTT', 'NOTE', :SEQ_NBR, 'es', 'New Spanish note'); &eh
execute :SEQ_NBR := 1; TEXT_TYPE.SET_TXP_TEXT('TXTT1', 'TXTT', 'NOTE', :SEQ_NBR, 'en', 'Updated English note'); &eh

select TXP.TXTT_CODE, TXP.TAB_ALIAS, TXP.MANDATORY_FLAG, TXP.MULTI_INSTANCE_FLAG, TXP.LONG_TEXT_FLAG, TXP.TXT_ID,
  TXT.TAB_ALIAS, TTH.TXTT_CODE, TTH.TXI_SEQ_NBR_MAX,
  TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from TEXT_TYPE_PROPERTIES TXP
left outer join TEXT_HEADERS TXT
  on TXT.ID = TXP.TXT_ID
left outer join TEXT_TYPE_HEADERS TTH
  on TTH.TXT_ID = TXT.ID
left outer join TEXT_ITEMS TXI
  on TXI.TXT_ID = TTH.TXT_ID
where TXP.TXTT_CODE like 'TXTT%'
order by TXP.TXTT_CODE, TXP.TAB_ALIAS, TTH.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Error cases
-- -----------

execute :SEQ_NBR := null; TEXT_TYPE.SET_TXP_TEXT('TXTT9', 'TXTT', 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh
-- ORA-01403: no data found

execute :SEQ_NBR := null; TEXT_TYPE.SET_TXP_TEXT('TXTT1', 'XXXX', 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh
-- ORA-01403: no data found

execute :SEQ_NBR := null; TEXT_TYPE.SET_TXP_TEXT('TXTT1', 'TXTT', 'XXX', :SEQ_NBR, 'en', 'English note'); &eh
-- TXT-0002: Unknown text type

execute :SEQ_NBR := 9; TEXT_TYPE.SET_TXP_TEXT('TXTT1', 'TXTT', 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh
-- TXT-0010: Text item sequence number greater than current maximum

execute :SEQ_NBR := null; TEXT_TYPE.SET_TXP_TEXT('TXTT1', 'TXTT', 'NOTE', :SEQ_NBR, 'xx', 'Unknown note'); &eh
-- TXT-0004: Unknown text language

execute :SEQ_NBR := null; TEXT_TYPE.SET_TXP_TEXT('TXTT1', 'TXTT', 'NOTE', :SEQ_NBR, 'la', 'Latin note'); &eh
-- TXT-0005: Inactive text language

execute :SEQ_NBR := null; TEXT_TYPE.SET_TXP_TEXT('TXTT1', 'TXTT', 'MSG', :SEQ_NBR, 'en', 'English message'); &eh
-- ORA-02291: integrity constraint (PSR.FK_TTH_TTP) violated - parent key not found

execute :SEQ_NBR := null; TEXT_TYPE.SET_TXP_TEXT('TXTT1', 'TXTT', 'NOTE', :SEQ_NBR, 'en', ''); &eh
-- TXT-0001: Text must be specified

-- Remove text type properties text
-- ================================

-- Error cases
-- -----------

execute TEXT_TYPE.REMOVE_TXP_TEXT('TXTT9', 'TXTT', 'NOTE'); &eh
-- ORA-01403: no data found

execute TEXT_TYPE.REMOVE_TXP_TEXT('TXTT1', 'XXXX', 'NOTE'); &eh
-- ORA-01403: no data found

execute TEXT_TYPE.REMOVE_TXP_TEXT('TXTT1', 'TXTT', 'XXXX'); &eh
-- ORA-01403: no data found

execute TEXT_TYPE.REMOVE_TXP_TEXT('TXTT1', 'TXTT', 'NOTE', 9); &eh
-- TXT-0011: No text to delete

execute TEXT_TYPE.REMOVE_TXP_TEXT('TXTT1', 'TXTT', 'NOTE', 1, 'xx'); &eh
-- TXT-0011: No text to delete

execute TEXT_TYPE.REMOVE_TXP_TEXT('TXTT1', 'TXTT', null); &eh
-- TXTT-0007: Text type must be specified

-- Success cases
-- -------------

execute TEXT_TYPE.REMOVE_TXP_TEXT('TXTT1', 'TXTT', 'NOTE', 1, 'en'); &eh
execute TEXT_TYPE.REMOVE_TXP_TEXT('TXTT1', 'TXTT', 'NOTE', 1); &eh
execute TEXT_TYPE.REMOVE_TXP_TEXT('TXTT1', 'TXTT', 'NOTE'); &eh
execute TEXT_TYPE.REMOVE_TXP_TEXT('TXTT2', 'TXTT', 'NOTE', 1, 'en'); &eh

select TXP.TXTT_CODE, TXP.TAB_ALIAS, TXP.MANDATORY_FLAG, TXP.MULTI_INSTANCE_FLAG, TXP.LONG_TEXT_FLAG, TXP.TXT_ID,
  TXT.TAB_ALIAS, TTH.TXTT_CODE, TTH.TXI_SEQ_NBR_MAX,
  TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from TEXT_TYPE_PROPERTIES TXP
left outer join TEXT_HEADERS TXT
  on TXT.ID = TXP.TXT_ID
left outer join TEXT_TYPE_HEADERS TTH
  on TTH.TXT_ID = TXT.ID
left outer join TEXT_ITEMS TXI
  on TXI.TXT_ID = TTH.TXT_ID
where TXP.TXTT_CODE like 'TXTT%'
order by TXP.TXTT_CODE, TXP.TAB_ALIAS, TTH.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Remove text type properties
-- ===========================

-- Error cases
-- -----------

execute TEXT_TYPE.REMOVE_TEXT_TYPE_PROPERTIES('XXX', 'TXTT'); &eh
-- TXTT-0008: Text type property does not exist

execute TEXT_TYPE.REMOVE_TEXT_TYPE_PROPERTIES('TXTT1', 'XXX'); &eh
-- TXTT-0008: Text type property does not exist

execute TEXT_TYPE.REMOVE_TEXT_TYPE_PROPERTIES('TXTT1', 'TXT'); &eh
-- TXTT-0008: Text type property does not exist

execute TEXT_TYPE.REMOVE_TEXT_TYPE_PROPERTIES('TXTT5', 'TXTT'); &eh
-- TXTT-0008: Text type property does not exist

-- Success cases
-- -------------

execute TEXT_TYPE.REMOVE_TEXT_TYPE_PROPERTIES('TXTT4', 'TXTT'); &eh

select TXP.TXTT_CODE, TXP.TAB_ALIAS, TXP.MANDATORY_FLAG, TXP.MULTI_INSTANCE_FLAG, TXP.LONG_TEXT_FLAG, TXP.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from TEXT_TYPE_PROPERTIES TXP
left outer join TEXT_ITEMS TXI
  on TXI.TXT_ID = TXP.TXT_ID
where TXP.TXTT_CODE like 'TXTT%'
order by TXP.TXTT_CODE, TXP.TAB_ALIAS, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

set echo off serveroutput off feedback on recsepchar " "

@check_orphan_TXT_ID

rollback;

spool off

@login
