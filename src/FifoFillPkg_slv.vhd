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
--    Date      Version     Description
--    06/2021   2021.06     Updated to work with new FIFO/Scoreboard data structures
--    10/2020   2020.10     Updating comments to serve as documentation
--    09/2020   2020.09     Updating comments to serve as documentation
--    05/2020   2020.05     Initial revision
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
  -- Push each value in the VectorOfWords parameter into the FIFO.   
  -- Only FifoWidth bits of each value will be pushed.    
  ------------------------------------------------------------
    constant Fifo           : in    ScoreboardIdType ;
    constant VectorOfWords  : in    integer_vector ;
    constant FifoWidth      : in    integer := 8
  ) ;

  ------------------------------------------------------------
  procedure PushBurstIncrement (
  -- Push Count number of values into FIFO.  The first value 
  -- pushed will be FirstWord and following values are one greater 
  -- than the previous one.  
  -- Only FifoWidth bits of each value will be pushed.    
  ------------------------------------------------------------
    constant Fifo      : in    ScoreboardIdType ;
    constant FirstWord : in    integer ;
    constant Count     : in    integer ;
    constant FifoWidth : in    integer := 8
  ) ;
  
  ------------------------------------------------------------
  procedure PushBurstRandom (
  -- Push Count number of values into FIFO.  The first value 
  -- pushed will be FirstWord and following values are randomly generated 
  -- using the first value as the randomization seed.
  -- Only FifoWidth bits of each value will be pushed.    
  ------------------------------------------------------------
    constant Fifo      : in    ScoreboardIdType ;
    constant FirstWord : in    integer ;
    constant Count     : in    integer ;
    constant FifoWidth : in    integer := 8
  ) ;
  
  ------------------------------------------------------------
  procedure PopBurst (
  -- Pop values from the FIFO into the VectorOfWords parameter.
  -- Each value popped will be FifoWidth bits wide.   
  ------------------------------------------------------------
    constant Fifo           : in    ScoreboardIdType ;
    variable VectorOfWords  : out   integer_vector ;
    constant FifoWidth      : in    integer := 8
  ) ;

  ------------------------------------------------------------
  procedure CheckBurst (
  -- Pop values from the FIFO and check them against each value 
  -- in the VectorOfWords parameter.   
  -- Each value popped will be FifoWidth bits wide.   
  ------------------------------------------------------------
    constant Fifo           : in    ScoreboardIdType ;
    constant VectorOfWords  : in    integer_vector ;
    constant FifoWidth      : in    integer := 8
  ) ;

  ------------------------------------------------------------
  procedure CheckBurstIncrement (
  -- Pop values from the FIFO and check them against values determined 
  -- by an incrementing pattern.  The first check value will be FirstWord  
  -- and the following check values are one greater than the previous one.  
  -- Each value popped will be FifoWidth bits wide.   
  ------------------------------------------------------------
    constant Fifo      : in    ScoreboardIdType ;
    constant FirstWord : in    integer ;
    constant Count     : in    integer ;
    constant FifoWidth : in    integer := 8
  ) ;
  
  ------------------------------------------------------------
  procedure CheckBurstRandom (
  -- Pop values from the FIFO and check them against values determined 
  -- by a random pattern.  The first check value will be FirstWord and the
  -- following check values are randomly generated using the first  
  -- value as the randomization seed.  
  -- Each value popped will be FifoWidth bits wide.   
  ------------------------------------------------------------
    constant Fifo      : in    ScoreboardIdType ;
    constant FirstWord : in    integer ;
    constant Count     : in    integer ;
    constant FifoWidth : in    integer := 8
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
    constant Fifo              : in    ScoreboardIdType ;
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
    constant Fifo              : in    ScoreboardIdType ;
    variable Data              : in    std_logic_vector ; 
    constant DropUndriven      : in    boolean := FALSE ;
    constant ByteAddress       : in    natural := 0 
  ) ; 
  
  ------------------------------------------------------------
  procedure CheckWord (
  -- Check a word using the byte oriented BurstFifo
  -- Current implementation for now assumes it is assembling bytes.   
  --
  ------------------------------------------------------------
    constant Fifo              : in    ScoreboardIdType ;
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
  constant NUMBER_POSITIVE_INTEGER_BITS : integer := 31 ; 

  ------------------------------------------------------------
  procedure PushBurst (
  ------------------------------------------------------------
    constant Fifo           : in    ScoreboardIdType ;
    constant VectorOfWords  : in    integer_vector ;
    constant FifoWidth      : in    integer := 8
  ) is
  begin
    for i in VectorOfWords'range loop 
      if VectorOfWords(i) < 0 then 
        Push(Fifo, (FifoWidth downto 1 => 'U')) ;
      else 
        Push(Fifo, to_slv(VectorOfWords(i), FifoWidth)) ;
      end if ;
    end loop ;
  end procedure PushBurst ;

  ------------------------------------------------------------
  procedure PushBurstIncrement (
  ------------------------------------------------------------
    constant Fifo      : in    ScoreboardIdType ;
    constant FirstWord : in    integer ;
    constant Count     : in    integer ;
    constant FifoWidth : in    integer := 8
  ) is
  begin
    for i in FirstWord to Count+FirstWord-1 loop 
      if FifoWidth < NUMBER_POSITIVE_INTEGER_BITS then 
        Push(Fifo, to_slv(i mod (2**FifoWidth), FifoWidth)) ;
      else 
        Push(Fifo, to_slv(i, FifoWidth)) ;
      end if ; 
    end loop ;
  end procedure PushBurstIncrement ;
  
  ------------------------------------------------------------
  procedure PushBurstRandom (
  ------------------------------------------------------------
    constant Fifo      : in    ScoreboardIdType ;
    constant FirstWord : in    integer ;
    constant Count     : in    integer ;
    constant FifoWidth : in    integer := 8
  ) is
    variable RV : RandomPType ; 
    variable JunkValue : integer ;
    variable Data : std_logic_vector(FifoWidth-1 downto 0) ;
  begin
    -- Initialize seed and toss first random value  
    RV.InitSeed(FirstWord) ;
    JunkValue := RV.RandInt(1, 10) ;  -- toss
    
    if FifoWidth < NUMBER_POSITIVE_INTEGER_BITS then 
      Push(Fifo, to_slv(FirstWord mod (2**FifoWidth), FifoWidth)) ;
    else 
      Push(Fifo, to_slv(FirstWord, FifoWidth)) ;
    end if ; 
    
    for i in 2 to Count loop 
      Data := RV.RandSlv(FifoWidth) ;
      Push(Fifo, Data) ;
    end loop ;
  end procedure PushBurstRandom ;
  
  ------------------------------------------------------------
  procedure PopBurst (
  ------------------------------------------------------------
    constant Fifo           : in    ScoreboardIdType ;
    variable VectorOfWords  : out   integer_vector ;
    constant FifoWidth      : in    integer := 8
  ) is
  begin
    for i in VectorOfWords'range loop 
      if VectorOfWords(i) < 0 then 
        Push(Fifo, (FifoWidth downto 1 => 'U')) ;
      else 
        Push(Fifo, to_slv(VectorOfWords(i), FifoWidth)) ;
      end if ;
    end loop ;
  end procedure PopBurst ;
  
  ------------------------------------------------------------
  procedure CheckBurst (
  ------------------------------------------------------------
    constant Fifo           : in    ScoreboardIdType ;
    constant VectorOfWords  : in    integer_vector ;
    constant FifoWidth      : in    integer := 8
  ) is
    variable AlertLogID : AlertLogIDType ; 
    variable RxVal : std_logic_vector(FifoWidth-1 downto 0) ;
  begin
    AlertLogID := GetAlertLogID(Fifo) ; 
    for i in VectorOfWords'range loop 
      RxVal := Pop(Fifo) ;
      if VectorOfWords(i) < 0 then 
        AffirmIfEqual(AlertLogID, RxVal, (FifoWidth downto 1 => 'U')) ;
      else 
        AffirmIfEqual(AlertLogID, RxVal, to_slv(VectorOfWords(i), FifoWidth)) ;
      end if ;
    end loop ;
  end procedure CheckBurst ;

  ------------------------------------------------------------
  procedure CheckBurstIncrement (
  ------------------------------------------------------------
    constant Fifo      : in    ScoreboardIdType ;
    constant FirstWord : in    integer ;
    constant Count     : in    integer ;
    constant FifoWidth : in    integer := 8
  ) is
    variable AlertLogID : AlertLogIDType ; 
    variable RxVal : std_logic_vector(FifoWidth-1 downto 0) ;
  begin
    AlertLogID := GetAlertLogID(Fifo) ; 
    for i in FirstWord to Count+FirstWord-1 loop 
      RxVal := Pop(Fifo) ;
      if FifoWidth < NUMBER_POSITIVE_INTEGER_BITS then 
        AffirmIfEqual(AlertLogID, RxVal, to_slv(i mod (2**FifoWidth), FifoWidth)) ;
      else 
        AffirmIfEqual(AlertLogID, RxVal, to_slv(i, FifoWidth)) ;
      end if ; 
    end loop ;
  end procedure CheckBurstIncrement ;
  
  ------------------------------------------------------------
  procedure CheckBurstRandom (
  ------------------------------------------------------------
    constant Fifo      : in    ScoreboardIdType ;
    constant FirstWord : in    integer ;
    constant Count     : in    integer ;
    constant FifoWidth : in    integer := 8
  ) is
    variable RV : RandomPType ; 
    variable JunkValue : integer ;
    variable AlertLogID : AlertLogIDType ; 
    variable RxVal, ExpVal : std_logic_vector(FifoWidth-1 downto 0) ;
  begin
    AlertLogID := GetAlertLogID(Fifo) ; 
    -- Initialize seed and toss first random value 
    RV.InitSeed(FirstWord) ;
    JunkValue := RV.RandInt(1, 10) ;  -- Toss
    
    RxVal := Pop(Fifo) ;
    -- Check First Value      Received    Expected, First Value
    if FifoWidth < NUMBER_POSITIVE_INTEGER_BITS then 
      AffirmIfEqual(AlertLogID, RxVal, to_slv(FirstWord mod (2**FifoWidth), FifoWidth)) ;
    else 
      AffirmIfEqual(AlertLogID, RxVal, to_slv(FirstWord, FifoWidth)) ;
    end if ; 
    
    for i in 2 to Count loop 
      RxVal := Pop(Fifo) ;
      ExpVal := RV.RandSlv(FifoWidth) ;
      -- Check Remaining Values   Received    Expected
      AffirmIfEqual(AlertLogID,   RxVal,      ExpVal ) ;
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
    constant Fifo              : in    ScoreboardIdType ;
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
      if not Empty(Fifo) then 
        aData(Index+7 downto Index) := Pop(Fifo) ; 
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
    constant Fifo              : in    ScoreboardIdType ;
    variable Data              : in    std_logic_vector ; 
    constant DropUndriven      : in    boolean := FALSE ;
    constant ByteAddress       : in    natural := 0 
  ) is
    variable Index    : integer := ByteAddress * 8 ; 
    constant DataLeft : integer := Data'length-1; 
    alias    aData    : std_logic_vector(DataLeft downto 0) is Data;
  begin
    PushBytes : while Index <= DataLeft loop  
      if not ((DropUndriven and aData(Index) = 'U') or aData(Index) = '-') then 
        Push(Fifo, aData(Index+7 downto Index)) ; 
      end if ;
      Index := Index + 8 ; 
    end loop PushBytes ; 
  end PushWord ; 

  ------------------------------------------------------------
  procedure CheckWord (
  -- Push a word into the byte oriented BurstFifo
  -- Current implementation for now assumes it is assembling bytes.   
  --
  ------------------------------------------------------------
    constant Fifo              : in    ScoreboardIdType ;
    variable Data              : in    std_logic_vector ; 
    constant DropUndriven      : in    boolean := FALSE ;
    constant ByteAddress       : in    natural := 0 
  ) is
    variable Index    : integer := ByteAddress * 8 ; 
    constant DataLeft : integer := Data'length-1; 
    alias aData       : std_logic_vector(DataLeft downto 0) is Data;
  begin
    PushBytes : while Index <= DataLeft loop  
      if not ((DropUndriven and aData(Index) = 'U') or aData(Index) = '-') then 
        Check(Fifo, aData(Index+7 downto Index)) ; 
      end if ;
      Index := Index + 8 ; 
    end loop PushBytes ; 
  end CheckWord ; 

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
      if not ((DropUndriven and aData(Index) = 'U') or aData(Index) = '-') then 
        Count := Count + 1 ; 
      end if ;
      Index := Index + 8 ; 
    end loop ; 
    return Count ;
  end function CountBytes ; 
    
end FifoFillPkg_slv ;