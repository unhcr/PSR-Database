create or replace package body P_UTILITY is
--
-- ========================================
-- Private types
-- ========================================
--
-- Array of module names.
--
  type tasModuleName is
  table of varchar2(64)
  index by binary_integer;
--
-- Array of context information.
--
  type tasContext is
  table of varchar2(250)
  index by binary_integer;
--
-- ========================================
-- Private global variables
-- ========================================
--
-- Call stack arrays.
--
  gasModuleName tasModuleName;  -- Module names
  gasContext tasContext;  -- Context information
  gasTracePoint tasContext;  -- Trace points
--
  gi binary_integer := 0;  -- Call stack index
--
  gbCallStackEnabled boolean;  -- Is call stack display enabled?
  gbBacktraceEnabled boolean;  -- Is backtrace display enabled?
  gbTraceEnabled boolean;  -- Is trace display enabled?
  gsMatchString varchar2(250);  -- Filtering string for trace output
--
  gsLogDir varchar2(30);  -- Name of directory object for log file output
--
  gbTraceLogOutput boolean;  -- Should tracing output be written to the log file?
  gsTraceLogFile varchar2(255);  -- Name of trace log file
--
  ghFile utl_file.file_type;  -- Log file handle
--
  gsOperation varchar2(100);
  gdOperationStart timestamp with time zone;
--
-- ========================================
-- Private program units
-- ========================================
--
-- ----------------------------------------
-- FORMATTED_MESSAGE
-- ----------------------------------------
--
-- Return a formatted string containing the current module, trace point and context information.
--
  function FORMATTED_MESSAGE
  return varchar2
  is
  begin
    return rtrim(gasModuleName(gi) || '/' || gasTracePoint(gi) || ': ' || gasContext(gi), ': ');
  end FORMATTED_MESSAGE;
--
-- ----------------------------------------
-- OUTPUT_TRACE
-- ----------------------------------------
--
-- If trace is enabled then output a trace line either to dbms_output or the log file.
--
  procedure OUTPUT_TRACE
  is
  begin
    if gbTraceEnabled
      and FORMATTED_MESSAGE like '%' || gsMatchString || '%'
    then
      if gbTraceLogOutput
      then
        if not LOG_OPEN
        then
          OPEN_LOG(gsTraceLogFile, true);
          START_OPERATION('Tracing');
        end if;
      --
        LOG(FORMATTED_MESSAGE);
      else dbms_output.put_line(FORMATTED_MESSAGE);
      end if;
    end if;
  end OUTPUT_TRACE;
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- START_MODULE
-- ----------------------------------------
--
-- Set module name and initial context at start of module.
--
  procedure START_MODULE
   (psModuleName in varchar2,
    psContext in varchar2 := null)
  is
  begin
    dbms_application_info.read_module(gasModuleName(gi), gasTracePoint(gi));
    gi := gi + 1;
    gasModuleName(gi) := to_char(gi) || '#' || psModuleName;
    gasContext(gi) := substr(psContext, 1, 250);
    gasTracePoint(gi) := 'Entry';
    dbms_application_info.set_module(gasModuleName(gi), 'Entry');
    dbms_application_info.set_client_info(psContext);
  --
    OUTPUT_TRACE;
  end START_MODULE;
--
-- ----------------------------------------
-- END_MODULE
-- ----------------------------------------
--
-- Restore calling module name and context from stack at end of module.
--
  procedure END_MODULE
  is
  begin
    gasTracePoint(gi) := 'Exit';
    dbms_application_info.set_action('Exit');
  --
    OUTPUT_TRACE;
  --
    if gi > 0
    then gi := gi - 1;
    end if;
  --
    if gi > 0
    then dbms_application_info.set_module(gasModuleName(gi), gasTracePoint(gi));
      dbms_application_info.set_client_info(gasContext(gi));
    else dbms_application_info.set_module(gasModuleName(gi), null);
    end if;
  end END_MODULE;
--
-- ----------------------------------------
-- TRACE_POINT
-- ----------------------------------------
--
-- Output trace point information (optionally with new context information).
--
  procedure TRACE_POINT
   (psTracePoint in varchar2)
  is
  begin
    gasTracePoint(gi) := psTracePoint;
    dbms_application_info.set_action(psTracePoint);
  --
    OUTPUT_TRACE;
  end TRACE_POINT;
--
--
  procedure TRACE_POINT
   (psTracePoint in varchar2,
    psContext in varchar2)
  is
  begin
    TRACE_CONTEXT(psContext);
  --
    gasTracePoint(gi) := psTracePoint;
    dbms_application_info.set_action(psTracePoint);
  --
    OUTPUT_TRACE;
  end TRACE_POINT;
