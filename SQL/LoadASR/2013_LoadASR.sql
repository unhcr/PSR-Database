spool 2013_LoadASR.log

define year = 2013

@@LoadRefugeeStatistics
@@LoadDemographicsStatistics

@@LoadIDPStatistics

@@LoadOOCStatistics

@@LoadStatelessStatistics
@@LoadReturnsStatistics
@@LoadRSDStatistics

@@CreateASRTableStatisticGroups

--rollback;


spool off
