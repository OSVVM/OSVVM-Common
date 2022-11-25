--
--  File Name:         TbAxi4_ReadWriteAsync4.vhd
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
--    05/2018   2018       Initial revision
--    01/2020   2020.01    Updated license notice
--    12/2020   2020.12    Updated signal and port names
--
--
--  This file is part of OSVVM.
--  
--  Copyright (c) 2018 - 2021 by SynthWorks Design Inc.  
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

architecture ReadWriteAsync4 of TestCtrl is

  signal TestDone : integer_barrier := 1 ;
  signal TbManagerID : AlertLogIDType ; 
  signal TbSubordinateID  : AlertLogIDType ; 
 
begin

  ------------------------------------------------------------
  -- ControlProc
  --   Set up AlertLog and wait for end of test
  ------------------------------------------------------------
  ControlProc : process
  begin
    -- Initialization of test
    SetTestName("TbAxi4_ReadWriteAsync4") ;
    TbManagerID <= GetAlertLogID("TB Manager Proc") ;
    TbSubordinateID <= GetAlertLogID("TB Subordinate Proc") ;
    SetLogEnable(PASSED, TRUE) ;    -- Enable PASSED logs

    -- Wait for testbench initialization 
    wait for 0 ns ;  wait for 0 ns ;
    TranscriptOpen(OSVVM_RESULTS_DIR & "TbAxi4_ReadWriteAsync4.txt") ;
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
    -- AlertIfDiff("./results/TbAxi4_ReadWriteAsync4.txt", "../sim_shared/validated_results/TbAxi4_ReadWriteAsync4.txt", "") ; 

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
    variable Available : boolean ; 
    variable NumTryRead : integer ; 
  begin
    wait until nReset = '1' ;  
    SetLogEnable(INFO, TRUE) ;    -- Enable INFO logs
    WaitForClock(ManagerRec, 1, 2) ; 
    log(TbManagerID, "Write and Read with ByteAddr = 0, 4 Bytes") ;
    log(TbManagerID, "WriteAddressAsync,  Addr: AAAA_AAA0") ;
    WriteAddressAsync(ManagerRec, 1, X"AAAA_AAA0") ;
    log(TbManagerID, "WriteDataAsync, Data: 5555_5555") ;
    WriteDataAsync   (ManagerRec, 1, X"5555_5555" ) ;
    WaitForClock(ManagerRec, 1, 4) ; 
    
    print("") ; 
    log(TbManagerID, "ReadAddressAsync,  Addr: 1111_1110") ;
    ReadAddressAsync(ManagerRec, 1, X"1111_1110") ;
    NumTryRead := 1 ; 
    loop 
      log(TbManagerID, "TryReadCheckData, Data: 2222_2222, Try # " & to_string(NumTryRead)) ;
      TryReadCheckData(ManagerRec, 1, X"2222_2222", Available) ;
      exit when Available ; 
      NumTryRead := NumTryRead + 1 ; 
      WaitForClock(ManagerRec, 1, 1) ; 
    end loop ;
    WaitForClock(ManagerRec, 1, 2) ; 
    SetLogEnable(INFO, FALSE) ;    -- Disable INFO logs

    print("") ;  print("") ; 
    log(TbManagerID, "Write and Read with 1 Byte, and ByteAddr = 0, 1, 2, 3") ; 
    log(TbManagerID, "WriteAddressAsync,  Addr: AAAA_AAA0") ;
    WriteAddressAsync(ManagerRec, 1, X"AAAA_AAA0") ;
    log(TbManagerID, "WriteAddressAsync,  Addr: AAAA_AAA1") ;
    WriteAddressAsync(ManagerRec, 1, X"AAAA_AAA1") ;
    log(TbManagerID, "WriteAddressAsync,  Addr: AAAA_AAA2") ;
    WriteAddressAsync(ManagerRec, 1, X"AAAA_AAA2") ;
    log(TbManagerID, "WriteAddressAsync,  Addr: AAAA_AAA3") ;
    WriteAddressAsync(ManagerRec, 1, X"AAAA_AAA3") ;
    -- Allow Write Address to get two clocks ahead of Write Data
    log(TbManagerID, "WaitForClock 2") ;
    WaitForClock(ManagerRec, 1, 2) ; 
    log(TbManagerID, "WriteDataAsync, ByteAddr: 00, Data: 11") ;
    WriteDataAsync   (ManagerRec, 1, X"00", X"11" ) ;
    log(TbManagerID, "WriteDataAsync, ByteAddr: 01, Data: 22") ;
    WriteDataAsync   (ManagerRec, 1, X"01", X"22" ) ;
    log(TbManagerID, "WriteDataAsync, ByteAddr: 02, Data: 33") ;
    WriteDataAsync   (ManagerRec, 1, X"02", X"33" ) ;
    log(TbManagerID, "WriteDataAsync, ByteAddr: 03, Data: 44") ;
    WriteDataAsync   (ManagerRec, 1, X"03", X"44" ) ;
    WaitForClock(ManagerRec, 1, 8) ; 
    
    print("") ;  
    log(TbManagerID, "ReadAddressAsync,  Addr: 1111_1110") ;
    ReadAddressAsync(ManagerRec, 1,  X"1111_1110") ;
    log(TbManagerID, "ReadAddressAsync,  Addr: 1111_1111") ;
    ReadAddressAsync(ManagerRec, 1,  X"1111_1111") ;
    log(TbManagerID, "ReadAddressAsync,  Addr: 1111_1112") ;
    ReadAddressAsync(ManagerRec, 1,  X"1111_1112") ;
    log(TbManagerID, "ReadAddressAsync,  Addr: 1111_1113") ;
    ReadAddressAsync(ManagerRec, 1,  X"1111_1113") ;
    NumTryRead := 1 ; 
    loop 
      log(TbManagerID, "TryReadCheckData, Data: AA, Try # " & to_string(NumTryRead)) ;
      TryReadCheckData(ManagerRec, 1, X"AA", Available) ;
      exit when Available ; 
      NumTryRead := NumTryRead + 1 ; 
      WaitForClock(ManagerRec, 1, 1) ; 
    end loop ;
    NumTryRead := 1 ; 
    loop 
      log(TbManagerID, "TryReadCheckData, Data: BB, Try # " & to_string(NumTryRead)) ;
      TryReadCheckData(ManagerRec, 1, X"BB", Available) ;
      exit when Available ; 
      NumTryRead := NumTryRead + 1 ; 
      WaitForClock(ManagerRec, 1, 1) ; 
    end loop ;
    NumTryRead := 1 ; 
    loop 
      log(TbManagerID, "TryReadCheckData, Data: CC, Try # " & to_string(NumTryRead)) ;
      TryReadCheckData(ManagerRec, 1, X"CC", Available) ;
      exit when Available ; 
      NumTryRead := NumTryRead + 1 ; 
      WaitForClock(ManagerRec, 1, 1) ; 
    end loop ;
    NumTryRead := 1 ; 
    loop 
      log(TbManagerID, "TryReadCheckData, Data: DD, Try # " & to_string(NumTryRead)) ;
      TryReadCheckData(ManagerRec, 1, X"DD", Available) ;
      exit when Available ; 
      NumTryRead := NumTryRead + 1 ; 
      WaitForClock(ManagerRec, 1, 1) ; 
    end loop ;
    SetLogEnable(INFO, FALSE) ;    -- Disable INFO logs

    print("") ;  print("") ; 
    log(TbManagerID, "Write and Read with 2 Bytes, and ByteAddr = 0, 1, 2") ;
    log(TbManagerID, "WriteAddressAsync,  Addr: BBBB_BBB0") ;
    WriteAddressAsync(ManagerRec, 1, X"BBBB_BBB0") ;
    log(TbManagerID, "WriteAddressAsync,  Addr: BBBB_BBB1") ;
    WriteAddressAsync(ManagerRec, 1, X"BBBB_BBB1") ;
    log(TbManagerID, "WriteAddressAsync,  Addr: BBBB_BBB2") ;
    WriteAddressAsync(ManagerRec, 1, X"BBBB_BBB2") ;
    log(TbManagerID, "WriteDataAsync, ByteAddr: 00, Data: 2211") ;
    WriteDataAsync   (ManagerRec, 1, X"00", X"2211" ) ;
    log(TbManagerID, "WriteDataAsync, ByteAddr: 01, Data: 33_22") ;
    WriteDataAsync   (ManagerRec, 1, X"01", X"33_22" ) ;
    log(TbManagerID, "WriteDataAsync, ByteAddr: 02, Data: 4433") ;
    WriteDataAsync   (ManagerRec, 1, X"02", X"4433" ) ;

    print("") ;  
    log(TbManagerID, "ReadAddressAsync,  Addr: 1111_1110") ;
    ReadAddressAsync(ManagerRec, 1,  X"1111_1110") ;
    log(TbManagerID, "ReadAddressAsync,  Addr: 1111_1111") ;
    ReadAddressAsync(ManagerRec, 1,  X"1111_1111") ;
    log(TbManagerID, "ReadAddressAsync,  Addr: 1111_1112") ;
    ReadAddressAsync(ManagerRec, 1,  X"1111_1112") ;
    NumTryRead := 1 ; 
    loop 
      log(TbManagerID, "TryReadCheckData, Data: BBAA, Try # " & to_string(NumTryRead)) ;
      TryReadCheckData(ManagerRec, 1, X"BBAA", Available) ;
      exit when Available ; 
      NumTryRead := NumTryRead + 1 ; 
      WaitForClock(ManagerRec, 1, 1) ; 
    end loop ;
    NumTryRead := 1 ; 
    loop 
      log(TbManagerID, "TryReadCheckData, Data: CCBB, Try # " & to_string(NumTryRead)) ;
      TryReadCheckData(ManagerRec, 1, X"CCBB", Available) ;
      exit when Available ; 
      NumTryRead := NumTryRead + 1 ; 
      WaitForClock(ManagerRec, 1, 1) ; 
    end loop ;
    NumTryRead := 1 ; 
    loop 
      log(TbManagerID, "TryReadCheckData, Data: DDCC, Try # " & to_string(NumTryRead)) ;
      TryReadCheckData(ManagerRec, 1, X"DDCC", Available) ;
      exit when Available ; 
      NumTryRead := NumTryRead + 1 ; 
      WaitForClock(ManagerRec, 1, 1) ; 
    end loop ;

    print("") ;  print("") ; 
    log(TbManagerID, "Write and Read with 3 Bytes and ByteAddr = 0. 1") ;
    log(TbManagerID, "WriteAddressAsync,  Addr: CCCC_CCC0") ;
    WriteAddressAsync(ManagerRec, 1, X"CCCC_CCC0") ;
    log(TbManagerID, "WriteDataAsync, ByteAddr: 00, Data: 33_2211") ;
    WriteDataAsync   (ManagerRec, 1, X"00", X"33_2211" ) ;
    log(TbManagerID, "WriteAddressAsync,  Addr: CCCC_CCC1") ;
    WriteAddressAsync(ManagerRec, 1, X"CCCC_CCC1") ;
    log(TbManagerID, "WriteDataAsync, ByteAddr: 01, Data: 4433_22") ;
    WriteDataAsync   (ManagerRec, 1, X"01", X"4433_22" ) ;

    print("") ;  
    log(TbManagerID, "ReadAddressAsync,  Addr: 1111_1110") ;
    ReadAddressAsync(ManagerRec, 1,  X"1111_1110") ;
    log(TbManagerID, "ReadAddressAsync,  Addr: 1111_1111") ;
    ReadAddressAsync(ManagerRec, 1,  X"1111_1111") ;
    NumTryRead := 1 ; 
    loop 
      log(TbManagerID, "TryReadCheckData, Data: CC_BBAA, Try # " & to_string(NumTryRead)) ;
      TryReadCheckData(ManagerRec, 1, X"CC_BBAA", Available) ;
      exit when Available ; 
      NumTryRead := NumTryRead + 1 ; 
      WaitForClock(ManagerRec, 1, 1) ; 
    end loop ;
    NumTryRead := 1 ; 
    loop 
      log(TbManagerID, "TryReadCheckData, Data: DDCC_BB, Try # " & to_string(NumTryRead)) ;
      TryReadCheckData(ManagerRec, 1, X"DDCC_BB", Available) ;
      exit when Available ; 
      NumTryRead := NumTryRead + 1 ; 
      WaitForClock(ManagerRec, 1, 1) ; 
    end loop ;
    
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
    variable Data : std_logic_vector(AXI_DATA_WIDTH-1 downto 0) ;    
  begin
    WaitForClock(SubordinateRec, 1, 2) ; 
    -- Write and Read with ByteAddr = 0, 4 Bytes
    GetWrite(SubordinateRec, 1, Addr, Data) ;
    AffirmIfEqual(TbSubordinateID, Addr, X"AAAA_AAA0", "Subordinate Write Addr: ") ;
    AffirmIfEqual(TbSubordinateID, Data, X"5555_5555", "Subordinate Write Data: ") ;
    
    SendRead(SubordinateRec, 1, Addr, X"2222_2222") ; 
    AffirmIfEqual(TbSubordinateID, Addr, X"1111_1110", "Subordinate Read Addr: ") ;

    
    -- Write and Read with 1 Byte, and ByteAddr = 0, 1, 2, 3
    -- Write(ManagerRec, 1, X"AAAA_AAA0", X"11" ) ;
    GetWrite(SubordinateRec, 1, Addr, Data) ;
    AffirmIfEqual(TbSubordinateID, Addr, X"AAAA_AAA0", "Subordinate Write Addr: ") ;
    AffirmIfEqual(TbSubordinateID, Data, X"0000_0011", "Subordinate Write Data: ") ;
    -- Write(ManagerRec, 1, X"AAAA_AAA1", X"22" ) ;
    GetWrite(SubordinateRec, 1, Addr, Data) ;
    AffirmIfEqual(TbSubordinateID, Addr, X"AAAA_AAA1", "Subordinate Write Addr: ") ;
    AffirmIfEqual(TbSubordinateID, Data, X"0000_2200", "Subordinate Write Data: ") ;
    -- Write(ManagerRec, 1, X"AAAA_AAA2", X"33" ) ;
    GetWrite(SubordinateRec, 1, Addr, Data) ;
    AffirmIfEqual(TbSubordinateID, Addr, X"AAAA_AAA2", "Subordinate Write Addr: ") ;
    AffirmIfEqual(TbSubordinateID, Data, X"0033_0000", "Subordinate Write Data: ") ;
    -- Write(ManagerRec, 1, X"AAAA_AAA3", X"44" ) ;
    GetWrite(SubordinateRec, 1, Addr, Data) ;
    AffirmIfEqual(TbSubordinateID, Addr, X"AAAA_AAA3", "Subordinate Write Addr: ") ;
    AffirmIfEqual(TbSubordinateID, Data, X"4400_0000", "Subordinate Write Data: ") ;

    SendRead(SubordinateRec, 1, Addr, X"0000_00AA") ; 
    AffirmIfEqual(TbSubordinateID, Addr, X"1111_1110", "Subordinate Read Addr: ") ;
    SendRead(SubordinateRec, 1, Addr, X"0000_BB00") ; 
    AffirmIfEqual(TbSubordinateID, Addr, X"1111_1111", "Subordinate Read Addr: ") ;
    SendRead(SubordinateRec, 1, Addr, X"00CC_0000") ; 
    AffirmIfEqual(TbSubordinateID, Addr, X"1111_1112", "Subordinate Read Addr: ") ;
    SendRead(SubordinateRec, 1, Addr, X"DD00_0000") ; 
    AffirmIfEqual(TbSubordinateID, Addr, X"1111_1113", "Subordinate Read Addr: ") ;


    -- Write and Read with 2 Bytes, and ByteAddr = 0, 1, 2
    -- Write(ManagerRec, 1, X"BBBB_BBB0", X"2211" ) ;
    GetWrite(SubordinateRec, 1, Addr, Data) ;
    AffirmIfEqual(TbSubordinateID, Addr, X"BBBB_BBB0", "Subordinate Write Addr: ") ;
    AffirmIfEqual(TbSubordinateID, Data, X"0000_2211", "Subordinate Write Data: ") ;
    -- Write(ManagerRec, 1, X"BBBB_BBB1", X"3322" ) ;
    GetWrite(SubordinateRec, 1, Addr, Data) ;
    AffirmIfEqual(TbSubordinateID, Addr, X"BBBB_BBB1", "Subordinate Write Addr: ") ;
    AffirmIfEqual(TbSubordinateID, Data, X"0033_2200", "Subordinate Write Data: ") ;
    -- Write(ManagerRec, 1, X"BBBB_BBB2", X"4433" ) ;
    GetWrite(SubordinateRec, 1, Addr, Data) ;
    AffirmIfEqual(TbSubordinateID, Addr, X"BBBB_BBB2", "Subordinate Write Addr: ") ;
    AffirmIfEqual(TbSubordinateID, Data, X"4433_0000", "Subordinate Write Data: ") ;

    SendRead(SubordinateRec, 1, Addr, X"0000_BBAA") ; 
    AffirmIfEqual(TbSubordinateID, Addr, X"1111_1110", "Subordinate Read Addr: ") ;
    SendRead(SubordinateRec, 1, Addr, X"00CC_BB00") ; 
    AffirmIfEqual(TbSubordinateID, Addr, X"1111_1111", "Subordinate Read Addr: ") ;
    SendRead(SubordinateRec, 1, Addr, X"DDCC_0000") ; 
    AffirmIfEqual(TbSubordinateID, Addr, X"1111_1112", "Subordinate Read Addr: ") ;

    -- Write and Read with 3 Bytes and ByteAddr = 0. 1
    -- Write(ManagerRec, 1, X"CCCC_CCC0", X"332211" ) ;
    GetWrite(SubordinateRec, 1, Addr, Data) ;
    AffirmIfEqual(TbSubordinateID, Addr, X"CCCC_CCC0", "Subordinate Write Addr: ") ;
    AffirmIfEqual(TbSubordinateID, Data, X"0033_2211", "Subordinate Write Data: ") ;
    -- Write(ManagerRec, 1, X"CCCC_CCC1", X"443322" ) ;
    GetWrite(SubordinateRec, 1, Addr, Data) ;
    AffirmIfEqual(TbSubordinateID, Addr, X"CCCC_CCC1", "Subordinate Write Addr: ") ;
    AffirmIfEqual(TbSubordinateID, Data, X"4433_2200", "Subordinate Write Data: ") ;

    SendRead(SubordinateRec, 1, Addr, X"00CC_BBAA") ; 
    AffirmIfEqual(TbSubordinateID, Addr, X"1111_1110", "Subordinate Read Addr: ") ;
    SendRead(SubordinateRec, 1, Addr, X"DDCC_BB00") ; 
    AffirmIfEqual(TbSubordinateID, Addr, X"1111_1111", "Subordinate Read Addr: ") ;


    -- Wait for outputs to propagate and signal TestDone
    WaitForClock(SubordinateRec, 1, 2) ;
    WaitForBarrier(TestDone) ;
    wait ;
  end process SubordinateProc ;


end ReadWriteAsync4 ;

Configuration TbAxi4_ReadWriteAsync4 of TbAxi4 is
  for TestHarness
    for TestCtrl_1 : TestCtrl
      use entity work.TestCtrl(ReadWriteAsync4) ; 
    end for ; 
  end for ; 
end TbAxi4_ReadWriteAsync4 ; 