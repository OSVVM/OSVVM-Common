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
--    01/2022   2022.01     Added new burst patterns
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

package FifoFillPkg_slv is
  ------------------------------------------------------------
  procedure PushBurstVector (
  -- Push each value in the VectorOfWords parameter into the FIFO.   
  -- FifoWidth must match the std_logic_vector parameter.    
  ------------------------------------------------------------
    constant Fifo          : In    ScoreboardIdType ;
    constant VectorOfWords : In    slv_vector 
  ) ;

  ------------------------------------------------------------
  procedure PushBurstVector (
  -- Push each value in the VectorOfWords parameter into the FIFO.   
  -- Only FifoWidth bits of each value will be pushed.    
  ------------------------------------------------------------
    constant Fifo           : in    ScoreboardIdType ;
    constant VectorOfWords  : in    integer_vector ;
    constant FifoWidth      : in    integer
  ) ;

  ------------------------------------------------------------
  procedure PushBurstIncrement (
  -- Push Count number of values into FIFO.  The first value 
  -- pushed will be FirstWord and following values are one greater 
  -- than the previous one.  
  -- FifoWidth must match the std_logic_vector parameter.    
  ------------------------------------------------------------
    constant Fifo           : In    ScoreboardIdType ;
    constant FirstWord      : In    std_logic_vector ;
    constant Count          : In    integer 
  ) ;

  ------------------------------------------------------------
  procedure PushBurstIncrement (
  -- Push Count number of values into FIFO.  The first value 
  -- pushed will be FirstWord and following values are one greater 
  -- than the previous one.  
  -- Only FifoWidth bits of each value will be pushed.    
  ------------------------------------------------------------
    constant Fifo         : in    ScoreboardIdType ;
    constant FirstWord    : in    integer ;
    constant Count        : in    integer ;
    constant FifoWidth    : in    integer := 8
  ) ;
  
  ------------------------------------------------------------
  procedure PushBurstRandom (
  -- Push Count number of values into FIFO.  The first value 
  -- pushed will be FirstWord and following values are randomly generated 
  -- using the first value as the randomization seed.
  -- FifoWidth must match the std_logic_vector parameter.    
  ------------------------------------------------------------
    constant Fifo           : In    ScoreboardIdType ;
    constant FirstWord      : In    std_logic_vector ;
    constant Count          : In    integer 
  ) ;

  ------------------------------------------------------------
  procedure PushBurstRandom (
  -- Push Count number of values into FIFO.  The first value 
  -- pushed will be FirstWord and following values are randomly generated 
  -- using the first value as the randomization seed.
  -- Only FifoWidth bits of each value will be pushed.    
  ------------------------------------------------------------
    constant Fifo         : in    ScoreboardIdType ;
    constant FirstWord    : in    integer ;
    constant Count        : in    integer ;
    constant FifoWidth    : in    integer := 8
  ) ;
  
  ------------------------------------------------------------
  -- Experimental and Provisional
  procedure PushBurstRandom (
  -- Push Count number of values into FIFO.  Values are 
  -- randomly generated using the coverage model.
  -- Only FifoWidth bits of each value will be pushed.    
  ------------------------------------------------------------
    constant Fifo         : in    ScoreboardIdType ;
    constant CoverID      : in    CoverageIdType ;
    constant Count        : in    integer ;
    constant FifoWidth    : in    integer := 8
  ) ;

  ------------------------------------------------------------
  procedure PopBurstVector (
  -- Pop values from the FIFO into the VectorOfWords parameter.
  -- Width of VectorOfWords(i) shall match the width of the Fifo 
  ------------------------------------------------------------
    constant Fifo           : in    ScoreboardIdType ;
    variable VectorOfWords  : out   slv_vector 
  ) ;

  ------------------------------------------------------------
  procedure PopBurstVector (
  -- Pop values from the FIFO into the VectorOfWords parameter.
  -- Each value popped will be FifoWidth bits wide.   
  ------------------------------------------------------------
    constant Fifo           : in    ScoreboardIdType ;
    variable VectorOfWords  : out   integer_vector 
  ) ;

  ------------------------------------------------------------
  procedure CheckBurstVector (
  -- Check values from the FIFO against the values 
  -- in the VectorOfWords parameter.   
  -- Width of VectorOfWords(i) shall match the width of the Fifo 
  ------------------------------------------------------------
    constant Fifo           : in    ScoreboardIdType ;
    constant VectorOfWords  : in    slv_vector 
  ) ;

  ------------------------------------------------------------
  procedure CheckBurstVector (
  -- Check values from the FIFO against the values 
  -- in the VectorOfWords parameter.   
  -- Each value of VectorOfWords shall be converted to FifoWidth bits wide.   
  ------------------------------------------------------------
    constant Fifo           : in    ScoreboardIdType ;
    constant VectorOfWords  : in    integer_vector ;
    constant FifoWidth      : in    integer
  ) ;

  ------------------------------------------------------------
  procedure CheckBurstIncrement (
  -- Check values from the FIFO against the incrementing values 
  -- that start with the value of the FirstWord.
  -- Width of FirstWord shall match the width of the Fifo 
  ------------------------------------------------------------
    constant Fifo         : in    ScoreboardIdType ;
    constant FirstWord    : in    std_logic_vector ;
    constant Count        : in    integer 
  ) ;
  
  ------------------------------------------------------------
  procedure CheckBurstIncrement (
  -- Check values from the FIFO against the incrementing values 
  -- that start with the value of the FirstWord.
  -- Each value of VectorOfWords shall be converted to FifoWidth bits wide.   
  ------------------------------------------------------------
    constant Fifo         : in    ScoreboardIdType ;
    constant FirstWord    : in    integer ;
    constant Count        : in    integer ;
    constant FifoWidth    : in    integer := 8
  ) ;

  ------------------------------------------------------------
  procedure CheckBurstRandom (
  -- Check values from the FIFO against the random values 
  -- that are generated using the value of the FirstWord and 
  -- NumFifoWords as the randomization seeds.
  -- Width of FirstWord shall match the width of the Fifo 
  ------------------------------------------------------------
    constant Fifo         : in    ScoreboardIdType ;
    constant FirstWord    : in    std_logic_vector ;
    constant Count        : in    integer 
  ) ;
  
  ------------------------------------------------------------
  procedure CheckBurstRandom (
  -- Check values from the FIFO against the random values 
  -- that are generated using the value of the FirstWord and 
  -- Count as the randomization seeds.
  -- Each value of VectorOfWords shall be converted to FifoWidth bits wide.   
  ------------------------------------------------------------
    constant Fifo         : in    ScoreboardIdType ;
    constant FirstWord    : in    integer ;
    constant Count        : in    integer ;
    constant FifoWidth    : in    integer := 8
  ) ;

  ------------------------------------------------------------
  -- Experimental and Provisional
  procedure CheckBurstRandom (
  ------------------------------------------------------------
    constant Fifo         : in    ScoreboardIdType ;
    constant CoverID      : in    CoverageIdType ;
    constant Count        : in    integer ;
    constant FifoWidth    : in    integer := 8
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
    constant Data              : in    std_logic_vector ;
    constant DropUndriven      : in    boolean := FALSE ;
    constant ByteAddress       : in    natural := 0 
  ) return integer ;
  
  -- ========================================================
  --  Deprecated
  -- ========================================================

  ------------------------------------------------------------
  -- Deprecated and replaced by PushBurstVector
  procedure PushBurst (
  -- Push each value in the VectorOfWords parameter into the FIFO.   
  -- Only FifoWidth bits of each value will be pushed.    
  ------------------------------------------------------------
    constant Fifo           : in    ScoreboardIdType ;
    constant VectorOfWords  : in    integer_vector ;
    constant FifoWidth      : in    integer := 8
  ) ;

  ------------------------------------------------------------
  -- Deprecated and replaced by CheckBurstVector
  procedure CheckBurst (
  -- Pop values from the FIFO and check them against each value 
  -- in the VectorOfWords parameter.   
  -- Each value popped will be FifoWidth bits wide.   
  ------------------------------------------------------------
    constant Fifo           : in    ScoreboardIdType ;
    constant VectorOfWords  : in    integer_vector ;
    constant FifoWidth      : in    integer := 8
  ) ;

