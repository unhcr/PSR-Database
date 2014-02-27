begin
P_SYSTEM_USER.INSERT_SYSTEM_USER  ('ananib','en','Bruno Codjo  Anani');
P_SYSTEM_USER.INSERT_SYSTEM_USER  ('jalloha','en','Abubakarr Talib Jalloh');
P_SYSTEM_USER.INSERT_SYSTEM_USER  ('gbatti','en','Oukoum Nadjombe Gbatti');
P_SYSTEM_USER.INSERT_SYSTEM_USER  ('ionescu','en','Liliana Ionescu');
P_SYSTEM_USER.INSERT_SYSTEM_USER  ('dahlgren','en','Cecilia Dahlgren');
P_SYSTEM_USER.INSERT_SYSTEM_USER  ('lumb','en','Bik Lum');
P_SYSTEM_USER.INSERT_SYSTEM_USER  ('khanna','en','Nasir Khan');
P_SYSTEM_USER.INSERT_SYSTEM_USER  ('chikwan','en','Mwenya Chikwanda');
P_SYSTEM_USER.INSERT_SYSTEM_USER  ('kasoma','en','Chipo Kasoma');
P_SYSTEM_USER.INSERT_SYSTEM_USER  ('binder','en','George Binder');
P_SYSTEM_USER.INSERT_SYSTEM_USER  ('pitoiset','en','Laurent Pitoiset');
P_SYSTEM_USER.INSERT_SYSTEM_USER  ('camus','en','Philippe Camus');
P_SYSTEM_USER.INSERT_SYSTEM_USER  ('abouchab','en','Tarek Abou Chabake');
P_SYSTEM_USER.INSERT_SYSTEM_USER  ('tenkoran','en','Joseph Tenkorang');
P_SYSTEM_USER.INSERT_SYSTEM_USER  ('gross','en','Stefanie Gross');
P_SYSTEM_USER.INSERT_SYSTEM_USER  ('karp','en','David Karp');
P_SYSTEM_USER.INSERT_SYSTEM_USER  ('casasola','en','Michael Casasola');
P_SYSTEM_USER.INSERT_SYSTEM_USER  ('dioh','en','Ngor Dioh');
P_SYSTEM_USER.INSERT_SYSTEM_USER  ('lebillan','en','Samuel Le Billan');
P_SYSTEM_USER.INSERT_SYSTEM_USER  ('morlang','en','Claas Morlang');
P_SYSTEM_USER.INSERT_SYSTEM_USER  ('omer','en','Sanaa Omer');
P_SYSTEM_USER.INSERT_SYSTEM_USER  ('selivano','en','Tatiana Selivanova');
P_SYSTEM_USER.INSERT_SYSTEM_USER  ('teohf','en','Francis Teoh');

end;
/

begin
--Admin
P_SYSTEM_USER.INSERT_USER_ROLE  ('binder',   1);  
P_SYSTEM_USER.INSERT_USER_ROLE  ('camus',   1);  
P_SYSTEM_USER.INSERT_USER_ROLE  ('pitoiset',   1);  
end;
/

declare
 rid number;
cid number;
begin
select id 
into rid
from   roles 
where description = 'PF data entry' ;

select id 
into cid
from  locations where name= 'South Africa' and locations.LOCT_CODE = 'COUNTRY';

P_ROLE.INSERT_ROLE_COUNTRY(rid, cid);

end;
/


DECLARE  
rol  number;
ctry  number;
CURSOR cUserCtry IS
    select 'ananib' usr,'Ethiopia' ctry from dual
    union select 'jalloha','Iraq' from dual
    union select 'gbatti','Kenya' from dual
    union select 'ionescu','Pakistan' from dual
    union select 'dahlgren','Senegal' from dual
    union select 'lumb','South Africa' from dual
    union select 'khanna','Yemen' from dual
    union select 'chikwan','Zambia' from dual
    union select 'kasoma','Zambia' from dual
	union select 'morlang','Afghanistan' from dual
	union select 'omer','Afghanistan' from dual
	union select 'tenkoran','Afghanistan' from dual
	union select 'casasola','Canada' from dual
	union select 'selivano','China' from dual
	union select 'teohf','China' from dual
	union select 'tenkoran','Kenya' from dual
	union select 'dioh','Senegal' from dual
	union select 'lebillan','Senegal' from dual
	union select 'tenkoran','South Sudan' from dual
;
begin
   for r in cUserCtry loop
        select rol_id, cou_id 
          into rol, ctry
          from ROLE_COUNTRIES
         where ROL_DESCRIPTION = 'PF data entry' 
          and cou_name = r.ctry;
    P_SYSTEM_USER.INSERT_USER_ROLE (r.usr,  rol, ctry);  
   end loop;
end; 
/

show errors


