create or replace package body P_CONTEXT is
--
-- ========================================
-- Private global variables
-- ========================================
--
  gsCONTEXT varchar2(30);
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- SET_USERID
-- ----------------------------------------
--
  procedure SET_USERID
   (psUSERID in P_BASE.tmsUSR_USERID)
  is
  begin
    P_UTILITY.START_MODULE(sVersion || '-' || sComponent || '.SET_USERID', psUSERID);
  --
    dbms_session.set_context(gsCONTEXT, 'USERID', psUSERID);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_USERID;
--
-- ----------------------------------------
-- CLEAR_USERID
-- ----------------------------------------
--
  procedure CLEAR_USERID
  is
  begin
    P_UTILITY.START_MODULE(sVersion || '-' || sComponent || '.CLEAR_USERID');
  --
    dbms_session.clear_context(gsCONTEXT, attribute => 'USERID');
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end CLEAR_USERID;
--
-- ----------------------------------------
-- SET_COUNTRY
-- ----------------------------------------
--
  procedure SET_COUNTRY
   (pnLOC_ID_COUNTRY in P_BASE.tmnLOC_ID)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_COUNTRY', to_char(pnLOC_ID_COUNTRY));
  --
    dbms_session.set_context(gsCONTEXT, 'COUNTRY', to_char(pnLOC_ID_COUNTRY));
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_COUNTRY;
--
-- ----------------------------------------
-- CLEAR_COUNTRY
-- ----------------------------------------
--
  procedure CLEAR_COUNTRY
  is
  begin
    P_UTILITY.START_MODULE(sVersion || '-' || sComponent || '.CLEAR_COUNTRY');
  --
    dbms_session.clear_context(gsCONTEXT, attribute => 'COUNTRY');
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end CLEAR_COUNTRY;
--
-- ----------------------------------------
-- SET_CONTEXT
-- ----------------------------------------
--
  procedure SET_CONTEXT
   (psUSERID in P_BASE.tmsUSR_USERID,
    pnLOC_ID_COUNTRY in P_BASE.tnLOC_ID := null)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_CONTEXT',
      psUSERID || '~' || to_char(pnLOC_ID_COUNTRY));
  --
    dbms_session.set_context(gsCONTEXT, 'USERID', psUSERID);
  --
    if pnLOC_ID_COUNTRY is not null
    then dbms_session.set_context(gsCONTEXT, 'COUNTRY', to_char(pnLOC_ID_COUNTRY));
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_CONTEXT;
--
-- ----------------------------------------
-- CLEAR_CONTEXT
-- ----------------------------------------
--
  procedure CLEAR_CONTEXT
  is
  begin
    P_UTILITY.START_MODULE(sVersion || '-' || sComponent || '.CLEAR_CONTEXT');
  --
    dbms_session.clear_context(gsCONTEXT);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end CLEAR_CONTEXT;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sComponent != 'CTX'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'Component code mismatch');
  end if;
--
  if sVersion != 'D1.0'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
  select user
  into gsCONTEXT
  from DUAL;
--
end P_CONTEXT;
/

show errors