--
-- ----------------------------------------
-- TRACE_CONTEXT
-- ----------------------------------------
--
-- Set tracing context with no output of trace information.
--
  procedure TRACE_CONTEXT
   (psContext in varchar2)
  is
  begin
    gasContext(gi) := substr(psContext, 1, 250);
    dbms_application_info.set_client_info(psContext);
  end TRACE_CONTEXT;
--
-- ----------------------------------------
-- TRACE_EXCEPTION
-- ----------------------------------------
--
-- Handle an exception in a procedure or function with tracing.
--
-- The exception is re-raised with call stack and backtrace information optionally appended. The
-- exception message consists of up to three parts:
--  - The error code and description are obtained from dbms_utility.format_error_stack. If the
--    exception is not a native Oracle error, i.e. it is raised by raise_application_error in
--    P_MESSAGES.DISPLAY_MESSAGE (sqlcode = -20000) or by the re-raising of an exception (sqlcode =
--    -20001), then the first 12 characters of the message are stripped off, leaving the error code
--    and message as originally formulated.
--  - Call stack information (if enabled) is obtained from dbms_utility.format_error_backtrace. If
--    this is an exception raised by a call to P_MESSAGES.DISPLAY_MESSAGE (sqlcode = -20000), the
--    first line on the call stack (relating to the call to P_MESSAGES.DISPLAY_MESSAGE) is removed.
--    If this is a re-raised exception (sqlcode = -20001), the first two lines on the call stack
--    (relating to the call to P_UTILITY.TRACE_EXCEPTION ... ) are removed. Note that the ORA-06512
--    error code string is removed from the call stack as it adds no useful information.
--  - The current module tracing information (if backtrace is enabled), which is then popped off the
--    stack.
--
  procedure TRACE_EXCEPTION
  is
    sMessage varchar2(2048) :=
      substr
       (case sqlcode
          when -20001
          then substr(dbms_utility.format_error_stack, 12) ||
            case
              when gbCallStackEnabled
              then regexp_replace(replace(dbms_utility.format_error_backtrace, 'ORA-06512: ', ''),
                                  '^.*' || chr(10) || '.*' || chr(10), '')
            end || case when gbBacktraceEnabled then FORMATTED_MESSAGE end
          when -20000
          then substr(dbms_utility.format_error_stack, 12) ||
            case
              when gbCallStackEnabled
              then regexp_replace(replace(dbms_utility.format_error_backtrace, 'ORA-06512: ', ''),
                                  '^.*' || chr(10), '')
            end || case when gbBacktraceEnabled then FORMATTED_MESSAGE end
          else dbms_utility.format_error_stack ||
            case
              when gbCallStackEnabled
              then replace(dbms_utility.format_error_backtrace, 'ORA-06512: ', '')
            end || case when gbBacktraceEnabled then FORMATTED_MESSAGE end
        end, 1, 2048);
  begin
    END_MODULE;
  --
    raise_application_error(-20001, sMessage);
  end TRACE_EXCEPTION;
--
-- ----------------------------------------
-- ENABLE_CALL_STACK
-- ----------------------------------------
--
-- Enable display of call stack in exceptions.
--
  procedure ENABLE_CALL_STACK
  is
  begin
    gbCallStackEnabled := true;
  end ENABLE_CALL_STACK;
--
-- ----------------------------------------
-- DISABLE_CALL_STACK
-- ----------------------------------------
--
-- Disable display of call stack in exceptions.
--
  procedure DISABLE_CALL_STACK
  is
  begin
    gbCallStackEnabled := false;
  end DISABLE_CALL_STACK;
--
-- ----------------------------------------
-- ENABLE_BACKTRACE
-- ----------------------------------------
--
-- Enable display of backtrace information in exceptions.
--
  procedure ENABLE_BACKTRACE
  is
  begin
    gbBacktraceEnabled := true;
  end ENABLE_BACKTRACE;
--
-- ----------------------------------------
-- DISABLE_BACKTRACE
-- ----------------------------------------
--
-- Disable display of backtrace information in exceptions.
--
  procedure DISABLE_BACKTRACE
  is
  begin
    gbBacktraceEnabled := false;
  end DISABLE_BACKTRACE;
--
-- ----------------------------------------
-- ENABLE_TRACE
-- ----------------------------------------
--
-- Enable continuous trace output (with optional filtering and destination parameters).
--  NB. "set serveroutput on" or similar is also required to see the output.
--
  procedure ENABLE_TRACE
   (psMatchString in varchar2 := null,
    pbLogFile in boolean := null)
  is
  begin
    gbTraceEnabled := true;
    gsMatchString := psMatchString;
  --
    if pbLogFile is not null
    then gbTraceLogOutput := pbLogFile;
    end if;
  end ENABLE_TRACE;
--
-- ----------------------------------------
-- DISABLE_TRACE
-- ----------------------------------------
--
-- Disable trace output.
--
  procedure DISABLE_TRACE
  is
  begin
    gbTraceEnabled := false;
  end DISABLE_TRACE;