end package FifoFillPkg_slv ;
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
package body FifoFillPkg_slv is
  constant NUMBER_POSITIVE_INTEGER_BITS : integer := 31 ; 

  ------------------------------------------------------------
  procedure PushBurstVector (
  ------------------------------------------------------------
    constant Fifo          : In    ScoreboardIdType ;
    constant VectorOfWords : In    slv_vector 
  ) is
  begin
    for i in VectorOfWords'range loop
      Push( Fifo, VectorOfWords(i) ) ;
    end loop ; 
  end procedure PushBurstVector ;

  ------------------------------------------------------------
  procedure PushBurstVector (
  ------------------------------------------------------------
    constant Fifo           : in    ScoreboardIdType ;
    constant VectorOfWords  : in    integer_vector ;
    constant FifoWidth      : in    integer
  ) is
  begin
    for i in VectorOfWords'range loop 
      if VectorOfWords(i) < 0 then 
        Push(Fifo, (FifoWidth downto 1 => 'U')) ;
      elsif FifoWidth < NUMBER_POSITIVE_INTEGER_BITS then 
        Push(Fifo, to_slv(VectorOfWords(i) mod (2**FifoWidth), FifoWidth)) ;
      else 
        Push(Fifo, to_slv(VectorOfWords(i), FifoWidth)) ;
      end if ; 
    end loop ;
  end procedure PushBurstVector ;

  ------------------------------------------------------------
  procedure PushBurstIncrement (
  ------------------------------------------------------------
    constant Fifo           : In    ScoreboardIdType ;
    constant FirstWord      : In    std_logic_vector ;
    constant Count          : In    integer 
  ) is
  begin
    for i in 0 to Count-1 loop
      Push( Fifo, FirstWord+i ) ;
    end loop ; 
  end procedure PushBurstIncrement ;
  
  ------------------------------------------------------------
  procedure PushBurstIncrement (
  ------------------------------------------------------------
    constant Fifo         : in    ScoreboardIdType ;
    constant FirstWord    : in    integer ;
    constant Count        : in    integer ;
    constant FifoWidth    : in    integer := 8
  ) is
    variable intFirstWord : integer ; 
    variable AdjFirstWord : std_logic_vector(FifoWidth-1 downto 0) ;
  begin
    if FirstWord < 0 then 
      intFirstWord := -FirstWord ; 
    else
      intFirstWord := FirstWord ; 
    end if ; 
    if FifoWidth < NUMBER_POSITIVE_INTEGER_BITS then 
      AdjFirstWord := to_slv(intFirstWord mod (2**FifoWidth), FifoWidth) ;
    else
      AdjFirstWord := to_slv(intFirstWord, FifoWidth) ;
    end if ; 
    for i in 0 to Count-1 loop 
      Push( Fifo, AdjFirstWord+i ) ;
    end loop ;
  end procedure PushBurstIncrement ;
  
  ------------------------------------------------------------
  procedure PushBurstRandom (
  ------------------------------------------------------------
    constant Fifo           : In    ScoreboardIdType ;
    constant FirstWord      : In    std_logic_vector ;
    constant Count          : In    integer 
  ) is
    variable RV         : RandomPType ; 
    alias    aFirstWord : std_logic_vector(FirstWord'length-1 downto 0) is FirstWord ; 
    constant FW_LEFT    : integer := minimum(30, FirstWord'length) - 1 ;
  begin
    RV.InitSeed(to_integer(MetaTo01(aFirstWord(FW_LEFT downto 0))) + Count, UseNewSeedMethods => TRUE) ;
    Push( Fifo, FirstWord ) ;
    for i in 2 to Count loop
      Push( Fifo, RV.RandSlv(FirstWord'length) ) ;
    end loop ; 
  end procedure PushBurstRandom ;

  ------------------------------------------------------------
  procedure PushBurstRandom (
  ------------------------------------------------------------
    constant Fifo         : in    ScoreboardIdType ;
    constant FirstWord    : in    integer ;
    constant Count        : in    integer ;
    constant FifoWidth    : in    integer := 8
  ) is
    variable RV : RandomPType ; 
    variable intFirstWord : integer ; 
    variable slvFirstWord : std_logic_vector(FifoWidth-1 downto 0) ; 
  begin
    if FirstWord < 0 then 
      intFirstWord := -FirstWord ; 
    else
      intFirstWord := FirstWord ; 
    end if ; 
    
    -- Initialize seed and toss first random value  
    RV.InitSeed(intFirstWord mod 2**30 + Count, UseNewSeedMethods => TRUE) ;
    
    if FifoWidth < NUMBER_POSITIVE_INTEGER_BITS then 
      Push(Fifo, to_slv(intFirstWord mod (2**FifoWidth), FifoWidth)) ;
    else 
      Push(Fifo, to_slv(intFirstWord, FifoWidth)) ;
    end if ; 
    
    for i in 2 to Count loop 
      -- Extra Var added for QuestaSim
      slvFirstWord := RV.RandSlv(FifoWidth) ;
      Push(Fifo, slvFirstWord) ;
    end loop ;
  end procedure PushBurstRandom ;

  ------------------------------------------------------------
  -- Experimental and Provisional
  procedure PushBurstRandom (
  ------------------------------------------------------------
    constant Fifo         : in    ScoreboardIdType ;
    constant CoverID      : in    CoverageIdType ;
    constant Count        : in    integer ;
    constant FifoWidth    : in    integer := 8
  ) is
    variable RandValue : std_logic_vector(FifoWidth-1 downto 0) ; 
  begin    
    for i in 1 to Count loop 
      RandValue := to_slv(GetRandPoint(CoverID), FifoWidth) ;
      Push(Fifo, RandValue) ;
      ICoverLast(CoverID) ; 
    end loop ;
  end procedure PushBurstRandom ;

  ------------------------------------------------------------
  procedure PopBurstVector (
  ------------------------------------------------------------
    constant Fifo           : in    ScoreboardIdType ;
    variable VectorOfWords  : out   slv_vector 
  ) is
  begin
    for i in VectorOfWords'range loop 
      VectorOfWords(i) := Pop(Fifo) ; 
    end loop ;
  end procedure PopBurstVector ;

  ------------------------------------------------------------
  procedure PopBurstVector (
  ------------------------------------------------------------
    constant Fifo           : in    ScoreboardIdType ;
    variable VectorOfWords  : out   integer_vector 
  ) is
  begin
    for i in VectorOfWords'range loop 
      VectorOfWords(i) := to_integer(Pop(Fifo)) ; 
    end loop ;
  end procedure PopBurstVector ;

  ------------------------------------------------------------
  procedure CheckBurstVector (
  ------------------------------------------------------------
    constant Fifo           : in    ScoreboardIdType ;
    constant VectorOfWords  : in    slv_vector 
  ) is
  begin
    for i in VectorOfWords'range loop
      CheckExpected( Fifo, VectorOfWords(i) ) ;
    end loop ; 
  end procedure CheckBurstVector ;

  ------------------------------------------------------------
  procedure CheckBurstVector (
  ------------------------------------------------------------
    constant Fifo           : in    ScoreboardIdType ;
    constant VectorOfWords  : in    integer_vector ;
    constant FifoWidth      : in    integer 
  ) is
  begin
    for i in VectorOfWords'range loop 
      if VectorOfWords(i) < 0 then 
        CheckExpected( Fifo, (FifoWidth downto 1 => 'U') ) ;
      elsif FifoWidth < NUMBER_POSITIVE_INTEGER_BITS then 
        CheckExpected( Fifo, to_slv(VectorOfWords(i) mod (2**FifoWidth), FifoWidth) ) ;
      else 
        CheckExpected( Fifo, to_slv(VectorOfWords(i), FifoWidth) ) ;
      end if ; 
    end loop ;
  end procedure CheckBurstVector ;

  ------------------------------------------------------------
  procedure CheckBurstIncrement (
  ------------------------------------------------------------
    constant Fifo         : in    ScoreboardIdType ;
    constant FirstWord    : in    std_logic_vector ;
    constant Count        : in    integer 
  ) is
  begin
    for i in 0 to Count-1 loop
      CheckExpected( Fifo, FirstWord+i ) ;
    end loop ; 
  end procedure CheckBurstIncrement ;

  ------------------------------------------------------------
  procedure CheckBurstIncrement (
  ------------------------------------------------------------
    constant Fifo         : in    ScoreboardIdType ;
    constant FirstWord    : in    integer ;
    constant Count        : in    integer ;
    constant FifoWidth    : in    integer := 8
  ) is
    variable intFirstWord : integer ; 
    variable AdjFirstWord : std_logic_vector(FifoWidth-1 downto 0) ;
  begin
    if FirstWord < 0 then 
      intFirstWord := -FirstWord ; 
    else
      intFirstWord := FirstWord ; 
    end if ; 
    if FifoWidth < NUMBER_POSITIVE_INTEGER_BITS then 
      AdjFirstWord := to_slv(intFirstWord mod (2**FifoWidth), FifoWidth) ;
    else
      AdjFirstWord := to_slv(intFirstWord, FifoWidth) ;
    end if ; 
    for i in 0 to Count-1 loop 
      CheckExpected( Fifo, AdjFirstWord+i ) ;
    end loop ;
  end procedure CheckBurstIncrement ;
  
  ------------------------------------------------------------
  procedure CheckBurstRandom (
  ------------------------------------------------------------
    constant Fifo         : in    ScoreboardIdType ;
    constant FirstWord    : in    std_logic_vector ;
    constant Count        : in    integer 
  ) is
    variable RV         : RandomPType ; 
    alias    aFirstWord : std_logic_vector(FirstWord'length-1 downto 0) is FirstWord ; 
    constant FW_LEFT    : integer := minimum(30, FirstWord'length) - 1 ;
  begin
    RV.InitSeed(to_integer(MetaTo01(aFirstWord(FW_LEFT downto 0))) + Count, UseNewSeedMethods => TRUE) ;
    CheckExpected( Fifo, FirstWord ) ;
    for i in 2 to Count loop
      CheckExpected( Fifo, RV.RandSlv(FirstWord'length) ) ;
    end loop ; 
  end procedure CheckBurstRandom ;

  ------------------------------------------------------------
  procedure CheckBurstRandom (
  ------------------------------------------------------------
    constant Fifo         : in    ScoreboardIdType ;
    constant FirstWord    : in    integer ;
    constant Count        : in    integer ;
    constant FifoWidth    : in    integer := 8
  ) is
    variable RV           : RandomPType ; 
    variable intFirstWord : integer ; 
    variable slvFirstWord : std_logic_vector(FifoWidth-1 downto 0) ; 
  begin
    if FirstWord < 0 then 
      intFirstWord := -FirstWord ; 
    else
      intFirstWord := FirstWord ; 
    end if ; 
    
    -- Initialize seed and toss first random value  
    RV.InitSeed(intFirstWord mod 2**30 + Count, UseNewSeedMethods => TRUE) ;
    
    if FifoWidth < NUMBER_POSITIVE_INTEGER_BITS then 
      CheckExpected(Fifo, to_slv(intFirstWord mod (2**FifoWidth), FifoWidth)) ;
    else 
      CheckExpected(Fifo, to_slv(intFirstWord, FifoWidth)) ;
    end if ; 
    
    for i in 2 to Count loop 
      -- Extra Var added for QuestaSim
      slvFirstWord := RV.RandSlv(FifoWidth) ; 
      CheckExpected(Fifo, slvFirstWord) ;
    end loop ;
  end procedure CheckBurstRandom ;
  
  ------------------------------------------------------------
  -- Experimental and Provisional
  procedure CheckBurstRandom (
  ------------------------------------------------------------
    constant Fifo         : in    ScoreboardIdType ;
    constant CoverID      : in    CoverageIdType ;
    constant Count        : in    integer ;
    constant FifoWidth    : in    integer := 8
  ) is
    variable RandValue : std_logic_vector(FifoWidth-1 downto 0) ; 
  begin    
    for i in 1 to Count loop 
      RandValue := to_slv(GetRandPoint(CoverID), FifoWidth) ;
      CheckExpected(Fifo, RandValue) ;
      ICoverLast(CoverID) ; 
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
    constant Data              : in    std_logic_vector ;
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

  -- ========================================================
  --  Deprecated
  -- ========================================================

  ------------------------------------------------------------
  -- Deprecated.  Replaced by PushBurstVector
  procedure PushBurst (
  ------------------------------------------------------------
    constant Fifo           : in    ScoreboardIdType ;
    constant VectorOfWords  : in    integer_vector ;
    constant FifoWidth      : in    integer := 8
  ) is
  begin
    PushBurstVector(Fifo, VectorOfWords, FifoWidth) ; 
  end procedure PushBurst ;

  ------------------------------------------------------------
  -- Deprecated and replaced by CheckBurstVector
  procedure CheckBurst (
  -- Pop values from the FIFO and check them against each value 
  -- in the VectorOfWords parameter.   
  -- Each value popped will be FifoWidth bits wide.   
  ------------------------------------------------------------
    constant Fifo           : in    ScoreboardIdType ;
    constant VectorOfWords  : in    integer_vector ;
    constant FifoWidth      : in    integer := 8
  ) is
  begin
    CheckBurstVector(Fifo, VectorOfWords, FifoWidth) ; 
  end procedure CheckBurst ;
  
end FifoFillPkg_slv ;