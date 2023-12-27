--
--  File Name:         ModelParametersSingletonPkg.vhd
--  Design Unit Name:  ModelParametersSingletonPkg
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
--    09/2023   2023.09    Made into Singleton
--    05/2020   2020.05    Added handling to also store std_logic_vector values
--                         Added AlertLogID for error handling
--    05/2020   NONE       Refactored from AbstractMmPkg.vhd
--                      
--
--
--  This file is part of OSVVM.
--
--  Copyright (c) 2020 by Highland Technology
--  Copyright (c) 2020-2023 by SynthWorks Design Inc.
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
use std.textio.all ; 

library osvvm;
context osvvm.OsvvmContext ; 


package ModelParametersSingletonPkg is

  type ModelParametersIDType is record
      ID             : integer_max ;
  end record ModelParametersIDType ; 
  
  constant OSVVM_MODEL_PARAM_ALERTLOG_ID : AlertLogIDType := OSVVM_ALERTLOG_ID ;
  
  type ModelParametersIDArrayType is array (integer range <>) of ModelParametersIDType ;  
  
  ------------------------------------------------------------
  --- ///////////////////////////////////////////////////////////////////////////
  ------------------------------------------------------------
  impure function NewID (
    Name                : String ;
    NumParams           : positive ; 
    ParentID            : AlertLogIDType          := OSVVM_MODEL_PARAM_ALERTLOG_ID ;
    ReportMode          : AlertLogReportModeType  := DISABLED ;
    Search              : NameSearchType          := PRIVATE_NAME ;
    PrintParent         : AlertLogPrintParentType := PRINT_NAME_AND_PARENT
  ) return ModelParametersIDType ;
  
  procedure Init(ID : ModelParametersIDType; NumParams : in positive);
  
  procedure Set(ID : ModelParametersIDType; Index: in natural; Data: in integer);
  procedure Set(ID : ModelParametersIDType; Data:  in integer_vector);
  procedure Set(ID : ModelParametersIDType; Index: in natural; Data: in integer; Size: positive);
  procedure Set(ID : ModelParametersIDType; Index: in natural; Data: in boolean);
  procedure Set(ID : ModelParametersIDType; Index: in natural; Data: in std_logic_vector);
  
  impure function Get(ID : ModelParametersIDType; Index: natural) return integer;
  impure function Get(ID : ModelParametersIDType; Index: natural) return boolean;
  impure function Get(ID : ModelParametersIDType; Index: natural) return std_logic_vector;
  impure function Get(ID : ModelParametersIDType; Index: natural; Size: natural) return std_logic_vector;
  
  ------------------------------------------------------------
  impure function GetAlertLogID (ID : ModelParametersIDType) return AlertLogIDType ;

end package ModelParametersSingletonPkg;

package body ModelParametersSingletonPkg is
	
	type ModelParametersSingletonType is protected
    impure function NewID (
      Name                : String ;
      NumParams           : positive ; 
      ParentID            : AlertLogIDType          := OSVVM_MODEL_PARAM_ALERTLOG_ID ;
      ReportMode          : AlertLogReportModeType  := DISABLED ;
      Search              : NameSearchType          := PRIVATE_NAME ;
      PrintParent         : AlertLogPrintParentType := PRINT_NAME_AND_PARENT
    ) return ModelParametersIDType ;

		procedure Init(ID : ModelParametersIDType; NumParams : in positive);
		
		procedure Set(ID : ModelParametersIDType; Index: in natural; Data: in integer);
		procedure Set(ID : ModelParametersIDType; Data:  in integer_vector);
		procedure Set(ID : ModelParametersIDType; Index: in natural; Data: in integer; Size: positive);
		procedure Set(ID : ModelParametersIDType; Index: in natural; Data: in boolean);
		procedure Set(ID : ModelParametersIDType; Index: in natural; Data: in std_logic_vector);
