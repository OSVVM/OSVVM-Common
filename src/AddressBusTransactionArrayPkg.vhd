--
--  File Name:         AddressBusTransactionArrayPkg.vhd
--  Design Unit Name:  AddressBusTransactionArrayPkg
--  Revision:          OSVVM MODELS STANDARD VERSION
--
--  Maintainer:        Jim Lewis      email:  jim@synthworks.com
--  Contributor(s):
--     Jim Lewis      jim@synthworks.com
--
--
--  Description:
--    Defines Address Bus transaction initiation procedures (Read, Write, ...)
--    for arrays of Address Bus Interfaces (AddressBusRecArrayType).
--    Companion to AddressBusTransactionPkg.vhd
--    
--    This works around a VHDL issue documented in 
--    https://gitlab.com/IEEE-P1076/VHDL-Issues/-/issues/275
--    When this issue is fixed and implemented, this package will
--    no longer be needed
--
--
--  Developed by:
--        SynthWorks Design Inc.
--        VHDL Training Classes
--        http://www.SynthWorks.com
--
--  Revision History:
--    Date      Version    Description
--    11/2022   2022.11    Initial.   Derived from AddressBusTransactionPkg
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
library ieee ;
  use ieee.std_logic_1164.all ;
  use ieee.numeric_std.all ;
  use ieee.numeric_std_unsigned.all ;
  use ieee.math_real.all ;

library osvvm ;
  context osvvm.OsvvmContext ;
  use osvvm.ScoreboardPkg_slv.all ; 

  use work.FifoFillPkg_slv.all ; 
  use work.AddressBusTransactionPkg.all ; 

