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
--    Works around issues with signal parameters required to be a static signal name
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
    variable  TransactionCount  : out   integer 
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