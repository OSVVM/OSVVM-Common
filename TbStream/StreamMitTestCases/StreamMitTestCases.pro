#  File Name:         testbench.pro
#  Revision:          STANDARD VERSION
#
#  Maintainer:        Jim Lewis      email:  jim@synthworks.com
#  Contributor(s):
#     Jim Lewis      jim@synthworks.com
#
#
#  Description:
#        Script to run one Axi Stream test  
#
#  Developed for:
#        SynthWorks Design Inc.
#        VHDL Training Classes
#        11898 SW 128th Ave.  Tigard, Or  97223
#        http://www.SynthWorks.com
#
#  Revision History:
#    Date      Version    Description
#    11/2022   2022.11    Separated Stream MIT from VC specific tests
#     1/2022   2022.01    Added Tests
#     9/2021   2021.09    RunTest replacing analyze + simulate
#     5/2021   2021.05    Start of Refactoring TestCases
#     1/2020   2020.01    Updated Licenses to Apache
#     1/2019   2019.01    Compile Script for OSVVM
#
#
#  This file is part of OSVVM.
#  
#  Copyright (c) 2019 - 2022 by SynthWorks Design Inc.  
#  
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#  
#      https://www.apache.org/licenses/LICENSE-2.0
#  
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#  

##
## Runs in conjunction with either 
## Testbench/Testbench.pro or TestbenchVTI/TestbenchVTI.pro
## Continuing with library set previously by the above
##

## =============================================
## Run Demo
RunTest  TbStream_SendGetDemo1.vhd           ; # Demo of Send, Get, and Check of words and bursts

## =============================================
## MIT Checks that apply to all streaming models
## MIT Blocking, Single Transfers
RunTest  TbStream_SendGet1.vhd
RunTest  TbStream_ByteHandling1.vhd

## MIT Asynchronous, Single Transfers
RunTest  TbStream_SendGetAsync1.vhd
RunTest  TbStream_ByteHandlingAsync1.vhd

## MIT Blocking Burst Transfers
RunTest  TbStream_SendGetBurst1.vhd
RunTest  TbStream_SendGetBurstByte1.vhd
RunTest  TbStream_ByteHandlingBurst1.vhd
RunTest  TbStream_ByteHandlingBurstByte1.vhd

## MIT Blocking Burst that use BurstFifo also as scoreboard
RunTest  TbStream_SendCheckBurst1.vhd
RunTest  TbStream_SendCheckBurstByte1.vhd

RunTest  TbStream_SendCheckBurstPattern1.vhd
RunTest  TbStream_SendCheckBurstPattern2.vhd
RunTest  TbStream_SendCheckBurstBytePattern1.vhd
RunTest  TbStream_SendCheckBurstAsyncPattern1.vhd
RunTest  TbStream_SendCheckBurstAsyncPattern2.vhd
RunTest  TbStream_SendCheckBurstByteAsyncPattern1.vhd

## MIT Asynchronous Burst Transfers
RunTest  TbStream_SendGetBurstAsync1.vhd
RunTest  TbStream_SendGetBurstByteAsync1.vhd
RunTest  TbStream_ByteHandlingBurstAsync1.vhd
RunTest  TbStream_ByteHandlingBurstByteAsync1.vhd

## MIT Asynchronous Burst that use BurstFifo also as scoreboard
RunTest  TbStream_SendCheckBurstAsync1.vhd
RunTest  TbStream_SendCheckBurstByteAsync1.vhd

## =============================================
## MIT Record Checks 
RunTest  TbStream_MultipleDriversTransmitter1.vhd   ;# Multiple Driver tests
RunTest  TbStream_MultipleDriversReceiver1.vhd
RunTest  TbStream_ReleaseAcquireTransmitter1.vhd    ;# Release Acquire tests - only for StreamTransactionPkg tests?
RunTest  TbStream_ReleaseAcquireReceiver1.vhd
