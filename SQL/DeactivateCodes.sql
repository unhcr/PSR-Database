set serveroutput on

declare
  nDST_VERSION_NBR P_BASE.tnDST_VERSION_NBR;
  nDIM_VERSION_NBR P_BASE.tnDIM_VERSION_NBR;
  iCount pls_integer;
begin
  iCount := 0;
  for rDST in
   (select DST.ID as DST_ID, DST.VERSION_NBR
    from STAGE.S_DISPLACEMENT_STATUSES STG
    inner join DISPLACEMENT_STATUSES DST
      on DST.CODE = STG.CODE
    where STG.ACTIVE_FLAG = 'N')
  loop
    iCount := iCount + 1;
    P_DISPLACEMENT_STATUS.UPDATE_DISPLACEMENT_STATUS(rDST.DST_ID, rDST.VERSION_NBR, psACTIVE_FLAG => 'N');
  end loop;
--
  if iCount = 1
  then dbms_output.put_line('1 DISPLACEMENT_STATUSES record inactivated');
  else dbms_output.put_line(to_char(iCount) || ' DISPLACEMENT_STATUSES records inactivated');
  end if;
--
  iCount := 0;
  for rDIM in
   (select DIM.ID as DIM_ID, DIM.VERSION_NBR
    from STAGE.S_DIMENSION_VALUES STG
    inner join DIMENSION_VALUES DIM
      on DIM.DIMT_CODE = STG.DIMT_CODE
      and DIM.CODE = STG.CODE
    where STG.ACTIVE_FLAG = 'N')
  loop
    iCount := iCount + 1;
    P_DIMENSION.UPDATE_DIMENSION_VALUE(rDIM.DIM_ID, rDIM.VERSION_NBR, psACTIVE_FLAG => 'N');
  end loop;
--
  if iCount = 1
  then dbms_output.put_line('1 DIMENSION_VALUES record inactivated');
  else dbms_output.put_line(to_char(iCount) || ' DIMENSION_VALUES records inactivated');
  end if;
end;
/