package AddressBusTransactionArrayPkg is

  -- ========================================================
  --  Directive Transactions  
  --  Directive transactions interact with the verification component 
  --  without generating any transactions or interface waveforms.
  --  Supported by all verification components
  -- ========================================================
  ------------------------------------------------------------
  procedure WaitForTransaction (
  --  Wait until pending transaction completes
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  
  ) ; 

  ------------------------------------------------------------
  procedure WaitForWriteTransaction (
  --  Wait until pending transaction completes
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  
  ) ; 

  ------------------------------------------------------------
  procedure WaitForReadTransaction (
  --  Wait until pending transaction completes
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  
  ) ;
  
  ------------------------------------------------------------
  procedure WaitForClock (
  -- Wait for NumberOfClocks number of clocks 
  -- relative to the verification component clock
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    constant NumberOfClocks : In    natural := 1
  ) ;

  alias NoOp is WaitForClock [AddressBusRecArrayType, integer, natural] ;

  ------------------------------------------------------------
  procedure GetTransactionCount (
  -- Get the number of transactions handled by the model.  
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    variable Count          : Out   integer
  ) ;

  ------------------------------------------------------------
  procedure GetWriteTransactionCount (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    variable Count          : Out   integer
  ) ;

  ------------------------------------------------------------
  procedure GetReadTransactionCount (
  -- Get the number of read transactions handled by the model.  
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    variable Count          : Out   integer
  ) ;

  ------------------------------------------------------------
  procedure GetAlertLogID (
  -- Get the AlertLogID from the verification component.
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    variable AlertLogID     : Out   AlertLogIDType
  ) ;

  ------------------------------------------------------------
  procedure GetErrorCount (
  -- Error reporting for testbenches that do not use OSVVM AlertLogPkg
  -- Returns error count.  If an error count /= 0, also print errors
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    variable ErrorCount     : Out   natural
  ) ;

  -- ========================================================
  --  Delay Coverage Transactions   
  --  Get Delay Coverage ID to change delay coverage parameters.
  -- ========================================================
  ------------------------------------------------------------
  procedure SetUseRandomDelays (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    constant OptVal         : In    boolean := TRUE
  ) ;

  ------------------------------------------------------------
  procedure GetUseRandomDelays (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    variable OptVal         : Out   boolean
  ) ;
  
  ------------------------------------------------------------
  procedure SetDelayCoverageID (
  ------------------------------------------------------------
    signal   TransactionRec : inout AddressBusRecArrayType ;
    constant ArrayIndex     : In    integer  ;
    constant DelayCov       : in    DelayCoverageIdType ;
    constant Index          : in    integer := 1 
  ) ;

  ------------------------------------------------------------
  procedure GetDelayCoverageID (
  ------------------------------------------------------------
    signal   TransactionRec : inout AddressBusRecArrayType ;
    constant ArrayIndex     : In    integer  ;
    variable DelayCov       : out   DelayCoverageIdType ;
    constant Index          : in    integer := 1 
  ) ;

  ------------------------------------------------------------
  procedure SetDelayCoverageID (
  ------------------------------------------------------------
    signal   TransactionRec : inout AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    constant DelayCov       : in    DelayCoverageIdArrayType 
  ) ;

  ------------------------------------------------------------
  procedure GetDelayCoverageID (
  ------------------------------------------------------------
    signal   TransactionRec : inout AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    variable DelayCov       : out   DelayCoverageIdArrayType 
  ) ;

  -- ========================================================
  --  Set and Get Burst Mode   
  --  Set Burst Mode for models that do bursting.
  -- ========================================================
  ------------------------------------------------------------
  procedure SetBurstMode (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    constant OptVal         : In    AddressBusFifoBurstModeType
  ) ;

  ------------------------------------------------------------
  procedure GetBurstMode (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    variable OptVal         : Out   AddressBusFifoBurstModeType
  ) ;

  -- ========================================================
  --  Set and Get Model Options  
  --  Model operations are directive transactions that are  
  --  used to configure the verification component.  
  --  They can either be used directly or with a model specific
  --  wrapper around them - see AXI models for examples.
  -- ========================================================
  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    constant Option         : In    integer ;
    constant OptVal         : In    boolean
  ) ;

  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    constant Option         : In    integer ;
    constant OptVal         : In    integer
  ) ;

  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    constant Option         : In    integer ;
    constant OptVal         : In    std_logic_vector
  ) ;
  
  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    constant Option         : In    integer ;
    constant OptVal         : In    time
  ) ;

  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    constant Option         : In    integer ;
    variable OptVal         : Out   boolean
  ) ;

  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    constant Option         : In    integer ;
    variable OptVal         : Out   integer
  ) ;

  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    constant Option         : In    integer ;
    variable OptVal         : Out   std_logic_vector
  ) ;

  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    constant Option         : In    integer ;
    variable OptVal         : Out   time
  ) ;
  ------------------------------------------------------------
  procedure InterruptReturn (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  
  ) ;


  -- ========================================================
  --  Master / Initiator Transactions  
  -- ========================================================
  -- ========================================================
  --  Interface Independent Transactions
  --  These transactions work independent of the interface.
  --  Recommended for all tests that verify internal design functionality.
  --  Many are blocking transactions which do not return (complete)
  --  until the interface operation requested by the transaction  
  --  has completed.
  --  Some are asynchronous, which means they return before the
  --  transaction is complete - typically even before it starts.
  --  Supported by all verification components
  -- ========================================================
  ------------------------------------------------------------
  procedure Write (
  -- Blocking Write Transaction. 
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             iData          : In    std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure WriteAsync (
  -- Asynchronous / Non-Blocking Write Transaction
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             iData          : In    std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure Read (
  -- Blocking Read Transaction.
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
    variable oData          : Out   std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure ReadCheck (
  -- Blocking Read Transaction and check iData, rather than returning a value.
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             iData          : In    std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) ;
  
  ------------------------------------------------------------
  procedure ReadPoll (
  -- Read location (iAddr) until Data(IndexI) = ValueI
  -- WaitTime is the number of clocks to wait between reads.
  -- oData is the value read.
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
    variable oData          : Out   std_logic_vector ;
             RegIndex       : In    Integer ;
             BitValue       : In    std_logic ;
             StatusMsgOn    : In    boolean := false ;
             WaitTime       : In    natural := 10
  ) ;

  ------------------------------------------------------------
  procedure ReadPoll (
  -- Read location (iAddr) until Data(IndexI) = ValueI
  -- WaitTime is the number of clocks to wait between reads.
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             RegIndex       : In    Integer ;
             BitValue       : In    std_logic ;
             StatusMsgOn    : In    boolean := false ;
             WaitTime       : In    natural := 10
  ) ;
  
  ------------------------------------------------------------
  procedure WriteAndRead (
  -- Write and Read Cycle that use same address and are dispatched together
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             iData          : In    std_logic_vector ;
    variable oData          : Out   std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure WriteAndReadAsync (
  -- Dispatch Write Address and Data.  Do not wait for completion
  -- Dispatch Read Address.  Do not wait for Read Data.  
  -- Retrieve read data with ReadData or TryReadData
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             iData          : In    std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) ;
  
  
  -- ========================================================
  --  Burst Transactions
  --  Some interfaces support bursting, and some do not.  
  --  Hence, support for burst transactions is optional.
  --  However, for an interface that does not support bursting,  
  --  it is appropriate to implement a burst as multiple single  
  --  cycle operations.    
  -- ========================================================
  
  ------------------------------------------------------------
  procedure WriteBurst (
  -- Blocking Write Burst.   
  -- Data is provided separately via a WriteBurstFifo.   
  -- NumFifoWords specifies the number of items from the FIFO to be transferred.
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             NumFifoWords   : In    integer ;
             StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure WriteBurstVector (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             VectorOfWords  : In    slv_vector ;
             StatusMsgOn    : In    boolean := false
  ) ;
  
  ------------------------------------------------------------
  procedure WriteBurstVector (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             VectorOfWords  : In    integer_vector ;
             FifoWidth      : In    integer ; 
             StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure WriteBurstIncrement (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             FirstWord      : In    std_logic_vector ;
             NumFifoWords   : In    integer ;
             StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure WriteBurstRandom (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             FirstWord      : In    std_logic_vector ;
             NumFifoWords   : In    integer ;
             StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure WriteBurstRandom (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             CoverID        : In    CoverageIDType ;
             NumFifoWords   : In    integer ;
             FifoWidth      : In    integer ;
             StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure WriteBurstAsync (
  -- Asynchronous / Non-Blocking Write Burst.   
  -- Data is provided separately via a WriteBurstFifo.   
  -- NumFifoWords specifies the number of bytes to be transferred.
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             NumFifoWords   : In    integer ;
             StatusMsgOn    : In    boolean := false
  ) ;
  
------------------------------------------------------------
  procedure WriteBurstVectorAsync (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             VectorOfWords  : In    slv_vector ;
             StatusMsgOn    : In    boolean := false
  ) ;
  
  ------------------------------------------------------------
  procedure WriteBurstVectorAsync (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             VectorOfWords  : In    integer_vector ;
             FifoWidth      : In    integer ; 
             StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure WriteBurstIncrementAsync (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             FirstWord      : In    std_logic_vector ;
             NumFifoWords   : In    integer ;
             StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure WriteBurstRandomAsync (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             FirstWord      : In    std_logic_vector ;
             NumFifoWords   : In    integer ;
             StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure WriteBurstRandomAsync (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             CoverID        : In    CoverageIDType ;
             NumFifoWords   : In    integer ;
             FifoWidth      : In    integer ;
             StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure ReadBurst (
  -- Blocking Read Burst.
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             NumFifoWords   : In    integer ;
             StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure ReadCheckBurstVector (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             VectorOfWords  : In    slv_vector ;
             StatusMsgOn    : In    boolean := false
  ) ;
  
  ------------------------------------------------------------
  procedure ReadCheckBurstVector (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             VectorOfWords  : In    integer_vector ;
             FifoWidth      : In    integer ; 
             StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure ReadCheckBurstIncrement (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             FirstWord      : In    std_logic_vector ;
             NumFifoWords   : In    integer ;
             StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure ReadCheckBurstRandom (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             FirstWord      : In    std_logic_vector ;
             NumFifoWords   : In    integer ;
             StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure ReadCheckBurstRandom (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             CoverID        : In    CoverageIDType ;
             NumFifoWords   : In    integer ;
             FifoWidth      : In    integer ;
             StatusMsgOn    : In    boolean := false
  ) ;

  -- ========================================================
  --  Interface Specific Transactions
  --  Support split transaction interfaces - such as AXI which
  --  independently operates the write address, write data, 
  --  write response, read address, and read data interfaces. 
  --  For split transaction interfaces, these transactions are 
  --  required to fully test the interface characteristics.  
  --  Most of these transactions are asynchronous.  
  -- ========================================================

  ------------------------------------------------------------
  procedure WriteAddressAsync (
  -- Non-blocking Write Address 
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure WriteDataAsync (
  -- Non-blocking Write Data 
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             iData          : In    std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure WriteDataAsync (
  -- Non-blocking Write Data.  iAddr = 0.  
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iData          : In    std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) ;
  
  ------------------------------------------------------------
  procedure ReadAddressAsync (
  -- Non-blocking Read Address
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure ReadData (
  -- Blocking Read Data
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    variable oData          : Out   std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure ReadCheckData (
  -- Blocking Read data and check iData, rather than returning a value.
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iData          : In    std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure TryReadData (
  -- Try (non-blocking) read data attempt.   
  -- If data is available, get it and return available TRUE.
  -- Otherwise Return Available FALSE.
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    variable oData          : Out   std_logic_vector ;
    variable Available      : Out   boolean ;
             StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure TryReadCheckData (
  -- Try (non-blocking) read data and check attempt.   
  -- If data is available, check it and return available TRUE.
  -- Otherwise Return Available FALSE.
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iData          : In    std_logic_vector ;
    variable Available      : Out   boolean ;
             StatusMsgOn    : In    boolean := false
  ) ;

  -- ========================================================
  --  Pseudo Transactions
  --  Interact with the record only.
  -- ========================================================
  ------------------------------------------------------------
  procedure ReleaseTransactionRecord (
  --  Must run on same delta cycle as AcquireTransactionRecord
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  
  ) ; 
  
  ------------------------------------------------------------
  procedure AcquireTransactionRecord (
  --  Must run on same delta cycle as ReleaseTransactionRecord
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  
  ) ; 
  
  -- ========================================================
  --  Supports AddressBusResponderTransactionArrayPkg
  -- ========================================================
  ------------------------------------------------------------
  procedure AddressBusArrayRequestTransaction (
  --  Package Local
  ------------------------------------------------------------
    signal    TransactionRec   : inout AddressBusRecArrayType ;
    constant  Index            : in    integer 
  ) ;

end package AddressBusTransactionArrayPkg ;

-- /////////////////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////////////////

package body AddressBusTransactionArrayPkg is

  ------------------------------------------------------------
  procedure AddressBusArrayRequestTransaction (
  --  Package Local
  ------------------------------------------------------------
    signal    TransactionRec   : inout AddressBusRecArrayType ;
    constant  Index            : in    integer 
  ) is
  begin
    case Index is 
      when  0 =>  RequestTransaction(Rdy => TransactionRec( 0).Rdy, Ack => TransactionRec( 0).Ack) ; 
      when  1 =>  RequestTransaction(Rdy => TransactionRec( 1).Rdy, Ack => TransactionRec( 1).Ack) ; 
      when  2 =>  RequestTransaction(Rdy => TransactionRec( 2).Rdy, Ack => TransactionRec( 2).Ack) ; 
      when  3 =>  RequestTransaction(Rdy => TransactionRec( 3).Rdy, Ack => TransactionRec( 3).Ack) ; 
      when  4 =>  RequestTransaction(Rdy => TransactionRec( 4).Rdy, Ack => TransactionRec( 4).Ack) ; 
      when  5 =>  RequestTransaction(Rdy => TransactionRec( 5).Rdy, Ack => TransactionRec( 5).Ack) ; 
      when  6 =>  RequestTransaction(Rdy => TransactionRec( 6).Rdy, Ack => TransactionRec( 6).Ack) ; 
      when  7 =>  RequestTransaction(Rdy => TransactionRec( 7).Rdy, Ack => TransactionRec( 7).Ack) ; 
      when  8 =>  RequestTransaction(Rdy => TransactionRec( 8).Rdy, Ack => TransactionRec( 8).Ack) ; 
      when  9 =>  RequestTransaction(Rdy => TransactionRec( 9).Rdy, Ack => TransactionRec( 9).Ack) ; 
      when 10 =>  RequestTransaction(Rdy => TransactionRec(10).Rdy, Ack => TransactionRec(10).Ack) ; 
      when 11 =>  RequestTransaction(Rdy => TransactionRec(11).Rdy, Ack => TransactionRec(11).Ack) ; 
      when 12 =>  RequestTransaction(Rdy => TransactionRec(12).Rdy, Ack => TransactionRec(12).Ack) ; 
      when 13 =>  RequestTransaction(Rdy => TransactionRec(13).Rdy, Ack => TransactionRec(13).Ack) ; 
      when 14 =>  RequestTransaction(Rdy => TransactionRec(14).Rdy, Ack => TransactionRec(14).Ack) ; 
      when 15 =>  RequestTransaction(Rdy => TransactionRec(15).Rdy, Ack => TransactionRec(15).Ack) ; 
      when 16 =>  RequestTransaction(Rdy => TransactionRec(16).Rdy, Ack => TransactionRec(16).Ack) ; 
      when 17 =>  RequestTransaction(Rdy => TransactionRec(17).Rdy, Ack => TransactionRec(17).Ack) ; 
      when 18 =>  RequestTransaction(Rdy => TransactionRec(18).Rdy, Ack => TransactionRec(18).Ack) ; 
      when 19 =>  RequestTransaction(Rdy => TransactionRec(19).Rdy, Ack => TransactionRec(19).Ack) ; 
      when 20 =>  RequestTransaction(Rdy => TransactionRec(20).Rdy, Ack => TransactionRec(20).Ack) ; 
      when 21 =>  RequestTransaction(Rdy => TransactionRec(21).Rdy, Ack => TransactionRec(21).Ack) ; 
      when 22 =>  RequestTransaction(Rdy => TransactionRec(22).Rdy, Ack => TransactionRec(22).Ack) ; 
      when 23 =>  RequestTransaction(Rdy => TransactionRec(23).Rdy, Ack => TransactionRec(23).Ack) ; 
      when 24 =>  RequestTransaction(Rdy => TransactionRec(24).Rdy, Ack => TransactionRec(24).Ack) ; 
      when 25 =>  RequestTransaction(Rdy => TransactionRec(25).Rdy, Ack => TransactionRec(25).Ack) ; 
      when 26 =>  RequestTransaction(Rdy => TransactionRec(26).Rdy, Ack => TransactionRec(26).Ack) ; 
      when 27 =>  RequestTransaction(Rdy => TransactionRec(27).Rdy, Ack => TransactionRec(27).Ack) ; 
      when 28 =>  RequestTransaction(Rdy => TransactionRec(28).Rdy, Ack => TransactionRec(28).Ack) ; 
      when 29 =>  RequestTransaction(Rdy => TransactionRec(29).Rdy, Ack => TransactionRec(29).Ack) ; 
      when 30 =>  RequestTransaction(Rdy => TransactionRec(30).Rdy, Ack => TransactionRec(30).Ack) ; 
      when 31 =>  RequestTransaction(Rdy => TransactionRec(31).Rdy, Ack => TransactionRec(31).Ack) ; 
      when 32 =>  RequestTransaction(Rdy => TransactionRec(32).Rdy, Ack => TransactionRec(32).Ack) ; 
      when 33 =>  RequestTransaction(Rdy => TransactionRec(33).Rdy, Ack => TransactionRec(33).Ack) ; 
      when 34 =>  RequestTransaction(Rdy => TransactionRec(34).Rdy, Ack => TransactionRec(34).Ack) ; 
      when 35 =>  RequestTransaction(Rdy => TransactionRec(35).Rdy, Ack => TransactionRec(35).Ack) ; 
      when 36 =>  RequestTransaction(Rdy => TransactionRec(36).Rdy, Ack => TransactionRec(36).Ack) ; 
      when 37 =>  RequestTransaction(Rdy => TransactionRec(37).Rdy, Ack => TransactionRec(37).Ack) ; 
      when 38 =>  RequestTransaction(Rdy => TransactionRec(38).Rdy, Ack => TransactionRec(38).Ack) ; 
      when 39 =>  RequestTransaction(Rdy => TransactionRec(39).Rdy, Ack => TransactionRec(39).Ack) ; 
      when 40 =>  RequestTransaction(Rdy => TransactionRec(40).Rdy, Ack => TransactionRec(40).Ack) ; 
      when 41 =>  RequestTransaction(Rdy => TransactionRec(41).Rdy, Ack => TransactionRec(41).Ack) ; 
      when 42 =>  RequestTransaction(Rdy => TransactionRec(42).Rdy, Ack => TransactionRec(42).Ack) ; 
      when 43 =>  RequestTransaction(Rdy => TransactionRec(43).Rdy, Ack => TransactionRec(43).Ack) ; 
      when 44 =>  RequestTransaction(Rdy => TransactionRec(44).Rdy, Ack => TransactionRec(44).Ack) ; 
      when 45 =>  RequestTransaction(Rdy => TransactionRec(45).Rdy, Ack => TransactionRec(45).Ack) ; 
      when 46 =>  RequestTransaction(Rdy => TransactionRec(46).Rdy, Ack => TransactionRec(46).Ack) ; 
      when 47 =>  RequestTransaction(Rdy => TransactionRec(47).Rdy, Ack => TransactionRec(47).Ack) ; 
      when 48 =>  RequestTransaction(Rdy => TransactionRec(48).Rdy, Ack => TransactionRec(48).Ack) ; 
      when 49 =>  RequestTransaction(Rdy => TransactionRec(49).Rdy, Ack => TransactionRec(49).Ack) ; 
      when 50 =>  RequestTransaction(Rdy => TransactionRec(50).Rdy, Ack => TransactionRec(50).Ack) ; 
      when 51 =>  RequestTransaction(Rdy => TransactionRec(51).Rdy, Ack => TransactionRec(51).Ack) ; 
      when 52 =>  RequestTransaction(Rdy => TransactionRec(52).Rdy, Ack => TransactionRec(52).Ack) ; 
      when 53 =>  RequestTransaction(Rdy => TransactionRec(53).Rdy, Ack => TransactionRec(53).Ack) ; 
      when 54 =>  RequestTransaction(Rdy => TransactionRec(54).Rdy, Ack => TransactionRec(54).Ack) ; 
      when 55 =>  RequestTransaction(Rdy => TransactionRec(55).Rdy, Ack => TransactionRec(55).Ack) ; 
      when 56 =>  RequestTransaction(Rdy => TransactionRec(56).Rdy, Ack => TransactionRec(56).Ack) ; 
      when 57 =>  RequestTransaction(Rdy => TransactionRec(57).Rdy, Ack => TransactionRec(57).Ack) ; 
      when 58 =>  RequestTransaction(Rdy => TransactionRec(58).Rdy, Ack => TransactionRec(58).Ack) ; 
      when 59 =>  RequestTransaction(Rdy => TransactionRec(59).Rdy, Ack => TransactionRec(59).Ack) ; 
      when 60 =>  RequestTransaction(Rdy => TransactionRec(60).Rdy, Ack => TransactionRec(60).Ack) ; 
      when 61 =>  RequestTransaction(Rdy => TransactionRec(61).Rdy, Ack => TransactionRec(61).Ack) ; 
      when 62 =>  RequestTransaction(Rdy => TransactionRec(62).Rdy, Ack => TransactionRec(62).Ack) ; 
      when 63 =>  RequestTransaction(Rdy => TransactionRec(63).Rdy, Ack => TransactionRec(63).Ack) ; 
      when 64 =>  RequestTransaction(Rdy => TransactionRec(64).Rdy, Ack => TransactionRec(64).Ack) ; 
      when 65 =>  RequestTransaction(Rdy => TransactionRec(65).Rdy, Ack => TransactionRec(65).Ack) ; 
      when 66 =>  RequestTransaction(Rdy => TransactionRec(66).Rdy, Ack => TransactionRec(66).Ack) ; 
      when 67 =>  RequestTransaction(Rdy => TransactionRec(67).Rdy, Ack => TransactionRec(67).Ack) ; 
      when 68 =>  RequestTransaction(Rdy => TransactionRec(68).Rdy, Ack => TransactionRec(68).Ack) ; 
      when 69 =>  RequestTransaction(Rdy => TransactionRec(69).Rdy, Ack => TransactionRec(69).Ack) ; 
      when 70 =>  RequestTransaction(Rdy => TransactionRec(70).Rdy, Ack => TransactionRec(70).Ack) ; 
      when 71 =>  RequestTransaction(Rdy => TransactionRec(71).Rdy, Ack => TransactionRec(71).Ack) ; 
      when 72 =>  RequestTransaction(Rdy => TransactionRec(72).Rdy, Ack => TransactionRec(72).Ack) ; 
      when 73 =>  RequestTransaction(Rdy => TransactionRec(73).Rdy, Ack => TransactionRec(73).Ack) ; 
      when 74 =>  RequestTransaction(Rdy => TransactionRec(74).Rdy, Ack => TransactionRec(74).Ack) ; 
      when 75 =>  RequestTransaction(Rdy => TransactionRec(75).Rdy, Ack => TransactionRec(75).Ack) ; 
      when 76 =>  RequestTransaction(Rdy => TransactionRec(76).Rdy, Ack => TransactionRec(76).Ack) ; 
      when 77 =>  RequestTransaction(Rdy => TransactionRec(77).Rdy, Ack => TransactionRec(77).Ack) ; 
      when 78 =>  RequestTransaction(Rdy => TransactionRec(78).Rdy, Ack => TransactionRec(78).Ack) ; 
      when 79 =>  RequestTransaction(Rdy => TransactionRec(79).Rdy, Ack => TransactionRec(79).Ack) ; 
      when 80 =>  RequestTransaction(Rdy => TransactionRec(80).Rdy, Ack => TransactionRec(80).Ack) ; 
      when 81 =>  RequestTransaction(Rdy => TransactionRec(81).Rdy, Ack => TransactionRec(81).Ack) ; 
      when 82 =>  RequestTransaction(Rdy => TransactionRec(82).Rdy, Ack => TransactionRec(82).Ack) ; 
      when 83 =>  RequestTransaction(Rdy => TransactionRec(83).Rdy, Ack => TransactionRec(83).Ack) ; 
      when 84 =>  RequestTransaction(Rdy => TransactionRec(84).Rdy, Ack => TransactionRec(84).Ack) ; 
      when 85 =>  RequestTransaction(Rdy => TransactionRec(85).Rdy, Ack => TransactionRec(85).Ack) ; 
      when 86 =>  RequestTransaction(Rdy => TransactionRec(86).Rdy, Ack => TransactionRec(86).Ack) ; 
      when 87 =>  RequestTransaction(Rdy => TransactionRec(87).Rdy, Ack => TransactionRec(87).Ack) ; 
      when 88 =>  RequestTransaction(Rdy => TransactionRec(88).Rdy, Ack => TransactionRec(88).Ack) ; 
      when 89 =>  RequestTransaction(Rdy => TransactionRec(89).Rdy, Ack => TransactionRec(89).Ack) ; 
      when 90 =>  RequestTransaction(Rdy => TransactionRec(90).Rdy, Ack => TransactionRec(90).Ack) ; 
      when 91 =>  RequestTransaction(Rdy => TransactionRec(91).Rdy, Ack => TransactionRec(91).Ack) ; 
      when 92 =>  RequestTransaction(Rdy => TransactionRec(92).Rdy, Ack => TransactionRec(92).Ack) ; 
      when 93 =>  RequestTransaction(Rdy => TransactionRec(93).Rdy, Ack => TransactionRec(93).Ack) ; 
      when 94 =>  RequestTransaction(Rdy => TransactionRec(94).Rdy, Ack => TransactionRec(94).Ack) ; 
      when 95 =>  RequestTransaction(Rdy => TransactionRec(95).Rdy, Ack => TransactionRec(95).Ack) ; 
      when 96 =>  RequestTransaction(Rdy => TransactionRec(96).Rdy, Ack => TransactionRec(96).Ack) ; 
      when 97 =>  RequestTransaction(Rdy => TransactionRec(97).Rdy, Ack => TransactionRec(97).Ack) ; 
      when 98 =>  RequestTransaction(Rdy => TransactionRec(98).Rdy, Ack => TransactionRec(98).Ack) ; 
      when 99 =>  RequestTransaction(Rdy => TransactionRec(99).Rdy, Ack => TransactionRec(99).Ack) ; 
      when 100 =>  RequestTransaction(Rdy => TransactionRec(100).Rdy, Ack => TransactionRec(100).Ack) ; 
      when 101 =>  RequestTransaction(Rdy => TransactionRec(101).Rdy, Ack => TransactionRec(101).Ack) ; 
      when 102 =>  RequestTransaction(Rdy => TransactionRec(102).Rdy, Ack => TransactionRec(102).Ack) ; 
      when 103 =>  RequestTransaction(Rdy => TransactionRec(103).Rdy, Ack => TransactionRec(103).Ack) ; 
      when 104 =>  RequestTransaction(Rdy => TransactionRec(104).Rdy, Ack => TransactionRec(104).Ack) ; 
      when 105 =>  RequestTransaction(Rdy => TransactionRec(105).Rdy, Ack => TransactionRec(105).Ack) ; 
      when 106 =>  RequestTransaction(Rdy => TransactionRec(106).Rdy, Ack => TransactionRec(106).Ack) ; 
      when 107 =>  RequestTransaction(Rdy => TransactionRec(107).Rdy, Ack => TransactionRec(107).Ack) ; 
      when 108 =>  RequestTransaction(Rdy => TransactionRec(108).Rdy, Ack => TransactionRec(108).Ack) ; 
      when 109 =>  RequestTransaction(Rdy => TransactionRec(109).Rdy, Ack => TransactionRec(109).Ack) ; 
      when 110 =>  RequestTransaction(Rdy => TransactionRec(110).Rdy, Ack => TransactionRec(110).Ack) ; 
      when 111 =>  RequestTransaction(Rdy => TransactionRec(111).Rdy, Ack => TransactionRec(111).Ack) ; 
      when 112 =>  RequestTransaction(Rdy => TransactionRec(112).Rdy, Ack => TransactionRec(112).Ack) ; 
      when 113 =>  RequestTransaction(Rdy => TransactionRec(113).Rdy, Ack => TransactionRec(113).Ack) ; 
      when 114 =>  RequestTransaction(Rdy => TransactionRec(114).Rdy, Ack => TransactionRec(114).Ack) ; 
      when 115 =>  RequestTransaction(Rdy => TransactionRec(115).Rdy, Ack => TransactionRec(115).Ack) ; 
      when 116 =>  RequestTransaction(Rdy => TransactionRec(116).Rdy, Ack => TransactionRec(116).Ack) ; 
      when 117 =>  RequestTransaction(Rdy => TransactionRec(117).Rdy, Ack => TransactionRec(117).Ack) ; 
      when 118 =>  RequestTransaction(Rdy => TransactionRec(118).Rdy, Ack => TransactionRec(118).Ack) ; 
      when 119 =>  RequestTransaction(Rdy => TransactionRec(119).Rdy, Ack => TransactionRec(119).Ack) ; 
      when 120 =>  RequestTransaction(Rdy => TransactionRec(120).Rdy, Ack => TransactionRec(120).Ack) ; 
      when 121 =>  RequestTransaction(Rdy => TransactionRec(121).Rdy, Ack => TransactionRec(121).Ack) ; 
      when 122 =>  RequestTransaction(Rdy => TransactionRec(122).Rdy, Ack => TransactionRec(122).Ack) ; 
      when 123 =>  RequestTransaction(Rdy => TransactionRec(123).Rdy, Ack => TransactionRec(123).Ack) ; 
      when 124 =>  RequestTransaction(Rdy => TransactionRec(124).Rdy, Ack => TransactionRec(124).Ack) ; 
      when 125 =>  RequestTransaction(Rdy => TransactionRec(125).Rdy, Ack => TransactionRec(125).Ack) ; 
      when 126 =>  RequestTransaction(Rdy => TransactionRec(126).Rdy, Ack => TransactionRec(126).Ack) ; 
      when 127 =>  RequestTransaction(Rdy => TransactionRec(127).Rdy, Ack => TransactionRec(127).Ack) ; 
      when 128 =>  RequestTransaction(Rdy => TransactionRec(128).Rdy, Ack => TransactionRec(128).Ack) ; 
      when 129 =>  RequestTransaction(Rdy => TransactionRec(129).Rdy, Ack => TransactionRec(129).Ack) ; 
      when others => Alert("AddressBusTransactionArrayPkg: Please extend AddressBusArrayRequestTransaction to handle " & to_string(Index) & " indices") ; 
    end case ;  
  end procedure AddressBusArrayRequestTransaction ; 
  
  
  -- ========================================================
  --  Directive Transactions
  --  Interact with verification component but not interface.
  -- ========================================================
  ------------------------------------------------------------
  procedure WaitForTransaction (
  --  Wait until pending transaction completes
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  
  ) is
  begin
    TransactionRec(Index).Operation     <= WAIT_FOR_TRANSACTION ;
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ; 
  end procedure WaitForTransaction ; 

  ------------------------------------------------------------
  procedure WaitForWriteTransaction (
  --  Wait until pending transaction completes
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  
  ) is
  begin
    TransactionRec(Index).Operation     <= WAIT_FOR_WRITE_TRANSACTION ;
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ; 
  end procedure WaitForWriteTransaction ; 

  ------------------------------------------------------------
  procedure WaitForReadTransaction (
  --  Wait until pending transaction completes
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  
  ) is
  begin
    TransactionRec(Index).Operation     <= WAIT_FOR_READ_TRANSACTION ;
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ; 
  end procedure WaitForReadTransaction ; 

  ------------------------------------------------------------
  procedure WaitForClock (
  -- Directive:  Wait for NumberOfClocks number of clocks in the model
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    constant NumberOfClocks : In    natural := 1
  ) is
  begin
    TransactionRec(Index).Operation     <= WAIT_FOR_CLOCK ;
    TransactionRec(Index).IntToModel    <= NumberOfClocks ; 
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
  end procedure WaitForClock ;

  ------------------------------------------------------------
  procedure GetTransactionCount (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    variable Count          : Out   integer
  ) is
  begin
    TransactionRec(Index).Operation     <= GET_TRANSACTION_COUNT ;
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;

    -- Return AlertLogID
    Count := TransactionRec(Index).IntFromModel ;
--    Count := integer(TransactionRec(Index).Rdy) ;
  end procedure GetTransactionCount ;

  ------------------------------------------------------------
  procedure GetWriteTransactionCount (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    variable Count          : Out   integer
  ) is
  begin
    TransactionRec(Index).Operation     <= GET_WRITE_TRANSACTION_COUNT ;
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;

    -- Return AlertLogID
    Count := TransactionRec(Index).IntFromModel ;
  end procedure GetWriteTransactionCount ;

  ------------------------------------------------------------
  procedure GetReadTransactionCount (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    variable Count          : Out   integer
  ) is
  begin
    TransactionRec(Index).Operation     <= GET_READ_TRANSACTION_COUNT ;
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;

    -- Return AlertLogID
    Count := TransactionRec(Index).IntFromModel ;
  end procedure GetReadTransactionCount ;

  ------------------------------------------------------------
  procedure GetAlertLogID (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    variable AlertLogID     : Out   AlertLogIDType
  ) is
  begin
    TransactionRec(Index).Operation     <= GET_ALERTLOG_ID ;
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;

    -- Return AlertLogID
    AlertLogID := AlertLogIDType(TransactionRec(Index).IntFromModel) ;
  end procedure GetAlertLogID ;

  ------------------------------------------------------------
  procedure GetErrorCount (
  -- Error reporting for testbenches that do not use AlertLogPkg
  -- Returns error count.  If an error count /= 0, also print it
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    variable ErrorCount     : Out   natural
  ) is
    variable ModelID : AlertLogIDType ;
  begin
    GetAlertLogID(TransactionRec, Index, ModelID) ;
--    ReportNonZeroAlerts(AlertLogID => ModelID) ;
    ErrorCount := GetAlertCount(AlertLogID => ModelID) ;
  end procedure GetErrorCount ;

  -- ========================================================
  --  Delay Coverage Transactions   
  --  Get Delay Coverage ID to change delay coverage parameters.
  -- ========================================================
  ------------------------------------------------------------
  procedure SetUseRandomDelays (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    constant OptVal         : In    boolean := TRUE
  ) is
  begin
    TransactionRec(Index).Operation     <= SET_USE_RANDOM_DELAYS ;
    TransactionRec(Index).BoolToModel   <= OptVal ;
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
  end procedure SetUseRandomDelays ;

  ------------------------------------------------------------
  procedure GetUseRandomDelays (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    variable OptVal         : Out   boolean
  ) is
  begin
    TransactionRec(Index).Operation     <= GET_USE_RANDOM_DELAYS ;
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
    OptVal := TransactionRec(Index).BoolFromModel    ;
  end procedure GetUseRandomDelays ;
  
  ------------------------------------------------------------
  procedure SetDelayCoverageID (
  ------------------------------------------------------------
    signal   TransactionRec : inout AddressBusRecArrayType ;
    constant ArrayIndex     : In    integer  ;
    constant DelayCov       : in    DelayCoverageIdType ;
    constant Index          : in    integer := 1 
  ) is
  begin
    TransactionRec(Index).Operation     <= SET_DELAYCOV_ID ;
    TransactionRec(Index).IntToModel    <= DelayCov.ID ;
    TransactionRec(Index).Options       <= Index ; 
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => ArrayIndex) ;
  end procedure SetDelayCoverageID ;

  ------------------------------------------------------------
  procedure GetDelayCoverageID (
  ------------------------------------------------------------
    signal   TransactionRec : inout AddressBusRecArrayType ;
    constant ArrayIndex     : In    integer  ;
    variable DelayCov       : out   DelayCoverageIdType ;
    constant Index          : in    integer := 1 
  ) is
  begin
    TransactionRec(Index).Operation     <= GET_DELAYCOV_ID ;
    TransactionRec(Index).Options       <= Index ; 
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => ArrayIndex) ;
    DelayCov := GetDelayCoverage(TransactionRec(Index).IntFromModel) ; 
  end procedure GetDelayCoverageID ;

  ------------------------------------------------------------
  procedure SetDelayCoverageID (
  ------------------------------------------------------------
    signal   TransactionRec : inout AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    constant DelayCov       : in    DelayCoverageIdArrayType 
  ) is
  begin
    for i in DelayCov'range loop
      SetDelayCoverageID(TransactionRec, Index, DelayCov(i), i) ; 
    end loop ; 
  end procedure SetDelayCoverageID ;

  ------------------------------------------------------------
  procedure GetDelayCoverageID (
  ------------------------------------------------------------
    signal   TransactionRec : inout AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    variable DelayCov       : out   DelayCoverageIdArrayType 
  ) is
  begin
    for i in DelayCov'range loop
      GetDelayCoverageID(TransactionRec, Index, DelayCov(i), i) ; 
    end loop ; 
  end procedure GetDelayCoverageID ;

  -- ========================================================
  --  Set and Get Burst Mode   
  --  Set Burst Mode for models that do bursting.
  -- ========================================================
  ------------------------------------------------------------
  procedure SetBurstMode (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    constant OptVal         : In    AddressBusFifoBurstModeType
  ) is
  begin
    TransactionRec(Index).Operation     <= SET_BURST_MODE ;
    TransactionRec(Index).IntToModel    <= OptVal ;
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
  end procedure SetBurstMode ;

  ------------------------------------------------------------
  procedure GetBurstMode (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    variable OptVal         : Out   AddressBusFifoBurstModeType
  ) is
  begin
    TransactionRec(Index).Operation     <= GET_BURST_MODE ;
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
    OptVal := TransactionRec(Index).IntFromModel ; 
  end procedure GetBurstMode ;

  --
  --  Extensions to support model customizations
  -- 
  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    constant Option         : In    integer ;
    constant OptVal         : In    boolean
  ) is
  begin
    TransactionRec(Index).Operation     <= SET_MODEL_OPTIONS ;
    TransactionRec(Index).Options       <= Option ;
    TransactionRec(Index).BoolToModel   <= OptVal ;
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
  end procedure SetModelOptions ;

  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    constant Option         : In    integer ;
    constant OptVal         : In    integer
  ) is
  begin
    TransactionRec(Index).Operation     <= SET_MODEL_OPTIONS ;
    TransactionRec(Index).Options       <= Option ;
    TransactionRec(Index).IntToModel    <= OptVal ;
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
  end procedure SetModelOptions ;

  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    constant Option         : In    integer ;
    constant OptVal         : In    std_logic_vector
  ) is
  begin
    TransactionRec(Index).Operation     <= SET_MODEL_OPTIONS ;
    TransactionRec(Index).Options       <= Option ;
    TransactionRec(Index).IntToModel    <= to_integer(OptVal) ;
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
  end procedure SetModelOptions ;
 
  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    constant Option         : In    integer ;
    constant OptVal         : In    time
  ) is
  begin
    TransactionRec(Index).Operation     <= SET_MODEL_OPTIONS ;
    TransactionRec(Index).Options       <= Option ;
    TransactionRec(Index).TimeToModel   <= OptVal ;
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
  end procedure SetModelOptions ;

  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    constant Option         : In    integer ;
    variable OptVal         : Out   boolean
  ) is
  begin
    TransactionRec(Index).Operation     <= GET_MODEL_OPTIONS ;
    TransactionRec(Index).Options       <= Option ;
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
    OptVal := TransactionRec(Index).BoolFromModel    ;
  end procedure GetModelOptions ;

  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    constant Option         : In    integer ;
    variable OptVal         : Out   integer
  ) is
  begin
    TransactionRec(Index).Operation     <= GET_MODEL_OPTIONS ;
    TransactionRec(Index).Options       <= Option ;
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
    OptVal := TransactionRec(Index).IntFromModel ; 
  end procedure GetModelOptions ;

  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    constant Option         : In    integer ;
    variable OptVal         : Out   std_logic_vector
  ) is
  begin
    TransactionRec(Index).Operation     <= GET_MODEL_OPTIONS ;
    TransactionRec(Index).Options       <= Option ;
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
    OptVal := to_slv(TransactionRec(Index).IntFromModel, OptVal'length) ; 
  end procedure GetModelOptions ;

  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    constant Option         : In    integer ;
    variable OptVal         : Out   time
  ) is
  begin
    TransactionRec(Index).Operation     <= GET_MODEL_OPTIONS ;
    TransactionRec(Index).Options       <= Option ;
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
    OptVal := TransactionRec(Index).TimeFromModel ; 
  end procedure GetModelOptions ;

  ------------------------------------------------------------
  procedure InterruptReturn (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  
  ) is
  begin
    TransactionRec(Index).Operation     <= INTERRUPT_RETURN ;
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
  end procedure InterruptReturn ;

  ------------------------------------------------------------
  procedure Write (
  -- do CPU Write Cycle
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             iData          : In    std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec(Index).Operation     <= WRITE_OP ;
    TransactionRec(Index).Address       <= SafeResize(iAddr, TransactionRec(Index).Address'length) ;
    TransactionRec(Index).AddrWidth     <= iAddr'length ;
    TransactionRec(Index).DataToModel   <= SafeResize(iData, TransactionRec(Index).DataToModel'length) ;
    TransactionRec(Index).DataWidth     <= iData'length ;
    TransactionRec(Index).StatusMsgOn   <= StatusMsgOn ;
    -- Start Transaction
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
  end procedure Write ;

  ------------------------------------------------------------
  procedure WriteAsync (
  -- dispatch CPU Write Cycle
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             iData          : In    std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec(Index).Operation     <= ASYNC_WRITE ;
    TransactionRec(Index).Address       <= SafeResize(iAddr, TransactionRec(Index).Address'length) ;
    TransactionRec(Index).AddrWidth     <= iAddr'length ;
    TransactionRec(Index).DataToModel   <= SafeResize(iData, TransactionRec(Index).DataToModel'length) ;
    TransactionRec(Index).DataWidth     <= iData'length ;
    TransactionRec(Index).StatusMsgOn   <= StatusMsgOn ;
    -- Start Transaction
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
  end procedure WriteAsync ;

  ------------------------------------------------------------
  procedure WriteAddressAsync (
  -- dispatch CPU Write Address Cycle
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec(Index).Operation     <= ASYNC_WRITE_ADDRESS ;
    TransactionRec(Index).Address       <= SafeResize(iAddr, TransactionRec(Index).Address'length) ;
    TransactionRec(Index).AddrWidth     <= iAddr'length ;
    TransactionRec(Index).DataWidth     <= 0 ;
    TransactionRec(Index).StatusMsgOn   <= StatusMsgOn ;
    -- Start Transaction
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
  end procedure WriteAddressAsync ;

  ------------------------------------------------------------
  procedure WriteDataAsync (
  -- dispatch CPU Write Data Cycle
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             iData          : In    std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec(Index).Operation     <= ASYNC_WRITE_DATA ;
    TransactionRec(Index).Address       <= SafeResize(iAddr, TransactionRec(Index).Address'length) ;
    TransactionRec(Index).AddrWidth     <= iAddr'length ;
    TransactionRec(Index).DataToModel   <= SafeResize(iData, TransactionRec(Index).DataToModel'length) ;
    TransactionRec(Index).DataWidth     <= iData'length ;
    TransactionRec(Index).StatusMsgOn   <= StatusMsgOn ;
    -- Start Transaction
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
  end procedure WriteDataAsync ;
  
  ------------------------------------------------------------
  procedure WriteDataAsync (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iData          : In    std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    WriteDataAsync(TransactionRec, Index, X"00", iData, StatusMsgOn) ;
  end procedure WriteDataAsync ;

  ------------------------------------------------------------
  procedure Read (
  -- do CPU Read Cycle and return data
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
    variable oData          : Out   std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec(Index).Operation     <= READ_OP ;
    TransactionRec(Index).Address       <= SafeResize(iAddr, TransactionRec(Index).Address'length) ;
    TransactionRec(Index).AddrWidth     <= iAddr'length ;
    TransactionRec(Index).DataWidth     <= oData'length ;
    TransactionRec(Index).StatusMsgOn   <= StatusMsgOn ;
    -- Start Transaction
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
    -- Return Results
    oData  := SafeResize(TransactionRec(Index).DataFromModel, oData'length) ;
  end procedure Read ;

  ------------------------------------------------------------
  procedure ReadCheck (
  -- do CPU Read Cycle and check supplied data
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             iData          : In    std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec(Index).Operation     <= READ_CHECK ;
    TransactionRec(Index).Address       <= SafeResize(iAddr, TransactionRec(Index).Address'length) ;
    TransactionRec(Index).AddrWidth     <= iAddr'length ;
    TransactionRec(Index).DataToModel   <= SafeResize(iData, TransactionRec(Index).DataToModel'length) ;
    TransactionRec(Index).DataWidth     <= iData'length ;
    TransactionRec(Index).StatusMsgOn   <= StatusMsgOn ;
    -- Start Transaction
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
  end procedure ReadCheck ;

  ------------------------------------------------------------
  procedure ReadAddressAsync (
  -- dispatch CPU Read Address Cycle
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec(Index).Operation     <= ASYNC_READ_ADDRESS ;
    TransactionRec(Index).Address       <= SafeResize(iAddr, TransactionRec(Index).Address'length) ;
    TransactionRec(Index).AddrWidth     <= iAddr'length ;
    TransactionRec(Index).DataToModel   <= (TransactionRec(Index).DataToModel'range => 'X') ;
    TransactionRec(Index).DataWidth     <= 0 ;
    TransactionRec(Index).StatusMsgOn   <= StatusMsgOn ;
    -- Start Transaction
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
  end procedure ReadAddressAsync ;

  ------------------------------------------------------------
  procedure ReadData (
  -- Do CPU Read Data Cycle
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    variable oData          : Out   std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec(Index).Operation     <= READ_DATA ;
    TransactionRec(Index).Address       <= (TransactionRec(Index).Address'range => 'X') ;
    TransactionRec(Index).DataWidth     <= oData'length ;
    TransactionRec(Index).StatusMsgOn   <= StatusMsgOn ;
    -- Start Transaction
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
    -- Return Results
    oData  := SafeResize(TransactionRec(Index).DataFromModel, oData'length) ;
  end procedure ReadData ;

  ------------------------------------------------------------
  procedure ReadCheckData (
  -- Do CPU Read Data Cycle and check received Data
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iData          : In    std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec(Index).Operation     <= READ_DATA_CHECK ;
    TransactionRec(Index).Address       <= (TransactionRec(Index).Address'range => 'X') ;
    TransactionRec(Index).DataToModel   <= SafeResize(iData, TransactionRec(Index).DataToModel'length) ;
    TransactionRec(Index).DataWidth     <= iData'length ;
    TransactionRec(Index).StatusMsgOn   <= StatusMsgOn ;
    -- Start Transaction
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
  end procedure ReadCheckData ;

  ------------------------------------------------------------
  procedure TryReadData (
  -- Try to Get CPU Read Data Cycle
  -- If data is available, get it and return available TRUE.
  -- Otherwise Return Available FALSE.
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
    variable oData          : Out   std_logic_vector ;
    variable Available      : Out   boolean ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec(Index).Operation     <= ASYNC_READ_DATA ;
    TransactionRec(Index).Address       <= (TransactionRec(Index).Address'range => 'X') ;
    TransactionRec(Index).DataWidth     <= oData'length ;
    TransactionRec(Index).StatusMsgOn   <= StatusMsgOn ;
    -- Start Transaction
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
    -- Return Results
    oData  := SafeResize(TransactionRec(Index).DataFromModel, oData'length) ;
    Available := TransactionRec(Index).BoolFromModel ;
  end procedure TryReadData ;

  ------------------------------------------------------------
  procedure TryReadCheckData (
  -- Try to Get CPU Read Data Cycle
  -- If data is available, check it and return available TRUE.
  -- Otherwise Return Available FALSE.
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iData          : In    std_logic_vector ;
    variable Available      : Out   boolean ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec(Index).Operation     <= ASYNC_READ_DATA_CHECK ;
    TransactionRec(Index).Address       <= (TransactionRec(Index).Address'range => 'X') ;
    TransactionRec(Index).DataToModel   <= SafeResize(iData, TransactionRec(Index).DataToModel'length) ;
    TransactionRec(Index).DataWidth     <= iData'length ;
    TransactionRec(Index).StatusMsgOn   <= StatusMsgOn ;
    -- Start Transaction
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
    Available := TransactionRec(Index).BoolFromModel ;
  end procedure TryReadCheckData ;

  ------------------------------------------------------------
  procedure ReadPoll (
  -- Read location (iAddr) until Data(IndexI) = ValueI
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
    variable oData          : Out   std_logic_vector ;
             RegIndex       : In    Integer ;
             BitValue       : In    std_logic ;
             StatusMsgOn    : In    boolean := false ;
             WaitTime       : In    natural := 10
  ) is
    variable vData    : std_logic_vector(oData'length-1 downto 0) ;
    variable ModelID  : AlertLogIDType ;
  begin
    loop
      WaitForClock(TransactionRec, Index, WaitTime) ;
      Read (TransactionRec, Index, iAddr, vData) ;
      exit when vData(RegIndex) = BitValue ;
    end loop ;

    GetAlertLogID(TransactionRec, Index, ModelID) ;
    Log(ModelID, "CpuPoll: address" & to_hstring(iAddr) &
      "  Data: " & to_hstring(vData), INFO, StatusMsgOn) ;
    oData := vData ;
  end procedure ReadPoll ;

  ------------------------------------------------------------
  procedure ReadPoll (
  -- Read location (iAddr) until Data(IndexI) = ValueI
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             RegIndex       : In    Integer ;
             BitValue       : In    std_logic ;
             StatusMsgOn    : In    boolean := false ;
             WaitTime       : In    natural := 10
  ) is
    variable vData    : std_logic_vector(TransactionRec(Index).DataFromModel'range) ;
  begin
    ReadPoll(TransactionRec, Index, iAddr, vData, RegIndex, BitValue, StatusMsgOn, WaitTime) ;
  end procedure ReadPoll ;

  ------------------------------------------------------------
  procedure WriteAndRead (
  -- Write and Read Cycle that use same address and are dispatched together
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             iData          : In    std_logic_vector ;
    variable oData          : Out   std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec(Index).Operation     <= WRITE_AND_READ ;
    TransactionRec(Index).Address       <= SafeResize(iAddr, TransactionRec(Index).Address'length) ;
    TransactionRec(Index).AddrWidth     <= iAddr'length ;
    TransactionRec(Index).DataToModel   <= SafeResize(iData, TransactionRec(Index).DataToModel'length) ;
    TransactionRec(Index).DataWidth     <= iData'length ;
    TransactionRec(Index).StatusMsgOn   <= StatusMsgOn ;
    -- Start Transaction
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
    -- Return Results
    oData  := SafeResize(TransactionRec(Index).DataFromModel, oData'length) ;  
  end procedure WriteAndRead ;

  ------------------------------------------------------------
  procedure WriteAndReadAsync (
  -- Dispatch Write Address and Data.  Do not wait for completion
  -- Dispatch Read Address.  Do not wait for Read Data.  
  -- Retrieve read data with ReadData or TryReadData
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             iData          : In    std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec(Index).Operation     <= ASYNC_WRITE_AND_READ ;
    TransactionRec(Index).Address       <= SafeResize(iAddr, TransactionRec(Index).Address'length) ;
    TransactionRec(Index).AddrWidth     <= iAddr'length ;
    TransactionRec(Index).DataToModel   <= SafeResize(iData, TransactionRec(Index).DataToModel'length) ;
    TransactionRec(Index).DataWidth     <= iData'length ;
    TransactionRec(Index).StatusMsgOn   <= StatusMsgOn ;
    -- Start Transaction
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
  end procedure WriteAndReadAsync ;
  
  -- ========================================================
  --  Burst Transactions
  -- ========================================================

  ------------------------------------------------------------
  procedure WriteBurst (
  -- do CPU Write Cycle
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             NumFifoWords   : In    integer ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec(Index).Operation     <= WRITE_BURST ;
    TransactionRec(Index).Address       <= SafeResize(iAddr, TransactionRec(Index).Address'length) ;
    TransactionRec(Index).AddrWidth     <= iAddr'length ;
--    TransactionRec(Index).DataToModel   <= (TransactionRec(Index).DataToModel'range => 'X') ;
    TransactionRec(Index).DataWidth     <= NumFifoWords ;
    TransactionRec(Index).StatusMsgOn   <= StatusMsgOn ;
    -- Start Transaction
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
  end procedure WriteBurst ;
  
  ------------------------------------------------------------
  procedure WriteBurstVector (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             VectorOfWords  : In    slv_vector ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    PushBurstVector(TransactionRec(Index).WriteBurstFifo, VectorOfWords) ; 
    WriteBurst(TransactionRec, Index, iAddr, VectorOfWords'length, StatusMsgOn) ; 
  end procedure WriteBurstVector ;
  
  ------------------------------------------------------------
  procedure WriteBurstVector (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             VectorOfWords  : In    integer_vector ;
             FifoWidth      : In    integer ; 
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    PushBurstVector(TransactionRec(Index).WriteBurstFifo, VectorOfWords, FifoWidth) ; 
    WriteBurst(TransactionRec, Index, iAddr, VectorOfWords'length, StatusMsgOn) ; 
  end procedure WriteBurstVector ;
  
  ------------------------------------------------------------
  procedure WriteBurstIncrement (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             FirstWord      : In    std_logic_vector ;
             NumFifoWords   : In    integer ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    PushBurstIncrement(TransactionRec(Index).WriteBurstFifo, FirstWord, NumFifoWords) ; 
    WriteBurst(TransactionRec, Index, iAddr, NumFifoWords, StatusMsgOn) ; 
  end procedure WriteBurstIncrement ;

  ------------------------------------------------------------
  procedure WriteBurstRandom (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             FirstWord      : In    std_logic_vector ;
             NumFifoWords   : In    integer ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    PushBurstRandom(TransactionRec(Index).WriteBurstFifo, FirstWord, NumFifoWords) ; 
    WriteBurst(TransactionRec, Index, iAddr, NumFifoWords, StatusMsgOn) ; 
  end procedure WriteBurstRandom ;

  ------------------------------------------------------------
  procedure WriteBurstRandom (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             CoverID        : In    CoverageIDType ;
             NumFifoWords   : In    integer ;
             FifoWidth      : In    integer ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    PushBurstRandom(TransactionRec(Index).WriteBurstFifo, CoverID, NumFifoWords, FifoWidth) ; 
    WriteBurst(TransactionRec, Index, iAddr, NumFifoWords, StatusMsgOn) ; 
  end procedure WriteBurstRandom ;

  ------------------------------------------------------------
  procedure WriteBurstAsync (
  -- dispatch CPU Write Cycle
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             NumFifoWords   : In    integer ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec(Index).Operation     <= ASYNC_WRITE_BURST ;
    TransactionRec(Index).Address       <= SafeResize(iAddr, TransactionRec(Index).Address'length) ;
    TransactionRec(Index).AddrWidth     <= iAddr'length ;
--    TransactionRec(Index).DataToModel   <= (TransactionRec(Index).DataToModel'range => 'X') ;
    TransactionRec(Index).DataWidth     <= NumFifoWords ;
    TransactionRec(Index).StatusMsgOn   <= StatusMsgOn ;
    -- Start Transaction
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
  end procedure WriteBurstAsync ;
  
  ------------------------------------------------------------
  procedure WriteBurstVectorAsync (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             VectorOfWords  : In    slv_vector ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    PushBurstVector(TransactionRec(Index).WriteBurstFifo, VectorOfWords) ; 
    WriteBurstAsync(TransactionRec, Index, iAddr, VectorOfWords'length, StatusMsgOn) ; 
  end procedure WriteBurstVectorAsync ;
  
  ------------------------------------------------------------
  procedure WriteBurstVectorAsync (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             VectorOfWords  : In    integer_vector ;
             FifoWidth      : In    integer ; 
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    PushBurstVector(TransactionRec(Index).WriteBurstFifo, VectorOfWords, FifoWidth) ; 
    WriteBurstAsync(TransactionRec, Index, iAddr, VectorOfWords'length, StatusMsgOn) ; 
  end procedure WriteBurstVectorAsync ;

  ------------------------------------------------------------
  procedure WriteBurstIncrementAsync (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             FirstWord      : In    std_logic_vector ;
             NumFifoWords   : In    integer ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    PushBurstIncrement(TransactionRec(Index).WriteBurstFifo, FirstWord, NumFifoWords) ; 
    WriteBurstAsync(TransactionRec, Index, iAddr, NumFifoWords, StatusMsgOn) ; 
  end procedure WriteBurstIncrementAsync ;

  ------------------------------------------------------------
  procedure WriteBurstRandomAsync (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             FirstWord      : In    std_logic_vector ;
             NumFifoWords   : In    integer ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    PushBurstRandom(TransactionRec(Index).WriteBurstFifo, FirstWord, NumFifoWords) ; 
    WriteBurstAsync(TransactionRec, Index, iAddr, NumFifoWords, StatusMsgOn) ; 
  end procedure WriteBurstRandomAsync ;  
  
  ------------------------------------------------------------
  procedure WriteBurstRandomAsync (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             CoverID        : In    CoverageIDType ;
             NumFifoWords   : In    integer ;
             FifoWidth      : In    integer ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    PushBurstRandom(TransactionRec(Index).WriteBurstFifo, CoverID, NumFifoWords, FifoWidth) ; 
    WriteBurstAsync(TransactionRec, Index, iAddr, NumFifoWords, StatusMsgOn) ; 
  end procedure WriteBurstRandomAsync ;

  ------------------------------------------------------------
  procedure ReadBurst (
  -- do CPU Read Cycle and return data
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             NumFifoWords   : In    integer ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec(Index).Operation     <= READ_BURST ;
    TransactionRec(Index).Address       <= SafeResize(iAddr, TransactionRec(Index).Address'length) ;
    TransactionRec(Index).AddrWidth     <= iAddr'length ;
    TransactionRec(Index).DataWidth     <= NumFifoWords ;
--??    TransactionRec(Index).DataWidth     <= 0 ;
    TransactionRec(Index).StatusMsgOn   <= StatusMsgOn ;
    -- Start Transaction
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
--??    -- Return Results
--??    NumFifoWords := TransactionRec(Index).IntFromModel ;
  end procedure ReadBurst ;
  
  ------------------------------------------------------------
  procedure ReadCheckBurstVector (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             VectorOfWords  : In    slv_vector ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    ReadBurst(TransactionRec, Index, iAddr, VectorOfWords'length, StatusMsgOn) ; 
    CheckBurstVector(TransactionRec(Index).ReadBurstFifo, VectorOfWords) ;
  end procedure ReadCheckBurstVector ;
  
  ------------------------------------------------------------
  procedure ReadCheckBurstVector (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             VectorOfWords  : In    integer_vector ;
             FifoWidth      : In    integer ; 
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    ReadBurst(TransactionRec, Index, iAddr, VectorOfWords'length, StatusMsgOn) ; 
    CheckBurstVector(TransactionRec(Index).ReadBurstFifo, VectorOfWords, FifoWidth) ;
  end procedure ReadCheckBurstVector ;
  
  ------------------------------------------------------------
  procedure ReadCheckBurstIncrement (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             FirstWord      : In    std_logic_vector ;
             NumFifoWords   : In    integer ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    ReadBurst(TransactionRec, Index, iAddr, NumFifoWords, StatusMsgOn) ; 
    CheckBurstIncrement(TransactionRec(Index).ReadBurstFifo, FirstWord, NumFifoWords) ; 
  end procedure ReadCheckBurstIncrement ;

  ------------------------------------------------------------
  procedure ReadCheckBurstRandom (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             FirstWord      : In    std_logic_vector ;
             NumFifoWords   : In    integer ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    ReadBurst(TransactionRec, Index, iAddr, NumFifoWords, StatusMsgOn) ; 
    CheckBurstRandom(TransactionRec(Index).ReadBurstFifo, FirstWord, NumFifoWords) ; 
  end procedure ReadCheckBurstRandom ;

  ------------------------------------------------------------
  procedure ReadCheckBurstRandom (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  ;
             iAddr          : In    std_logic_vector ;
             CoverID        : In    CoverageIDType ;
             NumFifoWords   : In    integer ;
             FifoWidth      : In    integer ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    ReadBurst(TransactionRec, Index, iAddr, NumFifoWords, StatusMsgOn) ; 
    CheckBurstRandom(TransactionRec(Index).ReadBurstFifo, CoverID, NumFifoWords, FifoWidth) ; 
  end procedure ReadCheckBurstRandom ;

  -- ========================================================
  --  Pseudo Transactions
  --  Interact with the record only.
  -- ========================================================
  ------------------------------------------------------------
  procedure ReleaseTransactionRecord (
  --  Must run on same delta cycle as AcquireTransactionRecord
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  
  ) is
  begin
    -- Set everything driven by TestCtrl to type'left (except Rdy)
    TransactionRec(Index).Rdy           <= RdyType'left ;   
    TransactionRec(Index).Operation     <= NOT_DRIVEN ;
    TransactionRec(Index).Address       <= (TransactionRec(Index).Address'range => 'U') ;
    TransactionRec(Index).AddrWidth     <= integer'left ; 
    TransactionRec(Index).DataToModel   <= (TransactionRec(Index).DataToModel'range => 'U') ;
    TransactionRec(Index).DataWidth     <= integer'left ; 
    TransactionRec(Index).StatusMsgOn   <= boolean'left ; 
    TransactionRec(Index).IntToModel    <= integer'left ; 
    TransactionRec(Index).BoolToModel   <= boolean'left ;  
    TransactionRec(Index).Options       <= integer'left ;    
  end procedure ReleaseTransactionRecord ; 
  
  ------------------------------------------------------------
  procedure AcquireTransactionRecord (
  --  Must run on same delta cycle as ReleaseTransactionRecord
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecArrayType ;
    constant Index          : In    integer  
  ) is
  begin
    -- Start Driving Rdy on next delta cycle with the current value.  
    TransactionRec(Index).Rdy <= TransactionRec(Index).Rdy ; 
  end procedure AcquireTransactionRecord ; 
    

end package body AddressBusTransactionArrayPkg ;