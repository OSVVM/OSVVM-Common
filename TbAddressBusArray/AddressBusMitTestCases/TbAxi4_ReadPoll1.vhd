--
--  File Name:         TbAxi4_ReadPoll1.vhd
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
--    11/2022   2022.11    Initial
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

architecture ReadPoll1 of TestCtrl is

  signal TestDone, Sync : integer_barrier := 1 ;
 
begin

  ------------------------------------------------------------
  -- ControlProc
  --   Set up AlertLog and wait for end of test
  ------------------------------------------------------------
  ControlProc : process
  begin
    -- Initialization of test
    SetTestName("TbAxi4_ReadPoll1") ;
    SetLogEnable(PASSED, TRUE) ;    -- Enable PASSED logs
    SetLogEnable(INFO, TRUE) ;    -- Enable INFO logs

    -- Wait for testbench initialization 
    wait for 0 ns ;  wait for 0 ns ;
    TranscriptOpen(OSVVM_RESULTS_DIR & "TbAxi4_ReadPoll1.txt") ;
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
    -- AlertIfDiff("./results/TbAxi4_ReadPoll1.txt", "../AXI4/Axi4/testbench/validated_results/TbAxi4_ReadPoll1.txt", "") ; 

    EndOfTestReports ; 
    std.env.stop ; 
    wait ; 
  end process ControlProc ; 

  ------------------------------------------------------------
  -- ManagerProc
  --   Generate transactions for AxiManager
  ------------------------------------------------------------
  ManagerProc : process
    variable Data : std_logic_vector(AXI_DATA_WIDTH-1 downto 0) ;
  begin
    wait until nReset = '1' ;  
    WaitForClock(ManagerRec, 1, 2) ; 
    --  ------------------------------------------------------------
    --  procedure ReadPoll (
    --  -- Read location (iAddr) until Data(IndexI) = ValueI
    --  -- WaitTime is the number of clocks to wait between reads.
    --  -- oData is the value read.
    --  ------------------------------------------------------------
    --    signal   TransactionRec : InOut AddressBusRecType ;
    --             iAddr          : In    std_logic_vector ;
    --    variable oData          : Out   std_logic_vector ;
    --             Index          : In    Integer ;
    --             BitValue       : In    std_logic ;
    --             StatusMsgOn    : In    boolean := false ;
    --             WaitTime       : In    natural := 10
    --  ) ;
    --
    --  ------------------------------------------------------------
    --  procedure ReadPoll (
    --  -- Read location (iAddr) until Data(IndexI) = ValueI
    --  -- WaitTime is the number of clocks to wait between reads.
    --  ------------------------------------------------------------
    --    signal   TransactionRec : InOut AddressBusRecType ;
    --             iAddr          : In    std_logic_vector ;
    --             Index          : In    Integer ;
    --             BitValue       : In    std_logic ;
    --             StatusMsgOn    : In    boolean := false ;
    --             WaitTime       : In    natural := 10
    --  ) ;
    log("ReadPoll ") ;
    
    
    WaitForBarrier(Sync) ;
    WaitForClock(ManagerRec, 1, 4) ; 
    --     ReadPoll(TransactionRec, iAddr, vData, Index, BitValue, StatusMsgOn, WaitTime) ;
    ReadPoll(ManagerRec, 1,  X"1111_1110", Data, 2, '1') ;  -- "x1xx"
    AffirmIfEqual(Data, X"1111_1114", "Manager ReadPoll Data: ") ;
    
    ReadPoll(ManagerRec, 1,  X"2222_2221", Data(7 downto 0), 2, '0') ;  -- "x0xx"
    AffirmIfEqual(Data(7 downto 0), X"20", "Manager ReadPoll Data: ") ;

    ReadPoll(ManagerRec, 1,  X"3333_3330", 4, '1') ;  -- "1_xxxx"
    Data(15 downto 0) := SafeResize(ManagerRec(1).DataFromModel(15 downto 0), 16) ; 
    AffirmIfEqual(Data(15 downto 0), X"1130", "Manager ReadPoll Data: ") ;
    
    ReadPoll(ManagerRec, 1,  X"4444_4444", 4, '0') ;  -- "0_xxxx"
    Data(23 downto 0) := SafeResize(ManagerRec(1).DataFromModel(23 downto 0), 24) ; 
    AffirmIfEqual(Data(23 downto 0), X"44440F", "Manager ReadPoll Data: ") ;
    

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
    variable Addr : std_logic_vector(AXI_ADDR_WIDTH-1 downto 0) ;
  begin
    WaitForBarrier(Sync) ;

    for i in 1 to 4 loop 
      SendRead(SubordinateRec, 1, Addr, X"1111_1110" + i) ; 
      AffirmIfEqual(Addr, X"1111_1110", "Subordinate Read Addr: ") ;
    end loop ; 
    
    for i in 1 to 4 loop 
      SendRead(SubordinateRec, 1, Addr, X"1C" + i) ; 
    end loop ; 
    AffirmIfEqual(Addr, X"2222_2221", "Subordinate Read Addr: ") ;

    for i in 1 to 6 loop 
      SendRead(SubordinateRec, 1, Addr, X"112A" + i) ; 
    end loop ; 
    AffirmIfEqual(Addr, X"3333_3330", "Subordinate Read Addr: ") ;

    for i in 1 to 3 loop 
      SendRead(SubordinateRec, 1, Addr, X"444412" - i) ; 
    end loop ; 
    AffirmIfEqual(Addr, X"4444_4444", "Subordinate Read Addr: ") ;


    -- Wait for outputs to propagate and signal TestDone
    WaitForClock(SubordinateRec, 1, 2) ;
    WaitForBarrier(TestDone) ;
    wait ;
  end process SubordinateProc ;


end ReadPoll1 ;

Configuration TbAxi4_ReadPoll1 of TbAxi4 is
  for TestHarness
    for TestCtrl_1 : TestCtrl
      use entity work.TestCtrl(ReadPoll1) ; 
    end for ; 
  end for ; 
end TbAxi4_ReadPoll1 ; 