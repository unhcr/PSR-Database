-- Test set-up
-- ===========

define eh = "exception when others then dbms_output.put_line(substr(sqlerrm, case when substr(sqlerrm, 12, 5) = 'ORA-2' then 12 else 1 end))"

set echo on serveroutput on feedback off recsepchar "." sqlprompt "        " sqlnumber off

column LONG_TEXT format A150

spool test_MESSAGE.log

-- Set components
-- ==============

-- Success cases
-- -------------

execute MESSAGE.SET_COMPONENT('TST1', 'en', 'Test 1'); &eh
execute MESSAGE.SET_COMPONENT('TST2', 'en', 'Test 2', null, 'N'); &eh
execute MESSAGE.SET_COMPONENT('TST3', 'en', 'Test 3', 1); &eh
execute MESSAGE.SET_COMPONENT('TST4', 'en', 'Test 4', 999, 'N'); &eh
execute MESSAGE.SET_COMPONENT('TST5', 'en', 'Test 5', pnDISPLAY_SEQ => 2); &eh
execute MESSAGE.SET_COMPONENT('TST6', 'en', 'Test 6', psACTIVE_FLAG => 'N'); &eh
execute MESSAGE.SET_COMPONENT('TST1', 'en', 'Text!'); &eh
execute MESSAGE.SET_COMPONENT('TST1', null, null, 1); &eh
execute MESSAGE.SET_COMPONENT('TST1', null, null, null, 'N'); &eh
execute MESSAGE.SET_COMPONENT('TST1', psLANG_CODE => 'en', psDescription => 'Text'); &eh
execute MESSAGE.SET_COMPONENT('TST1', pnDISPLAY_SEQ => 2); &eh
execute MESSAGE.SET_COMPONENT('TST1', psACTIVE_FLAG => 'Y'); &eh
execute MESSAGE.SET_COMPONENT('TST1', pnDISPLAY_SEQ => null); &eh

select COMP.CODE, COMP.DISPLAY_SEQ, COMP.ACTIVE_FLAG, COMP.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from COMPONENTS COMP
join TEXT_ITEMS TXI
  on TXI.TXT_ID = COMP.TXT_ID
where COMP.CODE like 'TST%'
order by COMP.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Error cases
-- -----------

execute MESSAGE.SET_COMPONENT('TST7', 'en', ''); &eh
-- MSG-0005: Description must be specified for new component

execute MESSAGE.SET_COMPONENT('TST7', 'xx', 'Statistic Types'); &eh
-- MSG-0008: Unknown description language

execute MESSAGE.SET_COMPONENT('TST7', 'la', 'Statistic Types'); &eh
-- MSG-0009 Inactive description language

execute MESSAGE.SET_COMPONENT('TST7', 'en', 'Statistic Types', 1e6); &eh
-- ORA-01438: value larger than specified precision allowed for this column

execute MESSAGE.SET_COMPONENT('TST7', 'en', 'Statistic Types', null, 'X'); &eh
-- ORA-02290: check constraint (PSR.CH_COMP_ACTIVE_FLAG) violated

execute MESSAGE.SET_COMPONENT('TST1', 'en'); &eh
-- MSG-0006: Description language cannot be specified without description text

execute MESSAGE.SET_COMPONENT('TST1', 'xx', 'Text'); &eh
-- MSG-0008: Unknown description language

execute MESSAGE.SET_COMPONENT('TST1', 'la', 'Text'); &eh
-- MSG-0009 Inactive description language

execute MESSAGE.SET_COMPONENT('TST1', null, 'Text'); &eh
-- MSG-0008: Unknown description language

execute MESSAGE.SET_COMPONENT('TST1'); &eh
-- MSG-0007: Nothing to be updated

execute MESSAGE.SET_COMPONENT('TST1', pnDISPLAY_SEQ => 1e6); &eh
-- ORA-01438: value larger than specified precision allowed for this column

execute MESSAGE.SET_COMPONENT('TST1', psACTIVE_FLAG => 'X'); &eh
-- ORA-02290: check constraint (PSR.CH_COMP_ACTIVE_FLAG) violated

