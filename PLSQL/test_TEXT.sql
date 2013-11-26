-- Test set-up
-- ===========

define eh = "exception when others then dbms_output.put_line('-- ' || sqlerrm)"

variable TXT_ID number
variable TXT_ID1 number
variable TXT_ID2 number
variable SEQ_NBR number
variable SEQ_NBR1 number
variable SEQ_NBR2 number

execute TEXT_TYPE.INSERT_TEXT_TYPE('INACT', 'en', 'Inactive', null, 'N');

set echo on serveroutput on feedback off recsepchar "." sqlprompt "" sqlnumber off

column LONG_TEXT format A150
column UPDATE_TIMESTAMP format A25

spool test_TEXT.log

-- Set text
-- ========

-- Success cases
-- -------------

execute :TXT_ID := null; :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, 'LANG', 'NOTE', :SEQ_NBR, 'en', 'English note 1'); :TXT_ID1 := :TXT_ID; &eh
execute :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, null, 'NOTE', :SEQ_NBR, 'en', 'English note 2'); :SEQ_NBR1 := :SEQ_NBR; &eh
execute TEXT.SET_TEXT(:TXT_ID, null, 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
execute TEXT.SET_TEXT(:TXT_ID, null, 'NOTE', :SEQ_NBR, 'es', rpad('x', 1001, unistr('\00F1'))); &eh
execute :TXT_ID := null; :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, 'LANG', 'DESCR', :SEQ_NBR, 'en', 'English description'); :TXT_ID2 := :TXT_ID; :SEQ_NBR2 := :SEQ_NBR; &eh
execute :TXT_ID := :TXT_ID1; :SEQ_NBR := :SEQ_NBR1; TEXT.SET_TEXT(:TXT_ID, 'LANG', 'NOTE', :SEQ_NBR, 'en', 'English note 2a'); &eh
execute TEXT.SET_TEXT(:TXT_ID, null, 'NOTE', :SEQ_NBR, 'en', 'English note 2b'); &eh
execute TEXT.SET_TEXT(:TXT_ID, null, 'NOTE', :SEQ_NBR, 'es', 'Spanish note 3'); &eh
execute TEXT.SET_TEXT(:TXT_ID, null, 'NOTE', :SEQ_NBR, 'fr', rpad('French note ', 1001, unistr('\8BF4'))); &eh
execute TEXT.SET_TEXT(:TXT_ID, null, 'NOTE', :SEQ_NBR, 'fr', rpad('French note ', 1001, '$')); &eh

select TXT.ID, TXT.TAB_ALIAS,
  TTH.TXTT_CODE, TTH.TAB_ALIAS, TTH.TXI_SEQ_NBR_MAX,
  TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TAB_ALIAS, TXI.UPDATE_TIMESTAMP, TXI.UPDATE_USERID, TXI.TEXT, TXI.LONG_TEXT
from TEXT_HEADERS TXT
join TEXT_TYPE_HEADERS TTH
  on TTH.TXT_ID = TXT.ID
join TEXT_ITEMS TXI
  on TXI.TXT_ID = TTH.TXT_ID
  and TXI.TXTT_CODE = TTH.TXTT_CODE
where TXT.ID >= :TXT_ID1
order by TXT.ID, TTH.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Error cases
-- -----------

execute :TXT_ID := null; :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, null, 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh
-- ORA-01400: cannot insert NULL into ("PSR"."TEXT_HEADERS"."TAB_ALIAS")

execute :TXT_ID := null; :SEQ_NBR := 1; TEXT.SET_TEXT(:TXT_ID, 'LANG', 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh
-- ORA-20002: TXT-0005: Cannot specify a text item sequence number without a text identifier

execute :TXT_ID := null; :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, 'XXXX', 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh
-- ORA-02291: integrity constraint (PSR.FK_TXT_TAB) violated - parent key not found

execute :TXT_ID := null; :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, 'LANG', 'XXXX', :SEQ_NBR, 'en', 'English note'); &eh
-- ORA-20002: TXT-0001: Unknown text type

execute :TXT_ID := null; :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, 'LANG', 'INACT', :SEQ_NBR, 'en', 'English note'); &eh
-- ORA-20002: TXT-0002: Inactive text type

execute :TXT_ID := null; :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, 'LANG', 'MSG', :SEQ_NBR, 'en', 'English message'); &eh
-- ORA-02291: integrity constraint (PSR.FK_TTH_TTP) violated - parent key not found

execute :TXT_ID := 9999999; :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, null, 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh
-- ORA-01403: no data found

