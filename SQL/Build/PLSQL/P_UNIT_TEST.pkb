create or replace package body P_UNIT_TEST is
--
-- ========================================
-- Private program units
-- ========================================
--
-- ----------------------------------------
-- REPORT
-- ----------------------------------------
--
  procedure REPORT
   (psLabel in P_BASE.tsText,
    psDetails in P_BASE.tsText)
  is
  begin
    dbms_output.put_line('>' || lpad(psLabel, 18) || ': ' || psDetails);
  end REPORT;
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- RUN_TEST
-- ----------------------------------------
--
  procedure RUN_TEST
   (psCODE in P_BASE.tsTST_CODE)
  is
    sDESCRIPTION P_BASE.tsTST_DESCRIPTION;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.RUN_TEST', psCODE);
  --
    select DESCRIPTION into sDESCRIPTION from T_TESTS where CODE = psCODE;
  --
    REPORT('Start test', psCODE || ' - ' || sDESCRIPTION);
  --
  -- Run before actions for test.
  --
    for rACT in
     (select ACT.DESCRIPTION, ACT.ACTION_SCRIPT
      from T_TEST_ACTION_INVOCATIONS TAI
      join T_TEST_ACTIONS ACT
        on ACT.ID = TAI.ACT_ID
      where TAI.TST_CODE = psCODE
      and TAI.STP_SEQ_NBR is null
      and TAI.BEFORE_AFTER_FLAG = 'B'
      order by TAI.SEQ_NBR)
    loop
      REPORT('Before test', rACT.DESCRIPTION);
      execute immediate rACT.ACTION_SCRIPT;
    end loop;
  --
  -- Run all steps within the test.
  --
    for rSTP in
     (select SEQ_NBR, DESCRIPTION, CHECK_FLAG
      from T_TEST_STEPS
      where TST_CODE = psCODE
      order by SEQ_NBR)
    loop
      REPORT('Start test step', psCODE || '/' || rSTP.SEQ_NBR || ' - ' || rSTP.DESCRIPTION);
    --
      if rSTP.CHECK_FLAG = 'N'
      then RUN_TEST_CASE(psCODE, rSTP.SEQ_NBR);
      end if;
    --
      REPORT('End test step', psCODE || '/' || rSTP.SEQ_NBR || ' - ' || rSTP.DESCRIPTION);
    end loop;
  --
  -- Recursively run all sub-tests.
  --
    for rTST in
     (select CODE from T_TESTS where TST_CODE_PARENT = psCODE order by SEQ_NBR)
    loop
      RUN_TEST(rTST.CODE);
    end loop;
  --
  -- Run after actions for test.
  --
    for rACT in
     (select ACT.DESCRIPTION, ACT.ACTION_SCRIPT
      from T_TEST_ACTION_INVOCATIONS TAI
      join T_TEST_ACTIONS ACT
        on ACT.ID = TAI.ACT_ID
      where TAI.TST_CODE = psCODE
      and TAI.STP_SEQ_NBR is null
      and TAI.BEFORE_AFTER_FLAG = 'A'
      order by TAI.SEQ_NBR)
    loop
      REPORT('After test', rACT.DESCRIPTION);
      execute immediate rACT.ACTION_SCRIPT;
    end loop;
  --
    REPORT('End test', psCODE || ' - ' || sDESCRIPTION);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end RUN_TEST;
