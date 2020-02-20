--
--  File Name:         AddressBusSlaveTransactionGenericPkg.vhd
--  Design Unit Name:  AddressBusSlaveTransactionGenericPkg
--  Revision:          OSVVM MODELS STANDARD VERSION
--
--  Maintainer:        Jim Lewis      email:  jim@synthworks.com
--  Contributor(s):
--     Jim Lewis      jim@synthworks.com
--
--
--  Description:
--      Defines types, constants, and subprograms used by
--      OSVVM Address Bus Slave Transaction Based Models (aka: TBM, TLM, VVC)
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
--    02/2020   2020.02    Refactored from Axi4LiteSlaveTransactionPkg
--
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


package AddressBusSlaveTransactionGenericPkg is
  generic (
    type ModelOptionsType  
  ) ; 

  -- Model AXI Lite Operations
  type UnresolvedAddressBusSlaveOperationType is (
    -- Model Directives
    WAIT_CLOCK, 
    GET_ALERTLOG_ID, 
    GET_TRANSACTION_COUNT, 
    GET_WRITE_TRANSACTION_COUNT, GET_READ_TRANSACTION_COUNT,
    SET_MODEL_OPTIONS, GET_MODEL_OPTIONS,
    -- 
    --  Slave bus operations
    WRITE,                   -- Blocking (Rx Addr & Data)
    READ,                    -- Blocking (Rx Addr, Tx Data)
    --  Planned Extensions of Slave bus operations
    WRITE_ADDRESS,           -- Blocking (Rx Addr)
    WRITE_DATA,              -- Blocking (Rx Data)
    TRY_WRITE,               -- Check for Write(Rx Addr & Data)
    TRY_WRITE_ADDRESS,       -- Non-blocking try & get
    TRY_WRITE_DATA,          -- Non-blocking try & get
    READ_ADDRESS,            -- Blocking (Rx Addr)
    TRY_READ_ADDRESS,        -- Non-blocking try & get
    ASYNC_READ_DATA,         -- Non-blocking (Tx Data)
    THE_END
  ) ;
  type UnresolvedAddressBusSlaveOperationVectorType is array (natural range <>) of UnresolvedAddressBusSlaveOperationType ;
--  alias resolved_max is maximum[ UnresolvedAddressBusSlaveOperationVectorType return UnresolvedAddressBusSlaveOperationType] ;
  function resolved_max ( A : UnresolvedAddressBusSlaveOperationVectorType) return UnresolvedAddressBusSlaveOperationType ;
  -- Maximum is implicitly defined for any array type in VHDL-2008.   Function resolved_max is a fall back.
  subtype AddressBusSlaveOperationType is resolved_max UnresolvedAddressBusSlaveOperationType ;

  -- Record creates a channel for communicating transactions to the model.
  type AddressBusSlaveTransactionRecType is record
    Rdy                : bit_max ;
    Ack                : bit_max ;
    Operation          : AddressBusSlaveOperationType ;
    Address            : std_logic_vector_max_c ;
    AddrWidth          : integer_max ;
    DataToModel        : std_logic_vector_max_c ;
    DataFromModel      : std_logic_vector_max_c ;
    DataWidth          : integer_max ;
    StatusMsgOn        : boolean_max ;
    -- Model Options
    Options            : ModelOptionsType ;
    -- Optional parameter handling
    IntToModel         : integer_max ;
    BoolToModel        : boolean_max ;
    IntFromModel       : integer_max ;
    BoolFromModel      : boolean_max ;
  end record AddressBusSlaveTransactionRecType ;
  
