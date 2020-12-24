--
--  File Name:         ModelParametersPkg.vhd
--  Design Unit Name:  ModelParametersPkg
--  Revision:          OSVVM MODELS STANDARD VERSION
--
--  Author:      Rob Gaddi  <rgaddi@highlandtechnology.com>
--  Company      Highland Technology, Inc.
--
--  Contributor(s):
--     Jim Lewis      jim@synthworks.com
--
--
--  Description:
--      Defines ModelParametersPType
--
--  Revision History:
--    Date      Version    Description
--    05/2020   NONE       Refactored from AbstractMmPkg.vhd
--    05/2020   2020.05    Added handling to also store std_logic_vector values
--                         Added AlertLogID for error handling
--                      
--
--
--  This file is part of OSVVM.
--
--  Copyright (c) 2020 by Highland Technology
--  Copyright (c) 2020 by SynthWorks Design Inc.
--
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std_unsigned.all;

library osvvm;
context osvvm.OsvvmContext ; 


package ModelParametersPkg is
	
	type ModelParametersPType is protected
-- Add SetAlertLogID(string, ID), SetAlertLogID(ID), GetAlertLogID

		procedure Init(nparams : in positive);
--		procedure Init(initvals : in integer_vector);
		
		procedure Set(Index: in natural; Data: in integer);
		procedure Set(Data:  in integer_vector);
		procedure Set(Index: in natural; Data: in integer; len: positive);
		procedure Set(Index: in natural; Data: in boolean);
		procedure Set(Index: in natural; Data: in std_logic_vector);
		
		impure function Get(Index: natural) return integer;
		impure function Get(Index: natural) return boolean;
		impure function Get(Index: natural) return std_logic_vector;
		impure function Get(Index: natural; len: positive) return std_logic_vector;
    
    ------------------------------------------------------------
    procedure SetAlertLogID (A : AlertLogIDType) ;
    procedure SetAlertLogID (Name : string ; ParentID : AlertLogIDType := ALERTLOG_BASE_ID ; CreateHierarchy : Boolean := TRUE) ;    
    impure function GetAlertLogID return AlertLogIDType ;
	end protected ModelParametersPType;

end package ModelParametersPkg;

package body ModelParametersPkg is
	
	type ModelParametersPType is protected body
		type SlvPtrType is access std_logic_vector;
    
    type ParmTypeType is (NONE, eSLV, eINT) ; 

    type ParameterRecType is record 
      ParmType : ParmTypeType ; 
      IParm    : integer ; 
      SParm    : SlvPtrType ; 
    end record ParameterRecType ; 
    type ParameterRecArrayType is array (natural range <>) of ParameterRecType ; 
		type ParamPtrType is access ParameterRecArrayType ;
		variable ParmPtrVar : ParamPtrType := NULL;
    
    variable AlertLogIDVar : AlertLogIDType := OSVVM_ALERTLOG_ID ;
	
    ------------------------------------------------------------
    procedure Deallocate is
    ------------------------------------------------------------
    begin
      for i in ParmPtrVar'range loop  
        if ParmPtrVar(i).SParm /= NULL then 
          deallocate(ParmPtrVar(i).SParm) ;
        end if ; 
      end loop ;
      deallocate(ParmPtrVar);
    end procedure Deallocate ; 
    
    ------------------------------------------------------------
		--	Create storage for nParams parameters
		procedure Init(nparams : in positive) is
    ------------------------------------------------------------
		begin
			if ParmPtrVar /= NULL then
-- probably a mistake to do this
-- Should instead do a resize of the structure like in ScoreboardPkg.
        Deallocate; 
      end if; 
			ParmPtrVar := new ParameterRecArrayType(0 to nparams-1);
			for i in ParmPtrVar'range loop
				ParmPtrVar(i).IParm := 0;
			end loop;
		end procedure Init;
		
    ------------------------------------------------------------
--		--	Initialize the parameters array from initvals.
--		procedure Init(InitVals : in integer_vector) is
    ------------------------------------------------------------
