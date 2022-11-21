--
--  File Name:         TbAxi_SendGetAllParam1.vhd
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
--    01/2022   2022.01    Initial revision
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
architecture SendGetAllParam1 of TestCtrl is

  signal   TestDone : integer_barrier := 1 ;
   
begin

  ------------------------------------------------------------
  -- ControlProc
  --   Set up AlertLog and wait for end of test
  ------------------------------------------------------------
  ControlProc : process
  begin
    -- Initialization of test
    SetTestName("TbAxi_SendGetAllParam1") ;
    SetLogEnable(PASSED, TRUE) ;    -- Enable PASSED logs
    SetLogEnable(INFO, TRUE) ;    -- Enable INFO logs

    -- Wait for simulation elaboration/initialization 
    wait for 0 ns ;  wait for 0 ns ;
    TranscriptOpen(OSVVM_RESULTS_DIR & "TbAxi_SendGetAllParam1.txt") ;
    SetTranscriptMirror(TRUE) ; 

    -- Wait for Design Reset
    wait until nReset = '1' ;  
    ClearAlerts ;

    -- Wait for test to finish
    WaitForBarrier(TestDone, 35 ms) ;
    AlertIf(now >= 35 ms, "Test finished due to timeout") ;
    AlertIf(GetAffirmCount < 1, "Test is not Self-Checking");
    
    TranscriptClose ; 
--    AlertIfDiff("./results/TbAxi_SendGetAllParam1.txt", "../sim_shared/validated_results/TbAxi_SendGetAllParam1.txt", "") ; 
    
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
    variable ID   : std_logic_vector(ID_LEN-1 downto 0) ;    -- 8
    variable Dest : std_logic_vector(DEST_LEN-1 downto 0) ;  -- 4
    variable User : std_logic_vector(USER_LEN-1 downto 0) ;  -- 4
    variable TxParam : std_logic_vector(ID_LEN + DEST_LEN + USER_LEN downto 0) ;
  begin

    wait until nReset = '1' ;  
    WaitForClock(StreamTxRec, 2) ; 
    
    ID   := to_slv(1, ID_LEN);
    Dest := to_slv(2, DEST_LEN) ; 
    User := to_slv(3, USER_LEN) ; 
    TxParam := ID & Dest & User & '0' ;

-- Send and Get    
    log("Transmit 32 words") ;
    for I in 1 to 32 loop 
      Send( StreamTxRec, X"0000_0000" + I, TxParam) ; 
    end loop ; 

-- Send and Check    
    log("Transmit 32 words") ;
    for I in 1 to 32 loop 
      Send( StreamTxRec, X"0000_1000" + I, TxParam) ; 
    end loop ; 

    TxParam := ID & Dest & User & '1' ;

-- SendBurst and GetBurst    
    log("Send 32 word burst") ;
    for I in 1 to 32 loop 
      Push( StreamTxRec.BurstFifo, X"0000_2000" + I  ) ; 
    end loop ; 
    SendBurst(StreamTxRec, 32, TxParam) ;

-- SendBurst and CheckBurst    
    log("Send 32 word burst") ;
    for I in 1 to 32 loop 
      Push( StreamTxRec.BurstFifo, X"0000_3000" + I ) ; 
    end loop ; 
    SendBurst(StreamTxRec, 32, TxParam) ;

-- SendBurst and CheckBurst    
    log("SendBurstVector 13 word burst") ;
    SendBurstVector(StreamTxRec, 
        (X"0000_4001", X"0000_4003", X"0000_4005", X"0000_4007", X"0000_4009",
         X"0000_4011", X"0000_4013", X"0000_4015", X"0000_4017", X"0000_4019",
         X"0000_4021", X"0000_4023", X"0000_4025"), TxParam ) ;
   

-- SendBurstIncrement and CheckBurstIncrement    
    log("SendBurstIncrement 16 word burst") ;
    SendBurstIncrement(StreamTxRec, X"0000_5000", 16, TxParam) ; 

-- SendBurstRandom and CheckBurstRandom    
    log("SendBurstRandom 24 word burst") ;
    SendBurstRandom   (StreamTxRec, X"0000_6000", 24, TxParam) ; 
    
