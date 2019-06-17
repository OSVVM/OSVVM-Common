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
--    Date       Version    Description
--    2019.06    2019.06    Refactored from UartTbPkg and AxiStreamTransactionPkg
--
--      Copyright (c) 1999 - 2019 by SynthWorks Design Inc.  All rights reserved.
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--

library ieee ;
  use ieee.std_logic_1164.all ;
  use ieee.numeric_std.all ;
  use ieee.numeric_std_unsigned.all ;

  use std.textio.all ;

library OSVVM ; 
  context OSVVM.OsvvmContext ;  
  
package StreamTransactionPkg is 

  ------------------------------------------------------------
  -- OSVVM Stream Operations
  ------------------------------------------------------------
  type StreamUnresolvedOperationType is (
    --  bus operations
    SEND,            -- Master
    SEND_ASYNC,
    GET,             -- Slave
    TRY_GET,
    CHECK,
    TRY_CHECK,
    WAIT_FOR_TRANSACTION,
    -- Model Directives
    WAIT_FOR_CLOCK, 
    GET_ALERT_LOG_ID,
    -- GET_ERRORS, 
    GET_TRANSACTION_COUNT,
    SET_OPTIONS,
    THE_END
  ) ;
  type StreamUnresolvedOperationVectorType is array (natural range <>) of StreamUnresolvedOperationType ;
  -- Maximum is implicitly defined for any array type in VHDL-2008.   
  -- alias resolved_max is maximum[ StreamUnresolvedOperationVectorType return StreamUnresolvedOperationType] ;
  -- Function resolved_max is a fall back.
  function resolved_max ( s : StreamUnresolvedOperationVectorType) return StreamUnresolvedOperationType ;
  subtype StreamOperationType is resolved_max StreamUnresolvedOperationType ;

  
  ------------------------------------------------------------
  -- The Record for Communication 
  ------------------------------------------------------------
  type StreamRecType is record
    Rdy             : bit_max ;
    Ack             : bit_max ;
    Operation       : StreamOperationType ;
    DataToModel     : std_logic_vector_max_c ; 
    ErrorToModel    : std_logic_vector_max_c ; 
    DataFromModel   : std_logic_vector_max_c ; 
    ErrorFromModel  : std_logic_vector_max_c ; 
    Option          : integer_max ;
    IntToModel      : integer_max ; 
    TimeToModel     : time_max ; 
    BoolToModel     : boolean_max ; 
    IntFromModel    : integer_max ; 
    AlertLogID      : integer_max ; 
  end record ; 

