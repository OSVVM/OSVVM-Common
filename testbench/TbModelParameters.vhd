--
--  File Name:         TbModelParameters.vhd
--  Design Unit Name:  TbModelParameters
--  Revision:          OSVVM MODELS STANDARD VERSION
--
--  Maintainer:        Jim Lewis      email:  jim@synthworks.com
--  Contributor(s):
--     Jim Lewis      jim@synthworks.com
--
--
--  Description:
--      Test ModelParametersPkg
--
--
--  Developed by:
--        SynthWorks Design Inc.
--        VHDL Training Classes
--        http://www.SynthWorks.com
--
--  Revision History:
--    Date      Version    Description
--    02/2020   2020.05    Initial
--
--
--  This file is part of OSVVM.
--  
--  Copyright (c) 2020 by SynthWorks Design Inc.  
--  
--  Licensed under the Apache License, Version 2.0 (the "License");
--  you may not use this file except in compliance with the License.
--  You may obtain a copy of the License at
--  
--      https://www.apache.org/licenses/LICENSE-2.0
--  
--  Unless required by applicable law or agreed to in writing, software
--  distributed under the License is distributed on an "AS IS" BASIS,
--  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--  See the License for the specific language governing permissions and
--  limitations under the License.
--  
library ieee ;
  use ieee.std_logic_1164.all ;
  use ieee.numeric_std.all ;
  use ieee.numeric_std_unsigned.all ;
  use ieee.math_real.all ;

library osvvm ;
    context osvvm.OsvvmContext ;
    
library OSVVM_Common ; 
  use OSVVM_Common.ModelParametersPkg.all ; 
    
entity TbModelParameters is
end entity TbModelParameters ; 
architecture Test of TbModelParameters is
  shared variable Params : ModelParametersPType ; 
  signal TbID : AlertLogIDType ; 