-- Coverage:  SendBurstRandom and CheckBurstRandom    
    CoverID := NewID("Cov1") ; 
    InitSeed(CoverID, 5) ; -- Get a common seed in both processes
    AddBins(CoverID, 1, GenBin(16#7000#, 16#7007#) & GenBin(16#7010#, 16#7017#) & GenBin(16#7020#, 16#7027#) & GenBin(16#7030#, 16#7037#)) ; 

    log("SendBurstRandom 42 word burst") ;
    SendBurstRandom   (StreamTxRec, CoverID, 42, 32, TxParam) ; 

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
    variable CoverID : CoverageIdType ; 
    variable slvBurstVector : slv_vector(1 to 5)(31 downto 0) ; 
    variable intBurstVector : integer_vector(1 to 5) ; 
    variable ExpParam, RxParam : std_logic_vector(ID_LEN + DEST_LEN + USER_LEN downto 0) ;
    variable ID   : std_logic_vector(ID_LEN-1 downto 0) ;    -- 8
    variable Dest : std_logic_vector(DEST_LEN-1 downto 0) ;  -- 4
    variable User : std_logic_vector(USER_LEN-1 downto 0) ;  -- 4
  begin
    
    ID   := to_slv(1, ID_LEN);
    Dest := to_slv(2, DEST_LEN) ; 
    User := to_slv(3, USER_LEN) ; 

    WaitForClock(StreamRxRec, 2) ; 
    
    ExpParam := ID & Dest & User & '0' ;
    
--    log("Transmit 32 words") ;
    for I in 1 to 32 loop 
      Get(StreamRxRec, RxData, RxParam) ;      
      AffirmIfEqual(RxData, X"0000_0000" + I, "RxData") ;
      AffirmIfEqual(RxParam, ExpParam, "Get, Param: ") ;
    end loop ;

--    log("Transmit 32 words") ;
    for I in 1 to 32 loop 
      Check(StreamRxRec, X"0000_1000" + I, ExpParam ) ;      
    end loop ; 

    ExpParam := ID & Dest & User & '1' ;

--    log("Send 32 word burst") ;
    GetBurst(StreamRxRec, NumBytes, RxParam) ;
    AffirmIfEqual(NumBytes, 32, "Receiver: 32 Received") ;
    for I in 1 to 32 loop 
      RxData := Pop( StreamRxRec.BurstFifo ) ;      
      AffirmIfEqual(RxData, X"0000_2000" + I , "RxData") ;
    end loop ; 
    AffirmIfEqual(RxParam, ExpParam, "GetBurst, Param: ") ;

--    log("Send 32 word burst") ;
    for I in 1 to 32 loop 
      Push( StreamRxRec.BurstFifo, X"0000_3000" + I  ) ; 
    end loop ; 
    CheckBurst(StreamRxRec, 32, ExpParam) ;

    CheckBurstVector(StreamRxRec, 
        (X"0000_4001", X"0000_4003", X"0000_4005", X"0000_4007", X"0000_4009",
         X"0000_4011", X"0000_4013", X"0000_4015", X"0000_4017", X"0000_4019",
         X"0000_4021", X"0000_4023", X"0000_4025"), ExpParam ) ;
   
    CheckBurstIncrement(StreamRxRec, X"0000_5000", 16, ExpParam) ; 

    CheckBurstRandom   (StreamRxRec, X"0000_6000", 24, ExpParam) ; 

    CoverID := NewID("Cov2") ; 
    InitSeed(CoverID, 5) ; -- Get a common seed in both processes
    AddBins(CoverID, 1, 
        GenBin(16#7000#, 16#7007#) & GenBin(16#7010#, 16#7017#) & 
        GenBin(16#7020#, 16#7027#) & GenBin(16#7030#, 16#7037#)) ; 

    CheckBurstRandom   (StreamRxRec, CoverID, 42, 32, ExpParam) ; 
    

    -- Wait for outputs to propagate and signal TestDone
    WaitForClock(StreamRxRec, 2) ;
    WaitForBarrier(TestDone) ;
    wait ;
  end process ReceiverProc ;

end SendGetAllParam1 ;

Configuration TbAxi_SendGetAllParam1 of TbStream is
  for TestHarness
    for TestCtrl_1 : TestCtrl
      use entity work.TestCtrl(SendGetAllParam1) ; 
    end for ; 
  end for ; 
end TbAxi_SendGetAllParam1 ; 