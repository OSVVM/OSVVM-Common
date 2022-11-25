--
--  File Name:         TbAxi4_SetModelOptions1.vhd
--  Design Unit Name:  Architecture of TestCtrl
--  Revision:          OSVVM MODELS STANDARD VERSION
--
--  Maintainer:        Jim Lewis      email:  jim@synthworks.com
--  Contributor(s):
--     Jim Lewis      jim@synthworks.com
--
--
--  Description:
--    For Manager and Memory: 
--        AWPROT, AWID, AWLOCK, AWCACHE, AWQOS, AWREGION, AWUSER, AWBURST
--        WID, WUSER
--        BRESP, BID, BUSER – BID and BUSER are set by AWID and AWUSER
--        ARPROT, ARID, ARSIZE, ARLOCK, ARCACHE, ARQOS, ARREGION, ARUSER, ARBURST
--        RRESP, RID, RUSER
--
--
--  Developed by:
--        SynthWorks Design Inc.
--        VHDL Training Classes
--        http://www.SynthWorks.com
--
--  Revision History:
--    Date      Version    Description
--    11/2022   2022.11    Initial revision.  
--
--
--  This file is part of OSVVM.
--  
--  Copyright (c) 2022 by SynthWorks Design Inc.  
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

architecture SetModelOptions1 of TestCtrl is

  signal TestDone, StartManager, StartSubordinate : integer_barrier := 1 ;

  signal TbManagerID : AlertLogIDType ; 
  signal TbSubordinateID  : AlertLogIDType ; 
  signal TransactionCount : integer := 0 ; 
  constant BURST_MODE : AddressBusFifoBurstModeType := ADDRESS_BUS_BURST_WORD_MODE ;   
--  constant BURST_MODE : AddressBusFifoBurstModeType := ADDRESS_BUS_BURST_BYTE_MODE ;   
  constant DATA_WIDTH : integer := IfElse(BURST_MODE = ADDRESS_BUS_BURST_BYTE_MODE, 8, AXI_DATA_WIDTH)  ;  