-- Set component descriptions
-- ==========================

-- Success cases
-- -------------

execute MESSAGE.SET_COMP_DESCRIPTION('TST1', 'fr', 'Text'); &eh
execute MESSAGE.SET_COMP_DESCRIPTION('TST1', 'fr', 'Texte'); &eh

select COMP.CODE, COMP.DISPLAY_SEQ, COMP.ACTIVE_FLAG, COMP.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from COMPONENTS COMP
join TEXT_ITEMS TXI
  on TXI.TXT_ID = COMP.TXT_ID
where COMP.CODE = 'TST1'
order by COMP.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Error cases
-- -----------

execute MESSAGE.SET_COMP_DESCRIPTION('TST1', 'xx', 'Text'); &eh
-- TXT-0004: Unknown text language

execute MESSAGE.SET_COMP_DESCRIPTION('TST1', 'la', 'Latin Text'); &eh
-- TXT-0005: Inactive text language

execute MESSAGE.SET_COMP_DESCRIPTION('XXX', 'en', 'Component'); &eh
-- ORA-01403: no data found

execute MESSAGE.SET_COMP_DESCRIPTION('TST1', 'ru', ''); &eh
-- TXT-0001: Text must be specified

-- Remove component descriptions
-- =============================

-- Error cases
-- -----------

execute MESSAGE.REMOVE_COMP_DESCRIPTION('XXX', 'fr'); &eh
-- ORA-01403: no data found

execute MESSAGE.REMOVE_COMP_DESCRIPTION('TST2', 'en'); &eh
-- TXT-0012: Cannot delete last mandatory text item

execute MESSAGE.REMOVE_COMP_DESCRIPTION('TST1', 'xx'); &eh
-- TXT-0011: No text to delete

-- Success cases
-- -------------

execute MESSAGE.REMOVE_COMP_DESCRIPTION('TST1', 'fr'); &eh

select COMP.CODE, COMP.DISPLAY_SEQ, COMP.ACTIVE_FLAG, COMP.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from COMPONENTS COMP
join TEXT_ITEMS TXI
  on TXI.TXT_ID = COMP.TXT_ID
where COMP.CODE = 'TST1'
order by COMP.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Set component text
-- ==================

-- Success cases
-- -------------

