--
--  File Name:         StreamTransactionArrayPkg.vhd
--  Design Unit Name:  StreamTransactionArrayPkg
--  Revision:          OSVVM MODELS STANDARD VERSION
--
--  Maintainer:        Jim Lewis      email:  jim@synthworks.com
--  Contributor(s):
--     Jim Lewis      jim@synthworks.com
--
--
--  Description:
--    Defines Stream transaction initiation procedures (Send, Get, ...)
--    for arrays of Stream Interfaces (StreamRecArrayType).
--    Companion to StreamTransactionPkg.vhd
--    
--    This works around a VHDL issue documented in 
--    https://gitlab.com/IEEE-P1076/VHDL-Issues/-/issues/275
--    When this issue is fixed and implemented, this package will
--    no longer be needed
--
--
--  Developed by:
--        SynthWorks Design Inc.
--        VHDL Training Classes
--        http://www.SynthWorks.com
--
--  Revision History:
--    Date      Version    Description
--    11/2022   2022.11    initial
--
--
--  This file is part of OSVVM.
--  
--  Copyright (c) 2022 by SynthWorks Design Inc.  
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

  use std.textio.all ;

library osvvm ; 
  context osvvm.OsvvmContext ;  
  use osvvm.ScoreboardPkg_slv.all ; 
  
  use work.FifoFillPkg_slv.all ; 
  use work.StreamTransactionPkg.all ; 

package StreamTransactionArrayPkg is 

  -- ========================================================
  --  Directive Transactions  
  --  Directive transactions interact with the verification component 
  --  without generating any transactions or interface waveforms.
  --  Supported by all verification components
  -- ========================================================
  ------------------------------------------------------------
  procedure WaitForTransaction (
  --  Wait until pending (transmit) or next (receive) transaction(s) complete
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer 
  ) ; 

  ------------------------------------------------------------
  procedure WaitForClock (
  -- Wait for NumberOfClocks number of clocks 
  -- relative to the verification component clock
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  WaitCycles       : in    natural := 1
  ) ; 
  
  ------------------------------------------------------------
  procedure GetTransactionCount (
  -- Get the number of transactions handled by the model.  
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    variable  TransactionCount : out   integer 
  ) ; 

  ------------------------------------------------------------
  procedure GetAlertLogID (
  -- Get the AlertLogID from the verification component.
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    variable  AlertLogID       : out   AlertLogIDType 
  ) ; 
  
  ------------------------------------------------------------
  procedure GetErrorCount (
  -- Error reporting for testbenches that do not use OSVVM AlertLogPkg
  -- Returns error count.  If an error count /= 0, also print errors
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    variable  ErrorCount       : out   natural
  ) ; 
  
  -- ========================================================
  --  Delay Coverage Transactions   
  --  Get Delay Coverage ID to change delay coverage parameters.
  -- ========================================================
  ------------------------------------------------------------
  procedure SetUseRandomDelays (
  ------------------------------------------------------------
    signal    TransactionRec : InOut StreamRecArrayType ;
    constant  Index          : in    integer ;
    constant  OptVal         : In    boolean := TRUE
  ) ;

  ------------------------------------------------------------
  procedure GetUseRandomDelays (
  ------------------------------------------------------------
    signal    TransactionRec : InOut StreamRecArrayType ;
    constant  Index          : in    integer ;
    variable  OptVal         : Out   boolean
  ) ;

  ------------------------------------------------------------
  procedure SetDelayCoverageID (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  DelayCov         : in    DelayCoverageIdType 
  ) ;

  ------------------------------------------------------------
  procedure GetDelayCoverageID (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    variable  DelayCov         : out   DelayCoverageIdType 
  ) ;

  ------------------------------------------------------------
  --  SetBurstMode and GetBurstMode
  --  are directive transactions that configure the burst mode 
  --  into one of the modes defined for StreamFifoBurstModeType
  ------------------------------------------------------------
  ------------------------------------------------------------
  procedure SetBurstMode (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  OptVal           : in    StreamFifoBurstModeType
  ) ;

  ------------------------------------------------------------
  procedure GetBurstMode (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    variable  OptVal           : out   StreamFifoBurstModeType
  ) ;

  ------------------------------------------------------------
  --  GotBurst   
  --  Check to see if Read Burst is available
  --  Primarily used internally
  ------------------------------------------------------------
  ------------------------------------------------------------
  procedure GotBurst (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  NumFifoWords     : in    integer ;
    variable  Available        : out   boolean
  ) ;

  -- ========================================================
  --  Set and Get Model Options  
  --  Model operations are directive transactions that are  
  --  used to configure the verification component.  
  --  They can either be used directly or with a model specific
  --  wrapper around them - see AXI models for examples.
  -- ========================================================
  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Option           : in    integer ;
    constant  OptVal           : in    boolean
  ) ;

  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Option           : in    integer ;
    constant  OptVal           : in    integer
  ) ;

  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Option           : in    integer ;
    constant  OptVal           : in    std_logic_vector
  ) ;
  
  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Option           : in    integer ;
    constant  OptVal           : in    time
  ) ;
  
  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Option           : in    integer 
  ) ;
  
  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Option           : in    integer ;
    variable  OptVal           : out   boolean
  ) ;

  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Option           : in    integer ;
    variable  OptVal           : out   integer
  ) ;

  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Option           : in    integer ;
    variable  OptVal           : out   std_logic_vector
  ) ;
  
  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Option           : in    integer ;
    variable  OptVal           : out   time
  ) ;
  
  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Option           : in    integer 
  ) ;


  -- ========================================================
  --  Transmitter Transactions
  -- ========================================================

  -- ========================================================
  -- Send
  -- Blocking Send Transaction. 
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for error injection.
  -- ========================================================
  
  ------------------------------------------------------------
  procedure Send (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Data             : in    std_logic_vector ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false 
  ) ; 

  ------------------------------------------------------------
  procedure Send (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Data             : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false 
  ) ; 
  

  -- ========================================================
  -- SendAsync
  -- Asynchronous / Non-Blocking Send Transaction
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for error injection. 
  -- ========================================================

  ------------------------------------------------------------
  procedure SendAsync (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Data             : in    std_logic_vector ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false 
  ) ; 

  ------------------------------------------------------------
  procedure SendAsync (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Data             : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false 
  ) ; 


  -- ========================================================
  -- SendBurst
  -- Blocking Send Burst Transaction. 
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for error injection.
  -- ========================================================

  ------------------------------------------------------------
  procedure SendBurst (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  NumFifoWords     : in    integer ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false 
  ) ; 

  ------------------------------------------------------------
  procedure SendBurst (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  NumFifoWords     : in    integer ;
    constant  StatusMsgOn      : in    boolean := false 
  ) ; 
  
  ------------------------------------------------------------
  procedure SendBurstVector (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  VectorOfWords    : in    slv_vector ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false
  ) ;
  
  ------------------------------------------------------------
  procedure SendBurstVector (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  VectorOfWords    : in    slv_vector ;
    constant  StatusMsgOn      : in    boolean := false
  ) ;
  
