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
    SetTestName("TbModelParameters") ;
    ID := GetAlertLogID("TB") ;
    TbID <= ID ; 
    SetLogEnable(PASSED, TRUE) ; 
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
    variable CheckValue : integer ; 
  begin
    wait for 1 ns ; 
    
    log("Return integer values as an integer") ;
    AffirmIfEqual(TbID, Params.Get(0), 10,  "Params.Get(0) = 10") ;    
    AffirmIfEqual(TbID, Params.Get(1), 11,  "Params.Get(1) = 11") ;
    AffirmIfEqual(TbID, Params.Get(2),  0,  "Params.Get(2) =  0") ;
    AffirmIfEqual(TbID, Params.Get(3),  1,  "Params.Get(3) =  1") ;
    AffirmIfEqual(TbID, Params.Get(4), 14,  "Params.Get(4) = 14") ;
    
    blankline(2) ; 
    log("Return std_logic_vector values as an std_logic_vector") ;
    AffirmIfEqual(TbID, Params.Get(5), 5X"11",   "Params.Get(5) = 5X""11""") ; 
    AffirmIfEqual(TbID, Params.Get(6), 6X"12",   "Params.Get(6) = 6X""12""") ; 
    AffirmIfEqual(TbID, Params.Get(7), 7X"13",   "Params.Get(7) = 7X""13""") ; 
    AffirmIfEqual(TbID, Params.Get(8), 8X"14",   "Params.Get(8) = 8X""14""") ; 
    AffirmIfEqual(TbID, Params.Get(9), 9X"15",   "Params.Get(9) = 9X""15""") ; 
    
    blankline(2) ; 

    log("Return integer values as an std_logic_vector or boolean") ;
    AffirmIfEqual(TbID, Params.Get(0),   32X"0A",    "Params.Get(0) =  32D""010""") ;
    AffirmIfEqual(TbID, Params.Get(1,4),  4D"11",    "Params.Get(1) = (1,4) = 4D""11""") ;
    AffirmIfEqual(TbID, Params.Get(2),     FALSE,    "Params.Get(2) = (2)   = FALSE") ;
    AffirmIfEqual(TbID, Params.Get(3),      TRUE,    "Params.Get(3) = (3)   = TRUE") ;
    AffirmIfEqual(TbID, Params.Get(4,8),  8D"14",    "Params.Get(4) = (4,8) = 8D""14""") ;
    
    blankline(2) ; 
    log("Return std_logic_vector values as an integer") ;
    AffirmIfEqual(TbID, Params.Get(5), 17, "Params.Get(5) = (17)") ; 
    AffirmIfEqual(TbID, Params.Get(6), 18, "Params.Get(6) = (18)") ; 
    AffirmIfEqual(TbID, Params.Get(7), 19, "Params.Get(7) = (19)") ; 
    AffirmIfEqual(TbID, Params.Get(8), 20, "Params.Get(8) = (20)") ; 
    AffirmIfEqual(TbID, Params.Get(9), 21, "Params.Get(9) = (21)") ; 

    blankline(2) ; 
    log("Params.Set((0,1,2,3,4,5,6,7,8,9))") ;
    Params.Set((0,1,2,3,4,5,6,7,8,9)) ;
 
    blankline(2) ; 
    log("Check reading values as an integer") ;
    for i in 0 to 9 loop
      AffirmIfEqual(TbID, Params.Get(i), i, "Params.Get(i) = " & to_string(i)) ;
    end loop ; 
    
    blankline(2) ; 
    log("Check reading values as a std_logic_vector") ;
    for i in 0 to 9 loop
      AffirmIfEqual(TbID, Params.Get(i,4), to_slv(i,4), "Params.Get(i) = " & to_string(i)) ;
    end loop ; 
    
    blankline(2) ; 
    log("Params.Set((0, -1, -2, -3, -4, -5, -6, -7, -8, -9))") ;
    Params.Set((0, -1, -2, -3, -4, -5, -6, -7, -8, -9)) ;
 
    blankline(2) ; 
    log("Check reading values as an integer") ;
    for i in 0 to 4 loop
      AffirmIfEqual(TbID, Params.Get(i), -i, "Params.Get(i) = " & to_string(-i)) ;
    end loop ; 
    for i in 5 to 9 loop
      CheckValue := to_integer(unsigned(to_signed(-i, i))) ;
      AffirmIfEqual(TbID, Params.Get(i), CheckValue, "Params.Get(i) = " & to_string(CheckValue)) ;
    end loop ; 
    
    blankline(2) ; 
    log("Check reading values as a std_logic_vector") ;
    for i in 0 to 9 loop
      AffirmIfEqual(TbID, Params.Get(i,5), std_logic_vector(to_signed(-i,5)), "Params.Get(i) = " & to_hstring(std_logic_vector(to_signed(-i,5)))) ;
    end loop ; 
    
    EndOfTestReports ;
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