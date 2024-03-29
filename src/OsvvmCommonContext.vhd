--
--  File Name:         OsvvmCommonContext.vhd
--  Design Unit Name:  OsvvmCommonContext
--  Revision:          OSVVM MODELS STANDARD VERSION
--
--  Maintainer:        Jim Lewis      email:  jim@synthworks.com
--
--  Description
--      Context Declaration for OSVVM packages
--
--  Developed by/for:
--        SynthWorks Design Inc.
--        VHDL Training Classes
--        11898 SW 128th Ave.  Tigard, Or  97223
--        http://www.SynthWorks.com
--
--  Revision History:      
--    Date      Version    Description
--    11/2022   2022.11    Added AddressBusTransactionArrayPkg and AddressBusResponderTransactionArrayPkg
--    01/2020   2020.01    Updated license notice
--    06/2019   2019.06    Initial Revision
--
--
--  This file is part of OSVVM.
--  
--  Copyright (c) 2019 - 2020 by SynthWorks Design Inc.  
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


context OsvvmCommonContext is
    library osvvm_common ;  
    use OSVVM_Common.ModelParametersPkg.all ; 
    use OSVVM_Common.ModelParametersSingletonPkg.all ; 
    use OSVVM_Common.FifoFillPkg_slv.all ;  
    
    -- MIT
    use osvvm_common.StreamTransactionPkg.all ; 
    use osvvm_common.StreamTransactionArrayPkg.all ; 
    use OSVVM_Common.AddressBusTransactionPkg.all ; 
    use OSVVM_Common.AddressBusTransactionArrayPkg.all ; 
    use OSVVM_Common.AddressBusResponderTransactionPkg.all ;
    use OSVVM_Common.AddressBusResponderTransactionArrayPkg.all ;
    use OSVVM_Common.AddressBusVersionCompatibilityPkg.all ;  
    
    -- Interrupt
    use OSVVM_Common.InterruptGlobalSignalPkg.all ;
    use OSVVM_Common.InterruptHandlerComponentPkg.all ;
    use OSVVM_Common.InterruptGeneratorComponentPkg.all ;
end context OsvvmCommonContext ; 

