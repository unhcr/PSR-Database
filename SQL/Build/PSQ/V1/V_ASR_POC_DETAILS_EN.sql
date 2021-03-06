CREATE or replace  VIEW
    V_ASR_POC_DETAILS_EN ( ASR_YEAR, COU_CODE_RESIDENCE, COU_NAME_RESIDENCE_EN, COU_CODE_ORIGIN, COU_NAME_ORIGIN_EN, POPULATION_TYPE_CODE, POPULATION_TYPE_EN, POPULATION_TYPE_SEQ, VALUE, REDACTED_FLAG ) AS
SELECT
    ASR_YEAR,
    COU_CODE_RESIDENCE,
    COU_NAME_RESIDENCE_EN,
    COU_CODE_ORIGIN,
    COU_NAME_ORIGIN_EN,
    SUBSTR(POPULATION_TYPE, 2, 2)            AS POPULATION_TYPE_CODE,
    SUBSTR(POPULATION_TYPE, 4)               AS POPULATION_TYPE_EN,
    to_number(SUBSTR(POPULATION_TYPE, 1, 1)) AS POPULATION_TYPE_SEQ,
    VALUE,
    REDACTED_FLAG
FROM
    V_ASR_POC_SUMMARY_EN unpivot ((VALUE, REDACTED_FLAG) FOR POPULATION_TYPE IN ((REFPOP_VALUE, REFPOP_REDACTED_FLAG) AS '1RFRefugees', (ASYPOP_VALUE, ASYPOP_REDACTED_FLAG) AS '2ASAsylum seekers', (REFRTN_VALUE, REFRTN_REDACTED_FLAG) AS '3RTReturned refugees', (IDPHPOP_VALUE, IDPHPOP_REDACTED_FLAG) AS '4IDInternally displaced persons', (IDPHRTN_VALUE, IDPHRTN_REDACTED_FLAG) AS '5RDReturned IDPs', (STAPOP_VALUE, STAPOP_REDACTED_FLAG) AS '6STStateless persons', (OOCPOP_VALUE, OOCPOP_REDACTED_FLAG) AS '7OCOthers of concern'))
	;