 begin
 P_SYSTEM_PARAMETER.INSERT_SYSTEM_PARAMETER
   (psCODE => 'REDACTION LIMIT',
    psLANG_CODE => 'en',
    psDescription => 'Threshold below which small values are redacted from public reports',
    psDATA_TYPE => 'N',
    pnNUM_VALUE => 5
);
end;
/