-- Test set-up
-- ===========

define eh = "exception when others then dbms_output.put_line('-- ' || sqlerrm)"

variable VERSION_NBR number
variable SEQ_NBR number

set echo on serveroutput on feedback off recsepchar "." sqlprompt "" sqlnumber off

column LONG_TEXT format A150

spool test_LANGUAGE.log

-- Set languages
-- =============

-- Success cases
-- -------------

execute :VERSION_NBR := null; LANGUAGE.SET_LANGUAGE('de', :VERSION_NBR, 'en', 'German'); &eh
execute LANGUAGE.INSERT_LANGUAGE('eo', 'en', 'Esperanto', null, 'N'); &eh
execute LANGUAGE.INSERT_LANGUAGE('it', 'en', 'Italian', 1); &eh
execute LANGUAGE.INSERT_LANGUAGE('enm', 'en', 'Middle English', 999, 'N'); &eh
execute LANGUAGE.INSERT_LANGUAGE('nl', 'en', 'Dutch', pnDISPLAY_SEQ => 2); &eh
execute LANGUAGE.INSERT_LANGUAGE('frm', 'en', 'Middle French', psACTIVE_FLAG => 'N'); &eh
execute LANGUAGE.SET_LANGUAGE('de', :VERSION_NBR, 'en', 'German!'); &eh
execute LANGUAGE.SET_LANGUAGE('de', :VERSION_NBR, null, null, 1); &eh
execute LANGUAGE.SET_LANGUAGE('de', :VERSION_NBR, null, null, null, 'N'); &eh
execute LANGUAGE.SET_LANGUAGE('de', :VERSION_NBR, psLANG_CODE => 'en', psDescription => 'German'); &eh
execute LANGUAGE.SET_LANGUAGE('de', :VERSION_NBR, pnDISPLAY_SEQ => 2); &eh
execute LANGUAGE.SET_LANGUAGE('de', :VERSION_NBR, psACTIVE_FLAG => 'Y'); &eh
execute LANGUAGE.SET_LANGUAGE('de', :VERSION_NBR, pnDISPLAY_SEQ => null); &eh

select LANG.CODE, LANG.DISPLAY_SEQ, LANG.ACTIVE_FLAG, LANG.TXT_ID, LANG.VERSION_NBR,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from LANGUAGES LANG
join TEXT_ITEMS TXI
  on TXI.TXT_ID = LANG.TXT_ID
where LANG.CODE in ('de', 'eo', 'it', 'enm', 'nl', 'frm')
order by LANG.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Error cases
-- -----------

execute :VERSION_NBR := null; LANGUAGE.UPDATE_LANGUAGE('de', :VERSION_NBR, 'en', 'German!'); &eh
-- ORA-20002: LANG-0001: Language has been updated by another user

execute :VERSION_NBR := 1; LANGUAGE.SET_LANGUAGE('de', :VERSION_NBR, 'en', 'German!'); &eh
-- ORA-20002: LANG-0001: Language has been updated by another user

execute :VERSION_NBR := null; LANGUAGE.SET_LANGUAGE('gr', :VERSION_NBR, 'en', ''); &eh
-- ORA-06502: PL/SQL: numeric or value error

execute LANGUAGE.SET_LANGUAGE('gr', :VERSION_NBR, 'xx', 'German'); &eh
-- ORA-20002: TXT-0003: Unknown text language

execute LANGUAGE.SET_LANGUAGE('gr', :VERSION_NBR, 'la', 'German'); &eh
-- ORA-20002: TXT-0004: Inactive text language

execute LANGUAGE.SET_LANGUAGE('gr', :VERSION_NBR, 'en', 'Greek', 1e6); &eh
-- ORA-01438: value larger than specified precision allowed for this column

execute LANGUAGE.SET_LANGUAGE('gr', :VERSION_NBR, 'en', 'Greek', null, 'X'); &eh
-- ORA-02290: check constraint (PSR.CH_LANG_ACTIVE_FLAG) violated

execute LANGUAGE.SET_LANGUAGE('gr', :VERSION_NBR, 'en', 'Greek', null, 'YY'); &eh
-- ORA-12899: value too large for column "PSR"."LANGUAGES"."ACTIVE_FLAG" (actual: 2, maximum: 1)

execute :VERSION_NBR := 8; LANGUAGE.SET_LANGUAGE('de', :VERSION_NBR, 'en'); &eh
-- ORA-06502: PL/SQL: numeric or value error

