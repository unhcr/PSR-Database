-- Table aliases
-- =============

insert into T_TABLE_ALIASES (ALIAS, TABLE_NAME)
select substr(CONSTRAINT_NAME, 4), TABLE_NAME
from USER_CONSTRAINTS
where CONSTRAINT_TYPE = 'P'
and GENERATED = 'USER NAME';


-- Initial "bootstrapping" entries in text-related tables
-- ======================================================

variable ITM_ID number;
insert into T_DATA_ITEMS (ID, TAB_ALIAS) values (ITM_SEQ.nextval, 'TXTT') returning ID into :ITM_ID;
insert into T_TEXT_TYPES (CODE, ITM_ID) values ('DESCR', ITM_SEQ.currval);
insert into T_TEXT_TYPE_PROPERTIES (TXTT_CODE, TAB_ALIAS, MANDATORY_FLAG, MULTI_INSTANCE_FLAG, LONG_TEXT_FLAG) values ('DESCR', 'TXTT', 'Y', 'N', 'N');
insert into T_TEXT_TYPE_PROPERTIES (TXTT_CODE, TAB_ALIAS, MANDATORY_FLAG, MULTI_INSTANCE_FLAG, LONG_TEXT_FLAG) values ('DESCR', 'LANG', 'Y', 'N', 'N');
insert into T_TEXT_TYPE_HEADERS (ITM_ID, TXTT_CODE, TAB_ALIAS, TXT_SEQ_NBR_MAX) values (ITM_SEQ.currval, 'DESCR', 'TXTT', 1);
insert into T_DATA_ITEMS (ID, TAB_ALIAS) values (ITM_SEQ.nextval, 'LANG');
insert into T_TEXT_TYPE_HEADERS (ITM_ID, TXTT_CODE, TAB_ALIAS, TXT_SEQ_NBR_MAX) values (ITM_SEQ.currval, 'DESCR', 'LANG', 1);
insert into T_LANGUAGES (CODE, DISPLAY_SEQ, ITM_ID) values ('en', 1, ITM_SEQ.currval);
insert into T_TEXT_ITEMS (ITM_ID, TXTT_CODE, SEQ_NBR, LANG_CODE, TAB_ALIAS, TEXT) values (:ITM_ID, 'DESCR', 1, 'en', 'TXTT', 'Description');
insert into T_TEXT_ITEMS (ITM_ID, TXTT_CODE, SEQ_NBR, LANG_CODE, TAB_ALIAS, TEXT) values (ITM_SEQ.currval, 'DESCR', 1, 'en', 'LANG', 'English');

-- Languages
-- =========

-- Inital record for all the UN languages (additional details added later)
begin
  P_LANGUAGE.INSERT_LANGUAGE('fr', 'en', 'French', 2);
  P_LANGUAGE.INSERT_LANGUAGE('es', 'en', 'Spanish');
  P_LANGUAGE.INSERT_LANGUAGE('ru', 'en', 'Russian');
  P_LANGUAGE.INSERT_LANGUAGE('ar', 'en', 'Arabic');
  P_LANGUAGE.INSERT_LANGUAGE('zh', 'en', 'Chinese');
end;
/
