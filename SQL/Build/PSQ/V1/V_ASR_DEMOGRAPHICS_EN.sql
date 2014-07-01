CREATE or replace VIEW
    V_ASR_DEMOGRAPHICS_EN ( ASR_YEAR, COU_CODE_RESIDENCE, COU_NAME_RESIDENCE_EN, LOC_NAME_RESIDENCE_EN, F0_VALUE, F0_REDACTED_FLAG, F5_VALUE, F5_REDACTED_FLAG, F12_VALUE, F12_REDACTED_FLAG, F18_VALUE, F18_REDACTED_FLAG, F60_VALUE, F60_REDACTED_FLAG, FOTHER_VALUE, FOTHER_REDACTED_FLAG, FTOTAL_VALUE, FTOTAL_REDACTED_FLAG, M0_VALUE, M0_REDACTED_FLAG, M5_VALUE, M5_REDACTED_FLAG, M12_VALUE, M12_REDACTED_FLAG, M18_VALUE, M18_REDACTED_FLAG, M60_VALUE, M60_REDACTED_FLAG, MOTHER_VALUE, MOTHER_REDACTED_FLAG, MTOTAL_VALUE, MTOTAL_REDACTED_FLAG, TOTAL_VALUE, TOTAL_REDACTED_FLAG ) AS