execute LANGUAGE.SET_LANGUAGE('de', :VERSION_NBR, 'xx', 'German'); &eh
-- ORA-20002: TXT-0003: Unknown text language

execute LANGUAGE.SET_LANGUAGE('de', :VERSION_NBR, 'la', 'German'); &eh
-- ORA-20002: TXT-0004: Inactive text language

execute LANGUAGE.SET_LANGUAGE('de', :VERSION_NBR, null, 'German'); &eh
-- ORA-06502: PL/SQL: numeric or value error

execute LANGUAGE.SET_LANGUAGE('de', :VERSION_NBR); &eh
-- ORA-20002: LANG-0002: Nothing to be updated

execute LANGUAGE.SET_LANGUAGE('de', :VERSION_NBR, pnDISPLAY_SEQ => 1e6); &eh
-- ORA-01438: value larger than specified precision allowed for this column

execute LANGUAGE.SET_LANGUAGE('de', :VERSION_NBR, psACTIVE_FLAG => 'X'); &eh
-- ORA-02290: check constraint (PSR.CH_LANG_ACTIVE_FLAG) violated

execute LANGUAGE.SET_LANGUAGE('de', :VERSION_NBR, psACTIVE_FLAG => 'YY'); &eh
-- ORA-12899: value too large for column "PSR"."LANGUAGES"."ACTIVE_FLAG" (actual: 2, maximum: 1)

-- Set language descriptions
-- =========================

-- Success cases
-- -------------

execute LANGUAGE.SET_LANG_DESCRIPTION('de', :VERSION_NBR, 'fr', 'German'); &eh
execute LANGUAGE.SET_LANG_DESCRIPTION('de', :VERSION_NBR, 'fr', 'Allemand'); &eh

select LANG.CODE, LANG.DISPLAY_SEQ, LANG.ACTIVE_FLAG, LANG.TXT_ID, LANG.VERSION_NBR,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from LANGUAGES LANG
join TEXT_ITEMS TXI
  on TXI.TXT_ID = LANG.TXT_ID
where LANG.CODE = 'de'
order by LANG.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Error cases
-- -----------

execute :VERSION_NBR := null; LANGUAGE.SET_LANG_DESCRIPTION('de', :VERSION_NBR, 'de', 'Deutsch'); &eh
-- ORA-20002: LANG-0001: Language has been updated by another user

execute :VERSION_NBR := 10; LANGUAGE.SET_LANG_DESCRIPTION('de', :VERSION_NBR, 'xx', 'German'); &eh
-- ORA-20002: TXT-0003: Unknown text language

execute LANGUAGE.SET_LANG_DESCRIPTION('de', :VERSION_NBR, 'la', 'Latin German'); &eh
-- ORA-20002: TXT-0004: Inactive text language

execute LANGUAGE.SET_LANG_DESCRIPTION('xx', :VERSION_NBR, 'en', 'Language'); &eh
-- ORA-01403: no data found

execute LANGUAGE.SET_LANG_DESCRIPTION('de', :VERSION_NBR, 'ru', ''); &eh
-- ORA-06502: PL/SQL: numeric or value error

-- Remove language descriptions
-- ============================

-- Error cases
-- -----------

execute :VERSION_NBR := 1; LANGUAGE.REMOVE_LANG_DESCRIPTION('de', :VERSION_NBR, 'fr'); &eh
-- ORA-20002: LANG-0001: Language has been updated by another user

execute LANGUAGE.REMOVE_LANG_DESCRIPTION('xx', :VERSION_NBR, 'fr'); &eh
-- ORA-01403: no data found

execute :VERSION_NBR := 1; LANGUAGE.REMOVE_LANG_DESCRIPTION('it', :VERSION_NBR, 'en'); &eh
-- ORA-20002: TXT-0011: Cannot delete last mandatory text item

execute :VERSION_NBR := 10; LANGUAGE.REMOVE_LANG_DESCRIPTION('de', :VERSION_NBR, 'xx'); &eh
-- ORA-20002: TXT-0010: No text to delete

-- Success cases
-- -------------

execute LANGUAGE.REMOVE_LANG_DESCRIPTION('de', :VERSION_NBR, 'fr'); &eh

select LANG.CODE, LANG.DISPLAY_SEQ, LANG.ACTIVE_FLAG, LANG.TXT_ID, LANG.VERSION_NBR,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from LANGUAGES LANG
join TEXT_ITEMS TXI
  on TXI.TXT_ID = LANG.TXT_ID
