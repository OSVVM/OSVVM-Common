--
--  File Name:         FifoFillPkg_slv.vhd
--  Design Unit Name:  FifoFillPkg_slv
--  Revision:          STANDARD VERSION
--
--  Maintainer:        Jim Lewis      email:  jim@synthworks.com
--  Contributor(s):
--     Jim Lewis          email:  jim@synthworks.com
--
--
--  Description:
--    Fill and check data in burst fifos 
--    Defines type ScoreBoardPType
--    Defines methods for putting values the scoreboard
--
--  Developed for:
--        SynthWorks Design Inc.
--        VHDL Training Classes
--        11898 SW 128th Ave.  Tigard, Or  97223
--        http://www.SynthWorks.com
--
--  Revision History:
--    Date      Version      Description
--    05/2020   2020.05     Initial revision
--    09/2020   2020.09     Updating comments to serve as documentation
--    10/2020   2020.10     Updating comments to serve as documentation
--
--  This file is part of OSVVM.
--  
--  Copyright (c) 2020 by SynthWorks Design Inc.  
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


use std.textio.all ;

library ieee ;
  use ieee.std_logic_1164.all ;
  use ieee.numeric_std.all ;
  use ieee.numeric_std_unsigned.all ;
  
library osvvm ; 
  context osvvm.OsvvmContext ;   
  use osvvm.ScoreboardPkg_slv.all ;

--!! Can this be made a generic package.   

package FifoFillPkg_slv is
  ------------------------------------------------------------
  procedure PushBurst (
  -- Push each value in the Bytes parameter into the FIFO.   
  -- Only DataWidth bits of each value will be pushed.    
  ------------------------------------------------------------
    variable Fifo      : inout ScoreboardPType ;
    constant Bytes     : in    integer_vector ;
    constant DataWidth : in    integer := 8
  ) ;

  ------------------------------------------------------------
  procedure PushBurstIncrement (
  -- Push ByteCount number of values into FIFO.  The first value 
  -- pushed will be Start and following values are one greater 
  -- than the previous one.  
  -- Only DataWidth bits of each value will be pushed.    
  ------------------------------------------------------------
    variable Fifo      : inout ScoreboardPType ;
    constant Start     : in    integer ;
    constant ByteCount : in    integer ;
    constant DataWidth : in    integer := 8
  ) ;
  
  ------------------------------------------------------------
  procedure PushBurstRandom (
  -- Push ByteCount number of values into FIFO.  The first value 
  -- pushed will be Start and following values are randomly generated 
  -- using the first value as the randomization seed.
  -- Only DataWidth bits of each value will be pushed.    
  ------------------------------------------------------------
    variable Fifo      : inout ScoreboardPType ;
    constant Start     : in    integer ;
    constant ByteCount : in    integer ;
    constant DataWidth : in    integer := 8
  ) ;
  
  ------------------------------------------------------------
  procedure PopBurst (
  -- Pop values from the FIFO into the Bytes parameter.
  -- Each value popped will be DataWidth bits wide.   
  ------------------------------------------------------------
    variable Fifo      : inout ScoreboardPType ;
    variable Bytes     : out   integer_vector ;
    constant DataWidth : in    integer := 8
  ) ;

  ------------------------------------------------------------
  procedure CheckBurst (
  -- Pop values from the FIFO and check them against each value 
  -- in the Bytes parameter.   
  -- Each value popped will be DataWidth bits wide.   
  ------------------------------------------------------------
    variable Fifo      : inout ScoreboardPType ;
    constant Bytes     : in    integer_vector ;
    constant DataWidth : in    integer := 8
  ) ;

  ------------------------------------------------------------
  procedure CheckBurstIncrement (
  -- Pop values from the FIFO and check them against values determined 
  -- by an incrementing pattern.  The first check value will be Start  
  -- and the following check values are one greater than the previous one.  
  -- Each value popped will be DataWidth bits wide.   
  ------------------------------------------------------------
    variable Fifo      : inout ScoreboardPType ;
    constant Start     : in    integer ;
    constant ByteCount : in    integer ;
    constant DataWidth : in    integer := 8
  ) ;
  
  ------------------------------------------------------------
  procedure CheckBurstRandom (
  -- Pop values from the FIFO and check them against values determined 
  -- by a random pattern.  The first check value will be Start and the
  -- following check values are randomly generated using the first  
  -- value as the randomization seed.  
  -- Each value popped will be DataWidth bits wide.   
  ------------------------------------------------------------
    variable Fifo      : inout ScoreboardPType ;
    constant Start     : in    integer ;
    constant ByteCount : in    integer ;
    constant DataWidth : in    integer := 8
  ) ;


  -- ========================================================
  --  Verification Component Support
  -- ========================================================

  ------------------------------------------------------------
  procedure PopWord (
  -- Pop bytes from BurstFifo and form a word 
  -- Current implementation for now assumes it is assembling bytes.   
  --
  ------------------------------------------------------------
    variable Fifo              : inout ScoreboardPType ;
    variable Valid             : out   boolean ;
    variable Data              : out   std_logic_vector ; 
    variable BytesToSend       : inout integer ;
    constant ByteAddress       : in    natural := 0 
  ) ; 

  ------------------------------------------------------------
  procedure PushWord (
  -- Push a word into the byte oriented BurstFifo
  -- Current implementation for now assumes it is assembling bytes.   
  --
  ------------------------------------------------------------
    variable Fifo              : inout ScoreboardPType ;
    variable Data              : in    std_logic_vector ; 
    constant DropUndriven      : in    boolean := FALSE ;
    constant ByteAddress       : in    natural := 0 
  ) ; 

  ------------------------------------------------------------
  function CountBytes(
  -- Count number of bytes in a word
  --
  ------------------------------------------------------------
    constant Data              : std_logic_vector ;
    constant DropUndriven      : in    boolean := FALSE ;
    constant ByteAddress       : in    natural := 0 
  ) return integer ;
  