--
-- ----------------------------------------
-- LOG_OPEN
-- ----------------------------------------
--
-- Test if the log file is open.
--
  function LOG_OPEN
    return boolean
  is
  begin
    return utl_file.is_open(ghFile);
  end LOG_OPEN;
--
-- ----------------------------------------
-- OPEN_LOG
-- ----------------------------------------
--
-- Open a log file, written to the server directory indicated by the designated directory object.
--
  procedure OPEN_LOG
   (psFileName in varchar2,
    pbAppend boolean := false)
  is
  begin
    if pbAppend
    then
      begin
        ghFile := utl_file.fopen(gsLogDir, psFileName, 'a');
      exception
        when utl_file.invalid_operation
        then ghFile := utl_file.fopen(gsLogDir, psFileName, 'w');
      end;
    else ghFile := utl_file.fopen(gsLogDir, psFileName, 'w');
    end if;
  end OPEN_LOG;
--
-- ----------------------------------------
-- CLOSE_LOG
-- ----------------------------------------
--
-- Close the currently open log file.
--
  procedure CLOSE_LOG
  is
  begin
    utl_file.fclose(ghFile);
  end CLOSE_LOG;
--
-- ----------------------------------------
-- LOG
-- ----------------------------------------
--
-- Write a message line to the currently open log file.
--
  procedure LOG
   (psMessage in varchar2)
  is
  begin
    utl_file.put_line(ghFile, psMessage);
    utl_file.fflush(ghFile);
  end LOG;
--
-- ----------------------------------------
-- START_OPERATION
-- ----------------------------------------
--
-- Record the start of a timed operation in the currently open log file.
--
  procedure START_OPERATION
   (psOperation in varchar2)
  is
  begin
    gsOperation := psOperation;
    gdOperationStart := systimestamp;
  --
    utl_file.put_line(ghFile,
                      to_char(gdOperationStart, 'YYYY/MM/DD HH24:MI:SS.FF3') || '> ' ||
                        gsOperation || ' - Start');
    utl_file.fflush(ghFile);
  end START_OPERATION;
--
-- ----------------------------------------
-- END_OPERATION
-- ----------------------------------------
--
-- Record the end of the timed operation in the currently open log file, with optional additional
--  message.
--
  procedure END_OPERATION
   (psMessage in varchar2 := null)
  is
    dDuration interval day(2) to second(3) := systimestamp - gdOperationStart;
  begin
    utl_file.put_line(ghFile,
                      to_char(systimestamp, 'YYYY/MM/DD HH24:MI:SS.FF3') || '> ' || gsOperation ||
                        ': duration ' || to_char(dDuration) ||
                        case when psMessage is not null then ' - ' || psMessage end);
    utl_file.fflush(ghFile);
  end END_OPERATION;
--
-- ========================================
-- Initialisation
-- ========================================
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
  declare
    sDummy varchar2(1);
  begin
    select 'x'
    into sDummy
    from T_SYSTEM_PARAMETERS
    where CODE = 'DISPLAY CALL STACK'
    and CHAR_VALUE = 'Y';
  --
    gbCallStackEnabled := true;
  exception
    when NO_DATA_FOUND
    then gbCallStackEnabled := false;
  end;
--
  declare
    sDummy varchar2(1);
  begin
    select 'x'
    into sDummy
    from T_SYSTEM_PARAMETERS
    where CODE = 'DISPLAY BACKTRACE'
    and CHAR_VALUE = 'Y';
  --
    gbBacktraceEnabled := true;
  exception
    when NO_DATA_FOUND
    then gbBacktraceEnabled := false;
  end;
--
  declare
    sDummy varchar2(1);
  begin
    select 'x'
    into sDummy
    from T_SYSTEM_PARAMETERS
    where CODE = 'TRACING'
    and CHAR_VALUE = 'Y';
  --
    gbTraceEnabled := true;
  exception
    when NO_DATA_FOUND
    then gbTraceEnabled := false;
  end;
--
  declare
    sDummy varchar2(1);
  begin
    select 'x'
    into sDummy
    from T_SYSTEM_PARAMETERS
    where CODE = 'TRACE TO LOG'
    and CHAR_VALUE = 'Y';
  --
    gbTraceLogOutput := true;
  exception
    when NO_DATA_FOUND
    then gbTraceLogOutput := false;
  end;
--
  begin
    select CHAR_VALUE
    into gsLogDir
    from T_SYSTEM_PARAMETERS
    where CODE = 'LOG DIRECTORY';
  exception
    when NO_DATA_FOUND
    then gsLogDir := 'UDUMP';
  end;
--
  begin
    select CHAR_VALUE
    into gsTraceLogFile
    from T_SYSTEM_PARAMETERS
    where CODE = 'TRACE LOG FILE NAME';
  exception
    when NO_DATA_FOUND
    then gsTraceLogFile := 'trace.log';
  end;
--
end P_UTILITY;
/

show errors
