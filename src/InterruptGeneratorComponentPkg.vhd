--
--  File Name:         InterruptGeneratorComponentPkg.vhd
--  Design Unit Name:  InterruptGeneratorComponentPkg
--  Revision:          OSVVM MODELS STANDARD VERSION
--
--  Maintainer:        Jim Lewis      email:  jim@synthworks.com
--  Contributor(s):
--     Jim Lewis      jim@synthworks.com
--
--
--  Description:
--      InterruptGenerator Component Declaration
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

  use work.InterruptGlobalSignalPkg.all ;

package InterruptGeneratorComponentPkg is

  component InterruptGeneratorBit is
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
  end component InterruptGeneratorBit ;
  
  component InterruptGeneratorBitVti is
  generic (
    MODEL_ID_NAME    : string := "" ;
    POLARITY         : std_logic := '1' 
  ) ;
  port (
    -- Interrupt Input
    IntReq          : out   std_logic 
  ) ;
  end component InterruptGeneratorBitVti ;
  
--  component InterruptGenerator is
--  generic (
--    MODEL_ID_NAME    : string := "" 
--  ) ;
--  port (
--    -- Interrupt Input
--    IntReq          : out   std_logic_vector(gIntReq'range) ; 
--  
--    -- Transaction port
--    TransRec         : inout InterruptGeneratorRecType
--  ) ;
--  end component InterruptGenerator ;
--  
--  component InterruptGeneratorVti is
--  generic (
--    MODEL_ID_NAME    : string := "" 
--  ) ;
--  port (
--    -- Interrupt Input
--    IntReq          : out   std_logic_vector(gIntReq'range) 
--  ) ;
--  end component InterruptGeneratorVti ;
  
end package InterruptGeneratorComponentPkg ;