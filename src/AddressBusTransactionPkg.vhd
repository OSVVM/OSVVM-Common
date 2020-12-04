--
--  File Name:         AddressBusTransactionPkg.vhd
--  Design Unit Name:  AddressBusTransactionPkg
--  Revision:          OSVVM MODELS STANDARD VERSION
--
--  Maintainer:        Jim Lewis      email:  jim@synthworks.com
--  Contributor(s):
--     Jim Lewis      jim@synthworks.com
--     Rob Gaddi      Highland Technology.    Wrote a similar package which inspired this one.
--
--
--  Description:
--      Defines types, constants, and subprograms used by
--      OSVVM Address Bus Transaction Based Models (aka: TBM, TLM, VVC)
--
--
--  Developed by:
--        SynthWorks Design Inc.
--        VHDL Training Classes
--        http://www.SynthWorks.com
--
--  Revision History:
--    Date      Version    Description
--    09/2017   2017       Initial revision
--    01/2020   2020.01    Updated license notice
--    02/2020   2020.02    Refactored from Axi4LiteMasterTransactionPkg
--    07/2020   2020.07    Unified M/S packages - dropping M/S terminology
--    09/2020   2020.09    Updating comments to serve as documentation
--    12/2020   2020.12    Added SetBurstMode, updated parameter names for consistency
--
--  This file is part of OSVVM.
--  
--  Copyright (c) 2017 - 2020 by SynthWorks Design Inc.  
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
    
package AddressBusTransactionPkg is

  -- ========================================================
  --  AddressBusOperationType 
  --  Enumeration type used to communication transaction type
  --  to the model via the transaction interface
  -- ========================================================
  type UnresolvedAddressBusOperationType is (
    --
    -- Model Directives
    --
    WAIT_FOR_CLOCK,
    WAIT_FOR_TRANSACTION,
    WAIT_FOR_WRITE_TRANSACTION, WAIT_FOR_READ_TRANSACTION, 
    GET_TRANSACTION_COUNT, 
    GET_WRITE_TRANSACTION_COUNT, GET_READ_TRANSACTION_COUNT,
    GET_ALERTLOG_ID, 
    -- Burst FIFO Configuration
    SET_BURST_MODE,
    GET_BURST_MODE,
    -- Model Options
    SET_MODEL_OPTIONS, 
    GET_MODEL_OPTIONS,
    --
    --  bus operations                        Master                Minion
    --                       --------------------------------------------------------
    WRITE_OP,                -- Blocking     (Tx Addr & Data)      (Rx Addr & Data)
    WRITE_ADDRESS,           -- Blocking     (Tx Addr)             (Rx Addr)
    WRITE_DATA,              -- Blocking     (Tx Data)             (Rx Data)
    ASYNC_WRITE,             -- Non-blocking (Tx Addr & Data)      (Rx Addr & Data)
    ASYNC_WRITE_ADDRESS,     -- Non-blocking (Tx Addr)             (Rx Addr)
    ASYNC_WRITE_DATA,        -- Non-blocking (Tx Data)             (Rx Data)
    
    READ_OP,                 -- Blocking     (Tx Addr & Rx Data)   (Rx Addr & Tx Data)
    READ_ADDRESS,            -- Blocking     (Tx Addr)             (Rx Addr)
    READ_DATA,               -- Blocking     (Rx Data)             (Tx Data)
    READ_CHECK,              -- Blocking     (Tx Addr & Tx Data)   
    READ_DATA_CHECK,         -- Blocking     (Tx Data)             (Tx Data)
    ASYNC_READ,              -- Non-blocking  --------             (Rx Addr, Tx Data)
    ASYNC_READ_ADDRESS,      -- Non-blocking (Tx Addr)             (Rx Addr)
    ASYNC_READ_DATA,         -- Non-blocking (Rx Data)             (Tx Data)
    ASYNC_READ_DATA_CHECK,   -- Non-blocking (Tx Data)             
    --
    --  burst operations
    --                       ----------------------------
    WRITE_BURST,             -- Blocking BURST (Tx Addr & Data)
    WRITE_BURST_ADDRESS,
    WRITE_BURST_DATA,
    ASYNC_WRITE_BURST,       -- Non-blocking BURST (Tx Addr & Data)
    ASYNC_WRITE_BURST_ADDRESS,
    ASYNC_WRITE_BURST_DATA,
    
    READ_BURST,              -- Blocking BURST (Tx Addr, Rx Data)
    READ_BURST_ADDRESS,
    READ_BURST_DATA,
    ASYNC_READ_BURST,       -- Non-blocking BURST (Tx Addr & Data)
    ASYNC_READ_BURST_ADDRESS,
    ASYNC_READ_BURST_DATA,

    THE_END
  ) ;
  
  type UnresolvedAddressBusOperationVectorType is array (natural range <>) of UnresolvedAddressBusOperationType ;
