--
--  File Name:         InterruptHandler.vhd
--  Design Unit Name:  InterruptHandler
--  Revision:          OSVVM MODELS STANDARD VERSION
--
--  Maintainer:        Jim Lewis      email:  jim@synthworks.com
--  Contributor(s):
--     Jim Lewis      jim@synthworks.com
--
--
--  Description:
--      InterruptHandler
--
--
--  Developed by:
--        SynthWorks Design Inc.
--        VHDL Training Classes
--        http://www.SynthWorks.com
--
--  Revision History:
--    Date      Version    Description
--    04/2021   2021.04    Initial revision
--
--
--  This file is part of OSVVM.
--
--  Copyright (c) 2017 - 2021 by SynthWorks Design Inc.
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

library osvvm_common ;
  context osvvm_common.OsvvmCommonContext ;


entity InterruptHandler is
port (
  -- Interrupt Input
  IntReq      : in   std_logic ;

  -- From TestCtrl
  TransRec    : inout AddressBusRecType ;
  IntRec      : inout AddressBusRecType ;
  
  -- To Verification Component
  VCRec       : inout AddressBusRecType
) ;
end entity InterruptHandler ;
architecture Behavioral of InterruptHandler is
  constant POLARITY : std_logic := '1' ;
  signal   iIntReq  : std_logic := '0' ;
begin

  -- Generate Interrupts only when Interrupt Present and
  -- there are interrupt transactions pending 
  iIntReq <= '1' when IntReq = POLARITY and 
                      IntRec.Rdy /= IntRec.Ack else '0' ;

  TransactionHandler : process 
    variable IntState : boolean := FALSE ;
  begin
    Increment(TransRec.Ack) ; -- due to differences in handling
    Increment(IntRec.Ack) ;   -- due to differences in handling
    wait for 0 ns ; 
    loop
      if not IntState then 
        if not(TransRec.Ack /= TransRec.Rdy or iIntReq = '1') then 
          wait until TransRec.Ack /= TransRec.Rdy or iIntReq = '1' ;
        end if ; 
        if iIntReq = '1' then 
          IntState := TRUE ; 
        else
          -- Copy transaction info to VC
          VCRec.Operation     <=  TransRec.Operation   ;
          VCRec.Address       <=  TransRec.Address     ;
          VCRec.AddrWidth     <=  TransRec.AddrWidth   ;
          VCRec.DataToModel   <=  TransRec.DataToModel ;
          VCRec.DataWidth     <=  TransRec.DataWidth   ;
          VCRec.StatusMsgOn   <=  TransRec.StatusMsgOn ;
          VCRec.IntToModel    <=  TransRec.IntToModel  ;
          VCRec.BoolToModel   <=  TransRec.BoolToModel ;
          VCRec.Options       <=  TransRec.Options     ;
          RequestTransaction(Rdy => VCRec.Rdy, Ack => VCRec.Ack) ; 

          -- Copy transaction results back
          TransRec.DataFromModel <= VCRec.DataFromModel ;
          TransRec.IntFromModel  <= VCRec.IntFromModel  ;
          TransRec.BoolFromModel <= VCRec.BoolFromModel ;
          increment(TransRec.Ack) ; 
          wait for 0 ns ; 
        end if ; 
      end if ; 
      
      if IntState then 
        if not(IntRec.Ack /= IntRec.Rdy) then 
          wait until IntRec.Ack /= IntRec.Rdy ;
        end if ; 
        if IntRec.Operation = INTERRUPT_RETURN then 
          IntState := FALSE ; 
        else
          -- Copy transaction info to VC
          VCRec.Operation     <=  IntRec.Operation   ;
          VCRec.Address       <=  IntRec.Address     ;
          VCRec.AddrWidth     <=  IntRec.AddrWidth   ;
          VCRec.DataToModel   <=  IntRec.DataToModel ;
          VCRec.DataWidth     <=  IntRec.DataWidth   ;
          VCRec.StatusMsgOn   <=  IntRec.StatusMsgOn ;
          VCRec.IntToModel    <=  IntRec.IntToModel  ;
          VCRec.BoolToModel   <=  IntRec.BoolToModel ;
          VCRec.Options       <=  IntRec.Options     ;
          RequestTransaction(Rdy => VCRec.Rdy, Ack => VCRec.Ack) ; 
          
          -- Copy transaction results back
          IntRec.DataFromModel <= VCRec.DataFromModel ;
          IntRec.IntFromModel  <= VCRec.IntFromModel  ;
          IntRec.BoolFromModel <= VCRec.BoolFromModel ;
        end if ; 
        increment(IntRec.Ack) ; 
        wait for 0 ns ; 
      end if ; 
    end loop ; 
  end process TransactionHandler ;  

end architecture Behavioral ; 