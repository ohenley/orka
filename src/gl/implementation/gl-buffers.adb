--  Copyright (c) 2012 Felix Krause <contact@flyx.org>
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

with Ada.Unchecked_Conversion;

with GL.API;
with GL.Enums.Getter;

package body GL.Buffers is

   use type Culling.Face_Selector;

   procedure Clear (Bits : Buffer_Bits) is
      use type Low_Level.Bitfield;
      function Convert is new Ada.Unchecked_Conversion
        (Source => Buffer_Bits, Target => Low_Level.Bitfield);
      Raw_Bits : constant Low_Level.Bitfield :=
        Convert (Bits) and 2#0100010100000000#;
   begin
      API.Clear (Raw_Bits);
      Raise_Exception_On_OpenGL_Error;
   end Clear;

   procedure Set_Color_Clear_Value (Value : Colors.Color) is
   begin
      API.Clear_Color (Value (Colors.R), Value (Colors.G), Value (Colors.B),
                       Value (Colors.A));
      Raise_Exception_On_OpenGL_Error;
   end Set_Color_Clear_Value;

   function Color_Clear_Value return Colors.Color is
      Value : Colors.Color;
   begin
      API.Get_Color (Enums.Getter.Color_Clear_Value, Value);
      Raise_Exception_On_OpenGL_Error;
      return Value;
   end Color_Clear_Value;

   procedure Color_Mask (Value : Colors.Enabled_Color) is
   begin
      API.Color_Mask
        (Low_Level.Bool (Value (Colors.R)), Low_Level.Bool (Value (Colors.G)),
         Low_Level.Bool (Value (Colors.B)), Low_Level.Bool (Value (Colors.A)));
      Raise_Exception_On_OpenGL_Error;
   end Color_Mask;

   procedure Color_Mask
     (Index : Draw_Buffer_Index;
      Value : Colors.Enabled_Color) is
   begin
      API.Color_Mask_Indexed
        (Index,
         Low_Level.Bool (Value (Colors.R)), Low_Level.Bool (Value (Colors.G)),
         Low_Level.Bool (Value (Colors.B)), Low_Level.Bool (Value (Colors.A)));
      Raise_Exception_On_OpenGL_Error;
   end Color_Mask;

   function Color_Mask (Index : Draw_Buffer_Index) return Colors.Enabled_Color is
      Value : Colors.Enabled_Color;
   begin
      API.Get_Enabled_Color (Enums.Getter.Color_Writemask, Index, Value);
      Raise_Exception_On_OpenGL_Error;
      return Value;
   end Color_Mask;

   procedure Set_Depth_Clear_Value (Value : Depth) is
   begin
      API.Clear_Depth (Value);
      Raise_Exception_On_OpenGL_Error;
   end Set_Depth_Clear_Value;

   function Depth_Clear_Value return Depth is
      Value : Double := 1.0;
   begin
      API.Get_Double (Enums.Getter.Depth_Clear_Value, Value);
      Raise_Exception_On_OpenGL_Error;
      return Value;
   end Depth_Clear_Value;

   procedure Set_Stencil_Clear_Value (Value : Stencil_Index) is
   begin
      API.Clear_Stencil (Value);
      Raise_Exception_On_OpenGL_Error;
   end Set_Stencil_Clear_Value;

   function Stencil_Clear_Value return Stencil_Index is
      Value : Stencil_Index := Stencil_Index'First;
   begin
      API.Get_Integer (Enums.Getter.Stencil_Clear_Value, Value);
      Raise_Exception_On_OpenGL_Error;
      return Value;
   end Stencil_Clear_Value;

   procedure Set_Depth_Function (Func : Compare_Function) is
   begin
      API.Depth_Func (Func);
      Raise_Exception_On_OpenGL_Error;
   end Set_Depth_Function;

   function Depth_Function return Compare_Function is
      Value : Compare_Function := Compare_Function'First;
   begin
      API.Get_Compare_Function (Enums.Getter.Depth_Func, Value);
      Raise_Exception_On_OpenGL_Error;
      return Value;
   end Depth_Function;

   procedure Depth_Mask (Enabled : Boolean) is
   begin
      API.Depth_Mask (Low_Level.Bool (Enabled));
      Raise_Exception_On_OpenGL_Error;
   end Depth_Mask;

   function Depth_Mask return Boolean is
      Value : Low_Level.Bool := Low_Level.Bool (True);
   begin
      API.Get_Boolean (Enums.Getter.Depth_Writemask, Value);
      Raise_Exception_On_OpenGL_Error;
      return Boolean (Value);
   end Depth_Mask;

   procedure Set_Stencil_Function (Func : Compare_Function;
                                   Ref  : Int;
                                   Mask : UInt) is
      Face : constant Culling.Face_Selector := Culling.Front_And_Back;
   begin
      Set_Stencil_Function (Face, Func, Ref, Mask);
   end Set_Stencil_Function;

   procedure Set_Stencil_Function (Face : Culling.Face_Selector;
                                   Func : Compare_Function;
                                   Ref  : Int;
                                   Mask : UInt) is
   begin
      API.Stencil_Func_Separate (Face, Func, Ref, Mask);
      Raise_Exception_On_OpenGL_Error;
   end Set_Stencil_Function;

   function Stencil_Function (Face : Single_Face_Selector) return Compare_Function is
      Value : Compare_Function := Compare_Function'First;
   begin
      if Face = Culling.Front then
         API.Get_Compare_Function (Enums.Getter.Stencil_Func, Value);
      else
         API.Get_Compare_Function (Enums.Getter.Stencil_Back_Func, Value);
      end if;
      Raise_Exception_On_OpenGL_Error;
      return Value;
   end Stencil_Function;

   function Stencil_Reference_Value (Face : Single_Face_Selector) return Int is
      Value : Int := 0;
   begin
      if Face = Culling.Front then
         API.Get_Integer (Enums.Getter.Stencil_Ref, Value);
      else
         API.Get_Integer (Enums.Getter.Stencil_Back_Ref, Value);
      end if;
      Raise_Exception_On_OpenGL_Error;
      return Value;
   end Stencil_Reference_Value;

   function Stencil_Value_Mask (Face : Single_Face_Selector) return UInt is
      Value : UInt := 0;
   begin
      if Face = Culling.Front then
         API.Get_Unsigned_Integer (Enums.Getter.Stencil_Value_Mask, Value);
      else
         API.Get_Unsigned_Integer (Enums.Getter.Stencil_Back_Value_Mask, Value);
      end if;
      Raise_Exception_On_OpenGL_Error;
      return Value;
   end Stencil_Value_Mask;

   procedure Set_Stencil_Operation (Stencil_Fail : Buffers.Stencil_Action;
                                    Depth_Fail   : Buffers.Stencil_Action;
                                    Depth_Pass   : Buffers.Stencil_Action) is
      Face : constant Culling.Face_Selector := Culling.Front_And_Back;
   begin
      Set_Stencil_Operation (Face, Stencil_Fail, Depth_Fail, Depth_Pass);
   end Set_Stencil_Operation;

   procedure Set_Stencil_Operation (Face : Culling.Face_Selector;
                                    Stencil_Fail : Buffers.Stencil_Action;
                                    Depth_Fail   : Buffers.Stencil_Action;
                                    Depth_Pass   : Buffers.Stencil_Action) is
   begin
      API.Stencil_Op_Separate (Face, Stencil_Fail, Depth_Fail, Depth_Pass);
      Raise_Exception_On_OpenGL_Error;
   end Set_Stencil_Operation;

   function Stencil_Operation_Stencil_Fail (Face : Single_Face_Selector) return Buffers.Stencil_Action is
      Value : Buffers.Stencil_Action := Buffers.Stencil_Action'First;
   begin
      if Face = Culling.Front then
         API.Get_Stencil_Action (Enums.Getter.Stencil_Fail, Value);
      else
         API.Get_Stencil_Action (Enums.Getter.Stencil_Back_Fail, Value);
      end if;
      Raise_Exception_On_OpenGL_Error;
      return Value;
   end Stencil_Operation_Stencil_Fail;

   function Stencil_Operation_Depth_Fail (Face : Single_Face_Selector) return Buffers.Stencil_Action is
      Value : Buffers.Stencil_Action := Buffers.Stencil_Action'First;
   begin
      if Face = Culling.Front then
         API.Get_Stencil_Action (Enums.Getter.Stencil_Pass_Depth_Fail, Value);
      else
         API.Get_Stencil_Action (Enums.Getter.Stencil_Back_Pass_Depth_Fail, Value);
      end if;
      Raise_Exception_On_OpenGL_Error;
      return Value;
   end Stencil_Operation_Depth_Fail;

   function Stencil_Operation_Depth_Pass (Face : Single_Face_Selector) return Buffers.Stencil_Action is
      Value : Buffers.Stencil_Action := Buffers.Stencil_Action'First;
   begin
      if Face = Culling.Front then
         API.Get_Stencil_Action (Enums.Getter.Stencil_Pass_Depth_Pass, Value);
      else
         API.Get_Stencil_Action (Enums.Getter.Stencil_Back_Pass_Depth_Pass, Value);
      end if;
      Raise_Exception_On_OpenGL_Error;
      return Value;
   end Stencil_Operation_Depth_Pass;

   procedure Set_Stencil_Mask (Value : UInt) is
      Face : constant Culling.Face_Selector := Culling.Front_And_Back;
   begin
      Set_Stencil_Mask (Face, Value);
   end Set_Stencil_Mask;

   procedure Set_Stencil_Mask (Face  : Culling.Face_Selector;
                               Value : UInt) is
   begin
      API.Stencil_Mask_Separate (Face, Value);
      Raise_Exception_On_OpenGL_Error;
   end Set_Stencil_Mask;

   function Stencil_Mask (Face : Single_Face_Selector) return UInt is
      Value : UInt := 0;
   begin
      if Face = Culling.Front then
         API.Get_Unsigned_Integer (Enums.Getter.Stencil_Writemask, Value);
      else
         API.Get_Unsigned_Integer (Enums.Getter.Stencil_Back_Writemask, Value);
      end if;
      Raise_Exception_On_OpenGL_Error;
      return Value;
   end Stencil_Mask;

end GL.Buffers;
