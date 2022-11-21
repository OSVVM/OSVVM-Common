--
--  File Name:         TbAxi_SetBurstMode1.vhd
--  Design Unit Name:  Architecture of TestCtrl
--  Revision:          OSVVM MODELS STANDARD VERSION
--
--  Maintainer:        Jim Lewis      email:  jim@synthworks.com
--  Contributor(s):
--     Jim Lewis      jim@synthworks.com
--
--
--  Description:
--      Set AXI Ready Time.   Check Timeout on Valid (nominally large or infinite?)
--
--
--  Developed by:
--        SynthWorks Design Inc.
--        VHDL Training Classes
--        http://www.SynthWorks.com
--
--  Revision History:
--    Date      Version    Description
--    11/2022   2022.11    Initial revision
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
architecture SetBurstMode1 of TestCtrl is

  signal TestDone, TestPhaseStart : integer_barrier := 1 ;
   
begin

  ------------------------------------------------------------
  -- ControlProc
  --   Set up AlertLog and wait for end of test
  ------------------------------------------------------------
  ControlProc : process
  begin
    -- Initialization of test
    SetTestName("TbAxi_SetBurstMode1") ;
    SetLogEnable(PASSED, TRUE) ;    -- Enable PASSED logs
    SetLogEnable(INFO, TRUE) ;    -- Enable INFO logs
    SetAlertStopCount(FAILURE, integer'right) ;  -- Allow FAILURES

    -- Wait for testbench initialization 
    wait for 0 ns ;  wait for 0 ns ;
    TranscriptOpen(OSVVM_RESULTS_DIR & "TbAxi_SetBurstMode1.txt") ;
    SetTranscriptMirror(TRUE) ; 

    -- Wait for Design Reset
    wait until nReset = '1' ;  

    -- Wait for test to finish
    WaitForBarrier(TestDone, 35 ms) ;
    AlertIf(now >= 35 ms, "Test finished due to timeout") ;
    AlertIf(GetAffirmCount < 1, "Test is not Self-Checking");
    
    TranscriptClose ; 
--    AlertIfDiff("./results/TbAxi_SetBurstMode1.txt", "../sim_shared/validated_results/TbAxi_SetBurstMode1.txt", "") ; 
    
    EndOfTestReports ; 
    std.env.stop ;
    wait ; 
  end process ControlProc ; 

  
  ------------------------------------------------------------
  -- AxiTransmitterProc
  --   Generate transactions for AxiTransmitter
  ------------------------------------------------------------
  AxiTransmitterProc : process
    variable BurstMode : StreamFifoBurstModeType ; 
  begin
    WaitForClock(StreamTxRec, 1) ; 
    
    GetBurstMode(StreamTxRec, BurstMode) ;
    log("Default BurstMode " & to_string(BurstMode)) ; 
    SetBurstMode(StreamTxRec, STREAM_BURST_BYTE_MODE) ;
    GetBurstMode(StreamTxRec, BurstMode) ;
    AffirmIf(BurstMode = STREAM_BURST_BYTE_MODE, "BurstMode = " & to_string(BurstMode), "Expected STREAM_BURST_BYTE_MODE") ; 
    SetBurstMode(StreamTxRec, STREAM_BURST_WORD_MODE) ;
    GetBurstMode(StreamTxRec, BurstMode) ;
    AffirmIf(BurstMode = STREAM_BURST_WORD_MODE, "BurstMode = " & to_string(BurstMode), "Expected STREAM_BURST_WORD_MODE") ; 
    SetBurstMode(StreamTxRec, STREAM_BURST_WORD_PARAM_MODE) ;
    GetBurstMode(StreamTxRec, BurstMode) ;
    AffirmIf(BurstMode = STREAM_BURST_WORD_PARAM_MODE, "BurstMode = " & to_string(BurstMode), "Expected STREAM_BURST_WORD_PARAM_MODE") ; 


    -- Wait for outputs to propagate and signal TestDone
    WaitForClock(StreamTxRec, 2) ;
    WaitForBarrier(TestDone) ;
    wait ;
  end process AxiTransmitterProc ;


  ------------------------------------------------------------
  -- AxiReceiverProc
  --   Generate transactions for AxiReceiver
  ------------------------------------------------------------
  AxiReceiverProc : process
    variable BurstMode : StreamFifoBurstModeType ; 
  begin
    WaitForClock(StreamRxRec, 2) ; 
    
    GetBurstMode(StreamRxRec, BurstMode) ;
    log("Default BurstMode " & to_string(BurstMode)) ; 
    SetBurstMode(StreamRxRec, STREAM_BURST_BYTE_MODE) ;
    GetBurstMode(StreamRxRec, BurstMode) ;
    AffirmIf(BurstMode = STREAM_BURST_BYTE_MODE, "BurstMode = " & to_string(BurstMode), "Expected STREAM_BURST_BYTE_MODE") ; 
    SetBurstMode(StreamRxRec, STREAM_BURST_WORD_MODE) ;
    GetBurstMode(StreamRxRec, BurstMode) ;
    AffirmIf(BurstMode = STREAM_BURST_WORD_MODE, "BurstMode = " & to_string(BurstMode), "Expected STREAM_BURST_WORD_MODE") ; 
    SetBurstMode(StreamRxRec, STREAM_BURST_WORD_PARAM_MODE) ;
    GetBurstMode(StreamRxRec, BurstMode) ;
    AffirmIf(BurstMode = STREAM_BURST_WORD_PARAM_MODE, "BurstMode = " & to_string(BurstMode), "Expected STREAM_BURST_WORD_PARAM_MODE") ; 

 
    -- Wait for outputs to propagate and signal TestDone
    WaitForClock(StreamRxRec, 2) ;
    WaitForBarrier(TestDone) ;
    wait ;
  end process AxiReceiverProc ;

end SetBurstMode1 ;

Configuration TbAxi_SetBurstMode1 of TbStream is
  for TestHarness
    for TestCtrl_1 : TestCtrl
      use entity work.TestCtrl(SetBurstMode1) ; 
    end for ; 
  end for ; 
end TbAxi_SetBurstMode1 ; 