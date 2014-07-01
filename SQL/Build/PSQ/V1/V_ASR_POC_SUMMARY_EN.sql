CREATE or replace  VIEW
    V_ASR_POC_SUMMARY_EN ( ASR_YEAR, COU_CODE_RESIDENCE, COU_NAME_RESIDENCE_EN, COU_CODE_ORIGIN, COU_NAME_ORIGIN_EN, REFPOP_VALUE, REFPOP_REDACTED_FLAG, ASYPOP_VALUE, ASYPOP_REDACTED_FLAG, REFRTN_VALUE, REFRTN_REDACTED_FLAG, IDPHPOP_VALUE, IDPHPOP_REDACTED_FLAG, IDPHRTN_VALUE, IDPHRTN_REDACTED_FLAG, STAPOP_VALUE, STAPOP_REDACTED_FLAG, OOCPOP_VALUE, OOCPOP_REDACTED_FLAG ) AS
WITH
    Q_POC_SUMMARY AS
    (
        SELECT
            ASR_YEAR,
            LOC_ID_RESIDENCE,
            LOC_ID_ORIGIN,
            SUM(REFPOP_VALUE)  AS REFPOP_VALUE,
            SUM(ASYPOP_VALUE)  AS ASYPOP_VALUE,
            SUM(REFRTN_VALUE)  AS REFRTN_VALUE,
            SUM(IDPHPOP_VALUE) AS IDPHPOP_VALUE,
            SUM(IDPHRTN_VALUE) AS IDPHRTN_VALUE,
            SUM(STAPOP_VALUE)  AS STAPOP_VALUE,
            SUM(OOCPOP_VALUE)  AS OOCPOP_VALUE
        FROM
            (
                SELECT
                    ASR_YEAR,
                    DST_ID,
                    LOC_ID_RESIDENCE,
                    LOC_ID_ORIGIN,
                    REFPOP_VALUE,
                    ASYPOP_VALUE,
                    greatest(NVL(VOLREP_VALUE, REFRTN_VALUE), NVL(REFRTN_VALUE, VOLREP_VALUE)) AS REFRTN_VALUE,
                    IDPHPOP_VALUE,
                    IDPHRTN_VALUE,
                    STAPOP_VALUE,
                    OOCPOP_VALUE
                FROM
                    (
                        SELECT
                            TO_CHAR(extract(YEAR FROM STC.START_DATE)) AS ASR_YEAR,
                            STC.DST_ID,
                            CASE
                                WHEN STC.STCT_CODE IN ('VOLREP', 'REFRTN')
                                THEN STC.LOC_ID_ORIGIN_COUNTRY
                                ELSE STC.LOC_ID_ASYLUM_COUNTRY
                            END AS LOC_ID_RESIDENCE,
                            CASE
                                WHEN STC.STCT_CODE IN ('VOLREP', 'REFRTN')
                                THEN STC.LOC_ID_ASYLUM_COUNTRY
                                ELSE STC.LOC_ID_ORIGIN_COUNTRY
                            END AS LOC_ID_ORIGIN,
                            STC.STCT_CODE,
                            VALUE
                        FROM
                            T_STATISTICS STC
                        WHERE
                            extract(DAY FROM STC.END_DATE) = 1
                        AND STC.STCT_CODE IN ('REFPOP', 'ASYPOP', 'VOLREP', 'REFRTN', 'IDPHPOP', 'IDPHRTN', 'STAPOP', 'OOCPOP')
                        AND NVL(STC.DIM_ID1, -1) !=
                            (
                                SELECT
                                    ID
                                FROM
                                    T_DIMENSION_VALUES
                                WHERE
                                    DIMT_CODE = 'OFFICIAL'
                                AND CODE = 'N'
                            )
                    )
                    pivot (SUM(VALUE) AS VALUE FOR STCT_CODE IN ('REFPOP' AS REFPOP, 'ASYPOP' AS ASYPOP, 'VOLREP' AS VOLREP, 'REFRTN' AS REFRTN, 'IDPHPOP' AS IDPHPOP, 'IDPHRTN' AS IDPHRTN, 'STAPOP' AS STAPOP, 'OOCPOP' AS OOCPOP))
            )
        GROUP BY
            ASR_YEAR,
            LOC_ID_RESIDENCE,
            LOC_ID_ORIGIN
    )
    ,
    --
Q_COUNTRIES_EN AS
    (
        SELECT
            LOC.ID,
            LOCA.CHAR_VALUE AS ISO3166_ALPHA3_CODE,
            nvl(txt1.text, TXT.TEXT)        AS NAME_EN
        FROM
            T_LOCATIONS LOC
        INNER JOIN T_LOCATION_ATTRIBUTES LOCA
        ON
            LOCA.LOC_ID = LOC.ID
        AND LOCA.LOCAT_CODE = 'ISO3166A3'
        INNER JOIN T_TEXT_ITEMS TXT
        ON
            TXT.ITM_ID = LOC.ITM_ID
        AND TXT.TXTT_CODE = 'NAME'
        AND TXT.SEQ_NBR = 1
        AND TXT.LANG_CODE = 'en'
        LEFT OUTER JOIN T_TEXT_ITEMS TXT1
        ON
            TXT1.ITM_ID = loc.ITM_ID
        AND TXT1.TXTT_CODE = 'PSRNAME'
        AND TXT1.SEQ_NBR = 1
        AND TXT1.LANG_CODE = 'en'
    )
