--
--  File Name:         InterruptGlobalSignalPkg.vhd
--  Design Unit Name:  InterruptGlobalSignalPkg
--  Revision:          OSVVM MODELS STANDARD VERSION
--
--  Maintainer:        Jim Lewis      email:  jim@synthworks.com
--  Contributor(s):
--     Jim Lewis          jim@synthworks.com
--     Simon Southwell    simon.southwell@gmail.com
--
--  Description:
--      InterruptHandler Component Declaration
--
--
--  Developed by:
--        SynthWorks Design Inc.
--        VHDL Training Classes
--        http://www.SynthWorks.com
--
--  Revision History:
--    Date      Version    Description
--    01/2023   2023.01    Updated to gIntReq use std_logic_vector
--    12/2022              Initial revision
--
--
--  This file is part of OSVVM.
--
--  Copyright (c) 2022-2023 by SynthWorks Design Inc.
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

package InterruptGlobalSignalPkg is

  constant NUMBER_INTERRUPT_SIGNALS : integer := 32 ; 
  signal gIntReq : std_logic_vector(NUMBER_INTERRUPT_SIGNALS-1 downto 0) := (others => '0') ; 
--  signal gIntReq : boolean := false ;
  signal gVProcReadInterrupts : bit := '0' ; 
  constant INTERRUPT_ON_LEVEL : std_logic := '0' ;
  constant INTERRUPT_ON_EDGE  : std_logic := '1' ;

end package InterruptGlobalSignalPkg ;

package body InterruptGlobalSignalPkg is

--  constant NUMBER_INTERRUPT_SIGNALS : integer ; 

end package body InterruptGlobalSignalPkg ;