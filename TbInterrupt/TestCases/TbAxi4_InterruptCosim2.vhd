--
--  File Name:         TbAxi4_Interrupt1.vhd
--  Design Unit Name:  Architecture of TestCtrl
--  Revision:          OSVVM MODELS STANDARD VERSION
--
--  Maintainer:        Jim Lewis      email:  jim@synthworks.com
--  Contributor(s):
--     Jim Lewis      jim@synthworks.com
--
--
--  Description:
--      Test transaction source
--
--
--  Developed by:
--        SynthWorks Design Inc.
--        VHDL Training Classes
--        http://www.SynthWorks.com
--
--  Revision History:
--    Date      Version    Description
--    10/2022   2022.10    Updated for new interrupt handler
--    04/2021   2021.04    Initial revision
--
--
--  This file is part of OSVVM.
--
--  Copyright (c) 2021-2022 by SynthWorks Design Inc.
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

library osvvm_tbcosim ;
  use osvvm_tbcosim.OsvvmVprocPkg.all ;
  use osvvm_tbcosim.OsvvmTestCoSimPkg.all;
  
library osvvm_common ;

  use osvvm_common.InterruptHandlerComponentPkg.all ;

architecture InterruptCosim2 of TestCtrl is

  signal ManagerSync1, MemorySync1, TestDone : integer_barrier := 1 ;

begin

  ------------------------------------------------------------
  -- ControlProc
  --   Set up AlertLog and wait for end of test
  ------------------------------------------------------------
  ControlProc : process
  begin

    -- Initialization of test
    SetTestName("TbAxi4_Interruptcosim1") ;
    SetLogEnable(PASSED, TRUE) ;    -- Enable PASSED logs
    SetLogEnable(INFO, TRUE) ;    -- Enable INFO logs
    SetLogEnable(GetAlertLogID("Memory_1"), INFO, FALSE) ;

    -- Wait for testbench initialization
    wait for 0 ns ;  wait for 0 ns ;
    TranscriptOpen(OSVVM_RESULTS_DIR & "TbAxi4_InterruptCosim2.txt") ;
    SetTranscriptMirror(TRUE) ;

    -- Wait for Design Reset
    wait until nReset = '1' ;
    ClearAlerts ;

    -- Wait for test to finish
    WaitForBarrier(TestDone, 35 ms) ;
    AlertIf(now >= 35 ms, "Test finished due to timeout") ;
    AlertIf(GetAffirmCount < 1, "Test is not Self-Checking");


    TranscriptClose ;
    -- Printing differs in different simulators due to differences in process order execution
    -- AlertIfDiff("./results/TbAxi4_InterruptCosim2.txt", "../AXI4/Axi4/testbench/validated_results/TbAxi4_InterruptCosim2.txt", "") ;

    EndOfTestReports ;
    std.env.stop ;
    wait ;
  end process ControlProc ;

  ------------------------------------------------------------
  -- ManagerProc
  --   Generate transactions for AxiManager
  ------------------------------------------------------------
  ManagerProc : process
    variable Data        : std_logic_vector(AXI_DATA_WIDTH-1 downto 0) := (others => '0') ;
    variable Ticks       : integer := 0 ;
    variable Done        : integer := 0 ;
    variable Error       : integer := 0 ;
    variable Node        : integer := 0 ;
    variable Int         : boolean := false ;
    variable gIntReqLast : boolean := false ;
    variable WaitForClockRV : RandomPType ;
  begin
    wait until nReset = '1' ;
    WaitForClock(ManagerRec, 2) ;

    -- Initialise VProc code
    CoSimInit(Node);

    OperationLoop : loop
    
      -- 20 % of the time add a no-op cycle with a delay of 1 to 5 clocks
      if WaitForClockRV.DistInt((8, 2)) = 1 and Ticks = 0 then
        WaitForClock(ManagerRec, WaitForClockRV.RandInt(1, 5)) ;
      end if ;
      
      -- Inspect interrupt state and flag when global signal changes
      Int         := true when gIntReq /= gIntReqLast else false ;
       -- Remember the global interrupt state for next iteration 
      gIntReqLast := gIntReq;

      -- Call co-simulation procedure
      CoSimTrans(ManagerRec, Ticks, Done, Error, Int, Node) ;

      -- Alter if an error
      AlertIf(Error /= 0, "CoSimTrans flagged an error") ;

      -- Finish when counts == 0
      exit when Ticks = 0 and Done /= 0;

    end loop OperationLoop ;
 
    -- Wait for outputs to propagate and signal TestDone
    WaitForClock(ManagerRec, 2) ;
    WaitForBarrier(TestDone) ;
    wait ;
  end process ManagerProc ;

  ------------------------------------------------------------
  -- InterruptProc
  --   Generate interupts in lieu of a DUT
  ------------------------------------------------------------
  InterruptProc : process
  begin
  
    wait until nReset = '1' ;
  
    IntReq <= '1' after 105 ns , '0' after 155 ns ;
  
    wait ;
  
  end process InterruptProc ;

  ------------------------------------------------------------
  -- SubordinateProc
  --   Generate transactions for AxiSubordinate
  ------------------------------------------------------------
  SubordinateProc : process
    variable Addr : std_logic_vector(AXI_ADDR_WIDTH-1 downto 0) ;
    variable Data : std_logic_vector(AXI_DATA_WIDTH-1 downto 0) ;
  begin

    -- Wait for outputs to propagate and signal TestDone
    WaitForClock(SubordinateRec, 2) ;
    WaitForBarrier(TestDone) ;
    wait ;
  end process SubordinateProc ;


end InterruptCosim2 ;

Configuration TbAxi4_InterruptCosim2 of TbAxi4Memory is
  for TestHarness
    for TestCtrl_1 : TestCtrl
      use entity work.TestCtrl(InterruptCosim2) ;
    end for ;
--!!    for Subordinate_1 : Axi4Subordinate
--!!      use entity OSVVM_AXI4.Axi4Memory ;
--!!    end for ;
  end for ;
end TbAxi4_InterruptCosim2 ;