end package FifoFillPkg_slv ;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
package body FifoFillPkg_slv is

  ------------------------------------------------------------
  procedure PushBurst (
  ------------------------------------------------------------
    variable Fifo      : inout ScoreboardPType ;
    constant Bytes     : in    integer_vector ;
    constant DataWidth : in    integer := 8
  ) is
  begin
    for i in Bytes'range loop 
      if Bytes(i) < 0 then 
        Fifo.Push((DataWidth downto 1 => 'U')) ;
      else 
        Fifo.Push(to_slv(Bytes(i), DataWidth)) ;
      end if ;
    end loop ;
  end procedure PushBurst ;

  ------------------------------------------------------------
  procedure PushBurstIncrement (
  ------------------------------------------------------------
    variable Fifo      : inout ScoreboardPType ;
    constant Start     : in    integer ;
    constant ByteCount : in    integer ;
    constant DataWidth : in    integer := 8
  ) is
  begin
    for i in Start to ByteCount+Start-1 loop 
      Fifo.Push(to_slv(i mod (2**DataWidth), DataWidth)) ;
    end loop ;
  end procedure PushBurstIncrement ;
  
  ------------------------------------------------------------
  procedure PushBurstRandom (
  ------------------------------------------------------------
    variable Fifo      : inout ScoreboardPType ;
    constant Start     : in    integer ;
    constant ByteCount : in    integer ;
    constant DataWidth : in    integer := 8
  ) is
    variable RV : RandomPType ; 
    variable Junk : integer ; 
    constant MOD_VAL : integer := 2**DataWidth  ; 
  begin
    -- Initialize seed and toss first random value  
    RV.InitSeed(Start) ;
    Junk := RV.RandInt(0, MOD_VAL-1) ;
    
    Fifo.Push(to_slv(Start mod MOD_VAL, DataWidth)) ;
    
    for i in 2 to ByteCount loop 
      Fifo.Push(RV.RandSlv(0, MOD_VAL-1, DataWidth)) ;
    end loop ;
  end procedure PushBurstRandom ;
  
  ------------------------------------------------------------
  procedure PopBurst (
  ------------------------------------------------------------
    variable Fifo      : inout ScoreboardPType ;
    variable Bytes     : out   integer_vector ;
    constant DataWidth : in    integer := 8
  ) is
  begin
    for i in Bytes'range loop 
      if Bytes(i) < 0 then 
        Fifo.Push((DataWidth downto 1 => 'U')) ;
      else 
        Fifo.Push(to_slv(Bytes(i), DataWidth)) ;
      end if ;
    end loop ;
  end procedure PopBurst ;
  
  ------------------------------------------------------------
  procedure CheckBurst (
  ------------------------------------------------------------
    variable Fifo      : inout ScoreboardPType ;
    constant Bytes     : in    integer_vector ;
    constant DataWidth : in    integer := 8
  ) is
  begin
    for i in Bytes'range loop 
      if Bytes(i) < 0 then 
        Fifo.Check((DataWidth downto 1 => 'U')) ;
      else 
        Fifo.Check(to_slv(Bytes(i), DataWidth)) ;
      end if ;
    end loop ;
  end procedure CheckBurst ;

  ------------------------------------------------------------
  procedure CheckBurstIncrement (
  ------------------------------------------------------------
    variable Fifo      : inout ScoreboardPType ;
    constant Start     : in    integer ;
    constant ByteCount : in    integer ;
    constant DataWidth : in    integer := 8
  ) is
  begin
    for i in Start to ByteCount+Start-1 loop 
      Fifo.Check(to_slv(i mod (2**DataWidth), DataWidth)) ;
    end loop ;
  end procedure CheckBurstIncrement ;
  
  ------------------------------------------------------------
  procedure CheckBurstRandom (
  ------------------------------------------------------------
    variable Fifo      : inout ScoreboardPType ;
    constant Start     : in    integer ;
    constant ByteCount : in    integer ;
    constant DataWidth : in    integer := 8
  ) is
    variable RV : RandomPType ; 
    variable Junk : integer; 
    constant MOD_VAL : integer := 2**DataWidth  ; 
  begin
    -- Initialize seed and toss first random value 
    RV.InitSeed(Start) ;
    Junk := RV.RandInt(0, MOD_VAL-1) ;
    
    Fifo.Check(to_slv(Start mod MOD_VAL, DataWidth)) ;
    
    for i in 2 to ByteCount loop 
      Fifo.Check(RV.RandSlv(0, MOD_VAL-1, DataWidth)) ;
    end loop ;
  end procedure CheckBurstRandom ;
  
  
  -- ========================================================
  --  Verification Component Support
  -- ========================================================

  ------------------------------------------------------------
  procedure PopWord (
  -- Pop bytes from BurstFifo and form a word 
  -- Current implementation for now assumes it is assembling bytes.   
  --
  ------------------------------------------------------------
    variable Fifo              : inout ScoreboardPType ;
    variable Valid             : out   boolean ;
    variable Data              : out   std_logic_vector ; 
    variable BytesToSend       : inout integer ;
    constant ByteAddress       : in    natural := 0 
  ) is
    variable Index    : integer := ByteAddress * 8 ; 
    constant DataLeft : integer := Data'length-1; 
    alias aData       : std_logic_vector(DataLeft downto 0) is Data;
  begin
    aData := (aData'range => 'U') ;  -- Default Undriven
    Valid := TRUE ; 
    GetWord : while Index <= DataLeft loop  
      if not Fifo.empty then 
        aData(Index+7 downto Index) := Fifo.pop ; 
        BytesToSend := BytesToSend - 1 ; 
        exit when BytesToSend = 0 ; 
      else
        Valid := FALSE ; 
        exit ; 
      end if ; 
      Index := Index + 8 ; 
    end loop GetWord ;
  end PopWord ; 

  ------------------------------------------------------------
  procedure PushWord (
  -- Push a word into the byte oriented BurstFifo
  -- Current implementation for now assumes it is assembling bytes.   
  --
  ------------------------------------------------------------
    variable Fifo              : inout ScoreboardPType ;
    variable Data              : in    std_logic_vector ; 
    constant DropUndriven      : in    boolean := FALSE ;
    constant ByteAddress       : in    natural := 0 
  ) is
    variable Index    : integer := ByteAddress * 8 ; 
    constant DataLeft : integer := Data'length-1; 
    alias aData       : std_logic_vector(DataLeft downto 0) is Data;
  begin
    PushBytes : while Index <= DataLeft loop  
      if not (DropUndriven and aData(Index) = 'U') then 
        Fifo.push(aData(Index+7 downto Index)) ; 
      end if ;
      Index := Index + 8 ; 
    end loop PushBytes ; 
  end PushWord ; 

  ------------------------------------------------------------
  function CountBytes(
  -- Count number of bytes in a word
  --
  ------------------------------------------------------------
    constant Data              : std_logic_vector ;
    constant DropUndriven      : in    boolean := FALSE ;
    constant ByteAddress       : in    natural := 0 
  ) return integer is
    variable Index    : integer := ByteAddress * 8 ; 
    variable Count    : integer := 0 ; 
    constant DataLeft : integer := Data'length-1 ;
    alias aData       : std_logic_vector(DataLeft downto 0) is Data ; 
  begin
    while Index <= DataLeft loop
      if not (DropUndriven and aData(Index) = 'U') then 
        Count := Count + 1 ; 
      end if ;
      Index := Index + 8 ; 
    end loop ; 
    return Count ;
  end function CountBytes ; 
    
end FifoFillPkg_slv ;