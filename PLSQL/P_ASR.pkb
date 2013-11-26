create or replace package body P_ASR is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- INSERT_ASR_RETURNEES
-- ----------------------------------------
--
  procedure INSERT_ASR_RETURNEES
   (pnASR_YEAR in P_BASE.tmnYear,
    pnLOC_ID_ORIGIN_COUNTRY in P_BASE.tmnLOC_ID,
    pnLOC_ID_ASYLUM_COUNTRY in P_BASE.tmnLOC_ID,
    pnDST_ID in P_BASE.tmnDST_ID,
    psSOURCE in P_BASE.tsSTGA_CHAR_VALUE,
    psBASIS in P_BASE.tsSTGA_CHAR_VALUE,
    pnREFRTN_VALUE in P_BASE.tnSTC_VALUE,
    pnREFRTN_AH_VALUE in P_BASE.tnSTC_VALUE)
  is
    dSTART_DATE P_BASE.tdDate := to_date(to_char(pnASR_YEAR) || '-01-01', 'YYYY-MM-DD');
    dEND_DATE P_BASE.tdDate := to_date(to_char(pnASR_YEAR + 1) || '-01-01', 'YYYY-MM-DD');
    nSTG_ID P_BASE.tnSTG_ID;
    nSTC_ID P_BASE.tnSTC_ID;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_ASR_RETURNEES',
      to_char(pnASR_YEAR)  || '~' || to_char(pnLOC_ID_ORIGIN_COUNTRY) || '~' ||
        to_char(pnLOC_ID_ASYLUM_COUNTRY) || '~' || to_char(pnDST_ID) || '~' ||
        psSOURCE || '~' || psBASIS || '~' ||
        to_char(pnREFRTN_VALUE) || '~' || to_char(pnREFRTN_AH_VALUE));
  --
  -- Check that at lease one statistic value has been provided for this row.
  --
    if nvl(pnREFRTN_VALUE, 0) = 0 and nvl(pnREFRTN_AH_VALUE, 0) = 0
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'At least one statistic value must be supplied');
    end if;
  --
  -- Check that UNHCR-assisted value is not greater than total value.
  --
    if pnREFRTN_AH_VALUE > pnREFRTN_VALUE
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'UNHCR-assisted value may not be greater than total value');
    end if;
  --
  -- Create new population group representing this returnee table row.
  --
    P_STATISTIC_GROUP.INSERT_STATISTIC_GROUP
     (nSTG_ID, dSTART_DATE, dEND_DATE, 'RETURNEE',
      pnDST_ID => pnDST_ID,
      pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
      pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY);
  --
  -- Create population group attributes for the source and basis.
  --
    if psSOURCE is not null
    then P_STATISTIC_GROUP.INSERT_STG_ATTRIBUTE(nSTG_ID, 'SOURCE', psSOURCE);
    end if;
  --
    if psBASIS is not null
    then P_STATISTIC_GROUP.INSERT_STG_ATTRIBUTE(nSTG_ID, 'BASIS', psBASIS);
    end if;
  --
  -- Create statistics for the REFRTN and REFRTN_AH statistic types.
  --
    if nvl(pnREFRTN_VALUE, 0) != 0
    then
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, 'REFRTN', dSTART_DATE, dEND_DATE,
        pnDST_ID => pnDST_ID,
        pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
        pnSTG_ID_PRIMARY => nSTG_ID,
        pnVALUE => pnREFRTN_VALUE);
    end if;
  --
    if nvl(pnREFRTN_AH_VALUE, 0) != 0
    then
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, 'REFRTN_AH', dSTART_DATE, dEND_DATE,
        pnDST_ID => pnDST_ID,
        pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
        pnSTG_ID_PRIMARY => nSTG_ID,
        pnVALUE => pnREFRTN_AH_VALUE);
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_ASR_RETURNEES;
--
-- ----------------------------------------
-- UPDATE_ASR_RETURNEES
-- ----------------------------------------
--
  procedure UPDATE_ASR_RETURNEES
   (pnASR_YEAR in P_BASE.tmnYear,
    pnLOC_ID_ORIGIN_COUNTRY in P_BASE.tmnLOC_ID,
    pnLOC_ID_ASYLUM_COUNTRY in P_BASE.tmnLOC_ID,
    pnDST_ID in P_BASE.tmnDST_ID,
    psSOURCE in P_BASE.tsSTGA_CHAR_VALUE,
    psBASIS in P_BASE.tsSTGA_CHAR_VALUE,
    pnREFRTN_VALUE in P_BASE.tnSTC_VALUE,
    pnREFRTN_AH_VALUE in P_BASE.tnSTC_VALUE,
    pnSTG_ID_PRIMARY in P_BASE.tmnSTG_ID,
    pnSTG_VERSION_NBR in P_BASE.tnSTG_VERSION_NBR,
    pnSTGA_VERSION_NBR_SOURCE in P_BASE.tnSTGA_VERSION_NBR,
    pnSTGA_VERSION_NBR_BASIS in P_BASE.tnSTGA_VERSION_NBR,
    pnREFRTN_STC_ID in P_BASE.tnSTC_ID,
    pnREFRTN_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR,
    pnREFRTN_AH_STC_ID in P_BASE.tnSTC_ID,
    pnREFRTN_AH_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR)
  is
    nSTGA_VERSION_NBR_SOURCE P_BASE.tnSTGA_VERSION_NBR := pnSTGA_VERSION_NBR_SOURCE;
    nSTGA_VERSION_NBR_BASIS P_BASE.tnSTGA_VERSION_NBR := pnSTGA_VERSION_NBR_BASIS;
    nREFRTN_VERSION_NBR P_BASE.tnSTC_VERSION_NBR := pnREFRTN_VERSION_NBR;
    nREFRTN_AH_VERSION_NBR P_BASE.tnSTC_VERSION_NBR := pnREFRTN_AH_VERSION_NBR;
    dSTART_DATE P_BASE.tdDate := to_date(to_char(pnASR_YEAR) || '-01-01', 'YYYY-MM-DD');
    dEND_DATE P_BASE.tdDate := to_date(to_char(pnASR_YEAR + 1) || '-01-01', 'YYYY-MM-DD');
    nSTC_ID P_BASE.tnSTC_ID;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_ASR_RETURNEES',
      to_char(pnASR_YEAR) || '~' || to_char(pnLOC_ID_ORIGIN_COUNTRY) || '~' ||
        to_char(pnLOC_ID_ASYLUM_COUNTRY) || '~' || to_char(pnDST_ID) || '~' ||
        psSOURCE || '~' || psBASIS || '~' ||
        to_char(pnREFRTN_VALUE) || '~' || to_char(pnREFRTN_AH_VALUE) || '~' ||
        to_char(pnSTG_ID_PRIMARY)  || '~' ||
        to_char(pnSTGA_VERSION_NBR_SOURCE) || '~' || to_char(pnSTGA_VERSION_NBR_BASIS) || '~' ||
        to_char(pnREFRTN_STC_ID) || '~' || to_char(pnREFRTN_VERSION_NBR) || '~' ||
        to_char(pnREFRTN_AH_STC_ID) || '~' || to_char(pnREFRTN_AH_VERSION_NBR));
  --
  -- Check that at lease one statistic value has been provided for this row.
  --
    if nvl(pnREFRTN_VALUE, 0) = 0 and nvl(pnREFRTN_AH_VALUE, 0) = 0
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'At least one statistic value must be supplied');
    end if;
  --
  -- Check that UNHCR-assisted value is not greater than total value.
  --
    if pnREFRTN_AH_VALUE > pnREFRTN_VALUE
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'UNHCR-assisted value may not be greater than total value');
    end if;
  --
  -- Update or insert population group attributes for the source and basis. Delete attributes where
  --  the new value is null.
  --
    if psSOURCE is null and pnSTGA_VERSION_NBR_SOURCE is not null
    then
      P_STATISTIC_GROUP.DELETE_STG_ATTRIBUTE(pnSTG_ID_PRIMARY, 'SOURCE', nSTGA_VERSION_NBR_SOURCE);
    elsif psSOURCE is not null and pnSTGA_VERSION_NBR_SOURCE is null
    then
      P_STATISTIC_GROUP.INSERT_STG_ATTRIBUTE(pnSTG_ID_PRIMARY, 'SOURCE', psSOURCE);
    else
      P_STATISTIC_GROUP.UPDATE_STG_ATTRIBUTE
       (pnSTG_ID_PRIMARY, 'SOURCE', nSTGA_VERSION_NBR_SOURCE, psSOURCE);
    end if;
  --
    if psBASIS is null and pnSTGA_VERSION_NBR_BASIS is not null
    then
      P_STATISTIC_GROUP.DELETE_STG_ATTRIBUTE(pnSTG_ID_PRIMARY, 'BASIS', nSTGA_VERSION_NBR_BASIS);
    elsif psBASIS is not null and pnSTGA_VERSION_NBR_BASIS is null
    then
      P_STATISTIC_GROUP.INSERT_STG_ATTRIBUTE(pnSTG_ID_PRIMARY, 'BASIS', psBASIS);
    else
      P_STATISTIC_GROUP.UPDATE_STG_ATTRIBUTE
       (pnSTG_ID_PRIMARY, 'BASIS', nSTGA_VERSION_NBR_BASIS, psBASIS);
    end if;
  --
  -- Update or insert statistics for the REFRTN and REFRTN_AH statistic types. Delete statistics
  --  where the new value is null or zero.
  -- 
    if nvl(pnREFRTN_VALUE, 0) = 0 and pnREFRTN_STC_ID is not null
    then P_STATISTIC.DELETE_STATISTIC(pnREFRTN_STC_ID, pnREFRTN_VERSION_NBR);
    elsif nvl(pnREFRTN_VALUE, 0) != 0 and pnREFRTN_STC_ID is null
    then
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, 'REFRTN', dSTART_DATE, dEND_DATE,
        pnDST_ID => pnDST_ID,
        pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
        pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
        pnVALUE => pnREFRTN_VALUE);
    else
      P_STATISTIC.UPDATE_STATISTIC(pnREFRTN_STC_ID, nREFRTN_VERSION_NBR, pnREFRTN_VALUE);
    end if;
  --
    if nvl(pnREFRTN_AH_VALUE, 0) = 0 and pnREFRTN_AH_STC_ID is not null
    then P_STATISTIC.DELETE_STATISTIC(pnREFRTN_AH_STC_ID, pnREFRTN_AH_VERSION_NBR);
    elsif nvl(pnREFRTN_AH_VALUE, 0) != 0 and pnREFRTN_AH_STC_ID is null
    then
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, 'REFRTN_AH', dSTART_DATE, dEND_DATE,
        pnDST_ID => pnDST_ID,
        pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
        pnSTG_ID_PRIMARY => pnSTG_ID_PRIMARY,
        pnVALUE => pnREFRTN_AH_VALUE);
    else
      P_STATISTIC.UPDATE_STATISTIC(pnREFRTN_AH_STC_ID, nREFRTN_AH_VERSION_NBR, pnREFRTN_AH_VALUE);
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end UPDATE_ASR_RETURNEES;
--
-- ----------------------------------------
-- DELETE_ASR_RETURNEES
-- ----------------------------------------
--
  procedure DELETE_ASR_RETURNEES
   (pnSTG_ID_PRIMARY in P_BASE.tnSTG_ID,
    pnSTG_VERSION_NBR in P_BASE.tnSTG_VERSION_NBR,
    pnSTGA_VERSION_NBR_SOURCE in P_BASE.tnSTGA_VERSION_NBR,
    pnSTGA_VERSION_NBR_BASIS in P_BASE.tnSTGA_VERSION_NBR,
    pnREFRTN_STC_ID in P_BASE.tnSTC_ID,
    pnREFRTN_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR,
    pnREFRTN_AH_STC_ID in P_BASE.tnSTC_ID,
    pnREFRTN_AH_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR)
  is
    nSTG_VERSION_NBR P_BASE.tnSTG_VERSION_NBR := pnSTG_VERSION_NBR;
    nSTGA_VERSION_NBR_SOURCE P_BASE.tnSTGA_VERSION_NBR := pnSTGA_VERSION_NBR_SOURCE;
    nSTGA_VERSION_NBR_BASIS P_BASE.tnSTGA_VERSION_NBR := pnSTGA_VERSION_NBR_BASIS;
    nREFRTN_VERSION_NBR P_BASE.tnSTC_VERSION_NBR := pnREFRTN_VERSION_NBR;
    nREFRTN_AH_VERSION_NBR P_BASE.tnSTC_VERSION_NBR := pnREFRTN_AH_VERSION_NBR;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_ASR_RETURNEES',
      to_char(pnSTG_ID_PRIMARY)  || '~' || to_char(pnSTG_VERSION_NBR) || '~' ||
        to_char(pnSTGA_VERSION_NBR_SOURCE) || '~' || to_char(pnSTGA_VERSION_NBR_BASIS) || '~' ||
        to_char(pnREFRTN_STC_ID) || '~' || to_char(pnREFRTN_VERSION_NBR) || '~' ||
        to_char(pnREFRTN_AH_STC_ID) || '~' || to_char(pnREFRTN_AH_VERSION_NBR));
  --
  -- Delete the REFRTN and REFRTN_AH statistics.
  --
    if pnREFRTN_STC_ID is not null
    then P_STATISTIC.DELETE_STATISTIC(pnREFRTN_STC_ID, nREFRTN_VERSION_NBR);
    end if;
  --
    if pnREFRTN_AH_STC_ID is not null
    then P_STATISTIC.DELETE_STATISTIC(pnREFRTN_AH_STC_ID, nREFRTN_AH_VERSION_NBR);
    end if;
  --
  -- Delete the source and basis population group attributes and the primary population group.
  --
    if pnSTG_ID_PRIMARY is not null
    then
      if nSTGA_VERSION_NBR_SOURCE is not null
      then
        P_STATISTIC_GROUP.DELETE_STG_ATTRIBUTE(pnSTG_ID_PRIMARY, 'SOURCE', nSTGA_VERSION_NBR_SOURCE);
      end if;
    --
      if nSTGA_VERSION_NBR_BASIS is not null
      then
        P_STATISTIC_GROUP.DELETE_STG_ATTRIBUTE(pnSTG_ID_PRIMARY, 'BASIS', nSTGA_VERSION_NBR_BASIS);
      end if;
    --
      P_STATISTIC_GROUP.DELETE_STATISTIC_GROUP(pnSTG_ID_PRIMARY, nSTG_VERSION_NBR);
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_ASR_RETURNEES;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sComponent != 'ASR'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'Component code mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
end P_ASR;
/

show errors
