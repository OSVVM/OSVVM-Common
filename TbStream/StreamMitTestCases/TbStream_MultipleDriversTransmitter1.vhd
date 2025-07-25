--
--  File Name:         TbStream_MultipleDriversTransmitter1.vhd
--  Design Unit Name:  Architecture of TestCtrl
--  Revision:          OSVVM MODELS STANDARD VERSION
--
--  Maintainer:        Jim Lewis      email:  jim@synthworks.com
--  Contributor(s):
--     Jim Lewis      jim@synthworks.com
--
--
--  Description:
--      Validates Multiple Driver detection works
--
--
--  Developed by:
--        SynthWorks Design Inc.
--        VHDL Training Classes
--        http://www.SynthWorks.com
--
--  Revision History:
--    Date      Version    Description
--    02/2021   2021.02    Initial revision
--
--
--  This file is part of OSVVM.
--  
--  Copyright (c) 2021 by SynthWorks Design Inc.  
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
architecture MultipleDriversTransmitter1 of TestCtrl is

  signal   TestDone : integer_barrier := 1 ;
   
begin

  ------------------------------------------------------------
  -- ControlProc
  --   Set up AlertLog and wait for end of test
  ------------------------------------------------------------
  ControlProc : process
  begin
    -- Initialization of test
    SetTestName("TbStream_MultipleDriversTransmitter1") ;
    SetLogEnable(PASSED, TRUE) ;    -- Enable PASSED logs
    SetLogEnable(INFO, TRUE) ;    -- Enable INFO logs
    SetAlertStopCount(FAILURE, 2) ;    -- Allow 2 FAILURE Alerts

    -- Wait for testbench initialization 
    wait for 0 ns ;  wait for 0 ns ;
    TranscriptOpen ;
    SetTranscriptMirror(TRUE) ; 

    -- Wait for Design Reset
    wait until nReset = '1' ;  
    ClearAlerts ;

    -- Wait for test to finish
    WaitForBarrier(TestDone, 35 ms) ;
    
    TranscriptClose ; 
--    AffirmIfTranscriptsMatch(PATH_TO_VALIDATED_RESULTS) ;
    
    EndOfTestReports(ExternalErrors => (FAILURE => -1, ERROR => 0, WARNING => 0), TimeOut => (now >= 35 ms)) ; 

    std.env.stop ;
    wait ; 
  end process ControlProc ; 

  
  ------------------------------------------------------------
  -- TransmitterProc
  --   Generate transactions for Transmitter
  ------------------------------------------------------------
  TransmitterProc : process
  begin
    wait until nReset = '1' ;  
    WaitForClock(StreamTxRec, 2) ; 
    WaitForClock(StreamTxRec, 3) ; 
    
    WaitForBarrier(TestDone) ;
    wait ;
  end process TransmitterProc ;


  ------------------------------------------------------------
  -- ReceiverProc
  --   Generate transactions for Receiver
  ------------------------------------------------------------
  ReceiverProc : process
  begin
    wait until nReset = '1' ;  
    WaitForClock(StreamRxRec, 2) ; 
    WaitForClock(StreamRxRec, 2) ; 
    WaitForClock(StreamTxRec, 2) ; 
    
    WaitForBarrier(TestDone) ;
    wait ;
  end process ReceiverProc ;

end MultipleDriversTransmitter1 ;

Configuration TbStream_MultipleDriversTransmitter1 of TbStream is
  for TestHarness
    for TestCtrl_1 : TestCtrl
      use entity work.TestCtrl(MultipleDriversTransmitter1) ; 
    end for ; 
  end for ; 
end TbStream_MultipleDriversTransmitter1 ; 