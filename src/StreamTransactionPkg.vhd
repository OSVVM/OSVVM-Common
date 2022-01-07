--
--  File Name:         StreamTransactionPkg.vhd
--  Design Unit Name:  StreamTransactionPkg
--  Revision:          OSVVM MODELS STANDARD VERSION
--
--  Maintainer:        Jim Lewis      email:  jim@synthworks.com
--  Contributor(s):
--     Jim Lewis      jim@synthworks.com
--
--
--  Description:
--    The Stream Model Independent Transaction package (StreamTransactionTransactionPkg.vhd) 
--    defines a record for communication and transaction initiation procedures 
--    that are suitable for Stream Interfaces.   
--
--
--  Developed by:
--        SynthWorks Design Inc.
--        VHDL Training Classes
--        http://www.SynthWorks.com
--
--  Revision History:
--    Date      Version    Description
--    01/2022   2022.01    Burst patterns - Burst, BurstInc, BurstRandom
--    06/2021   2021.06    Updated bursting 
--    10/2020   2020.10    Added bursting to stream transactions
--    09/2020   2020.09    Updating comments to serve as documentation
--    07/2020   2020.07    Updated
--    01/2020   2020.01    Updated license notice
--    07/2019   2019.07    Refactored from UartTbPkg and AxiStreamTransactionPkg
--
--
--  This file is part of OSVVM.
--  
--  Copyright (c) 2019 - 2021 by SynthWorks Design Inc.  
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

  use std.textio.all ;

library osvvm ; 
  context osvvm.OsvvmContext ;  
  use osvvm.ScoreboardPkg_slv.all ; 
  
  use work.FifoFillPkg_slv.all ; 

package StreamTransactionPkg is 

  -- ========================================================
  --  StreamOperationType 
  --  Enumeration type used to communication transaction type
  --  to the model via the transaction interface
  -- ========================================================
  type StreamUnresolvedOperationType is (
    -- Default. Used for Multiple Driver Detection
    NOT_DRIVEN,  
    -- Directives
    WAIT_FOR_CLOCK, 
    WAIT_FOR_TRANSACTION,
    GET_TRANSACTION_COUNT,
    GET_ALERTLOG_ID,
    -- Burst FIFO Configuration
    SET_BURST_MODE,
    GET_BURST_MODE,
    -- Check to see if Read Burst is available
    GOT_BURST, 
    -- Model Options
    SET_MODEL_OPTIONS,
    GET_MODEL_OPTIONS,
    --  Transmitter
    SEND, 
    SEND_ASYNC,
    SEND_BURST,
    SEND_BURST_ASYNC,
    -- Receiver
    GET,             
    TRY_GET,
    GET_BURST,
    TRY_GET_BURST,
    CHECK,
    TRY_CHECK,
    CHECK_BURST,
    TRY_CHECK_BURST,
    MULTIPLE_DRIVER_DETECT  -- value used when multiple drivers are present
  ) ;
  type StreamUnresolvedOperationVectorType is array (natural range <>) of StreamUnresolvedOperationType ;
  -- Maximum is implicitly defined for any array type in VHDL-2008.   
  -- alias resolved_max is maximum[ StreamUnresolvedOperationVectorType return StreamUnresolvedOperationType] ;
  -- Function resolved_max is a fall back.
  function resolved_max ( s : StreamUnresolvedOperationVectorType) return StreamUnresolvedOperationType ;
  subtype StreamOperationType is resolved_max StreamUnresolvedOperationType ;

  -- ========================================================
  --  Stream Transaction Interface (StreamRecType) 
  --  The Stream Transaction Interface (StreamRecType) defines the 
  --  transaction interface between the test sequencer and the 
  --  verification component.   As such, it is the primary channel for 
  --  information exchange between the two.   It is defined as follows.
  --
  --  The record element types, bit_max, std_logic_vector_max_c, 
  --  integer_max, time_max, and boolean_max, are defined in the
  --  OSVVM package ResolutionPkg.  These types allow the record to 
  --  support multiple drivers and use resolution functions based on 
  --  function maximum (return largest value). 
  -- ========================================================
  type StreamRecType is record
    -- Handshaking controls
    --   Used by RequestTransaction in the Transaction Procedures
    --   Used by WaitForTransaction in the Verification Component
    --   RequestTransaction and WaitForTransaction are in osvvm.TbUtilPkg
    Rdy             : RdyType ;
    Ack             : AckType ;
    -- Transaction Type
    Operation       : StreamOperationType ;
    -- Data and Transaction Parameter to and from verification component 
    DataToModel     : std_logic_vector_max_c ; 
    ParamToModel    : std_logic_vector_max_c ; 
    DataFromModel   : std_logic_vector_max_c ; 
    ParamFromModel  : std_logic_vector_max_c ; 
    -- BurstFifo
    BurstFifo       : ScoreboardIdType ; 
    -- Verification Component Options Parameters - used by SetModelOptions
    IntToModel      : integer_max ;
    IntFromModel    : integer_max ; 
    BoolToModel     : boolean_max ; 
    BoolFromModel   : boolean_max ;
    TimeToModel     : time_max ; 
    TimeFromModel   : time_max ; 
    -- Verification Component Options Type 
    Options         : integer_max ; 
  end record StreamRecType ; 


  -- --------------------------------------------------------
  -- Usage of the Transaction Interface (StreamRecType)
  -- The Data and Parameter fields of StreamRecType are unconstrained.
  -- Unconstrained objects may be used on component/entity interfaces.    
  -- The record fields will be sized by the record signal that is mapped
  -- as the actual in the test harness of the testbench.  
  -- Such a declaration is shown below:
  --
  --   signal StreamTxRec, StreamRxRec : StreamRecType(
  --         DataToModel   (AXI_DATA_WIDTH-1  downto 0),
  --         ParamToModel  (AXI_PARAM_WIDTH-1 downto 0),
  --         DataFromModel (AXI_DATA_WIDTH-1  downto 0),
  --         ParamFromModel(AXI_PARAM_WIDTH-1 downto 0)
  --       ) ; 
  --
  -- --------------------------------------------------------
  

