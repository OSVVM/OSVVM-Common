--
--  File Name:         TbStream_GotBurst1.vhd
--  Design Unit Name:  Architecture of TestCtrl
--  Revision:          OSVVM MODELS STANDARD VERSION
--
--  Maintainer:        Jim Lewis      email:  jim@synthworks.com
--  Contributor(s):
--     Jim Lewis      jim@synthworks.com
--
--
--  Description:
--      Validates Stream Model Independent Transactions
--      Send, Get, Check, 
--      WaitForTransaction, GetTransactionCount
--      GetAlertLogID, GetErrorCount, 
--
--
--  Developed by:
--        SynthWorks Design Inc.
--        VHDL Training Classes
--        http://www.SynthWorks.com
--
--  Revision History:
--    Date      Version    Description
--    01/2022   2022.11    Initial revision
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
architecture GotBurst1 of TestCtrl is

  signal   TestDone : integer_barrier := 1 ;
   
begin

  ------------------------------------------------------------
  -- ControlProc
  --   Set up AlertLog and wait for end of test
  ------------------------------------------------------------
  ControlProc : process
  begin
    -- Initialization of test
    SetTestName("TbStream_GotBurst1") ;
    SetLogEnable(PASSED, TRUE) ;    -- Enable PASSED logs
    SetLogEnable(INFO, TRUE) ;    -- Enable INFO logs

    -- Wait for simulation elaboration/initialization 
    wait for 0 ns ;  wait for 0 ns ;
    TranscriptOpen(OSVVM_RESULTS_DIR & "TbStream_GotBurst1.txt") ;
    SetTranscriptMirror(TRUE) ; 

    -- Wait for Design Reset
    wait until nReset = '1' ;  
    ClearAlerts ;

    -- Wait for test to finish
    WaitForBarrier(TestDone, 35 ms) ;
    AlertIf(now >= 35 ms, "Test finished due to timeout") ;
    AlertIf(GetAffirmCount < 1, "Test is not Self-Checking");
    
    TranscriptClose ; 
--    AlertIfDiff("TbStream_GotBurst1.txt", "../sim_shared/validated_results/TbStream_GotBurst1.txt", "") ; 
    
    -- Expecting two check errors at 128 and 256
    EndOfTestReports(ExternalErrors => (0, 0, 0)) ; 
    std.env.stop ;
    wait ; 
  end process ControlProc ; 

  
  ------------------------------------------------------------
  -- AxiTransmitterProc
  --   Generate transactions for AxiTransmitter
  ------------------------------------------------------------
  TransmitterProc : process
    variable CoverID : CoverageIdType ; 
  begin

    wait until nReset = '1' ;  
    WaitForClock(StreamTxRec, 2) ; 
    
-- SendBurst and GetBurst    
    log("Send 32 word burst") ;
    for I in 1 to 32 loop 
      Push( StreamTxRec.BurstFifo, X"0000_2000" + I  ) ; 
    end loop ; 
    SendBurstAsync(StreamTxRec, 32) ;

-- SendBurst and CheckBurst    
    log("Send 32 word burst") ;
    for I in 1 to 32 loop 
      Push( StreamTxRec.BurstFifo, X"0000_3000" + I ) ; 
    end loop ; 
    SendBurstAsync(StreamTxRec, 32) ;

    -- Wait for outputs to propagate and signal TestDone
    WaitForClock(StreamTxRec, 2) ;
    WaitForBarrier(TestDone) ;
    wait ;
  end process TransmitterProc ;


  ------------------------------------------------------------
  -- AxiReceiverProc
  --   Generate transactions for AxiReceiver
  ------------------------------------------------------------
  ReceiverProc : process
    variable ExpData, RxData : std_logic_vector(DATA_WIDTH-1 downto 0) ;  
    variable NumBytes : integer ; 
    variable TryCount : integer := 0; 
    variable CoverID : CoverageIdType ; 
    variable slvBurstVector : slv_vector(1 to 5)(31 downto 0) ; 
    variable intBurstVector : integer_vector(1 to 5) ; 
    variable Available : boolean ; 
  begin
    WaitForClock(StreamRxRec, 2) ; 
    
--    log("Send 32 word burst") ;
    TryCount := 0 ; 
    loop 
      GotBurst(StreamRxRec, 32, Available) ; 
 --     TryGetBurst (StreamRxRec, NumBytes, Available) ;
      exit when Available ; 
      WaitForClock(StreamRxRec, 1) ; 
      TryCount := TryCount + 1 ;
    end loop ;
    TryGetBurst (StreamRxRec, NumBytes, Available) ;
    AffirmIfEqual(Available, TRUE, "TryGetBurst after GotBurst") ; 
    AffirmIf(TryCount > 0, "TryCount " & to_string(TryCount)) ; 
    AffirmIfEqual(NumBytes, 32, "Receiver: 32 Received") ;
    for I in 1 to 32 loop 
      RxData := Pop( StreamRxRec.BurstFifo ) ;      
      AffirmIfEqual(RxData, X"0000_2000" + I , "RxData") ;
    end loop ; 

--    log("Send 32 word burst") ;
    for I in 1 to 32 loop 
      Push( StreamRxRec.BurstFifo, X"0000_3000" + I  ) ; 
    end loop ; 
    TryCount := 0 ; 
    loop 
      GotBurst(StreamRxRec, 32, Available) ; 
--      TryCheckBurst (StreamRxRec, 32, Available) ;
      exit when Available ; 
      WaitForClock(StreamRxRec, 1) ; 
      TryCount := TryCount + 1 ;
    end loop ;
    TryCheckBurst (StreamRxRec, 32, Available) ;
    AffirmIfEqual(Available, TRUE, "TryCheckBurst after GotBurst") ; 
    AffirmIf(TryCount > 0, "TryCount " & to_string(TryCount)) ; 



    -- Wait for outputs to propagate and signal TestDone
    WaitForClock(StreamRxRec, 2) ;
    WaitForBarrier(TestDone) ;
    wait ;
  end process ReceiverProc ;

end GotBurst1 ;

Configuration TbStream_GotBurst1 of TbStream is
  for TestHarness
    for TestCtrl_1 : TestCtrl
      use entity work.TestCtrl(GotBurst1) ; 
    end for ; 
  end for ; 
end TbStream_GotBurst1 ; 