execute :TXT_ID := :TXT_ID1; :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, 'LANG', 'MSG', :SEQ_NBR, 'en', 'English message'); &eh
-- ORA-02291: integrity constraint (PSR.FK_TTH_TTP) violated - parent key not found

execute :TXT_ID := :TXT_ID1; :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, 'TXTT', 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh
-- ORA-20002: TXT-0006: Wrong table for this text identifier

execute :TXT_ID := :TXT_ID1; :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, null, 'XXXX', :SEQ_NBR, 'en', 'English note'); &eh
-- ORA-20002: TXT-0001: Unknown text type

execute :TXT_ID := :TXT_ID1; :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, null, 'INACT', :SEQ_NBR, 'en', 'English note'); &eh
-- ORA-20002: TXT-0002: Inactive text type

execute :TXT_ID := :TXT_ID2; :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, null, 'DESCR', :SEQ_NBR, 'en', 'English description'); &eh
-- ORA-20002: TXT-0007: Only one text item of this type allowed

execute :TXT_ID := :TXT_ID2; :SEQ_NBR := :SEQ_NBR2; TEXT.SET_TEXT(:TXT_ID, null, 'DESCR', :SEQ_NBR, 'en', rpad('English description ', 1001, '$')); &eh
-- ORA-12899: value too large for column "PSR"."TEXT_ITEMS"."TEXT" (actual: 1001, maximum: 1000)

execute :TXT_ID := :TXT_ID2; :SEQ_NBR := :SEQ_NBR2; TEXT.SET_TEXT(:TXT_ID, null, 'DESCR', :SEQ_NBR, 'fr', rpad('French description ', 1001, '$')); &eh
-- ORA-12899: value too large for column "PSR"."TEXT_ITEMS"."TEXT" (actual: 1001, maximum: 1000)

execute :TXT_ID := :TXT_ID2; :SEQ_NBR := :SEQ_NBR2; TEXT.SET_TEXT(:TXT_ID, null, 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh
-- ORA-20002: TXT-0008: No existing text of this type

execute :TXT_ID := :TXT_ID1; :SEQ_NBR := 9; TEXT.SET_TEXT(:TXT_ID, null, 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh
-- ORA-20002: TXT-0009: Text item sequence number greater than current maximum

execute :TXT_ID := :TXT_ID1; :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, null, 'NOTE', :SEQ_NBR, 'de', 'German note'); &eh
-- ORA-20002: TXT-0003: Unknown text language

execute :TXT_ID := :TXT_ID1; :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, null, 'NOTE', :SEQ_NBR, 'la', 'Latin note'); &eh
-- ORA-20002: TXT-0004: Inactive text language

execute :TXT_ID := null; :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, 'LANG', 'NOTE', :SEQ_NBR, 'en', ''); &eh
-- ORA-06502: PL/SQL: numeric or value error

select TXT.ID, TXT.TAB_ALIAS,
  TTH.TXTT_CODE, TTH.TAB_ALIAS, TTH.TXI_SEQ_NBR_MAX,
  TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TAB_ALIAS, TXI.UPDATE_TIMESTAMP, TXI.UPDATE_USERID, TXI.TEXT, TXI.LONG_TEXT
from TEXT_HEADERS TXT
join TEXT_TYPE_HEADERS TTH
  on TTH.TXT_ID = TXT.ID
join TEXT_ITEMS TXI
  on TXI.TXT_ID = TTH.TXT_ID
  and TXI.TXTT_CODE = TTH.TXTT_CODE
where TXT.ID >= :TXT_ID1
order by TXT.ID, TTH.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Delete text
-- ===========

-- Error cases
-- -----------

execute TEXT.DELETE_TEXT(:TXT_ID1, 'NOTE', :SEQ_NBR1, 'de'); &eh
-- ORA-20002: TXT-0010: No text to delete

execute TEXT.DELETE_TEXT(:TXT_ID1, 'NOTE', 9999); &eh
-- ORA-20002: TXT-0010: No text to delete

execute TEXT.DELETE_TEXT(:TXT_ID1, 'XXXX'); &eh
-- ORA-01403: no data found

execute TEXT.DELETE_TEXT(9999999); &eh
-- ORA-20002: TXT-0010: No text to delete

execute TEXT.DELETE_TEXT(:TXT_ID2, 'DESCR', :SEQ_NBR2, 'en'); &eh
-- ORA-20002: TXT-0011: Cannot delete last mandatory text item

execute TEXT.DELETE_TEXT(:TXT_ID2, 'DESCR', :SEQ_NBR2); &eh
-- ORA-20002: TXT-0011: Cannot delete last mandatory text item

