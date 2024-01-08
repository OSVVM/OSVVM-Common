#  File Name:         RunAllTests.pro
#  Revision:          STANDARD VERSION
#
#  Maintainer:        Jim Lewis      email:  jim@synthworks.com
#  Contributor(s):
#     Jim Lewis      jim@synthworks.com
#
#
#  Description:
#        Script to run all Common tests  
#
#  Developed for:
#        SynthWorks Design Inc.
#        VHDL Training Classes
#        11898 SW 128th Ave.  Tigard, Or  97223
#        http://www.SynthWorks.com
#
#  Revision History:
#    Date      Version    Description
#     1/2022   2022.11    Initial - testbenches refactored from VC tests and moved here
#
#
#  This file is part of OSVVM.
#  
#  Copyright (c) 2022 by SynthWorks Design Inc.  
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

if {$::osvvm::ToolNameVersion ne "XSIM-2023.2"}  {
# These test cases use component instantiation and will not run under 2023.2 of Xilinx

## =============================================
## Test StreamTransactionPkg and StreamTransactionArrayPkg
include ./TbStream
include ./TbStreamArray

## =============================================
## Test AddressBusTransactionPkg and AddressBusTransactionArrayPkg
include ./TbAddressBus
include ./TbAddressBusArray

## =============================================
## Test InterruptHandler 
include ./TbInterrupt   
}

## =============================================
## Test Params Pkg   
include ./TbParams     
include ./TbParamsPt     


