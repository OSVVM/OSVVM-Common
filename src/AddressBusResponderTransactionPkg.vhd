--
--  File Name:         AddressBusResponderTransactionPkg.vhd
--  Design Unit Name:  AddressBusResponderTransactionPkg
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
--    09/2017   2017       Initial revision as Axi4LiteTransactionPkg
--    01/2020   2020.01    Updated license notice
--    02/2020   2020.02    Refactored from Axi4LiteSlaveTransactionPkg
--    05/2020   2020.05    Removed Generics due to simulator bugs
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
    
  use work.AddressBusTransactionPkg.all; 

package AddressBusResponderTransactionPkg is
  
  ------------------------------------------------------------
  procedure GetWrite (
  -- Fetch the address and data a peripheral sees for a write
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusTransactionRecType ;
    variable oAddr       : Out   std_logic_vector ;
    variable oData       : Out   std_logic_vector ;
    constant StatusMsgOn : In    boolean := false
  ) ;
  
  ------------------------------------------------------------
  procedure TryGetWrite (
  -- Fetch the address and data a peripheral sees for a write
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusTransactionRecType ;
    variable oAddr       : Out   std_logic_vector ;
    variable oData       : Out   std_logic_vector ;
    variable Available   : Out   boolean ;
    constant StatusMsgOn : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure GetWriteAddress (
  -- Fetch the address a peripheral sees for a write
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusTransactionRecType ;
    variable oAddr       : Out   std_logic_vector ;
    constant StatusMsgOn : In    boolean := false
  ) ;
  
  ------------------------------------------------------------
  procedure TryGetWriteAddress (
  -- Fetch the address a peripheral sees for a write
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusTransactionRecType ;
    variable oAddr       : Out   std_logic_vector ;
    variable Available   : Out   boolean ;
    constant StatusMsgOn : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure GetWriteData (
  -- Fetch the data a peripheral sees for a write
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusTransactionRecType ;
    constant oAddr       : In    std_logic_vector ;
    variable oData       : Out   std_logic_vector ;
    constant StatusMsgOn : In    boolean := false
  ) ;
  
  ------------------------------------------------------------
  procedure TryGetWriteData (
  -- Fetch the data a peripheral sees for a write
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusTransactionRecType ;
    constant oAddr       : In    std_logic_vector ;
    variable oData       : Out   std_logic_vector ;
    variable Available   : Out   boolean ;
    constant StatusMsgOn : In    boolean := false
  ) ;
  
  ------------------------------------------------------------
  procedure GetWriteData (
  -- Fetch the data a peripheral sees for a write
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusTransactionRecType ;
    variable oData       : Out   std_logic_vector ;
    constant StatusMsgOn : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure TryGetWriteData (
  -- Fetch the data a peripheral sees for a write
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusTransactionRecType ;
    variable oData       : Out   std_logic_vector ;
    variable Available   : Out   boolean ;
    constant StatusMsgOn : In    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure SendRead (
  -- Block until address is available and data is done
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusTransactionRecType ;
    variable oAddr       : Out   std_logic_vector ;
    constant iData       : In    std_logic_vector ;
    constant StatusMsgOn : In    boolean := false
  ) ;
  
  ------------------------------------------------------------
  procedure TrySendRead (
  -- Return address if available, send data if address available
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusTransactionRecType ;
    variable oAddr       : Out   std_logic_vector ;
    constant iData       : In    std_logic_vector ;
    variable Available   : Out   boolean ;
    constant StatusMsgOn : In    boolean := false
  ) ;
  
  ------------------------------------------------------------
  procedure GetReadAddress (
  -- Block until address is available
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusTransactionRecType ;
    variable oAddr       : Out   std_logic_vector ;
    constant StatusMsgOn : In    boolean := false
  ) ;
  
  ------------------------------------------------------------
  procedure TryGetReadAddress (
  -- Return read address if available, otherwise return false on Available
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusTransactionRecType ;
    variable oAddr       : Out   std_logic_vector ;
    variable Available   : Out   boolean ;
    constant StatusMsgOn : In    boolean := false
  ) ;
  
  ------------------------------------------------------------
  procedure SendReadData (
  -- Block until data is done
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusTransactionRecType ;
    constant iData       : In    std_logic_vector ;
    constant StatusMsgOn : In    boolean := false
  ) ;
  
  ------------------------------------------------------------
  procedure AsyncSendReadData (
  -- Queue Read Data
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusTransactionRecType ;
    constant iData       : In    std_logic_vector ;
    constant StatusMsgOn : In    boolean := false
  ) ;   
  
end package AddressBusResponderTransactionPkg ;

-- /////////////////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////////////////

package body AddressBusResponderTransactionPkg is

  ------------------------------------------------------------
  procedure GetWrite (
  -- Blocks until Address and Data are both available
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusTransactionRecType ;
    variable oAddr       : Out   std_logic_vector ;
    variable oData       : Out   std_logic_vector ;
    constant StatusMsgOn : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransRec.Operation        <= WRITE_OP ;
    TransRec.AddrWidth        <= oAddr'length ;
    TransRec.DataWidth        <= oData'length ;
    TransRec.StatusMsgOn      <= StatusMsgOn ;
    RequestTransaction(Rdy => TransRec.Rdy, Ack => TransRec.Ack) ;
    oAddr  := FromTransaction(TransRec.Address) ;
    oData  := Reduce(FromTransaction(TransRec.DataFromModel), oData'length) ;
  end procedure GetWrite ;

  ------------------------------------------------------------
  procedure TryGetWrite (
  -- Return address and data if both available otherwise return false
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusTransactionRecType ;
    variable oAddr       : Out   std_logic_vector ;
    variable oData       : Out   std_logic_vector ;
    variable Available   : Out   boolean ;
    constant StatusMsgOn : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransRec.Operation        <= ASYNC_WRITE ;
    TransRec.AddrWidth        <= oAddr'length ;
    TransRec.DataWidth        <= oData'length ;
    TransRec.StatusMsgOn      <= StatusMsgOn ;
    RequestTransaction(Rdy => TransRec.Rdy, Ack => TransRec.Ack) ;
    oAddr     := FromTransaction(TransRec.Address) ;
    oData     := Reduce(FromTransaction(TransRec.DataFromModel), oData'length) ;
    Available := TransRec.BoolFromModel ;
  end procedure TryGetWrite ;

  ------------------------------------------------------------
  procedure GetWriteAddress (
  -- Blocks until Address is available
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusTransactionRecType ;
    variable oAddr       : Out   std_logic_vector ;
    constant StatusMsgOn : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransRec.Operation        <= WRITE_ADDRESS ;
    TransRec.AddrWidth        <= oAddr'length ;
    TransRec.StatusMsgOn      <= StatusMsgOn ;
    RequestTransaction(Rdy => TransRec.Rdy, Ack => TransRec.Ack) ;
    oAddr  := FromTransaction(TransRec.Address) ;
  end procedure GetWriteAddress ;
  
  ------------------------------------------------------------
  procedure TryGetWriteAddress (
  -- Return address if available otherwise return false
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusTransactionRecType ;
    variable oAddr       : Out   std_logic_vector ;
    variable Available   : Out   boolean ;
    constant StatusMsgOn : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransRec.Operation        <= ASYNC_WRITE_ADDRESS ;
    TransRec.AddrWidth        <= oAddr'length ;
    TransRec.StatusMsgOn      <= StatusMsgOn ;
    RequestTransaction(Rdy => TransRec.Rdy, Ack => TransRec.Ack) ;
    oAddr     := FromTransaction(TransRec.Address) ;
    Available := TransRec.BoolFromModel ;
  end procedure TryGetWriteAddress ;

  ------------------------------------------------------------
  procedure GetWriteData (
  -- Blocks until Data is available
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusTransactionRecType ;
    constant oAddr       : In    std_logic_vector ;
    variable oData       : Out   std_logic_vector ;
    constant StatusMsgOn : In    boolean := false
  ) is
    alias aAddr : std_logic_vector(oAddr'length-1 downto 0) is oAddr ;
    constant ADDR_LEN : integer := minimum(aAddr'left, 30) ;
  begin
    -- Put values in record
    TransRec.Operation        <= WRITE_DATA ;
    TransRec.AddrWidth        <= to_integer(aAddr(ADDR_LEN downto 0)) ; -- Allows bursts upto 2**31
    TransRec.DataWidth        <= oData'length ;
    TransRec.StatusMsgOn      <= StatusMsgOn ;
    RequestTransaction(Rdy => TransRec.Rdy, Ack => TransRec.Ack) ;
    oData  := Reduce(FromTransaction(TransRec.DataFromModel), oData'length) ;
  end procedure GetWriteData ;
  
  ------------------------------------------------------------
  procedure TryGetWriteData (
  -- Return data if available otherwise return false
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusTransactionRecType ;
    constant oAddr       : In    std_logic_vector ;
    variable oData       : Out   std_logic_vector ;
    variable Available   : Out   boolean ;
    constant StatusMsgOn : In    boolean := false
  ) is
    alias aAddr : std_logic_vector(oAddr'length-1 downto 0) is oAddr ;
    constant ADDR_LEN : integer := minimum(aAddr'left, 30) ;
  begin
    -- Put values in record
    TransRec.Operation        <= ASYNC_WRITE_DATA ;
    TransRec.AddrWidth        <= to_integer(aAddr(ADDR_LEN downto 0)) ; -- Allows bursts upto 2**31
    TransRec.DataWidth        <= oData'length ;
    TransRec.StatusMsgOn      <= StatusMsgOn ;
    RequestTransaction(Rdy => TransRec.Rdy, Ack => TransRec.Ack) ;
    oData     := Reduce(FromTransaction(TransRec.DataFromModel), oData'length) ;
    Available := TransRec.BoolFromModel ;
  end procedure TryGetWriteData ;
  
  ------------------------------------------------------------
  procedure GetWriteData (
  -- Blocks until Data is available
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusTransactionRecType ;
    variable oData       : Out   std_logic_vector ;
    constant StatusMsgOn : In    boolean := false
  ) is
  begin
    GetWriteData(TransRec, X"00", oData, StatusMsgOn) ;
  end procedure GetWriteData ;

  ------------------------------------------------------------
  procedure TryGetWriteData (
  -- Return data if available otherwise return false
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusTransactionRecType ;
    variable oData       : Out   std_logic_vector ;
    variable Available   : Out   boolean ;
    constant StatusMsgOn : In    boolean := false
  ) is
  begin
    TryGetWriteData(TransRec, X"00", oData, Available, StatusMsgOn) ;
  end procedure TryGetWriteData ;

  ------------------------------------------------------------
  procedure SendRead (
  -- Block until address is available and data is done
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusTransactionRecType ;
    variable oAddr       : Out   std_logic_vector ;
    constant iData       : In    std_logic_vector ;
    constant StatusMsgOn : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransRec.Operation        <= READ_OP ;
    TransRec.AddrWidth        <= oAddr'length ;
    TransRec.DataWidth        <= iData'length ;
    TransRec.DataToModel      <= ToTransaction(Extend(iData, TransRec.DataToModel'length)) ;
    TransRec.StatusMsgOn      <= StatusMsgOn ;
    RequestTransaction(Rdy => TransRec.Rdy, Ack => TransRec.Ack) ;
    oAddr  := FromTransaction(TransRec.Address) ;
  end procedure SendRead ;
  
  ------------------------------------------------------------
  procedure TrySendRead (
  -- Return address if available, send data if address available
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusTransactionRecType ;
    variable oAddr       : Out   std_logic_vector ;
    constant iData       : In    std_logic_vector ;
    variable Available   : Out   boolean ;
    constant StatusMsgOn : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransRec.Operation        <= ASYNC_READ ;
    TransRec.AddrWidth        <= oAddr'length ;
    TransRec.DataWidth        <= iData'length ;
    TransRec.DataToModel      <= ToTransaction(Extend(iData, TransRec.DataToModel'length)) ;
    TransRec.StatusMsgOn      <= StatusMsgOn ;
    RequestTransaction(Rdy => TransRec.Rdy, Ack => TransRec.Ack) ;
    oAddr  := FromTransaction(TransRec.Address) ;
    Available  := TransRec.BoolFromModel ;
  end procedure TrySendRead ;
    
  ------------------------------------------------------------
  procedure GetReadAddress (
  -- Block until address is available
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusTransactionRecType ;
    variable oAddr       : Out   std_logic_vector ;
    constant StatusMsgOn : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransRec.Operation        <= READ_ADDRESS ;
    TransRec.AddrWidth        <= oAddr'length ;
    TransRec.StatusMsgOn      <= StatusMsgOn ;
    RequestTransaction(Rdy => TransRec.Rdy, Ack => TransRec.Ack) ;
    oAddr  := FromTransaction(TransRec.Address) ;
  end procedure GetReadAddress ;
  
  ------------------------------------------------------------
  procedure TryGetReadAddress (
  -- Return read address if available, otherwise return false on Available
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusTransactionRecType ;
    variable oAddr       : Out   std_logic_vector ;
    variable Available   : Out   boolean ;
    constant StatusMsgOn : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransRec.Operation        <= ASYNC_READ_ADDRESS ;
    TransRec.AddrWidth        <= oAddr'length ;
    TransRec.StatusMsgOn      <= StatusMsgOn ;
    RequestTransaction(Rdy => TransRec.Rdy, Ack => TransRec.Ack) ;
    oAddr      := FromTransaction(TransRec.Address) ;
    Available  := TransRec.BoolFromModel ;
  end procedure TryGetReadAddress ;
  
  ------------------------------------------------------------
  procedure SendReadData (
  -- Block until data is done
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusTransactionRecType ;
    constant iData       : In    std_logic_vector ;
    constant StatusMsgOn : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransRec.Operation        <= READ_DATA ;
    TransRec.DataWidth        <= iData'length ;
    TransRec.DataToModel      <= ToTransaction(Extend(iData, TransRec.DataToModel'length)) ;
    TransRec.StatusMsgOn      <= StatusMsgOn ;
    RequestTransaction(Rdy => TransRec.Rdy, Ack => TransRec.Ack) ;
  end procedure SendReadData ;
  
  ------------------------------------------------------------
  procedure AsyncSendReadData (
  -- Queue Read Data
  ------------------------------------------------------------
    signal   TransRec    : InOut AddressBusTransactionRecType ;
    constant iData       : In    std_logic_vector ;
    constant StatusMsgOn : In    boolean := false
  ) is
  begin
    -- Put values in record
    TransRec.Operation        <= ASYNC_READ_DATA ;
    TransRec.DataWidth        <= iData'length ;
    TransRec.DataToModel      <= ToTransaction(Extend(iData, TransRec.DataToModel'length)) ;
    TransRec.StatusMsgOn      <= StatusMsgOn ;
    RequestTransaction(Rdy => TransRec.Rdy, Ack => TransRec.Ack) ;
  end procedure AsyncSendReadData ;  
  
end package body AddressBusResponderTransactionPkg ;