--!TODO add VHDL-2018 Interfaces


  ------------------------------------------------------------
  procedure WaitForClock (
  -- Directive:  Wait for NumberOfClocks number of clocks
  ------------------------------------------------------------
    signal   TransRec        : InOut AddressBusSlaveTransactionRecType ;
             NumberOfClocks  : In    natural := 1
  ) ;

  alias NoOp is WaitForClock [AddressBusSlaveTransactionRecType, natural] ;

  ------------------------------------------------------------
  procedure GetErrors (
  -- Error reporting for testbenches that do not use AlertLogPkg
  -- Returns error count.  If an error count /= 0, also print it
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusSlaveTransactionRecType ;
    variable ErrCnt      : Out   natural
  ) ;

  ------------------------------------------------------------
  procedure SlaveGetWrite (
  -- Fetch the address and data the slave sees for a write
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusSlaveTransactionRecType ;
    variable oAddr       : Out   std_logic_vector ;
    variable oData       : Out   std_logic_vector ;
    constant StatusMsgOn : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure SlaveRead (
  -- Fetch the address and data the slave sees for a write
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusSlaveTransactionRecType ;
    variable oAddr       : Out   std_logic_vector ;
    Constant iData       : In    std_logic_vector ;
    constant StatusMsgOn : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusSlaveTransactionRecType ;
    constant Option      : In    ModelOptionsType ;
    constant OptVal      : In    boolean
  ) ;

  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusSlaveTransactionRecType ;
    constant Option      : In    ModelOptionsType ;
    constant OptVal      : In    integer
  ) ;

  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusSlaveTransactionRecType ;
    constant Option      : In    ModelOptionsType ;
    constant OptVal      : In    std_logic_vector
  ) ;

end package AddressBusSlaveTransactionGenericPkg ;

-- /////////////////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////////////////