--      alias aInitVals : integer_vector(0 to InitVals'length-1) ;
--		begin
--      Deallocate ; 
--			ParmPtrVar := new ParameterRecArrayType(0 to InitVals'length-1);
--      for i in aInitVals'range loop 
--        ParmPtrVar(i).IsInit := TRUE ;
--        ParmPtrVar(i).IParm  := aInitVals(i) ;
--      end loop ; 
--		end procedure Init;
		
    ------------------------------------------------------------
		procedure Set(Index: in natural; Data: in integer) is
    ------------------------------------------------------------
		begin
      case ParmPtrVar(Index).ParmType is 
        when NONE | eINT =>
          ParmPtrVar(Index).IParm     := Data;
          ParmPtrVar(Index).ParmType  := eINT;
        
        when eSLV =>
          ParmPtrVar(Index).SParm.all := std_logic_vector(to_signed(Data, ParmPtrVar(Index).SParm'length));
          ParmPtrVar(Index).ParmType  := eSLV;
      end case ; 
    end procedure Set;
		
    ------------------------------------------------------------
		procedure Set(Data: in integer_vector) is
    ------------------------------------------------------------
		begin
      for i in Data'range loop 
        Set(i, Data(i)) ; 
      end loop ;
    end procedure Set ; 
		
    ------------------------------------------------------------
		procedure Set(Index: in natural; Data: in boolean) is
    ------------------------------------------------------------
		begin
      case ParmPtrVar(Index).ParmType is 
        when NONE | eINT =>
          ParmPtrVar(Index).IParm     := 1 when Data else 0 ;
          ParmPtrVar(Index).ParmType  := eINT;
        
        when eSLV =>
          ParmPtrVar(Index).SParm.all := (ParmPtrVar(Index).SParm'range => '0') ;
          ParmPtrVar(Index).SParm(0) := '1' when Data else '0';
          ParmPtrVar(Index).ParmType  := eSLV;
      end case ; 
		end procedure Set;
		
    ------------------------------------------------------------
		procedure Set(Index: in natural; Data: in integer; len: positive) is
    ------------------------------------------------------------
      -- to_signed correctly handles non-negative integers up len in length
      constant SlvVal : std_logic_vector(len-1 downto 0) := std_logic_vector(to_signed(Data, len));
		begin
      case ParmPtrVar(Index).ParmType is 
        when NONE =>
          ParmPtrVar(Index).SParm    := new std_logic_vector'(SlvVal);
          ParmPtrVar(Index).ParmType := eSLV;

        when eSLV  =>
--? What if parameters do not match in size?
          ParmPtrVar(Index).SParm.all := resize(SlvVal, ParmPtrVar(Index).SParm'length);
        
        when eINT =>
          ParmPtrVar(Index).IParm    := Data;
          ParmPtrVar(Index).ParmType := eINT;
      end case ; 
		end procedure Set;

    ------------------------------------------------------------
		procedure Set(Index: in natural; Data: in std_logic_vector) is
    ------------------------------------------------------------
      alias aData : std_logic_vector(Data'length-1 downto 0) is Data ; 
		begin
      case ParmPtrVar(Index).ParmType is 
        when NONE =>
          ParmPtrVar(Index).SParm    := new std_logic_vector'(aData)  ;
          ParmPtrVar(Index).ParmType := eSLV;
        
        when eSLV  =>
--? What if parameters do not match in size?
          ParmPtrVar(Index).SParm.all := resize(aData, ParmPtrVar(Index).SParm'length);

        when eINT =>
          ParmPtrVar(Index).IParm    := to_integer(signed(Data));
          ParmPtrVar(Index).ParmType := eINT;
      end case ; 
		end procedure Set;
		
    ------------------------------------------------------------
		impure function Get(Index: natural) return integer is
    ------------------------------------------------------------
		begin
      case ParmPtrVar(Index).ParmType is 
        when NONE =>
          alert(AlertLogIDVar, "ModelParametersPType.Get[natural, return integer] No value set");
          return integer'left;
        
        when eINT =>
          return ParmPtrVar(Index).IParm;

        when eSLV =>
-- std_logic_vector values are unsigned
          return to_integer(unsigned(ParmPtrVar(Index).SParm.all));
      end case ; 
		end function Get;
		
    ------------------------------------------------------------
		impure function Get(Index: natural) return boolean is
    ------------------------------------------------------------
		begin
      case ParmPtrVar(Index).ParmType is 
        when NONE =>
          alert(AlertLogIDVar, "ModelParametersPType.Get[natural, return boolean] No value set");
          return boolean'left;
        
        when eINT =>
          return (ParmPtrVar(Index).IParm /= 0);

        when eSLV =>
          return (ParmPtrVar(Index).SParm(0) /= '0');
      end case ; 
		end function Get;
		
    ------------------------------------------------------------
		impure function Get(Index: natural) return std_logic_vector is
    ------------------------------------------------------------
		begin
      case ParmPtrVar(Index).ParmType is 
        when NONE =>
          alert(AlertLogIDVar, "ModelParametersPType.Get[natural, return std_logic_vector] No value set");
          return (31 downto 0 => 'U');
        
        when eINT =>
          return std_logic_vector(to_signed(ParmPtrVar(Index).IParm, 32));

        when eSLV =>
          return ParmPtrVar(Index).SParm.all;
      end case ; 
		end function Get;
		
    ------------------------------------------------------------
		impure function Get(Index: natural; len: positive) return std_logic_vector is
    ------------------------------------------------------------
		begin
      case ParmPtrVar(Index).ParmType is 
        when NONE =>
          alert(AlertLogIDVar, "ModelParametersPType.Get[natural, positive return std_logic_vector] No value set");
          return (len-1 downto 0 => 'U');
        
        when eINT =>
          return std_logic_vector(to_signed(ParmPtrVar(Index).IParm, len));

        when eSLV =>
          return resize(ParmPtrVar(Index).SParm.all, len);
      end case ; 
		end function Get;
    
    ------------------------------------------------------------
    procedure SetAlertLogID (A : AlertLogIDType) is
    ------------------------------------------------------------
    begin
      AlertLogIDVar := A ;
    end procedure SetAlertLogID ;

    ------------------------------------------------------------
    procedure SetAlertLogID(Name : string ; ParentID : AlertLogIDType := ALERTLOG_BASE_ID ; CreateHierarchy : Boolean := TRUE) is
    ------------------------------------------------------------
    begin
      AlertLogIDVar := GetAlertLogID(Name, ParentID, CreateHierarchy) ;
    end procedure SetAlertLogID ;
    
    ------------------------------------------------------------
    impure function GetAlertLogID return AlertLogIDType is
    ------------------------------------------------------------
    begin
      return AlertLogIDVar ; 
    end function GetAlertLogID ;
    
				
	end protected body ModelParametersPType;
	
end package body ModelParametersPkg;