--		procedure Set(ID : ModelParametersIDType; Index: in natural; Data: in string);
		
		impure function Get(ID : ModelParametersIDType; Index: natural) return integer;
		impure function Get(ID : ModelParametersIDType; Index: natural) return boolean;
		impure function Get(ID : ModelParametersIDType; Index: natural) return std_logic_vector;
    impure function Get(ID : ModelParametersIDType; Index: natural; Size: natural) return std_logic_vector;
--		impure function Get(ID : ModelParametersIDType; Index: natural) return string;

    ------------------------------------------------------------
    impure function GetAlertLogID(ID : ModelParametersIDType) return AlertLogIDType ;
	end protected ModelParametersSingletonType;

	type ModelParametersSingletonType is protected body
		type SlvPtrType is access std_logic_vector;
    
    type ParamTypeType is (NONE, eSLV, eINT, eSTR) ; 

    type ParameterRecType is record 
      ParamType : ParamTypeType ; 
      IntParam  : integer ; 
      SlvParam  : SlvPtrType ;
      StrParam  : Line ;
    end record ParameterRecType ; 
    type ParameterRecArrayType is array (natural range <>) of ParameterRecType ; 
		type ParamPtrType is access ParameterRecArrayType ;
    
    type SingletonStructType is record
      ParamPtr     : ParamPtrType ; 
      AlertLogID   : AlertLogIDType ;
    end record SingletonStructType ; 
    
    type     SingletonArrayType    is array (integer range <>) of SingletonStructType ;
    type     SingletonArrayPtrType is access SingletonArrayType ;

    variable SingletonArrayPtr : SingletonArrayPtrType ;   
    variable NumItems          : integer := 0 ; 
    constant MIN_NUM_ITEMS     : integer := 32 ; -- Min amount to resize array
    variable LocalNameStore    : NameStorePType ;

    ------------------------------------------------------------
    -- Package Local
    function NormalizeArraySize( NewNumItems, MinNumItems : integer ) return integer is
    ------------------------------------------------------------
      variable NormNumItems : integer ;
      variable ModNumItems  : integer ;
    begin
      NormNumItems := NewNumItems ; 
      ModNumItems  := NewNumItems mod MinNumItems ; 
      if ModNumItems > 0 then 
        NormNumItems := NormNumItems + (MinNumItems - ModNumItems) ; 
      end if ; 
      return NormNumItems ; 
    end function NormalizeArraySize ;

    ------------------------------------------------------------
    -- Package Local
    procedure GrowNumberItems (
    ------------------------------------------------------------
      variable SingletonArrayPtr : InOut SingletonArrayPtrType ;
      variable NumItems          : InOut integer ;
      constant GrowAmount        : in    integer ;
      constant MinNumItems       : in    integer 
    ) is
      variable oldSingletonArrayPtr : SingletonArrayPtrType ;
      variable NewNumItems     : integer ;
      variable NewSize         : integer ;
    begin
      NewNumItems := NumItems + GrowAmount ; 
      NewSize     := NormalizeArraySize(NewNumItems, MinNumItems) ;
      if SingletonArrayPtr = NULL then
        SingletonArrayPtr := new SingletonArrayType(1 to NewSize) ;
      elsif NewNumItems > SingletonArrayPtr'length then
        oldSingletonArrayPtr := SingletonArrayPtr ;
        SingletonArrayPtr    := new SingletonArrayType(1 to NewSize) ;
        SingletonArrayPtr.all(1 to NumItems) := oldSingletonArrayPtr.all(1 to NumItems) ;
        deallocate(oldSingletonArrayPtr) ;
      end if ;
      NumItems := NewNumItems ; 
    end procedure GrowNumberItems ;

    ------------------------------------------------------------
    impure function NewID (
    ------------------------------------------------------------
      Name                : String ;
      NumParams           : positive ; 
      ParentID            : AlertLogIDType          := OSVVM_MODEL_PARAM_ALERTLOG_ID ;
      ReportMode          : AlertLogReportModeType  := DISABLED ;
      Search              : NameSearchType          := PRIVATE_NAME ;
      PrintParent         : AlertLogPrintParentType := PRINT_NAME_AND_PARENT
    ) return ModelParametersIDType is
      variable NameID              : integer ;
      variable ResolvedSearch      : NameSearchType ;
      variable ResolvedPrintParent : AlertLogPrintParentType ;
      variable NewModelID          : ModelParametersIDType ;
    begin
      ResolvedSearch      := ResolveSearch     (ParentID /= OSVVM_MODEL_PARAM_ALERTLOG_ID, Search) ;
      ResolvedPrintParent := ResolvePrintParent(ParentID /= OSVVM_MODEL_PARAM_ALERTLOG_ID, PrintParent) ;

      NameID := LocalNameStore.find(Name, ParentID, ResolvedSearch) ;

      if NameID /= ID_NOT_FOUND.ID then
        NewModelID := (ID => NameID) ;
        return NewModelID ;
      else
        -- Add New Item to Singleton to Structure
        GrowNumberItems(SingletonArrayPtr, NumItems, 1, MIN_NUM_ITEMS) ;
        NewModelID := (ID => NumItems) ;
        -- Create AlertLogID
        SingletonArrayPtr(NumItems).AlertLogID := NewID(Name, ParentID, ReportMode, ResolvedPrintParent, CreateHierarchy => FALSE) ;
        -- Add item to NameStore
        NameID := LocalNameStore.NewID(Name, ParentID, ResolvedSearch) ;
        -- Initialize 
        Init(NewModelID, NumParams) ; 
        -- Check NameStore Index vs NumItems
        AlertIfNotEqual(SingletonArrayPtr(NumItems).AlertLogID, NameID, NumItems, "NewID: NewID /= NameStoreID") ;  
        return NewModelID ; 
      end if ;
    end function NewID ;
	
    ------------------------------------------------------------
    procedure Deallocate(ID : ModelParametersIDType) is
    ------------------------------------------------------------
    begin
      for i in SingletonArrayPtr(ID.ID).ParamPtr'range loop  
        deallocate(SingletonArrayPtr(ID.ID).ParamPtr(i).SlvParam) ;
        deallocate(SingletonArrayPtr(ID.ID).ParamPtr(i).StrParam) ;
      end loop ;
      deallocate(SingletonArrayPtr(ID.ID).ParamPtr);
    end procedure Deallocate ; 
    
    ------------------------------------------------------------
		--	Create storage for NumParams parameters
		procedure Init(ID : ModelParametersIDType; NumParams : in positive) is
    ------------------------------------------------------------
		begin
			if SingletonArrayPtr(ID.ID).ParamPtr /= NULL then