--
SELECT
    SUM.ASR_YEAR,
    CASE
        WHEN COU1.ISO3166_ALPHA3_CODE = 'XXA'
        THEN 'XXX'
        ELSE NVL(COU1.ISO3166_ALPHA3_CODE, 'XXX')
    END AS COU_CODE_RESIDENCE,
    CASE
        WHEN COU1.ISO3166_ALPHA3_CODE = 'XXA'
        THEN 'Various'
        ELSE NVL(COU1.NAME_EN, 'Various')
    END                                  AS COU_NAME_RESIDENCE_EN,
    NVL(COU2.ISO3166_ALPHA3_CODE, 'XXX') AS COU_CODE_ORIGIN,
    CASE
        WHEN COU2.NAME_EN = 'State of Palestine'
        THEN 'Palestinian'
        WHEN COU2.NAME_EN = 'Palestinian Territory, Occupied'
        THEN 'Palestinian'
        ELSE NVL(COU2.NAME_EN, 'Various')
    END AS COU_NAME_ORIGIN_EN,
    CASE
        WHEN ABS(SUM.REFPOP_VALUE) >= PAR.NUM_VALUE
         OR ASR_YEAR != '2013'
        THEN SUM.REFPOP_VALUE
    END AS REFPOP_VALUE,
    CASE
        WHEN ABS(SUM.REFPOP_VALUE) < PAR.NUM_VALUE
        AND ASR_YEAR = '2013'
        THEN 1
    END AS REFPOP_REDACTED_FLAG,
    CASE
        WHEN ABS(SUM.ASYPOP_VALUE) >= PAR.NUM_VALUE
         OR ASR_YEAR != '2013'
        THEN SUM.ASYPOP_VALUE
    END AS ASYPOP_VALUE,
    CASE
        WHEN ABS(SUM.ASYPOP_VALUE) < PAR.NUM_VALUE
        AND ASR_YEAR = '2013'
        THEN 1
    END AS ASYPOP_REDACTED_FLAG,
    CASE
        WHEN ABS(SUM.REFRTN_VALUE) >= PAR.NUM_VALUE
         OR ASR_YEAR != '2013'
        THEN SUM.REFRTN_VALUE
    END AS REFRTN_VALUE,
    CASE
        WHEN ABS(SUM.REFRTN_VALUE) < PAR.NUM_VALUE
        AND ASR_YEAR = '2013'
        THEN 1
    END AS REFRTN_REDACTED_FLAG,
    CASE
        WHEN ABS(SUM.IDPHPOP_VALUE) >= PAR.NUM_VALUE
         OR ASR_YEAR != '2013'
        THEN SUM.IDPHPOP_VALUE
    END AS IDPHPOP_VALUE,
    CASE
        WHEN ABS(SUM.IDPHPOP_VALUE) < PAR.NUM_VALUE
        AND ASR_YEAR = '2013'
        THEN 1
    END AS IDPHPOP_REDACTED_FLAG,
    CASE
        WHEN ABS(SUM.IDPHRTN_VALUE) >= PAR.NUM_VALUE
         OR ASR_YEAR != '2013'
        THEN SUM.IDPHRTN_VALUE
    END AS IDPHRTN_VALUE,
    CASE
        WHEN ABS(SUM.IDPHRTN_VALUE) < PAR.NUM_VALUE
        AND ASR_YEAR = '2013'
        THEN 1
    END AS IDPHRTN_REDACTED_FLAG,
    CASE
        WHEN ABS(SUM.STAPOP_VALUE) >= PAR.NUM_VALUE
         OR ASR_YEAR != '2013'
        THEN SUM.STAPOP_VALUE
    END AS STAPOP_VALUE,
    CASE
        WHEN ABS(SUM.STAPOP_VALUE) < PAR.NUM_VALUE
        AND ASR_YEAR = '2013'
        THEN 1
    END AS STAPOP_REDACTED_FLAG,
    CASE
        WHEN ABS(SUM.OOCPOP_VALUE) >= PAR.NUM_VALUE
         OR ASR_YEAR != '2013'
        THEN SUM.OOCPOP_VALUE
    END AS OOCPOP_VALUE,
    CASE
        WHEN ABS(SUM.OOCPOP_VALUE) < PAR.NUM_VALUE
        AND ASR_YEAR = '2013'
        THEN 1
    END AS OOCPOP_REDACTED_FLAG
FROM
    Q_POC_SUMMARY SUM
LEFT OUTER JOIN Q_COUNTRIES_EN COU1
ON
    COU1.ID = SUM.LOC_ID_RESIDENCE
LEFT OUTER JOIN Q_COUNTRIES_EN COU2
ON
    COU2.ID = SUM.LOC_ID_ORIGIN
CROSS JOIN T_SYSTEM_PARAMETERS PAR
WHERE
    PAR.CODE = 'REDACTION LIMIT';
	