--  alias resolved_max is maximum[ UnresolvedAddressBusOperationVectorType return UnresolvedAddressBusOperationType] ;
  -- Maximum is implicitly defined for any array type in VHDL-2008.   Function resolved_max is a fall back.
  function resolved_max ( s : UnresolvedAddressBusOperationVectorType) return UnresolvedAddressBusOperationType ;
  subtype AddressBusOperationType is resolved_max UnresolvedAddressBusOperationType ;


  -- ========================================================
  --  AddressBusRecType 
  --  Transaction interface between the test sequencer and the 
  --  verification component.   As such it is the primary channel 
  --  for information exchange between the two.
  --  The types bit_max, std_logic_vector_max_c, integer_max, and 
  --  boolean_max are defined the OSVVM package, ResolutionPkg.  
  --  These types allow the record to support multiple drivers and 
  --  use resolution functions based on function maximum (return largest value)
  -- ========================================================
  type AddressBusRecType is record
    -- Handshaking controls
    --   Used by RequestTransaction in the Transaction Procedures
    --   Used by WaitForTransaction in the Verification Component
    --   RequestTransaction and WaitForTransaction are in osvvm.TbUtilPkg
    Rdy                : bit_max ;
    Ack                : bit_max ;
    -- Transaction Type
    Operation          : AddressBusOperationType ;
    -- Address to verification component and its width
    -- Width may be smaller than Address
    Address            : std_logic_vector_max_c ;
    AddrWidth          : integer_max ;
    -- Data to and from the verification component and its width.
    -- Width will be smaller than Data for byte operations
    -- Width size requirements are enforced in the verification component
    DataToModel        : std_logic_vector_max_c ;
    DataFromModel      : std_logic_vector_max_c ;
    DataWidth          : integer_max ;
    -- StatusMsgOn provides transaction messaging override.
    -- When true, print transaction messaging independent of 
    -- other verification based based controls.
    StatusMsgOn        : boolean_max ;
    -- Verification Component Options Parameters - used by SetModelOptions
    IntToModel         : integer_max ;
    BoolToModel        : boolean_max ; 
    IntFromModel       : integer_max ; 
    BoolFromModel      : boolean_max ;
    -- Verification Component Options Type - currently aliased to type integer_max 
    Options            : integer_max ;  
  end record AddressBusRecType ;
  
  -- --------------------------------------------------------
  -- Usage of the Transaction Interface (AddressBusRecType)
  -- The Address and Data fields of AddressBusRecType are unconstrained.
  -- Unconstrained objects may be used on component/entity interfaces.    
  -- These fields will be sized when used as a record signal in the test harness 
  -- of the testbench.  Such a declaration is shown below:
  --
  --   signal AxiInitiatorTransactionRec : AddressBusRecType(
  --           Address      (27 downto 0),
  --           DataToModel  (31 downto 0),
  --           DataFromModel(31 downto 0)
  --         ) ;
  -- --------------------------------------------------------
  
