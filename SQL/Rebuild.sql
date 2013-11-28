@dropall
@drop

spool Rebuild.log

purge recyclebin;

prompt StageSynonyms
prompt =============
@StageSynonyms

prompt Schema
prompt ======
@Schema

prompt Views
prompt =====
@Views

prompt Packages
prompt ========
@Packages

prompt MViews
prompt ======
@MViews

prompt Triggers
prompt ========
@Triggers

prompt InitBase
prompt ========
@InitBase

prompt LoadLanguages
prompt =============
@LoadLanguages

prompt LoadTextTypes
prompt =============
@LoadTextTypes

prompt LoadMessages
prompt ============
@LoadMessages

prompt InitParameters
prompt ==============
@InitParameters

prompt LoadDisplacementStatuses
prompt ========================
@LoadDisplacementStatuses

prompt InitSexes
prompt =========
@InitSexes

prompt InitAgeProfiles
prompt ===============
@InitAgeProfiles

prompt LoadDimensionTypes
prompt ==================
@LoadDimensionTypes

prompt LoadStatisticTypes
prompt ==================
@LoadStatisticTypes

prompt LoadStatisticGroupAttributeTypes
prompt =================================
@LoadStatisticGroupAttributeTypes

prompt LoadLocationTypes
prompt =================
@LoadLocationTypes

prompt LoadLocationAttributeTypes
prompt ==========================
@LoadLocationAttributeTypes

prompt LoadLocationRelationshipTypes
prompt =============================
@LoadLocationRelationshipTypes

prompt LoadLocationsRegions
prompt ====================
@LoadLocationsRegions

prompt LoadLocationsCountries
prompt ======================
@LoadLocationsCountries

prompt LoadLocationTypeVariants
prompt ========================
@LoadLocationTypeVariants

prompt LoadLocationsSubdivisions
prompt =========================
@LoadLocationsSubdivisions

prompt LoadLocationRelationships
prompt =========================
@LoadLocationRelationships

prompt LoadPPGs
prompt ========
@LoadPPGs

prompt LoadRefugeeStatistics
prompt =====================
@LoadRefugeeStatistics

prompt LoadDemographicsStatistics
prompt ==========================
@LoadDemographicsStatistics

prompt LoadRSDStatistics
prompt =================
@LoadRSDStatistics

prompt LoadIDPStatistics
prompt =================
@LoadIDPStatistics

prompt LoadReturnsStatistics
prompt =====================
@LoadReturnsStatistics

prompt LoadStatelessStatistics
prompt =======================
@LoadStatelessStatistics

prompt LoadOOCStatistics
prompt =================
@LoadOOCStatistics

prompt DeactivateCodes
prompt ===============
@DeactivateCodes

prompt FixKosovoPPGs
prompt =============
@FixKosovoPPGs

prompt RefreshMViews
prompt =============
@RefreshMViews.sql

--prompt InitTests
--prompt =========
--@InitTests

commit;

--execute dbms_stats.gather_schema_stats(user);

spool off
