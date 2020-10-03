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
--      Constant and Transaction Support for OSVVM UART Transmitter and Receiver models
--
--
--  Developed by:
--        SynthWorks Design Inc.
--        VHDL Training Classes
--        http://www.SynthWorks.com
--
--  Revision History:
--    Date      Version    Description
--    09/2020   2020.09    Updating comments to serve as documentation
--    07/2019   2019.07    Refactored from UartTbPkg and AxiStreamTransactionPkg
--    01/2020   2020.01    Updated license notice
--
--
--  This file is part of OSVVM.
--  
--  Copyright (c) 2019 - 2020 by SynthWorks Design Inc.  
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

library OSVVM ; 
  context OSVVM.OsvvmContext ;  
  
package StreamTransactionPkg is 

  -- ========================================================
  --  StreamOperationType 
  --  Enumeration type used to communication transaction type
  --  to the model via the transaction interface
  -- ========================================================
  type StreamUnresolvedOperationType is (
   --  Transmitter
    SEND, 
    SEND_ASYNC,
    -- Receiver
    GET,             
    TRY_GET,
    CHECK,
    TRY_CHECK,
    -- Model Directives
    WAIT_FOR_CLOCK, 
    GET_ALERTLOG_ID,
    GET_TRANSACTION_COUNT,
    SET_MODEL_OPTIONS,
    GET_MODEL_OPTIONS,
    WAIT_FOR_TRANSACTION,
    THE_END
  ) ;
  type StreamUnresolvedOperationVectorType is array (natural range <>) of StreamUnresolvedOperationType ;
  -- Maximum is implicitly defined for any array type in VHDL-2008.   
  -- alias resolved_max is maximum[ StreamUnresolvedOperationVectorType return StreamUnresolvedOperationType] ;
  -- Function resolved_max is a fall back.
  function resolved_max ( s : StreamUnresolvedOperationVectorType) return StreamUnresolvedOperationType ;
  subtype StreamOperationType is resolved_max StreamUnresolvedOperationType ;

  -- ========================================================
  --  StreamRecType 
  --  Transaction interface between the test sequencer and the 
  --  verification component.   As such it is the primary channel 
  --  for information exchange between the two. The types bit_max,
  --   std_logic_vector_max_c, integer_max, time_max, and 
  --  boolean_max are defined the OSVVM package, ResolutionPkg.  
  --  These types allow the record to support multiple drivers and 
  --  use resolution functions based on function maximum (return largest value)
  -- ========================================================
  type StreamRecType is record
    -- Handshaking controls
    --   Used by RequestTransaction in the Transaction Procedures
    --   Used by WaitForTransaction in the Verification Component
    --   RequestTransaction and WaitForTransaction are in osvvm.TbUtilPkg
    Rdy             : bit_max ;
    Ack             : bit_max ;
    -- Transaction Type
    Operation       : StreamOperationType ;
    -- Data and Transaction Parameter to and from verification component 
    DataToModel     : std_logic_vector_max_c ; 
    ParamToModel    : std_logic_vector_max_c ; 
    DataFromModel   : std_logic_vector_max_c ; 
    ParamFromModel  : std_logic_vector_max_c ; 
    -- Verification Component Options Parameters - used by SetModelOptions
    IntToModel      : integer_max ;
    BoolToModel     : boolean_max ; 
    IntFromModel    : integer_max ; 
    BoolFromModel   : boolean_max ;
    TimeToModel     : time_max ; 
    TimeFromModel   : time_max ; 
    -- Verification Component Options Type - currently aliased to type integer_max 
    Options         : integer_max ; 
  end record StreamRecType ; 
    
  -- --------------------------------------------------------
  -- Usage of the Transaction Interface (StreamRecType)
  -- The Data and Parameter fields of StreamRecType are unconstrained.
  -- Unconstrained objects may be used on component/entity interfaces.    
  -- These fields will be sized when used as a record signal in the test harness 
  -- of the testbench.  Such a declaration is shown below:
  --
  --   signal AxiStreamTransmitterTransRec : StreamRecType(
  --                DataToModel(AXI_DATA_WIDTH-1 downto 0),
  --                DataFromModel(AXI_DATA_WIDTH-1 downto 0),
  --                ParamToModel(0 downto 1),    -- Not Used for AXI Stream
  --                ParamFromModel(0 downto 1)   -- Not Used for AXI Stream
  --             ) ;  
  --
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
  
  ------------------------------------------------------------
  procedure GetTransactionCount (
  -- Get the number of transactions handled by the model.  
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecType ;
    variable  TransactionCount : out   integer 
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
    signal   TransRec    : InOut StreamRecType ;
    constant Option      : In    integer ;
    constant OptVal      : In    boolean
  ) ;

  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal   TransRec    : InOut StreamRecType ;
    constant Option      : In    integer ;
    constant OptVal      : In    integer
  ) ;

  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal   TransRec    : InOut StreamRecType ;
    constant Option      : In    integer ;
    constant OptVal      : In    std_logic_vector
  ) ;
  
  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal   TransRec    : InOut StreamRecType ;
    constant Option      : In    integer ;
    constant OptVal      : In    time
  ) ;
  
  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal   TransRec    : InOut StreamRecType ;
    constant Option      : In    integer 
  ) ;
  
  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal   TransRec    : InOut StreamRecType ;
    constant Option      : In    integer ;
    variable OptVal      : Out   boolean
  ) ;

  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal   TransRec    : InOut StreamRecType ;
    constant Option      : In    integer ;
    variable OptVal      : Out   integer
  ) ;

  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal   TransRec    : InOut StreamRecType ;
    constant Option      : In    integer ;
    variable OptVal      : Out   std_logic_vector
  ) ;
  
  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal   TransRec    : InOut StreamRecType ;
    constant Option      : In    integer ;
    variable OptVal      : Out   time
  ) ;
  
  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal   TransRec    : InOut StreamRecType ;
    constant Option      : In    integer 
  ) ;


  -- ========================================================
  --  Transmitter Transactions
  -- ========================================================

  ------------------------------------------------------------
  procedure Send (
  -- Blocking Send Transaction. 
  -- Param is an extra parameter used by the verification component
  -- The UART verification component uses Param for error injection.
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  Param           : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 

  procedure Send (
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 
  
  ------------------------------------------------------------
  procedure SendAsync (
  -- Asynchronous / Non-Blocking Send Transaction
  -- Param is an extra parameter used by the verification component
  -- The UART verification component uses Param for error injection. 
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  Param           : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 

  procedure SendAsync (
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 


  -- ========================================================
  --  Receiver Transactions
  -- ========================================================
  ------------------------------------------------------------
  procedure Get (
  -- Blocking Get Transaction. 
  -- Param is an extra parameter used by the verification component
  -- The UART verification component uses Param for error injection.
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    variable  Data            : out   std_logic_vector ;
    variable  Param           : out   std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 

  procedure Get (
    signal    TransactionRec  : inout StreamRecType ;
    variable  Data            : out   std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 

  ------------------------------------------------------------
  procedure TryGet (
  -- Try Get Transaction
  -- If Data is available, get it and return available TRUE,
  -- otherwise Return Available FALSE.
  -- Param is an extra parameter used by the verification component
  -- The UART verification component uses Param for error injection. 
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    variable  Data            : out   std_logic_vector ;
    variable  Available       : out   boolean ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 
  
  procedure TryGet (
    signal    TransactionRec  : inout StreamRecType ;
    variable  Data            : out   std_logic_vector ;
    variable  Param           : out   std_logic_vector ;
    variable  Available       : out   boolean ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ;  

  ------------------------------------------------------------
  procedure Check (
  -- Blocking Get Transaction. 
  -- Data is the expected value to be received.
  -- Param is an extra parameter used by the verification component
  -- The UART verification component uses Param for error injection.
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  Param           : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 

  procedure Check (
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 


  ------------------------------------------------------------
  procedure TryCheck (
  -- Try Check Transaction
  -- If Data is available, check it and return available TRUE,
  -- otherwise Return Available FALSE.
  -- Param is an extra parameter used by the verification component
  -- The UART verification component uses Param for error injection. 
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  Param           : in    std_logic_vector ;
    variable  Available       : out   boolean ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 

  procedure TryCheck (
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    variable  Available       : out   boolean ;
    constant  StatusMsgOn     : in    boolean := FALSE 
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
  )  ;
  
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
  begin
    return maximum(s) ;
  end function resolved_max ; 

  ------------------------------------------------------------
  -- OSVVM Model Independent Transactions
  ------------------------------------------------------------
  ------------------------------------------------------------
  -- Send: Transaction Transmit Data Procedure
  procedure LocalSend (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Operation       : in    StreamOperationType ;
    constant  Data            : in    std_logic_vector ;
    constant  Param           : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
  begin
    TransactionRec.Operation     <= Operation ;
    TransactionRec.DataToModel   <= std_logic_vector_max_c(Data) ; 
    TransactionRec.ParamToModel  <= std_logic_vector_max_c(Param) ; 
    TransactionRec.IntToModel    <= Data'length ;
    TransactionRec.BoolToModel   <= StatusMsgOn ; 
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ; 
  end procedure LocalSend ; 

  ------------------------------------------------------------
  -- Send: Transaction Transmit Data Procedure
  procedure Send (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  Param           : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
    constant LocalParam : std_logic_vector(TransactionRec.ParamToModel'length -1 downto 0) := (others => '-') ;
  begin
    LocalParam(Param'length-1 downto 0) := Param ; 
    LocalSend(TransactionRec, SEND, Data, LocalParam, StatusMsgOn) ;
  end procedure Send ; 

  procedure Send (
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
    constant LocalParam : std_logic_vector(TransactionRec.ParamToModel'range) := (others => '-') ;
  begin
    LocalSend(TransactionRec, SEND, Data, LocalParam, StatusMsgOn);
  end procedure Send ; 

  ------------------------------------------------------------
  -- SendAsync: Transaction Transmit Data Procedure
  procedure SendAsync (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  Param           : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
    constant LocalParam : std_logic_vector(TransactionRec.ParamToModel'length -1 downto 0) := (others => '-') ;
  begin
    LocalParam(Param'length-1 downto 0) := Param ; 
    LocalSend(TransactionRec, SEND_ASYNC, Data, LocalParam, StatusMsgOn) ;
  end procedure SendAsync ; 

  procedure SendAsync (
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
    constant LocalParam : std_logic_vector(TransactionRec.ParamToModel'range) := (others => '-') ;
  begin
    LocalSend(TransactionRec, SEND_ASYNC, Data, LocalParam, StatusMsgOn);
  end procedure SendAsync ; 

  ------------------------------------------------------------
  -- Get: Transaction Receive Data Procedure
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
    Data      := std_logic_vector(TransactionRec.DataFromModel) ; 
  end procedure Get ; 
  
  procedure Get (
    signal    TransactionRec  : inout StreamRecType ;
    variable  Data            : out   std_logic_vector ;
    variable  Param           : out   std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
  begin
    Get(TransactionRec, Data, StatusMsgOn) ;
    Param := std_logic_vector(TransactionRec.ParamFromModel) ; 
  end procedure Get ;  

  ------------------------------------------------------------
  -- TryGet: Transaction Receive Data if available Procedure
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
    Data      := std_logic_vector(TransactionRec.DataFromModel) ; 
    Available := TransactionRec.IntFromModel = 1 ;
  end procedure TryGet ; 
  
  procedure TryGet (
    signal    TransactionRec  : inout StreamRecType ;
    variable  Data            : out   std_logic_vector ;
    variable  Param           : out   std_logic_vector ;
    variable  Available       : out   boolean ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
  begin
    TryGet(TransactionRec, Data, Available, StatusMsgOn) ;
    Param := std_logic_vector(TransactionRec.ParamFromModel) ; 
  end procedure TryGet ;  

  ------------------------------------------------------------
  -- Check: Transaction Receive and Check Procedure
  procedure Check (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  Param           : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
  begin
    TransactionRec.Operation     <= CHECK ;
    TransactionRec.DataToModel   <= std_logic_vector_max_c(Data) ; 
    TransactionRec.ParamToModel  <= std_logic_vector_max_c(Param) ; 
    TransactionRec.IntToModel    <= Data'length ;
    TransactionRec.BoolToModel   <= StatusMsgOn ;     
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ; 
  end procedure Check ; 

  procedure Check (
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
    constant Param : std_logic_vector(TransactionRec.ParamToModel'range) := (others => '0') ;
  begin
    Check(TransactionRec, Data, Param, StatusMsgOn) ;
  end procedure Check ; 

  ------------------------------------------------------------
  -- TryCheck: Transaction Receive and Check Data if available Procedure
  procedure TryCheck (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  Param           : in    std_logic_vector ;
    variable  Available       : out   boolean ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
  begin
    TransactionRec.Operation     <= TRY_CHECK ;
    TransactionRec.DataToModel   <= std_logic_vector_max_c(Data) ; 
    TransactionRec.ParamToModel  <= std_logic_vector_max_c(Param) ; 
    TransactionRec.IntToModel    <= Data'length ;
    TransactionRec.BoolToModel   <= StatusMsgOn ;     
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ; 
    Available := TransactionRec.IntFromModel = 1 ;
  end procedure TryCheck ; 

  procedure TryCheck (
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    variable  Available       : out   boolean ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
    constant Param : std_logic_vector(TransactionRec.ParamToModel'range) := (others => '0') ;
  begin
    TryCheck(TransactionRec, Data, Param, Available, StatusMsgOn) ;
  end procedure TryCheck ; 

  ------------------------------------------------------------
  -- WaitForTransaction  
  --   Wait until pending (transmit) or next (receive) transaction(s) complete
  procedure WaitForTransaction (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType 
  ) is
  begin
    TransactionRec.Operation   <= WAIT_FOR_TRANSACTION ;
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ; 
  end procedure WaitForTransaction ; 

  ------------------------------------------------------------
  -- WaitForClock:  Directive, do nothing for WaitCycles number of clocks
  procedure WaitForClock (
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
  -- GetAlertLogID:  Directive, get AlertLogID from the model 
  procedure GetAlertLogID (
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
  -- GetErrors:  
  --    For non-osvvm testbenches, returns error count for this model
  --    If Error Count is also non-zero, also prints error counts
  procedure GetErrorCount (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    variable  ErrorCount      : out   natural
  ) is
    variable  AlertLogID : AlertLogIDType ;
  begin
    GetAlertLogID(TransactionRec, AlertLogID) ;
    ReportNonZeroAlerts(AlertLogID => AlertLogID) ;
    ErrorCount := GetAlertCount(AlertLogID => AlertLogID) ;
  end procedure GetErrorCount ; 
  
  ------------------------------------------------------------
  -- GetTransactionCount:  Directive, get model transaction count
  procedure GetTransactionCount (
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
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal   TransRec    : InOut StreamRecType ;
    constant Option      : In    integer ;
    constant OptVal      : In    boolean
  ) is
  begin
    TransRec.Operation     <= SET_MODEL_OPTIONS ;
    TransRec.Options       <= Option ;
    TransRec.BoolToModel   <= OptVal ;
    RequestTransaction(Rdy => TransRec.Rdy, Ack => TransRec.Ack) ;
  end procedure SetModelOptions ;

  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal   TransRec    : InOut StreamRecType ;
    constant Option      : In    integer ;
    constant OptVal      : In    integer
  ) is
  begin
    TransRec.Operation     <= SET_MODEL_OPTIONS ;
    TransRec.Options       <= Option ;
    TransRec.IntToModel    <= OptVal ;
    RequestTransaction(Rdy => TransRec.Rdy, Ack => TransRec.Ack) ;
  end procedure SetModelOptions ;

  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal   TransRec    : InOut StreamRecType ;
    constant Option      : In    integer ;
    constant OptVal      : In    std_logic_vector
  ) is
  begin
    TransRec.Operation     <= SET_MODEL_OPTIONS ;
    TransRec.Options       <= Option ;
    TransRec.IntToModel    <= to_integer(OptVal) ;
    RequestTransaction(Rdy => TransRec.Rdy, Ack => TransRec.Ack) ;
  end procedure SetModelOptions ;
  
  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal   TransRec    : InOut StreamRecType ;
    constant Option      : In    integer ;
    constant OptVal      : In    time
  ) is
  begin
    TransRec.Operation     <= SET_MODEL_OPTIONS ;
    TransRec.Options       <= Option ;
    TransRec.TimeToModel   <= OptVal ;
    RequestTransaction(Rdy => TransRec.Rdy, Ack => TransRec.Ack) ;
  end procedure SetModelOptions ;

  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal   TransRec    : InOut StreamRecType ;
    constant Option      : In    integer 
  ) is
  begin
    TransRec.Operation     <= SET_MODEL_OPTIONS ;
    TransRec.Options       <= Option ;
    -- OptVal handled by Model Specific Package
    -- TransRec.IntToModel    <= to_integer(OptVal) ;
    RequestTransaction(Rdy => TransRec.Rdy, Ack => TransRec.Ack) ;
  end procedure SetModelOptions ;

  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal   TransRec    : InOut StreamRecType ;
    constant Option      : In    integer ;
    variable OptVal      : Out   boolean
  ) is
  begin
    TransRec.Operation     <= GET_MODEL_OPTIONS ;
    TransRec.Options       <= Option ;
    RequestTransaction(Rdy => TransRec.Rdy, Ack => TransRec.Ack) ;
    OptVal := TransRec.BoolFromModel    ;
  end procedure GetModelOptions ;

  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal   TransRec    : InOut StreamRecType ;
    constant Option      : In    integer ;
    variable OptVal      : Out   integer
  ) is
  begin
    TransRec.Operation     <= GET_MODEL_OPTIONS ;
    TransRec.Options       <= Option ;
    RequestTransaction(Rdy => TransRec.Rdy, Ack => TransRec.Ack) ;
    OptVal := TransRec.IntFromModel ; 
  end procedure GetModelOptions ;

  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal   TransRec    : InOut StreamRecType ;
    constant Option      : In    integer ;
    variable OptVal      : Out   std_logic_vector
  ) is
  begin
    TransRec.Operation     <= GET_MODEL_OPTIONS ;
    TransRec.Options       <= Option ;
    RequestTransaction(Rdy => TransRec.Rdy, Ack => TransRec.Ack) ;
    OptVal := to_slv(TransRec.IntFromModel, OptVal'length) ; 
  end procedure GetModelOptions ;
  
  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal   TransRec    : InOut StreamRecType ;
    constant Option      : In    integer ;
    variable OptVal      : Out   time
  ) is
  begin
    TransRec.Operation     <= GET_MODEL_OPTIONS ;
    TransRec.Options       <= Option ;
    RequestTransaction(Rdy => TransRec.Rdy, Ack => TransRec.Ack) ;
    OptVal := TransRec.TimeFromModel ; 
  end procedure GetModelOptions ;

  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal   TransRec    : InOut StreamRecType ;
    constant Option      : In    integer 
  ) is
  begin
    TransRec.Operation     <= GET_MODEL_OPTIONS ;
    TransRec.Options       <= Option ;
    RequestTransaction(Rdy => TransRec.Rdy, Ack => TransRec.Ack) ;
    -- OptVal handled by Model Specific layer overloading
    -- OptVal := TransRec.TimeFromModel ; 
  end procedure GetModelOptions ;


  ------------------------------------------------------------
  -- OSVVM Model Support
  ------------------------------------------------------------
  ------------------------------------------------------------
  function IsBlocking (
  -----------------------------------------------------------
    constant Operation     : in StreamOperationType
  ) return boolean is
  begin
    return (Operation = SEND) or (Operation = GET) or (Operation = CHECK) ;
  end function IsBlocking ;

  ------------------------------------------------------------
  function IsTry (
  -----------------------------------------------------------
    constant Operation     : in StreamOperationType
  ) return boolean is
  begin
    return (Operation = TRY_GET) or (Operation = TRY_CHECK) ;
  end function IsTry ;

  ------------------------------------------------------------
  function IsCheck (
  -----------------------------------------------------------
    constant Operation     : in StreamOperationType
  ) return boolean is
  begin
    return (Operation = CHECK) or (Operation = TRY_CHECK) ;
  end function IsCheck ;

end StreamTransactionPkg ;