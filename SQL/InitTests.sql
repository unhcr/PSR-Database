variable ACT_ID number;

insert into T_TESTS (CODE, DESCRIPTION)
values ('SYP', 'Test SYSTEM_PARAMETER package');

insert into T_TESTS (CODE, DESCRIPTION, TST_CODE_PARENT, SEQ_NBR)
values ('SYP1', 'Dummy test', 'SYP', 1);

insert into T_TEST_ACTIONS (DESCRIPTION, ACTION_SCRIPT)
values ('Roll back', 'rollback')
returning ID into :ACT_ID;

insert into T_TEST_ACTION_INVOCATIONS (ACT_ID, TST_CODE, BEFORE_AFTER_FLAG, SEQ_NBR)
values (:ACT_ID, 'SYP', 'A', 1);

insert into T_TEST_STEPS (TST_CODE, SEQ_NBR, DESCRIPTION, CHECK_FLAG)
values ('SYP', 1, 'Insert character parameter', 'N');

insert into T_TEST_ACTIONS (DESCRIPTION, ACTION_SCRIPT)
values ('Save point SYP1', 'savepoint SYP1')
returning ID into :ACT_ID;

insert into T_TEST_ACTION_INVOCATIONS (ACT_ID, TST_CODE, STP_SEQ_NBR, BEFORE_AFTER_FLAG, SEQ_NBR)
values (:ACT_ID, 'SYP', 1, 'B', 1);

insert into T_TEST_ACTIONS (DESCRIPTION, ACTION_SCRIPT)
values ('Rollback to save point SYP1', 'rollback to savepoint SYP1')
returning ID into :ACT_ID;

insert into T_TEST_ACTION_INVOCATIONS (ACT_ID, TST_CODE, STP_SEQ_NBR, BEFORE_AFTER_FLAG, SEQ_NBR)
values (:ACT_ID, 'SYP', 1, 'A', 1);

insert into T_TEST_CASES (TST_CODE, STP_SEQ_NBR, PACKAGE_NAME, PROGRAM_UNIT_NAME)
values ('SYP', 1, 'P_SYSTEM_PARAMETER', 'INSERT_SYSTEM_PARAMETER');

insert into T_TEST_CASE_INPUTS (TST_CODE, STP_SEQ_NBR, PARAMETER_NAME, DATA_TYPE, CHAR_VALUE)
values ('SYP', 1, 'psCODE', 'C', 'SYP1');

insert into T_TEST_CASE_INPUTS (TST_CODE, STP_SEQ_NBR, PARAMETER_NAME, DATA_TYPE, CHAR_VALUE)
values ('SYP', 1, 'psLANG_CODE', 'C', 'en');

insert into T_TEST_CASE_INPUTS (TST_CODE, STP_SEQ_NBR, PARAMETER_NAME, DATA_TYPE, CHAR_VALUE)
values ('SYP', 1, 'psDESCRIPTION', 'C', 'Test parameter 1');

insert into T_TEST_CASE_INPUTS (TST_CODE, STP_SEQ_NBR, PARAMETER_NAME, DATA_TYPE, CHAR_VALUE)
values ('SYP', 1, 'psDATA_TYPE', 'C', 'C');

insert into T_TEST_CASE_INPUTS (TST_CODE, STP_SEQ_NBR, PARAMETER_NAME, DATA_TYPE, CHAR_VALUE)
values ('SYP', 1, 'psCHAR_VALUE', 'C', 'Character parameter');
