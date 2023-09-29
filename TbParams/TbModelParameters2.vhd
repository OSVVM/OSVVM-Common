--
--  File Name:         TbModelParameters2.vhd
--  Design Unit Name:  TbModelParameters2
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
  use OSVVM_Common.ModelParametersSingletonPkg.all ; 
    
entity TbModelParameters2 is
end entity TbModelParameters2 ; 
architecture Test of TbModelParameters2 is
  signal Params : ModelParametersIDArrayType(3 downto 0) ; 
  signal TbID   : AlertLogIDType ; 
begin
  initial : process
    variable ID : AlertLogIDType ; 
  begin
    SetTestName("TbModelParameters2") ;
    ID := GetAlertLogID("TB") ;
    TbID <= ID ; 
    Params(0) <= NewID("Param0", 5) ; 
    Params(1) <= NewID("Param1", 5) ; 
    Params(2) <= NewID("Param2", 10) ; 
    Params(3) <= NewID("Param3", 10) ; 
    SetLogEnable(PASSED, TRUE) ; 
    wait for 0 ns ; 
    -- Params.SetAlertLogID(ID) ;
    
    Init(Params(0), 5) ;
    Init(Params(1), 5) ;
    Set (Params(0), 0, 10) ;
    Set (Params(0), 1, 11) ;
    Set (Params(0), 2, FALSE) ;
    Set (Params(0), 3, TRUE);
    Set (Params(0), 4, 14); 
    Set (Params(1), 0, "10001") ;
    Set (Params(1), 1, 6X"12") ;
    Set (Params(1), 2, "0010011") ;
    Set (Params(1), 3, 20, 8) ; -- SLV
    Set (Params(1), 4, B"0_0001_0101") ;
    wait ; 
  end process initial ; 
  
  TestProc : process
    variable CheckValue : integer ; 
  begin
    wait for 1 ns ; 
    
    log("Return integer values as an integer") ;
    AffirmIfEqual(TbID, Get(Params(0), 0), 10,  "Get(Params(0), 0) = 10") ;    
    AffirmIfEqual(TbID, Get(Params(0), 1), 11,  "Get(Params(0), 1) = 11") ;
    AffirmIfEqual(TbID, Get(Params(0), 2),  0,  "Get(Params(0), 2) =  0") ;
    AffirmIfEqual(TbID, Get(Params(0), 3),  1,  "Get(Params(0), 3) =  1") ;
    AffirmIfEqual(TbID, Get(Params(0), 4), 14,  "Get(Params(0), 4) = 14") ;
    
    blankline(2) ; 
    log("Return std_logic_vector values as an std_logic_vector") ;
    AffirmIfEqual(TbID, Get(Params(1), 0), 5X"11",   "Get(Params(1), 5) = 5X""11""") ; 
    AffirmIfEqual(TbID, Get(Params(1), 1), 6X"12",   "Get(Params(1), 6) = 6X""12""") ; 
    AffirmIfEqual(TbID, Get(Params(1), 2), 7X"13",   "Get(Params(1), 7) = 7X""13""") ; 
    AffirmIfEqual(TbID, Get(Params(1), 3), 8X"14",   "Get(Params(1), 8) = 8X""14""") ; 
    AffirmIfEqual(TbID, Get(Params(1), 4), 9X"15",   "Get(Params(1), 9) = 9X""15""") ; 
    
    blankline(2) ; 

    log("Return integer values as an std_logic_vector or boolean") ;
    AffirmIfEqual(TbID, Get(Params(0), 0),   32X"0A",    "Get(Params(0), 0) =  32D""010""") ;
    AffirmIfEqual(TbID, Get(Params(0), 1,4),  4D"11",    "Get(Params(0), 1) = (1,4) = 4D""11""") ;
    AffirmIfEqual(TbID, Get(Params(0), 2),     FALSE,    "Get(Params(0), 2) = (2)   = FALSE") ;
    AffirmIfEqual(TbID, Get(Params(0), 3),      TRUE,    "Get(Params(0), 3) = (3)   = TRUE") ;
    AffirmIfEqual(TbID, Get(Params(0), 4,8),  8D"14",    "Get(Params(0), 4) = (4,8) = 8D""14""") ;
    
    blankline(2) ; 
    log("Return std_logic_vector values as an integer") ;
    AffirmIfEqual(TbID, Get(Params(1), 0), 17, "Get(Params(1), 5) = (17)") ; 
    AffirmIfEqual(TbID, Get(Params(1), 1), 18, "Get(Params(1), 6) = (18)") ; 
    AffirmIfEqual(TbID, Get(Params(1), 2), 19, "Get(Params(1), 7) = (19)") ; 
    AffirmIfEqual(TbID, Get(Params(1), 3), 20, "Get(Params(1), 8) = (20)") ; 
    AffirmIfEqual(TbID, Get(Params(1), 4), 21, "Get(Params(1), 9) = (21)") ; 

    blankline(2) ; 
    log("Set(Params(2), (0,1,2,3,4,5,6,7,8,9))") ;
    Set(Params(2), (20,21,22,23,24,25,26,27,28,29)) ;
    Set(Params(3), (0,1,2,3,4,5,6,7,8,9)) ;
 
    blankline(2) ; 
    log("Check reading values as an integer") ;
    for i in 0 to 9 loop
      AffirmIfEqual(TbID, Get(Params(2), i), 20+i, "Get(Params(2), i) = " & to_string(20+i)) ;
    end loop ; 
    
    blankline(2) ; 
    log("Check reading values as a std_logic_vector") ;
    for i in 0 to 9 loop
      AffirmIfEqual(TbID, Get(Params(3), i, 4), to_slv(i,4), "Get(Params(3), i) = " & to_string(i)) ;
    end loop ; 
    
    EndOfTestReports ;
    std.env.stop;
    
  end process TestProc ; 
end architecture Test ; -- of TbModelParameters2