--!TODO add VHDL-2019 Interfaces


  -- ========================================================
  --  Types of Transactions
  --  A transaction may be either a directive or an interface transaction.
  --
  --  Directive transactions interact with the verification component 
  --  without generating any transactions or interface waveforms.
  --
  --  An interface transaction results in interface signaling to the DUT.
  --  An interface transaction may be either blocking (such as Send or Get)
  --  or non-blocking (such as SendAsync or TryGet).
  --
  --  A blocking transaction is an interface transaction that does not 
  --  does not return (complete) until the interface operation   
  --  requested by the transaction has completed.
  --
  --  An asynchronous transaction is nonblocking interface transaction
  --  that returns before the transaction has completed - typically 
  --  immediately and before the transaction has started.   
  --  An asynchronous transaction has "Async" as part of its name.
  --
  --  A Try transaction is nonblocking interface transaction that 
  --  checks to see if transaction information is available, 
  --  such as read data, and if it is returns it.  
  --  A Try transaction has "Try" as part of its name.
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
  --  Wait until pending (transmit) or next (receive) transaction(s) complete
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType 
  ) ; 

  ------------------------------------------------------------
  procedure WaitForClock (
  -- Wait for NumberOfClocks number of clocks 
  -- relative to the verification component clock
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  WaitCycles      : in    natural := 1
  ) ; 
  
 alias NoOp is WaitForClock [StreamRecType, natural] ;

  ------------------------------------------------------------
  procedure GetTransactionCount (
  -- Get the number of transactions handled by the model.  
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecType ;
    variable  TransactionCount : out   integer 
  ) ; 

  ------------------------------------------------------------
  procedure GetAlertLogID (
  -- Get the AlertLogID from the verification component.
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    variable  AlertLogID      : out   AlertLogIDType 
  ) ; 
  
  ------------------------------------------------------------
  procedure GetErrorCount (
  -- Error reporting for testbenches that do not use OSVVM AlertLogPkg
  -- Returns error count.  If an error count /= 0, also print errors
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    variable  ErrorCount      : out   natural
  ) ; 
  
  -- ========================================================
  -- BurstFIFOs and Burst Mode Controls
  -- The burst FIFOs hold bursts of data that is to be sent to 
  -- or was received from the interface.   The burst FIFO can be 
  -- configured in the modes defined for StreamFifoBurstModeType.
  -- Currently these modes defined as a subtype of integer, shown below.
  -- The intention of using integers is to facilitate model specific 
  -- extensions without the need to define separate transactions.
  -- ========================================================
  subtype StreamFifoBurstModeType is integer ;
  
  -- Word mode indicates the burst FIFO contains interface words.
  -- The size of the word may either be interface specific (such as 
  -- a UART which supports up to 8 bits) or be interface instance specific 
  -- (such as AxiStream which supports interfaces sizes of 1, 2, 4, 8, 
  -- 16, ... bytes)
  constant STREAM_BURST_WORD_MODE       : StreamFifoBurstModeType  := 0 ;
  
  -- Word + Param mode indicates the burst FIFO contains interface 
  -- words plus a parameter.   The size of the parameter is also either
  -- interface specific (such as the OSVVM UART, which uses 3 bits - 
  -- one bit for each of parity, stop, and break error injection) or
  -- interface instance specific (such as AxiStream which uses the Param
  -- field to hold TUser).  AxiStream TUser may be different size for
  -- different applications.
  constant STREAM_BURST_WORD_PARAM_MODE : StreamFifoBurstModeType  := 1 ;
  
  -- Byte mode is experimental and may be removed in a future revision.
  -- Byte mode indicates that the burst FIFO contains bytes.  
  -- The verification component assembles interface words from the bytes.
  -- This allows transfers to be conceptualized in an interface independent 
  --manner.    
  constant STREAM_BURST_BYTE_MODE       : StreamFifoBurstModeType  := 2 ; 
    
  ------------------------------------------------------------
  --  SetBurstMode and GetBurstMode
  --  are directive transactions that configure the burst mode 
  --  into one of the modes defined for StreamFifoBurstModeType
  ------------------------------------------------------------
  ------------------------------------------------------------
  procedure SetBurstMode (
  ------------------------------------------------------------
    signal   TransactionRec  : InOut StreamRecType ;
    constant OptVal          : In    StreamFifoBurstModeType
  ) ;

  ------------------------------------------------------------
  procedure GetBurstMode (
  ------------------------------------------------------------
    signal   TransactionRec  : InOut StreamRecType ;
    variable OptVal          : Out   StreamFifoBurstModeType
  ) ;

  ------------------------------------------------------------
  --  GotBurst   
  --  Check to see if Read Burst is available
  --  Primarily used internally
  ------------------------------------------------------------
  ------------------------------------------------------------
  procedure GotBurst (
  ------------------------------------------------------------
    signal   TransactionRec    : InOut StreamRecType ;
    constant NumFifoWords      : In    integer ;
    variable Available         : Out   boolean
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
    signal   TransactionRec  : InOut StreamRecType ;
    constant Option          : In    integer ;
    constant OptVal          : In    boolean
  ) ;

  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec  : InOut StreamRecType ;
    constant Option          : In    integer ;
    constant OptVal          : In    integer
  ) ;

  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec  : InOut StreamRecType ;
    constant Option          : In    integer ;
    constant OptVal          : In    std_logic_vector
  ) ;
  
  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec  : InOut StreamRecType ;
    constant Option          : In    integer ;
    constant OptVal          : In    time
  ) ;
  
  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec  : InOut StreamRecType ;
    constant Option          : In    integer 
  ) ;
  
  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec  : InOut StreamRecType ;
    constant Option          : In    integer ;
    variable OptVal          : Out   boolean
  ) ;

  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec  : InOut StreamRecType ;
    constant Option          : In    integer ;
    variable OptVal          : Out   integer
  ) ;

  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec  : InOut StreamRecType ;
    constant Option          : In    integer ;
    variable OptVal          : Out   std_logic_vector
  ) ;
  
  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec  : InOut StreamRecType ;
    constant Option          : In    integer ;
    variable OptVal          : Out   time
  ) ;
  
  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec  : InOut StreamRecType ;
    constant Option          : In    integer 
  ) ;


  -- ========================================================
  --  Transmitter Transactions
  -- ========================================================

  -- ========================================================
  -- Send
  -- Blocking Send Transaction. 
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for error injection.
  -- ========================================================
  
  ------------------------------------------------------------
  procedure Send (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  Param           : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 

  ------------------------------------------------------------
  procedure Send (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 
  

  -- ========================================================
  -- SendAsync
  -- Asynchronous / Non-Blocking Send Transaction
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for error injection. 
  -- ========================================================

  ------------------------------------------------------------
  procedure SendAsync (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  Param           : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 

  ------------------------------------------------------------
  procedure SendAsync (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 


  -- ========================================================
  -- SendBurst
  -- Blocking Send Burst Transaction. 
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for error injection.
  -- ========================================================

  ------------------------------------------------------------
  procedure SendBurst (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  NumFifoWords    : In    integer ;
    constant  Param           : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 

  ------------------------------------------------------------
  procedure SendBurst (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  NumFifoWords    : In    integer ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 
  
  ------------------------------------------------------------
  procedure SendBurstVector (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant VectorOfWords  : In    slv_vector ;
    constant Param          : In    std_logic_vector ;
    constant StatusMsgOn    : In    boolean := false
  ) ;
  
  ------------------------------------------------------------
  procedure SendBurstVector (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant VectorOfWords  : In    slv_vector ;
    constant StatusMsgOn    : In    boolean := false
  ) ;
  
--  alias SendBurst is SendBurstVector[StreamRecType, slv_vector, std_logic_vector, boolean] ; 
--  alias SendBurst is SendBurstVector[StreamRecType, slv_vector, boolean] ; 

  ------------------------------------------------------------
  procedure SendBurstIncrement (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant FirstWord      : In    std_logic_vector ;
    constant NumFifoWords   : In    integer ;
    constant Param          : In    std_logic_vector ;
    constant StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure SendBurstIncrement (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant FirstWord      : In    std_logic_vector ;
    constant NumFifoWords   : In    integer ;
    constant StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure SendBurstRandom (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant FirstWord      : In    std_logic_vector ;
    constant NumFifoWords   : In    integer ;
    constant Param          : In    std_logic_vector ;
    constant StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure SendBurstRandom (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant FirstWord      : In    std_logic_vector ;
    constant NumFifoWords   : In    integer ;
    constant StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure SendBurstRandom (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant CoverID        : In    CoverageIDType ;
    constant NumFifoWords   : In    integer ;
    constant FifoWidth      : In    integer ;
    constant Param          : In    std_logic_vector ;
    constant StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure SendBurstRandom (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant CoverID        : In    CoverageIDType ;
    constant NumFifoWords   : In    integer ;
    constant FifoWidth      : In    integer ;
    constant StatusMsgOn    : In    boolean := false
  ) ;

  -- ========================================================
  -- SendBurstAsync
  -- Asynchronous / Non-Blocking Send Transaction
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for error injection. 
  -- ========================================================

  ------------------------------------------------------------
  procedure SendBurstAsync (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  NumFifoWords    : In    integer ;
    constant  Param           : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 

  ------------------------------------------------------------
  procedure SendBurstAsync (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  NumFifoWords    : In    integer ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 
  
  ------------------------------------------------------------
  procedure SendBurstVectorAsync (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant VectorOfWords  : In    slv_vector ;
    constant Param          : In    std_logic_vector ;
    constant StatusMsgOn    : In    boolean := false
  ) ;
  
  ------------------------------------------------------------
  procedure SendBurstVectorAsync (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant VectorOfWords  : In    slv_vector ;
    constant StatusMsgOn    : In    boolean := false
  ) ;
  
--  alias SendBurstAsync is SendBurstVectorAsync[StreamRecType, slv_vector, std_logic_vector, boolean] ; 
--  alias SendBurstAsync is SendBurstVectorAsync[StreamRecType, slv_vector, boolean] ; 

  ------------------------------------------------------------
  procedure SendBurstIncrementAsync (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant FirstWord      : In    std_logic_vector ;
    constant NumFifoWords   : In    integer ;
    constant Param          : In    std_logic_vector ;
    constant StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure SendBurstIncrementAsync (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant FirstWord      : In    std_logic_vector ;
    constant NumFifoWords   : In    integer ;
    constant StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure SendBurstRandomAsync (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant FirstWord      : In    std_logic_vector ;
    constant NumFifoWords   : In    integer ;
    constant Param          : In    std_logic_vector ;
    constant StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure SendBurstRandomAsync (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant FirstWord      : In    std_logic_vector ;
    constant NumFifoWords   : In    integer ;
    constant StatusMsgOn    : In    boolean := false
  ) ;
  
  ------------------------------------------------------------
  procedure SendBurstRandomAsync (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant CoverID        : In    CoverageIDType ;
    constant NumFifoWords   : In    integer ;
    constant FifoWidth      : In    integer ;
    constant Param          : In    std_logic_vector ;
    constant StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure SendBurstRandomAsync (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant CoverID        : In    CoverageIDType ;
    constant NumFifoWords   : In    integer ;
    constant FifoWidth      : In    integer ;
    constant StatusMsgOn    : In    boolean := false
  ) ;

  -- ========================================================
  --  Receiver Transactions
  -- ========================================================

  -- ========================================================
  -- Get
  -- Blocking Get Transaction. 
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for received error status.
  -- ========================================================

  ------------------------------------------------------------
  procedure Get (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    variable  Data            : out   std_logic_vector ;
    variable  Param           : out   std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 

  ------------------------------------------------------------
  procedure Get (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    variable  Data            : out   std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 


  -- ========================================================
  -- TryGet
  -- Try Get Transaction
  -- If Data is available, get it and return available TRUE,
  -- otherwise Return Available FALSE.
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for received error status.
  -- ========================================================

  ------------------------------------------------------------
  procedure TryGet (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    variable  Data            : out   std_logic_vector ;
    variable  Available       : out   boolean ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 
  
  ------------------------------------------------------------
  procedure TryGet (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    variable  Data            : out   std_logic_vector ;
    variable  Param           : out   std_logic_vector ;
    variable  Available       : out   boolean ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ;  


  -- ========================================================
  -- GetBurst
  -- Blocking Get Burst Transaction. 
  -- Param, when present, is an extra parameter from the verification component
  -- The UART verification component uses Param for received error status.
  -- ========================================================

  ------------------------------------------------------------
  procedure GetBurst (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    variable  NumFifoWords    : inout integer ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 
  
  ------------------------------------------------------------
  procedure GetBurst (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    variable  NumFifoWords    : inout integer ;
    variable  Param           : out   std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ;  

  -- ========================================================
  -- TryGetBurst
  -- Try Get Burst Transaction
  -- If Data is available, get it and return available TRUE,
  -- otherwise Return Available FALSE.
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for received error status.
  -- ========================================================

  ------------------------------------------------------------
  procedure TryGetBurst (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    variable  NumFifoWords    : inout integer ;
    variable  Available       : out   boolean ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 
  
  ------------------------------------------------------------
  procedure TryGetBurst (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    variable  NumFifoWords    : inout integer ;
    variable  Param           : out   std_logic_vector ;
    variable  Available       : out   boolean ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ;  


  -- ========================================================
  -- Check
  -- Blocking Check Transaction. 
  -- Data is the expected value to be received.
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for received error status.
  -- ========================================================

  ------------------------------------------------------------
  procedure Check (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  Param           : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 

  ------------------------------------------------------------
  procedure Check (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 


  -- ========================================================
  -- TryCheck
  -- Try Check Transaction
  -- If Data is available, check it and return available TRUE,
  -- otherwise Return Available FALSE.
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for received error status.
  -- ========================================================

  ------------------------------------------------------------
  procedure TryCheck (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  Param           : in    std_logic_vector ;
    variable  Available       : out   boolean ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 

  ------------------------------------------------------------
  procedure TryCheck (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    variable  Available       : out   boolean ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 

  -- ========================================================
  -- CheckBurst
  -- Blocking Check Burst Transaction. 
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for checking error injection.
  -- ========================================================
  ------------------------------------------------------------
  procedure CheckBurst (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  NumFifoWords    : In    integer ;
    constant  Param           : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 

  ------------------------------------------------------------
  procedure CheckBurst (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  NumFifoWords    : In    integer ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 

  ------------------------------------------------------------
  procedure CheckBurstVector (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant VectorOfWords  : In    slv_vector ;
    constant Param          : In    std_logic_vector ;
    constant StatusMsgOn    : In    boolean := false
  ) ;
  
  ------------------------------------------------------------
  procedure CheckBurstVector (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant VectorOfWords  : In    slv_vector ;
    constant StatusMsgOn    : In    boolean := false
  ) ;
  
--  alias CheckBurst is CheckBurstVector[StreamRecType, slv_vector, std_logic_vector, boolean] ; 
--  alias CheckBurst is CheckBurstVector[StreamRecType, slv_vector, boolean] ; 

  ------------------------------------------------------------
  procedure CheckBurstIncrement (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant FirstWord      : In    std_logic_vector ;
    constant NumFifoWords   : In    integer ;
    constant Param          : In    std_logic_vector ;
    constant StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure CheckBurstIncrement (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant FirstWord      : In    std_logic_vector ;
    constant NumFifoWords   : In    integer ;
    constant StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure CheckBurstRandom (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant FirstWord      : In    std_logic_vector ;
    constant NumFifoWords   : In    integer ;
    constant Param          : In    std_logic_vector ;
    constant StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure CheckBurstRandom (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant FirstWord      : In    std_logic_vector ;
    constant NumFifoWords   : In    integer ;
    constant StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure CheckBurstRandom (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant CoverID        : In    CoverageIDType ;
    constant NumFifoWords   : In    integer ;
    constant FifoWidth      : In    integer ;
    constant Param          : In    std_logic_vector ;
    constant StatusMsgOn    : In    boolean := false
  ) ;  

  ------------------------------------------------------------
  procedure CheckBurstRandom (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant CoverID        : In    CoverageIDType ;
    constant NumFifoWords   : In    integer ;
    constant FifoWidth      : In    integer ;
    constant StatusMsgOn    : In    boolean := false
  ) ;  

  -- ========================================================
  -- TryCheckBurst
  -- Try / Non-Blocking Check Burst Transaction
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for error injection. 
  -- ========================================================

  ------------------------------------------------------------
  procedure TryCheckBurst (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  NumFifoWords    : In    integer ;
    constant  Param           : in    std_logic_vector ;
    variable  Available       : out   boolean ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 
  
  ------------------------------------------------------------
  procedure TryCheckBurst (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  NumFifoWords    : In    integer ;
    variable  Available       : out   boolean ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 
  
  ------------------------------------------------------------
  procedure TryCheckBurstVector (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant VectorOfWords  : In    slv_vector ;
    constant Param          : In    std_logic_vector ;
    variable Available      : Out   boolean ;
    constant StatusMsgOn    : In    boolean := false
  )  ;
  
  ------------------------------------------------------------
  procedure TryCheckBurstVector (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant VectorOfWords  : In    slv_vector ;
    variable Available      : Out   boolean ;
    constant StatusMsgOn    : In    boolean := false
  ) ;

--  alias TryCheckBurst is TryCheckBurstVector[StreamRecType, slv_vector, std_logic_vector, boolean, boolean] ; 
--  alias TryCheckBurst is TryCheckBurstVector[StreamRecType, slv_vector, boolean, boolean] ; 
  
  ------------------------------------------------------------
  procedure TryCheckBurstIncrement (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant FirstWord      : In    std_logic_vector ;
    constant NumFifoWords   : In    integer ;
    constant Param          : In    std_logic_vector ;
    variable Available      : Out   boolean ;
    constant StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure TryCheckBurstIncrement (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant FirstWord      : In    std_logic_vector ;
    constant NumFifoWords   : In    integer ;
    variable Available      : Out   boolean ;
    constant StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure TryCheckBurstRandom (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant FirstWord      : In    std_logic_vector ;
    constant NumFifoWords   : In    integer ;
    constant Param          : In    std_logic_vector ;
    variable Available      : Out   boolean ;
    constant StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure TryCheckBurstRandom (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant FirstWord      : In    std_logic_vector ;
    constant NumFifoWords   : In    integer ;
    variable Available      : Out   boolean ;
    constant StatusMsgOn    : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure TryCheckBurstRandom (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant CoverID        : In    CoverageIDType ;
    constant NumFifoWords   : In    integer ;
    constant FifoWidth      : In    integer ;
    constant Param          : In    std_logic_vector ;
    variable Available      : Out   boolean ;
    constant StatusMsgOn    : In    boolean := false
  ) ;  

  ------------------------------------------------------------
  procedure TryCheckBurstRandom (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant CoverID        : In    CoverageIDType ;
    constant NumFifoWords   : In    integer ;
    constant FifoWidth      : In    integer ;
    variable Available      : Out   boolean ;
    constant StatusMsgOn    : In    boolean := false
  ) ;  


  -- ========================================================
  --  Pseudo Transactions
  --  Interact with the record only.
  -- ========================================================
  ------------------------------------------------------------
  procedure ReleaseTransactionRecord (
  --  Must run on same delta cycle as AcquireTransactionRecord
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType 
  ) ; 
  
  ------------------------------------------------------------
  procedure AcquireTransactionRecord (
  --  Must run on same delta cycle as ReleaseTransactionRecord
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType 
  ) ; 

  -- ========================================================
  --  Verification Component Support Functions
  --  These help decode the operation value (StreamOperationType)  
  --  to determine properties about the operation
  -- ========================================================
  ------------------------------------------------------------
  function IsBlocking (
  -----------------------------------------------------------
    constant Operation     : in StreamOperationType
  ) return boolean ;
  
  ------------------------------------------------------------
  function IsTry (
  -- True when this transaction is an asynchronous or try transaction.
  -----------------------------------------------------------
    constant Operation     : in StreamOperationType
  ) return boolean ;

  ------------------------------------------------------------
  function IsCheck (
  -- True when this transaction is a check transaction.
  -----------------------------------------------------------
    constant Operation     : in StreamOperationType
  ) return boolean ;

end StreamTransactionPkg ;

package body StreamTransactionPkg is 

  ------------------------------------------------------------
  function resolved_max ( s : StreamUnresolvedOperationVectorType) return StreamUnresolvedOperationType is
  ------------------------------------------------------------
    variable Result : StreamUnresolvedOperationType := NOT_DRIVEN ;
  begin
    for i in s'range loop 
      if s(i) /= NOT_DRIVEN then 
        if result = NOT_DRIVEN then 
          result := s(i) ;
        else
          result := MULTIPLE_DRIVER_DETECT ;
        end if ; 
      end if ; 
    end loop ;
    return result ; 
--    return maximum(s) ;
  end function resolved_max ; 
  
--    ------------------------------------------------------------
--    function FillParam (TransactionRec : StreamRecType; Param : std_logic_vector) return std_logic_vector is
--    ------------------------------------------------------------
--      variable LocalParam : std_logic_vector(TransactionRec.ParamToModel'range) := (others => '-') ;
--    begin
--      LocalParam(Param'length-1 downto 0) := Param ; 
--      return Param ;
--    end function FillParam ; 

  -- ========================================================
  --  Directive Transactions  
  --  Directive transactions interact with the verification component 
  --  without generating any transactions or interface waveforms.
  --  Supported by all verification components
  -- ========================================================
  ------------------------------------------------------------
  procedure WaitForTransaction (
  --  Wait until pending (transmit) or next (receive) transaction(s) complete
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType 
  ) is
  begin
    TransactionRec.Operation   <= WAIT_FOR_TRANSACTION ;
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ; 
  end procedure WaitForTransaction ; 

  ------------------------------------------------------------
  procedure WaitForClock (
  -- Wait for NumberOfClocks number of clocks 
  -- relative to the verification component clock
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  WaitCycles      : in    natural := 1
  ) is
  begin
    TransactionRec.Operation   <= WAIT_FOR_CLOCK ;
    TransactionRec.IntToModel  <= WaitCycles ; 
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ; 
  end procedure WaitForClock ; 

  ------------------------------------------------------------
  procedure GetTransactionCount (
  -- Get the number of transactions handled by the model.  
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecType ;
    variable  TransactionCount : out   integer 
  ) is
  begin
    TransactionRec.Operation   <= GET_TRANSACTION_COUNT ;
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ; 
    TransactionCount := TransactionRec.IntFromModel ; 
  end procedure GetTransactionCount ; 

  ------------------------------------------------------------
  procedure GetAlertLogID (
  -- Get the AlertLogID from the verification component.
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    variable  AlertLogID      : out   AlertLogIDType 
  ) is
  begin
    TransactionRec.Operation   <= GET_ALERTLOG_ID ;
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ; 
    AlertLogID := AlertLogIDType(TransactionRec.IntFromModel) ; 
  end procedure GetAlertLogID ; 
  
  ------------------------------------------------------------
  procedure GetErrorCount (
  -- Error reporting for testbenches that do not use OSVVM AlertLogPkg
  -- Returns error count.  If an error count /= 0, also print errors
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    variable  ErrorCount      : out   natural
  ) is
    variable  AlertLogID : AlertLogIDType ;
  begin
    GetAlertLogID(TransactionRec, AlertLogID) ;
--    ReportNonZeroAlerts(AlertLogID => AlertLogID) ;
    ErrorCount := GetAlertCount(AlertLogID => AlertLogID) ;
  end procedure GetErrorCount ; 
  
  
  -- ========================================================
  --  Set and Get Burst Mode   
  --  Set Burst Mode for models that do bursting.
  -- ========================================================
  ------------------------------------------------------------
  procedure SetBurstMode (
  ------------------------------------------------------------
    signal   TransactionRec    : InOut StreamRecType ;
    constant OptVal            : In    StreamFifoBurstModeType
  ) is
  begin
    TransactionRec.Operation     <= SET_BURST_MODE ;
    TransactionRec.IntToModel    <= OptVal ;
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ;
  end procedure SetBurstMode ;

  ------------------------------------------------------------
  procedure GetBurstMode (
  ------------------------------------------------------------
    signal   TransactionRec    : InOut StreamRecType ;
    variable OptVal            : Out   StreamFifoBurstModeType
  ) is
  begin
    TransactionRec.Operation     <= GET_BURST_MODE ;
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ;
    OptVal := TransactionRec.IntFromModel ; 
  end procedure GetBurstMode ;

  ------------------------------------------------------------
  --  GotBurst   
  -- Check to see if Read Burst is available
  ------------------------------------------------------------
  ------------------------------------------------------------
  procedure GotBurst (
  ------------------------------------------------------------
    signal   TransactionRec    : InOut StreamRecType ;
    constant NumFifoWords      : In    integer ;
    variable Available         : Out   boolean
  ) is
  begin
    TransactionRec.Operation   <= GOT_BURST ;
    -- NumFifoWords not used in all implementations - needed when interface has no burst capability
    TransactionRec.IntToModel  <= NumFifoWords ; 
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ;
    Available := TransactionRec.BoolFromModel ; 
  end procedure GotBurst ;

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
    signal   TransactionRec  : InOut StreamRecType ;
    constant Option          : In    integer ;
    constant OptVal          : In    boolean
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
    signal   TransactionRec  : InOut StreamRecType ;
    constant Option          : In    integer ;
    constant OptVal          : In    integer
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
    signal   TransactionRec  : InOut StreamRecType ;
    constant Option          : In    integer ;
    constant OptVal          : In    std_logic_vector
  ) is
  begin
    TransactionRec.Operation     <= SET_MODEL_OPTIONS ;
    TransactionRec.Options       <= Option ;
    TransactionRec.IntToModel    <= to_integer(OptVal) ;
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ;
  end procedure SetModelOptions ;
  
  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec  : InOut StreamRecType ;
    constant Option          : In    integer ;
    constant OptVal          : In    time
  ) is
  begin
    TransactionRec.Operation     <= SET_MODEL_OPTIONS ;
    TransactionRec.Options       <= Option ;
    TransactionRec.TimeToModel   <= OptVal ;
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ;
  end procedure SetModelOptions ;

  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec  : InOut StreamRecType ;
    constant Option          : In    integer 
  ) is
  begin
    TransactionRec.Operation     <= SET_MODEL_OPTIONS ;
    TransactionRec.Options       <= Option ;
    -- OptVal handled by Model Specific Package
    -- TransactionRec.IntToModel    <= to_integer(OptVal) ;
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ;
  end procedure SetModelOptions ;

  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec  : InOut StreamRecType ;
    constant Option          : In    integer ;
    variable OptVal          : Out   boolean
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
    signal   TransactionRec  : InOut StreamRecType ;
    constant Option          : In    integer ;
    variable OptVal          : Out   integer
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
    signal   TransactionRec  : InOut StreamRecType ;
    constant Option          : In    integer ;
    variable OptVal          : Out   std_logic_vector
  ) is
  begin
    TransactionRec.Operation     <= GET_MODEL_OPTIONS ;
    TransactionRec.Options       <= Option ;
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ;
    OptVal := to_slv(TransactionRec.IntFromModel, OptVal'length) ; 
  end procedure GetModelOptions ;
  
  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec  : InOut StreamRecType ;
    constant Option          : In    integer ;
    variable OptVal          : Out   time
  ) is
  begin
    TransactionRec.Operation     <= GET_MODEL_OPTIONS ;
    TransactionRec.Options       <= Option ;
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ;
    OptVal := TransactionRec.TimeFromModel ; 
  end procedure GetModelOptions ;

  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal   TransactionRec  : InOut StreamRecType ;
    constant Option          : In    integer 
  ) is
  begin
    TransactionRec.Operation     <= GET_MODEL_OPTIONS ;
    TransactionRec.Options       <= Option ;
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ;
    -- OptVal handled by Model Specific layer overloading
    -- OptVal := TransactionRec.TimeFromModel ; 
  end procedure GetModelOptions ;


  -- ========================================================
  --  Transmitter Transactions
  -- ========================================================
  
  -- ========================================================
  -- Send
  -- Blocking Send Transaction. 
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for error injection.
  -- ========================================================
  ------------------------------------------------------------
  procedure LocalSend (
  -- Package Local - simplifies the other calls to Send
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Operation       : in    StreamOperationType ;
    constant  Data            : in    std_logic_vector ;
    constant  Param           : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
    variable LocalParam : std_logic_vector(TransactionRec.ParamToModel'length -1 downto 0) := (others => '-') ;
  begin
    LocalParam(Param'length-1 downto 0) := Param ; 
    TransactionRec.Operation     <= Operation ;
    TransactionRec.DataToModel   <= SafeResize(Data, TransactionRec.DataToModel'length) ; 
    TransactionRec.ParamToModel  <= SafeResize(LocalParam, TransactionRec.ParamToModel'length) ; 
    TransactionRec.IntToModel    <= Data'length ;
    TransactionRec.BoolToModel   <= StatusMsgOn ; 
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ; 
  end procedure LocalSend ; 

  ------------------------------------------------------------
  procedure Send (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  Param           : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
  begin
    LocalSend(TransactionRec, SEND, Data, Param, StatusMsgOn) ;
  end procedure Send ; 

  ------------------------------------------------------------
  procedure Send (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
  begin
    LocalSend(TransactionRec, SEND, Data, "", StatusMsgOn);
  end procedure Send ; 

  -- ========================================================
  -- SendAsync
  -- Asynchronous / Non-Blocking Send Transaction
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for error injection. 
  -- ========================================================

  ------------------------------------------------------------
  procedure SendAsync (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  Param           : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
  begin
    LocalSend(TransactionRec, SEND_ASYNC, Data, Param, StatusMsgOn) ;
  end procedure SendAsync ; 

  ------------------------------------------------------------
  procedure SendAsync (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
  begin
    LocalSend(TransactionRec, SEND_ASYNC, Data, "", StatusMsgOn);
  end procedure SendAsync ; 


  -- ========================================================
  -- SendBurst
  -- Blocking Send Burst Transaction. 
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for error injection.
  -- ========================================================
  ------------------------------------------------------------
  procedure LocalSendBurst (
  -- Package Local - simplifies the other calls to Send
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Operation       : in    StreamOperationType ;
    constant  NumFifoWords    : In    integer ;
    constant  Param           : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
    variable LocalParam : std_logic_vector(TransactionRec.ParamToModel'length -1 downto 0) := (others => '-') ;
  begin
    LocalParam(Param'length-1 downto 0) := Param ; 
    TransactionRec.Operation     <= Operation ;
    TransactionRec.IntToModel    <= NumFifoWords ; 
    TransactionRec.ParamToModel  <= SafeResize(LocalParam, TransactionRec.ParamToModel'length) ; 
    TransactionRec.BoolToModel   <= StatusMsgOn ; 
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ; 
  end procedure LocalSendBurst ; 

  ------------------------------------------------------------
  procedure SendBurst (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  NumFifoWords    : In    integer ;
    constant  Param           : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
  begin
    LocalSendBurst(TransactionRec, SEND_BURST, NumFifoWords, Param, StatusMsgOn) ;
  end procedure SendBurst ; 

  ------------------------------------------------------------
  procedure SendBurst (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  NumFifoWords    : In    integer ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
  begin
    LocalSendBurst(TransactionRec, SEND_BURST, NumFifoWords, "", StatusMsgOn) ;
  end procedure SendBurst ; 

  ------------------------------------------------------------
  procedure SendBurstVector (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant VectorOfWords  : In    slv_vector ;
    constant Param          : In    std_logic_vector ;
    constant StatusMsgOn    : In    boolean := false
  ) is
  begin
    PushBurstVector(TransactionRec.BurstFifo, VectorOfWords) ;
    LocalSendBurst(TransactionRec, SEND_BURST, VectorOfWords'length, Param, StatusMsgOn) ; 
  end procedure SendBurstVector ;
  
  ------------------------------------------------------------
  procedure SendBurstVector (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant VectorOfWords  : In    slv_vector ;
    constant StatusMsgOn    : In    boolean := false
  ) is
  begin
    SendBurstVector(TransactionRec, VectorOfWords, "", StatusMsgOn) ; 
  end procedure SendBurstVector ;
  
  ------------------------------------------------------------
  procedure SendBurstIncrement (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant FirstWord      : In    std_logic_vector ;
    constant NumFifoWords   : In    integer ;
    constant Param          : In    std_logic_vector ;
    constant StatusMsgOn    : In    boolean := false
  ) is
  begin
    PushBurstIncrement(TransactionRec.BurstFifo, FirstWord, NumFifoWords) ;
    LocalSendBurst(TransactionRec, SEND_BURST, NumFifoWords, Param, StatusMsgOn) ; 
  end procedure SendBurstIncrement ;
  
  ------------------------------------------------------------
  procedure SendBurstIncrement (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant FirstWord      : In    std_logic_vector ;
    constant NumFifoWords   : In    integer ;
    constant StatusMsgOn    : In    boolean := false
  ) is
  begin
    SendBurstIncrement(TransactionRec, FirstWord, NumFifoWords, "", StatusMsgOn) ; 
  end procedure SendBurstIncrement ;

  ------------------------------------------------------------
  procedure SendBurstRandom (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant FirstWord      : In    std_logic_vector ;
    constant NumFifoWords   : In    integer ;
    constant Param          : In    std_logic_vector ;
    constant StatusMsgOn    : In    boolean := false
  ) is
  begin
    PushBurstRandom(TransactionRec.BurstFifo, FirstWord, NumFifoWords) ;
    LocalSendBurst(TransactionRec, SEND_BURST, NumFifoWords, Param, StatusMsgOn) ; 
  end procedure SendBurstRandom ;
  
  ------------------------------------------------------------
  procedure SendBurstRandom (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant FirstWord      : In    std_logic_vector ;
    constant NumFifoWords   : In    integer ;
    constant StatusMsgOn    : In    boolean := false
  ) is
  begin
    SendBurstRandom(TransactionRec, FirstWord, NumFifoWords, "", StatusMsgOn) ; 
  end procedure SendBurstRandom ;

  ------------------------------------------------------------
  procedure SendBurstRandom (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant CoverID        : In    CoverageIDType ;
    constant NumFifoWords   : In    integer ;
    constant FifoWidth      : In    integer ;
    constant Param          : In    std_logic_vector ;
    constant StatusMsgOn    : In    boolean := false
  ) is
  begin
    PushBurstRandom(TransactionRec.BurstFifo, CoverID, NumFifoWords, FifoWidth) ;
    LocalSendBurst(TransactionRec, SEND_BURST, NumFifoWords, Param, StatusMsgOn) ; 
  end procedure SendBurstRandom ;  

  ------------------------------------------------------------
  procedure SendBurstRandom (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant CoverID        : In    CoverageIDType ;
    constant NumFifoWords   : In    integer ;
    constant FifoWidth      : In    integer ;
    constant StatusMsgOn    : In    boolean := false
  ) is
  begin
    SendBurstRandom(TransactionRec, CoverID, NumFifoWords, FifoWidth, "", StatusMsgOn) ; 
  end procedure SendBurstRandom ;  


  -- ========================================================
  -- SendBurstAsync
  -- Asynchronous / Non-Blocking Send Transaction
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for error injection. 
  -- ========================================================

  ------------------------------------------------------------
  procedure SendBurstAsync (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  NumFifoWords    : In    integer ;
    constant  Param           : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
  begin
    LocalSendBurst(TransactionRec, SEND_BURST_ASYNC, NumFifoWords, Param, StatusMsgOn) ;
  end procedure SendBurstAsync ; 

  ------------------------------------------------------------
  procedure SendBurstAsync (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  NumFifoWords    : In    integer ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
  begin
    LocalSendBurst(TransactionRec, SEND_BURST_ASYNC, NumFifoWords, "", StatusMsgOn) ;
  end procedure SendBurstAsync ; 

  ------------------------------------------------------------
  procedure SendBurstVectorAsync (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant VectorOfWords  : In    slv_vector ;
    constant Param          : In    std_logic_vector ;
    constant StatusMsgOn    : In    boolean := false
  ) is
  begin
    PushBurstVector(TransactionRec.BurstFifo, VectorOfWords) ;
    LocalSendBurst(TransactionRec, SEND_BURST_ASYNC, VectorOfWords'length, Param, StatusMsgOn) ; 
  end procedure SendBurstVectorAsync ;
  
  ------------------------------------------------------------
  procedure SendBurstVectorAsync (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant VectorOfWords  : In    slv_vector ;
    constant StatusMsgOn    : In    boolean := false
  ) is
  begin
    SendBurstVectorAsync(TransactionRec, VectorOfWords, "", StatusMsgOn) ; 
  end procedure SendBurstVectorAsync ;
  
  ------------------------------------------------------------
  procedure SendBurstIncrementAsync (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant FirstWord      : In    std_logic_vector ;
    constant NumFifoWords   : In    integer ;
    constant Param          : In    std_logic_vector ;
    constant StatusMsgOn    : In    boolean := false
  ) is
  begin
    PushBurstIncrement(TransactionRec.BurstFifo, FirstWord, NumFifoWords) ;
    LocalSendBurst(TransactionRec, SEND_BURST_ASYNC, NumFifoWords, Param, StatusMsgOn) ; 
  end procedure SendBurstIncrementAsync ;

  ------------------------------------------------------------
  procedure SendBurstIncrementAsync (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant FirstWord      : In    std_logic_vector ;
    constant NumFifoWords   : In    integer ;
    constant StatusMsgOn    : In    boolean := false
  ) is
  begin
    SendBurstIncrementAsync(TransactionRec, FirstWord, NumFifoWords, "", StatusMsgOn) ; 
  end procedure SendBurstIncrementAsync ;

  ------------------------------------------------------------
  procedure SendBurstRandomAsync (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant FirstWord      : In    std_logic_vector ;
    constant NumFifoWords   : In    integer ;
    constant Param          : In    std_logic_vector ;
    constant StatusMsgOn    : In    boolean := false
  ) is
  begin
    PushBurstRandom(TransactionRec.BurstFifo, FirstWord, NumFifoWords) ;
    LocalSendBurst(TransactionRec, SEND_BURST_ASYNC, NumFifoWords, Param, StatusMsgOn) ; 
  end procedure SendBurstRandomAsync ;

  ------------------------------------------------------------
  procedure SendBurstRandomAsync (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant FirstWord      : In    std_logic_vector ;
    constant NumFifoWords   : In    integer ;
    constant StatusMsgOn    : In    boolean := false
  ) is
    variable RV : RandomPType ; 
  begin
    SendBurstRandomAsync(TransactionRec, FirstWord, NumFifoWords, "", StatusMsgOn) ; 
  end procedure SendBurstRandomAsync ;

  ------------------------------------------------------------
  procedure SendBurstRandomAsync (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant CoverID        : In    CoverageIDType ;
    constant NumFifoWords   : In    integer ;
    constant FifoWidth      : In    integer ;
    constant Param          : In    std_logic_vector ;
    constant StatusMsgOn    : In    boolean := false
  ) is
  begin
    PushBurstRandom(TransactionRec.BurstFifo, CoverID, NumFifoWords, FifoWidth) ;
    LocalSendBurst(TransactionRec, SEND_BURST_ASYNC, NumFifoWords, Param, StatusMsgOn) ; 
  end procedure SendBurstRandomAsync ;  

  ------------------------------------------------------------
  procedure SendBurstRandomAsync (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant CoverID        : In    CoverageIDType ;
    constant NumFifoWords   : In    integer ;
    constant FifoWidth      : In    integer ;
    constant StatusMsgOn    : In    boolean := false
  ) is
  begin
    SendBurstRandomAsync(TransactionRec, CoverID, NumFifoWords, FifoWidth, "", StatusMsgOn) ; 
  end procedure SendBurstRandomAsync ;  


  -- ========================================================
  --  Receiver Transactions
  -- ========================================================

  -- ========================================================
  -- Get
  -- Blocking Get Transaction. 
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for received error status.
  -- ========================================================

  ------------------------------------------------------------
  procedure Get (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    variable  Data            : out   std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
  begin
    TransactionRec.Operation   <= GET ;
    TransactionRec.IntToModel  <= Data'length ;
    TransactionRec.BoolToModel <= StatusMsgOn ;     
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ; 
    Data  := SafeResize(TransactionRec.DataFromModel, Data'length) ; 
  end procedure Get ; 
  
  ------------------------------------------------------------
  procedure Get (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    variable  Data            : out   std_logic_vector ;
    variable  Param           : out   std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
  begin
    Get(TransactionRec, Data, StatusMsgOn) ;
    Param := SafeResize(TransactionRec.ParamFromModel, Param'length) ; 
  end procedure Get ;  

  -- ========================================================
  -- TryGet
  -- Try Get Transaction
  -- If Data is available, get it and return available TRUE,
  -- otherwise Return Available FALSE.
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for received error status.
  -- ========================================================

  ------------------------------------------------------------
  procedure TryGet (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    variable  Data            : out   std_logic_vector ;
    variable  Available       : out   boolean ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
  begin
    TransactionRec.Operation   <= TRY_GET ;
    TransactionRec.IntToModel  <= Data'length ;
    TransactionRec.BoolToModel <= StatusMsgOn ;     
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ; 
    Data      := SafeResize(TransactionRec.DataFromModel, Data'length) ; 
    Available := TransactionRec.BoolFromModel ;
  end procedure TryGet ; 
  
  ------------------------------------------------------------
  procedure TryGet (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    variable  Data            : out   std_logic_vector ;
    variable  Param           : out   std_logic_vector ;
    variable  Available       : out   boolean ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
  begin
    TryGet(TransactionRec, Data, Available, StatusMsgOn) ;
    Param := SafeResize(TransactionRec.ParamFromModel, Param'length) ; 
  end procedure TryGet ;  


  -- ========================================================
  -- GetBurst
  -- Blocking Get Burst Transaction. 
  -- Param, when present, is an extra parameter from the verification component
  -- The UART verification component uses Param for received error status.
  -- ========================================================

  ------------------------------------------------------------
  procedure LocalGetBurst (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  NumFifoWords    : in    integer ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
  begin
    TransactionRec.Operation   <= GET_BURST ;
    TransactionRec.IntToModel  <= NumFifoWords ;  -- For models without burst framing (like UART)
    TransactionRec.BoolToModel <= StatusMsgOn ;     
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ; 
  end procedure LocalGetBurst ; 
  
  ------------------------------------------------------------
  procedure GetBurst (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    variable  NumFifoWords    : inout integer ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
  begin
    LocalGetBurst(TransactionRec, NumFifoWords, StatusMsgOn) ; 
    NumFifoWords := TransactionRec.IntFromModel ;
  end procedure GetBurst ; 
  
  ------------------------------------------------------------
  procedure GetBurst (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    variable  NumFifoWords    : inout integer ;
    variable  Param           : out   std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
  begin
    LocalGetBurst(TransactionRec, NumFifoWords, StatusMsgOn) ; 
    NumFifoWords := TransactionRec.IntFromModel ;
    Param := SafeResize(TransactionRec.ParamFromModel, Param'length) ; 
  end procedure GetBurst ;  

  -- ========================================================
  -- TryGetBurst
  -- Try Get Burst Transaction
  -- If Data is available, get it and return available TRUE,
  -- otherwise Return Available FALSE.
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for received error status.
  -- ========================================================

  ------------------------------------------------------------
  procedure LocalTryGetBurst (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  NumFifoWords    : in    integer ;
    variable  Available       : out   boolean ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
  begin
    TransactionRec.Operation   <= TRY_GET_BURST ;
    TransactionRec.IntToModel  <= NumFifoWords ;  -- For models without burst framing (like UART)
    TransactionRec.BoolToModel <= StatusMsgOn ;     
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ; 
    Available := TransactionRec.BoolFromModel ;
  end procedure LocalTryGetBurst ; 

  ------------------------------------------------------------
  procedure TryGetBurst (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    variable  NumFifoWords    : inout integer ;
    variable  Available       : out   boolean ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
  begin
    LocalTryGetBurst(TransactionRec, NumFifoWords, Available, StatusMsgOn) ;
    NumFifoWords  := TransactionRec.IntFromModel ;
  end procedure TryGetBurst ; 

  ------------------------------------------------------------
  procedure TryGetBurst (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    variable  NumFifoWords    : inout integer ;
    variable  Param           : out   std_logic_vector ;
    variable  Available       : out   boolean ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
  begin
    LocalTryGetBurst(TransactionRec, NumFifoWords, Available, StatusMsgOn) ;
    NumFifoWords  := TransactionRec.IntFromModel ;
    Param := SafeResize(TransactionRec.ParamFromModel, Param'length) ; 
  end procedure TryGetBurst ;  


  -- ========================================================
  -- Check
  -- Blocking Get Transaction. 
  -- Data is the expected value to be received.
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for received error status.
  -- ========================================================

  ------------------------------------------------------------
  procedure Check (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  Param           : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
    variable LocalParam : std_logic_vector(TransactionRec.ParamToModel'length -1 downto 0) := (others => '-') ;
  begin
    LocalParam(Param'length-1 downto 0) := Param ; 
    TransactionRec.Operation     <= CHECK ;
    TransactionRec.DataToModel   <= SafeResize(Data, TransactionRec.DataToModel'length) ; 
    TransactionRec.ParamToModel  <= SafeResize(LocalParam, TransactionRec.ParamToModel'length) ; 
    TransactionRec.IntToModel    <= Data'length ;
    TransactionRec.BoolToModel   <= StatusMsgOn ;     
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ; 
  end procedure Check ; 

  ------------------------------------------------------------
  procedure Check (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
  begin
    Check(TransactionRec, Data, "", StatusMsgOn) ;
  end procedure Check ; 


  -- ========================================================
  -- TryCheck
  -- Try Check Transaction
  -- If Data is available, check it and return available TRUE,
  -- otherwise Return Available FALSE.
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for received error status.
  -- ========================================================

  ------------------------------------------------------------
  procedure TryCheck (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  Param           : in    std_logic_vector ;
    variable  Available       : out   boolean ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
    variable LocalParam : std_logic_vector(TransactionRec.ParamToModel'length -1 downto 0) := (others => '-') ;
  begin
    LocalParam(Param'length-1 downto 0) := Param ; 
    TransactionRec.Operation     <= TRY_CHECK ;
    TransactionRec.DataToModel   <= SafeResize(Data, TransactionRec.DataToModel'length) ; 
    TransactionRec.ParamToModel  <= SafeResize(LocalParam, TransactionRec.ParamToModel'length) ; 
    TransactionRec.IntToModel    <= Data'length ;
    TransactionRec.BoolToModel   <= StatusMsgOn ;     
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ; 
    Available := TransactionRec.BoolFromModel ;
  end procedure TryCheck ; 

  ------------------------------------------------------------
  procedure TryCheck (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    variable  Available       : out   boolean ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
  begin
    TryCheck(TransactionRec, Data, "", Available, StatusMsgOn) ;
  end procedure TryCheck ; 


  -- ========================================================
  -- CheckBurst
  -- Blocking Check Burst Transaction. 
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for checking error injection.
  -- ========================================================
  ------------------------------------------------------------
  procedure LocalCheckBurst (
  -- Package Local - simplifies the other calls to Check
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Operation       : in    StreamOperationType ;
    constant  NumFifoWords    : In    integer ;
    constant  Param           : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
    variable LocalParam : std_logic_vector(TransactionRec.ParamToModel'length -1 downto 0) := (others => '-') ;
  begin
    LocalParam(Param'length-1 downto 0) := Param ; 
    TransactionRec.Operation     <= Operation ;
    TransactionRec.IntToModel    <= NumFifoWords ; 
    TransactionRec.ParamToModel  <= SafeResize(LocalParam, TransactionRec.ParamToModel'length) ; 
    TransactionRec.BoolToModel   <= StatusMsgOn ; 
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ; 
  end procedure LocalCheckBurst ; 

  ------------------------------------------------------------
  procedure CheckBurst (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  NumFifoWords    : In    integer ;
    constant  Param           : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
  begin
    LocalCheckBurst(TransactionRec, CHECK_BURST, NumFifoWords, Param, StatusMsgOn) ;
  end procedure CheckBurst ; 
  
  ------------------------------------------------------------
  procedure CheckBurst (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  NumFifoWords    : In    integer ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
  begin
    LocalCheckBurst(TransactionRec, CHECK_BURST, NumFifoWords, "", StatusMsgOn) ;
  end procedure CheckBurst ; 

  ------------------------------------------------------------
  procedure CheckBurstVector (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant VectorOfWords  : In    slv_vector ;
    constant Param          : In    std_logic_vector ;
    constant StatusMsgOn    : In    boolean := false
  ) is
  begin
    PushBurstVector(TransactionRec.BurstFifo, VectorOfWords) ;
    LocalCheckBurst(TransactionRec, CHECK_BURST, VectorOfWords'length, Param, StatusMsgOn) ;
  end procedure CheckBurstVector ;
  
  ------------------------------------------------------------
  procedure CheckBurstVector (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant VectorOfWords  : In    slv_vector ;
    constant StatusMsgOn    : In    boolean := false
  ) is
  begin
    CheckBurstVector(TransactionRec, VectorOfWords, "", StatusMsgOn) ; 
  end procedure CheckBurstVector ;
  
  ------------------------------------------------------------
  procedure CheckBurstIncrement (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant FirstWord      : In    std_logic_vector ;
    constant NumFifoWords   : In    integer ;
    constant Param          : In    std_logic_vector ;
    constant StatusMsgOn    : In    boolean := false
  ) is
  begin
    PushBurstIncrement(TransactionRec.BurstFifo, FirstWord, NumFifoWords) ;
    LocalCheckBurst(TransactionRec, CHECK_BURST, NumFifoWords, Param, StatusMsgOn) ;
  end procedure CheckBurstIncrement ;

  ------------------------------------------------------------
  procedure CheckBurstIncrement (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant FirstWord      : In    std_logic_vector ;
    constant NumFifoWords   : In    integer ;
    constant StatusMsgOn    : In    boolean := false
  ) is
  begin
    CheckBurstIncrement(TransactionRec, FirstWord, NumFifoWords, "", StatusMsgOn) ; 
  end procedure CheckBurstIncrement ;

  ------------------------------------------------------------
  procedure CheckBurstRandom (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant FirstWord      : In    std_logic_vector ;
    constant NumFifoWords   : In    integer ;
    constant Param          : In    std_logic_vector ;
    constant StatusMsgOn    : In    boolean := false
  ) is
  begin
    PushBurstRandom(TransactionRec.BurstFifo, FirstWord, NumFifoWords) ;
    LocalCheckBurst(TransactionRec, CHECK_BURST, NumFifoWords, Param, StatusMsgOn) ;
  end procedure CheckBurstRandom ;
  
  ------------------------------------------------------------
  procedure CheckBurstRandom (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant FirstWord      : In    std_logic_vector ;
    constant NumFifoWords   : In    integer ;
    constant StatusMsgOn    : In    boolean := false
  ) is
  begin
    CheckBurstRandom(TransactionRec, FirstWord, NumFifoWords, "", StatusMsgOn) ; 
  end procedure CheckBurstRandom ;

  ------------------------------------------------------------
  procedure CheckBurstRandom (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant CoverID        : In    CoverageIDType ;
    constant NumFifoWords   : In    integer ;
    constant FifoWidth      : In    integer ;
    constant Param          : In    std_logic_vector ;
    constant StatusMsgOn    : In    boolean := false
  ) is
  begin
    PushBurstRandom(TransactionRec.BurstFifo, CoverID, NumFifoWords, FifoWidth) ;
    LocalCheckBurst(TransactionRec, CHECK_BURST, NumFifoWords, Param, StatusMsgOn) ;
  end procedure CheckBurstRandom ;  

  ------------------------------------------------------------
  procedure CheckBurstRandom (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant CoverID        : In    CoverageIDType ;
    constant NumFifoWords   : In    integer ;
    constant FifoWidth      : In    integer ;
    constant StatusMsgOn    : In    boolean := false
  ) is
  begin
    CheckBurstRandom(TransactionRec, CoverID, NumFifoWords, FifoWidth, "", StatusMsgOn) ;
  end procedure CheckBurstRandom ;  

  -- ========================================================
  -- TryCheckBurst
  -- Try / Non-Blocking Check Burst Transaction
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for error injection. 
  -- ========================================================
  ------------------------------------------------------------
  procedure TryCheckBurst (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  NumFifoWords    : In    integer ;
    constant  Param           : in    std_logic_vector ;
    variable  Available       : out   boolean ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
  begin
    LocalCheckBurst(TransactionRec, TRY_CHECK_BURST, NumFifoWords, Param, StatusMsgOn) ;
    Available := TransactionRec.BoolFromModel ;
  end procedure TryCheckBurst ; 

  ------------------------------------------------------------
  procedure TryCheckBurst (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  NumFifoWords    : In    integer ;
    variable  Available       : out   boolean ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
  begin
    LocalCheckBurst(TransactionRec, TRY_CHECK_BURST, NumFifoWords, "", StatusMsgOn) ;
    Available := TransactionRec.BoolFromModel ;
  end procedure TryCheckBurst ; 

  ------------------------------------------------------------
  procedure TryCheckBurstVector (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant VectorOfWords  : In    slv_vector ;
    constant Param          : In    std_logic_vector ;
    variable Available      : Out   boolean ;
    constant StatusMsgOn    : In    boolean := false
  ) is
  begin
    GotBurst(TransactionRec, VectorOfWords'length, Available) ; 
    if Available then 
      PushBurstVector(TransactionRec.BurstFifo, VectorOfWords) ;
      LocalCheckBurst(TransactionRec, CHECK_BURST, VectorOfWords'length, Param, StatusMsgOn) ;
    end if ; 
  end procedure TryCheckBurstVector ;
    
  ------------------------------------------------------------
  procedure TryCheckBurstVector (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant VectorOfWords  : In    slv_vector ;
    variable Available      : Out   boolean ;
    constant StatusMsgOn    : In    boolean := false
  ) is
  begin
    TryCheckBurstVector(TransactionRec, VectorOfWords, "", Available, StatusMsgOn) ;
  end procedure TryCheckBurstVector ;
  
  ------------------------------------------------------------
  procedure TryCheckBurstIncrement (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant FirstWord      : In    std_logic_vector ;
    constant NumFifoWords   : In    integer ;
    constant Param          : In    std_logic_vector ;
    variable Available      : Out   boolean ;
    constant StatusMsgOn    : In    boolean := false
  ) is
  begin
    GotBurst(TransactionRec, NumFifoWords, Available) ; 
    if Available then
      PushBurstIncrement(TransactionRec.BurstFifo, FirstWord, NumFifoWords) ;
      LocalCheckBurst(TransactionRec, CHECK_BURST, NumFifoWords, Param, StatusMsgOn) ;
    end if ; 
  end procedure TryCheckBurstIncrement ;

  ------------------------------------------------------------
  procedure TryCheckBurstIncrement (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant FirstWord      : In    std_logic_vector ;
    constant NumFifoWords   : In    integer ;
    variable Available      : Out   boolean ;
    constant StatusMsgOn    : In    boolean := false
  ) is
  begin
    TryCheckBurstIncrement(TransactionRec, FirstWord, NumFifoWords, "", Available, StatusMsgOn) ; 
  end procedure TryCheckBurstIncrement ;

  ------------------------------------------------------------
  procedure TryCheckBurstRandom (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant FirstWord      : In    std_logic_vector ;
    constant NumFifoWords   : In    integer ;
    constant Param          : In    std_logic_vector ;
    variable Available      : Out   boolean ;
    constant StatusMsgOn    : In    boolean := false
  ) is
  begin
    GotBurst(TransactionRec, NumFifoWords, Available) ; 
    if Available then
      PushBurstRandom(TransactionRec.BurstFifo, FirstWord, NumFifoWords) ;
      LocalCheckBurst(TransactionRec, CHECK_BURST, NumFifoWords, Param, StatusMsgOn) ;
    end if ; 
  end procedure TryCheckBurstRandom ;

  ------------------------------------------------------------
  procedure TryCheckBurstRandom (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant FirstWord      : In    std_logic_vector ;
    constant NumFifoWords   : In    integer ;
    variable Available      : Out   boolean ;
    constant StatusMsgOn    : In    boolean := false
  ) is
  begin
    TryCheckBurstRandom(TransactionRec, FirstWord, NumFifoWords, "", Available, StatusMsgOn) ; 
  end procedure TryCheckBurstRandom ;

  ------------------------------------------------------------
  procedure TryCheckBurstRandom (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant CoverID        : In    CoverageIDType ;
    constant NumFifoWords   : In    integer ;
    constant FifoWidth      : In    integer ;
    constant Param          : In    std_logic_vector ;
    variable Available      : Out   boolean ;
    constant StatusMsgOn    : In    boolean := false
  ) is
  begin
    GotBurst(TransactionRec, NumFifoWords, Available) ; 
    if Available then
      PushBurstRandom(TransactionRec.BurstFifo, CoverID, NumFifoWords, FifoWidth) ;
      LocalCheckBurst(TransactionRec, CHECK_BURST, NumFifoWords, Param, StatusMsgOn) ;
    end if ; 
  end procedure TryCheckBurstRandom ;  

  ------------------------------------------------------------
  procedure TryCheckBurstRandom (
  ------------------------------------------------------------
    signal   TransactionRec : InOut StreamRecType ;
    constant CoverID        : In    CoverageIDType ;
    constant NumFifoWords   : In    integer ;
    constant FifoWidth      : In    integer ;
    variable Available      : Out   boolean ;
    constant StatusMsgOn    : In    boolean := false
  ) is
  begin
    TryCheckBurstRandom(TransactionRec, CoverID, NumFifoWords, FifoWidth, "", Available, StatusMsgOn) ;
  end procedure TryCheckBurstRandom ;  

  -- ========================================================
  --  Pseudo Transactions
  --  Interact with the record only.
  -- ========================================================
  ------------------------------------------------------------
  procedure ReleaseTransactionRecord (
  --  Must run on same delta cycle as AcquireTransactionRecord
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType 
  ) is
  begin
    -- Set everything driven by TestCtrl to type'left (except Rdy)
    TransactionRec.Rdy           <= RdyType'left ;   
    TransactionRec.Operation     <= NOT_DRIVEN ;
    TransactionRec.DataToModel   <= (TransactionRec.DataToModel'range => 'U') ;
    TransactionRec.ParamToModel  <= (TransactionRec.ParamToModel'range => 'U') ;
    TransactionRec.IntToModel    <= integer'left ; 
    TransactionRec.BoolToModel   <= boolean'left ; 
    TransactionRec.TimeToModel   <= time'left ; 
    TransactionRec.Options       <= integer'left ;    
  end procedure ReleaseTransactionRecord ; 
  
  ------------------------------------------------------------
  procedure AcquireTransactionRecord (
  --  Must run on same delta cycle as ReleaseTransactionRecord
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType 
  ) is
  begin
    -- Start Driving Rdy on next delta cycle with the current value.  
    TransactionRec.Rdy           <= TransactionRec.Rdy ; 
  end procedure AcquireTransactionRecord ; 


  -- ========================================================
  --  Verification Component Support Functions
  --  These help decode the operation value (StreamOperationType)  
  --  to determine properties about the operation
  -- ========================================================
  ------------------------------------------------------------
  function IsBlocking (
  -----------------------------------------------------------
    constant Operation     : in StreamOperationType
  ) return boolean is
  begin
    return (Operation = SEND) or (Operation = GET) or (Operation = CHECK) or 
           (Operation = SEND_BURST) or (Operation = GET_BURST) or (Operation = CHECK_BURST)  ;
  end function IsBlocking ;

  ------------------------------------------------------------
  function IsTry (
  -----------------------------------------------------------
    constant Operation     : in StreamOperationType
  ) return boolean is
  begin
    return (Operation = TRY_GET) or (Operation = TRY_CHECK) or (Operation = TRY_GET_BURST) or (Operation = TRY_CHECK_BURST) ;
  end function IsTry ;

  ------------------------------------------------------------
  function IsCheck (
  -----------------------------------------------------------
    constant Operation     : in StreamOperationType
  ) return boolean is
  begin
    return (Operation = CHECK) or (Operation = TRY_CHECK) or (Operation = CHECK_BURST) or (Operation = TRY_CHECK_BURST) ;
  end function IsCheck ;

end StreamTransactionPkg ;