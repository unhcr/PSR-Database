create or replace type tCHARAGG as
object
 (sAGG varchar2(4000),
  static function ODCIAggregateInitialize
   (poCTX in out tCHARAGG)
    return number,
  member function ODCIAggregateIterate
   (self in out tCHARAGG,
    psVALUE in varchar2)
    return number,
  member function ODCIAggregateMerge
   (self in out tCHARAGG,
    poCTX2 in tCHARAGG)
    return number,
  member function ODCIAggregateTerminate
   (self in tCHARAGG,
    psRETURNVALUE out varchar2,
    pnFLAGS in number)
    return number);
/

create or replace type body tCHARAGG
is
  static function ODCIAggregateInitialize
   (poCTX in out tCHARAGG)
    return number
  is
  begin
    poCTX := tCHARAGG(null);
    return ODCIConst.Success;
  end;
--
  member function ODCIAggregateIterate
   (self in out tCHARAGG,
    psVALUE in varchar2)
    return number
  is
    sVALUE varchar2(4000) := regexp_replace(psVALUE, '[^[:alnum:]]', '');
    sCHAR varchar2(1);
  begin
    for i in 1 .. nvl(length(sVALUE), 0)
    loop
      sCHAR := substr(sVALUE, i, 1);
      if self.sAGG is null
      then self.sAGG := sCHAR;
      elsif instr(self.sAGG, sCHAR) > 0
      then null;
      elsif sCHAR > substr(self.sAGG, -1)
      then self.sAGG := self.sAGG || sCHAR;
      else
        declare
          j pls_integer := 1;
        begin
          while sCHAR > substr(self.sAGG, j, 1)
          loop
            j := j + 1;
          end loop;
          self.sAGG := substr(self.sAGG, 1, j-1) || sCHAR || substr(self.sAGG, j);
        end;
      end if;
    end loop;
    return ODCIConst.Success;
  end;
--
  member function ODCIAggregateMerge
   (self in out tCHARAGG,
    poCTX2 in tCHARAGG)
    return number
  is
  begin
    return ODCIConst.Error;
  end;
--
  member function ODCIAggregateTerminate
   (self in tCHARAGG,
    psRETURNVALUE out varchar2,
    pnFLAGS in number)
    return number
  is
  begin
    psRETURNVALUE := self.sAGG;
    return ODCIConst.Success;
  end;
end;
/

create or replace function CHARAGG
 (input varchar2)
  return varchar2
  aggregate
using tCHARAGG;
/

grant execute on CHARAGG to PSR_STAGE;