execute TEXT.DELETE_TEXT(:TXT_ID2, 'DESCR'); &eh
-- ORA-20002: TXT-0012: Cannot delete mandatory text type

execute TEXT.DELETE_TEXT(:TXT_ID1, 'NOTE', null, 'fr'); &eh
-- ORA-20002: TXT-0010: No text to delete

execute TEXT.DELETE_TEXT(:TXT_ID1, null, :SEQ_NBR1, 'fr'); &eh
-- ORA-20002: TXT-0010: No text to delete

execute TEXT.DELETE_TEXT(:TXT_ID1, null, null, 'fr'); &eh
-- ORA-20002: TXT-0010: No text to delete

execute TEXT.DELETE_TEXT(null, 'NOTE', :SEQ_NBR1, 'fr'); &eh
-- ORA-01403: no data found

execute TEXT.DELETE_TEXT(null, 'NOTE', null, 'fr'); &eh
-- ORA-01403: no data found

execute TEXT.DELETE_TEXT(null, null, :SEQ_NBR1, 'fr'); &eh
-- ORA-20002: TXT-0010: No text to delete

execute TEXT.DELETE_TEXT(null, null, null, 'fr'); &eh
-- ORA-20002: TXT-0010: No text to delete

execute TEXT.DELETE_TEXT(:TXT_ID1, null, :SEQ_NBR1); &eh
-- ORA-20002: TXT-0010: No text to delete

execute TEXT.DELETE_TEXT(null, 'NOTE', :SEQ_NBR1); &eh
-- ORA-01403: no data found

execute TEXT.DELETE_TEXT(null, null, :SEQ_NBR1); &eh
-- ORA-20002: TXT-0010: No text to delete

select TXT.ID, TXT.TAB_ALIAS,
  TTH.TXTT_CODE, TTH.TAB_ALIAS, TTH.TXI_SEQ_NBR_MAX,
  TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TAB_ALIAS, TXI.UPDATE_TIMESTAMP, TXI.UPDATE_USERID, TXI.TEXT, TXI.LONG_TEXT
from TEXT_HEADERS TXT
join TEXT_TYPE_HEADERS TTH
  on TTH.TXT_ID = TXT.ID
join TEXT_ITEMS TXI
  on TXI.TXT_ID = TTH.TXT_ID
  and TXI.TXTT_CODE = TTH.TXTT_CODE
where TXT.ID >= :TXT_ID1
order by TXT.ID, TTH.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Success cases
-- -------------

execute TEXT.DELETE_TEXT(:TXT_ID1, 'NOTE', :SEQ_NBR1, 'fr'); &eh
execute TEXT.DELETE_TEXT(:TXT_ID1, 'NOTE', :SEQ_NBR1); &eh
execute TEXT.DELETE_TEXT(:TXT_ID1, 'NOTE'); &eh
execute TEXT.DELETE_TEXT(:TXT_ID1); &eh
execute :TXT_ID := null; :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, 'LANG', 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh
execute TEXT.DELETE_TEXT(:TXT_ID); &eh
execute :TXT_ID := null; :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, 'LANG', 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh
execute :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, 'LANG', 'DESCR', :SEQ_NBR, 'en', 'English description'); &eh
execute TEXT.DELETE_TEXT(:TXT_ID, 'NOTE'); &eh
execute TEXT.DELETE_TEXT(:TXT_ID); &eh
execute :TXT_ID := :TXT_ID2; :SEQ_NBR := :SEQ_NBR2; TEXT.SET_TEXT(:TXT_ID, 'LANG', 'DESCR', :SEQ_NBR, 'fr', 'French description'); &eh
execute TEXT.DELETE_TEXT(:TXT_ID2, 'DESCR', :SEQ_NBR2, 'en'); &eh

select TXT.ID, TXT.TAB_ALIAS,
  TTH.TXTT_CODE, TTH.TAB_ALIAS, TTH.TXI_SEQ_NBR_MAX,
  TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TAB_ALIAS, TXI.UPDATE_TIMESTAMP, TXI.UPDATE_USERID, TXI.TEXT, TXI.LONG_TEXT
from TEXT_HEADERS TXT
join TEXT_TYPE_HEADERS TTH
  on TTH.TXT_ID = TXT.ID
join TEXT_ITEMS TXI
  on TXI.TXT_ID = TTH.TXT_ID
  and TXI.TXTT_CODE = TTH.TXTT_CODE
where TXT.ID >= :TXT_ID1
order by TXT.ID, TTH.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

set echo off serveroutput off feedback on recsepchar " "

@check_orphan_TXT_ID

rollback;

spool off

@login
