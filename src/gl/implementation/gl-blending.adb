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

with GL.API;
with GL.Enums.Getter;

package body GL.Blending is

   procedure Set_Blend_Func (Src_Factor, Dst_Factor : Blend_Factor) is
   begin
      API.Blend_Func (Src_Factor, Dst_Factor);
      Raise_Exception_On_OpenGL_Error;
   end Set_Blend_Func;

   procedure Set_Blend_Func (Draw_Buffer : Buffers.Draw_Buffer_Index;
                             Src_Factor, Dst_Factor : Blend_Factor) is
   begin
      API.Blend_Func_I (Draw_Buffer, Src_Factor, Dst_Factor);
      Raise_Exception_On_OpenGL_Error;
   end Set_Blend_Func;

   procedure Set_Blend_Func_Separate (Src_RGB, Dst_RGB, Src_Alpha, Dst_Alpha
                                      : Blend_Factor) is
   begin
      API.Blend_Func_Separate (Src_RGB, Dst_RGB, Src_Alpha, Dst_Alpha);
      Raise_Exception_On_OpenGL_Error;
   end Set_Blend_Func_Separate;

   procedure Set_Blend_Func_Separate (Draw_Buffer : Buffers.Draw_Buffer_Index;
                                      Src_RGB, Dst_RGB, Src_Alpha, Dst_Alpha
                                      : Blend_Factor) is
   begin
      API.Blend_Func_Separate_I (Draw_Buffer, Src_RGB, Dst_RGB,
                                 Src_Alpha, Dst_Alpha);
      Raise_Exception_On_OpenGL_Error;
   end Set_Blend_Func_Separate;

   function Blend_Func_Src_RGB return Blend_Factor is
      Ret : Blend_Factor := One;
   begin
      API.Get_Blend_Factor (Enums.Getter.Blend_Src_RGB, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Ret;
   end Blend_Func_Src_RGB;

   function Blend_Func_Src_Alpha return Blend_Factor is
      Ret : Blend_Factor := One;
   begin
      API.Get_Blend_Factor (Enums.Getter.Blend_Src_Alpha, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Ret;
   end Blend_Func_Src_Alpha;

   function Blend_Func_Dst_RGB return Blend_Factor is
      Ret : Blend_Factor := Zero;
   begin
      API.Get_Blend_Factor (Enums.Getter.Blend_Dst_RGB, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Ret;
   end Blend_Func_Dst_RGB;

   function Blend_Func_Dst_Alpha return Blend_Factor is
      Ret : Blend_Factor := Zero;
   begin
      API.Get_Blend_Factor (Enums.Getter.Blend_Dst_Alpha, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Ret;
   end Blend_Func_Dst_Alpha;

   procedure Set_Blend_Color (Value : Types.Colors.Color) is
      use Types.Colors;
   begin
      API.Blend_Color (Value (R), Value (G), Value (B), Value (A));
      Raise_Exception_On_OpenGL_Error;
   end Set_Blend_Color;

   function Blend_Color return Types.Colors.Color is
      Ret : Types.Colors.Color;
   begin
      API.Get_Color (Enums.Getter.Blend_Color, Ret);
      return Ret;
   end Blend_Color;

   procedure Set_Blend_Equation (Value : Equation) is
   begin
      API.Blend_Equation (Value);
      Raise_Exception_On_OpenGL_Error;
   end Set_Blend_Equation;

   procedure Set_Blend_Equation (Draw_Buffer : Buffers.Draw_Buffer_Index;
                                 Value : Equation) is
   begin
      API.Blend_Equation_I (Draw_Buffer, Value);
      Raise_Exception_On_OpenGL_Error;
   end Set_Blend_Equation;

   procedure Set_Blend_Equation_Separate (RGB, Alpha : Equation) is
   begin
      API.Blend_Equation_Separate (RGB, Alpha);
      Raise_Exception_On_OpenGL_Error;
   end Set_Blend_Equation_Separate;

   procedure Set_Blend_Equation_Separate
     (Draw_Buffer : Buffers.Draw_Buffer_Index; RGB, Alpha : Equation) is
   begin
      API.Blend_Equation_Separate_I (Draw_Buffer, RGB, Alpha);
      Raise_Exception_On_OpenGL_Error;
   end Set_Blend_Equation_Separate;

   function Blend_Equation_RGB return Equation is
      Ret : Equation := Equation'First;
   begin
      API.Get_Blend_Equation (Enums.Getter.Blend_Equation_RGB, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Ret;
   end Blend_Equation_RGB;

   function Blend_Equation_Alpha return Equation is
      Ret : Equation := Equation'First;
   begin
      API.Get_Blend_Equation (Enums.Getter.Blend_Equation_Alpha, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Ret;
   end Blend_Equation_Alpha;

end GL.Blending;