WITH
    Q_DEMOGRAPHICS AS
    (
        SELECT
            ASR_YEAR,
            LOC_ID_ASYLUM_COUNTRY,
            LOC_ID_ASYLUM,
            SUM(F0_VALUE)     AS F0_VALUE,
            SUM(F5_VALUE)     AS F5_VALUE,
            SUM(F12_VALUE)    AS F12_VALUE,
            SUM(F18_VALUE)    AS F18_VALUE,
            SUM(F60_VALUE)    AS F60_VALUE,
            SUM(FOTHER_VALUE) AS FOTHER_VALUE,
            SUM(FTOTAL_VALUE) AS FTOTAL_VALUE,
            SUM(M0_VALUE)     AS M0_VALUE,
            SUM(M5_VALUE)     AS M5_VALUE,
            SUM(M12_VALUE)    AS M12_VALUE,
            SUM(M18_VALUE)    AS M18_VALUE,
            SUM(M60_VALUE)    AS M60_VALUE,
            SUM(MOTHER_VALUE) AS MOTHER_VALUE,
            SUM(MTOTAL_VALUE) AS MTOTAL_VALUE,
            SUM(TOTAL_VALUE)  AS TOTAL_VALUE
        FROM
            (
                SELECT
                    ASR_YEAR,
                    LOC_ID_ASYLUM_COUNTRY,
                    LOC_ID_ASYLUM,
                    F0_VALUE,
                    F5_VALUE,
                    F12_VALUE,
                    F18_VALUE,
                    F60_VALUE,
                    CASE
                        WHEN STCT_CODE = 'POCPOPAS'
                        THEN FOTHER_VALUE
                    END AS FOTHER_VALUE,
                    CASE
                        WHEN STCT_CODE = 'POCPOPS'
                        THEN FOTHER_VALUE
                    END AS FTOTAL_VALUE,
                    M0_VALUE,
                    M5_VALUE,
                    M12_VALUE,
                    M18_VALUE,
                    M60_VALUE,
                    CASE
                        WHEN STCT_CODE = 'POCPOPAS'
                        THEN MOTHER_VALUE
                    END AS MOTHER_VALUE,
                    CASE
                        WHEN STCT_CODE = 'POCPOPS'
                        THEN MOTHER_VALUE
                    END AS MTOTAL_VALUE,
                    CASE
                        WHEN STCT_CODE = 'POCPOPN'
                        THEN TOTAL_VALUE
                    END AS TOTAL_VALUE
                FROM
                    (
                        SELECT
                            extract(YEAR FROM STC.START_DATE) AS ASR_YEAR,
                            STC.STCT_CODE,
                            STC.LOC_ID_ASYLUM_COUNTRY,
                            STC.LOC_ID_ASYLUM,
                            STC.SEX_CODE || NVL(TO_CHAR(AGR.AGE_FROM), 'X') AS DATA_POINT,
                            STC.VALUE
                        FROM
                            T_STATISTIC_TYPES_IN_GROUPS STTIG
                        INNER JOIN T_STATISTICS STC
                        ON
                            STC.STCT_CODE = STTIG.STCT_CODE
                        LEFT OUTER JOIN T_AGE_RANGES AGR
                        ON
                            AGR.ID = STC.AGR_ID
                        WHERE
                            STTIG.STTG_CODE = 'DEMOGR'
                    )
                    pivot (SUM(VALUE) AS VALUE FOR DATA_POINT IN ('F0' AS F0, 'F5' AS F5, 'F12' AS F12, 'F18' AS F18, 'F60' AS F60, 'FX' AS FOTHER, 'M0' AS M0, 'M5' AS M5, 'M12' AS M12, 'M18' AS M18, 'M60' AS M60, 'MX' AS MOTHER, 'X' AS TOTAL))
            )
        GROUP BY
            ASR_YEAR,
            LOC_ID_ASYLUM_COUNTRY,
            LOC_ID_ASYLUM
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
    ,
    --
    Q_LOCATIONS_EN AS
    (
        SELECT
            LOC.ID,
            LOC.LOCT_CODE,
            TXT1.TEXT                 AS NAME_EN,
            NVL(TXT3.TEXT, TXT2.TEXT) AS LOCATION_TYPE_EN
        FROM
            T_LOCATIONS LOC
        INNER JOIN T_TEXT_ITEMS TXT1
        ON
            TXT1.ITM_ID = LOC.ITM_ID
        AND TXT1.TXTT_CODE = 'NAME'
        AND TXT1.SEQ_NBR = 1
        AND TXT1.LANG_CODE = 'en'
        INNER JOIN T_LOCATION_TYPES LOCT
        ON
            LOCT.CODE = LOC.LOCT_CODE
        INNER JOIN T_TEXT_ITEMS TXT2
        ON
            TXT2.ITM_ID = LOCT.ITM_ID
        AND TXT2.TXTT_CODE = 'DESCR'
        AND TXT2.SEQ_NBR = 1
        AND TXT2.LANG_CODE = 'en'
        LEFT OUTER JOIN T_LOCATION_TYPE_VARIANTS LOCTV
        ON
            LOCTV.ID = LOC.LOCTV_ID
        LEFT OUTER JOIN T_TEXT_ITEMS TXT3
        ON
            TXT3.ITM_ID = LOCTV.ITM_ID
        AND TXT3.TXTT_CODE = 'DESCR'
        AND TXT3.SEQ_NBR = 1
        AND TXT3.LANG_CODE = 'en'
    )
--
SELECT
    ASR_YEAR,
    COU_CODE_RESIDENCE,
    COU_NAME_RESIDENCE_EN,
    CASE
        WHEN LOCT_CODE = 'ADMIN0'
        THEN LOCATION_TYPE_EN
        WHEN LOC_COUNT > 1
        THEN LOC_NAME_RESIDENCE_EN || ' (' || LOCATION_TYPE_EN || ')'
        ELSE LOC_NAME_RESIDENCE_EN
    END AS LOC_NAME_RESIDENCE_EN,
    F0_VALUE,
    F0_REDACTED_FLAG,
    F5_VALUE,
    F5_REDACTED_FLAG,
    F12_VALUE,
    F12_REDACTED_FLAG,
    F18_VALUE,
    F18_REDACTED_FLAG,
    F60_VALUE,
    F60_REDACTED_FLAG,
    FOTHER_VALUE,
    FOTHER_REDACTED_FLAG,
    CASE
        WHEN COALESCE(F0_VALUE, F5_VALUE, F12_VALUE, F18_VALUE, F60_VALUE, FOTHER_VALUE, FTOTAL_VALUE) IS NOT NULL
        THEN NVL(F0_VALUE, 0) + NVL(F5_VALUE, 0) + NVL(F12_VALUE, 0) + NVL(F18_VALUE, 0) + NVL(F60_VALUE, 0) + NVL(FOTHER_VALUE, 0) + NVL(FTOTAL_VALUE, 0)
    END                                                                                                                                               AS FTOTAL_VALUE,
    COALESCE(F0_REDACTED_FLAG, F5_REDACTED_FLAG, F12_REDACTED_FLAG, F18_REDACTED_FLAG, F60_REDACTED_FLAG, FOTHER_REDACTED_FLAG, FTOTAL_REDACTED_FLAG) AS FTOTAL_REDACTED_FLAG,
    M0_VALUE,
    M0_REDACTED_FLAG,
    M5_VALUE,
    M5_REDACTED_FLAG,
    M12_VALUE,
    M12_REDACTED_FLAG,
    M18_VALUE,
    M18_REDACTED_FLAG,
    M60_VALUE,
    M60_REDACTED_FLAG,
    MOTHER_VALUE,
    MOTHER_REDACTED_FLAG,
    CASE
        WHEN COALESCE(M0_VALUE, M5_VALUE, M12_VALUE, M18_VALUE, M60_VALUE, MOTHER_VALUE, MTOTAL_VALUE) IS NOT NULL
        THEN NVL(M0_VALUE, 0) + NVL(M5_VALUE, 0) + NVL(M12_VALUE, 0) + NVL(M18_VALUE, 0) + NVL(M60_VALUE, 0) + NVL(MOTHER_VALUE, 0) + NVL(MTOTAL_VALUE, 0)
    END                                                                                                                                               AS MTOTAL_VALUE,
    COALESCE(M0_REDACTED_FLAG, M5_REDACTED_FLAG, M12_REDACTED_FLAG, M18_REDACTED_FLAG, M60_REDACTED_FLAG, MOTHER_REDACTED_FLAG, MTOTAL_REDACTED_FLAG) AS MTOTAL_REDACTED_FLAG,
    CASE
        WHEN COALESCE(F0_VALUE, F5_VALUE, F12_VALUE, F18_VALUE, F60_VALUE, FOTHER_VALUE, FTOTAL_VALUE, M0_VALUE, M5_VALUE, M12_VALUE, M18_VALUE, M60_VALUE, MOTHER_VALUE, MTOTAL_VALUE, TOTAL_VALUE) IS NOT NULL
        THEN NVL(F0_VALUE, 0) + NVL(F5_VALUE, 0) + NVL(F12_VALUE, 0) + NVL(F18_VALUE, 0) + NVL(F60_VALUE, 0) + NVL(FOTHER_VALUE, 0) + NVL(FTOTAL_VALUE, 0) + NVL(M0_VALUE, 0) + NVL(M5_VALUE, 0) + NVL(M12_VALUE, 0) + NVL(M18_VALUE, 0) + NVL(M60_VALUE, 0) + NVL(MOTHER_VALUE, 0) + NVL(MTOTAL_VALUE, 0) + NVL(TOTAL_VALUE, 0)
    END                                                                                                                                                                                                                                                                                                              AS TOTAL_VALUE,
    COALESCE(F0_REDACTED_FLAG, F5_REDACTED_FLAG, F12_REDACTED_FLAG, F18_REDACTED_FLAG, F60_REDACTED_FLAG, FOTHER_REDACTED_FLAG, FTOTAL_REDACTED_FLAG, M0_REDACTED_FLAG, M5_REDACTED_FLAG, M12_REDACTED_FLAG, M18_REDACTED_FLAG, M60_REDACTED_FLAG, MOTHER_REDACTED_FLAG, MTOTAL_REDACTED_FLAG, MTOTAL_REDACTED_FLAG) AS TOTAL_REDACTED_FLAG
FROM
    (
        SELECT
            DEM.ASR_YEAR,
            COU.ISO3166_ALPHA3_CODE AS COU_CODE_RESIDENCE,
            COU.NAME_EN             AS COU_NAME_RESIDENCE_EN,
            LOC.NAME_EN             AS LOC_NAME_RESIDENCE_EN,
            LOC.LOCT_CODE,
            LOC.LOCATION_TYPE_EN,
            COUNT(DISTINCT DEM.LOC_ID_ASYLUM) over (partition BY DEM.ASR_YEAR, COU.ISO3166_ALPHA3_CODE, LOC.NAME_EN) AS LOC_COUNT,
            CASE
                WHEN ABS(DEM.F0_VALUE) >= PAR.NUM_VALUE
                 OR DEM.ASR_YEAR != '2013'
                THEN DEM.F0_VALUE
            END AS F0_VALUE,
            CASE
                WHEN ABS(DEM.F0_VALUE) < PAR.NUM_VALUE
                AND DEM.ASR_YEAR = '2013'
                THEN 1
            END AS F0_REDACTED_FLAG,
            CASE
                WHEN ABS(DEM.F5_VALUE) >= PAR.NUM_VALUE
                 OR DEM.ASR_YEAR != '2013'
                THEN DEM.F5_VALUE
            END AS F5_VALUE,
            CASE
                WHEN ABS(DEM.F5_VALUE) < PAR.NUM_VALUE
                AND DEM.ASR_YEAR = '2013'
                THEN 1
            END AS F5_REDACTED_FLAG,
            CASE
                WHEN ABS(DEM.F12_VALUE) >= PAR.NUM_VALUE
                 OR DEM.ASR_YEAR != '2013'
                THEN DEM.F12_VALUE
            END AS F12_VALUE,
            CASE
                WHEN ABS(DEM.F12_VALUE) < PAR.NUM_VALUE
                AND DEM.ASR_YEAR = '2013'
                THEN 1
            END AS F12_REDACTED_FLAG,
            CASE
                WHEN ABS(DEM.F18_VALUE) >= PAR.NUM_VALUE
                 OR DEM.ASR_YEAR != '2013'
                THEN DEM.F18_VALUE
            END AS F18_VALUE,
            CASE
                WHEN ABS(DEM.F18_VALUE) < PAR.NUM_VALUE
                AND DEM.ASR_YEAR = '2013'
                THEN 1
            END AS F18_REDACTED_FLAG,
            CASE
                WHEN ABS(DEM.F60_VALUE) >= PAR.NUM_VALUE
                 OR DEM.ASR_YEAR != '2013'
                THEN DEM.F60_VALUE
            END AS F60_VALUE,
            CASE
                WHEN ABS(DEM.F60_VALUE) < PAR.NUM_VALUE
                AND DEM.ASR_YEAR = '2013'
                THEN 1
            END AS F60_REDACTED_FLAG,
            CASE
                WHEN ABS(DEM.FOTHER_VALUE) >= PAR.NUM_VALUE
                 OR DEM.ASR_YEAR != '2013'
                THEN DEM.FOTHER_VALUE
            END AS FOTHER_VALUE,
            CASE
                WHEN ABS(DEM.FOTHER_VALUE) < PAR.NUM_VALUE
                AND DEM.ASR_YEAR = '2013'
                THEN 1
            END AS FOTHER_REDACTED_FLAG,
            CASE
                WHEN ABS(DEM.FTOTAL_VALUE) >= PAR.NUM_VALUE
                 OR DEM.ASR_YEAR != '2013'
                THEN DEM.FTOTAL_VALUE
            END AS FTOTAL_VALUE,
            CASE
                WHEN ABS(DEM.FTOTAL_VALUE) < PAR.NUM_VALUE
                AND DEM.ASR_YEAR = '2013'
                THEN 1
            END AS FTOTAL_REDACTED_FLAG,
            CASE
                WHEN ABS(DEM.M0_VALUE) >= PAR.NUM_VALUE
                 OR DEM.ASR_YEAR != '2013'
                THEN DEM.M0_VALUE
            END AS M0_VALUE,
            CASE
                WHEN ABS(DEM.M0_VALUE) < PAR.NUM_VALUE
                AND DEM.ASR_YEAR = '2013'
                THEN 1
            END AS M0_REDACTED_FLAG,
            CASE
                WHEN ABS(DEM.M5_VALUE) >= PAR.NUM_VALUE
                 OR DEM.ASR_YEAR != '2013'
                THEN DEM.M5_VALUE
            END AS M5_VALUE,
            CASE
                WHEN ABS(DEM.M5_VALUE) < PAR.NUM_VALUE
                AND DEM.ASR_YEAR = '2013'
                THEN 1
            END AS M5_REDACTED_FLAG,
            CASE
                WHEN ABS(DEM.M12_VALUE) >= PAR.NUM_VALUE
                 OR DEM.ASR_YEAR != '2013'
                THEN DEM.M12_VALUE
            END AS M12_VALUE,
            CASE
                WHEN ABS(DEM.M12_VALUE) < PAR.NUM_VALUE
                AND DEM.ASR_YEAR = '2013'
                THEN 1
            END AS M12_REDACTED_FLAG,
            CASE
                WHEN ABS(DEM.M18_VALUE) >= PAR.NUM_VALUE
                 OR DEM.ASR_YEAR != '2013'
                THEN DEM.M18_VALUE
            END AS M18_VALUE,
            CASE
                WHEN ABS(DEM.M18_VALUE) < PAR.NUM_VALUE
                AND DEM.ASR_YEAR = '2013'
                THEN 1
            END AS M18_REDACTED_FLAG,
            CASE
                WHEN ABS(DEM.M60_VALUE) >= PAR.NUM_VALUE
                 OR DEM.ASR_YEAR != '2013'
                THEN DEM.M60_VALUE
            END AS M60_VALUE,
            CASE
                WHEN ABS(DEM.M60_VALUE) < PAR.NUM_VALUE
                AND DEM.ASR_YEAR = '2013'
                THEN 1
            END AS M60_REDACTED_FLAG,
            CASE
                WHEN ABS(DEM.MOTHER_VALUE) >= PAR.NUM_VALUE
                 OR DEM.ASR_YEAR != '2013'
                THEN DEM.MOTHER_VALUE
            END AS MOTHER_VALUE,
            CASE
                WHEN ABS(DEM.MOTHER_VALUE) < PAR.NUM_VALUE
                AND DEM.ASR_YEAR = '2013'
                THEN 1
            END AS MOTHER_REDACTED_FLAG,
            CASE
                WHEN ABS(DEM.MTOTAL_VALUE) >= PAR.NUM_VALUE
                 OR DEM.ASR_YEAR != '2013'
                THEN DEM.MTOTAL_VALUE
            END AS MTOTAL_VALUE,
            CASE
                WHEN ABS(DEM.MTOTAL_VALUE) < PAR.NUM_VALUE
                AND DEM.ASR_YEAR = '2013'
                THEN 1
            END AS MTOTAL_REDACTED_FLAG,
            CASE
                WHEN ABS(DEM.TOTAL_VALUE) >= PAR.NUM_VALUE
                 OR DEM.ASR_YEAR != '2013'
                THEN DEM.TOTAL_VALUE
            END AS TOTAL_VALUE,
            CASE
                WHEN ABS(DEM.TOTAL_VALUE) < PAR.NUM_VALUE
                AND DEM.ASR_YEAR = '2013'
                THEN 1
            END AS TOTAL_REDACTED_FLAG
        FROM
            Q_DEMOGRAPHICS DEM
        INNER JOIN Q_COUNTRIES_EN COU
        ON
            COU.ID = DEM.LOC_ID_ASYLUM_COUNTRY
        INNER JOIN Q_LOCATIONS_EN LOC
        ON
            LOC.ID = DEM.LOC_ID_ASYLUM
        CROSS JOIN T_SYSTEM_PARAMETERS PAR
        WHERE
            PAR.CODE = 'REDACTION LIMIT'
    )
	;
	