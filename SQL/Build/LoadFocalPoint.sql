begin
P_STATISTIC_GROUP.INSERT_STG_ATTRIBUTE_TYPE
   (psCODE => 'FPTNAME',
    psDATA_TYPE => 'C',
    psLANG_CODE => 'en',
    psDescription => 'Focal point name'
);
P_STATISTIC_GROUP.INSERT_STG_ATTRIBUTE_TYPE
   (psCODE => 'FPTMAIL',
    psDATA_TYPE => 'C',
    psLANG_CODE => 'en',
    psDescription => 'Focal point email'
);
end;
/

show errors
