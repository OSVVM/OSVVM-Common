# OSVVM Common Library
The OSVVM Common Library 
defines OSVVM's Model Independent Transactions (MIT).
MIT defines a common communication interface (record based)
and transaction API for Address Bus and Streaming Interface.
Using MIT makes verification component development as easy
as any "Lite" approach to verification.
Going further using a common transaction API simplifies
the test development process.

## Common Library Project Structure
   * Common
      * src
      * testbench
         
## Release History
For the release history see, [CHANGELOG.md](CHANGELOG.md)

## Learning OSVVM
You can find an overview of OSVVM at [osvvm.github.io](https://osvvm.github.io).
Alternately you can find our pdf documentation at 
[OSVVM Documentation Repository](https://github.com/OSVVM/Documentation#readme).

You can also learn OSVVM by taking the class, [Advanced VHDL Verification and Testbenches - OSVVM&trade; BootCamp](https://synthworks.com/vhdl_testbench_verification.htm)

## Download OSVVM Libraries
OSVVM is available as either a git repository 
[OsvvmLibraries](https://github.com/osvvm/OsvvmLibraries) 
or zip file from [osvvm.org Downloads Page](https://osvvm.org/downloads).

On GitHub, all OSVVM libraries are a submodule of the repository OsvvmLibraries. Download all OSVVM libraries using git clone with the “–recursive” flag: 
```    
  $ git clone --recursive https://github.com/osvvm/OsvvmLibraries
```
        
## Run The Demos
A great way to get oriented with OSVVM is to run the demos.
For directions on running the demos, see [OSVVM Scripts](https://github.com/osvvm/OSVVM-Scripts#readme).

## Participating and Project Organization 
The OSVVM project welcomes your participation with either 
issue reports or pull requests.

You can find the project [Authors here](AUTHORS.md) and
[Contributors here](CONTRIBUTORS.md).

### common/src
   * StreamTransactionPkg.vhd
      * Stream Interface Model Independent Transaction Definitions
   * AddressBusTransactionPkg.vhd
      * Address Bus Interface Model Independent Transaction Definitions
   * AddressBusResponderTransactionPkg.vhd
      * Address Bus Responder Interface Model Independent Transaction Definitions
   * AddressBusVersionCompatibilityPkg.vhd
      * Aliases to keep this version compatible with last version
   * ModelParametersPkg.vhd
      * Support for setting parameters in a verification component
   * FifoFillPkg_slv.vhd
      * Implements fill patterns for verification component burst buffers.
   * OsvvmCommonContext.vhd
      * Context declaration to include all above packages
      
For current compile order see Common/common.pro.

### common/testbench
   * TbModelParameters.vhd
      * Verify ModelParametersPkg.vhd
     
For current compile order see Common/testbench/testbench.pro.

## More Information on OSVVM

**OSVVM Forums and Blog:**     [http://www.osvvm.org/](http://www.osvvm.org/)   
**Gitter:** [https://gitter.im/OSVVM/Lobby](https://gitter.im/OSVVM/Lobby)  
**Documentation:** [osvvm.github.io](https://osvvm.github.io)    
**Documentation:** [PDF Documentation](https://github.com/OSVVM/Documentation)  

## Copyright and License
Copyright (C) 2006-2022 by [SynthWorks Design Inc.](http://www.synthworks.com/)  
Copyright (C) 2022 by [OSVVM Authors](AUTHORS.md)   

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
