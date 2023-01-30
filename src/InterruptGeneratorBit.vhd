--
--  File Name:         InterruptGeneratorBit.vhd
--  Design Unit Name:  InterruptGeneratorBit
--  Revision:          OSVVM MODELS STANDARD VERSION
--
--  Maintainer:        Jim Lewis      email:  jim@synthworks.com
--  Contributor(s):
--     Jim Lewis      jim@synthworks.com
--
--
--  Description:
--      InterruptGeneratorBit
--
--
--  Developed by:
--        SynthWorks Design Inc.
--        VHDL Training Classes
--        http://www.SynthWorks.com
--
--  Revision History:
--    Date      Version    Description
--    01/2023   2023.01    Initial revision
--
--
--  This file is part of OSVVM.
--
--  Copyright (c) 2023 by SynthWorks Design Inc.
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

  use work.StreamTransactionPkg.all; 
  use work.InterruptGlobalSignalPkg.all ;


entity InterruptGeneratorBit is
generic (
  MODEL_ID_NAME    : string := "" ;
  POLARITY         : std_logic := '1' 
) ;
port (
  -- Interrupt Input
  IntReq          : out   std_logic ; 
  
  -- Transaction port
  TransRec         : inout InterruptGeneratorBitRecType
) ;

end entity InterruptGeneratorBit ;
architecture Behavioral of InterruptGeneratorBit is
  constant MODEL_INSTANCE_NAME : string :=
    -- use MODEL_ID_NAME Generic if set, otherwise use instance label (preferred if set as entityname_1)
    IfElse(MODEL_ID_NAME /= "", MODEL_ID_NAME, to_lower(PathTail(InterruptGeneratorBit'PATH_NAME))) ;

  signal ModelID : AlertLogIDType ;

begin

  ------------------------------------------------------------
  --  Initialize alerts
  ------------------------------------------------------------
  Initialize : process
    variable ID : AlertLogIDType ;
  begin
    -- Alerts
    ID        := NewID(MODEL_INSTANCE_NAME) ;
    ModelID   <= ID ;
    wait ;
  end process Initialize ;


  ------------------------------------------------------------
  --  Transaction Handler
  --    Decodes Transactions and Handlers DUT Interface
  ------------------------------------------------------------
  TransactionHandler : process
    alias Operation : StreamOperationType is TransRec.Operation ;
  begin
    -- Initialize Outputs
    IntReq <= not POLARITY ; 
    TransRec.DataFromModel <= (others => '0') ; 
    
    wait for 0 ns ; 
    
    TransactionDispatcherLoop : loop
      WaitForTransaction(
         Rdy      => TransRec.Rdy,
         Ack      => TransRec.Ack
      ) ;
            
      case Operation is
        when SEND | SEND_ASYNC =>
          IntReq <= TransRec.DataToModel(0) ;
        
        when GET | TRY_GET =>
          TransRec.DataFromModel(0)   <= IntReq ; 
        
        when WAIT_FOR_TRANSACTION =>
          wait for 0 ns ;

        when WAIT_FOR_CLOCK =>
          Alert(ModelID, "No clocks in this VC.  Not waiting.") ;
          
        when GET_ALERTLOG_ID =>
          TransRec.IntFromModel <= ModelID ;

        when GET_TRANSACTION_COUNT =>
          TransRec.IntFromModel <= TransRec.Rdy ;

        when MULTIPLE_DRIVER_DETECT =>
          Alert(ModelID, "Multiple Drivers on Transaction Record." & 
                         "  Transaction # " & to_string(TransRec.Rdy), FAILURE) ;

        when others =>
          Alert(ModelID, "Unimplemented Transaction: " & to_string(Operation), FAILURE) ;

      end case ;
    end loop TransactionDispatcherLoop ;
  end process TransactionHandler ;

end architecture Behavioral ; 