where LANG.CODE = 'de'
order by LANG.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Set language text
-- =================

-- Success cases
-- -------------

execute LANGUAGE.SET_LANG_TEXT('de', :VERSION_NBR, 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh
execute LANGUAGE.SET_LANG_TEXT('de', :VERSION_NBR, 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
execute :SEQ_NBR := null; LANGUAGE.SET_LANG_TEXT('de', :VERSION_NBR, 'NOTE', :SEQ_NBR, 'es', 'New Spanish note'); &eh
execute :SEQ_NBR := 1; LANGUAGE.SET_LANG_TEXT('de', :VERSION_NBR, 'NOTE', :SEQ_NBR, 'fr', 'Updated French note'); &eh
execute :SEQ_NBR := 2; LANGUAGE.SET_LANG_TEXT('de', :VERSION_NBR, 'NOTE', :SEQ_NBR, 'es', 'Updated Spanish note'); &eh
execute :SEQ_NBR := 2; LANGUAGE.SET_LANG_TEXT('de', :VERSION_NBR, 'NOTE', :SEQ_NBR, 'es', rpad('Updated Spanish note ', 1001, unistr('\00F1'))); &eh

select LANG.CODE, LANG.DISPLAY_SEQ, LANG.ACTIVE_FLAG, LANG.TXT_ID, LANG.VERSION_NBR,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from LANGUAGES LANG
join TEXT_ITEMS TXI
  on TXI.TXT_ID = LANG.TXT_ID
where LANG.CODE = 'de'
order by LANG.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Error cases
-- -----------

execute :VERSION_NBR := 1; LANGUAGE.SET_LANG_TEXT('de', :VERSION_NBR, 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh
-- ORA-20002: LANG-0001: Language has been updated by another user

execute :VERSION_NBR := 17; :SEQ_NBR := null; LANGUAGE.SET_LANG_TEXT('de', :VERSION_NBR, 'NOTE', :SEQ_NBR, 'xx', 'Unknown note'); &eh
-- ORA-20002: TXT-0003: Unknown text language

execute :SEQ_NBR := null; LANGUAGE.SET_LANG_TEXT('de', :VERSION_NBR, 'NOTE', :SEQ_NBR, 'la', 'Latin note'); &eh
-- ORA-20002: TXT-0004: Inactive text language

execute :SEQ_NBR := null; LANGUAGE.SET_LANG_TEXT('xx', :VERSION_NBR, 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
-- ORA-01403: no data found

execute :SEQ_NBR := null; LANGUAGE.SET_LANG_TEXT('de', :VERSION_NBR, 'XXXX', :SEQ_NBR, 'fr', 'French note'); &eh
-- ORA-20002: TXT-0001: Unknown text type

execute :SEQ_NBR := null; LANGUAGE.SET_LANG_TEXT('de', :VERSION_NBR, 'DESCR', :SEQ_NBR, 'fr', 'French note'); &eh
-- ORA-20002: TXT-0007: Only one text item of this type allowed

execute :VERSION_NBR := 1; :SEQ_NBR := 1; LANGUAGE.SET_LANG_TEXT('it', :VERSION_NBR, 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
-- ORA-20002: TXT-0008: No existing text of this type

execute :VERSION_NBR := 17; :SEQ_NBR := 9; LANGUAGE.SET_LANG_TEXT('de', :VERSION_NBR, 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
-- ORA-20002: TXT-0009: Text item sequence number greater than current maximum

execute :SEQ_NBR := null; LANGUAGE.SET_LANG_TEXT('de', :VERSION_NBR, 'NOTE', :SEQ_NBR, 'en', ''); &eh
-- ORA-06502: PL/SQL: numeric or value error

execute :SEQ_NBR := 1; LANGUAGE.SET_LANG_TEXT('xx', :VERSION_NBR, 'NOTE', :SEQ_NBR, 'fr', 'Updated note'); &eh
-- ORA-01403: no data found

execute :SEQ_NBR := 1; LANGUAGE.SET_LANG_TEXT('de', :VERSION_NBR, 'XXXX', :SEQ_NBR, 'fr', 'Updated note'); &eh
-- ORA-20002: TXT-0001: Unknown text type

execute :SEQ_NBR := 9; LANGUAGE.SET_LANG_TEXT('de', :VERSION_NBR, 'NOTE', :SEQ_NBR, 'fr', 'Updated note'); &eh
-- ORA-20002: TXT-0009: Text item sequence number greater than current maximum

execute :SEQ_NBR := 1; LANGUAGE.SET_LANG_TEXT('de', :VERSION_NBR, 'NOTE', :SEQ_NBR, 'xx', 'Updated note'); &eh
-- ORA-20002: TXT-0003: Unknown text language

execute :SEQ_NBR := 1; LANGUAGE.SET_LANG_TEXT('de', :VERSION_NBR, 'NOTE', :SEQ_NBR, 'fr', ''); &eh
-- ORA-06502: PL/SQL: numeric or value error

-- Remove language text
-- ====================

-- Error cases
-- -----------

execute LANGUAGE.REMOVE_LANG_TEXT('xx', :VERSION_NBR, 'NOTE', 1, 'en'); &eh
-- ORA-01403: no data found

execute LANGUAGE.REMOVE_LANG_TEXT('de', :VERSION_NBR, ''); &eh
-- ORA-06502: PL/SQL: numeric or value error

execute LANGUAGE.REMOVE_LANG_TEXT('de', :VERSION_NBR, 'XXXX', 1, 'en'); &eh
-- ORA-01403: no data found

execute LANGUAGE.REMOVE_LANG_TEXT('de', :VERSION_NBR, 'NOTE', 9, 'en'); &eh
-- ORA-20002: TXT-0010: No text to delete

execute LANGUAGE.REMOVE_LANG_TEXT('de', :VERSION_NBR, 'NOTE', 1, 'xx'); &eh
-- ORA-20002: TXT-0010: No text to delete

execute :VERSION_NBR := 1; LANGUAGE.REMOVE_LANG_TEXT('it', :VERSION_NBR, 'NOTE'); &eh
-- ORA-20002: TXT-0010: No text to delete

execute :VERSION_NBR := 6; LANGUAGE.REMOVE_LANG_TEXT('en', :VERSION_NBR, 'DESCR'); &eh
-- ORA-20002: TXT-0012: Cannot delete mandatory text type

execute :VERSION_NBR := 6; LANGUAGE.REMOVE_LANG_TEXT('fr', :VERSION_NBR, 'DESCR', 1); &eh
-- ORA-20002: TXT-0011: Cannot delete last mandatory text item

execute :VERSION_NBR := 1; LANGUAGE.REMOVE_LANG_TEXT('it', :VERSION_NBR, 'DESCR', 1, 'en'); &eh
-- ORA-20002: TXT-0011: Cannot delete last mandatory text item

-- Success cases
-- -------------

execute :VERSION_NBR := 17; LANGUAGE.REMOVE_LANG_TEXT('de', :VERSION_NBR, 'NOTE', 1, 'en'); &eh
execute LANGUAGE.REMOVE_LANG_TEXT('de', :VERSION_NBR, 'NOTE', 1); &eh
execute LANGUAGE.REMOVE_LANG_TEXT('de', :VERSION_NBR, 'NOTE'); &eh

select LANG.CODE, LANG.DISPLAY_SEQ, LANG.ACTIVE_FLAG, LANG.TXT_ID, LANG.VERSION_NBR,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from LANGUAGES LANG
join TEXT_ITEMS TXI
  on TXI.TXT_ID = LANG.TXT_ID
where LANG.CODE = 'de'
order by LANG.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Delete languages
-- ================

-- Error cases
-- -----------

execute LANGUAGE.DELETE_LANGUAGE('en', :VERSION_NBR); &eh
-- ORA-20002: LANG-0001: Language has been updated by another user

execute :VERSION_NBR := 6; LANGUAGE.DELETE_LANGUAGE('en', :VERSION_NBR); &eh
-- ORA-02292: integrity constraint (PSR.FK_TXI_LANG) violated - child record found

execute LANGUAGE.DELETE_LANGUAGE('xx', :VERSION_NBR); &eh
-- ORA-01403: no data found

-- Success cases
-- -------------

execute :VERSION_NBR := 1; LANGUAGE.DELETE_LANGUAGE('frm', :VERSION_NBR); &eh

select LANG.CODE, LANG.DISPLAY_SEQ, LANG.ACTIVE_FLAG, LANG.TXT_ID, LANG.VERSION_NBR,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from LANGUAGES LANG
join TEXT_ITEMS TXI
  on TXI.TXT_ID = LANG.TXT_ID
where LANG.CODE in ('de', 'eo', 'it', 'enm', 'nl', 'frm')
order by LANG.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

set echo off serveroutput off feedback on recsepchar " "

@check_orphan_TXT_ID

rollback;

spool off

@login