--  -- Older Methodology used initializations similar to the following
--  constant INIT_STREAM_REC : StreamRecType := 
--    ( Rdy             => '0', 
--      Ack             => '0',
--      Operation       => StreamUnresolvedOperationType'left,
--      DataToModel     => (others => 'U'),
--      ErrorToModel    => (others => 'U'),
--      DataFromModel   => (others => 'U'),
--      ErrorFromModel  => (others => 'U'),
--      Option          => integer'left,
--      IntToModel      => integer'left, 
--      TimeToModel     => time'left,
--      BoolToModel     => boolean'left, 
--      IntFromModel    => integer'left, 
--      AlertLogID      => integer'left
--    ) ; 
    
    
  ------------------------------------------------------------
  -- OSVVM Standard Transactions
  ------------------------------------------------------------
  ------------------------------------------------------------
  -- Send: Transaction Transmit Data Procedure
  procedure Send (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  ErrorMode       : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 

  procedure Send (
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 
  
  ------------------------------------------------------------
  -- SendAsync: Transaction Transmit Data Procedure
  procedure SendAsync (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  ErrorMode       : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 

  procedure SendAsync (
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 
  
  ------------------------------------------------------------
  -- Get: Transaction Receive Data Procedure
  procedure Get (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    variable  Data            : out   std_logic_vector ;
    variable  ErrorMode       : out   std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 

  procedure Get (
    signal    TransactionRec  : inout StreamRecType ;
    variable  Data            : out   std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 

  ------------------------------------------------------------
  -- TryGet: Transaction Receive Data if available Procedure
  procedure TryGet (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    variable  Data            : out   std_logic_vector ;
    variable  Available       : out   boolean ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 
  
  procedure TryGet (
    signal    TransactionRec  : inout StreamRecType ;
    variable  Data            : out   std_logic_vector ;
    variable  ErrorMode       : out   std_logic_vector ;
    variable  Available       : out   boolean ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ;  

  ------------------------------------------------------------
  -- Check: Transaction Receive and Check Procedure
  procedure Check (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  ErrorMode       : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 

  procedure Check (
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 


  ------------------------------------------------------------
  -- TryCheck: Transaction Receive and Check Data if available Procedure
  procedure TryCheck (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  ErrorMode       : in    std_logic_vector ;
    variable  Available       : out   boolean ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 

  procedure TryCheck (
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    variable  Available       : out   boolean ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) ; 


  ------------------------------------------------------------
  -- WaitForTransaction  
  --   Wait until pending (transmit) or next (receive) transaction(s) complete
  procedure WaitForTransaction (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType 
  ) ; 

  ------------------------------------------------------------
  -- WaitForClock:  Directive, do nothing for WaitCycles number of clocks
  procedure WaitForClock (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  WaitCycles      : in    natural := 1
  ) ; 

  ------------------------------------------------------------
  -- GetAlertLogID:  Directive, get AlertLogID from the model 
  procedure GetAlertLogID (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    variable  AlertLogID      : out   AlertLogIDType 
  ) ; 
  
  ------------------------------------------------------------
  -- GetErrors:  
  --    For non-osvvm testbenches, returns error count for this model
  --    If Error Count is also non-zero, also prints error counts
  procedure GetErrors (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    variable  ErrorCount      : out   natural
  ) ; 
  
  ------------------------------------------------------------
  -- GetTransactionCount:  Directive, get model transaction count
  procedure GetTransactionCount (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecType ;
    variable  TransactionCount : out   integer 
  ) ; 

  ------------------------------------------------------------
  -- SetOption:  Directive, set model options
  procedure SetOption (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Option          : in    integer ; 
    constant  TimeVal         : in    time 
  ) ; 
  
  procedure SetOption (
    signal    TransactionRec  : inout StreamRecType ;
    constant  Option          : in    integer ; 
    constant  IntVal          : in    integer 
  ) ; 

  ------------------------------------------------------------
  -- OSVVM Standard Model Support
  ------------------------------------------------------------
  ------------------------------------------------------------
  function IsTry (
  -----------------------------------------------------------
    constant Operation     : in StreamOperationType
  ) return boolean ;

  ------------------------------------------------------------
  function IsCheck (
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
  -- OSVVM Standard Transactions
  ------------------------------------------------------------
  ------------------------------------------------------------
  -- Send: Transaction Transmit Data Procedure
  procedure LocalSend (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Operation       : in    StreamOperationType ;
    constant  Data            : in    std_logic_vector ;
    constant  ErrorMode       : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
  begin
    TransactionRec.Operation     <= Operation ;
    TransactionRec.DataToModel   <= std_logic_vector_max_c(Data) ; 
    TransactionRec.ErrorToModel  <= std_logic_vector_max_c(ErrorMode) ; 
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
    constant  ErrorMode       : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
  begin
    LocalSend(TransactionRec, SEND, Data, ErrorMode, StatusMsgOn) ;
  end procedure Send ; 

  procedure Send (
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
    constant ErrorMode : std_logic_vector(TransactionRec.ErrorToModel'range) := (others => '0') ;
  begin
    LocalSend(TransactionRec, SEND, Data, ErrorMode, StatusMsgOn);
  end procedure Send ; 

  
  ------------------------------------------------------------
  -- SendAsync: Transaction Transmit Data Procedure
  procedure SendAsync (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  ErrorMode       : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
  begin
    LocalSend(TransactionRec, SEND_ASYNC, Data, ErrorMode, StatusMsgOn) ;
  end procedure SendAsync ; 

  procedure SendAsync (
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
    constant ErrorMode : std_logic_vector(TransactionRec.ErrorToModel'range) := (others => '0') ;
  begin
    LocalSend(TransactionRec, SEND_ASYNC, Data, ErrorMode, StatusMsgOn);
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
    variable  ErrorMode       : out   std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
  begin
    Get(TransactionRec, Data, StatusMsgOn) ;
    ErrorMode := std_logic_vector(TransactionRec.ErrorFromModel) ; 
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
    variable  ErrorMode       : out   std_logic_vector ;
    variable  Available       : out   boolean ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
  begin
    TryGet(TransactionRec, Data, Available, StatusMsgOn) ;
    ErrorMode := std_logic_vector(TransactionRec.ErrorFromModel) ; 
  end procedure TryGet ;  


  ------------------------------------------------------------
  -- Check: Transaction Receive and Check Procedure
  procedure Check (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  ErrorMode       : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
  begin
    TransactionRec.Operation     <= CHECK ;
    TransactionRec.DataToModel   <= std_logic_vector_max_c(Data) ; 
    TransactionRec.ErrorToModel  <= std_logic_vector_max_c(ErrorMode) ; 
    TransactionRec.IntToModel    <= Data'length ;
    TransactionRec.BoolToModel   <= StatusMsgOn ;     
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ; 
  end procedure Check ; 

  procedure Check (
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
    constant ErrorMode : std_logic_vector(TransactionRec.ErrorToModel'range) := (others => '0') ;
  begin
    Check(TransactionRec, Data, ErrorMode, StatusMsgOn) ;
  end procedure Check ; 


  ------------------------------------------------------------
  -- TryCheck: Transaction Receive and Check Data if available Procedure
  procedure TryCheck (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Data            : in    std_logic_vector ;
    constant  ErrorMode       : in    std_logic_vector ;
    variable  Available       : out   boolean ;
    constant  StatusMsgOn     : in    boolean := FALSE 
  ) is 
  begin
    TransactionRec.Operation     <= TRY_CHECK ;
    TransactionRec.DataToModel   <= std_logic_vector_max_c(Data) ; 
    TransactionRec.ErrorToModel  <= std_logic_vector_max_c(ErrorMode) ; 
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
    constant ErrorMode : std_logic_vector(TransactionRec.ErrorToModel'range) := (others => '0') ;
  begin
    TryCheck(TransactionRec, Data, ErrorMode, Available, StatusMsgOn) ;
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
    TransactionRec.Operation   <= GET_ALERT_LOG_ID ;
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ; 
    AlertLogID := AlertLogIDType(TransactionRec.IntFromModel) ; 
  end procedure GetAlertLogID ; 
  
  ------------------------------------------------------------
  -- GetErrors:  
  --    For non-osvvm testbenches, returns error count for this model
  --    If Error Count is also non-zero, also prints error counts
  procedure GetErrors (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    variable  ErrorCount      : out   natural
  ) is
    variable  AlertLogID : AlertLogIDType ;
  begin
    GetAlertLogID(TransactionRec, AlertLogID) ;
    ReportNonZeroAlerts(AlertLogID => AlertLogID) ;
    ErrorCount := GetAlertCount(AlertLogID => AlertLogID) ;
  end procedure GetErrors ; 
  
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
  -- SetOption:  Directive, set model options
  procedure SetOption (
  ------------------------------------------------------------
    signal    TransactionRec  : inout StreamRecType ;
    constant  Option          : in    integer ; 
    constant  TimeVal         : in    time 
  ) is 
  begin
    TransactionRec.Operation   <= SET_OPTIONS ;
    TransactionRec.Option      <= Option ; 
    TransactionRec.TimeToModel <= TimeVal ; 
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ; 
  end procedure SetOption ; 
  
  procedure SetOption (
    signal    TransactionRec  : inout StreamRecType ;
    constant  Option          : in    integer ; 
    constant  IntVal          : in    integer 
  ) is 
  begin
    TransactionRec.Operation   <= SET_OPTIONS ;
    TransactionRec.Option      <= Option ; 
    TransactionRec.IntToModel  <= IntVal ; 
    RequestTransaction(Rdy => TransactionRec.Rdy, Ack => TransactionRec.Ack) ; 
  end procedure SetOption ; 

  ------------------------------------------------------------
  -- OSVVM Standard Model Support
  ------------------------------------------------------------
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