variable SEQ_NBR number
execute MESSAGE.SET_COMP_TEXT('TST1', 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh
execute MESSAGE.SET_COMP_TEXT('TST1', 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
execute :SEQ_NBR := null; MESSAGE.SET_COMP_TEXT('TST1', 'NOTE', :SEQ_NBR, 'es', 'New Spanish note'); &eh
execute :SEQ_NBR := 1; MESSAGE.SET_COMP_TEXT('TST1', 'NOTE', :SEQ_NBR, 'fr', 'Updated French note'); &eh
execute :SEQ_NBR := 2; MESSAGE.SET_COMP_TEXT('TST1', 'NOTE', :SEQ_NBR, 'es', 'Updated Spanish note'); &eh
execute :SEQ_NBR := 2; MESSAGE.SET_COMP_TEXT('TST1', 'NOTE', :SEQ_NBR, 'es', rpad('Updated Spanish note ', 1001, unistr('\00F1'))); &eh

select COMP.CODE, COMP.DISPLAY_SEQ, COMP.ACTIVE_FLAG, COMP.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from COMPONENTS COMP
join TEXT_ITEMS TXI
  on TXI.TXT_ID = COMP.TXT_ID
where COMP.CODE = 'TST1'
order by COMP.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Error cases
-- -----------

execute :SEQ_NBR := null; MESSAGE.SET_COMP_TEXT('TST1', 'NOTE', :SEQ_NBR, 'xx', 'Unknown note'); &eh
-- TXT-0004: Unknown text language

execute :SEQ_NBR := null; MESSAGE.SET_COMP_TEXT('TST1', 'NOTE', :SEQ_NBR, 'la', 'Latin note'); &eh
-- TXT-0005: Inactive text language

execute :SEQ_NBR := null; MESSAGE.SET_COMP_TEXT('XXX', 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
-- ORA-01403: no data found

execute :SEQ_NBR := null; MESSAGE.SET_COMP_TEXT('TST1', 'XXXX', :SEQ_NBR, 'fr', 'French note'); &eh
-- TXT-0002: Unknown text type

execute :SEQ_NBR := null; MESSAGE.SET_COMP_TEXT('TST1', 'DESCR', :SEQ_NBR, 'fr', 'French note'); &eh
-- TXT-0008: Only one text item of this type allowed

execute :SEQ_NBR := 1; MESSAGE.SET_COMP_TEXT('TST2', 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
-- TXT-0009: No existing text of this type

execute :SEQ_NBR := 9; MESSAGE.SET_COMP_TEXT('TST1', 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
-- TXT-0010: Text item sequence number greater than current maximum

execute :SEQ_NBR := null; MESSAGE.SET_COMP_TEXT('TST1', 'NOTE', :SEQ_NBR, 'en', ''); &eh
-- TXT-0001: Text must be specified

execute :SEQ_NBR := 1; MESSAGE.SET_COMP_TEXT('XXX', 'NOTE', :SEQ_NBR, 'fr', 'Updated note'); &eh
-- ORA-01403: no data found

execute :SEQ_NBR := 1; MESSAGE.SET_COMP_TEXT('TST1', 'XXXX', :SEQ_NBR, 'fr', 'Updated note'); &eh
-- TXT-0002: Unknown text type

execute :SEQ_NBR := 9; MESSAGE.SET_COMP_TEXT('TST1', 'NOTE', :SEQ_NBR, 'fr', 'Updated note'); &eh
-- TXT-0010: Text item sequence number greater than current maximum

execute :SEQ_NBR := 1; MESSAGE.SET_COMP_TEXT('TST1', 'NOTE', :SEQ_NBR, 'xx', 'Updated note'); &eh
-- TXT-0004: Unknown text language

execute :SEQ_NBR := 1; MESSAGE.SET_COMP_TEXT('TST1', 'NOTE', :SEQ_NBR, 'fr', ''); &eh
-- TXT-0001: Text must be specified

-- Remove component text
-- =====================

-- Error cases
-- -----------

execute MESSAGE.REMOVE_COMP_TEXT('XXX', 'NOTE', 1, 'en'); &eh
-- ORA-01403: no data found

execute MESSAGE.REMOVE_COMP_TEXT('TST1', null); &eh
-- MSG-0011: Text type must be specified

execute MESSAGE.REMOVE_COMP_TEXT('TST1', 'XXXX', 1, 'en'); &eh
-- ORA-01403: no data found

execute MESSAGE.REMOVE_COMP_TEXT('TST1', 'NOTE', 9, 'en'); &eh
-- TXT-0011: No text to delete

execute MESSAGE.REMOVE_COMP_TEXT('TST1', 'NOTE', 1, 'xx'); &eh
-- TXT-0011: No text to delete

execute MESSAGE.REMOVE_COMP_TEXT('TST2', 'NOTE'); &eh
-- TXT-0011: No text to delete

execute MESSAGE.REMOVE_COMP_TEXT('TST1', 'DESCR'); &eh
-- TXT-0013: Cannot delete mandatory text type

execute MESSAGE.REMOVE_COMP_TEXT('TST1', 'DESCR', 1); &eh
-- TXT-0012: Cannot delete last mandatory text item

execute MESSAGE.REMOVE_COMP_TEXT('TST1', 'DESCR', 1, 'en'); &eh
-- TXT-0012: Cannot delete last mandatory text item

-- Success cases
-- -------------

execute MESSAGE.REMOVE_COMP_TEXT('TST1', 'NOTE', 1, 'en'); &eh
execute MESSAGE.REMOVE_COMP_TEXT('TST1', 'NOTE', 1); &eh
execute MESSAGE.REMOVE_COMP_TEXT('TST1', 'NOTE'); &eh

select COMP.CODE, COMP.DISPLAY_SEQ, COMP.ACTIVE_FLAG, COMP.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from COMPONENTS COMP
join TEXT_ITEMS TXI
  on TXI.TXT_ID = COMP.TXT_ID
where COMP.CODE = 'TST1'
order by COMP.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Delete components
-- =================

-- Error cases
-- -----------

execute MESSAGE.DELETE_COMPONENT('XXX'); &eh
-- MSG-0010: Component does not exist

-- Success cases
-- -------------

execute MESSAGE.DELETE_COMPONENT('TST6'); &eh

select COMP.CODE, COMP.DISPLAY_SEQ, COMP.ACTIVE_FLAG, COMP.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from COMPONENTS COMP
join TEXT_ITEMS TXI
  on TXI.TXT_ID = COMP.TXT_ID
where COMP.CODE like 'TST%'
order by COMP.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;


-- Set messages
-- ============

-- Success cases
-- -------------

variable SEQ_NBR number;
execute :SEQ_NBR := null; MESSAGE.SET_MESSAGE('TST1', :SEQ_NBR, 'en', 'Error message'); &eh
execute :SEQ_NBR := null; MESSAGE.SET_MESSAGE('TST1', :SEQ_NBR, 'en', 'Warning message', 'W'); &eh
execute :SEQ_NBR := null; MESSAGE.SET_MESSAGE('TST2', :SEQ_NBR, 'fr', unistr('Message fran\00E7ais'), psSEVERITY => 'I'); &eh
execute :SEQ_NBR := null; MESSAGE.SET_MESSAGE('TST1', :SEQ_NBR, 'en', 'Error message 2'); &eh
execute MESSAGE.DELETE_MESSAGE('TST1', 2); &eh
execute :SEQ_NBR := 2; MESSAGE.SET_MESSAGE('TST1', :SEQ_NBR, 'en', 'Error message 2a'); &eh
execute :SEQ_NBR := 1; MESSAGE.SET_MESSAGE('TST1', :SEQ_NBR, 'en', 'Error message!'); &eh
execute :SEQ_NBR := 1; MESSAGE.SET_MESSAGE('TST1', :SEQ_NBR, null, null, 'I'); &eh
execute :SEQ_NBR := 1; MESSAGE.SET_MESSAGE('TST1', :SEQ_NBR, psLANG_CODE => 'en', psMessage => 'Error message'); &eh
execute :SEQ_NBR := 1; MESSAGE.SET_MESSAGE('TST1', :SEQ_NBR, psSEVERITY => 'E'); &eh

select MSG.COMP_CODE, MSG.SEQ_NBR, MSG.SEVERITY, MSG.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from MESSAGES MSG
join TEXT_ITEMS TXI
  on TXI.TXT_ID = MSG.TXT_ID
where MSG.COMP_CODE like 'TST%'
order by MSG.COMP_CODE, MSG.SEQ_NBR, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Error cases
-- -----------

execute :SEQ_NBR := null; MESSAGE.SET_MESSAGE('TST1', :SEQ_NBR, 'en', ''); &eh
-- MSG-0012: Message text must be specified for new message

execute :SEQ_NBR := null; MESSAGE.SET_MESSAGE('TST1', :SEQ_NBR, 'xx', 'Message'); &eh
-- MSG-0014: Unknown message language

execute :SEQ_NBR := null; MESSAGE.SET_MESSAGE('TST1', :SEQ_NBR, 'la', 'Latin message'); &eh
-- MSG-0015: Inactive message language

execute :SEQ_NBR := null; MESSAGE.SET_MESSAGE('XXX', :SEQ_NBR, 'en', 'Error message'); &eh
-- MSG-0010: Component does not exist

execute :SEQ_NBR := 1; MESSAGE.SET_MESSAGE('XXX', :SEQ_NBR, 'en', 'Error message'); &eh
-- ORA-01403: no data found

execute :SEQ_NBR := 9; MESSAGE.SET_MESSAGE('TST1', :SEQ_NBR, 'en', 'Error message'); &eh
-- MSG-0016: Message sequence number greater than current maximum

execute :SEQ_NBR := null; MESSAGE.SET_MESSAGE('TST1', :SEQ_NBR, 'en', 'Error message', 'X'); &eh
-- ORA-02290: check constraint (PSR.CH_MSG_SEVERITY) violated

execute :SEQ_NBR := 1; MESSAGE.SET_MESSAGE('TST1', :SEQ_NBR, null, 'Error message'); &eh
-- MSG-0014: Unknown message language

execute :SEQ_NBR := 1; MESSAGE.SET_MESSAGE('TST1', :SEQ_NBR, 'xx', 'Error message'); &eh
-- MSG-0014: Unknown message language

execute :SEQ_NBR := 1; MESSAGE.SET_MESSAGE('TST1', :SEQ_NBR, 'la', 'Error message'); &eh
-- MSG-0015: Inactive message language

execute :SEQ_NBR := 1; MESSAGE.SET_MESSAGE('XXX', :SEQ_NBR, 'en', 'Error message'); &eh
-- ORA-01403: no data found

execute :SEQ_NBR := 9; MESSAGE.SET_MESSAGE('TST1', :SEQ_NBR, 'en', 'Error message'); &eh
-- MSG-0016: Message sequence number greater than current maximum

execute :SEQ_NBR := 1; MESSAGE.SET_MESSAGE('TST1', :SEQ_NBR, 'en'); &eh
-- MSG-0013: Message language cannot be specified without message text

execute :SEQ_NBR := 1; MESSAGE.SET_MESSAGE('TST1', :SEQ_NBR); &eh
-- MSG-0007: Nothing to be updated

execute :SEQ_NBR := 1; MESSAGE.SET_MESSAGE('TST1', :SEQ_NBR, psSEVERITY => 'X'); &eh
-- ORA-02290: check constraint (PSR.CH_MSG_SEVERITY) violated

execute :SEQ_NBR := null; MESSAGE.SET_MESSAGE('TST1', :SEQ_NBR, 'en', rpad('Error message 3 ', 1001, 'x')); &eh
-- ORA-12899: value too large for column "PSR"."TEXT_ITEMS"."TEXT" (actual: 1001, maximum: 1000)

-- Set message variants
-- ====================

-- Success cases
-- -------------

execute MESSAGE.SET_MSG_MESSAGE('TST1', 1, 'fr', unistr('Message fran\00E7ais')); &eh
execute MESSAGE.SET_MSG_MESSAGE('TST1', 1, 'fr', unistr('Error message fran\00E7ais')); &eh
execute MESSAGE.SET_MSG_MESSAGE('TST1', 2, 'fr', unistr('Message d''erreur 2a')); &eh

select MSG.COMP_CODE, MSG.SEQ_NBR, MSG.SEVERITY, MSG.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from MESSAGES MSG
join TEXT_ITEMS TXI
  on TXI.TXT_ID = MSG.TXT_ID
where MSG.COMP_CODE like 'TST%'
order by MSG.COMP_CODE, MSG.SEQ_NBR, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Error cases
-- -----------

execute MESSAGE.SET_MSG_MESSAGE('TST1', 1, 'xx', 'Error message'); &eh
-- TXT-0004: Unknown text language

execute MESSAGE.SET_MSG_MESSAGE('TST1', 1, 'la', 'Latin error message'); &eh
-- TXT-0005: Inactive text language

execute MESSAGE.SET_MSG_MESSAGE('XXX', 1, 'en', 'Error message'); &eh
-- ORA-01403: no data found

execute MESSAGE.SET_MSG_MESSAGE('TST1', 9, 'en', 'Error message'); &eh
-- ORA-01403: no data found

execute MESSAGE.SET_MSG_MESSAGE('TST1', 1, 'ru', ''); &eh
-- TXT-0001: Text must be specified

-- Remove message variants
-- =======================

-- Error cases
-- -----------

execute MESSAGE.REMOVE_MSG_MESSAGE('XXX', 1, 'fr'); &eh
-- ORA-01403: no data found

execute MESSAGE.REMOVE_MSG_MESSAGE('TST1', 9, 'fr'); &eh
-- ORA-01403: no data found

execute MESSAGE.REMOVE_MSG_MESSAGE('TST2', 1, 'fr'); &eh
-- TXT-0012: Cannot delete last mandatory text item

execute MESSAGE.REMOVE_MSG_MESSAGE('TST2', 1, 'en'); &eh
-- TXT-0011: No text to delete

-- Success cases
-- -------------

execute MESSAGE.REMOVE_MSG_MESSAGE('TST1', 1, 'fr'); &eh

select MSG.COMP_CODE, MSG.SEQ_NBR, MSG.SEVERITY, MSG.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from MESSAGES MSG
join TEXT_ITEMS TXI
  on TXI.TXT_ID = MSG.TXT_ID
where MSG.COMP_CODE like 'TST%'
order by MSG.COMP_CODE, MSG.SEQ_NBR, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Set message general text
-- ========================

-- Success cases
-- -------------

variable TXI_SEQ_NBR number
execute :TXI_SEQ_NBR := null; MESSAGE.SET_MSG_TEXT('TST1', 1, 'NOTE', :TXI_SEQ_NBR, 'en', 'English note'); &eh
execute MESSAGE.SET_MSG_TEXT('TST1', 1, 'NOTE', :TXI_SEQ_NBR, 'fr', 'French note'); &eh
execute :TXI_SEQ_NBR := null; MESSAGE.SET_MSG_TEXT('TST1', 1, 'NOTE', :TXI_SEQ_NBR, 'es', 'New Spanish note'); &eh
execute :TXI_SEQ_NBR := 1; MESSAGE.SET_MSG_TEXT('TST1', 1, 'NOTE', :TXI_SEQ_NBR, 'fr', 'Updated French note'); &eh
execute :TXI_SEQ_NBR := 2; MESSAGE.SET_MSG_TEXT('TST1', 1, 'NOTE', :TXI_SEQ_NBR, 'es', 'Updated Spanish note'); &eh
execute :TXI_SEQ_NBR := 2; MESSAGE.SET_MSG_TEXT('TST1', 1, 'NOTE', :TXI_SEQ_NBR, 'es', rpad('Updated Spanish note ', 1001, unistr('\00F1'))); &eh

select MSG.COMP_CODE, MSG.SEQ_NBR, MSG.SEVERITY, MSG.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from MESSAGES MSG
join TEXT_ITEMS TXI
  on TXI.TXT_ID = MSG.TXT_ID
where MSG.COMP_CODE like 'TST%'
order by MSG.COMP_CODE, MSG.SEQ_NBR, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Error cases
-- -----------

execute :TXI_SEQ_NBR := null; MESSAGE.SET_MSG_TEXT('TST1', 1, 'NOTE', :TXI_SEQ_NBR, 'xx', 'Unknown note'); &eh
-- TXT-0004: Unknown text language

execute :TXI_SEQ_NBR := null; MESSAGE.SET_MSG_TEXT('TST1', 1, 'NOTE', :TXI_SEQ_NBR, 'la', 'Latin note'); &eh
-- TXT-0005: Inactive text language

execute :TXI_SEQ_NBR := null; MESSAGE.SET_MSG_TEXT('XXX', 1, 'NOTE', :TXI_SEQ_NBR, 'fr', 'French note'); &eh
-- ORA-01403: no data found

execute :TXI_SEQ_NBR := null; MESSAGE.SET_MSG_TEXT('TST1', 9, 'NOTE', :TXI_SEQ_NBR, 'fr', 'French note'); &eh
-- ORA-01403: no data found

execute :TXI_SEQ_NBR := null; MESSAGE.SET_MSG_TEXT('TST1', 1, 'XXXX', :TXI_SEQ_NBR, 'fr', 'French note'); &eh
-- TXT-0002: Unknown text type

execute :TXI_SEQ_NBR := null; MESSAGE.SET_MSG_TEXT('TST1', 1, 'MSG', :TXI_SEQ_NBR, 'fr', 'French note'); &eh
-- TXT-0008: Only one text item of this type allowed

execute :TXI_SEQ_NBR := 1; MESSAGE.SET_MSG_TEXT('TST2', 1, 'NOTE', :TXI_SEQ_NBR, 'fr', 'French note'); &eh
-- TXT-0009: No existing text of this type

execute :TXI_SEQ_NBR := 9; MESSAGE.SET_MSG_TEXT('TST1', 1, 'NOTE', :TXI_SEQ_NBR, 'fr', 'French note'); &eh
-- TXT-0010: Text item sequence number greater than current maximum

execute :TXI_SEQ_NBR := null; MESSAGE.SET_MSG_TEXT('TST1', 1, 'NOTE', :TXI_SEQ_NBR, 'en', ''); &eh
-- TXT-0001: Text must be specified

execute :TXI_SEQ_NBR := 1; MESSAGE.SET_MSG_TEXT('XXX', 1, 'NOTE', :TXI_SEQ_NBR, 'fr', 'Updated note'); &eh
-- ORA-01403: no data found

execute :TXI_SEQ_NBR := 1; MESSAGE.SET_MSG_TEXT('TST1', 9, 'NOTE', :TXI_SEQ_NBR, 'fr', 'Updated note'); &eh
-- ORA-01403: no data found

execute :TXI_SEQ_NBR := 1; MESSAGE.SET_MSG_TEXT('TST1', 1, 'XXXX', :TXI_SEQ_NBR, 'fr', 'Updated note'); &eh
-- TXT-0002: Unknown text type

execute :TXI_SEQ_NBR := 9; MESSAGE.SET_MSG_TEXT('TST1', 1, 'NOTE', :TXI_SEQ_NBR, 'fr', 'Updated note'); &eh
-- TXT-0010: Text item sequence number greater than current maximum

execute :TXI_SEQ_NBR := 1; MESSAGE.SET_MSG_TEXT('TST1', 1, 'NOTE', :TXI_SEQ_NBR, 'xx', 'Updated note'); &eh
-- TXT-0004: Unknown text language

execute :TXI_SEQ_NBR := 1; MESSAGE.SET_MSG_TEXT('TST1', 1, 'NOTE', :TXI_SEQ_NBR, 'fr', ''); &eh
-- TXT-0001: Text must be specified

-- Remove message general text
-- ===========================

-- Error cases
-- -----------

execute MESSAGE.REMOVE_MSG_TEXT('XXX', 1, 'NOTE', 1, 'en'); &eh
-- ORA-01403: no data found

execute MESSAGE.REMOVE_MSG_TEXT('TST1', 9, 'NOTE', 1, 'en'); &eh
-- ORA-01403: no data found

execute MESSAGE.REMOVE_MSG_TEXT('TST1', 1, null); &eh
-- MSG-0011: Text type must be specified

execute MESSAGE.REMOVE_MSG_TEXT('TST1', 1, 'XXXX', 1, 'en'); &eh
-- ORA-01403: no data found

execute MESSAGE.REMOVE_MSG_TEXT('TST1', 1, 'NOTE', 9, 'en'); &eh
-- TXT-0011: No text to delete

execute MESSAGE.REMOVE_MSG_TEXT('TST1', 1, 'NOTE', 1, 'xx'); &eh
-- TXT-0011: No text to delete

execute MESSAGE.REMOVE_MSG_TEXT('TST2', 1, 'NOTE'); &eh
-- TXT-0011: No text to delete

execute MESSAGE.REMOVE_MSG_TEXT('TST1', 1, 'MSG'); &eh
-- TXT-0013: Cannot delete mandatory text type

execute MESSAGE.REMOVE_MSG_TEXT('TST1', 1, 'MSG', 1); &eh
-- TXT-0012: Cannot delete last mandatory text item

execute MESSAGE.REMOVE_MSG_TEXT('TST2', 1, 'MSG', 1, 'fr'); &eh
-- TXT-0012: Cannot delete last mandatory text item

-- Success cases
-- -------------

execute MESSAGE.REMOVE_MSG_TEXT('TST1', 1, 'NOTE', 1, 'en'); &eh
execute MESSAGE.REMOVE_MSG_TEXT('TST1', 1, 'NOTE', 1); &eh
execute MESSAGE.REMOVE_MSG_TEXT('TST1', 1, 'NOTE'); &eh

select MSG.COMP_CODE, MSG.SEQ_NBR, MSG.SEVERITY, MSG.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from MESSAGES MSG
join TEXT_ITEMS TXI
  on TXI.TXT_ID = MSG.TXT_ID
where MSG.COMP_CODE like 'TST%'
order by MSG.COMP_CODE, MSG.SEQ_NBR, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Delete messages
-- ===============

-- Error cases
-- -----------

execute MESSAGE.DELETE_MESSAGE('XXX', 1); &eh
-- MSG-0017: Message does not exist

execute MESSAGE.DELETE_MESSAGE('TST1', 9); &eh
-- MSG-0017: Message does not exist

-- Success cases
-- -------------

execute MESSAGE.DELETE_MESSAGE('TST1', 1); &eh

select MSG.COMP_CODE, MSG.SEQ_NBR, MSG.SEVERITY, MSG.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from MESSAGES MSG
join TEXT_ITEMS TXI
  on TXI.TXT_ID = MSG.TXT_ID
where MSG.COMP_CODE like 'TST%'
order by MSG.COMP_CODE, MSG.SEQ_NBR, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Display messages
-- ================

-- Success cases
-- -------------

execute MESSAGE.DISPLAY_MESSAGE('TST1', 2); &eh
execute MESSAGE.DISPLAY_MESSAGE('TST1', 3, 'Error message 2'); &eh
execute MESSAGE.DISPLAY_MESSAGE('TST1', 2, psSEVERITY => 'I'); &eh
execute SYSTEM_PARAMETER.SET_SYSTEM_PARAMETER('FALLBACK LANGUAGE', 'C', 'fr');
execute MESSAGE.DISPLAY_MESSAGE('TST1', 2); &eh
execute SYSTEM_PARAMETER.DELETE_SYSTEM_PARAMETER('FALLBACK LANGUAGE');
execute MESSAGE.DISPLAY_MESSAGE('TST1', 2); &eh
execute MESSAGE.DISPLAY_MESSAGE('TST2', 1); &eh

-- Error cases
-- -----------

execute MESSAGE.DISPLAY_MESSAGE('XXX', 1); &eh
-- XXX-0001: ** Message not found **

execute MESSAGE.DISPLAY_MESSAGE('TST1', 9, 'Dummy message'); &eh
-- TST1-0009: ** Message not found **

execute MESSAGE.DISPLAY_MESSAGE('TST1', 2, psSEVERITY => 'X'); &eh
-- TST1-0002: ** Invalid severity **

execute MESSAGE.DISPLAY_MESSAGE('TST2', 1, 'French message'); &eh
-- TST2-0001: ** English message not found **

execute MESSAGE.DISPLAY_MESSAGE('TST1', 2, 'Error message'); &eh
-- TST1-0002: ** English message mismatch **

execute SYSTEM_PARAMETER.SET_SYSTEM_PARAMETER('FALLBACK LANGUAGE', 'C', 'fr');

execute MESSAGE.DISPLAY_MESSAGE('TST1', 9, 'Dummy message'); &eh
-- TST1-0009: ** Message introuvable **

execute MESSAGE.DISPLAY_MESSAGE('TST1', 2, psSEVERITY => 'X'); &eh
-- TST1-0002: ** Sévérité invalide **

execute MESSAGE.DISPLAY_MESSAGE('TST2', 1, 'French message'); &eh
-- TST2-0001: ** Message anglais introuvable **

execute MESSAGE.DISPLAY_MESSAGE('TST1', 2, 'Error message'); &eh
-- TST1-0002: ** Disparité de message anglais **

execute SYSTEM_PARAMETER.DELETE_SYSTEM_PARAMETER('FALLBACK LANGUAGE');

set echo off serveroutput off feedback on

@check_orphan_TXT_ID

rollback;

spool off

@login
