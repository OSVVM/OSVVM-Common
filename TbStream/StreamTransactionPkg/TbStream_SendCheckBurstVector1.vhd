--
--  File Name:         TbStream_SendCheckBurstVector1.vhd
--  Design Unit Name:  Architecture of TestCtrl
--  Revision:          OSVVM MODELS STANDARD VERSION
--
--  Maintainer:        Jim Lewis      email:  jim@synthworks.com
--  Contributor(s):
--     Jim Lewis      jim@synthworks.com
--
--
--  Description:
--      Burst Transactions with Full Data Width
--      SendBurst, GetBurst
--
--
--  Developed by:
--        SynthWorks Design Inc.
--        VHDL Training Classes
--        http://www.SynthWorks.com
--
--  Revision History:
--    Date      Version    Description
--    10/2020   2020.10    Initial revision
--
--
--  This file is part of OSVVM.
--  
--  Copyright (c) 2018 - 2020 by SynthWorks Design Inc.  
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
architecture SendCheckBurstVector1 of TestCtrl is

  signal   TestDone : integer_barrier := 1 ;
--    constant FIFO_WIDTH : integer := DATA_WIDTH ; 
  constant FIFO_WIDTH : integer := 8 ; -- BYTE 
  
  signal SB : ScoreboardIDType ; 
 
begin

  ------------------------------------------------------------
  -- ControlProc
  --   Set up AlertLog and wait for end of test
  ------------------------------------------------------------
  ControlProc : process
  begin
    -- Initialization of test
    SetTestName("TbStream_SendCheckBurstVector1") ;
    SetLogEnable(PASSED, TRUE) ;    -- Enable PASSED logs
    SetLogEnable(INFO, TRUE) ;    -- Enable INFO logs

    -- Wait for testbench initialization 
    wait for 0 ns ;  wait for 0 ns ;
    TranscriptOpen ;
    SetTranscriptMirror(TRUE) ; 
    SB <= NewID("SB") ; 

    -- Wait for Design Reset
    wait until nReset = '1' ;  
    ClearAlerts ;

    -- Wait for test to finish
    WaitForBarrier(TestDone, 5 ms) ;
    AlertIf(now >= 5 ms, "Test finished due to timeout") ;
    AlertIf(GetAffirmCount < 1, "Test is not Self-Checking");
    
    TranscriptClose ; 
--    AlertIfDiff("./results/TbStream_SendCheckBurstVector1.txt", "../sim_shared/validated_results/TbStream_SendCheckBurstVector1.txt", "") ; 
    
    EndOfTestReports ; 
    std.env.stop ; 
    wait ; 
  end process ControlProc ; 

  
  ------------------------------------------------------------
  -- AxiTransmitterProc
  --   Generate transactions for AxiTransmitter
  ------------------------------------------------------------
  AxiTransmitterProc : process
    variable ByteData : integer_vector(1 to 16) ; 
    variable RV : RandomPType ; 
    variable ID   : std_logic_vector(ID_LEN-1 downto 0) ;    -- 8
    variable Dest : std_logic_vector(DEST_LEN-1 downto 0) ;  -- 4
    variable User : std_logic_vector(USER_LEN-1 downto 0) ;  -- 4
    variable Param : std_logic_vector(ID_LEN + DEST_LEN + USER_LEN downto 0) ;
  begin
    ID   := to_slv(1, ID_LEN);
    Dest := to_slv(2, DEST_LEN) ; 
    User := to_slv(3, USER_LEN) ; 
    Param := ID & Dest & User & '1' ;
    
    RV.InitSeed(RV'path_name) ; 
    wait until nReset = '1' ;  
    WaitForClock(StreamTxRec, 2) ; 
    SetBurstMode(StreamTxRec, STREAM_BURST_BYTE_MODE) ;
    
    SendBurstVector(StreamTxRec, (1,3,5,7,9,11,13,15,17,19,21,23,25,27,29), FIFO_WIDTH) ;
    SendBurstVector(StreamTxRec, (31,33,35,37,39,41,43,45,47,49,51,53), Param, FIFO_WIDTH) ;
    SendBurstVector(StreamTxRec, (2,4,6,8,10,12,14,16,18,20), FIFO_WIDTH) ;

    WaitForClock(StreamTxRec, 4) ; 
    
    ByteData(1 to 14) := RV.RandIntV(0,255,14) ; 
    PushBurstVector(SB, ByteData(1 to 14), FIFO_WIDTH) ; 
    SendBurstVector(StreamTxRec, ByteData(1 to 14), FIFO_WIDTH) ; 
    

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
    variable BurstLen : integer ; 
    variable ID   : std_logic_vector(ID_LEN-1 downto 0) ;    -- 8
    variable Dest : std_logic_vector(DEST_LEN-1 downto 0) ;  -- 4
    variable User : std_logic_vector(USER_LEN-1 downto 0) ;  -- 4
    variable Param : std_logic_vector(ID_LEN + DEST_LEN + USER_LEN downto 0) ;
  begin
    ID   := to_slv(1, ID_LEN);
    Dest := to_slv(2, DEST_LEN) ; 
    User := to_slv(3, USER_LEN) ; 
    Param := ID & Dest & User & '1' ;
    WaitForClock(StreamRxRec, 2) ; 
    SetBurstMode(StreamRxRec, STREAM_BURST_BYTE_MODE) ;
    
--    log("Transmit 30 Bytes -- unaligned") ;
    CheckBurstVector(StreamRxRec, (1,3,5,7,9,11,13,15,17,19,21,23,25,27,29), FIFO_WIDTH) ;
    CheckBurstVector(StreamRxRec, (31,33,35,37,39,41,43,45,47,49,51,53), Param, FIFO_WIDTH) ;
    CheckBurstVector(StreamRxRec, (2,4,6,8,10,12,14,16,18,20), FIFO_WIDTH) ;

    WaitForClock(StreamRxRec, 4) ; 
    
    GetBurst(StreamRxRec, BurstLen) ; 
    CheckBurstFifo(SB, StreamRxRec.BurstFifo, BurstLen) ; 

    -- Wait for outputs to propagate and signal TestDone
    WaitForClock(StreamRxRec, 2) ;
    WaitForBarrier(TestDone) ;
    wait ;
  end process AxiReceiverProc ;

end SendCheckBurstVector1 ;

Configuration TbStream_SendCheckBurstVector1 of TbStream is
  for TestHarness
    for TestCtrl_1 : TestCtrl
      use entity work.TestCtrl(SendCheckBurstVector1) ; 
    end for ; 
  end for ; 
end TbStream_SendCheckBurstVector1 ; 