begin
  initial : process
    variable ID : AlertLogIDType ; 
  begin
    ID := GetAlertLogID("TB") ;
    TbID <= ID ; 
    Params.SetAlertLogID(ID) ;
    
    Params.Init(10) ;
    Params.Set(0, 10) ;
    Params.Set(5, "10001") ;
    Params.Set(1, 11) ;
    Params.Set(6, 6X"12") ;
    Params.Set(2, FALSE) ;
    Params.Set(7, "0010011") ;
    Params.Set(3, TRUE);
    Params.Set(8, 20, 8) ; -- SLV
    Params.Set(4, 14); 
    Params.Set(9, B"0_0001_0101") ;
    wait ; 
  end process initial ; 
  
  TestProc : process
  begin
    wait for 1 ns ; 
    
    Print("Return integer values as an integer") ;
    Print("Params.Get(0) = (10): " & to_string(integer'(Params.Get(0)))) ;
    Print("Params.Get(1) = (11): " & to_string(integer'(Params.Get(1)))) ;
    Print("Params.Get(2) = (0): "  & to_string(integer'(Params.Get(2)))) ;
    Print("Params.Get(3) = (1): "  & to_string(integer'(Params.Get(3)))) ;
    Print("Params.Get(4) = (14): " & to_string(integer'(Params.Get(4)))) ;
    
    blankline(2) ; 
    Print("Return std_logic_vector values as an integer") ;
    Print("Params.Get(5) = (17): " & to_string(integer'(Params.Get(5)))) ;
    Print("Params.Get(6) = (18): " & to_string(integer'(Params.Get(6)))) ;
    Print("Params.Get(7) = (19): " & to_string(integer'(Params.Get(7)))) ;
    Print("Params.Get(8) = (20): " & to_string(integer'(Params.Get(8)))) ;
    Print("Params.Get(9) = (21): " & to_string(integer'(Params.Get(9)))) ;

    blankline(2) ; 
    Print("Return integer values as an std_logic_vector or boolean") ;
    Print("Params.Get(0) = (0000000A): " & to_hstring(std_logic_vector'(Params.Get(0)))) ;
    Print("Params.Get(1) = (B): "        & to_hstring(std_logic_vector'(Params.Get(1,4)))) ;
    Print("Params.Get(2) = (FALSE): "    & to_string(boolean'(Params.Get(2)))) ;
    Print("Params.Get(3) = (TRUE): "     & to_string(boolean'(Params.Get(3)))) ;
    Print("Params.Get(4) = (0D): "       & to_hstring(std_logic_vector'(Params.Get(4,8)))) ;
    
    blankline(2) ; 
    Print("Return std_logic_vector values as an std_logic_vector") ;
    Print("Params.Get(5) = (17)x5: " & to_string(std_logic_vector'(Params.Get(5)))) ;
    Print("Params.Get(6) = (18)x6: " & to_string(std_logic_vector'(Params.Get(6)))) ;
    Print("Params.Get(7) = (19)x7: " & to_string(std_logic_vector'(Params.Get(7)))) ;
    Print("Params.Get(8) = (20)x8: " & to_string(std_logic_vector'(Params.Get(8)))) ;
    Print("Params.Get(9) = (21)x9: " & to_string(std_logic_vector'(Params.Get(9)))) ;
    
    blankline(2) ; 
    Print("Write using Set((0,1,2,3,4,5,6,7,8,9))") ;
    Params.Set((0,1,2,3,4,5,6,7,8,9)) ;

    blankline(2) ; 
    Print("Return all values as an integer") ;
    for i in 0 to 9 loop
      Print("Params.Get(i) = (" & to_string(i) & "): " & to_string(integer'(Params.Get(i)))) ;
    end loop ; 
    
    blankline(2) ; 
    Print("Return all values as an std_logic_vector") ;
    for i in 0 to 9 loop
      Print("Params.Get(i) = (" & to_string(i) & "): " & to_string(std_logic_vector'(Params.Get(i)))) ;
    end loop ;     
    
    blankline(2) ; 
    Print("Write using Set((17,17,17,17,17,17,17,17,17,17)") ;
    Params.Set((17,17,17,17,17,17,17,17,17,17)) ;

    blankline(2) ; 
    Print("Return all values as an integer") ;
    for i in 0 to 9 loop
      Print("Params.Get(i) = (" & to_string(i) & "): " & to_string(integer'(Params.Get(i)))) ;
    end loop ; 
    
    blankline(2) ; 
    Print("Return all values as an std_logic_vector") ;
    for i in 0 to 9 loop
      Print("Params.Get(i) = (" & to_string(i) & "): " & to_string(std_logic_vector'(Params.Get(i)))) ;
    end loop ;     
    
    blankline(2) ; 
    Print("Write using Set((-1, -2, -3, -4, -5, -1, -2, -3, -4, -5))") ;
    Params.Set((-1, -2, -3, -4, -5, -1, -2, -3, -4, -5)) ;

    blankline(2) ; 
    Print("Return all values as an integer") ;
    for i in 0 to 9 loop
      Print("Params.Get(i) = (" & to_string(i) & "): " & to_string(integer'(Params.Get(i)))) ;
    end loop ; 
    
    blankline(2) ; 
    Print("Return all values as an std_logic_vector") ;
    for i in 0 to 9 loop
      Print("Params.Get(i) = (" & to_string(i) & "): " & to_string(std_logic_vector'(Params.Get(i)))) ;
    end loop ;     
    
    std.env.stop;
    
--		procedure Init(nparams : in positive);
--  --		procedure Init(initvals : in integer_vector);
--		
--		procedure Set(Index: in natural; Data: in integer);
--		procedure Set(Data:  in integer_vector);
--		procedure Set(Index: in natural; Data: in integer; len: positive);
--		procedure Set(Index: in natural; Data: in boolean);
--		procedure Set(Index: in natural; Data: in std_logic_vector);
--		
--		impure function Get(Index: natural) return integer;
--		impure function Get(Index: natural) return boolean;
--		impure function Get(Index: natural) return std_logic_vector;
--		impure function Get(Index: natural; len: positive) return std_logic_vector;
--    
--    ------------------------------------------------------------
--    procedure SetAlertLogID (A : AlertLogIDType) ;
--    procedure SetAlertLogID (Name : string ; ParentID : AlertLogIDType := ALERTLOG_BASE_ID ; CreateHierarchy : Boolean := TRUE) ;    
--    impure function GetAlertLogID return AlertLogIDType ;
  end process TestProc ; 
end architecture Test ; -- of TbModelParameters