--
-- ----------------------------------------
-- RUN_TEST_CASE
-- ----------------------------------------
--
  procedure RUN_TEST_CASE
   (psTST_CODE in P_BASE.tsTST_CODE,
    pnSEQ_NBR in P_BASE.tsSTP_SEQ_NBR)
  is
    sStatement varchar2(32000);
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.RUN_TEST_CASE', psTST_CODE || '~' || to_char(pnSEQ_NBR));
/*
  --
  -- Construct procedure call for test case.
  --
    select ltrim(TCS.PACKAGE_NAME || '.', '.') || TCS.PROGRAM_UNIT_NAME ||
        case
          when count(TCI.PARAMETER_NAME) > 0
          then '(' ||
              listagg
               (TCI.PARAMETER_NAME || '=>' ||
                  case TCI.DATA_TYPE
                    when 'C' then '''' || replace(TCI.CHAR_VALUE, '''', '''''') || ''''
                    when 'N' then to_char(TCI.NUM_VALUE)
                    when 'D'
                    then 'timestamp ''' || to_char(TCI.DATE_VALUE, 'YYYY-MM-DD HH24:MI:SS') || ''''
                  end,
                ', ') within group (order by ARG.POSITION) || ')'
        end || ';'
    into sStatement
    from T_TEST_CASES TCS
    left outer join T_TEST_CASE_INPUTS TCI
      on TCI.TST_CODE = TCS.TST_CODE
      and TCI.STP_SEQ_NBR = TCS.STP_SEQ_NBR
    left outer join USER_ARGUMENTS ARG
      on ARG.PACKAGE_NAME = TCS.PACKAGE_NAME
      and ARG.OBJECT_NAME = TCS.PROGRAM_UNIT_NAME
      and ARG.ARGUMENT_NAME = upper(TCI.PARAMETER_NAME)
    where TCS.TST_CODE = psTST_CODE
    and TCS.STP_SEQ_NBR = pnSEQ_NBR
    group by TCS.PACKAGE_NAME, TCS.PROGRAM_UNIT_NAME;
*/
  --
    REPORT('Start test case', psTST_CODE || '/' || to_char(pnSEQ_NBR));
  --
  -- Run before actions for test case.
  --
    for rACT in
     (select ACT.DESCRIPTION, ACT.ACTION_SCRIPT
      from T_TEST_ACTION_INVOCATIONS TAI
      join T_TEST_ACTIONS ACT
        on ACT.ID = TAI.ACT_ID
      where TAI.TST_CODE = psTST_CODE
      and TAI.STP_SEQ_NBR = pnSEQ_NBR
      and TAI.BEFORE_AFTER_FLAG = 'B'
      order by TAI.SEQ_NBR)
    loop
      REPORT('Before test case', rACT.DESCRIPTION);
      execute immediate rACT.ACTION_SCRIPT;
    end loop;
  --
  -- Example dynamic SQL procedure call.
  --
    declare
      sStatement varchar2(1000) := 'begin :1 := dbms_random.string(''U'', :2); end;';
      hCur integer;
      s varchar2(1000 byte);
      n number;
      dummy integer;
    begin
      hCur := dbms_sql.open_cursor;
      dbms_sql.parse(hCur, sStatement, dbms_sql.native);
      dbms_sql.bind_variable(hCur, '1', s, 1000);
      n := 5;
      dbms_sql.bind_variable(hCur, '2', n);
      dummy := dbms_sql.execute(hCur);
      dbms_sql.variable_value(hCur, '1', s);
      dbms_output.put_line('>' || s || '<');
      n := 10;
      dbms_sql.bind_variable(hCur, '2', n);
      dummy := dbms_sql.execute(hCur);
      dbms_sql.variable_value(hCur, '1', s);
      dbms_output.put_line('>' || s || '<');
      dbms_sql.close_cursor(hCur);
    end;
  --
  -- Run the test case program unit.
  --
    declare
      sPACKAGE_NAME P_BASE.tnTCS_PACKAGE_NAME;
      sPROGRAM_UNIT_NAME P_BASE.tnTCS_PROGRAM_UNIT_NAME;
      nEXCEPTION_NBR P_BASE.tnTCS_EXCEPTION_NBR;
      sCOMP_CODE P_BASE.tsCOMP_CODE;
      nMSG_SEQ_NBR P_BASE.tnMSG_SEQ_NBR;
      sVARIABLE_NAME P_BASE.tsTCS_VARIABLE_NAME;
      sCHAR_VALUE P_BASE.tsTCS_CHAR_VALUE;
      nNUM_VALUE P_BASE.tnTCS_NUM_VALUE;
      dDATE_VALUE P_BASE.tdTCS_DATE_VALUE;
    begin
    --
    -- Get details of procedure or function to be called and expected return value or exception.
    --
      select PACKAGE_NAME, PROGRAM_UNIT_NAME,
        EXCEPTION_NBR, COMP_CODE, MSG_SEQ_NBR,
        VARIABLE_NAME, CHAR_VALUE, NUM_VALUE, DATE_VALUE
      into sPACKAGE_NAME, sPROGRAM_UNIT_NAME,
        nEXCEPTION_NBR, sCOMP_CODE, nMSG_SEQ_NBR,
        sVARIABLE_NAME, sCHAR_VALUE, nNUM_VALUE, dDATE_VALUE
      from T_TEST_CASES
      where TST_CODE = psTST_CODE
      and STP_SEQ_NBR = pnSEQ_NBR;
    --
    -- 1. Validate the test case and construct the procedure call statement and list of bind variables, input values and output check values
    --
      for rARG in
       (select ARG.OVERLOAD, ARG.POSITION, TCA.PARAMETER_NAME
        from USER_ARGUMENTS ARG
        full outer join T_TEST_CASE_ARGUMENTS TCA
          on TCA.TST_CODE = psTST_CODE
          and TCA.STP_SEQ_NBR = pnSEQ_NBR
          and TCA.PARAMETER_NAME = ARG.ARGUMENT_NAME
        where (ARG.PACKAGE_NAME = sPACKAGE_NAME
          or (sPACKAGE_NAME is null
            and ARG.PACKAGE_NAME is null))
        and ARG.OBJECT_NAME = sPROGRAM_UNIT_NAME
        order by ARG.SEQUENCE)
      loop
        if rARG.OVERLOAD is not null
        then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 999, 'Cannot test overloaded program units');
        end if;
      --
        if rARG.DATA_TYPE not in ('CHAR','CLOB','DATE','NUMBER','VARCHAR2')
        then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 999, 'Can only test program units with character, numeric or date parameters');
        end if;
      --
        if rARG.POSITION = 0
        then
        --
        -- Function return value
        --
        end if;
      end loop;
    exception
    end;
