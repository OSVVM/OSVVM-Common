--
--  File Name:         AddressBusResponderTransactionArrayPkg.vhd
--  Design Unit Name:  AddressBusResponderTransactionArrayPkg
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
--    11/2022   2022.11    Initial.  Derived from AddressBusResponderTransactionPkg
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
    
  use work.AddressBusTransactionPkg.all; 
  use work.AddressBusTransactionArrayPkg.AddressBusArrayRequestTransaction; 

package AddressBusResponderTransactionArrayPkg is
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
  procedure GetWrite (
  -- Blocking write transaction.  
  -- Block until the write address and data are available.
  -- oData variable should be sized to match the size of the data 
  -- being transferred.
  ------------------------------------------------------------
    signal   TransactionRec  : InOut AddressBusRecArrayType ;
    constant Index           : In    integer   ;
    variable oAddr           : Out   std_logic_vector ;
    variable oData           : Out   std_logic_vector ;
    constant StatusMsgOn     : In    boolean := false
  ) ;
  
  ------------------------------------------------------------
  procedure TryGetWrite (
  -- Try write transaction.  
  -- If a write cycle has already completed return Address and Data, 
  -- and return Available as TRUE, otherwise, return Available as FALSE. 
  -- oData variable should be sized to match the size of the data 
  -- being transferred.
  ------------------------------------------------------------
    signal   TransactionRec  : InOut AddressBusRecArrayType ;
    constant Index           : In    integer   ;
    variable oAddr           : Out   std_logic_vector ;
    variable oData           : Out   std_logic_vector ;
    variable Available       : Out   boolean ;
    constant StatusMsgOn     : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure SendRead (
  -- Blocking Read transaction.   
  -- Block until address is available and data is sent.
  -- iData variable should be sized to match the size of the data 
  -- being transferred.
  ------------------------------------------------------------
    signal   TransactionRec  : InOut AddressBusRecArrayType ;
    constant Index           : In    integer   ;
    variable oAddr           : Out   std_logic_vector ;
    constant iData           : In    std_logic_vector ;
    constant StatusMsgOn     : In    boolean := false
  ) ;
  
  ------------------------------------------------------------
  procedure TrySendRead (
  -- Try Read transaction.   
  -- If a read address already been received return Address, 
  -- send iData as the read data, and return Available as TRUE,
  -- otherwise return Available as FALSE.
  -- iData variable should be sized to match the size of the data 
  -- being transferred.
  ------------------------------------------------------------
    signal   TransactionRec  : InOut AddressBusRecArrayType ;
    constant Index           : In    integer   ;
    variable oAddr           : Out   std_logic_vector ;
    constant iData           : In    std_logic_vector ;
    variable Available       : Out   boolean ;
    constant StatusMsgOn     : In    boolean := false
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
  procedure GetWriteAddress (
  -- Blocking write address transaction.  
  ------------------------------------------------------------
    signal   TransactionRec  : InOut AddressBusRecArrayType ;
    constant Index           : In    integer   ;
    variable oAddr           : Out   std_logic_vector ;
    constant StatusMsgOn     : In    boolean := false
  ) ;
  
  ------------------------------------------------------------
  procedure TryGetWriteAddress (
  -- Try write address transaction.  
  -- If a write address cycle has already completed return oAddr and 
  -- return Available as TRUE, otherwise, return Available as FALSE.
  ------------------------------------------------------------
    signal   TransactionRec  : InOut AddressBusRecArrayType ;
    constant Index           : In    integer   ;
    variable oAddr           : Out   std_logic_vector ;
    variable Available       : Out   boolean ;
    constant StatusMsgOn     : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure GetWriteData (
  -- Blocking write data transaction.  
  -- oData should be sized to match the size of the data 
  -- being transferred.  
  ------------------------------------------------------------
    signal   TransactionRec  : InOut AddressBusRecArrayType ;
    constant Index           : In    integer   ;
    constant iAddr           : In    std_logic_vector ;
    variable oData           : Out   std_logic_vector ;
    constant StatusMsgOn     : In    boolean := false
  ) ;
  
  ------------------------------------------------------------
  procedure TryGetWriteData (
  -- Try write data transaction.  
  -- If a write data cycle has already completed return oData and 
  -- return Available as TRUE, otherwise, return Available as FALSE.
  -- oData should be sized to match the size of the data 
  -- being transferred.  
  ------------------------------------------------------------
    signal   TransactionRec  : InOut AddressBusRecArrayType ;
    constant Index           : In    integer   ;
    constant iAddr           : In    std_logic_vector ;
    variable oData           : Out   std_logic_vector ;
    variable Available       : Out   boolean ;
    constant StatusMsgOn     : In    boolean := false
  ) ;
  
  ------------------------------------------------------------
  procedure GetWriteData (
  -- Blocking write data transaction.  
  -- oData should be sized to match the size of the data 
  -- being transferred.  iAddr = 0
  ------------------------------------------------------------
    signal   TransactionRec  : InOut AddressBusRecArrayType ;
    constant Index           : In    integer   ;
    variable oData           : Out   std_logic_vector ;
    constant StatusMsgOn     : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure TryGetWriteData (
  -- Try write data transaction.  
  -- If a write data cycle has already completed return oData and 
  -- return Available as TRUE, otherwise, return Available as FALSE.
  -- oData should be sized to match the size of the data 
  -- being transferred.  iAddr = 0
  ------------------------------------------------------------
    signal   TransactionRec  : InOut AddressBusRecArrayType ;
    constant Index           : In    integer   ;
    variable oData           : Out   std_logic_vector ;
    variable Available       : Out   boolean ;
    constant StatusMsgOn     : In    boolean := false
  ) ;
  
  ------------------------------------------------------------
  procedure GetReadAddress (
  -- Blocking Read address transaction.   
  ------------------------------------------------------------
    signal   TransactionRec  : InOut AddressBusRecArrayType ;
    constant Index           : In    integer   ;
    variable oAddr           : Out   std_logic_vector ;
    constant StatusMsgOn     : In    boolean := false
  ) ;
  
  ------------------------------------------------------------
  procedure TryGetReadAddress (
  -- Try read address transaction.  
  -- If a read address cycle has already completed return oAddr and 
  -- return Available as TRUE, otherwise, return Available as FALSE.
  ------------------------------------------------------------
    signal   TransactionRec  : InOut AddressBusRecArrayType ;
    constant Index           : In    integer   ;
    variable oAddr           : Out   std_logic_vector ;
    variable Available       : Out   boolean ;
    constant StatusMsgOn     : In    boolean := false
  ) ;
  
  ------------------------------------------------------------
  procedure SendReadData (
  -- Blocking Send Read Data transaction.  
  -- iData should be sized to match the size of the data 
  -- being transferred.
  ------------------------------------------------------------
    signal   TransactionRec  : InOut AddressBusRecArrayType ;
    constant Index           : In    integer   ;
    constant iData           : In    std_logic_vector ;
    constant StatusMsgOn     : In    boolean := false
  ) ;
  
  ------------------------------------------------------------
  procedure SendReadDataAsync (
  -- Asynchronous Send Read Data transaction.  
  -- iData should be sized to match the size of the data 
  -- being transferred.
  ------------------------------------------------------------
    signal   TransactionRec  : InOut AddressBusRecArrayType ;
    constant Index           : In    integer   ;
    constant iData           : In    std_logic_vector ;
    constant StatusMsgOn     : In    boolean := false
  ) ;   
  
end package AddressBusResponderTransactionArrayPkg ;

-- /////////////////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////////////////

package body AddressBusResponderTransactionArrayPkg is

  ------------------------------------------------------------
  procedure GetWrite (
  -- Blocks until Address and Data are both available
  ------------------------------------------------------------
    signal   TransactionRec  : InOut AddressBusRecArrayType ;
    constant Index           : In    integer   ;
    variable oAddr           : Out   std_logic_vector ;
    variable oData           : Out   std_logic_vector ;
    constant StatusMsgOn     : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec(Index).Operation     <= WRITE_OP ;
    TransactionRec(Index).AddrWidth     <= oAddr'length ;
    TransactionRec(Index).DataWidth     <= oData'length ;
    TransactionRec(Index).StatusMsgOn   <= StatusMsgOn ;
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
    oAddr  := FromTransaction(TransactionRec(Index).Address, oAddr'length) ;
    oData  := FromTransaction(TransactionRec(Index).DataFromModel, oData'length) ;
  end procedure GetWrite ;

  ------------------------------------------------------------
  procedure TryGetWrite (
  -- Return address and data if both available otherwise return false
  ------------------------------------------------------------
    signal   TransactionRec  : InOut AddressBusRecArrayType ;
    constant Index           : In    integer   ;
    variable oAddr           : Out   std_logic_vector ;
    variable oData           : Out   std_logic_vector ;
    variable Available       : Out   boolean ;
    constant StatusMsgOn     : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec(Index).Operation     <= ASYNC_WRITE ;
    TransactionRec(Index).AddrWidth     <= oAddr'length ;
    TransactionRec(Index).DataWidth     <= oData'length ;
    TransactionRec(Index).StatusMsgOn   <= StatusMsgOn ;
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
    oAddr  := FromTransaction(TransactionRec(Index).Address, oAddr'length) ;
    oData  := FromTransaction(TransactionRec(Index).DataFromModel, oData'length) ;
    Available := TransactionRec(Index).BoolFromModel ;
  end procedure TryGetWrite ;

  ------------------------------------------------------------
  procedure GetWriteAddress (
  -- Blocks until Address is available
  ------------------------------------------------------------
    signal   TransactionRec  : InOut AddressBusRecArrayType ;
    constant Index           : In    integer   ;
    variable oAddr           : Out   std_logic_vector ;
    constant StatusMsgOn     : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec(Index).Operation     <= WRITE_ADDRESS ;
    TransactionRec(Index).AddrWidth     <= oAddr'length ;
    TransactionRec(Index).StatusMsgOn   <= StatusMsgOn ;
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
    oAddr  := FromTransaction(TransactionRec(Index).Address, oAddr'length) ;
  end procedure GetWriteAddress ;
  
  ------------------------------------------------------------
  procedure TryGetWriteAddress (
  -- Return address if available otherwise return false
  ------------------------------------------------------------
    signal   TransactionRec  : InOut AddressBusRecArrayType ;
    constant Index           : In    integer   ;
    variable oAddr           : Out   std_logic_vector ;
    variable Available       : Out   boolean ;
    constant StatusMsgOn     : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec(Index).Operation     <= ASYNC_WRITE_ADDRESS ;
    TransactionRec(Index).AddrWidth     <= oAddr'length ;
    TransactionRec(Index).StatusMsgOn   <= StatusMsgOn ;
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
    oAddr  := FromTransaction(TransactionRec(Index).Address, oAddr'length) ;
    Available := TransactionRec(Index).BoolFromModel ;
  end procedure TryGetWriteAddress ;

  ------------------------------------------------------------
  procedure GetWriteData (
  -- Blocking write data transaction.  
  -- oData should be sized to match the size of the data 
  -- being transferred.  
  ------------------------------------------------------------
    signal   TransactionRec  : InOut AddressBusRecArrayType ;
    constant Index           : In    integer   ;
    constant iAddr           : In    std_logic_vector ;
    variable oData           : Out   std_logic_vector ;
    constant StatusMsgOn     : In    boolean := false
  ) is
    alias aAddr : std_logic_vector(iAddr'length-1 downto 0) is iAddr ;
    constant ADDR_LEN : integer := minimum(aAddr'left, 30) ;
  begin
    -- Put values in record
    TransactionRec(Index).Operation     <= WRITE_DATA ;
    TransactionRec(Index).AddrWidth     <= to_integer(aAddr(ADDR_LEN downto 0)) ; -- Allows bursts upto 2**31
    TransactionRec(Index).DataWidth     <= oData'length ;
    TransactionRec(Index).StatusMsgOn   <= StatusMsgOn ;
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
    oData  := FromTransaction(TransactionRec(Index).DataFromModel, oData'length) ;
  end procedure GetWriteData ;
  
  ------------------------------------------------------------
  procedure TryGetWriteData (
  -- Try write data transaction.  
  -- If a write data cycle has already completed return oData and 
  -- return Available as TRUE, otherwise, return Available as FALSE.
  -- oData should be sized to match the size of the data 
  -- being transferred.  
  ------------------------------------------------------------
    signal   TransactionRec  : InOut AddressBusRecArrayType ;
    constant Index           : In    integer   ;
    constant iAddr           : In    std_logic_vector ;
    variable oData           : Out   std_logic_vector ;
    variable Available       : Out   boolean ;
    constant StatusMsgOn     : In    boolean := false
  ) is
    alias aAddr : std_logic_vector(iAddr'length-1 downto 0) is iAddr ;
    constant ADDR_LEN : integer := minimum(aAddr'left, 30) ;
  begin
    -- Put values in record
    TransactionRec(Index).Operation     <= ASYNC_WRITE_DATA ;
    TransactionRec(Index).AddrWidth     <= to_integer(aAddr(ADDR_LEN downto 0)) ; -- Allows bursts upto 2**31
    TransactionRec(Index).DataWidth     <= oData'length ;
    TransactionRec(Index).StatusMsgOn   <= StatusMsgOn ;
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
    oData  := FromTransaction(TransactionRec(Index).DataFromModel, oData'length) ;
    Available := TransactionRec(Index).BoolFromModel ;
  end procedure TryGetWriteData ;
  
  ------------------------------------------------------------
  procedure GetWriteData (
  -- Blocks until Data is available
  ------------------------------------------------------------
    signal   TransactionRec  : InOut AddressBusRecArrayType ;
    constant Index           : In    integer   ;
    variable oData           : Out   std_logic_vector ;
    constant StatusMsgOn     : In    boolean := false
  ) is
  begin
    GetWriteData(TransactionRec, Index, X"00", oData, StatusMsgOn) ;
  end procedure GetWriteData ;

  ------------------------------------------------------------
  procedure TryGetWriteData (
  -- Return data if available otherwise return false
  ------------------------------------------------------------
    signal   TransactionRec  : InOut AddressBusRecArrayType ;
    constant Index           : In    integer   ;
    variable oData           : Out   std_logic_vector ;
    variable Available       : Out   boolean ;
    constant StatusMsgOn     : In    boolean := false
  ) is
  begin
    TryGetWriteData(TransactionRec, Index, X"00", oData, Available, StatusMsgOn) ;
  end procedure TryGetWriteData ;

  ------------------------------------------------------------
  procedure SendRead (
  -- Block until address is available and data is done
  ------------------------------------------------------------
    signal   TransactionRec  : InOut AddressBusRecArrayType ;
    constant Index           : In    integer   ;
    variable oAddr           : Out   std_logic_vector ;
    constant iData           : In    std_logic_vector ;
    constant StatusMsgOn     : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec(Index).Operation     <= READ_OP ;
    TransactionRec(Index).AddrWidth     <= oAddr'length ;
    TransactionRec(Index).DataWidth     <= iData'length ;
    TransactionRec(Index).DataToModel   <= ToTransaction(iData, TransactionRec(Index).DataToModel'length) ;
    TransactionRec(Index).StatusMsgOn   <= StatusMsgOn ;
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
    oAddr  := FromTransaction(TransactionRec(Index).Address, oAddr'length) ;
  end procedure SendRead ;
  
  ------------------------------------------------------------
  procedure TrySendRead (
  -- Return address if available, send data if address available
  ------------------------------------------------------------
    signal   TransactionRec  : InOut AddressBusRecArrayType ;
    constant Index           : In    integer   ;
    variable oAddr           : Out   std_logic_vector ;
    constant iData           : In    std_logic_vector ;
    variable Available       : Out   boolean ;
    constant StatusMsgOn     : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec(Index).Operation     <= ASYNC_READ ;
    TransactionRec(Index).AddrWidth     <= oAddr'length ;
    TransactionRec(Index).DataWidth     <= iData'length ;
    TransactionRec(Index).DataToModel   <= ToTransaction(iData, TransactionRec(Index).DataToModel'length) ;
    TransactionRec(Index).StatusMsgOn   <= StatusMsgOn ;
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
    oAddr  := FromTransaction(TransactionRec(Index).Address, oAddr'length) ;
    Available  := TransactionRec(Index).BoolFromModel ;
  end procedure TrySendRead ;
    
  ------------------------------------------------------------
  procedure GetReadAddress (
  -- Block until address is available
  ------------------------------------------------------------
    signal   TransactionRec  : InOut AddressBusRecArrayType ;
    constant Index           : In    integer   ;
    variable oAddr           : Out   std_logic_vector ;
    constant StatusMsgOn     : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec(Index).Operation     <= READ_ADDRESS ;
    TransactionRec(Index).AddrWidth     <= oAddr'length ;
    TransactionRec(Index).StatusMsgOn   <= StatusMsgOn ;
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
    oAddr  := FromTransaction(TransactionRec(Index).Address, oAddr'length) ;
  end procedure GetReadAddress ;
  
  ------------------------------------------------------------
  procedure TryGetReadAddress (
  -- Return read address if available, otherwise return false on Available
  ------------------------------------------------------------
    signal   TransactionRec  : InOut AddressBusRecArrayType ;
    constant Index           : In    integer   ;
    variable oAddr           : Out   std_logic_vector ;
    variable Available       : Out   boolean ;
    constant StatusMsgOn     : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec(Index).Operation     <= ASYNC_READ_ADDRESS ;
    TransactionRec(Index).AddrWidth     <= oAddr'length ;
    TransactionRec(Index).StatusMsgOn   <= StatusMsgOn ;
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
    oAddr  := FromTransaction(TransactionRec(Index).Address, oAddr'length) ;
    Available  := TransactionRec(Index).BoolFromModel ;
  end procedure TryGetReadAddress ;
  
  ------------------------------------------------------------
  procedure SendReadData (
  -- Block until data is done
  ------------------------------------------------------------
    signal   TransactionRec  : InOut AddressBusRecArrayType ;
    constant Index           : In    integer   ;
    constant iData           : In    std_logic_vector ;
    constant StatusMsgOn     : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec(Index).Operation     <= READ_DATA ;
    TransactionRec(Index).DataWidth     <= iData'length ;
    TransactionRec(Index).DataToModel   <= ToTransaction(iData, TransactionRec(Index).DataToModel'length) ;
    TransactionRec(Index).StatusMsgOn   <= StatusMsgOn ;
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
  end procedure SendReadData ;
  
  ------------------------------------------------------------
  procedure SendReadDataAsync (
  -- Queue Read Data
  ------------------------------------------------------------
    signal   TransactionRec  : InOut AddressBusRecArrayType ;
    constant Index           : In    integer   ;
    constant iData           : In    std_logic_vector ;
    constant StatusMsgOn     : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransactionRec(Index).Operation     <= ASYNC_READ_DATA ;
    TransactionRec(Index).DataWidth     <= iData'length ;
    TransactionRec(Index).DataToModel   <= ToTransaction(iData, TransactionRec(Index).DataToModel'length) ;
    TransactionRec(Index).StatusMsgOn   <= StatusMsgOn ;
    AddressBusArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
  end procedure SendReadDataAsync ;  
  
end package body AddressBusResponderTransactionArrayPkg ;