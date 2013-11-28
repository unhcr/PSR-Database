create or replace package body P_BASE is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- MIN_DATE
-- ----------------------------------------
--
  function MIN_DATE
    return tdDate
  is
  begin
    return gdMIN_DATE;
  end;
--
-- ----------------------------------------
-- MAX_DATE
-- ----------------------------------------
--
  function MAX_DATE
    return tdDate
  is
  begin
    return gdMAX_DATE;
  end;
--
-- ----------------------------------------
-- FALSE_DATE
-- ----------------------------------------
--
  function FALSE_DATE
    return tdDate
  is
  begin
    return gdFALSE_DATE;
  end;
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
  if sComponent != 'BASE'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 3, 'Component code mismatch');
  end if;
--
  select DATE_VALUE into gdMIN_DATE from T_SYSTEM_PARAMETERS where CODE = 'MINIMUM DATE';
--
  select DATE_VALUE into gdMAX_DATE from T_SYSTEM_PARAMETERS where CODE = 'MAXIMUM DATE';
--
  select DATE_VALUE into gdFALSE_DATE from T_SYSTEM_PARAMETERS where CODE = 'FALSE DATE';
--
end P_BASE;
/

show errors