--!TODO add VHDL-2018 Interfaces


  -- ========================================================
  --  Types of Transactions
  --  A transaction may be either a directive or an interface transaction.
  --
  --  Directive transactions interact with the verification component 
  --  without generating any transactions or interface waveforms.
  --
  --  An interface transaction results in interface signaling to the DUT.
  --
  --  A blocking transaction is an interface transaction that does not 
  --  does not return (complete) until the interface operation   
  --  requested by the transaction has completed.
  --
  --  An asynchronous transaction is nonblocking interface transaction
  --  that returns before the transaction has completed - typically 
  --  immediately and before the transaction has started. 
  --
  --  A Try transaction is nonblocking interface transaction that 
  --  checks to see if transaction information is available, 
  --  such as read data, and if it is returns it.  
  --
  -- ========================================================


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
    signal    TransactionRec  : inout AddressBusRecType 
  ) ; 

  ------------------------------------------------------------
  procedure WaitForWriteTransaction (
  --  Wait until pending transaction completes
  ------------------------------------------------------------
    signal    TransactionRec  : inout AddressBusRecType 
  ) ; 

  ------------------------------------------------------------
  procedure WaitForReadTransaction (
  --  Wait until pending transaction completes
  ------------------------------------------------------------
    signal    TransactionRec  : inout AddressBusRecType 
  ) ;
  
  ------------------------------------------------------------
  procedure WaitForClock (
  -- Wait for NumberOfClocks number of clocks 
  -- relative to the verification component clock
  ------------------------------------------------------------
    signal   TransactionRec  : InOut AddressBusRecType ;
             NumberOfClocks  : In    natural := 1
  ) ;

  alias NoOp is WaitForClock [AddressBusRecType, natural] ;

  ------------------------------------------------------------
  procedure GetTransactionCount (
  -- Get the number of transactions handled by the model.  
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
    variable Count          : Out   integer
  ) ;

  ------------------------------------------------------------
  procedure GetWriteTransactionCount (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
    variable Count          : Out   integer
  ) ;

  ------------------------------------------------------------
  procedure GetReadTransactionCount (
  -- Get the number of read transactions handled by the model.  
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
    variable Count          : Out   integer
  ) ;

  ------------------------------------------------------------
  procedure GetAlertLogID (
  -- Get the AlertLogID from the verification component.
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
    variable AlertLogID     : Out   AlertLogIDType
  ) ;

  ------------------------------------------------------------
  procedure GetErrorCount (
  -- Error reporting for testbenches that do not use OSVVM AlertLogPkg
  -- Returns error count.  If an error count /= 0, also print errors
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
    variable ErrorCount     : Out   natural
  ) ;

  alias GetErrors is GetErrorCount [AddressBusRecType, natural] ;


  -- ========================================================
  -- BurstFIFOs and Burst Mode Controls
  -- The burst FIFOs hold bursts of data that is to be sent to 
  -- or was received from the interface.   The burst FIFO can be 
  -- configured in the modes defined for StreamFifoBurstModeType.
  -- Currently these modes defined as a subtype of integer, shown below.
  -- The intention of using integers is to facilitate model specific 
  -- extensions without the need to define separate transactions.
  -- ========================================================
  subtype AddressBusFifoBurstModeType is integer ;
  
  -- Word mode indicates the burst FIFO contains interface words.
  -- The size of the word may either be interface specific (such as 
  -- a UART which supports up to 8 bits) or be interface instance specific 
  -- (such as AxiStream which supports interfaces sizes of 1, 2, 4, 8, 
  -- 16, ... bytes)
  constant ADDRESS_BUS_BURST_WORD_MODE       : AddressBusFifoBurstModeType  := 0 ;
  
  -- Byte mode is experimental and may be removed in a future revision.
  -- Byte mode indicates that the burst FIFO contains bytes.  
  -- The verification component assembles interface words from the bytes.
  -- This allows transfers to be conceptualized in an interface independent 
  --manner.    
  constant ADDRESS_BUS_BURST_BYTE_MODE       : AddressBusFifoBurstModeType  := 1 ; 

  -- ========================================================
  --  Set and Get Burst Mode   
  --  Set Burst Mode for models that do bursting.
  -- ========================================================
  ------------------------------------------------------------
  procedure SetBurstMode (
  ------------------------------------------------------------
    signal   TransactionRec  : InOut AddressBusRecType ;
    constant OptVal          : In    AddressBusFifoBurstModeType
  ) ;

  ------------------------------------------------------------
  procedure GetBurstMode (
  ------------------------------------------------------------
    signal   TransactionRec  : InOut AddressBusRecType ;
    variable OptVal          : Out   AddressBusFifoBurstModeType
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
    signal   TransactionRec : InOut AddressBusRecType ;
    constant Option         : In    integer ;
    constant OptVal         : In    boolean
  ) ;

  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
    constant Option         : In    integer ;
    constant OptVal         : In    integer
  ) ;

  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
    constant Option         : In    integer ;
    constant OptVal         : In    std_logic_vector
  ) ;
  
  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
    constant Option         : In    integer ;
    variable OptVal         : Out   boolean
  ) ;

  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
    constant Option         : In    integer ;
    variable OptVal         : Out   integer
  ) ;

  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
    constant Option         : In    integer ;
    variable OptVal         : Out   std_logic_vector
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
    signal   TransactionRec : InOut AddressBusRecType ;
             iAddr          : In    std_logic_vector ;
             iData          : In    std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure WriteAsync (
  -- Asynchronous / Non-Blocking Write Transaction
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
             iAddr          : In    std_logic_vector ;
             iData          : In    std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure Read (
  -- Blocking Read Transaction.
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
             iAddr          : In    std_logic_vector ;
    variable oData          : Out   std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure ReadCheck (
  -- Blocking Read Transaction and check iData, rather than returning a value.
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
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
    signal   TransactionRec : InOut AddressBusRecType ;
             iAddr          : In    std_logic_vector ;
    variable oData          : Out   std_logic_vector ;
             Index          : In    Integer ;
             BitValue       : In    std_logic ;
             StatusMsgOn    : In    boolean := false ;
             WaitTime       : In    natural := 10
  ) ;

  ------------------------------------------------------------
  procedure ReadPoll (
  -- Read location (iAddr) until Data(IndexI) = ValueI
  -- WaitTime is the number of clocks to wait between reads.
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
             iAddr          : In    std_logic_vector ;
             Index          : In    Integer ;
             BitValue       : In    std_logic ;
             StatusMsgOn    : In    boolean := false ;
             WaitTime       : In    natural := 10
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
    signal   TransactionRec : InOut AddressBusRecType ;
             iAddr          : In    std_logic_vector ;
             NumFifoWords   : In    integer ;
             StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure WriteBurstAsync (
  -- Asynchronous / Non-Blocking Write Burst.   
  -- Data is provided separately via a WriteBurstFifo.   
  -- NumFifoWords specifies the number of bytes to be transferred.
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
             iAddr          : In    std_logic_vector ;
             NumFifoWords   : In    integer ;
             StatusMsgOn    : In    boolean := false
  ) ;
  
  ------------------------------------------------------------
  procedure ReadBurst (
  -- Blocking Read Burst.
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
             iAddr          : In    std_logic_vector ;
             NumFifoWords   : In    integer ;
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
    signal   TransactionRec : InOut AddressBusRecType ;
             iAddr          : In    std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure WriteDataAsync (
  -- Non-blocking Write Data 
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
             iAddr          : In    std_logic_vector ;
             iData          : In    std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure WriteDataAsync (
  -- Non-blocking Write Data.  iAddr = 0.  
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
             iData          : In    std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) ;
  
  ------------------------------------------------------------
  procedure ReadAddressAsync (
  -- Non-blocking Read Address
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
             iAddr          : In    std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure ReadData (
  -- Blocking Read Data
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
    variable oData          : Out   std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure ReadCheckData (
  -- Blocking Read data and check iData, rather than returning a value.
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
             iData          : In    std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure TryReadData (
  -- Try (non-blocking) read data attempt.   
  -- If data is available, get it and return available TRUE.
  -- Otherwise Return Available FALSE.
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
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
    signal   TransactionRec : InOut AddressBusRecType ;
             iData          : In    std_logic_vector ;
    variable Available      : Out   boolean ;
             StatusMsgOn    : In    boolean := false
  ) ;


  -- ========================================================
  --  Verification Component Support Functions
  --  These help decode the operation value (AddressBusOperationType)  
  --  to determine properties about the operation
  -- ========================================================
  ------------------------------------------------------------
  function IsWriteAddress (
  -- TRUE for a transaction includes write address
  -----------------------------------------------------------
    constant Operation     : in AddressBusOperationType
  ) return boolean ;

  ------------------------------------------------------------
  function IsBlockOnWriteAddress (
  -- TRUE for blocking transactions that include write address
  -----------------------------------------------------------
    constant Operation     : in AddressBusOperationType
  ) return boolean ;

  ------------------------------------------------------------
  function IsTryWriteAddress (
  -- TRUE for asynchronous or try transactions that include write address
  -----------------------------------------------------------
    constant Operation     : in AddressBusOperationType
  ) return boolean ;

  ------------------------------------------------------------
  function IsWriteData (
  -- TRUE for a transaction includes write data
  -----------------------------------------------------------
    constant Operation     : in AddressBusOperationType
  ) return boolean ;

  ------------------------------------------------------------
  function IsBlockOnWriteData (
  -- TRUE for a blocking transactions that include write data
  -----------------------------------------------------------
    constant Operation     : in AddressBusOperationType
  ) return boolean ;

  ------------------------------------------------------------
  function IsTryWriteData (
  -- TRUE for asynchronous or try transactions that include write data
  -----------------------------------------------------------
    constant Operation     : in AddressBusOperationType
  ) return boolean ;

  ------------------------------------------------------------
  function IsReadAddress (
  -- TRUE for a transaction includes read address
  -----------------------------------------------------------
    constant Operation     : in AddressBusOperationType
  ) return boolean ;

  ------------------------------------------------------------
  function IsTryReadAddress (
  -- TRUE for an asynchronous or try transactions that include read address
  -----------------------------------------------------------
    constant Operation     : in AddressBusOperationType
  ) return boolean ;

  ------------------------------------------------------------
  function IsReadData (
  -- TRUE for a transaction includes read data
  -----------------------------------------------------------
    constant Operation     : in AddressBusOperationType
  ) return boolean ;

  ------------------------------------------------------------
  function IsBlockOnReadData (
  -- TRUE for a blocking transactions that include read data
  -----------------------------------------------------------
    constant Operation     : in AddressBusOperationType
  ) return boolean ;

  ------------------------------------------------------------
  function IsTryReadData (
  -- TRUE for asynchronous or try transactions that include read data
  -----------------------------------------------------------
    constant Operation     : in AddressBusOperationType
  ) return boolean ;

  ------------------------------------------------------------
  function IsReadCheck (
  -- TRUE for a transaction includes check information for read data 
  -----------------------------------------------------------
    constant Operation     : in AddressBusOperationType
  ) return boolean ;

  ------------------------------------------------------------
  function IsBurst (
  -- TRUE for a transaction includes read or write burst information
  -----------------------------------------------------------
    constant Operation     : in AddressBusOperationType
  ) return boolean ;

  
end package AddressBusTransactionPkg ;

-- /////////////////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////////////////

package body AddressBusTransactionPkg is

  function resolved_max ( s : UnresolvedAddressBusOperationVectorType) return UnresolvedAddressBusOperationType is
  begin
    return maximum(s) ;
  end function resolved_max ;


  ------------------------------------------------------------
  procedure WaitForTransaction (
  --  Wait until pending transaction completes
  ------------------------------------------------------------
    signal    TransactionRec  : inout AddressBusRecType 
  ) is
  begin
    TransactionRec.Operation   <= WAIT_FOR_TRANSACTION ;
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ; 
  end procedure WaitForTransaction ; 

  ------------------------------------------------------------
  procedure WaitForWriteTransaction (
  --  Wait until pending transaction completes
  ------------------------------------------------------------
    signal    TransactionRec  : inout AddressBusRecType 
  ) is
  begin
    TransactionRec.Operation   <= WAIT_FOR_WRITE_TRANSACTION ;
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ; 
  end procedure WaitForWriteTransaction ; 

  ------------------------------------------------------------
  procedure WaitForReadTransaction (
  --  Wait until pending transaction completes
  ------------------------------------------------------------
    signal    TransactionRec  : inout AddressBusRecType 
  ) is
  begin
    TransactionRec.Operation   <= WAIT_FOR_READ_TRANSACTION ;
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ; 
  end procedure WaitForReadTransaction ; 

  ------------------------------------------------------------
  procedure WaitForClock (
  -- Directive:  Wait for NumberOfClocks number of clocks in the model
  ------------------------------------------------------------
    signal   TransactionRec  : InOut AddressBusRecType ;
             NumberOfClocks  : In    natural := 1
  ) is
  begin
    TransactionRec.Operation     <= WAIT_FOR_CLOCK ;
    TransactionRec.DataToModel   <= ToTransaction(NumberOfClocks, TransactionRec.DataToModel'length);
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ;
  end procedure WaitForClock ;

  ------------------------------------------------------------
  procedure GetTransactionCount (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
    variable Count          : Out   integer
  ) is
  begin
    TransactionRec.Operation     <= GET_TRANSACTION_COUNT ;
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ;

    -- Return AlertLogID
    Count := TransactionRec.IntFromModel ;
  end procedure GetTransactionCount ;

  ------------------------------------------------------------
  procedure GetWriteTransactionCount (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
    variable Count          : Out   integer
  ) is
  begin
    TransactionRec.Operation     <= GET_WRITE_TRANSACTION_COUNT ;
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ;

    -- Return AlertLogID
    Count := TransactionRec.IntFromModel ;
  end procedure GetWriteTransactionCount ;

  ------------------------------------------------------------
  procedure GetReadTransactionCount (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
    variable Count          : Out   integer
  ) is
  begin
    TransactionRec.Operation     <= GET_READ_TRANSACTION_COUNT ;
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ;

    -- Return AlertLogID
    Count := TransactionRec.IntFromModel ;
  end procedure GetReadTransactionCount ;

  ------------------------------------------------------------
  procedure GetAlertLogID (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
    variable AlertLogID     : Out   AlertLogIDType
  ) is
  begin
    TransactionRec.Operation     <= GET_ALERTLOG_ID ;
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ;

    -- Return AlertLogID
    AlertLogID := AlertLogIDType(TransactionRec.IntFromModel) ;
  end procedure GetAlertLogID ;

  ------------------------------------------------------------
  procedure GetErrorCount (
  -- Error reporting for testbenches that do not use AlertLogPkg
  -- Returns error count.  If an error count /= 0, also print it
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
    variable ErrorCount     : Out   natural
  ) is
    variable ModelID : AlertLogIDType ;
  begin
    GetAlertLogID(TransactionRec, ModelID) ;
--    ReportNonZeroAlerts(AlertLogID => ModelID) ;
    ErrorCount := GetAlertCount(AlertLogID => ModelID) ;
  end procedure GetErrorCount ;

  -- ========================================================
  --  Set and Get Burst Mode   
  --  Set Burst Mode for models that do bursting.
  -- ========================================================
  ------------------------------------------------------------
  procedure SetBurstMode (
  ------------------------------------------------------------
    signal   TransactionRec  : InOut AddressBusRecType ;
    constant OptVal          : In    AddressBusFifoBurstModeType
  ) is
  begin
    TransactionRec.Operation     <= SET_BURST_MODE ;
    TransactionRec.IntToModel    <= OptVal ;
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ;
  end procedure SetBurstMode ;

  ------------------------------------------------------------
  procedure GetBurstMode (
  ------------------------------------------------------------
    signal   TransactionRec  : InOut AddressBusRecType ;
    variable OptVal          : Out   AddressBusFifoBurstModeType
  ) is
  begin
    TransactionRec.Operation     <= GET_BURST_MODE ;
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ;
    OptVal := TransactionRec.IntFromModel ; 
  end procedure GetBurstMode ;

  --
  --  Extensions to support model customizations
  -- 
  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
    constant Option         : In    integer ;
    constant OptVal         : In    boolean
  ) is
  begin
    TransactionRec.Operation     <= SET_MODEL_OPTIONS ;
    TransactionRec.Options       <= Option ;
    TransactionRec.BoolToModel   <= OptVal ;
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ;
  end procedure SetModelOptions ;

  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
    constant Option         : In    integer ;
    constant OptVal         : In    integer
  ) is
  begin
    TransactionRec.Operation     <= SET_MODEL_OPTIONS ;
    TransactionRec.Options       <= Option ;
    TransactionRec.IntToModel    <= OptVal ;
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ;
  end procedure SetModelOptions ;

  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
    constant Option         : In    integer ;
    constant OptVal         : In    std_logic_vector
  ) is
  begin
    TransactionRec.Operation     <= SET_MODEL_OPTIONS ;
    TransactionRec.Options       <= Option ;
    TransactionRec.IntToModel    <= to_integer(OptVal) ;
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ;
  end procedure SetModelOptions ;
  
  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
    constant Option         : In    integer ;
    variable OptVal         : Out   boolean
  ) is
  begin
    TransactionRec.Operation     <= GET_MODEL_OPTIONS ;
    TransactionRec.Options       <= Option ;
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ;
    OptVal := TransactionRec.BoolFromModel    ;
  end procedure GetModelOptions ;

  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
    constant Option         : In    integer ;
    variable OptVal         : Out   integer
  ) is
  begin
    TransactionRec.Operation     <= GET_MODEL_OPTIONS ;
    TransactionRec.Options       <= Option ;
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ;
    OptVal := TransactionRec.IntFromModel ; 
  end procedure GetModelOptions ;

  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
    constant Option         : In    integer ;
    variable OptVal         : Out   std_logic_vector
  ) is
  begin
    TransactionRec.Operation     <= GET_MODEL_OPTIONS ;
    TransactionRec.Options       <= Option ;
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ;
    OptVal := to_slv(TransactionRec.IntFromModel, OptVal'length) ; 
  end procedure GetModelOptions ;
  
  
  ------------------------------------------------------------
  procedure Write (
  -- do CPU Write Cycle
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
             iAddr          : In    std_logic_vector ;
             iData          : In    std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec.Operation        <= WRITE_OP ;
    TransactionRec.Address          <= ToTransaction(iAddr) ;
    TransactionRec.AddrWidth        <= iAddr'length ;
    TransactionRec.DataToModel      <= ToTransaction(Extend(iData, TransactionRec.DataToModel'length)) ;
    TransactionRec.DataWidth        <= iData'length ;
    TransactionRec.StatusMsgOn      <= StatusMsgOn ;
    -- Start Transaction
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ;
  end procedure Write ;

  ------------------------------------------------------------
  procedure WriteAsync (
  -- dispatch CPU Write Cycle
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
             iAddr          : In    std_logic_vector ;
             iData          : In    std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec.Operation        <= ASYNC_WRITE ;
    TransactionRec.Address          <= ToTransaction(iAddr) ;
    TransactionRec.AddrWidth        <= iAddr'length ;
    TransactionRec.DataToModel      <= ToTransaction(Extend(iData, TransactionRec.DataToModel'length)) ;
    TransactionRec.DataWidth        <= iData'length ;
    TransactionRec.StatusMsgOn      <= StatusMsgOn ;
    -- Start Transaction
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ;
  end procedure WriteAsync ;

  ------------------------------------------------------------
  procedure WriteAddressAsync (
  -- dispatch CPU Write Address Cycle
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
             iAddr          : In    std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec.Operation        <= ASYNC_WRITE_ADDRESS ;
    TransactionRec.Address          <= ToTransaction(iAddr) ;
    TransactionRec.AddrWidth        <= iAddr'length ;
    TransactionRec.DataToModel      <= (TransactionRec.DataToModel'range => 'X') ;
    TransactionRec.DataWidth        <= 0 ;
    TransactionRec.StatusMsgOn      <= StatusMsgOn ;
    -- Start Transaction
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ;
  end procedure WriteAddressAsync ;

  ------------------------------------------------------------
  procedure WriteDataAsync (
  -- dispatch CPU Write Data Cycle
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
             iAddr          : In    std_logic_vector ;
             iData          : In    std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec.Operation        <= ASYNC_WRITE_DATA ;
    TransactionRec.Address          <= ToTransaction(iAddr, TransactionRec.Address'length) ;
    TransactionRec.AddrWidth        <= iAddr'length ;
    TransactionRec.DataToModel      <= ToTransaction(iData, TransactionRec.DataToModel'length) ;
    TransactionRec.DataWidth        <= iData'length ;
    TransactionRec.StatusMsgOn      <= StatusMsgOn ;
    -- Start Transaction
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ;
  end procedure WriteDataAsync ;
  
  ------------------------------------------------------------
  procedure WriteDataAsync (
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
             iData          : In    std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    WriteDataAsync(TransactionRec, X"00", iData, StatusMsgOn) ;
  end procedure WriteDataAsync ;

  ------------------------------------------------------------
  procedure WriteBurst (
  -- do CPU Write Cycle
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
             iAddr          : In    std_logic_vector ;
             NumFifoWords   : In    integer ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec.Operation        <= WRITE_BURST ;
    TransactionRec.Address          <= ToTransaction(iAddr) ;
    TransactionRec.AddrWidth        <= iAddr'length ;
--    TransactionRec.DataToModel      <= (TransactionRec.DataToModel'range => 'X') ;
    TransactionRec.DataWidth        <= NumFifoWords ;
--    TransactionRec.DataToModel      <= ToTransaction(to_slv(NumFifoWords, TransactionRec.DataToModel'length)) ;
--    TransactionRec.DataWidth        <= 0 ;
    TransactionRec.StatusMsgOn      <= StatusMsgOn ;
    -- Start Transaction
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ;
  end procedure WriteBurst ;

  ------------------------------------------------------------
  procedure WriteBurstAsync (
  -- dispatch CPU Write Cycle
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
             iAddr          : In    std_logic_vector ;
             NumFifoWords   : In    integer ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec.Operation        <= ASYNC_WRITE_BURST ;
    TransactionRec.Address          <= ToTransaction(iAddr) ;
    TransactionRec.AddrWidth        <= iAddr'length ;
--    TransactionRec.DataToModel      <= (TransactionRec.DataToModel'range => 'X') ;
    TransactionRec.DataWidth        <= NumFifoWords ;
--    TransactionRec.DataToModel      <= ToTransaction(to_slv(NumFifoWords, TransactionRec.DataToModel'length)) ;
--    TransactionRec.DataWidth        <= 0 ;
    TransactionRec.StatusMsgOn      <= StatusMsgOn ;
    -- Start Transaction
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ;
  end procedure WriteBurstAsync ;
  
  ------------------------------------------------------------
  procedure Read (
  -- do CPU Read Cycle and return data
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
             iAddr          : In    std_logic_vector ;
    variable oData          : Out   std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec.Operation          <= READ_OP ;
    TransactionRec.Address            <= ToTransaction(iAddr) ;
    TransactionRec.AddrWidth          <= iAddr'length ;
    TransactionRec.DataWidth          <= oData'length ;
    TransactionRec.StatusMsgOn        <= StatusMsgOn ;
    -- Start Transaction
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ;
    -- Return Results
    oData := Reduce(FromTransaction(TransactionRec.DataFromModel), oData'Length) ;
  end procedure Read ;

  ------------------------------------------------------------
  procedure ReadCheck (
  -- do CPU Read Cycle and check supplied data
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
             iAddr          : In    std_logic_vector ;
             iData          : In    std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec.Operation          <= READ_CHECK ;
    TransactionRec.Address            <= ToTransaction(iAddr) ;
    TransactionRec.AddrWidth          <= iAddr'length ;
    TransactionRec.DataToModel        <= ToTransaction(Extend(iData, TransactionRec.DataToModel'length)) ;
    TransactionRec.DataWidth          <= iData'length ;
    TransactionRec.StatusMsgOn        <= StatusMsgOn ;
    -- Start Transaction
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ;
  end procedure ReadCheck ;

  ------------------------------------------------------------
  procedure ReadAddressAsync (
  -- dispatch CPU Read Address Cycle
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
             iAddr          : In    std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec.Operation          <= ASYNC_READ_ADDRESS ;
    TransactionRec.Address            <= ToTransaction(iAddr) ;
    TransactionRec.AddrWidth          <= iAddr'length ;
    TransactionRec.DataToModel        <= (TransactionRec.DataToModel'range => 'X') ;
    TransactionRec.DataWidth          <= 0 ;
    TransactionRec.StatusMsgOn        <= StatusMsgOn ;
    -- Start Transaction
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ;
  end procedure ReadAddressAsync ;

  ------------------------------------------------------------
  procedure ReadData (
  -- Do CPU Read Data Cycle
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
    variable oData          : Out   std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec.Operation          <= READ_DATA ;
    TransactionRec.Address            <= (TransactionRec.Address'range => 'X') ;
    TransactionRec.DataWidth          <= oData'length ;
    TransactionRec.StatusMsgOn        <= StatusMsgOn ;
    -- Start Transaction
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ;
    -- Return Results
    oData := Reduce(FromTransaction(TransactionRec.DataFromModel), oData'Length) ;
  end procedure ReadData ;

  ------------------------------------------------------------
  procedure ReadCheckData (
  -- Do CPU Read Data Cycle and check received Data
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
             iData          : In    std_logic_vector ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec.Operation          <= READ_DATA_CHECK ;
    TransactionRec.Address            <= (TransactionRec.Address'range => 'X') ;
    TransactionRec.DataToModel        <= ToTransaction(Extend(iData, TransactionRec.DataToModel'length)) ;
    TransactionRec.DataWidth          <= iData'length ;
    TransactionRec.StatusMsgOn        <= StatusMsgOn ;
    -- Start Transaction
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ;
  end procedure ReadCheckData ;

  ------------------------------------------------------------
  procedure TryReadData (
  -- Try to Get CPU Read Data Cycle
  -- If data is available, get it and return available TRUE.
  -- Otherwise Return Available FALSE.
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
    variable oData          : Out   std_logic_vector ;
    variable Available      : Out   boolean ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec.Operation          <= ASYNC_READ_DATA ;
    TransactionRec.Address            <= (TransactionRec.Address'range => 'X') ;
    TransactionRec.DataWidth          <= oData'length ;
    TransactionRec.StatusMsgOn        <= StatusMsgOn ;
    -- Start Transaction
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ;
    -- Return Results
    oData := Reduce(FromTransaction(TransactionRec.DataFromModel), oData'Length) ;
    Available := TransactionRec.BoolFromModel ;
  end procedure TryReadData ;

  ------------------------------------------------------------
  procedure TryReadCheckData (
  -- Try to Get CPU Read Data Cycle
  -- If data is available, check it and return available TRUE.
  -- Otherwise Return Available FALSE.
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
             iData          : In    std_logic_vector ;
    variable Available      : Out   boolean ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec.Operation          <= ASYNC_READ_DATA_CHECK ;
    TransactionRec.Address            <= (TransactionRec.Address'range => 'X') ;
    TransactionRec.DataToModel        <= ToTransaction(Extend(iData, TransactionRec.DataToModel'length)) ;
    TransactionRec.DataWidth          <= iData'length ;
    TransactionRec.StatusMsgOn        <= StatusMsgOn ;
    -- Start Transaction
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ;
    Available := TransactionRec.BoolFromModel ;
  end procedure TryReadCheckData ;

  ------------------------------------------------------------
  procedure ReadPoll (
  -- Read location (iAddr) until Data(IndexI) = ValueI
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
             iAddr          : In    std_logic_vector ;
    variable oData          : Out   std_logic_vector ;
             Index          : In    Integer ;
             BitValue       : In    std_logic ;
             StatusMsgOn    : In    boolean := false ;
             WaitTime       : In    natural := 10
  ) is
    variable vData    : std_logic_vector(oData'length-1 downto 0) ;
    variable ModelID  : AlertLogIDType ;
  begin
    loop
      WaitForClock(TransactionRec, WaitTime) ;
      Read (TransactionRec, iAddr, vData) ;
      exit when vData(Index) = BitValue ;
    end loop ;

    GetAlertLogID(TransactionRec, ModelID) ;
    Log(ModelID, "CpuPoll: address" & to_hstring(iAddr) &
      "  Data: " & to_hstring(FromTransaction(vData)), INFO, StatusMsgOn) ;
    oData := vData ;
  end procedure ReadPoll ;

  ------------------------------------------------------------
  procedure ReadPoll (
  -- Read location (iAddr) until Data(IndexI) = ValueI
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
             iAddr          : In    std_logic_vector ;
             Index          : In    Integer ;
             BitValue       : In    std_logic ;
             StatusMsgOn    : In    boolean := false ;
             WaitTime       : In    natural := 10
  ) is
    variable vData    : std_logic_vector(TransactionRec.DataFromModel'range) ;
  begin
    ReadPoll(TransactionRec, iAddr, vData, Index, BitValue, StatusMsgOn, WaitTime) ;
  end procedure ReadPoll ;

  ------------------------------------------------------------
  procedure ReadBurst (
  -- do CPU Read Cycle and return data
  ------------------------------------------------------------
    signal   TransactionRec : InOut AddressBusRecType ;
             iAddr          : In    std_logic_vector ;
             NumFifoWords   : In    integer ;
             StatusMsgOn    : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec.Operation          <= READ_BURST ;
    TransactionRec.Address            <= ToTransaction(iAddr) ;
    TransactionRec.AddrWidth          <= iAddr'length ;
    TransactionRec.DataWidth          <= NumFifoWords ;
--??    TransactionRec.DataWidth          <= 0 ;
    TransactionRec.StatusMsgOn        <= StatusMsgOn ;
    -- Start Transaction
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ;
--??    -- Return Results
--??    NumFifoWords := to_integer(Reduce(FromTransaction(TransactionRec.DataFromModel), 31)) ;
  end procedure ReadBurst ;
  
  ------------------------------------------------------------
  function IsWriteAddress (
  -----------------------------------------------------------
    constant Operation     : in AddressBusOperationType
  ) return boolean is
  begin
    return
      (Operation = WRITE_OP) or
      (Operation = WRITE_ADDRESS) or
      (Operation = ASYNC_WRITE) or
      (Operation = ASYNC_WRITE_ADDRESS) or 
      (Operation = WRITE_BURST) or
      (Operation = WRITE_BURST_ADDRESS) or 
      (Operation = ASYNC_WRITE_BURST) or
      (Operation = ASYNC_WRITE_BURST_ADDRESS) ;
  end function IsWriteAddress ;

  ------------------------------------------------------------
  function IsBlockOnWriteAddress (
  -----------------------------------------------------------
    constant Operation     : in AddressBusOperationType
  ) return boolean is
  begin
    return
      (Operation = WRITE_OP) or
      (Operation = WRITE_ADDRESS) or
      (Operation = WRITE_BURST) or
      (Operation = WRITE_BURST_ADDRESS) ;
  end function IsBlockOnWriteAddress ;

  ------------------------------------------------------------
  function IsTryWriteAddress (
  -----------------------------------------------------------
    constant Operation     : in AddressBusOperationType
  ) return boolean is
  begin
    return
      (Operation = ASYNC_WRITE) or
      (Operation = ASYNC_WRITE_ADDRESS) or 
      (Operation = ASYNC_WRITE_BURST) or
      (Operation = ASYNC_WRITE_BURST_ADDRESS) ;
  end function IsTryWriteAddress ;

  ------------------------------------------------------------
  function IsWriteData (
  -----------------------------------------------------------
    constant Operation     : in AddressBusOperationType
  ) return boolean is
  begin
    return
      (Operation = WRITE_OP) or
      (Operation = WRITE_DATA) or
      (Operation = ASYNC_WRITE) or
      (Operation = ASYNC_WRITE_DATA) or 
      (Operation = WRITE_BURST) or
      (Operation = WRITE_BURST_DATA) or 
      (Operation = ASYNC_WRITE_BURST) or
      (Operation = ASYNC_WRITE_BURST_DATA) ;
  end function IsWriteData ;

  ------------------------------------------------------------
  function IsBlockOnWriteData (
  -----------------------------------------------------------
    constant Operation     : in AddressBusOperationType
  ) return boolean is
  begin
    return 
      (Operation = WRITE_OP) or
      (Operation = WRITE_DATA) or
      (Operation = WRITE_BURST) or
      (Operation = WRITE_BURST_DATA) ;
  end function IsBlockOnWriteData ;

  ------------------------------------------------------------
  function IsTryWriteData (
  -----------------------------------------------------------
    constant Operation     : in AddressBusOperationType
  ) return boolean is
  begin
    return
      (Operation = ASYNC_WRITE) or
      (Operation = ASYNC_WRITE_DATA) or 
      (Operation = ASYNC_WRITE_BURST) or
      (Operation = ASYNC_WRITE_BURST_DATA) ;
  end function IsTryWriteData ;

  ------------------------------------------------------------
  function IsReadAddress (
  -----------------------------------------------------------
    constant Operation     : in AddressBusOperationType
  ) return boolean is
  begin
    return
      (Operation = READ_OP) or
      (Operation = READ_ADDRESS) or
      (Operation = READ_CHECK) or
      (Operation = ASYNC_READ) or
      (Operation = ASYNC_READ_ADDRESS) or
      (Operation = READ_BURST) or
      (Operation = READ_BURST_ADDRESS) or
      (Operation = ASYNC_READ_BURST) or
      (Operation = ASYNC_READ_BURST_ADDRESS) ;
  end function IsReadAddress ;

  ------------------------------------------------------------
  function IsTryReadAddress (
  -----------------------------------------------------------
    constant Operation     : in AddressBusOperationType
  ) return boolean is
  begin
    return
      (Operation = ASYNC_READ) or
      (Operation = ASYNC_READ_ADDRESS) or
      (Operation = ASYNC_READ_BURST) or
      (Operation = ASYNC_READ_BURST_ADDRESS) ;
  end function IsTryReadAddress ;
  
  ------------------------------------------------------------
  function IsReadData (
  -----------------------------------------------------------
    constant Operation     : in AddressBusOperationType
  ) return boolean is
  begin
    return
      (Operation = READ_OP) or
      (Operation = READ_DATA) or
      (Operation = READ_CHECK) or
      (Operation = READ_DATA_CHECK) or
      (Operation = ASYNC_READ) or
      (Operation = ASYNC_READ_DATA) or
      (Operation = ASYNC_READ_DATA_CHECK) or
      (Operation = READ_BURST) or
      (Operation = READ_BURST_DATA) or
      (Operation = ASYNC_READ_BURST) or
      (Operation = ASYNC_READ_BURST_DATA) ;
  end function IsReadData ;

  ------------------------------------------------------------
  function IsBlockOnReadData (
  -----------------------------------------------------------
    constant Operation     : in AddressBusOperationType
  ) return boolean is
  begin
    return
      (Operation = READ_OP) or
      (Operation = READ_DATA) or
      (Operation = READ_CHECK) or
      (Operation = READ_DATA_CHECK) or
      (Operation = READ_BURST) or
      (Operation = READ_BURST_DATA) ;
  end function IsBlockOnReadData ;

  ------------------------------------------------------------
  function IsTryReadData (
  -----------------------------------------------------------
    constant Operation     : in AddressBusOperationType
  ) return boolean is
  begin
    return 
      (Operation = ASYNC_READ) or
      (Operation = ASYNC_READ_DATA) or
      (Operation = ASYNC_READ_DATA_CHECK) or
      (Operation = ASYNC_READ_BURST) or
      (Operation = ASYNC_READ_BURST_DATA) ;
  end function IsTryReadData ;

  ------------------------------------------------------------
  function IsReadCheck (
  -----------------------------------------------------------
    constant Operation     : in AddressBusOperationType
  ) return boolean is
  begin
    return
      (Operation = READ_CHECK) or
      (Operation = READ_DATA_CHECK) or
      (Operation = ASYNC_READ_DATA_CHECK) ;
  end function IsReadCheck ;

  ------------------------------------------------------------
  function IsBurst (
  -----------------------------------------------------------
    constant Operation     : in AddressBusOperationType
  ) return boolean is
  begin
    return
      (Operation = WRITE_BURST) or
      (Operation = WRITE_BURST_ADDRESS) or
      (Operation = WRITE_BURST_DATA) or
      (Operation = ASYNC_WRITE_BURST) or
      (Operation = ASYNC_WRITE_BURST_ADDRESS) or
      (Operation = ASYNC_WRITE_BURST_DATA) or
      (Operation = READ_BURST) or
      (Operation = READ_BURST_ADDRESS) or
      (Operation = READ_BURST_DATA) or
      (Operation = ASYNC_READ_BURST) or
      (Operation = ASYNC_READ_BURST_ADDRESS) or
      (Operation = ASYNC_READ_BURST_DATA) ;
  end function IsBurst ;

end package body AddressBusTransactionPkg ;