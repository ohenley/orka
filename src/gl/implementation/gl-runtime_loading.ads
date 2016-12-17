--  Copyright (c) 2013 Felix Krause <contact@flyx.org>
--
--  Licensed under the Apache License, Version 2.0 (the "License");
--  you may not use this file except in compliance with the License.
--  You may obtain a copy of the License at
--
--      http://www.apache.org/licenses/LICENSE-2.0
--
--  Unless required by applicable law or agreed to in writing, software
--  distributed under the License is distributed on an "AS IS" BASIS,
--  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--  See the License for the specific language governing permissions and
--  limitations under the License.

with System;

with GL.Functions;
with GL.Types;

private generic
   with function Raw_Subprogram_Reference (Name : String) return System.Address;
package GL.Runtime_Loading is
   pragma Preelaborate;

   use GL.Functions;

   -- This package loads raw API functions at runtime (meaning it requests
   -- the function pointer of the requested function at runtime).
   --
   -- Since some implementations of GL may return a function pointer even
   -- if it does not implement the actual feature, the functions in this
   -- package will never raise Feature_Not_Supported_Exception.
   -- Instead, the only reliable way on all platforms to find out whether
   -- a feature is supported is by using the GL.Context package.

   generic
      Function_ID : Reference_ID;
      type Return_Type is private;
   function Function_Without_Params return Return_Type;
   pragma Inline (Function_Without_Params);

   generic
      Function_ID : Reference_ID;
      type Param1_Type (<>) is private;
      type Return_Type is private;
   function Function_With_1_Param (Param1 : Param1_Type) return Return_Type;
   pragma Inline (Function_With_1_Param);

   generic
      Function_ID : Reference_ID;
      type Param1_Type (<>) is private;
      type Param2_Type (<>) is private;
      type Return_Type is private;
   function Function_With_2_Params (Param1 : Param1_Type;
                                    Param2 : Param2_Type)
                                   return Return_Type;
   pragma Inline (Function_With_2_Params);

   generic
      Function_ID : Reference_ID;
      type Param1_Type (<>) is private;
      type Param2_Type (<>) is private;
      type Param3_Type (<>) is private;
      type Return_Type is private;
   function Function_With_3_Params (Param1 : Param1_Type;
                                    Param2 : Param2_Type;
                                    Param3 : Param3_Type)
                                   return Return_Type;
   pragma Inline (Function_With_3_Params);

   generic
      Function_ID : Reference_ID;
      type Param1_Type (<>) is private;
      type Param2_Type (<>) is private;
      type Param3_Type (<>) is private;
      type Param4_Type (<>) is private;
      type Return_Type is private;
   function Function_With_4_Params (Param1 : Param1_Type;
                                    Param2 : Param2_Type;
                                    Param3 : Param3_Type;
                                    Param4 : Param4_Type)
                                   return Return_Type;
   pragma Inline (Function_With_4_Params);

   generic
      Procedure_ID : Reference_ID;
      type Param1_Type (<>) is private;
      type Element_Type is private;
      type Array_Type is array (Types.Size range <>) of Element_Type;
   function Array_Getter_With_4_Params (Param1   : Param1_Type;
                                        Max_Size : Types.Size)
                                        return Array_Type;
   pragma Inline (Array_Getter_With_4_Params);

   generic
      Procedure_ID : Reference_ID;
      type Param1_Type (<>) is private;
      type Param2_Type (<>) is private;
      type Param3_Type (<>) is private;
      type Param4_Type (<>) is private;
      type Param5_Type (<>) is private;
      type Element_Type is private;
      type Array_Type is array (Types.Size range <>) of Element_Type;
   function Array_Getter_With_8_Params (Param1   : Param1_Type;
                                        Param2   : Param2_Type;
                                        Param3   : Param3_Type;
                                        Param4   : Param4_Type;
                                        Param5   : Param5_Type;
                                        Max_Size : Types.Size)
                                        return Array_Type;
   pragma Inline (Array_Getter_With_8_Params);

   generic
      Procedure_ID : Reference_ID;
   procedure Procedure_Without_Params;
   pragma Inline (Procedure_Without_Params);
   
   generic
      Procedure_ID : Reference_ID;
      type Param1_Type (<>) is private;
   procedure Procedure_With_1_Param (Param1 : Param1_Type);
   pragma Inline (Procedure_With_1_Param);

   generic
      Procedure_ID : Reference_ID;
      type Param1_Type (<>) is private;
      type Param2_Type (<>) is private;
   procedure Procedure_With_2_Params (Param1 : Param1_Type;
                                      Param2 : Param2_Type);
   pragma Inline (Procedure_With_2_Params);

   generic
      Procedure_ID : Reference_ID;
      type Param1_Type (<>) is private;
      type Param2_Type (<>) is private;
      type Param3_Type (<>) is private;
   procedure Procedure_With_3_Params (Param1 : Param1_Type;
                                      Param2 : Param2_Type;
                                      Param3 : Param3_Type);
   pragma Inline (Procedure_With_3_Params);

   generic
      Procedure_ID : Reference_ID;
      type Param1_Type (<>) is private;
      type Param2_Type (<>) is private;
      type Param3_Type (<>) is private;
      type Param4_Type (<>) is private;
   procedure Procedure_With_4_Params (Param1 : Param1_Type;
                                      Param2 : Param2_Type;
                                      Param3 : Param3_Type;
                                      Param4 : Param4_Type);
   pragma Inline (Procedure_With_4_Params);

   generic
      Procedure_ID : Reference_ID;
      type Param1_Type (<>) is private;
      type Param2_Type (<>) is private;
      type Param3_Type (<>) is private;
      type Param4_Type (<>) is private;
      type Param5_Type (<>) is private;
   procedure Procedure_With_5_Params (Param1 : Param1_Type;
                                      Param2 : Param2_Type;
                                      Param3 : Param3_Type;
                                      Param4 : Param4_Type;
                                      Param5 : Param5_Type);
   pragma Inline (Procedure_With_5_Params);

   generic
      Procedure_ID : Reference_ID;
      type Param1_Type (<>) is private;
      type Param2_Type (<>) is private;
      type Param3_Type (<>) is private;
      type Param4_Type (<>) is private;
      type Param5_Type (<>) is private;
      type Param6_Type (<>) is private;
   procedure Procedure_With_6_Params (Param1 : Param1_Type;
                                      Param2 : Param2_Type;
                                      Param3 : Param3_Type;
                                      Param4 : Param4_Type;
                                      Param5 : Param5_Type;
                                      Param6 : Param6_Type);
   pragma Inline (Procedure_With_6_Params);

   generic
      Procedure_ID : Reference_ID;
      type Param1_Type (<>) is private;
      type Param2_Type (<>) is private;
      type Param3_Type (<>) is private;
      type Param4_Type (<>) is private;
      type Param5_Type (<>) is private;
      type Param6_Type (<>) is private;
      type Param7_Type (<>) is private;
   procedure Procedure_With_7_Params (Param1 : Param1_Type;
                                      Param2 : Param2_Type;
                                      Param3 : Param3_Type;
                                      Param4 : Param4_Type;
                                      Param5 : Param5_Type;
                                      Param6 : Param6_Type;
                                      Param7 : Param7_Type);
   pragma Inline (Procedure_With_7_Params);

   generic
      Procedure_ID : Reference_ID;
      type Param1_Type (<>) is private;
      type Param2_Type (<>) is private;
      type Param3_Type (<>) is private;
      type Param4_Type (<>) is private;
      type Param5_Type (<>) is private;
      type Param6_Type (<>) is private;
      type Param7_Type (<>) is private;
      type Param8_Type (<>) is private;
   procedure Procedure_With_8_Params (Param1 : Param1_Type;
                                      Param2 : Param2_Type;
                                      Param3 : Param3_Type;
                                      Param4 : Param4_Type;
                                      Param5 : Param5_Type;
                                      Param6 : Param6_Type;
                                      Param7 : Param7_Type;
                                      Param8 : Param8_Type);
   pragma Inline (Procedure_With_8_Params);

   generic
      Procedure_ID : Reference_ID;
      type Param1_Type (<>) is private;
      type Param2_Type (<>) is private;
      type Param3_Type (<>) is private;
      type Param4_Type (<>) is private;
      type Param5_Type (<>) is private;
      type Param6_Type (<>) is private;
      type Param7_Type (<>) is private;
      type Param8_Type (<>) is private;
      type Param9_Type (<>) is private;
   procedure Procedure_With_9_Params (Param1 : Param1_Type;
                                       Param2 : Param2_Type;
                                       Param3 : Param3_Type;
                                       Param4 : Param4_Type;
                                       Param5 : Param5_Type;
                                       Param6 : Param6_Type;
                                       Param7 : Param7_Type;
                                       Param8 : Param8_Type;
                                       Param9 : Param9_Type);
   pragma Inline (Procedure_With_9_Params);

   generic
      Procedure_ID : Reference_ID;
      type Param1_Type (<>) is private;
      type Param2_Type (<>) is private;
      type Param3_Type (<>) is private;
      type Param4_Type (<>) is private;
      type Param5_Type (<>) is private;
      type Param6_Type (<>) is private;
      type Param7_Type (<>) is private;
      type Param8_Type (<>) is private;
      type Param9_Type (<>) is private;
      type Param10_Type (<>) is private;
   procedure Procedure_With_10_Params (Param1 : Param1_Type;
                                       Param2 : Param2_Type;
                                       Param3 : Param3_Type;
                                       Param4 : Param4_Type;
                                       Param5 : Param5_Type;
                                       Param6 : Param6_Type;
                                       Param7 : Param7_Type;
                                       Param8 : Param8_Type;
                                       Param9 : Param9_Type;
                                       Param10 : Param10_Type);
   pragma Inline (Procedure_With_10_Params);

   generic
      Procedure_ID : Reference_ID;
      type Param1_Type (<>) is private;
      type Param2_Type (<>) is private;
      type Param3_Type (<>) is private;
      type Param4_Type (<>) is private;
      type Param5_Type (<>) is private;
      type Param6_Type (<>) is private;
      type Param7_Type (<>) is private;
      type Param8_Type (<>) is private;
      type Param9_Type (<>) is private;
      type Param10_Type (<>) is private;
      type Param11_Type (<>) is private;
   procedure Procedure_With_11_Params (Param1 : Param1_Type;
                                       Param2 : Param2_Type;
                                       Param3 : Param3_Type;
                                       Param4 : Param4_Type;
                                       Param5 : Param5_Type;
                                       Param6 : Param6_Type;
                                       Param7 : Param7_Type;
                                       Param8 : Param8_Type;
                                       Param9 : Param9_Type;
                                       Param10 : Param10_Type;
                                       Param11 : Param11_Type);
   pragma Inline (Procedure_With_11_Params);

   generic
      Procedure_ID : Reference_ID;
      type Param1_Type (<>) is private;
      type Param2_Type (<>) is private;
      type Param3_Type (<>) is private;
      type Param4_Type (<>) is private;
      type Param5_Type (<>) is private;
      type Param6_Type (<>) is private;
      type Param7_Type (<>) is private;
      type Param8_Type (<>) is private;
      type Param9_Type (<>) is private;
      type Param10_Type (<>) is private;
      type Param11_Type (<>) is private;
      type Param12_Type (<>) is private;
   procedure Procedure_With_12_Params (Param1 : Param1_Type;
                                       Param2 : Param2_Type;
                                       Param3 : Param3_Type;
                                       Param4 : Param4_Type;
                                       Param5 : Param5_Type;
                                       Param6 : Param6_Type;
                                       Param7 : Param7_Type;
                                       Param8 : Param8_Type;
                                       Param9 : Param9_Type;
                                       Param10 : Param10_Type;
                                       Param11 : Param11_Type;
                                       Param12 : Param12_Type);
   pragma Inline (Procedure_With_12_Params);

   generic
      Procedure_ID : Reference_ID;
      type Param1_Type is private;
      type Value_Type  (<>) is private;
   procedure Getter_With_2_Params (Param1 : Param1_Type;
                                   Value  : in out Value_Type);
   pragma Inline (Getter_With_2_Params);

   generic
      Procedure_ID : Reference_ID;
      type Param1_Type is private;
      type Param2_Type is private;
      type Value_Type  (<>) is private;
   procedure Getter_With_3_Params (Param1 : Param1_Type;
                                   Param2 : Param2_Type;
                                   Value  : in out Value_Type);
   pragma Inline (Getter_With_3_Params);

   generic
      Procedure_ID : Reference_ID;
      type Param1_Type is private;
      type Param2_Type is private;
      type Param3_Type is private;
      type Value_Type  (<>) is private;
   procedure Getter_With_4_Params (Param1 : Param1_Type;
                                   Param2 : Param2_Type;
                                   Param3 : Param3_Type;
                                   Value  : in out Value_Type);
   pragma Inline (Getter_With_4_Params);

   generic
      Procedure_ID : Reference_ID;
      type Size_Type is (<>);
      type Element_Type is private;
      type Array_Type is array (Positive range <>) of Element_Type;
   procedure Array_Proc_With_2_Params (Param1 : Size_Type;
                                       Param2 : Array_Type);
   pragma Inline (Array_Proc_With_2_Params);

   generic
      Procedure_ID : Reference_ID;
      type Param1_Type (<>) is private;
      type Size_Type is (<>);
      type Element_Type is private;
      type Array_Type is array (Positive range <>) of Element_Type;
   procedure Array_Proc_With_3_Params (Param1 : Param1_Type;
                                       Param2 : Size_Type;
                                       Param3 : Array_Type);
   pragma Inline (Array_Proc_With_3_Params);

   generic
      Procedure_ID : Reference_ID;
      type Size_Type is (<>);
      type Param1_Type is private;
   procedure String_Getter_With_4_Params (Param1      : Param1_Type;
                                          Buffer_Size : Size_Type;
                                          Length      : out Size_Type;
                                          Value       : in out String);
   pragma Inline (String_Getter_With_4_Params);

   generic
      Procedure_ID : Reference_ID;
      type Size_Type is (<>);
      type Param1_Type is private;
      type Param2_Type is private;
      type Param3_Type is private;
   procedure String_Getter_With_6_Params (Param1      : Param1_Type;
                                          Param2      : Param2_Type;
                                          Param3      : Param3_Type;
                                          Buffer_Size : Size_Type;
                                          Length      : out Size_Type;
                                          Value       : in out String);
   pragma Inline (String_Getter_With_6_Params);

   procedure Initialize;

private

   generic
      type Function_Reference is private;
   function Load (ID : Reference_ID) return Function_Reference
     with Inline;

   Loaded : array (Reference_ID) of System.Address;

end GL.Runtime_Loading;