package body AddressBusSlaveTransactionGenericPkg is
  function resolved_max ( A : UnresolvedAddressBusSlaveOperationVectorType) return UnresolvedAddressBusSlaveOperationType is
  begin
    return maximum(A) ;
  end function resolved_max ;


  ------------------------------------------------------------
  procedure WaitForClock (
  -- Directive:  Wait for NumberOfClocks number of clocks in the model
  ------------------------------------------------------------
    signal   TransRec        : InOut AddressBusSlaveTransactionRecType ;
             NumberOfClocks  : In    natural := 1
  ) is
  begin
    TransRec.Operation     <= WAIT_CLOCK ;
    TransRec.DataToModel   <= ToTransaction(NumberOfClocks, TransRec.DataToModel'length);
    RequestTransaction(Rdy => TransRec.Rdy, Ack => TransRec.Ack) ;
  end procedure WaitForClock ;


  ------------------------------------------------------------
  procedure GetAlertLogID (
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusSlaveTransactionRecType ;
    variable AlertLogID  : Out   AlertLogIDType
  ) is
  begin
    TransRec.Operation     <= GET_ALERTLOG_ID ;
    RequestTransaction(Rdy => TransRec.Rdy, Ack => TransRec.Ack) ;

    -- Return AlertLogID
    AlertLogID := AlertLogIDType(TransRec.IntFromModel) ;
  end procedure GetAlertLogID ;

  ------------------------------------------------------------
  procedure GetErrors (
  -- Error reporting for testbenches that do not use AlertLogPkg
  -- Returns error count.  If an error count /= 0, also print it
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusSlaveTransactionRecType ;
    variable ErrCnt      : Out   natural
  ) is
    variable ModelID : AlertLogIDType ;
  begin
    GetAlertLogID(TransRec, ModelID) ;
    ReportNonZeroAlerts(AlertLogID => ModelID) ;
    ErrCnt := GetAlertCount(AlertLogID => ModelID) ;
  end procedure GetErrors ;

  ------------------------------------------------------------
  procedure GetTransactionCount (
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusSlaveTransactionRecType ;
    variable Count       : Out   integer
  ) is
  begin
    TransRec.Operation     <= GET_TRANSACTION_COUNT ;
    RequestTransaction(Rdy => TransRec.Rdy, Ack => TransRec.Ack) ;

    -- Return AlertLogID
    Count := TransRec.IntFromModel ;
  end procedure GetTransactionCount ;

  ------------------------------------------------------------
  procedure GetWriteTransactionCount (
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusSlaveTransactionRecType ;
    variable Count       : Out   integer
  ) is
  begin
    TransRec.Operation     <= GET_WRITE_TRANSACTION_COUNT ;
    RequestTransaction(Rdy => TransRec.Rdy, Ack => TransRec.Ack) ;

    -- Return AlertLogID
    Count := TransRec.IntFromModel ;
  end procedure GetWriteTransactionCount ;

  ------------------------------------------------------------
  procedure GetReadTransactionCount (
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusSlaveTransactionRecType ;
    variable Count       : Out   integer
  ) is
  begin
    TransRec.Operation     <= GET_READ_TRANSACTION_COUNT ;
    RequestTransaction(Rdy => TransRec.Rdy, Ack => TransRec.Ack) ;

    -- Return AlertLogID
    Count := TransRec.IntFromModel ;
  end procedure GetReadTransactionCount ;

  ------------------------------------------------------------
  procedure SlaveGetWrite (
  -- Fetch the address and data the slave sees for a write
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusSlaveTransactionRecType ;
    variable oAddr       : Out   std_logic_vector ;
    variable oData       : Out   std_logic_vector ;
    constant StatusMsgOn : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransRec.Operation        <= WRITE ;
    TransRec.AddrWidth        <= oAddr'length ;
    TransRec.DataWidth        <= oData'length ;
    TransRec.StatusMsgOn      <= StatusMsgOn ;
    RequestTransaction(Rdy => TransRec.Rdy, Ack => TransRec.Ack) ;
    oAddr  := FromTransaction(TransRec.Address) ;
    oData  := Reduce(FromTransaction(TransRec.DataFromModel), oData'length) ;
  end procedure SlaveGetWrite ;

  ------------------------------------------------------------
  procedure SlaveRead (
  -- Fetch the address and data the slave sees for a write
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusSlaveTransactionRecType ;
    variable oAddr       : Out   std_logic_vector ;
    constant iData       : In    std_logic_vector ;
    constant StatusMsgOn : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransRec.Operation        <= READ ;
    TransRec.AddrWidth        <= oAddr'length ;
    TransRec.DataWidth        <= iData'length ;
    TransRec.DataToModel      <= ToTransaction(Extend(iData, TransRec.DataToModel'length)) ;
    TransRec.StatusMsgOn      <= StatusMsgOn ;
    RequestTransaction(Rdy => TransRec.Rdy, Ack => TransRec.Ack) ;
    oAddr  := FromTransaction(TransRec.Address) ;
  end procedure SlaveRead ;

  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusSlaveTransactionRecType ;
    constant Option      : In    ModelOptionsType ;
    constant OptVal      : In    boolean
  ) is
  begin
    TransRec.Operation      <= SET_MODEL_OPTIONS ;
    TransRec.Options        <= Option ;
    TransRec.BoolToModel    <= OptVal ;
    RequestTransaction(Rdy => TransRec.Rdy, Ack => TransRec.Ack) ;
  end procedure SetModelOptions ;

  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusSlaveTransactionRecType ;
    constant Option      : In    ModelOptionsType ;
    constant OptVal      : In    integer
  ) is
  begin
    TransRec.Operation      <= SET_MODEL_OPTIONS ;
    TransRec.Options        <= Option ;
    TransRec.IntToModel     <= OptVal ;
    RequestTransaction(Rdy => TransRec.Rdy, Ack => TransRec.Ack) ;
  end procedure SetModelOptions ;

  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusSlaveTransactionRecType ;
    constant Option      : In    ModelOptionsType ;
    constant OptVal      : In    std_logic_vector
  ) is
  begin
    TransRec.Operation     <= SET_MODEL_OPTIONS ;
    TransRec.Options       <= Option ;
    TransRec.IntToModel    <= to_integer(OptVal) ;
    RequestTransaction(Rdy => TransRec.Rdy, Ack => TransRec.Ack) ;
  end procedure SetModelOptions ;

end package body AddressBusSlaveTransactionGenericPkg ;