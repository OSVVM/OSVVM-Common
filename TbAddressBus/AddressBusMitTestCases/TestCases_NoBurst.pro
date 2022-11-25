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
#     1/2019   2019.01    Compile Script for OSVVM
#     1/2020   2020.01    Updated Licenses to Apache
#
#
#  This file is part of OSVVM.
#  
#  Copyright (c) 2019 - 2020 by SynthWorks Design Inc.  
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
## runs in conjunction with either 
## Testbench/Testbench.pro or TestbenchVTI/TestbenchVTI.pro
## Continuing with library set previously by the above
##


##
##  Manager TestCases
##

##  Common Directives
RunTest  TbAxi4_TransactionApiManager.vhd
RunTest  TbAxi4_AlertLogIDManager.vhd
RunTest  TbAxi4_ReleaseAcquireManager1.vhd
RunTest  TbAxi4_MultipleDriversManager.vhd

##  Basic Tests
RunTest  TbAxi4_BasicReadWrite.vhd
RunTest  TbAxi4_MemoryReadWrite1.vhd        ; # Also Memory 
RunTest  TbAxi4_MemoryReadWrite2.vhd        ; # Also Memory
RunTest  TbAxi4_ReadPoll1.vhd

RunTest  TbAxi4_RandomReadWrite.vhd
RunTest  TbAxi4_RandomReadWriteByte1.vhd


##  Basic Tests - Async
RunTest  TbAxi4_ReadWriteAsync1.vhd
RunTest  TbAxi4_ReadWriteAsync2.vhd
RunTest  TbAxi4_ReadWriteAsync3.vhd
RunTest  TbAxi4_ReadWriteAsync4.vhd

##
##  Subordinate TestCases
##

##  Common Directives
RunTest  TbAxi4_TransactionApiSubordinate.vhd
RunTest  TbAxi4_AlertLogIDSubordinate.vhd
RunTest  TbAxi4_ReleaseAcquireSubordinate1.vhd
RunTest  TbAxi4_MultipleDriversSubordinate.vhd

##  Basic Tests
RunTest  TbAxi4_SubordinateReadWrite1.vhd
RunTest  TbAxi4_SubordinateReadWrite2.vhd
RunTest  TbAxi4_SubordinateReadWrite3.vhd

##  Basic Tests - Async
RunTest  TbAxi4_SubordinateReadWriteAsync1.vhd
RunTest  TbAxi4_SubordinateReadWriteAsync2.vhd


##
## Memory
##

##  Common Directives
RunTest  TbAxi4_TransactionApiMemory.vhd
RunTest  TbAxi4_AlertLogIDMemory.vhd
RunTest  TbAxi4_ReleaseAcquireMemory1.vhd
RunTest  TbAxi4_MultipleDriversMemory.vhd

##  Basic Tests
# RunTest  TbAxi4_MemoryReadWrite1.vhd        ; # Also Manager 
# RunTest  TbAxi4_MemoryReadWrite2.vhd        ; # Also Manager


##
## MIT Examples
##
RunTest  TbAxi4_MemoryAsync.vhd
