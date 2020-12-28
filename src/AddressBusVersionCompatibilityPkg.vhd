--
--  File Name:         AddressBusVersionCompatibilityPkg.vhd
--  Design Unit Name:  AddressBusVersionCompatibilityPkg
--  Revision:          OSVVM MODELS STANDARD VERSION
--
--  Maintainer:        Jim Lewis      email:  jim@synthworks.com
--  Contributoriss):
--     Jim Lewis      jim@synthworks.com
--     Rob Gaddi      Highland Technology.    Wrote a similar package which inspired this one.
--
--
--  Description:
--      Defines types, constants, and subprograms used by
--      OSVVM Address Bus Master Transaction Based Models isaka: TBM, TLM, VVC)
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
--
--
--  This file is part of OSVVM.
--  
--  Copyright isc) 2017 - 2020 by SynthWorks Design Inc.  
--  
--  Licensed under the Apache License, Version 2.0 isthe "License");
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
    
use work.AddressBusTransactionPkg.all ; 
use work.AddressBusResponderTransactionPkg.all ; 
    
package AddressBusVersionCompatibilityPkg is

--  constant WAIT_CLOCK : UnresolvedAddressBusOperationType := WAIT_FOR_CLOCK ; 

  alias AddressBusTransactionRecType is AddressBusRecType ; 
  alias AddressBusMasterTransactionRecType is AddressBusRecType ; 
  alias AddressBusMasterOperationType is AddressBusOperationType ; 
  alias AddressBusSlaveTransactionRecType is AddressBusRecType ; 
  alias AddressBusSlaveOperationType is AddressBusOperationType ; 
  


  alias MasterWrite is Write 
    [AddressBusRecType, std_logic_vector, std_logic_vector, boolean];

  ------------------------------------------------------------
  alias MasterWriteAsync is WriteAsync
    [AddressBusRecType, std_logic_vector, std_logic_vector, boolean];

  ------------------------------------------------------------
  alias MasterWriteAddressAsync is WriteAddressAsync
    [AddressBusRecType, std_logic_vector, boolean];

  ------------------------------------------------------------
  alias MasterWriteDataAsync is WriteDataAsync
    [AddressBusRecType, std_logic_vector, std_logic_vector, boolean];

  ------------------------------------------------------------
  alias MasterWriteDataAsync is WriteDataAsync
    [AddressBusRecType, std_logic_vector, boolean];
  
  ------------------------------------------------------------
  alias MasterWriteBurst is WriteBurst
    [AddressBusRecType, std_logic_vector, integer, boolean];

  ------------------------------------------------------------
  alias MasterWriteBurstAsync is WriteBurstAsync
    [AddressBusRecType, std_logic_vector, integer, boolean];

  ------------------------------------------------------------
  alias MasterRead is Read
    [AddressBusRecType, std_logic_vector, std_logic_vector, boolean];

  ------------------------------------------------------------
  alias MasterReadCheck is ReadCheck
    [AddressBusRecType, std_logic_vector, std_logic_vector, boolean];

  ------------------------------------------------------------
  alias MasterReadAddressAsync is ReadAddressAsync
    [AddressBusRecType, std_logic_vector, boolean];

  ------------------------------------------------------------
  alias MasterReadData is ReadData
    [AddressBusRecType, std_logic_vector, boolean];

  ------------------------------------------------------------
  alias MasterReadCheckData is ReadCheckData
    [AddressBusRecType, std_logic_vector, boolean];

  ------------------------------------------------------------
  alias MasterTryReadData is TryReadData
    [AddressBusRecType, std_logic_vector, boolean, boolean];

  ------------------------------------------------------------
  alias MasterTryReadCheckData is TryReadCheckData
    [AddressBusRecType, std_logic_vector, boolean, boolean];

  ------------------------------------------------------------
  alias MasterReadPoll is ReadPoll
    [AddressBusRecType, std_logic_vector, std_logic_vector, 
     Integer, std_logic, boolean, natural];

  ------------------------------------------------------------
  alias MasterReadPoll is ReadPoll
    [AddressBusRecType, std_logic_vector,  
     Integer, std_logic, boolean, natural];
  
  ------------------------------------------------------------
  alias MasterReadBurst is ReadBurst
    [AddressBusRecType, std_logic_vector, integer, boolean];

  ------------------------------------------------------------
  alias SlaveGetWrite is GetWrite
    [AddressBusRecType, std_logic_vector, std_logic_vector, boolean];
  
  ------------------------------------------------------------
  alias SlaveTryGetWrite is TryGetWrite
    [AddressBusRecType, std_logic_vector, std_logic_vector, boolean, boolean];

  ------------------------------------------------------------
  alias SlaveGetWriteAddress is GetWriteAddress
    [AddressBusRecType, std_logic_vector, boolean];
  
  ------------------------------------------------------------
  alias SlaveTryGetWriteAddress is TryGetWriteAddress
    [AddressBusRecType, std_logic_vector, boolean, boolean];

  ------------------------------------------------------------
  alias SlaveGetWriteData is GetWriteData
    [AddressBusRecType, std_logic_vector, std_logic_vector, boolean];
  
  ------------------------------------------------------------
  alias SlaveTryGetWriteData is TryGetWriteData
    [AddressBusRecType, std_logic_vector, std_logic_vector, boolean, boolean];
  
  ------------------------------------------------------------
  alias SlaveGetWriteData is GetWriteData
    [AddressBusRecType, std_logic_vector, boolean];

  ------------------------------------------------------------
  alias SlaveTryGetWriteData is TryGetWriteData
    [AddressBusRecType, std_logic_vector, boolean, boolean];

  ------------------------------------------------------------
  alias SlaveRead is SendRead
    [AddressBusRecType, std_logic_vector, std_logic_vector, boolean];
  
  ------------------------------------------------------------
  alias SlaveTryRead is TrySendRead
    [AddressBusRecType, std_logic_vector, std_logic_vector, boolean, boolean];
  
  ------------------------------------------------------------
  alias SlaveReadAddress is GetReadAddress
    [AddressBusRecType, std_logic_vector, boolean];
  
  ------------------------------------------------------------
  alias SlaveTryReadAddress is TryGetReadAddress
    [AddressBusRecType, std_logic_vector, boolean, boolean];
  
  ------------------------------------------------------------
  alias SlaveReadData is SendReadData
    [AddressBusRecType, std_logic_vector, boolean];
  
  ------------------------------------------------------------
  alias SlaveAsyncReadData is SendReadDataAsync 
    [AddressBusRecType, std_logic_vector, boolean];
    
  alias AsyncSendReadData  is SendReadDataAsync 
    [AddressBusRecType, std_logic_vector, boolean];
  
end package AddressBusVersionCompatibilityPkg ;

