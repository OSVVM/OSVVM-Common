# OSVVM Common Library Change Log

| Revision  | Revision Date |  Release Summary | 
------------|---------------|----------- 
| 2022.01   | January 2022  |  Added Burst Patterns to Address Bus and Stream
| 2021.06   | June 2021     |  Updated FifoFillPkg_slv.vhd ...
| 2020.12   | December 2020 |  Consistency updates to AddressBus and Stream MIT
| 2020.10   | October 2020  |  Added Bursting to Stream Model Independent Transactions 
| 2020.07   | July 2020     |  Updated for MIT and freed the slaves
| 2020.02   | February 2020 |  Created by refactoring Axi4LiteMasterTransactionPkg


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
