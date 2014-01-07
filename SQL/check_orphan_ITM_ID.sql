select ITM_ID from T_AGE_PROFILES where ITM_ID is not null
union all
select ITM_ID from T_AGE_RANGES where ITM_ID is not null
union all
select ITM_ID from T_COMPONENTS where ITM_ID is not null
union all
select ITM_ID from T_LANGUAGES where ITM_ID is not null
union all
select ITM_ID from T_LOCATIONS where ITM_ID is not null
union all
select ITM_ID from T_LOCATION_ATTRIBUTES where ITM_ID is not null
union all
select ITM_ID from T_LOCATION_ATTRIBUTE_TYPES where ITM_ID is not null
union all
select ITM_ID from T_LOCATION_RELATIONSHIPS where ITM_ID is not null
union all
select ITM_ID from T_LOCATION_RELATIONSHIP_TYPES where ITM_ID is not null
union all
select ITM_ID from T_LOCATION_TYPES where ITM_ID is not null
union all
select ITM_ID from T_MESSAGES where ITM_ID is not null
union all
select ITM_ID from T_DISPLACEMENT_STATUSES where ITM_ID is not null
union all
select ITM_ID from T_POPULATION_PLANNING_GROUPS where ITM_ID is not null
union all
select ITM_ID from T_STATISTICS where ITM_ID is not null
union all
select ITM_ID from T_STATISTIC_GROUPS where ITM_ID is not null
union all
select ITM_ID from T_STATISTIC_TYPES where ITM_ID is not null
union all
select ITM_ID from T_STATISTIC_TYPES_IN_GROUPS where ITM_ID is not null
union all
select ITM_ID from T_TABLE_ALIASES where ITM_ID is not null
union all
select ITM_ID from T_TEXT_TYPES where ITM_ID is not null
union all
select ITM_ID from T_TEXT_TYPE_PROPERTIES where ITM_ID is not null
union all
select ITM_ID from T_TIME_PERIODS where ITM_ID is not null
union all
select ITM_ID from T_TIME_PERIOD_TYPES where ITM_ID is not null
minus
select ID from T_DATA_ITEMS
/