begin

  ------------------------------------------------------------
  -- ControlProc
  --   Set up AlertLog and wait for end of test
  ------------------------------------------------------------
  ControlProc : process
  begin
    -- Initialization of test
    SetTestName("TbAxi4_SetModelOptions1") ;
    TbManagerID <= GetAlertLogID("TB Manager Proc") ;
    TbSubordinateID <= GetAlertLogID("TB Subordinate Proc") ;
    SetLogEnable(PASSED, TRUE) ;  -- Enable PASSED logs
    SetLogEnable(INFO, TRUE) ;    -- Enable INFO logs

    -- Wait for testbench initialization 
    wait for 0 ns ;  wait for 0 ns ;
    TranscriptOpen(OSVVM_RESULTS_DIR & "TbAxi4_SetModelOptions1.txt") ;
    SetTranscriptMirror(TRUE) ; 

    -- Wait for Design Reset
    wait until nReset = '1' ;  
    -- SetAlertLogJustify ;
    ClearAlerts ;
    WaitForBarrier(StartManager) ;

    -- Wait for test to finish
    WaitForBarrier(TestDone, 35 ms) ;
    AlertIf(now >= 35 ms, "Test finished due to timeout") ;
    AlertIf(GetAffirmCount < 1, "Test is not Self-Checking");
    
    
    TranscriptClose ; 
    -- Printing differs in different simulators due to differences in process order execution
    -- AlertIfDiff("./results/TbAxi4_SetModelOptions1.txt", "../sim_shared/validated_results/TbAxi4_SetModelOptions1.txt", "") ; 

    EndOfTestReports ; 
    std.env.stop ; 
    wait ; 
  end process ControlProc ; 

  ------------------------------------------------------------
  -- ManagerProc
  --   Generate transactions for AxiSubordinate
  ------------------------------------------------------------
  ManagerProc : process
    variable IntOption,  IntExpected  : integer ; 
    variable SlvOption,  SlvExpected  : std_logic_vector(7 downto 0) ; 
    variable BoolOption, BoolExpected : boolean ; 
  begin
    WaitForBarrier(StartManager) ;
   
    -- Test AWUSER - configured as 8 bits 
    for i in 0 to 4 loop 
      WaitForClock(ManagerRec, 1, 1) ; 
      IntExpected := i * 2 ; 
      SlvExpected := to_slv(IntExpected, 8) ; 
      case i is 
        when 0 => 
          -- Defaults for AWUSER 
          -- Expecting 0
        when 1 =>
          -- Set with SetAxi4Options and Integer
          SetAxi4Options(ManagerRec, 1, AWUSER,    IntExpected) ;      
        when 2 =>
          -- Set with SetAxi4Options and Std_Logic_Vector
          SetAxi4Options(ManagerRec, 1, AWUSER,    SlvExpected) ;      
        when 3 =>
          -- Set with SetModelOptions and Integer
          SetModelOptions(ManagerRec, 1, Axi4OptionsType'pos(AWUSER),    IntExpected) ;      
        when 4 =>
          -- Set with SetModelOptions and Integer
          SetModelOptions(ManagerRec, 1, Axi4OptionsType'pos(AWUSER),    SlvExpected) ;      
      end case ;  
      
      -- Defaults for AWUSER - configured as 8 bits 
      -- Use GetAxi4Options
      GetAxi4Options(ManagerRec, 1, AWUSER,   IntOption) ;      
      AffirmIfEqual(TbManagerID, IntOption,   IntExpected, "AWUSER") ;  
      GetAxi4Options(ManagerRec, 1, AWUSER,   SlvOption) ;      
      AffirmIfEqual(TbManagerID, SlvOption,   SlvExpected, "AWUSER") ;  
      
      -- Use GetModelOptions
      GetModelOptions(ManagerRec, 1, Axi4OptionsType'pos(AWUSER),   IntOption) ;      -- config: 8 bits
      AffirmIfEqual(TbManagerID, IntOption,   IntExpected, "AWUSER") ;  
      GetModelOptions(ManagerRec, 1, Axi4OptionsType'pos(AWUSER),   SlvOption) ;      -- config: 8 bits
      AffirmIfEqual(TbManagerID, SlvOption,   SlvExpected, "AWUSER") ;  
    end loop ; 
    
    -- Test WRITE_RESPONSE_READY_BEFORE_VALID - boolean 
    for i in 0 to 4 loop 
      WaitForClock(ManagerRec, 1, 1) ; 
      BoolExpected := not BoolExpected; 
      case i is 
        when 0 => 
          -- Defaults for AWUSER 
          -- Expecting TRUE
        when 1 =>
          -- Set with SetAxi4Options 
          SetAxi4Options(ManagerRec, 1, WRITE_RESPONSE_READY_BEFORE_VALID,    BoolExpected) ;      
        when 2 =>
          -- Set with SetModelOptions 
          SetModelOptions(ManagerRec, 1, Axi4OptionsType'pos(WRITE_RESPONSE_READY_BEFORE_VALID),    boolean'pos(BoolExpected)) ;      
        when 3 =>
          -- Set with SetModelOptions 
          SetModelOptions(ManagerRec, 1, Axi4OptionsType'pos(WRITE_RESPONSE_READY_BEFORE_VALID),    boolean'pos(BoolExpected)) ;      
        when 4 =>
          -- Set with SetAxi4Options 
          SetAxi4Options(ManagerRec, 1, WRITE_RESPONSE_READY_BEFORE_VALID,    BoolExpected) ;      
      end case ;  
      
      -- Defaults for AWUSER - configured as 8 bits 
      -- Use GetAxi4Options
      GetAxi4Options(ManagerRec, 1, WRITE_RESPONSE_READY_BEFORE_VALID, BoolOption) ;
      AffirmIfEqual(TbManagerID, BoolOption, BoolExpected, "WRITE_RESPONSE_READY_BEFORE_VALID") ;
      
      -- Use GetModelOptions
      GetModelOptions(ManagerRec, 1, Axi4OptionsType'pos(WRITE_RESPONSE_READY_BEFORE_VALID),   IntOption) ;      -- config: 8 bits
      AffirmIfEqual(TbManagerID, boolean'val(IntOption),   BoolExpected, "WRITE_RESPONSE_READY_BEFORE_VALID") ;  
    end loop ; 
    
    WaitForClock(ManagerRec, 1, 4) ; 
    WaitForBarrier(StartSubordinate) ;
    BlankLine(2) ;
    
    -- Wait for outputs to propagate and signal TestDone
    WaitForClock(ManagerRec, 1, 2) ;
    WaitForBarrier(TestDone) ;
    wait ;
  end process ManagerProc ;
  
  
  ------------------------------------------------------------
  -- SubordinateProc
  --   Generate transactions for AxiSubordinate
  ------------------------------------------------------------
  SubordinateProc : process
    variable IntOption,  IntExpected  : integer ; 
    variable SlvOption,  SlvExpected  : std_logic_vector(7 downto 0) ; 
    variable BoolOption, BoolExpected : boolean ; 
  begin

    -- Start Subordinate test after Manager test - for output clarity.
    WaitForBarrier(StartSubordinate) ;
    
    -- Test BUSER - configured as 8 bits 
    for i in 0 to 4 loop 
      WaitForClock(SubordinateRec, 1, 1) ; 
      IntExpected := i * 2 ; 
      SlvExpected := to_slv(IntExpected, 8) ; 
      case i is 
        when 0 => 
          -- Defaults for BUSER 
          -- Expecting 0
        when 1 =>
          -- Set with SetAxi4Options and Integer
          SetAxi4Options(SubordinateRec, 1, BUSER,    IntExpected) ;      
        when 2 =>
          -- Set with SetAxi4Options and Std_Logic_Vector
          SetAxi4Options(SubordinateRec, 1, BUSER,    SlvExpected) ;      
        when 3 =>
          -- Set with SetModelOptions and Integer
          SetModelOptions(SubordinateRec, 1, Axi4OptionsType'pos(BUSER),    IntExpected) ;      
        when 4 =>
          -- Set with SetModelOptions and Integer
          SetModelOptions(SubordinateRec, 1, Axi4OptionsType'pos(BUSER),    SlvExpected) ;      
      end case ;  
      
      -- Defaults for BUSER - configured as 8 bits 
      -- Use GetAxi4Options
      GetAxi4Options(SubordinateRec, 1, BUSER,   IntOption) ;      
      AffirmIfEqual(TbSubordinateID, IntOption,   IntExpected, "BUSER") ;  
      GetAxi4Options(SubordinateRec, 1, BUSER,   SlvOption) ;      
      AffirmIfEqual(TbSubordinateID, SlvOption,   SlvExpected, "BUSER") ;  
      
      -- Use GetModelOptions
      GetModelOptions(SubordinateRec, 1, Axi4OptionsType'pos(BUSER),   IntOption) ;      -- config: 8 bits
      AffirmIfEqual(TbSubordinateID, IntOption,   IntExpected, "BUSER") ;  
      GetModelOptions(SubordinateRec, 1, Axi4OptionsType'pos(BUSER),   SlvOption) ;      -- config: 8 bits
      AffirmIfEqual(TbSubordinateID, SlvOption,   SlvExpected, "BUSER") ;  
    end loop ; 
    
    -- Test WRITE_ADDRESS_READY_BEFORE_VALID - boolean 
    for i in 0 to 4 loop 
      WaitForClock(SubordinateRec, 1, 1) ; 
      BoolExpected := not BoolExpected; 
      case i is 
        when 0 => 
          -- Defaults for BUSER 
          -- Expecting TRUE
        when 1 =>
          -- Set with SetAxi4Options 
          SetAxi4Options(SubordinateRec, 1, WRITE_ADDRESS_READY_BEFORE_VALID,    BoolExpected) ;      
        when 2 =>
          -- Set with SetModelOptions 
          SetModelOptions(SubordinateRec, 1, Axi4OptionsType'pos(WRITE_ADDRESS_READY_BEFORE_VALID),    boolean'pos(BoolExpected)) ;      
        when 3 =>
          -- Set with SetModelOptions 
          SetModelOptions(SubordinateRec, 1, Axi4OptionsType'pos(WRITE_ADDRESS_READY_BEFORE_VALID),    boolean'pos(BoolExpected)) ;      
        when 4 =>
          -- Set with SetAxi4Options 
          SetAxi4Options(SubordinateRec, 1, WRITE_ADDRESS_READY_BEFORE_VALID,    BoolExpected) ;      
      end case ;  
      
      -- Defaults for BUSER - configured as 8 bits 
      -- Use GetAxi4Options
      GetAxi4Options(SubordinateRec, 1, WRITE_ADDRESS_READY_BEFORE_VALID, BoolOption) ;
      AffirmIfEqual(TbSubordinateID, BoolOption, BoolExpected, "WRITE_ADDRESS_READY_BEFORE_VALID") ;
      
      -- Use GetModelOptions
      GetModelOptions(SubordinateRec, 1, Axi4OptionsType'pos(WRITE_ADDRESS_READY_BEFORE_VALID),   IntOption) ;      -- config: 8 bits
      AffirmIfEqual(TbSubordinateID, boolean'val(IntOption),   BoolExpected, "WRITE_ADDRESS_READY_BEFORE_VALID") ;  
    end loop ; 

    WaitForClock(SubordinateRec, 1, 2) ;
    WaitForBarrier(TestDone) ;
    wait ;
  end process SubordinateProc ;

end SetModelOptions1 ;

Configuration TbAxi4_SetModelOptions1 of TbAxi4Memory is
  for TestHarness
    for TestCtrl_1 : TestCtrl
      use entity work.TestCtrl(SetModelOptions1) ; 
    end for ; 
  end for ; 
end TbAxi4_SetModelOptions1 ; 