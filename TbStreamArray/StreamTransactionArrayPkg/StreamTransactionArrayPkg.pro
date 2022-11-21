#  File Name:         TestCases.pro
#  Revision:          STANDARD VERSION
#
#  Maintainer:        Jim Lewis      email:  jim@synthworks.com
#  Contributor(s):
#     Jim Lewis      jim@synthworks.com
#
#
#  Description:
#        Minimal set of tests to verify StreamTransactionPkg
#
#  Developed for:
#        SynthWorks Design Inc.
#        VHDL Training Classes
#        11898 SW 128th Ave.  Tigard, Or  97223
#        http://www.SynthWorks.com
#
#  Revision History:
#    Date      Version    Description
#    11/2022   2022.11    Refactored from AxiStream Tests
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
## Basic Tests
RunTest  TbStream_SendGet1.vhd
RunTest  TbStream_SendGetAsync1.vhd

## =============================================
## Burst Tests 
RunTest  TbStream_SendGetAll1.vhd
RunTest  TbStream_SendGetAllAsync1.vhd
RunTest  TbAxi_SendGetAllParam1.vhd
RunTest  TbAxi_SendGetAllParamAsync1.vhd

RunTest  TbStream_GotBurst1.vhd


## =============================================
## MIT Record Checks Burst Transfer Tests - only test once for all 
RunTest  TbStream_ReleaseAcquireTransmitter1.vhd
RunTest  TbStream_ReleaseAcquireReceiver1.vhd

RunTest  TbStream_MultipleDriversTransmitter1.vhd
RunTest  TbStream_MultipleDriversReceiver1.vhd

RunTest  TbAxi_SetBurstMode1.vhd
RunTest  TbAxi_SetModelOptions1.vhd

