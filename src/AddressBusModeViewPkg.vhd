--
--  File Name:         AddressBusModeViewPkg.vhd
--  Design Unit Name:  AddressBusModeViewPkg
--  Revision:          OSVVM MODELS STANDARD VERSION
--
--  Maintainer:        Jim Lewis      email:  jim@synthworks.com
--  Contributor(s):
--     Jim Lewis      jim@synthworks.com
--     Rob Gaddi      Highland Technology.    Wrote a similar package which inspired this one.
--
--
--  Description:
--    Mode View declarations for OSVVM's Address Bus Model  
--    Independent Transaction Interface (AddressBusRecType) 
--
--
--  Developed by:
--        SynthWorks Design Inc.
--        VHDL Training Classes
--        http://www.SynthWorks.com
--
--  Revision History:
--    Date      Version    Description
--    10/2025   2025.10    Initial revision
--
--  This file is part of OSVVM.
--  
--  Copyright (c) 2025 by SynthWorks Design Inc.  
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

  use work.AddressBusTransactionPkg.all ; 

package AddressBusModeViewPkg is

  -- ========================================================
  --  AddressBusRecType 
  --  Transaction interface between the test sequencer and the 
  --  verification component.   As such it is the primary channel 
  --  for information exchange between the two.
  -- ========================================================
  view AddressBusTestCtrlView of AddressBusRecType is 
    -- Handshaking controls
    --   Used by RequestTransaction in the Transaction Procedures
    --   Used by WaitForTransaction in the Verification Component
    --   RequestTransaction and WaitForTransaction are in osvvm.TbUtilPkg
    Rdy                : out ;
    Ack                : in ;
    -- Transaction Type
    Operation          : out ;
    -- Address to verification component and its width
    -- Width may be smaller than Address
    Address            : out ;
    AddrWidth          : out ;
    -- Data to and from the verification component and its width.
    -- Width will be smaller than Data for byte operations
    -- Width size requirements are enforced in the verification component
    DataToModel        : out ;
    DataFromModel      : in ;
    DataWidth          : out ;
    -- Burst FIFOs
    WriteBurstFifo     : in ; 
    ReadBurstFifo      : in ; 
--    UseCheckFifo       : boolean_max ; 
--    CheckFifo          : ScoreboardIdType ; 
    -- Parameters - internal settings for the VC in a singleton data structure   
    Params             : in ;  
    -- StatusMsgOn provides transaction messaging override.
    -- When true, print transaction messaging independent of 
    -- other verification based based controls.
    StatusMsgOn        : out ;
    -- Verification Component Options Parameters - used by SetModelOptions
    IntToModel         : out ;
    IntFromModel       : in ; 
    BoolToModel        : out ; 
    BoolFromModel      : in ;
    TimeToModel        : out ; 
    TimeFromModel      : in ; 
    -- Verification Component Options Type  
    Options            : out ;  
  end view AddressBusTestCtrlView ;
  
  alias AddressBusVerificationComponentView is AddressBusTestCtrlView'converse ;
  alias AddressBusVcView is AddressBusVerificationComponentView ; 

end package AddressBusModeViewPkg ;