--  alias SendBurst is SendBurstVector[StreamRecArrayType, slv_vector, std_logic_vector, boolean] ; 
--  alias SendBurst is SendBurstVector[StreamRecArrayType, slv_vector, boolean] ; 

  ------------------------------------------------------------
  procedure SendBurstVector (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  VectorOfWords    : in    integer_vector ;
    constant  Param            : in    std_logic_vector ;
    constant  FifoWidth        : in    integer ; 
    constant  StatusMsgOn      : in    boolean := false
  ) ;
  
  ------------------------------------------------------------
  procedure SendBurstVector (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  VectorOfWords    : in    integer_vector ;
    constant  FifoWidth        : in    integer ; 
    constant  StatusMsgOn      : in    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure SendBurstIncrement (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  FirstWord        : in    std_logic_vector ;
    constant  NumFifoWords     : in    integer ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure SendBurstIncrement (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  FirstWord        : in    std_logic_vector ;
    constant  NumFifoWords     : in    integer ;
    constant  StatusMsgOn      : in    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure SendBurstRandom (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  FirstWord        : in    std_logic_vector ;
    constant  NumFifoWords     : in    integer ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure SendBurstRandom (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  FirstWord        : in    std_logic_vector ;
    constant  NumFifoWords     : in    integer ;
    constant  StatusMsgOn      : in    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure SendBurstRandom (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  CoverID          : in    CoverageIDType ;
    constant  NumFifoWords     : in    integer ;
    constant  FifoWidth        : in    integer ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure SendBurstRandom (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  CoverID          : in    CoverageIDType ;
    constant  NumFifoWords     : in    integer ;
    constant  FifoWidth        : in    integer ;
    constant  StatusMsgOn      : in    boolean := false
  ) ;

  -- ========================================================
  -- SendBurstAsync
  -- Asynchronous / Non-Blocking Send Transaction
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for error injection. 
  -- ========================================================

  ------------------------------------------------------------
  procedure SendBurstAsync (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  NumFifoWords     : in    integer ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false 
  ) ; 

  ------------------------------------------------------------
  procedure SendBurstAsync (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  NumFifoWords     : in    integer ;
    constant  StatusMsgOn      : in    boolean := false 
  ) ; 
  
  ------------------------------------------------------------
  procedure SendBurstVectorAsync (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  VectorOfWords    : in    slv_vector ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false
  ) ;
  
  ------------------------------------------------------------
  procedure SendBurstVectorAsync (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  VectorOfWords    : in    slv_vector ;
    constant  StatusMsgOn      : in    boolean := false
  ) ;
  
--  alias SendBurstAsync is SendBurstVectorAsync[StreamRecArrayType, slv_vector, std_logic_vector, boolean] ; 
--  alias SendBurstAsync is SendBurstVectorAsync[StreamRecArrayType, slv_vector, boolean] ; 

  ------------------------------------------------------------
  procedure SendBurstVectorAsync (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  VectorOfWords    : in    integer_vector ;
    constant  Param            : in    std_logic_vector ;
    constant  FifoWidth        : in    integer ; 
    constant  StatusMsgOn      : in    boolean := false
  ) ;
  
  ------------------------------------------------------------
  procedure SendBurstVectorAsync (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  VectorOfWords    : in    integer_vector ;
    constant  FifoWidth        : in    integer ; 
    constant  StatusMsgOn      : in    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure SendBurstIncrementAsync (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  FirstWord        : in    std_logic_vector ;
    constant  NumFifoWords     : in    integer ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure SendBurstIncrementAsync (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  FirstWord        : in    std_logic_vector ;
    constant  NumFifoWords     : in    integer ;
    constant  StatusMsgOn      : in    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure SendBurstRandomAsync (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  FirstWord        : in    std_logic_vector ;
    constant  NumFifoWords     : in    integer ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure SendBurstRandomAsync (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  FirstWord        : in    std_logic_vector ;
    constant  NumFifoWords     : in    integer ;
    constant  StatusMsgOn      : in    boolean := false
  ) ;
  
  ------------------------------------------------------------
  procedure SendBurstRandomAsync (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  CoverID          : in    CoverageIDType ;
    constant  NumFifoWords     : in    integer ;
    constant  FifoWidth        : in    integer ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure SendBurstRandomAsync (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  CoverID          : in    CoverageIDType ;
    constant  NumFifoWords     : in    integer ;
    constant  FifoWidth        : in    integer ;
    constant  StatusMsgOn      : in    boolean := false
  ) ;

  -- ========================================================
  --  Receiver Transactions
  -- ========================================================

  -- ========================================================
  -- Get
  -- Blocking Get Transaction. 
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for received error status.
  -- ========================================================

  ------------------------------------------------------------
  procedure Get (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    variable  Data             : out   std_logic_vector ;
    variable  Param            : out   std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false 
  ) ; 

  ------------------------------------------------------------
  procedure Get (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    variable  Data             : out   std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false 
  ) ; 


  -- ========================================================
  -- TryGet
  -- Try Get Transaction
  -- If Data is available, get it and return available TRUE,
  -- otherwise Return Available FALSE.
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for received error status.
  -- ========================================================

  ------------------------------------------------------------
  procedure TryGet (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    variable  Data             : out   std_logic_vector ;
    variable  Available        : out   boolean ;
    constant  StatusMsgOn      : in    boolean := false 
  ) ; 
  
  ------------------------------------------------------------
  procedure TryGet (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    variable  Data             : out   std_logic_vector ;
    variable  Param            : out   std_logic_vector ;
    variable  Available        : out   boolean ;
    constant  StatusMsgOn      : in    boolean := false 
  ) ;  


  -- ========================================================
  -- GetBurst
  -- Blocking Get Burst Transaction. 
  -- Param, when present, is an extra parameter from the verification component
  -- The UART verification component uses Param for received error status.
  -- ========================================================

  ------------------------------------------------------------
  procedure GetBurst (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    variable  NumFifoWords     : inout integer ;
    constant  StatusMsgOn      : in    boolean := false 
  ) ; 
  
  ------------------------------------------------------------
  procedure GetBurst (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    variable  NumFifoWords     : inout integer ;
    variable  Param            : out   std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false 
  ) ;  

  -- ========================================================
  -- TryGetBurst
  -- Try Get Burst Transaction
  -- If Data is available, get it and return available TRUE,
  -- otherwise Return Available FALSE.
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for received error status.
  -- ========================================================

  ------------------------------------------------------------
  procedure TryGetBurst (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    variable  NumFifoWords     : inout integer ;
    variable  Available        : out   boolean ;
    constant  StatusMsgOn      : in    boolean := false 
  ) ; 
  
  ------------------------------------------------------------
  procedure TryGetBurst (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    variable  NumFifoWords     : inout integer ;
    variable  Param            : out   std_logic_vector ;
    variable  Available        : out   boolean ;
    constant  StatusMsgOn      : in    boolean := false 
  ) ;  


  -- ========================================================
  -- Check
  -- Blocking Check Transaction. 
  -- Data is the expected value to be received.
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for received error status.
  -- ========================================================

  ------------------------------------------------------------
  procedure Check (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Data             : in    std_logic_vector ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false 
  ) ; 

  ------------------------------------------------------------
  procedure Check (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Data             : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false 
  ) ; 


  -- ========================================================
  -- TryCheck
  -- Try Check Transaction
  -- If Data is available, check it and return available TRUE,
  -- otherwise Return Available FALSE.
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for received error status.
  -- ========================================================

  ------------------------------------------------------------
  procedure TryCheck (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Data             : in    std_logic_vector ;
    constant  Param            : in    std_logic_vector ;
    variable  Available        : out   boolean ;
    constant  StatusMsgOn      : in    boolean := false 
  ) ; 

  ------------------------------------------------------------
  procedure TryCheck (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Data             : in    std_logic_vector ;
    variable  Available        : out   boolean ;
    constant  StatusMsgOn      : in    boolean := false 
  ) ; 

  -- ========================================================
  -- CheckBurst
  -- Blocking Check Burst Transaction. 
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for checking error injection.
  -- ========================================================
  ------------------------------------------------------------
  procedure CheckBurst (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  NumFifoWords     : in    integer ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false 
  ) ; 

  ------------------------------------------------------------
  procedure CheckBurst (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  NumFifoWords     : in    integer ;
    constant  StatusMsgOn      : in    boolean := false 
  ) ; 

  ------------------------------------------------------------
  procedure CheckBurstVector (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  VectorOfWords    : in    slv_vector ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false
  ) ;
  
  ------------------------------------------------------------
  procedure CheckBurstVector (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  VectorOfWords    : in    slv_vector ;
    constant  StatusMsgOn      : in    boolean := false
  ) ;
  
--  alias CheckBurst is CheckBurstVector[StreamRecArrayType, slv_vector, std_logic_vector, boolean] ; 
--  alias CheckBurst is CheckBurstVector[StreamRecArrayType, slv_vector, boolean] ; 

  ------------------------------------------------------------
  procedure CheckBurstVector (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  VectorOfWords    : in    integer_vector ;
    constant  Param            : in    std_logic_vector ;
    constant  FifoWidth        : in    integer ; 
    constant  StatusMsgOn      : in    boolean := false
  ) ;
  
  ------------------------------------------------------------
  procedure CheckBurstVector (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  VectorOfWords    : in    integer_vector ;
    constant  FifoWidth        : in    integer ; 
    constant  StatusMsgOn      : in    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure CheckBurstIncrement (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  FirstWord        : in    std_logic_vector ;
    constant  NumFifoWords     : in    integer ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure CheckBurstIncrement (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  FirstWord        : in    std_logic_vector ;
    constant  NumFifoWords     : in    integer ;
    constant  StatusMsgOn      : in    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure CheckBurstRandom (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  FirstWord        : in    std_logic_vector ;
    constant  NumFifoWords     : in    integer ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure CheckBurstRandom (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  FirstWord        : in    std_logic_vector ;
    constant  NumFifoWords     : in    integer ;
    constant  StatusMsgOn      : in    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure CheckBurstRandom (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  CoverID          : in    CoverageIDType ;
    constant  NumFifoWords     : in    integer ;
    constant  FifoWidth        : in    integer ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false
  ) ;  

  ------------------------------------------------------------
  procedure CheckBurstRandom (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  CoverID          : in    CoverageIDType ;
    constant  NumFifoWords     : in    integer ;
    constant  FifoWidth        : in    integer ;
    constant  StatusMsgOn      : in    boolean := false
  ) ;  

  -- ========================================================
  -- TryCheckBurst
  -- Try / Non-Blocking Check Burst Transaction
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for error injection. 
  -- ========================================================

  ------------------------------------------------------------
  procedure TryCheckBurst (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  NumFifoWords     : in    integer ;
    constant  Param            : in    std_logic_vector ;
    variable  Available        : out   boolean ;
    constant  StatusMsgOn      : in    boolean := false 
  ) ; 
  
  ------------------------------------------------------------
  procedure TryCheckBurst (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  NumFifoWords     : in    integer ;
    variable  Available        : out   boolean ;
    constant  StatusMsgOn      : in    boolean := false 
  ) ; 
  
  ------------------------------------------------------------
  procedure TryCheckBurstVector (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  VectorOfWords    : in    slv_vector ;
    constant  Param            : in    std_logic_vector ;
    variable  Available        : out   boolean ;
    constant  StatusMsgOn      : in    boolean := false
  )  ;
  
  ------------------------------------------------------------
  procedure TryCheckBurstVector (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  VectorOfWords    : in    slv_vector ;
    variable  Available        : out   boolean ;
    constant  StatusMsgOn      : in    boolean := false
  ) ;

--  alias TryCheckBurst is TryCheckBurstVector[StreamRecArrayType, slv_vector, std_logic_vector, boolean, boolean] ; 
--  alias TryCheckBurst is TryCheckBurstVector[StreamRecArrayType, slv_vector, boolean, boolean] ; 
  
  ------------------------------------------------------------
  procedure TryCheckBurstIncrement (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  FirstWord        : in    std_logic_vector ;
    constant  NumFifoWords     : in    integer ;
    constant  Param            : in    std_logic_vector ;
    variable  Available        : out   boolean ;
    constant  StatusMsgOn      : in    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure TryCheckBurstIncrement (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  FirstWord        : in    std_logic_vector ;
    constant  NumFifoWords     : in    integer ;
    variable  Available        : out   boolean ;
    constant  StatusMsgOn      : in    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure TryCheckBurstRandom (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  FirstWord        : in    std_logic_vector ;
    constant  NumFifoWords     : in    integer ;
    constant  Param            : in    std_logic_vector ;
    variable  Available        : out   boolean ;
    constant  StatusMsgOn      : in    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure TryCheckBurstRandom (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  FirstWord        : in    std_logic_vector ;
    constant  NumFifoWords     : in    integer ;
    variable  Available        : out   boolean ;
    constant  StatusMsgOn      : in    boolean := false
  ) ;

  ------------------------------------------------------------
  procedure TryCheckBurstRandom (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  CoverID          : in    CoverageIDType ;
    constant  NumFifoWords     : in    integer ;
    constant  FifoWidth        : in    integer ;
    constant  Param            : in    std_logic_vector ;
    variable  Available        : out   boolean ;
    constant  StatusMsgOn      : in    boolean := false
  ) ;  

  ------------------------------------------------------------
  procedure TryCheckBurstRandom (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  CoverID          : in    CoverageIDType ;
    constant  NumFifoWords     : in    integer ;
    constant  FifoWidth        : in    integer ;
    variable  Available        : out   boolean ;
    constant  StatusMsgOn      : in    boolean := false
  ) ;  

  -- ========================================================
  --  Send And Get Transactions
  -- 
  -- ========================================================
  ------------------------------------------------------------
  procedure SendAndGet (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  iData            : in    std_logic_vector ;
    constant  iParam           : in    std_logic_vector ;
    variable  oData            : out   std_logic_vector ;
    variable  oParam           : out   std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false 
  ) ;  

  ------------------------------------------------------------
  procedure SendAndGet (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  iData            : in    std_logic_vector ;
    variable  oData            : out   std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false 
  ) ;  

  ------------------------------------------------------------
  procedure SendAndGetBurst (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  iNumFifoWords    : in    integer ;
    constant  iParam           : in    std_logic_vector ;
    variable  oNumFifoWords    : out   integer ;
    variable  oParam           : out   std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false 
  ) ; 

  ------------------------------------------------------------
  procedure SendAndGetBurst (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  iNumFifoWords    : in    integer ;
    variable  oNumFifoWords    : out   integer ;
    constant  StatusMsgOn      : in    boolean := false 
  ) ; 

  -- ========================================================
  --  Pseudo Transactions
  --  Interact with the record only.
  -- ========================================================
  ------------------------------------------------------------
  procedure ReleaseTransactionRecord (
  --  Must run on same delta cycle as AcquireTransactionRecord
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer 
  ) ; 
  
  ------------------------------------------------------------
  procedure AcquireTransactionRecord (
  --  Must run on same delta cycle as ReleaseTransactionRecord
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer 
  ) ; 
end package StreamTransactionArrayPkg ;

package body StreamTransactionArrayPkg is 

  ------------------------------------------------------------
  procedure StreamArrayRequestTransaction (
  --  Package Local
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer 
  ) is
  begin
    case Index is 
      when  0 =>  RequestTransaction(Rdy => TransactionRec( 0).Rdy, Ack => TransactionRec( 0).Ack) ; 
      when  1 =>  RequestTransaction(Rdy => TransactionRec( 1).Rdy, Ack => TransactionRec( 1).Ack) ; 
      when  2 =>  RequestTransaction(Rdy => TransactionRec( 2).Rdy, Ack => TransactionRec( 2).Ack) ; 
      when  3 =>  RequestTransaction(Rdy => TransactionRec( 3).Rdy, Ack => TransactionRec( 3).Ack) ; 
      when  4 =>  RequestTransaction(Rdy => TransactionRec( 4).Rdy, Ack => TransactionRec( 4).Ack) ; 
      when  5 =>  RequestTransaction(Rdy => TransactionRec( 5).Rdy, Ack => TransactionRec( 5).Ack) ; 
      when  6 =>  RequestTransaction(Rdy => TransactionRec( 6).Rdy, Ack => TransactionRec( 6).Ack) ; 
      when  7 =>  RequestTransaction(Rdy => TransactionRec( 7).Rdy, Ack => TransactionRec( 7).Ack) ; 
      when  8 =>  RequestTransaction(Rdy => TransactionRec( 8).Rdy, Ack => TransactionRec( 8).Ack) ; 
      when  9 =>  RequestTransaction(Rdy => TransactionRec( 9).Rdy, Ack => TransactionRec( 9).Ack) ; 
      when 10 =>  RequestTransaction(Rdy => TransactionRec(10).Rdy, Ack => TransactionRec(10).Ack) ; 
      when 11 =>  RequestTransaction(Rdy => TransactionRec(11).Rdy, Ack => TransactionRec(11).Ack) ; 
      when 12 =>  RequestTransaction(Rdy => TransactionRec(12).Rdy, Ack => TransactionRec(12).Ack) ; 
      when 13 =>  RequestTransaction(Rdy => TransactionRec(13).Rdy, Ack => TransactionRec(13).Ack) ; 
      when 14 =>  RequestTransaction(Rdy => TransactionRec(14).Rdy, Ack => TransactionRec(14).Ack) ; 
      when 15 =>  RequestTransaction(Rdy => TransactionRec(15).Rdy, Ack => TransactionRec(15).Ack) ; 
      when 16 =>  RequestTransaction(Rdy => TransactionRec(16).Rdy, Ack => TransactionRec(16).Ack) ; 
      when 17 =>  RequestTransaction(Rdy => TransactionRec(17).Rdy, Ack => TransactionRec(17).Ack) ; 
      when 18 =>  RequestTransaction(Rdy => TransactionRec(18).Rdy, Ack => TransactionRec(18).Ack) ; 
      when 19 =>  RequestTransaction(Rdy => TransactionRec(19).Rdy, Ack => TransactionRec(19).Ack) ; 
      when 20 =>  RequestTransaction(Rdy => TransactionRec(20).Rdy, Ack => TransactionRec(20).Ack) ; 
      when 21 =>  RequestTransaction(Rdy => TransactionRec(21).Rdy, Ack => TransactionRec(21).Ack) ; 
      when 22 =>  RequestTransaction(Rdy => TransactionRec(22).Rdy, Ack => TransactionRec(22).Ack) ; 
      when 23 =>  RequestTransaction(Rdy => TransactionRec(23).Rdy, Ack => TransactionRec(23).Ack) ; 
      when 24 =>  RequestTransaction(Rdy => TransactionRec(24).Rdy, Ack => TransactionRec(24).Ack) ; 
      when 25 =>  RequestTransaction(Rdy => TransactionRec(25).Rdy, Ack => TransactionRec(25).Ack) ; 
      when 26 =>  RequestTransaction(Rdy => TransactionRec(26).Rdy, Ack => TransactionRec(26).Ack) ; 
      when 27 =>  RequestTransaction(Rdy => TransactionRec(27).Rdy, Ack => TransactionRec(27).Ack) ; 
      when 28 =>  RequestTransaction(Rdy => TransactionRec(28).Rdy, Ack => TransactionRec(28).Ack) ; 
      when 29 =>  RequestTransaction(Rdy => TransactionRec(29).Rdy, Ack => TransactionRec(29).Ack) ; 
      when 30 =>  RequestTransaction(Rdy => TransactionRec(30).Rdy, Ack => TransactionRec(30).Ack) ; 
      when 31 =>  RequestTransaction(Rdy => TransactionRec(31).Rdy, Ack => TransactionRec(31).Ack) ; 
      when 32 =>  RequestTransaction(Rdy => TransactionRec(32).Rdy, Ack => TransactionRec(32).Ack) ; 
      when 33 =>  RequestTransaction(Rdy => TransactionRec(33).Rdy, Ack => TransactionRec(33).Ack) ; 
      when 34 =>  RequestTransaction(Rdy => TransactionRec(34).Rdy, Ack => TransactionRec(34).Ack) ; 
      when 35 =>  RequestTransaction(Rdy => TransactionRec(35).Rdy, Ack => TransactionRec(35).Ack) ; 
      when 36 =>  RequestTransaction(Rdy => TransactionRec(36).Rdy, Ack => TransactionRec(36).Ack) ; 
      when 37 =>  RequestTransaction(Rdy => TransactionRec(37).Rdy, Ack => TransactionRec(37).Ack) ; 
      when 38 =>  RequestTransaction(Rdy => TransactionRec(38).Rdy, Ack => TransactionRec(38).Ack) ; 
      when 39 =>  RequestTransaction(Rdy => TransactionRec(39).Rdy, Ack => TransactionRec(39).Ack) ; 
      when 40 =>  RequestTransaction(Rdy => TransactionRec(40).Rdy, Ack => TransactionRec(40).Ack) ; 
      when 41 =>  RequestTransaction(Rdy => TransactionRec(41).Rdy, Ack => TransactionRec(41).Ack) ; 
      when 42 =>  RequestTransaction(Rdy => TransactionRec(42).Rdy, Ack => TransactionRec(42).Ack) ; 
      when 43 =>  RequestTransaction(Rdy => TransactionRec(43).Rdy, Ack => TransactionRec(43).Ack) ; 
      when 44 =>  RequestTransaction(Rdy => TransactionRec(44).Rdy, Ack => TransactionRec(44).Ack) ; 
      when 45 =>  RequestTransaction(Rdy => TransactionRec(45).Rdy, Ack => TransactionRec(45).Ack) ; 
      when 46 =>  RequestTransaction(Rdy => TransactionRec(46).Rdy, Ack => TransactionRec(46).Ack) ; 
      when 47 =>  RequestTransaction(Rdy => TransactionRec(47).Rdy, Ack => TransactionRec(47).Ack) ; 
      when 48 =>  RequestTransaction(Rdy => TransactionRec(48).Rdy, Ack => TransactionRec(48).Ack) ; 
      when 49 =>  RequestTransaction(Rdy => TransactionRec(49).Rdy, Ack => TransactionRec(49).Ack) ; 
      when 50 =>  RequestTransaction(Rdy => TransactionRec(50).Rdy, Ack => TransactionRec(50).Ack) ; 
      when 51 =>  RequestTransaction(Rdy => TransactionRec(51).Rdy, Ack => TransactionRec(51).Ack) ; 
      when 52 =>  RequestTransaction(Rdy => TransactionRec(52).Rdy, Ack => TransactionRec(52).Ack) ; 
      when 53 =>  RequestTransaction(Rdy => TransactionRec(53).Rdy, Ack => TransactionRec(53).Ack) ; 
      when 54 =>  RequestTransaction(Rdy => TransactionRec(54).Rdy, Ack => TransactionRec(54).Ack) ; 
      when 55 =>  RequestTransaction(Rdy => TransactionRec(55).Rdy, Ack => TransactionRec(55).Ack) ; 
      when 56 =>  RequestTransaction(Rdy => TransactionRec(56).Rdy, Ack => TransactionRec(56).Ack) ; 
      when 57 =>  RequestTransaction(Rdy => TransactionRec(57).Rdy, Ack => TransactionRec(57).Ack) ; 
      when 58 =>  RequestTransaction(Rdy => TransactionRec(58).Rdy, Ack => TransactionRec(58).Ack) ; 
      when 59 =>  RequestTransaction(Rdy => TransactionRec(59).Rdy, Ack => TransactionRec(59).Ack) ; 
      when 60 =>  RequestTransaction(Rdy => TransactionRec(60).Rdy, Ack => TransactionRec(60).Ack) ; 
      when 61 =>  RequestTransaction(Rdy => TransactionRec(61).Rdy, Ack => TransactionRec(61).Ack) ; 
      when 62 =>  RequestTransaction(Rdy => TransactionRec(62).Rdy, Ack => TransactionRec(62).Ack) ; 
      when 63 =>  RequestTransaction(Rdy => TransactionRec(63).Rdy, Ack => TransactionRec(63).Ack) ; 
      when 64 =>  RequestTransaction(Rdy => TransactionRec(64).Rdy, Ack => TransactionRec(64).Ack) ; 
      when 65 =>  RequestTransaction(Rdy => TransactionRec(65).Rdy, Ack => TransactionRec(65).Ack) ; 
      when 66 =>  RequestTransaction(Rdy => TransactionRec(66).Rdy, Ack => TransactionRec(66).Ack) ; 
      when 67 =>  RequestTransaction(Rdy => TransactionRec(67).Rdy, Ack => TransactionRec(67).Ack) ; 
      when 68 =>  RequestTransaction(Rdy => TransactionRec(68).Rdy, Ack => TransactionRec(68).Ack) ; 
      when 69 =>  RequestTransaction(Rdy => TransactionRec(69).Rdy, Ack => TransactionRec(69).Ack) ; 
      when 70 =>  RequestTransaction(Rdy => TransactionRec(70).Rdy, Ack => TransactionRec(70).Ack) ; 
      when 71 =>  RequestTransaction(Rdy => TransactionRec(71).Rdy, Ack => TransactionRec(71).Ack) ; 
      when 72 =>  RequestTransaction(Rdy => TransactionRec(72).Rdy, Ack => TransactionRec(72).Ack) ; 
      when 73 =>  RequestTransaction(Rdy => TransactionRec(73).Rdy, Ack => TransactionRec(73).Ack) ; 
      when 74 =>  RequestTransaction(Rdy => TransactionRec(74).Rdy, Ack => TransactionRec(74).Ack) ; 
      when 75 =>  RequestTransaction(Rdy => TransactionRec(75).Rdy, Ack => TransactionRec(75).Ack) ; 
      when 76 =>  RequestTransaction(Rdy => TransactionRec(76).Rdy, Ack => TransactionRec(76).Ack) ; 
      when 77 =>  RequestTransaction(Rdy => TransactionRec(77).Rdy, Ack => TransactionRec(77).Ack) ; 
      when 78 =>  RequestTransaction(Rdy => TransactionRec(78).Rdy, Ack => TransactionRec(78).Ack) ; 
      when 79 =>  RequestTransaction(Rdy => TransactionRec(79).Rdy, Ack => TransactionRec(79).Ack) ; 
      when 80 =>  RequestTransaction(Rdy => TransactionRec(80).Rdy, Ack => TransactionRec(80).Ack) ; 
      when 81 =>  RequestTransaction(Rdy => TransactionRec(81).Rdy, Ack => TransactionRec(81).Ack) ; 
      when 82 =>  RequestTransaction(Rdy => TransactionRec(82).Rdy, Ack => TransactionRec(82).Ack) ; 
      when 83 =>  RequestTransaction(Rdy => TransactionRec(83).Rdy, Ack => TransactionRec(83).Ack) ; 
      when 84 =>  RequestTransaction(Rdy => TransactionRec(84).Rdy, Ack => TransactionRec(84).Ack) ; 
      when 85 =>  RequestTransaction(Rdy => TransactionRec(85).Rdy, Ack => TransactionRec(85).Ack) ; 
      when 86 =>  RequestTransaction(Rdy => TransactionRec(86).Rdy, Ack => TransactionRec(86).Ack) ; 
      when 87 =>  RequestTransaction(Rdy => TransactionRec(87).Rdy, Ack => TransactionRec(87).Ack) ; 
      when 88 =>  RequestTransaction(Rdy => TransactionRec(88).Rdy, Ack => TransactionRec(88).Ack) ; 
      when 89 =>  RequestTransaction(Rdy => TransactionRec(89).Rdy, Ack => TransactionRec(89).Ack) ; 
      when 90 =>  RequestTransaction(Rdy => TransactionRec(90).Rdy, Ack => TransactionRec(90).Ack) ; 
      when 91 =>  RequestTransaction(Rdy => TransactionRec(91).Rdy, Ack => TransactionRec(91).Ack) ; 
      when 92 =>  RequestTransaction(Rdy => TransactionRec(92).Rdy, Ack => TransactionRec(92).Ack) ; 
      when 93 =>  RequestTransaction(Rdy => TransactionRec(93).Rdy, Ack => TransactionRec(93).Ack) ; 
      when 94 =>  RequestTransaction(Rdy => TransactionRec(94).Rdy, Ack => TransactionRec(94).Ack) ; 
      when 95 =>  RequestTransaction(Rdy => TransactionRec(95).Rdy, Ack => TransactionRec(95).Ack) ; 
      when 96 =>  RequestTransaction(Rdy => TransactionRec(96).Rdy, Ack => TransactionRec(96).Ack) ; 
      when 97 =>  RequestTransaction(Rdy => TransactionRec(97).Rdy, Ack => TransactionRec(97).Ack) ; 
      when 98 =>  RequestTransaction(Rdy => TransactionRec(98).Rdy, Ack => TransactionRec(98).Ack) ; 
      when 99 =>  RequestTransaction(Rdy => TransactionRec(99).Rdy, Ack => TransactionRec(99).Ack) ; 
      when 100 =>  RequestTransaction(Rdy => TransactionRec(100).Rdy, Ack => TransactionRec(100).Ack) ; 
      when 101 =>  RequestTransaction(Rdy => TransactionRec(101).Rdy, Ack => TransactionRec(101).Ack) ; 
      when 102 =>  RequestTransaction(Rdy => TransactionRec(102).Rdy, Ack => TransactionRec(102).Ack) ; 
      when 103 =>  RequestTransaction(Rdy => TransactionRec(103).Rdy, Ack => TransactionRec(103).Ack) ; 
      when 104 =>  RequestTransaction(Rdy => TransactionRec(104).Rdy, Ack => TransactionRec(104).Ack) ; 
      when 105 =>  RequestTransaction(Rdy => TransactionRec(105).Rdy, Ack => TransactionRec(105).Ack) ; 
      when 106 =>  RequestTransaction(Rdy => TransactionRec(106).Rdy, Ack => TransactionRec(106).Ack) ; 
      when 107 =>  RequestTransaction(Rdy => TransactionRec(107).Rdy, Ack => TransactionRec(107).Ack) ; 
      when 108 =>  RequestTransaction(Rdy => TransactionRec(108).Rdy, Ack => TransactionRec(108).Ack) ; 
      when 109 =>  RequestTransaction(Rdy => TransactionRec(109).Rdy, Ack => TransactionRec(109).Ack) ; 
      when 110 =>  RequestTransaction(Rdy => TransactionRec(110).Rdy, Ack => TransactionRec(110).Ack) ; 
      when 111 =>  RequestTransaction(Rdy => TransactionRec(111).Rdy, Ack => TransactionRec(111).Ack) ; 
      when 112 =>  RequestTransaction(Rdy => TransactionRec(112).Rdy, Ack => TransactionRec(112).Ack) ; 
      when 113 =>  RequestTransaction(Rdy => TransactionRec(113).Rdy, Ack => TransactionRec(113).Ack) ; 
      when 114 =>  RequestTransaction(Rdy => TransactionRec(114).Rdy, Ack => TransactionRec(114).Ack) ; 
      when 115 =>  RequestTransaction(Rdy => TransactionRec(115).Rdy, Ack => TransactionRec(115).Ack) ; 
      when 116 =>  RequestTransaction(Rdy => TransactionRec(116).Rdy, Ack => TransactionRec(116).Ack) ; 
      when 117 =>  RequestTransaction(Rdy => TransactionRec(117).Rdy, Ack => TransactionRec(117).Ack) ; 
      when 118 =>  RequestTransaction(Rdy => TransactionRec(118).Rdy, Ack => TransactionRec(118).Ack) ; 
      when 119 =>  RequestTransaction(Rdy => TransactionRec(119).Rdy, Ack => TransactionRec(119).Ack) ; 
      when 120 =>  RequestTransaction(Rdy => TransactionRec(120).Rdy, Ack => TransactionRec(120).Ack) ; 
      when 121 =>  RequestTransaction(Rdy => TransactionRec(121).Rdy, Ack => TransactionRec(121).Ack) ; 
      when 122 =>  RequestTransaction(Rdy => TransactionRec(122).Rdy, Ack => TransactionRec(122).Ack) ; 
      when 123 =>  RequestTransaction(Rdy => TransactionRec(123).Rdy, Ack => TransactionRec(123).Ack) ; 
      when 124 =>  RequestTransaction(Rdy => TransactionRec(124).Rdy, Ack => TransactionRec(124).Ack) ; 
      when 125 =>  RequestTransaction(Rdy => TransactionRec(125).Rdy, Ack => TransactionRec(125).Ack) ; 
      when 126 =>  RequestTransaction(Rdy => TransactionRec(126).Rdy, Ack => TransactionRec(126).Ack) ; 
      when 127 =>  RequestTransaction(Rdy => TransactionRec(127).Rdy, Ack => TransactionRec(127).Ack) ; 
      when 128 =>  RequestTransaction(Rdy => TransactionRec(128).Rdy, Ack => TransactionRec(128).Ack) ; 
      when 129 =>  RequestTransaction(Rdy => TransactionRec(129).Rdy, Ack => TransactionRec(129).Ack) ; 
      when others => Alert("StreamTransactionArrayPkg: Please extend StreamArrayRequestTransaction to handle " & to_string(Index) & " indices") ; 
    end case ;  
  end procedure StreamArrayRequestTransaction ; 

  -- ========================================================
  --  Directive Transactions  
  --  Directive transactions interact with the verification component 
  --  without generating any transactions or interface waveforms.
  --  Supported by all verification components
  -- ========================================================
  ------------------------------------------------------------
  procedure WaitForTransaction (
  --  Wait until pending (transmit) or next (receive) transaction(s) complete
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer 
  ) is
  begin
    TransactionRec(Index).Operation   <= WAIT_FOR_TRANSACTION ;
    StreamArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ; 
  end procedure WaitForTransaction ; 

  ------------------------------------------------------------
  procedure WaitForClock (
  -- Wait for NumberOfClocks number of clocks 
  -- relative to the verification component clock
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  WaitCycles       : in    natural := 1
  ) is
  begin
    TransactionRec(Index).Operation   <= WAIT_FOR_CLOCK ;
    TransactionRec(Index).IntToModel  <= WaitCycles ; 
    StreamArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ; 
  end procedure WaitForClock ; 

  ------------------------------------------------------------
  procedure GetTransactionCount (
  -- Get the number of transactions handled by the model.  
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    variable  TransactionCount : out   integer 
  ) is
  begin
    TransactionRec(Index).Operation   <= GET_TRANSACTION_COUNT ;
    StreamArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ; 
    TransactionCount := TransactionRec(Index).IntFromModel ; 
  end procedure GetTransactionCount ; 

  ------------------------------------------------------------
  procedure GetAlertLogID (
  -- Get the AlertLogID from the verification component.
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    variable  AlertLogID       : out   AlertLogIDType 
  ) is
  begin
    TransactionRec(Index).Operation   <= GET_ALERTLOG_ID ;
    StreamArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ; 
    AlertLogID := AlertLogIDType(TransactionRec(Index).IntFromModel) ; 
  end procedure GetAlertLogID ; 
  
  ------------------------------------------------------------
  procedure GetErrorCount (
  -- Error reporting for testbenches that do not use OSVVM AlertLogPkg
  -- Returns error count.  If an error count /= 0, also print errors
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    variable  ErrorCount       : out   natural
  ) is
    variable  AlertLogID : AlertLogIDType ;
  begin
    GetAlertLogID(TransactionRec, Index, AlertLogID) ;
--    ReportNonZeroAlerts(AlertLogID => AlertLogID) ;
    ErrorCount := GetAlertCount(AlertLogID => AlertLogID) ;
  end procedure GetErrorCount ; 
  
  -- ========================================================
  --  Delay Coverage Transactions   
  --  Get Delay Coverage ID to change delay coverage parameters.
  -- ========================================================
  ------------------------------------------------------------
  procedure SetUseRandomDelays (
  ------------------------------------------------------------
    signal    TransactionRec : InOut StreamRecArrayType ;
    constant  Index          : in    integer ;
    constant  OptVal         : In    boolean := TRUE
  ) is
  begin
    TransactionRec(Index).Operation     <= SET_USE_RANDOM_DELAYS ;
    TransactionRec(Index).BoolToModel   <= OptVal ;
    StreamArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
  end procedure SetUseRandomDelays ;

  ------------------------------------------------------------
  procedure GetUseRandomDelays (
  ------------------------------------------------------------
    signal    TransactionRec : InOut StreamRecArrayType ;
    constant  Index          : in    integer ;
    variable  OptVal         : Out   boolean
  ) is
  begin
    TransactionRec(Index).Operation     <= GET_USE_RANDOM_DELAYS ;
    StreamArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
    OptVal := TransactionRec(Index).BoolFromModel    ;
  end procedure GetUseRandomDelays ;

  ------------------------------------------------------------
  procedure SetDelayCoverageID (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  DelayCov         : in    DelayCoverageIdType 
  ) is
  begin
    TransactionRec(Index).Operation     <= SET_DELAYCOV_ID ;
    TransactionRec(Index).IntToModel    <= DelayCov.ID ;
    StreamArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
  end procedure SetDelayCoverageID ;

  ------------------------------------------------------------
  procedure GetDelayCoverageID (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    variable  DelayCov         : out   DelayCoverageIdType 
  ) is
  begin
    TransactionRec(Index).Operation     <= GET_DELAYCOV_ID ;
    StreamArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
    DelayCov := GetDelayCoverage(TransactionRec(Index).IntFromModel) ; 
  end procedure GetDelayCoverageID ;

  -- ========================================================
  --  Set and Get Burst Mode   
  --  Set Burst Mode for models that do bursting.
  -- ========================================================
  ------------------------------------------------------------
  procedure SetBurstMode (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  OptVal           : in    StreamFifoBurstModeType
  ) is
  begin
    TransactionRec(Index).Operation     <= SET_BURST_MODE ;
    TransactionRec(Index).IntToModel    <= OptVal ;
    StreamArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
  end procedure SetBurstMode ;

  ------------------------------------------------------------
  procedure GetBurstMode (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    variable  OptVal           : out   StreamFifoBurstModeType
  ) is
  begin
    TransactionRec(Index).Operation     <= GET_BURST_MODE ;
    StreamArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
    OptVal := TransactionRec(Index).IntFromModel ; 
  end procedure GetBurstMode ;

  ------------------------------------------------------------
  --  GotBurst   
  -- Check to see if Read Burst is available
  ------------------------------------------------------------
  ------------------------------------------------------------
  procedure GotBurst (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  NumFifoWords     : in    integer ;
    variable  Available        : out   boolean
  ) is
  begin
    TransactionRec(Index).Operation   <= GOT_BURST ;
    -- NumFifoWords not used in all implementations - needed when interface has no burst capability
    TransactionRec(Index).IntToModel  <= NumFifoWords ; 
    StreamArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
    Available := TransactionRec(Index).BoolFromModel ; 
  end procedure GotBurst ;

  -- ========================================================
  --  Set and Get Model Options  
  --  Model operations are directive transactions that are  
  --  used to configure the verification component.  
  --  They can either be used directly or with a model specific
  --  wrapper around them - see AXI models for examples.
  -- ========================================================
  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Option           : in    integer ;
    constant  OptVal           : in    boolean
  ) is
  begin
    TransactionRec(Index).Operation     <= SET_MODEL_OPTIONS ;
    TransactionRec(Index).Options       <= Option ;
    TransactionRec(Index).BoolToModel   <= OptVal ;
    StreamArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
  end procedure SetModelOptions ;

  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Option           : in    integer ;
    constant  OptVal           : in    integer
  ) is
  begin
    TransactionRec(Index).Operation     <= SET_MODEL_OPTIONS ;
    TransactionRec(Index).Options       <= Option ;
    TransactionRec(Index).IntToModel    <= OptVal ;
    StreamArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
  end procedure SetModelOptions ;

  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Option           : in    integer ;
    constant  OptVal           : in    std_logic_vector
  ) is
  begin
    TransactionRec(Index).Operation     <= SET_MODEL_OPTIONS ;
    TransactionRec(Index).Options       <= Option ;
    TransactionRec(Index).IntToModel    <= to_integer(OptVal) ;
    StreamArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
  end procedure SetModelOptions ;
  
  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Option           : in    integer ;
    constant  OptVal           : in    time
  ) is
  begin
    TransactionRec(Index).Operation     <= SET_MODEL_OPTIONS ;
    TransactionRec(Index).Options       <= Option ;
    TransactionRec(Index).TimeToModel   <= OptVal ;
    StreamArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
  end procedure SetModelOptions ;

  ------------------------------------------------------------
  procedure SetModelOptions (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Option           : in    integer 
  ) is
  begin
    TransactionRec(Index).Operation     <= SET_MODEL_OPTIONS ;
    TransactionRec(Index).Options       <= Option ;
    -- OptVal handled by Model Specific Package
    -- TransactionRec(Index).IntToModel    <= to_integer(OptVal) ;
    StreamArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
  end procedure SetModelOptions ;

  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Option           : in    integer ;
    variable  OptVal           : out   boolean
  ) is
  begin
    TransactionRec(Index).Operation     <= GET_MODEL_OPTIONS ;
    TransactionRec(Index).Options       <= Option ;
    StreamArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
    OptVal := TransactionRec(Index).BoolFromModel    ;
  end procedure GetModelOptions ;

  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Option           : in    integer ;
    variable  OptVal           : out   integer
  ) is
  begin
    TransactionRec(Index).Operation     <= GET_MODEL_OPTIONS ;
    TransactionRec(Index).Options       <= Option ;
    StreamArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
    OptVal := TransactionRec(Index).IntFromModel ; 
  end procedure GetModelOptions ;

  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Option           : in    integer ;
    variable  OptVal           : out   std_logic_vector
  ) is
  begin
    TransactionRec(Index).Operation     <= GET_MODEL_OPTIONS ;
    TransactionRec(Index).Options       <= Option ;
    StreamArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
    OptVal := to_slv(TransactionRec(Index).IntFromModel, OptVal'length) ; 
  end procedure GetModelOptions ;
  
  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Option           : in    integer ;
    variable  OptVal           : out   time
  ) is
  begin
    TransactionRec(Index).Operation     <= GET_MODEL_OPTIONS ;
    TransactionRec(Index).Options       <= Option ;
    StreamArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
    OptVal := TransactionRec(Index).TimeFromModel ; 
  end procedure GetModelOptions ;

  ------------------------------------------------------------
  procedure GetModelOptions (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Option           : in    integer 
  ) is
  begin
    TransactionRec(Index).Operation     <= GET_MODEL_OPTIONS ;
    TransactionRec(Index).Options       <= Option ;
    StreamArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ;
    -- OptVal handled by Model Specific layer overloading
    -- OptVal := TransactionRec(Index).TimeFromModel ; 
  end procedure GetModelOptions ;


  -- ========================================================
  --  Transmitter Transactions
  -- ========================================================
  
  -- ========================================================
  -- Send
  -- Blocking Send Transaction. 
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for error injection.
  -- ========================================================
  ------------------------------------------------------------
  procedure LocalSend (
  -- Package Local - simplifies the other calls to Send
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Operation        : in    StreamOperationType ;
    constant  Data             : in    std_logic_vector ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false 
  ) is 
    variable LocalParam : std_logic_vector(TransactionRec(Index).ParamToModel'length -1 downto 0) := (others => '-') ;
  begin
    LocalParam(Param'length-1 downto 0) := Param ; 
    TransactionRec(Index).Operation     <= Operation ;
    TransactionRec(Index).DataToModel   <= SafeResize(Data, TransactionRec(Index).DataToModel'length) ; 
    TransactionRec(Index).ParamToModel  <= SafeResize(LocalParam, TransactionRec(Index).ParamToModel'length) ; 
    TransactionRec(Index).IntToModel    <= Data'length ;
    TransactionRec(Index).BoolToModel   <= StatusMsgOn ; 
    StreamArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ; 
  end procedure LocalSend ; 

  ------------------------------------------------------------
  procedure Send (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Data             : in    std_logic_vector ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false 
  ) is 
  begin
    LocalSend(TransactionRec, Index, SEND, Data, Param, StatusMsgOn) ;
  end procedure Send ; 

  ------------------------------------------------------------
  procedure Send (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Data             : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false 
  ) is 
  begin
    LocalSend(TransactionRec, Index, SEND, Data, "", StatusMsgOn);
  end procedure Send ; 

  -- ========================================================
  -- SendAsync
  -- Asynchronous / Non-Blocking Send Transaction
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for error injection. 
  -- ========================================================

  ------------------------------------------------------------
  procedure SendAsync (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Data             : in    std_logic_vector ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false 
  ) is 
  begin
    LocalSend(TransactionRec, Index, SEND_ASYNC, Data, Param, StatusMsgOn) ;
  end procedure SendAsync ; 

  ------------------------------------------------------------
  procedure SendAsync (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Data             : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false 
  ) is 
  begin
    LocalSend(TransactionRec, Index, SEND_ASYNC, Data, "", StatusMsgOn);
  end procedure SendAsync ; 


  -- ========================================================
  -- SendBurst
  -- Blocking Send Burst Transaction. 
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for error injection.
  -- ========================================================
  ------------------------------------------------------------
  procedure LocalSendBurst (
  -- Package Local - simplifies the other calls to Send
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Operation        : in    StreamOperationType ;
    constant  NumFifoWords     : in    integer ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false 
  ) is 
    variable LocalParam : std_logic_vector(TransactionRec(Index).ParamToModel'length -1 downto 0) := (others => '-') ;
  begin
    LocalParam(Param'length-1 downto 0) := Param ; 
    TransactionRec(Index).Operation     <= Operation ;
    TransactionRec(Index).IntToModel    <= NumFifoWords ; 
    TransactionRec(Index).ParamToModel  <= SafeResize(LocalParam, TransactionRec(Index).ParamToModel'length) ; 
    TransactionRec(Index).BoolToModel   <= StatusMsgOn ; 
    StreamArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ; 
  end procedure LocalSendBurst ; 

  ------------------------------------------------------------
  procedure SendBurst (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  NumFifoWords     : in    integer ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false 
  ) is 
  begin
    LocalSendBurst(TransactionRec, Index, SEND_BURST, NumFifoWords, Param, StatusMsgOn) ;
  end procedure SendBurst ; 

  ------------------------------------------------------------
  procedure SendBurst (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  NumFifoWords     : in    integer ;
    constant  StatusMsgOn      : in    boolean := false 
  ) is 
  begin
    LocalSendBurst(TransactionRec, Index, SEND_BURST, NumFifoWords, "", StatusMsgOn) ;
  end procedure SendBurst ; 

  ------------------------------------------------------------
  procedure SendBurstVector (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  VectorOfWords    : in    slv_vector ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    PushBurstVector(TransactionRec(Index).BurstFifo, VectorOfWords) ;
    LocalSendBurst(TransactionRec, Index, SEND_BURST, VectorOfWords'length, Param, StatusMsgOn) ; 
  end procedure SendBurstVector ;
  
  ------------------------------------------------------------
  procedure SendBurstVector (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  VectorOfWords    : in    slv_vector ;
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    SendBurstVector(TransactionRec, Index, VectorOfWords, "", StatusMsgOn) ; 
  end procedure SendBurstVector ;
  
  ------------------------------------------------------------
  procedure SendBurstVector (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  VectorOfWords    : in    integer_vector ;
    constant  Param            : in    std_logic_vector ;
    constant  FifoWidth        : in    integer ; 
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    PushBurstVector(TransactionRec(Index).BurstFifo, VectorOfWords, FifoWidth) ;
    LocalSendBurst(TransactionRec, Index, SEND_BURST, VectorOfWords'length, Param, StatusMsgOn) ; 
  end procedure SendBurstVector ;
  
  ------------------------------------------------------------
  procedure SendBurstVector (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  VectorOfWords    : in    integer_vector ;
    constant  FifoWidth        : in    integer ; 
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    SendBurstVector(TransactionRec, Index, VectorOfWords, "", FifoWidth, StatusMsgOn) ; 
  end procedure SendBurstVector ;
  
  ------------------------------------------------------------
  procedure SendBurstIncrement (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  FirstWord        : in    std_logic_vector ;
    constant  NumFifoWords     : in    integer ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    PushBurstIncrement(TransactionRec(Index).BurstFifo, FirstWord, NumFifoWords) ;
    LocalSendBurst(TransactionRec, Index, SEND_BURST, NumFifoWords, Param, StatusMsgOn) ; 
  end procedure SendBurstIncrement ;
  
  ------------------------------------------------------------
  procedure SendBurstIncrement (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  FirstWord        : in    std_logic_vector ;
    constant  NumFifoWords     : in    integer ;
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    SendBurstIncrement(TransactionRec, Index, FirstWord, NumFifoWords, "", StatusMsgOn) ; 
  end procedure SendBurstIncrement ;

  ------------------------------------------------------------
  procedure SendBurstRandom (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  FirstWord        : in    std_logic_vector ;
    constant  NumFifoWords     : in    integer ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    PushBurstRandom(TransactionRec(Index).BurstFifo, FirstWord, NumFifoWords) ;
    LocalSendBurst(TransactionRec, Index, SEND_BURST, NumFifoWords, Param, StatusMsgOn) ; 
  end procedure SendBurstRandom ;
  
  ------------------------------------------------------------
  procedure SendBurstRandom (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  FirstWord        : in    std_logic_vector ;
    constant  NumFifoWords     : in    integer ;
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    SendBurstRandom(TransactionRec, Index, FirstWord, NumFifoWords, "", StatusMsgOn) ; 
  end procedure SendBurstRandom ;

  ------------------------------------------------------------
  procedure SendBurstRandom (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  CoverID          : in    CoverageIDType ;
    constant  NumFifoWords     : in    integer ;
    constant  FifoWidth        : in    integer ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    PushBurstRandom(TransactionRec(Index).BurstFifo, CoverID, NumFifoWords, FifoWidth) ;
    LocalSendBurst(TransactionRec, Index, SEND_BURST, NumFifoWords, Param, StatusMsgOn) ; 
  end procedure SendBurstRandom ;  

  ------------------------------------------------------------
  procedure SendBurstRandom (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  CoverID          : in    CoverageIDType ;
    constant  NumFifoWords     : in    integer ;
    constant  FifoWidth        : in    integer ;
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    SendBurstRandom(TransactionRec, Index, CoverID, NumFifoWords, FifoWidth, "", StatusMsgOn) ; 
  end procedure SendBurstRandom ;  


  -- ========================================================
  -- SendBurstAsync
  -- Asynchronous / Non-Blocking Send Transaction
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for error injection. 
  -- ========================================================

  ------------------------------------------------------------
  procedure SendBurstAsync (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  NumFifoWords     : in    integer ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false 
  ) is 
  begin
    LocalSendBurst(TransactionRec, Index, SEND_BURST_ASYNC, NumFifoWords, Param, StatusMsgOn) ;
  end procedure SendBurstAsync ; 

  ------------------------------------------------------------
  procedure SendBurstAsync (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  NumFifoWords     : in    integer ;
    constant  StatusMsgOn      : in    boolean := false 
  ) is 
  begin
    LocalSendBurst(TransactionRec, Index, SEND_BURST_ASYNC, NumFifoWords, "", StatusMsgOn) ;
  end procedure SendBurstAsync ; 

  ------------------------------------------------------------
  procedure SendBurstVectorAsync (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  VectorOfWords    : in    slv_vector ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    PushBurstVector(TransactionRec(Index).BurstFifo, VectorOfWords) ;
    LocalSendBurst(TransactionRec, Index, SEND_BURST_ASYNC, VectorOfWords'length, Param, StatusMsgOn) ; 
  end procedure SendBurstVectorAsync ;
  
  ------------------------------------------------------------
  procedure SendBurstVectorAsync (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  VectorOfWords    : in    slv_vector ;
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    SendBurstVectorAsync(TransactionRec, Index, VectorOfWords, "", StatusMsgOn) ; 
  end procedure SendBurstVectorAsync ;
  
  ------------------------------------------------------------
  procedure SendBurstVectorAsync (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  VectorOfWords    : in    integer_vector ;
    constant  Param            : in    std_logic_vector ;
    constant  FifoWidth        : in    integer ; 
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    PushBurstVector(TransactionRec(Index).BurstFifo, VectorOfWords, FifoWidth) ;
    LocalSendBurst(TransactionRec, Index, SEND_BURST_ASYNC, VectorOfWords'length, Param, StatusMsgOn) ; 
  end procedure SendBurstVectorAsync ;
  
  ------------------------------------------------------------
  procedure SendBurstVectorAsync (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  VectorOfWords    : in    integer_vector ;
    constant  FifoWidth        : in    integer ; 
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    SendBurstVectorAsync(TransactionRec, Index, VectorOfWords, "", FifoWidth, StatusMsgOn) ; 
  end procedure SendBurstVectorAsync ;

  ------------------------------------------------------------
  procedure SendBurstIncrementAsync (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  FirstWord        : in    std_logic_vector ;
    constant  NumFifoWords     : in    integer ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    PushBurstIncrement(TransactionRec(Index).BurstFifo, FirstWord, NumFifoWords) ;
    LocalSendBurst(TransactionRec, Index, SEND_BURST_ASYNC, NumFifoWords, Param, StatusMsgOn) ; 
  end procedure SendBurstIncrementAsync ;

  ------------------------------------------------------------
  procedure SendBurstIncrementAsync (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  FirstWord        : in    std_logic_vector ;
    constant  NumFifoWords     : in    integer ;
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    SendBurstIncrementAsync(TransactionRec, Index, FirstWord, NumFifoWords, "", StatusMsgOn) ; 
  end procedure SendBurstIncrementAsync ;

  ------------------------------------------------------------
  procedure SendBurstRandomAsync (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  FirstWord        : in    std_logic_vector ;
    constant  NumFifoWords     : in    integer ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    PushBurstRandom(TransactionRec(Index).BurstFifo, FirstWord, NumFifoWords) ;
    LocalSendBurst(TransactionRec, Index, SEND_BURST_ASYNC, NumFifoWords, Param, StatusMsgOn) ; 
  end procedure SendBurstRandomAsync ;

  ------------------------------------------------------------
  procedure SendBurstRandomAsync (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  FirstWord        : in    std_logic_vector ;
    constant  NumFifoWords     : in    integer ;
    constant  StatusMsgOn      : in    boolean := false
  ) is
    variable RV : RandomPType ; 
  begin
    SendBurstRandomAsync(TransactionRec, Index, FirstWord, NumFifoWords, "", StatusMsgOn) ; 
  end procedure SendBurstRandomAsync ;

  ------------------------------------------------------------
  procedure SendBurstRandomAsync (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  CoverID          : in    CoverageIDType ;
    constant  NumFifoWords     : in    integer ;
    constant  FifoWidth        : in    integer ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    PushBurstRandom(TransactionRec(Index).BurstFifo, CoverID, NumFifoWords, FifoWidth) ;
    LocalSendBurst(TransactionRec, Index, SEND_BURST_ASYNC, NumFifoWords, Param, StatusMsgOn) ; 
  end procedure SendBurstRandomAsync ;  

  ------------------------------------------------------------
  procedure SendBurstRandomAsync (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  CoverID          : in    CoverageIDType ;
    constant  NumFifoWords     : in    integer ;
    constant  FifoWidth        : in    integer ;
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    SendBurstRandomAsync(TransactionRec, Index, CoverID, NumFifoWords, FifoWidth, "", StatusMsgOn) ; 
  end procedure SendBurstRandomAsync ;  


  -- ========================================================
  --  Receiver Transactions
  -- ========================================================

  -- ========================================================
  -- Get
  -- Blocking Get Transaction. 
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for received error status.
  -- ========================================================

  ------------------------------------------------------------
  procedure Get (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    variable  Data             : out   std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false 
  ) is 
  begin
    TransactionRec(Index).Operation   <= GET ;
    TransactionRec(Index).IntToModel  <= Data'length ;
    TransactionRec(Index).BoolToModel <= StatusMsgOn ;     
    StreamArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ; 
    Data  := SafeResize(TransactionRec(Index).DataFromModel, Data'length) ; 
  end procedure Get ; 
  
  ------------------------------------------------------------
  procedure Get (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    variable  Data             : out   std_logic_vector ;
    variable  Param            : out   std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false 
  ) is 
  begin
    Get(TransactionRec, Index, Data, StatusMsgOn) ;
    Param := SafeResize(TransactionRec(Index).ParamFromModel, Param'length) ; 
  end procedure Get ;  

  -- ========================================================
  -- TryGet
  -- Try Get Transaction
  -- If Data is available, get it and return available TRUE,
  -- otherwise Return Available FALSE.
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for received error status.
  -- ========================================================

  ------------------------------------------------------------
  procedure TryGet (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    variable  Data             : out   std_logic_vector ;
    variable  Available        : out   boolean ;
    constant  StatusMsgOn      : in    boolean := false 
  ) is 
  begin
    TransactionRec(Index).Operation   <= TRY_GET ;
    TransactionRec(Index).IntToModel  <= Data'length ;
    TransactionRec(Index).BoolToModel <= StatusMsgOn ;     
    StreamArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ; 
    Data      := SafeResize(TransactionRec(Index).DataFromModel, Data'length) ; 
    Available := TransactionRec(Index).BoolFromModel ;
  end procedure TryGet ; 
  
  ------------------------------------------------------------
  procedure TryGet (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    variable  Data             : out   std_logic_vector ;
    variable  Param            : out   std_logic_vector ;
    variable  Available        : out   boolean ;
    constant  StatusMsgOn      : in    boolean := false 
  ) is 
  begin
    TryGet(TransactionRec, Index, Data, Available, StatusMsgOn) ;
    Param := SafeResize(TransactionRec(Index).ParamFromModel, Param'length) ; 
  end procedure TryGet ;  


  -- ========================================================
  -- GetBurst
  -- Blocking Get Burst Transaction. 
  -- Param, when present, is an extra parameter from the verification component
  -- The UART verification component uses Param for received error status.
  -- ========================================================

  ------------------------------------------------------------
  procedure LocalGetBurst (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  NumFifoWords     : in    integer ;
    constant  StatusMsgOn      : in    boolean := false 
  ) is 
  begin
    TransactionRec(Index).Operation   <= GET_BURST ;
    TransactionRec(Index).IntToModel  <= NumFifoWords ;  -- For models without burst framing (like UART)
    TransactionRec(Index).BoolToModel <= StatusMsgOn ;     
    StreamArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ; 
  end procedure LocalGetBurst ; 
  
  ------------------------------------------------------------
  procedure GetBurst (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    variable  NumFifoWords     : inout integer ;
    constant  StatusMsgOn      : in    boolean := false 
  ) is 
  begin
    LocalGetBurst(TransactionRec, Index, NumFifoWords, StatusMsgOn) ; 
    NumFifoWords := TransactionRec(Index).IntFromModel ;
  end procedure GetBurst ; 
  
  ------------------------------------------------------------
  procedure GetBurst (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    variable  NumFifoWords     : inout integer ;
    variable  Param            : out   std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false 
  ) is 
  begin
    LocalGetBurst(TransactionRec, Index, NumFifoWords, StatusMsgOn) ; 
    NumFifoWords := TransactionRec(Index).IntFromModel ;
    Param := SafeResize(TransactionRec(Index).ParamFromModel, Param'length) ; 
  end procedure GetBurst ;  

  -- ========================================================
  -- TryGetBurst
  -- Try Get Burst Transaction
  -- If Data is available, get it and return available TRUE,
  -- otherwise Return Available FALSE.
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for received error status.
  -- ========================================================

  ------------------------------------------------------------
  procedure LocalTryGetBurst (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  NumFifoWords     : in    integer ;
    variable  Available        : out   boolean ;
    constant  StatusMsgOn      : in    boolean := false 
  ) is 
  begin
    TransactionRec(Index).Operation   <= TRY_GET_BURST ;
    TransactionRec(Index).IntToModel  <= NumFifoWords ;  -- For models without burst framing (like UART)
    TransactionRec(Index).BoolToModel <= StatusMsgOn ;     
    StreamArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ; 
    Available := TransactionRec(Index).BoolFromModel ;
  end procedure LocalTryGetBurst ; 

  ------------------------------------------------------------
  procedure TryGetBurst (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    variable  NumFifoWords     : inout integer ;
    variable  Available        : out   boolean ;
    constant  StatusMsgOn      : in    boolean := false 
  ) is 
  begin
    LocalTryGetBurst(TransactionRec, Index, NumFifoWords, Available, StatusMsgOn) ;
    NumFifoWords  := TransactionRec(Index).IntFromModel ;
  end procedure TryGetBurst ; 

  ------------------------------------------------------------
  procedure TryGetBurst (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    variable  NumFifoWords     : inout integer ;
    variable  Param            : out   std_logic_vector ;
    variable  Available        : out   boolean ;
    constant  StatusMsgOn      : in    boolean := false 
  ) is 
  begin
    LocalTryGetBurst(TransactionRec, Index, NumFifoWords, Available, StatusMsgOn) ;
    NumFifoWords  := TransactionRec(Index).IntFromModel ;
    Param := SafeResize(TransactionRec(Index).ParamFromModel, Param'length) ; 
  end procedure TryGetBurst ;  


  -- ========================================================
  -- Check
  -- Blocking Get Transaction. 
  -- Data is the expected value to be received.
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for received error status.
  -- ========================================================

  ------------------------------------------------------------
  procedure Check (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Data             : in    std_logic_vector ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false 
  ) is 
    variable LocalParam : std_logic_vector(TransactionRec(Index).ParamToModel'length -1 downto 0) := (others => '-') ;
  begin
    LocalParam(Param'length-1 downto 0) := Param ; 
    TransactionRec(Index).Operation     <= CHECK ;
    TransactionRec(Index).DataToModel   <= SafeResize(Data, TransactionRec(Index).DataToModel'length) ; 
    TransactionRec(Index).ParamToModel  <= SafeResize(LocalParam, TransactionRec(Index).ParamToModel'length) ; 
    TransactionRec(Index).IntToModel    <= Data'length ;
    TransactionRec(Index).BoolToModel   <= StatusMsgOn ;     
    StreamArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ; 
  end procedure Check ; 

  ------------------------------------------------------------
  procedure Check (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Data             : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false 
  ) is 
  begin
    Check(TransactionRec, Index, Data, "", StatusMsgOn) ;
  end procedure Check ; 


  -- ========================================================
  -- TryCheck
  -- Try Check Transaction
  -- If Data is available, check it and return available TRUE,
  -- otherwise Return Available FALSE.
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for received error status.
  -- ========================================================

  ------------------------------------------------------------
  procedure TryCheck (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Data             : in    std_logic_vector ;
    constant  Param            : in    std_logic_vector ;
    variable  Available        : out   boolean ;
    constant  StatusMsgOn      : in    boolean := false 
  ) is 
    variable LocalParam : std_logic_vector(TransactionRec(Index).ParamToModel'length -1 downto 0) := (others => '-') ;
  begin
    LocalParam(Param'length-1 downto 0) := Param ; 
    TransactionRec(Index).Operation     <= TRY_CHECK ;
    TransactionRec(Index).DataToModel   <= SafeResize(Data, TransactionRec(Index).DataToModel'length) ; 
    TransactionRec(Index).ParamToModel  <= SafeResize(LocalParam, TransactionRec(Index).ParamToModel'length) ; 
    TransactionRec(Index).IntToModel    <= Data'length ;
    TransactionRec(Index).BoolToModel   <= StatusMsgOn ;     
    StreamArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ; 
    Available := TransactionRec(Index).BoolFromModel ;
  end procedure TryCheck ; 

  ------------------------------------------------------------
  procedure TryCheck (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Data             : in    std_logic_vector ;
    variable  Available        : out   boolean ;
    constant  StatusMsgOn      : in    boolean := false 
  ) is 
  begin
    TryCheck(TransactionRec, Index, Data, "", Available, StatusMsgOn) ;
  end procedure TryCheck ; 


  -- ========================================================
  -- CheckBurst
  -- Blocking Check Burst Transaction. 
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for checking error injection.
  -- ========================================================
  ------------------------------------------------------------
  procedure LocalCheckBurst (
  -- Package Local - simplifies the other calls to Check
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  Operation        : in    StreamOperationType ;
    constant  NumFifoWords     : in    integer ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false 
  ) is 
    variable LocalParam : std_logic_vector(TransactionRec(Index).ParamToModel'length -1 downto 0) := (others => '-') ;
  begin
    LocalParam(Param'length-1 downto 0) := Param ; 
    TransactionRec(Index).Operation     <= Operation ;
    TransactionRec(Index).IntToModel    <= NumFifoWords ; 
    TransactionRec(Index).ParamToModel  <= SafeResize(LocalParam, TransactionRec(Index).ParamToModel'length) ; 
    TransactionRec(Index).BoolToModel   <= StatusMsgOn ; 
    StreamArrayRequestTransaction(TransactionRec => TransactionRec, Index => Index) ; 
  end procedure LocalCheckBurst ; 

  ------------------------------------------------------------
  procedure CheckBurst (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  NumFifoWords     : in    integer ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false 
  ) is 
  begin
    LocalCheckBurst(TransactionRec, Index, CHECK_BURST, NumFifoWords, Param, StatusMsgOn) ;
  end procedure CheckBurst ; 
  
  ------------------------------------------------------------
  procedure CheckBurst (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  NumFifoWords     : in    integer ;
    constant  StatusMsgOn      : in    boolean := false 
  ) is 
  begin
    LocalCheckBurst(TransactionRec, Index, CHECK_BURST, NumFifoWords, "", StatusMsgOn) ;
  end procedure CheckBurst ; 

  ------------------------------------------------------------
  procedure CheckBurstVector (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  VectorOfWords    : in    slv_vector ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    PushBurstVector(TransactionRec(Index).BurstFifo, VectorOfWords) ;
    LocalCheckBurst(TransactionRec, Index, CHECK_BURST, VectorOfWords'length, Param, StatusMsgOn) ;
  end procedure CheckBurstVector ;
  
  ------------------------------------------------------------
  procedure CheckBurstVector (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  VectorOfWords    : in    slv_vector ;
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    CheckBurstVector(TransactionRec, Index, VectorOfWords, "", StatusMsgOn) ; 
  end procedure CheckBurstVector ;
  
  ------------------------------------------------------------
  procedure CheckBurstVector (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  VectorOfWords    : in    integer_vector ;
    constant  Param            : in    std_logic_vector ;
    constant  FifoWidth        : in    integer ; 
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    PushBurstVector(TransactionRec(Index).BurstFifo, VectorOfWords, FifoWidth) ;
    LocalCheckBurst(TransactionRec, Index, CHECK_BURST, VectorOfWords'length, Param, StatusMsgOn) ;
  end procedure CheckBurstVector ;
  
  ------------------------------------------------------------
  procedure CheckBurstVector (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  VectorOfWords    : in    integer_vector ;
    constant  FifoWidth        : in    integer ; 
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    CheckBurstVector(TransactionRec, Index, VectorOfWords, "", FifoWidth, StatusMsgOn) ; 
  end procedure CheckBurstVector ;
  
  ------------------------------------------------------------
  procedure CheckBurstIncrement (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  FirstWord        : in    std_logic_vector ;
    constant  NumFifoWords     : in    integer ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    PushBurstIncrement(TransactionRec(Index).BurstFifo, FirstWord, NumFifoWords) ;
    LocalCheckBurst(TransactionRec, Index, CHECK_BURST, NumFifoWords, Param, StatusMsgOn) ;
  end procedure CheckBurstIncrement ;

  ------------------------------------------------------------
  procedure CheckBurstIncrement (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  FirstWord        : in    std_logic_vector ;
    constant  NumFifoWords     : in    integer ;
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    CheckBurstIncrement(TransactionRec, Index, FirstWord, NumFifoWords, "", StatusMsgOn) ; 
  end procedure CheckBurstIncrement ;

  ------------------------------------------------------------
  procedure CheckBurstRandom (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  FirstWord        : in    std_logic_vector ;
    constant  NumFifoWords     : in    integer ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    PushBurstRandom(TransactionRec(Index).BurstFifo, FirstWord, NumFifoWords) ;
    LocalCheckBurst(TransactionRec, Index, CHECK_BURST, NumFifoWords, Param, StatusMsgOn) ;
  end procedure CheckBurstRandom ;
  
  ------------------------------------------------------------
  procedure CheckBurstRandom (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  FirstWord        : in    std_logic_vector ;
    constant  NumFifoWords     : in    integer ;
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    CheckBurstRandom(TransactionRec, Index, FirstWord, NumFifoWords, "", StatusMsgOn) ; 
  end procedure CheckBurstRandom ;

  ------------------------------------------------------------
  procedure CheckBurstRandom (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  CoverID          : in    CoverageIDType ;
    constant  NumFifoWords     : in    integer ;
    constant  FifoWidth        : in    integer ;
    constant  Param            : in    std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    PushBurstRandom(TransactionRec(Index).BurstFifo, CoverID, NumFifoWords, FifoWidth) ;
    LocalCheckBurst(TransactionRec, Index, CHECK_BURST, NumFifoWords, Param, StatusMsgOn) ;
  end procedure CheckBurstRandom ;  

  ------------------------------------------------------------
  procedure CheckBurstRandom (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  CoverID          : in    CoverageIDType ;
    constant  NumFifoWords     : in    integer ;
    constant  FifoWidth        : in    integer ;
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    CheckBurstRandom(TransactionRec, Index, CoverID, NumFifoWords, FifoWidth, "", StatusMsgOn) ;
  end procedure CheckBurstRandom ;  

  -- ========================================================
  -- TryCheckBurst
  -- Try / Non-Blocking Check Burst Transaction
  -- Param, when present, is an extra parameter used by the verification component
  -- The UART verification component uses Param for error injection. 
  -- ========================================================
  ------------------------------------------------------------
  procedure TryCheckBurst (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  NumFifoWords     : in    integer ;
    constant  Param            : in    std_logic_vector ;
    variable  Available        : out   boolean ;
    constant  StatusMsgOn      : in    boolean := false 
  ) is 
  begin
    LocalCheckBurst(TransactionRec, Index, TRY_CHECK_BURST, NumFifoWords, Param, StatusMsgOn) ;
    Available := TransactionRec(Index).BoolFromModel ;
  end procedure TryCheckBurst ; 

  ------------------------------------------------------------
  procedure TryCheckBurst (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  NumFifoWords     : in    integer ;
    variable  Available        : out   boolean ;
    constant  StatusMsgOn      : in    boolean := false 
  ) is 
  begin
    LocalCheckBurst(TransactionRec, Index, TRY_CHECK_BURST, NumFifoWords, "", StatusMsgOn) ;
    Available := TransactionRec(Index).BoolFromModel ;
  end procedure TryCheckBurst ; 

  ------------------------------------------------------------
  procedure TryCheckBurstVector (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  VectorOfWords    : in    slv_vector ;
    constant  Param            : in    std_logic_vector ;
    variable  Available        : out   boolean ;
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    GotBurst(TransactionRec, Index, VectorOfWords'length, Available) ; 
    if Available then 
      PushBurstVector(TransactionRec(Index).BurstFifo, VectorOfWords) ;
      LocalCheckBurst(TransactionRec, Index, CHECK_BURST, VectorOfWords'length, Param, StatusMsgOn) ;
    end if ; 
  end procedure TryCheckBurstVector ;
    
  ------------------------------------------------------------
  procedure TryCheckBurstVector (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  VectorOfWords    : in    slv_vector ;
    variable  Available        : out   boolean ;
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    TryCheckBurstVector(TransactionRec, Index, VectorOfWords, "", Available, StatusMsgOn) ;
  end procedure TryCheckBurstVector ;
  
  ------------------------------------------------------------
  procedure TryCheckBurstVector (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  VectorOfWords    : in    integer_vector ;
    constant  Param            : in    std_logic_vector ;
    variable  Available        : out   boolean ;
    constant  FifoWidth        : in    integer ; 
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    GotBurst(TransactionRec, Index, VectorOfWords'length, Available) ; 
    if Available then 
      PushBurstVector(TransactionRec(Index).BurstFifo, VectorOfWords, FifoWidth) ;
      LocalCheckBurst(TransactionRec, Index, CHECK_BURST, VectorOfWords'length, Param, StatusMsgOn) ;
    end if ; 
  end procedure TryCheckBurstVector ;
    
  ------------------------------------------------------------
  procedure TryCheckBurstVector (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  VectorOfWords    : in    integer_vector ;
    variable  Available        : out   boolean ;
    constant  FifoWidth        : in    integer ; 
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    TryCheckBurstVector(TransactionRec, Index, VectorOfWords, "", Available, FifoWidth, StatusMsgOn) ;
  end procedure TryCheckBurstVector ;

  ------------------------------------------------------------
  procedure TryCheckBurstIncrement (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  FirstWord        : in    std_logic_vector ;
    constant  NumFifoWords     : in    integer ;
    constant  Param            : in    std_logic_vector ;
    variable  Available        : out   boolean ;
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    GotBurst(TransactionRec, Index, NumFifoWords, Available) ; 
    if Available then
      PushBurstIncrement(TransactionRec(Index).BurstFifo, FirstWord, NumFifoWords) ;
      LocalCheckBurst(TransactionRec, Index, CHECK_BURST, NumFifoWords, Param, StatusMsgOn) ;
    end if ; 
  end procedure TryCheckBurstIncrement ;

  ------------------------------------------------------------
  procedure TryCheckBurstIncrement (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  FirstWord        : in    std_logic_vector ;
    constant  NumFifoWords     : in    integer ;
    variable  Available        : out   boolean ;
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    TryCheckBurstIncrement(TransactionRec, Index, FirstWord, NumFifoWords, "", Available, StatusMsgOn) ; 
  end procedure TryCheckBurstIncrement ;

  ------------------------------------------------------------
  procedure TryCheckBurstRandom (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  FirstWord        : in    std_logic_vector ;
    constant  NumFifoWords     : in    integer ;
    constant  Param            : in    std_logic_vector ;
    variable  Available        : out   boolean ;
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    GotBurst(TransactionRec, Index, NumFifoWords, Available) ; 
    if Available then
      PushBurstRandom(TransactionRec(Index).BurstFifo, FirstWord, NumFifoWords) ;
      LocalCheckBurst(TransactionRec, Index, CHECK_BURST, NumFifoWords, Param, StatusMsgOn) ;
    end if ; 
  end procedure TryCheckBurstRandom ;

  ------------------------------------------------------------
  procedure TryCheckBurstRandom (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  FirstWord        : in    std_logic_vector ;
    constant  NumFifoWords     : in    integer ;
    variable  Available        : out   boolean ;
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    TryCheckBurstRandom(TransactionRec, Index, FirstWord, NumFifoWords, "", Available, StatusMsgOn) ; 
  end procedure TryCheckBurstRandom ;

  ------------------------------------------------------------
  procedure TryCheckBurstRandom (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  CoverID          : in    CoverageIDType ;
    constant  NumFifoWords     : in    integer ;
    constant  FifoWidth        : in    integer ;
    constant  Param            : in    std_logic_vector ;
    variable  Available        : out   boolean ;
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    GotBurst(TransactionRec, Index, NumFifoWords, Available) ; 
    if Available then
      PushBurstRandom(TransactionRec(Index).BurstFifo, CoverID, NumFifoWords, FifoWidth) ;
      LocalCheckBurst(TransactionRec, Index, CHECK_BURST, NumFifoWords, Param, StatusMsgOn) ;
    end if ; 
  end procedure TryCheckBurstRandom ;  

  ------------------------------------------------------------
  procedure TryCheckBurstRandom (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  CoverID          : in    CoverageIDType ;
    constant  NumFifoWords     : in    integer ;
    constant  FifoWidth        : in    integer ;
    variable  Available        : out   boolean ;
    constant  StatusMsgOn      : in    boolean := false
  ) is
  begin
    TryCheckBurstRandom(TransactionRec, Index, CoverID, NumFifoWords, FifoWidth, "", Available, StatusMsgOn) ;
  end procedure TryCheckBurstRandom ;  

  -- ========================================================
  --  Send And Get Transactions
  -- 
  -- ========================================================
  ------------------------------------------------------------
  procedure SendAndGet (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  iData            : in    std_logic_vector ;
    constant  iParam           : in    std_logic_vector ;
    variable  oData            : out   std_logic_vector ;
    variable  oParam           : out   std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false 
  ) is 
  begin
    LocalSend(TransactionRec, Index, SEND_AND_GET, iData, iParam, StatusMsgOn) ;
    oData  := SafeResize(TransactionRec(Index).DataFromModel,  oData'length) ; 
    oParam := SafeResize(TransactionRec(Index).ParamFromModel, oParam'length) ; 
  end procedure SendAndGet ;  

  ------------------------------------------------------------
  procedure SendAndGet (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  iData            : in    std_logic_vector ;
    variable  oData            : out   std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false 
  ) is 
  begin
    LocalSend(TransactionRec, Index, SEND_AND_GET, iData, "", StatusMsgOn) ;
    oData  := SafeResize(TransactionRec(Index).DataFromModel, oData'length) ; 
  end procedure SendAndGet ;  

  ------------------------------------------------------------
  procedure SendAndGetBurst (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  iNumFifoWords    : in    integer ;
    constant  iParam           : in    std_logic_vector ;
    variable  oNumFifoWords    : out   integer ;
    variable  oParam           : out   std_logic_vector ;
    constant  StatusMsgOn      : in    boolean := false 
  ) is 
  begin
    LocalSendBurst(TransactionRec, Index, SEND_AND_GET_BURST, iNumFifoWords, iParam, StatusMsgOn) ;
    oNumFifoWords := TransactionRec(Index).IntFromModel ;
    oParam        := SafeResize(TransactionRec(Index).ParamFromModel, oParam'length) ; 
  end procedure SendAndGetBurst ; 

  ------------------------------------------------------------
  procedure SendAndGetBurst (
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer ;
    constant  iNumFifoWords    : in    integer ;
    variable  oNumFifoWords    : out   integer ;
    constant  StatusMsgOn      : in    boolean := false 
  ) is 
  begin
    LocalSendBurst(TransactionRec, Index, SEND_AND_GET_BURST, iNumFifoWords, "", StatusMsgOn) ;
    oNumFifoWords := TransactionRec(Index).IntFromModel ;
  end procedure SendAndGetBurst ; 

  -- ========================================================
  --  Pseudo Transactions
  --  Interact with the record only.
  -- ========================================================
  ------------------------------------------------------------
  procedure ReleaseTransactionRecord (
  --  Must run on same delta cycle as AcquireTransactionRecord
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer 
  ) is
  begin
    -- Set everything driven by TestCtrl to type'left (except Rdy)
    TransactionRec(Index).Rdy           <= RdyType'left ;   
    TransactionRec(Index).Operation     <= NOT_DRIVEN ;
    TransactionRec(Index).DataToModel   <= (TransactionRec(Index).DataToModel'range => 'U') ;
    TransactionRec(Index).ParamToModel  <= (TransactionRec(Index).ParamToModel'range => 'U') ;
    TransactionRec(Index).IntToModel    <= integer'left ; 
    TransactionRec(Index).BoolToModel   <= boolean'left ; 
    TransactionRec(Index).TimeToModel   <= time'left ; 
    TransactionRec(Index).Options       <= integer'left ;    
  end procedure ReleaseTransactionRecord ; 
  
  ------------------------------------------------------------
  procedure AcquireTransactionRecord (
  --  Must run on same delta cycle as ReleaseTransactionRecord
  ------------------------------------------------------------
    signal    TransactionRec   : inout StreamRecArrayType ;
    constant  Index            : in    integer 
  ) is
  begin
    -- Start Driving Rdy on next delta cycle with the current value.  
    TransactionRec(Index).Rdy           <= TransactionRec(Index).Rdy ; 
  end procedure AcquireTransactionRecord ; 

end package body StreamTransactionArrayPkg ;