/*
  --
  -- Run the test case program unit.
  --
    declare
      sObjectName varchar2(197);
      nEXCEPTION_NBR P_BASE.tnTCS_EXCEPTION_NBR;
      sCOMP_CODE P_BASE.tsCOMP_CODE;
      nMSG_SEQ_NBR P_BASE.tnMSG_SEQ_NBR;
      sVARIABLE_NAME P_BASE.tsTCS_VARIABLE_NAME;
      sCHAR_VALUE P_BASE.tsTCS_CHAR_VALUE;
      nNUM_VALUE P_BASE.tnTCS_NUM_VALUE;
      dDATE_VALUE P_BASE.tdTCS_DATE_VALUE;
    --
      anOverload dbms_describe.number_table;
      anPosition dbms_describe.number_table;
      anLevel dbms_describe.number_table;
      anArgumentName dbms_describe.varchar2_table;
      anDataType dbms_describe.number_table;
      anDefaultValue dbms_describe.number_table;
      anInOut dbms_describe.number_table;
      anLength dbms_describe.number_table;
      anPrecision dbms_describe.number_table;
      anScale dbms_describe.number_table;
      anRadix dbms_describe.number_table;
      anSpare dbms_describe.number_table;
    --
      tasVARIABLE_NAME table of P_BASE.tsTCS_VARIABLE_NAME;
      asVARIABLE_NAME tasVARIABLE_NAME;
    begin
      select ltrim(PACKAGE_NAME || '.', '.') || PROGRAM_UNIT_NAME,
        EXCEPTION_NBR, COMP_CODE, MSG_SEQ_NBR,
        VARIABLE_NAME, CHAR_VALUE, NUM_VALUE, DATE_VALUE
      into sObjectName,
        nEXCEPTION_NBR, sCOMP_CODE, nMSG_SEQ_NBR,
        sVARIABLE_NAME, sCHAR_VALUE, nNUM_VALUE, dDATE_VALUE
      from T_TEST_CASES
      where TST_CODE = psTST_CODE
      and STP_SEQ_NBR = pnSEQ_NBR;
    --
      dbms_describe.describe_procedure
       (sObjectName, null, null,
        anOverload, anPosition, anLevel, anArgumentName, anDataType, anDefaultValue, anInOut,
        anLength, anPrecision, anScale, anRadix, anSpare);
    --
    -- The following code is written on the assumption that dbms_describe.describe_procedure returns
    --  its level 0 data ordered by position (within overload number). Although the documentation
    --  does not explicitly say that this will always be so, it always seems to be the case in
    --  practice and it makes sense. If this behaviour changes in future, the code will break and
    --  will need to be rewritten in a more complex manner. Note that this code only supports scalar
    --  data types, so the order in which non-level 0 data is ordered is of no concern.
    --
    -- 1. Validate the test case and construct the procedure call statement and list of bind variables, input values and output check values
    --
      for i in 1 .. anOverload.count
      loop
        if anOverload(i) > 1
        then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 999, 'Cannot test overloaded program units');
        end if;
      --
        if i > 1 and anPosition(i) != anPosition(i-1) + 1
        then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 999, 'Parameter out of order');
        end if;
      --
        if anDataType(i) not in (0, 1, 2, 3, 8, 12, 96, 112)
        then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 999, 'Can only test program units with character, numeric or date parameters');
        end if;
      --
        if anDataType != 0
        then
          if anPosition(i) = 0
          then
          --
          -- Function return value.
          --
            case anDataType(i)
              when 2 then anNUM_VALUE(i) := nNUM_VALUE;  -- number, integer, smallint, real, float, decimal
              when 3 then anNUM_VALUE(i) := nNUM_VALUE;  -- binary_integer, pls_integer, positive, natural
              when 12 then adDATE_VALUE(i) := dDATE_VALUE;  -- date
              else asCHAR_VALUE(i) := sCHAR_VALUE;  -- Character types
            end case;
          else
          --
          -- Procedure/function parameters.
          --
            if i = 1
            then
            --
            -- First parameter is not a function return value, so this is a procedure not a function.
            -- Check that a function return value test has not been specified.
            --
              if sCHAR_VALUE is not null or nNUM_VALUE is not null or dDATE_VALUE is not null
              then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 999, 'Cannot test the return value of a procedure');
              end if;
            end if;
          --
            declare
              sVARIABLE_NAME P_BASE.tsTCA_VARIABLE_NAME;
              sCHAR_VALUE_IN P_BASE.tsTCA_CHAR_VALUE_IN;
              sCHAR_VALUE_OUT P_BASE.tsTCA_CHAR_VALUE_OUT;
              nNUM_VALUE_IN P_BASE.tnTCA_NUM_VALUE_IN;
              nNUM_VALUE_OUT P_BASE.tnTCA_NUM_VALUE_OUT;
              dDATE_VALUE_IN P_BASE.tdTCA_DATE_VALUE_IN;
              dDATE_VALUE_OUT P_BASE.tdTCA_DATE_VALUE_OUT;
            begin
              select VARIABLE_NAME,
                 CHAR_VALUE_IN, CHAR_VALUE_OUT.
                 NUM_VALUE_IN, NUM_VALUE_OUT,
                 DATE_VALUE_IN, DATE_VALUE_OUT
              into sVARIABLE_NAME,
                sCHAR_VALUE_IN, sCHAR_VALUE_OUT.
                nNUM_VALUE_IN, nNUM_VALUE_OUT,
                dDATE_VALUE_IN, dDATE_VALUE_OUT
              from T_TEST_CASE_ARGUMENTS
              where TST_CODE = psTST_CODE
              and STP_SEQ_NBR = pnSEQ_NBR
              and PARAMETER_NAME = anArgumentName(i);
            exception
              when NO_DATA_FOUND
              then if anInOut = 0 and anDefaultValue = 0
                then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 999, 'Parameter ' || anArgumentName(i) || ' is mandatory');
                end if;
            end;
          end if;
        end if;
      end loop;
    --
    -- 2. initialise and bind the variables
    --
    -- 3. Execute the procedure call, catching any exceptions
    --
    -- 4. Check the returned/output values and ensure preservation of variables
    --
    end;
  --
    REPORT('Test case', sStatement);
    declare
      hCursor integer;
      nRows integer;
    begin
      hCursor := dbms_sql.open_cursor;
      dbms_sql.parse(hCursor, 'begin ' || sStatement || ' end;', dbms_sql.native);
      nRows := dbms_sql.execute(hCursor);
      REPORT('Rows: ', to_char(nRows));
      dbms_sql.close_cursor(hCursor);
    end;
*/
  --
  -- Run after actions for test case.
  --
    for rACT in
     (select ACT.DESCRIPTION, ACT.ACTION_SCRIPT
      from T_TEST_ACTION_INVOCATIONS TAI
      join T_TEST_ACTIONS ACT
        on ACT.ID = TAI.ACT_ID
      where TAI.TST_CODE = psTST_CODE
      and TAI.STP_SEQ_NBR = pnSEQ_NBR
      and TAI.BEFORE_AFTER_FLAG = 'A'
      order by TAI.SEQ_NBR)
    loop
      REPORT('After test case', rACT.DESCRIPTION);
      execute immediate rACT.ACTION_SCRIPT;
    end loop;
  --
    REPORT('End test case', psTST_CODE || '/' || to_char(pnSEQ_NBR));
  --
    P_UTILITY.END_MODULE;
--  exception
--    when others
--    then P_UTILITY.TRACE_EXCEPTION;
  end RUN_TEST_CASE;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sModule != $$PLSQL_UNIT
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'Module name mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
  if sComponent != 'TST'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 3, 'Component code mismatch');
  end if;
--
end P_UNIT_TEST;
/

show errors
