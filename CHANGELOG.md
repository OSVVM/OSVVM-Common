# OSVVM Common Library Change Log

| Revision  |  Release Summary | 
------------|----------- 
| 2024.11   |  WriteBurstVector, WriteBurstVectorAsync, and CheckBurstVector for Integer_vector
| 2024.09   |  Shorter calls for ClassifyUnimplementedOperation(TransRec)
| 2024.07   |  Updated testbench calls to CreateClock for it being refactored to ClockResetPkg
| 2024.03   |  Added Time to transaction record and SetModelOptions.  New overloading of PopBurstVector.
| 2023.09   |  Made ModelParametersPkg a singleton.  Formalized testbench.  Older implementation in ModelParamstersPtPkg
|           |  Updated Transaction Interface API
| 2023.05   |  Updated API for Randomizing delays in VC   
| 2022.11   |  Relocated tests cases for XxxTransactionPkg and InterruptHandler to here   
| 2022.10   |  Updated InterruptHandler for BurstFIFO updates.   
|           |  Updated PushBurstRandom / CheckBurstRandom to work around Questa bugs
| 2022.01   |  Added Burst Patterns to Address Bus and Stream
| 2021.06   |  Updated FifoFillPkg_slv.vhd ...
| 2020.12   |  Consistency updates to AddressBus and Stream MIT
| 2020.10   |  Added Bursting to Stream Model Independent Transactions 
| 2020.07   |  Updated for MIT and freed the slaves
| 2020.02   |  Created by refactoring Axi4LiteMasterTransactionPkg

## 2024.11 November 2024
- AddressBusTransactionPkg - WriteBurstVector, WriteBurstVectorAsync, and CheckBurstVector for Integer_vector

## 2024.09 September 2024
- AddressBusTransactionPkg - Added shorter call to ClassifyUnimplementedOperation
- StreamTransactionPkg - Added shorter call to ClassifyUnimplementedTransmitterOperation, ClassifyUnimplementedReceiverOperation
- Updated AddressBusTransactionArrayPkg - added missing features from AddressBusTransactionPkg

## 2024.07  July 2024
-  Updated testbench calls to CreateClock for it being refactored to ClockResetPkg
- Removed InterruptGeneratorRecArrayType.  It is unused.  It is partially constrained an causes issues in some simulators.  

## 2024.03  March 2024
- In AddressBusTransactionPkg, added SetModelOptions for a parameter of type time.
- In FifoFillPkg_Slv, added PopBurstVector that returns a count value for the size of its slv_vector or integer_vector parameters


## 2023.09  September 2023
- Added ModelParametersPkg as a singleton
   - PT implementation now in ModelParamstersPtPkg
   - Updated OsvvmCommonContext
- In StreamTransactionPkg, 
   - Added ModelParametersIdType to Transaction Interface
   - Added SendAndGet and SendAndGetBurst,
   - Added OperationType ENUMs:  EXTEND_DIRECTIVE_OP, EXTEND_OP, EXTEND_TX_OP, EXTEND_RX_OP
   - Added ClassifyUnimplementedOperation, ClassifyUnimplementedTransmitterOperation, ClassifyUnimplementedReceiverOperation
- In AddressBusTransactionPkg, 
   - Added ModelParametersIdType to Transaction Interface
   - Added OperationType ENUMs: EXTEND_DIRECTIVE_OP, EXTEND_OP, EXTEND_WRITE_OP, EXTEND_READ_OP
   - Added ClassifyUnimplementedOperation

## 2023.05  May 2023
- In XxxTransactionPkg, 
   - Added transactions to SetUseRandomDelays, SetDelayCoverageID, GetDelayCoverageID
   - Added overloading for SendBurstVector[Async] and [Try]CheckBurstVector to use integer_vector
- In FifoFillPkg_slv:  Added CheckBurstFifo

## 2022.11  November 2022
- Added array types AddressBusRecArrayType and StreamRecArrayType
- Created Array packages AddressBusTransactionArrayPkg and StreamTransactionArrayPkg
  These packages support iterating across AddressBusRecArrayType and StreamRecArrayType 
- Refactored test cases for AddressBusTransactionPkg and StreamTransactionPkg from AXI 
  to support a set of MitTestCases
- Created test cases for Array based packages
- Relocated Interrupt Handler TestCases to TbInterrupt

## 2022.01  January 2022
- Updated AddressBusTransactionPkg and StreamTransactionPkg for Burst Patterns
- Added GotBurst for Stream MIT
- Revised FifoFillPkg_slv.vhd to support burst patterns

## 2021.06  June 2021
- Updated AddressBusTransactionPkg and StreamTransactionPkg for new Burst FIFO/scoreboard data structures
- Revised FifoFillPkg_slv.vhd to support new burst FIFO/Scoreboard data structures
- Added FifoFillPtPkg_slv.vhd as a variant of FifoFillPkg_slv to maintain backward compatibility with older shared variable FIFO/Scoreboard data structures.

## 2020.12 December 2020
- Added Word/Byte Based Bursting controls. 
- Consistency updates to AddressBus and Stream MIT

## 2020.10 October 2020
- Added Byte and Word based bursting to Stream.
- Supports Burst modes: Byte, Word, Word + Parameter

## 2020.07 July 2020
Major release.
Package names have changed.
Transaction naming updated to remove
names master and slave.
All OSVVM models now use the 
Model Independent Transactions.

## 2020.02   February 2020    
Created by refactoring Axi4LiteMasterTransactionPkg.    
 
## Copyright and License
Copyright (C) 2006-2020 by [SynthWorks Design Inc.](http://www.synthworks.com/)   
Copyright (C) 2020 by [OSVVM contributors](CONTRIBUTOR.md)   

This file is part of OSVVM.

    Licensed under Apache License, Version 2.0 (the "License")
    You may not use this file except in compliance with the License.
    You may obtain a copy of the License at

  [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
