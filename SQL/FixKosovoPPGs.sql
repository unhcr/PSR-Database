begin
  for rPPG in
   (select ID, VERSION_NBR,
      replace(DESCRIPTION, ' (Kosovo)', '') as DESCRIPTION
    from POPULATION_PLANNING_GROUPS
    where PPG_CODE like '_KOS_'
    order by PPG_CODE)
  loop
    P_POPULATION_PLANNING_GROUP.UPDATE_PPG(rPPG.ID, rPPG.VERSION_NBR, 'en', rPPG.DESCRIPTION);
  end loop;
end;
/