-- probably a mistake to do this
-- Should instead do a resize of the structure like in ScoreboardPkg.
        Deallocate(SingletonArrayPtr(ID.ID).ParamPtr) ; 
      end if; 
			SingletonArrayPtr(ID.ID).ParamPtr := new ParameterRecArrayType(0 to NumParams-1);
			for i in SingletonArrayPtr(ID.ID).ParamPtr'range loop
				SingletonArrayPtr(ID.ID).ParamPtr(i).IntParam := 0;
			end loop;
		end procedure Init;
		
		
    ------------------------------------------------------------
		procedure Set(ID : ModelParametersIDType; Index: in natural; Data: in integer) is
    ------------------------------------------------------------
		begin
      case SingletonArrayPtr(ID.ID).ParamPtr(Index).ParamType is 
        when NONE | eINT =>
          SingletonArrayPtr(ID.ID).ParamPtr(Index).IntParam     := Data;
          SingletonArrayPtr(ID.ID).ParamPtr(Index).ParamType  := eINT;
        
        when eSLV =>
          SingletonArrayPtr(ID.ID).ParamPtr(Index).SlvParam.all := std_logic_vector(to_signed(Data, SingletonArrayPtr(ID.ID).ParamPtr(Index).SlvParam'length));
          SingletonArrayPtr(ID.ID).ParamPtr(Index).ParamType  := eSLV;

        when eSTR =>
          Alert(SingletonArrayPtr(ID.ID).AlertLogID, "Set: Require Type String") ; 

      end case ; 
    end procedure Set;
		
    ------------------------------------------------------------
		procedure Set(ID : ModelParametersIDType; Data: in integer_vector) is
    ------------------------------------------------------------
      alias aData : integer_vector(0 to Data'length -1) is Data ; 
		begin
      for i in aData'range loop 
        Set(ID, i, aData(i)) ; 
      end loop ;
    end procedure Set ; 
		
    ------------------------------------------------------------
		procedure Set(ID : ModelParametersIDType; Index: in natural; Data: in boolean) is
    ------------------------------------------------------------
		begin
      case SingletonArrayPtr(ID.ID).ParamPtr(Index).ParamType is 
        when NONE | eINT =>
          SingletonArrayPtr(ID.ID).ParamPtr(Index).IntParam     := 1 when Data else 0 ;
          SingletonArrayPtr(ID.ID).ParamPtr(Index).ParamType  := eINT;
        
        when eSLV =>
          SingletonArrayPtr(ID.ID).ParamPtr(Index).SlvParam.all := (SingletonArrayPtr(ID.ID).ParamPtr(Index).SlvParam'range => '0') ;
          SingletonArrayPtr(ID.ID).ParamPtr(Index).SlvParam(0) := '1' when Data else '0';
          SingletonArrayPtr(ID.ID).ParamPtr(Index).ParamType  := eSLV;

        when eSTR =>
          Alert(SingletonArrayPtr(ID.ID).AlertLogID, "Set: Require Type String") ; 

      end case ; 
		end procedure Set;
		
    ------------------------------------------------------------
		procedure Set(ID : ModelParametersIDType; Index: in natural; Data: in integer; Size: positive) is
    ------------------------------------------------------------
      -- to_signed correctly handles non-negative integers up Size in length
      constant SlvVal : std_logic_vector(Size-1 downto 0) := std_logic_vector(to_signed(Data, Size));
		begin
      case SingletonArrayPtr(ID.ID).ParamPtr(Index).ParamType is 
        when NONE =>
          SingletonArrayPtr(ID.ID).ParamPtr(Index).SlvParam    := new std_logic_vector'(SlvVal);
          SingletonArrayPtr(ID.ID).ParamPtr(Index).ParamType := eSLV;

        when eSLV  =>
--? What if parameters do not match in size?
          SingletonArrayPtr(ID.ID).ParamPtr(Index).SlvParam.all := resize(SlvVal, SingletonArrayPtr(ID.ID).ParamPtr(Index).SlvParam'length);
        
        when eINT =>
          SingletonArrayPtr(ID.ID).ParamPtr(Index).IntParam    := Data;
          SingletonArrayPtr(ID.ID).ParamPtr(Index).ParamType   := eINT;

        when eSTR =>
          Alert(SingletonArrayPtr(ID.ID).AlertLogID, "Set: Require Type String") ; 

      end case ; 
		end procedure Set;

    ------------------------------------------------------------
		procedure Set(ID : ModelParametersIDType; Index: in natural; Data: in std_logic_vector) is
    ------------------------------------------------------------
      alias aData : std_logic_vector(Data'length-1 downto 0) is Data ; 
		begin
      case SingletonArrayPtr(ID.ID).ParamPtr(Index).ParamType is 
        when NONE =>
          SingletonArrayPtr(ID.ID).ParamPtr(Index).SlvParam    := new std_logic_vector'(aData)  ;
          SingletonArrayPtr(ID.ID).ParamPtr(Index).ParamType := eSLV;
        
        when eSLV  =>
--? What if parameters do not match in size?
          SingletonArrayPtr(ID.ID).ParamPtr(Index).SlvParam.all := resize(aData, SingletonArrayPtr(ID.ID).ParamPtr(Index).SlvParam'length);

        when eINT =>
          SingletonArrayPtr(ID.ID).ParamPtr(Index).IntParam    := to_integer(signed(Data));
          SingletonArrayPtr(ID.ID).ParamPtr(Index).ParamType := eINT;

        when eSTR =>
          Alert(SingletonArrayPtr(ID.ID).AlertLogID, "Set: Require Type String") ; 

      end case ; 
		end procedure Set;
		
    ------------------------------------------------------------
		impure function Get(ID : ModelParametersIDType; Index: natural) return integer is
    ------------------------------------------------------------
		begin
      case SingletonArrayPtr(ID.ID).ParamPtr(Index).ParamType is 
        when NONE =>
          alert(SingletonArrayPtr(ID.ID).AlertLogID, "ModelParametersSingletonType.Get[natural, return integer] No value set");
          return integer'left;
        
        when eINT =>
          return SingletonArrayPtr(ID.ID).ParamPtr(Index).IntParam;

        when eSLV =>
-- std_logic_vector values are unsigned
          return to_integer(unsigned(SingletonArrayPtr(ID.ID).ParamPtr(Index).SlvParam.all));

        when eSTR =>
          Alert(SingletonArrayPtr(ID.ID).AlertLogID, "Expecting Type String") ; 
          return integer'left;

      end case ; 
		end function Get;
		
    ------------------------------------------------------------
		impure function Get(ID : ModelParametersIDType; Index: natural) return boolean is
    ------------------------------------------------------------
		begin
      case SingletonArrayPtr(ID.ID).ParamPtr(Index).ParamType is 
        when NONE =>
          alert(SingletonArrayPtr(ID.ID).AlertLogID, "ModelParametersSingletonType.Get[natural, return boolean] No value set");
          return boolean'left;
        
        when eINT =>
          return (SingletonArrayPtr(ID.ID).ParamPtr(Index).IntParam /= 0);

        when eSLV =>
          return (SingletonArrayPtr(ID.ID).ParamPtr(Index).SlvParam(0) /= '0');

        when eSTR =>
          Alert(SingletonArrayPtr(ID.ID).AlertLogID, "Expecting Type String") ; 
          return boolean'left;

      end case ; 
		end function Get;
		
    ------------------------------------------------------------
		impure function Get(ID : ModelParametersIDType; Index: natural) return std_logic_vector is
    ------------------------------------------------------------
		begin
      case SingletonArrayPtr(ID.ID).ParamPtr(Index).ParamType is 
        when NONE =>
          alert(SingletonArrayPtr(ID.ID).AlertLogID, "ModelParametersSingletonType.Get[natural, return std_logic_vector] No value set");
          return 32SB"U";
        
        when eINT =>
          return std_logic_vector(to_signed(SingletonArrayPtr(ID.ID).ParamPtr(Index).IntParam, 32));

        when eSLV =>
          return SingletonArrayPtr(ID.ID).ParamPtr(Index).SlvParam.all;

        when eSTR =>
          Alert(SingletonArrayPtr(ID.ID).AlertLogID, "Expecting Type String") ; 
          return 32SB"U";

      end case ; 
		end function Get;
		
    ------------------------------------------------------------
    impure function Get(ID : ModelParametersIDType; Index: natural; Size: natural) return std_logic_vector is
    ------------------------------------------------------------
      constant AllU   : std_logic_vector(Size-1 downto 0) := (others => 'U') ; 
      variable Result : signed(31 downto 0) ;
		begin
      case SingletonArrayPtr(ID.ID).ParamPtr(Index).ParamType is 
        when NONE =>
          alert(SingletonArrayPtr(ID.ID).AlertLogID, "ModelParametersSingletonType.Get[natural, positive return std_logic_vector] No value set");
          return AllU;
        
        when eINT =>
          Result := to_signed(SingletonArrayPtr(ID.ID).ParamPtr(Index).IntParam, 32) ;
          return std_logic_vector(Result(Size-1 downto 0));

        when eSLV =>
          return resize(SingletonArrayPtr(ID.ID).ParamPtr(Index).SlvParam.all, Size);

        when eSTR =>
          Alert(SingletonArrayPtr(ID.ID).AlertLogID, "Expecting Type String") ; 
          return AllU;

      end case ; 
		end function Get;
    
    ------------------------------------------------------------
    impure function GetAlertLogID(ID : ModelParametersIDType) return AlertLogIDType is
    ------------------------------------------------------------
    begin
      return SingletonArrayPtr(ID.ID).AlertLogID ; 
    end function GetAlertLogID ;
    
				
	end protected body ModelParametersSingletonType;
  
-- /////////////////////////////////////////
-- /////////////////////////////////////////
-- Singleton Data Structure
-- /////////////////////////////////////////
-- /////////////////////////////////////////
  shared variable ModelParameters : ModelParametersSingletonType ;
 
  impure function NewID (
    Name                : String ;
    NumParams           : positive ; 
    ParentID            : AlertLogIDType          := OSVVM_MODEL_PARAM_ALERTLOG_ID ;
    ReportMode          : AlertLogReportModeType  := DISABLED ;
    Search              : NameSearchType          := PRIVATE_NAME ;
    PrintParent         : AlertLogPrintParentType := PRINT_NAME_AND_PARENT
  ) return ModelParametersIDType is
    variable Result : ModelParametersIDType ; 
  begin
    Result := ModelParameters.NewID(Name, NumParams, ParentID, ReportMode, Search, PrintParent) ; 
    return Result ; 
  end function NewID ; 
  
  procedure Init(ID : ModelParametersIDType; NumParams : in positive) is
  begin
    ModelParameters.Init(ID, NumParams) ; 
  end procedure Init ;
  
  procedure Set(ID : ModelParametersIDType; Index: in natural; Data: in integer) is
  begin
    ModelParameters.Set(ID, Index, Data) ; 
  end procedure Set ; 
  
  procedure Set(ID : ModelParametersIDType; Data: in integer_vector) is
  begin
    ModelParameters.Set(ID, Data) ; 
  end procedure Set ; 

  procedure Set(ID : ModelParametersIDType; Index: in natural; Data: in integer; Size: positive) is
  begin
    ModelParameters.Set(ID, Index, Data, Size) ; 
  end procedure Set ; 
  
  procedure Set(ID : ModelParametersIDType; Index: in natural; Data: in boolean) is
  begin
    ModelParameters.Set(ID, Index, Data) ; 
  end procedure Set ; 
  
  procedure Set(ID : ModelParametersIDType; Index: in natural; Data: in std_logic_vector) is
  begin
    ModelParameters.Set(ID, Index, Data) ; 
  end procedure Set ; 
  
  
  impure function Get(ID : ModelParametersIDType; Index: natural) return integer is
  begin
    return ModelParameters.Get(ID, Index) ; 
  end function Get ; 
  
  impure function Get(ID : ModelParametersIDType; Index: natural) return boolean is
  begin
    return ModelParameters.Get(ID, Index) ; 
  end function Get ; 
  
  impure function Get(ID : ModelParametersIDType; Index: natural) return std_logic_vector is
  begin
    return ModelParameters.Get(ID, Index) ; 
  end function Get ; 
  
  impure function Get(ID : ModelParametersIDType; Index: natural; Size: natural) return std_logic_vector is
  begin
    return ModelParameters.Get(ID, Index, Size) ; 
  end function Get ; 
  
  
  ------------------------------------------------------------
  impure function GetAlertLogID (ID : ModelParametersIDType) return AlertLogIDType  is
  begin
    return ModelParameters.GetAlertLogID(ID) ; 
  end function GetAlertLogID ; 
  
	
end package body ModelParametersSingletonPkg;
