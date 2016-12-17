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

with GL.Functions;
with GL.Runtime_Loading;

with GL.Attributes;
with GL.Blending;
with GL.Buffers;
with GL.Culling;
with GL.Enums.Getter;
with GL.Enums.Textures;
with GL.Errors;
with GL.Framebuffer;
with GL.Low_Level.Enums;
with GL.Objects.Buffers;
with GL.Objects.Framebuffers;
with GL.Objects.Programs;
with GL.Objects.Queries;
with GL.Objects.Shaders;
with GL.Objects.Textures;
with GL.Objects.Transform_Feedbacks;
with GL.Objects.Vertex_Arrays;
with GL.Pixels;
with GL.Rasterization;
with GL.Toggles;
with GL.Types.Colors;

with Interfaces.C.Strings;

with System;

private package GL.API is
   pragma Preelaborate;

   use GL.Functions;
   use GL.Types;

   function GL_Subprogram_Reference (Function_Name : String) return System.Address;
   --  Implementation is platform-specific. Therefore, gl-api.adb is in the
   --  platform-specific source folders.

   package Loader is new Runtime_Loading (GL_Subprogram_Reference);

   --  Everything newer than OpenGL 1.1 will not be statically bound,
   --  but loaded with GL.Low_Level.Loader at runtime.
   --
   --  Also, all functions that have been deprecated with OpenGL 3.0
   --  will not be statically bound, as they may be omitted by implementors
   --  when they choose to only implement the OpenGL Core Profile.

   subtype Zero is Int range 0 .. 0;

   function Get_Error return Errors.Error_Code;
   pragma Import (Convention => StdCall, Entity => Get_Error,
                  External_Name => "glGetError");

   procedure Flush;
   pragma Import (Convention => StdCall, Entity => Flush,
                  External_Name => "glFlush");

   procedure Finish;
   pragma Import (Convention => StdCall, Entity => Finish,
                  External_Name => "glFinish");

   -----------------------------------------------------------------------------
   --                            Parameter getters                            --
   -----------------------------------------------------------------------------

   procedure Get_Boolean (Name   : Enums.Getter.Parameter;
                          Target : access Low_Level.Bool);
   pragma Import (Convention => StdCall, Entity => Get_Boolean,
                  External_Name => "glGetBooleanv");

   procedure Get_Double (Name   : Enums.Getter.Parameter;
                         Target : access Double);
   pragma Import (Convention => StdCall, Entity => Get_Double,
                  External_Name => "glGetDoublev");

   procedure Get_Double_Vec2 (Name   : Enums.Getter.Parameter;
                              Target : in out Doubles.Vector2);
   pragma Import (Convention => StdCall, Entity => Get_Double_Vec2,
                  External_Name => "glGetDoublev");

   procedure Get_Single (Name : Enums.Getter.Parameter;
                         Target : access Single);
   pragma Import (Convention => StdCall, Entity => Get_Single,
                  External_Name => "glGetFloatv");

   procedure Get_Single_Vec2 (Name   : Enums.Getter.Parameter;
                              Target : in out Singles.Vector2);
   pragma Import (Convention => StdCall, Entity => Get_Single_Vec2,
                  External_Name => "glGetFloatv");

   procedure Get_Color (Name : Enums.Getter.Parameter;
                        Target : in out Colors.Color);
   pragma Import (Convention => StdCall, Entity => Get_Color,
                  External_Name => "glGetFloatv");

   procedure Get_Long (Name : Enums.Getter.Parameter;
                       Target : access Long);
   pragma Import (Convention => StdCall, Entity => Get_Long,
                  External_Name => "glGetInteger64v");

   procedure Get_Integer (Name   : Enums.Getter.Parameter;
                          Target : access Int);
   pragma Import (Convention => StdCall, Entity => Get_Integer,
                  External_Name => "glGetIntegerv");

   procedure Get_Int_Vec4 (Name   : Enums.Getter.Parameter;
                           Target : in out Ints.Vector4);
   pragma Import (Convention => StdCall, Entity => Get_Int_Vec4,
                  External_Name => "glGetIntegerv");

   procedure Get_Unsigned_Integer (Name   : Enums.Getter.Parameter;
                                   Target : access UInt);
   pragma Import (Convention => StdCall, Entity => Get_Unsigned_Integer,
                  External_Name => "glGetIntegerv");

   procedure Get_Size (Name   : Enums.Getter.Parameter;
                       Target : access Size);
   pragma Import (Convention => StdCall, Entity => Get_Size,
                  External_Name => "glGetIntegerv");

   procedure Get_Blend_Factor (Name : Enums.Getter.Parameter;
                               Target : access Blending.Blend_Factor);
   pragma Import (Convention => StdCall, Entity => Get_Blend_Factor,
                  External_Name => "glGetIntegerv");

   procedure Get_Alignment (Name : Enums.Getter.Parameter;
                            Target : access Pixels.Alignment);
   pragma Import (Convention => StdCall, Entity => Get_Alignment,
                  External_Name => "glGetIntegerv");

   procedure Get_Blend_Equation (Name : Enums.Getter.Parameter;
                                 Target : access Blending.Equation);
   pragma Import (Convention => StdCall, Entity => Get_Blend_Equation,
                  External_Name => "glGetIntegerv");

   procedure Get_Compare_Function (Name : Enums.Getter.Parameter;
                                   Target : access Compare_Function);
   pragma Import (Convention => StdCall, Entity => Get_Compare_Function,
                  External_Name => "glGetIntegerv");

   procedure Get_Orientation (Name : Enums.Getter.Parameter;
                              Target : access Culling.Orientation);
   pragma Import (Convention => StdCall, Entity => Get_Orientation,
                  External_Name => "glGetIntegerv");

   procedure Get_Face_Selector (Name : Enums.Getter.Parameter;
                                Target : access Culling.Face_Selector);
   pragma Import (Convention => StdCall, Entity => Get_Face_Selector,
                  External_Name => "glGetIntegerv");

   procedure Get_Polygon_Mode (Name   : Enums.Getter.Parameter;
                               Target : access Rasterization.Polygon_Mode_Type);
   pragma Import (Convention => StdCall, Entity => Get_Polygon_Mode,
                  External_Name => "glGetIntegerv");

   procedure Get_Logic_Op (Name : Enums.Getter.Parameter;
                           Target : access Framebuffer.Logic_Op);
   pragma Import (Convention => StdCall, Entity => Get_Logic_Op,
                  External_Name => "glGetIntegerv");

   procedure Get_Stencil_Action (Name : Enums.Getter.Parameter;
                                 Target : access Buffers.Stencil_Action);
   pragma Import (Convention => StdCall, Entity => Get_Stencil_Action,
                  External_Name => "glGetIntegerv");

   procedure Get_Read_Buffer_Selector
     (Name   : Enums.Getter.Parameter;
      Target : access Buffers.Color_Buffer_Selector);
   pragma Import (Convention => StdCall, Entity => Get_Read_Buffer_Selector,
                  External_Name => "glGetIntegerv");

   function Get_String (Name : Enums.Getter.String_Parameter) 
                        return C.Strings.chars_ptr;  
   pragma Import (Convention => StdCall, Entity => Get_String,
                  External_Name => "glGetString");

   function Get_String_I is new Loader.Function_With_2_Params
     (GL_Get_Stringi, Enums.Getter.String_Parameter, UInt, C.Strings.chars_ptr);

   -----------------------------------------------------------------------------
   --                                 Toggles                                 --
   -----------------------------------------------------------------------------

   procedure Enable (Subject : Toggles.Toggle);
   pragma Import (Convention => StdCall, Entity => Enable,
                  External_Name => "glEnable");

   procedure Disable (Subject : Toggles.Toggle);
   pragma Import (Convention => StdCall, Entity => Disable,
                  External_Name => "glDisable");

   function Is_Enabled (Subject : Toggles.Toggle) return Low_Level.Bool;
   pragma Import (Convention => StdCall, Entity => Is_Enabled,
                  External_Name => "glIsEnabled");

   -----------------------------------------------------------------------------
   --                                 Culling                                 --
   -----------------------------------------------------------------------------

   procedure Cull_Face (Selector : Culling.Face_Selector);
   pragma Import (Convention => StdCall, Entity => Cull_Face,
                  External_Name => "glCullFace");

   procedure Front_Face (Face : Culling.Orientation);
   pragma Import (Convention => StdCall, Entity => Front_Face,
                  External_Name => "glFrontFace");

   -----------------------------------------------------------------------------
   --                               Pixel stuff                               --
   -----------------------------------------------------------------------------

   procedure Pixel_Store (Param : Enums.Pixel_Store_Param;
                          Value : Low_Level.Bool);
   procedure Pixel_Store (Param : Enums.Pixel_Store_Param;
                          Value : Size);
   procedure Pixel_Store (Param : Enums.Pixel_Store_Param;
                          Value : Pixels.Alignment);
   pragma Import (Convention => StdCall, Entity => Pixel_Store,
                  External_Name => "glPixelStorei");

   -----------------------------------------------------------------------------
   --                         Framebuffer operations                          --
   -----------------------------------------------------------------------------

   procedure Clamp_Color is new Loader.Procedure_With_2_Params
     (GL_Clamp_Color, Enums.Clamp_Color_Param, Low_Level.Bool);

   -----------------------------------------------------------------------------
   --                                 Drawing                                 --
   -----------------------------------------------------------------------------

   procedure Draw_Arrays (Mode  : Connection_Mode;
                          First : Int; Count : Size);
   pragma Import (Convention => StdCall, Entity => Draw_Arrays,
                  External_Name => "glDrawArrays");

   procedure Draw_Arrays_Instanced is new Loader.Procedure_With_4_Params
     (GL_Draw_Arrays_Instanced, Connection_Mode, Int, Size, Size);

   procedure Draw_Arrays_Instanced_Base_Instance is new Loader.Procedure_With_5_Params
     (GL_Draw_Arrays_Instanced_Base_Instance, Connection_Mode, Int, Size, Size, UInt);

   procedure Multi_Draw_Arrays is new Loader.Procedure_With_4_Params
     (GL_Multi_Draw_Arrays, Connection_Mode, Size_Array, Size_Array, Size);

   procedure Multi_Draw_Arrays_Indirect is new Loader.Procedure_With_4_Params
     (GL_Multi_Draw_Arrays_Indirect, Connection_Mode, Int, Size, Size);

   procedure Draw_Elements (Mode       : Connection_Mode;
                            Count      : Size;
                            Index_Type : Unsigned_Numeric_Type;
                            Indices    : Zero);
   pragma Import (Convention => StdCall, Entity => Draw_Elements,
                  External_Name => "glDrawElements");

   procedure Draw_Elements_Base_Vertex is new Loader.Procedure_With_5_Params
     (GL_Draw_Elements_Base_Vertex, Connection_Mode, Size, Unsigned_Numeric_Type, Int, Int);

   procedure Draw_Elements_Instanced is new Loader.Procedure_With_5_Params
     (GL_Draw_Elements_Instanced, Connection_Mode, Size, Unsigned_Numeric_Type, Zero, Size);

   procedure Draw_Elements_Instanced_Base_Instance is new Loader.Procedure_With_6_Params
     (GL_Draw_Elements_Instanced_Base_Instance, Connection_Mode, Size,
      Unsigned_Numeric_Type, Int, Size, UInt);

   procedure Draw_Elements_Instanced_Base_Vertex is new Loader.Procedure_With_6_Params
     (GL_Draw_Elements_Instanced_Base_Vertex, Connection_Mode, Size,
      Unsigned_Numeric_Type, Int, Size, Int);

   procedure Draw_Elements_Instanced_Base_Vertex_Base_Instance is new Loader.Procedure_With_7_Params
     (GL_Draw_Elements_Instanced_Base_Vertex_Base_Instance, Connection_Mode, Size,
      Unsigned_Numeric_Type, Int, Size, Int, UInt);

   procedure Multi_Draw_Elements is new Loader.Procedure_With_5_Params
     (GL_Multi_Draw_Elements, Connection_Mode, Size_Array, Unsigned_Numeric_Type, Size_Array, Size);

   procedure Multi_Draw_Elements_Base_Vertex is new Loader.Procedure_With_6_Params
     (GL_Multi_Draw_Elements_Base_Vertex, Connection_Mode, Size_Array,
      Unsigned_Numeric_Type, Size_Array, Size, Size_Array);

   procedure Multi_Draw_Elements_Indirect is new Loader.Procedure_With_5_Params
     (GL_Multi_Draw_Elements_Indirect, Connection_Mode, Unsigned_Numeric_Type,
      Int, Size, Size);

   -----------------------------------------------------------------------------
   --                                Blending                                 --
   -----------------------------------------------------------------------------

   procedure Blend_Func (Src_Factor, Dst_Factor : Blending.Blend_Factor);
   pragma Import (Convention => StdCall, Entity => Blend_Func,
                  External_Name => "glBlendFunc");

   procedure Blend_Func_I is new Loader.Procedure_With_3_Params
     (GL_Blend_Funci, Buffers.Draw_Buffer_Index, Blending.Blend_Factor,
      Blending.Blend_Factor);

   procedure Blend_Func_Separate is new Loader.Procedure_With_4_Params
     (GL_Blend_Func_Separate, Blending.Blend_Factor, Blending.Blend_Factor,
      Blending.Blend_Factor, Blending.Blend_Factor);

   procedure Blend_Func_Separate_I is new Loader.Procedure_With_5_Params
     (GL_Blend_Func_Separate, Buffers.Draw_Buffer_Index, Blending.Blend_Factor,
      Blending.Blend_Factor, Blending.Blend_Factor, Blending.Blend_Factor);

   procedure Blend_Color is new Loader.Procedure_With_4_Params
     (GL_Blend_Color, Colors.Component, Colors.Component, Colors.Component,
      Colors.Component);

   procedure Blend_Equation is new Loader.Procedure_With_1_Param
     (GL_Blend_Equation, Blending.Equation);

   procedure Blend_Equation_I is new Loader.Procedure_With_2_Params
     (GL_Blend_Equationi, Buffers.Draw_Buffer_Index, Blending.Equation);

   procedure Blend_Equation_Separate is new Loader.Procedure_With_2_Params
     (GL_Blend_Equation_Separate, Blending.Equation, Blending.Equation);

   procedure Blend_Equation_Separate_I is new Loader.Procedure_With_3_Params
     (GL_Blend_Equationi, Buffers.Draw_Buffer_Index, Blending.Equation,
      Blending.Equation);

   -----------------------------------------------------------------------------
   --                              Rasterization                              --
   -----------------------------------------------------------------------------

   procedure Line_Width (Value : Single);
   pragma Import (Convention => StdCall, Entity => Line_Width,
                  External_Name => "glLineWidth");

   procedure Polygon_Mode (Face : Culling.Face_Selector;
                           Value : Rasterization.Polygon_Mode_Type);
   pragma Import (Convention => StdCall, Entity => Polygon_Mode,
                  External_Name => "glPolygonMode");

   -----------------------------------------------------------------------------
   --                                 Buffers                                 --
   -----------------------------------------------------------------------------

   procedure Clear (Bits : Low_Level.Bitfield);
   pragma Import (Convention => StdCall, Entity => Clear,
                  External_Name => "glClear");

   procedure Clear_Color (Red, Green, Blue, Alpha : Colors.Component);
   pragma Import (Convention => StdCall, Entity => Clear_Color,
                  External_Name => "glClearColor");

   procedure Clear_Depth (Depth : Buffers.Depth);
   pragma Import (Convention => StdCall, Entity => Clear_Depth,
                  External_Name => "glClearDepth");

   procedure Clear_Stencil (Index : Buffers.Stencil_Index);
   pragma Import (Convention => StdCall, Entity => Clear_Stencil,
                  External_Name => "glClearStencil");

   -----------------------------------------------------------------------------
   --                        Depth and stencil buffers                        --
   -----------------------------------------------------------------------------

   procedure Depth_Mask (Value : Low_Level.Bool);
   pragma Import (Convention => StdCall, Entity => Depth_Mask,
                  External_Name => "glDepthMask");

   procedure Depth_Func (Func : Compare_Function);
   pragma Import (Convention => StdCall, Entity => Depth_Func,
                  External_Name => "glDepthFunc");

   procedure Stencil_Func_Separate is new Loader.Procedure_With_4_Params
     (GL_Stencil_Func_Separate, Culling.Face_Selector,
      Compare_Function, Int, UInt);

   procedure Stencil_Op_Separate is new Loader.Procedure_With_4_Params
     (GL_Stencil_Op_Separate, Culling.Face_Selector, Buffers.Stencil_Action,
      Buffers.Stencil_Action, Buffers.Stencil_Action);

   procedure Stencil_Mask_Separate is new Loader.Procedure_With_2_Params
     (GL_Stencil_Mask_Separate, Culling.Face_Selector, UInt);

   -----------------------------------------------------------------------------
   --                                Textures                                 --
   -----------------------------------------------------------------------------

   procedure Texture_Parameter_Min_Filter is new Loader.Procedure_With_3_Params
     (GL_Texture_Parameteri, UInt, Enums.Textures.Parameter, Objects.Textures.Minifying_Function);
   procedure Texture_Parameter_Mag_Filter is new Loader.Procedure_With_3_Params
     (GL_Texture_Parameteri, UInt, Enums.Textures.Parameter, Objects.Textures.Magnifying_Function);
   procedure Texture_Parameter_Wrap_Mode is new Loader.Procedure_With_3_Params
     (GL_Texture_Parameteri, UInt, Enums.Textures.Parameter, Objects.Textures.Wrapping_Mode);
   procedure Texture_Parameter_Compare_Mode is new Loader.Procedure_With_3_Params
     (GL_Texture_Parameteri, UInt, Enums.Textures.Parameter, Enums.Textures.Compare_Kind);
   procedure Texture_Parameter_Compare_Func is new Loader.Procedure_With_3_Params
     (GL_Texture_Parameteri, UInt, Enums.Textures.Parameter, Compare_Function);
   procedure Texture_Parameter_Depth_Mode is new Loader.Procedure_With_3_Params
     (GL_Texture_Parameteri, UInt, Enums.Textures.Parameter, Objects.Textures.Depth_Mode);

   procedure Texture_Parameter_Bool is new Loader.Procedure_With_3_Params
     (GL_Texture_Parameteri, UInt, Enums.Textures.Parameter, Low_Level.Bool);
   procedure Texture_Parameter_Int is new Loader.Procedure_With_3_Params
     (GL_Texture_Parameteri, UInt, Enums.Textures.Parameter, Int);
   procedure Texture_Parameter_Float is new Loader.Procedure_With_3_Params
     (GL_Texture_Parameterf, UInt, Enums.Textures.Parameter, Single);
   procedure Texture_Parameter_Floats is new Loader.Procedure_With_3_Params
     (GL_Texture_Parameterfv, UInt, Enums.Textures.Parameter, Low_Level.Single_Array);

   procedure Get_Texture_Parameter_Min_Filter is new Loader.Getter_With_3_Params
     (GL_Get_Texture_Parameteriv, UInt, Enums.Textures.Parameter, Objects.Textures.Minifying_Function);
   procedure Get_Texture_Parameter_Mag_Filter is new Loader.Getter_With_3_Params
     (GL_Get_Texture_Parameteriv, UInt, Enums.Textures.Parameter, Objects.Textures.Magnifying_Function);
   procedure Get_Texture_Parameter_Wrap_Mode is new Loader.Getter_With_3_Params
     (GL_Get_Texture_Parameteriv, UInt, Enums.Textures.Parameter, Objects.Textures.Wrapping_Mode);
   procedure Get_Texture_Parameter_Compare_Mode is new Loader.Getter_With_3_Params
     (GL_Get_Texture_Parameteriv, UInt, Enums.Textures.Parameter, Enums.Textures.Compare_Kind);
   procedure Get_Texture_Parameter_Compare_Func is new Loader.Getter_With_3_Params
     (GL_Get_Texture_Parameteriv, UInt, Enums.Textures.Parameter, Compare_Function);
   procedure Get_Texture_Parameter_Depth_Mode is new Loader.Getter_With_3_Params
     (GL_Get_Texture_Parameteriv, UInt, Enums.Textures.Parameter, Objects.Textures.Depth_Mode);

   procedure Get_Texture_Parameter_Bool is new Loader.Getter_With_3_Params
     (GL_Get_Texture_Parameteriv, UInt, Enums.Textures.Parameter, Low_Level.Bool);
   procedure Get_Texture_Parameter_Int is new Loader.Getter_With_3_Params
     (GL_Get_Texture_Parameteriv, UInt, Enums.Textures.Parameter, Int);
   procedure Get_Texture_Parameter_Floats is new Loader.Getter_With_3_Params
     (GL_Get_Texture_Parameterfv, UInt, Enums.Textures.Parameter, Low_Level.Single_Array);

   procedure Get_Texture_Level_Parameter_Size is new Loader.Getter_With_4_Params
     (GL_Get_Texture_Level_Parameteriv, UInt, Objects.Textures.Mipmap_Level,
      Enums.Textures.Level_Parameter, Size);
   procedure Get_Texture_Level_Parameter_Format is new Loader.Getter_With_4_Params
     (GL_Get_Texture_Level_Parameteriv, UInt, Objects.Textures.Mipmap_Level,
      Enums.Textures.Level_Parameter, Pixels.Internal_Format);
   procedure Get_Texture_Level_Parameter_Type is new Loader.Getter_With_4_Params
     (GL_Get_Texture_Level_Parameteriv, UInt, Objects.Textures.Mipmap_Level,
      Enums.Textures.Level_Parameter, Pixels.Channel_Data_Type);
   procedure Get_Texture_Level_Parameter_Bool is new Loader.Getter_With_4_Params
     (GL_Get_Texture_Level_Parameteriv, UInt, Objects.Textures.Mipmap_Level,
      Enums.Textures.Level_Parameter, Low_Level.Bool);

   procedure Delete_Textures (N : Size; Textures : Low_Level.UInt_Array);
   pragma Import (Convention => StdCall, Entity => Delete_Textures,
                  External_Name => "glDeleteTextures");

   procedure Texture_Buffer is new Loader.Procedure_With_3_Params
     (GL_Texture_Buffer, UInt, Pixels.Internal_Format_Buffer_Texture, UInt);

   procedure Texture_Buffer_Range is new Loader.Procedure_With_5_Params
     (GL_Texture_Buffer_Range, UInt, Pixels.Internal_Format_Buffer_Texture, UInt,
      Low_Level.IntPtr, Size);

   procedure Texture_Storage_1D is new Loader.Procedure_With_4_Params
     (GL_Texture_Storage_1D, UInt, Size, Pixels.Internal_Format, Size);

   procedure Texture_Storage_2D is new Loader.Procedure_With_5_Params
     (GL_Texture_Storage_2D, UInt, Size, Pixels.Internal_Format, Size, Size);

   procedure Texture_Storage_3D is new Loader.Procedure_With_6_Params
     (GL_Texture_Storage_3D, UInt, Size, Pixels.Internal_Format, Size, Size, Size);

   procedure Texture_Storage_2D_Multisample is new Loader.Procedure_With_6_Params
     (GL_Texture_Storage_2D_Multisample, UInt, Size, Pixels.Internal_Format,
      Size, Size, Low_Level.Bool);

   procedure Texture_Storage_3D_Multisample is new Loader.Procedure_With_7_Params
     (GL_Texture_Storage_3D_Multisample, UInt, Size, Pixels.Internal_Format,
      Size, Size, Size, Low_Level.Bool);

   procedure Texture_Sub_Image_1D is new Loader.Procedure_With_7_Params
     (GL_Texture_Sub_Image_1D, UInt, Objects.Textures.Mipmap_Level,
      Int, Size, Pixels.Format, Pixels.Data_Type,
      System.Address);

   procedure Texture_Sub_Image_2D is new Loader.Procedure_With_9_Params
     (GL_Texture_Sub_Image_2D, UInt, Objects.Textures.Mipmap_Level,
      Int, Int, Size, Size, Pixels.Format, Pixels.Data_Type,
      System.Address);

   procedure Texture_Sub_Image_3D is new Loader.Procedure_With_11_Params
     (GL_Texture_Sub_Image_3D, UInt, Objects.Textures.Mipmap_Level,
      Int, Int, Int, Size, Size, Size, Pixels.Format, Pixels.Data_Type,
      System.Address);

   procedure Compressed_Texture_Sub_Image_1D is new Loader.Procedure_With_7_Params
     (GL_Compressed_Texture_Sub_Image_1D, UInt, Objects.Textures.Mipmap_Level,
      Int, Size, Pixels.Format, Size,
      System.Address);

   procedure Compressed_Texture_Sub_Image_2D is new Loader.Procedure_With_9_Params
     (GL_Compressed_Texture_Sub_Image_2D, UInt, Objects.Textures.Mipmap_Level,
      Int, Int, Size, Size, Pixels.Format, Size,
      System.Address);

   procedure Compressed_Texture_Sub_Image_3D is new Loader.Procedure_With_11_Params
     (GL_Compressed_Texture_Sub_Image_3D, UInt, Objects.Textures.Mipmap_Level,
      Int, Int, Int, Size, Size, Size, Pixels.Format, Size,
      System.Address);

   procedure Copy_Texture_Sub_Image_1D is new Loader.Procedure_With_6_Params
     (GL_Copy_Texture_Sub_Image_1D, UInt, Objects.Textures.Mipmap_Level,
      Int, Int, Int, Size);

   procedure Copy_Texture_Sub_Image_2D is new Loader.Procedure_With_8_Params
     (GL_Copy_Texture_Sub_Image_2D, UInt, Objects.Textures.Mipmap_Level,
      Int, Int, Int, Int, Size, Size);

   procedure Copy_Texture_Sub_Image_3D is new Loader.Procedure_With_9_Params
     (GL_Copy_Texture_Sub_Image_3D, UInt, Objects.Textures.Mipmap_Level,
      Int, Int, Int, Int, Int, Size, Size);

   procedure Generate_Texture_Mipmap is new Loader.Procedure_With_1_Param
     (GL_Generate_Texture_Mipmap, UInt);

   procedure Invalidate_Tex_Image is new Loader.Procedure_With_2_Params
     (GL_Invalidate_Tex_Image, UInt, Objects.Textures.Mipmap_Level);

   procedure Invalidate_Tex_Sub_Image is new Loader.Procedure_With_8_Params
     (GL_Invalidate_Tex_Sub_Image, UInt, Objects.Textures.Mipmap_Level,
      Int, Int, Int, Size, Size, Size);

   procedure Create_Textures is new Loader.Getter_With_3_Params
     (GL_Create_Textures, Low_Level.Enums.Non_Proxy_Texture_Kind, Size, UInt);

   procedure Bind_Texture_Unit is new Loader.Procedure_With_2_Params
     (GL_Bind_Texture_Unit, Objects.Textures.Texture_Unit, UInt);

   -----------------------------------------------------------------------------
   --                             Buffer objects                              --
   -----------------------------------------------------------------------------

   procedure Create_Buffers is new Loader.Getter_With_2_Params
      (GL_Create_Buffers, Size, UInt);

   procedure Delete_Buffers is new Loader.Array_Proc_With_2_Params
      (GL_Delete_Buffers, Size, UInt, Low_Level.UInt_Array);

   procedure Bind_Buffer is new Loader.Procedure_With_2_Params
      (GL_Bind_Buffer, Low_Level.Enums.Buffer_Kind, UInt);

   procedure Bind_Buffer_Base is new Loader.Procedure_With_3_Params
      (GL_Bind_Buffer_Base, Low_Level.Enums.Buffer_Kind, UInt, UInt);

   procedure Bind_Buffer_Range is new Loader.Procedure_With_5_Params
      (GL_Bind_Buffer_Range, Low_Level.Enums.Buffer_Kind, UInt, UInt,
       Low_Level.IntPtr, Low_Level.SizeIPtr);

   procedure Named_Buffer_Data is new Loader.Procedure_With_4_Params
      (GL_Named_Buffer_Data, UInt, Low_Level.SizeIPtr,
       System.Address, Objects.Buffers.Buffer_Usage);

   procedure Named_Buffer_Sub_Data is new Loader.Procedure_With_4_Params
      (GL_Named_Buffer_Sub_Data, UInt, Low_Level.IntPtr, Low_Level.SizeIPtr,
       System.Address);

   procedure Named_Buffer_Storage is new Loader.Procedure_With_4_Params
      (GL_Named_Buffer_Storage, UInt, Low_Level.SizeIPtr,
       System.Address, Low_Level.Bitfield);

   -- glMapNamedBuffer[Range] returns an instance of generic Interfaces.C.Pointers.Pointer,
   -- therefore declared in GL.Objects.Buffers

   procedure Unmap_Named_Buffer is new Loader.Procedure_With_1_Param
     (GL_Unmap_Named_Buffer, UInt);

   procedure Get_Named_Buffer_Parameter_Access_Kind is new Loader.Getter_With_3_Params
     (GL_Get_Named_Buffer_Parameteriv, UInt, Enums.Buffer_Param,
      Objects.Buffers.Access_Kind);

   procedure Get_Named_Buffer_Parameter_Bool is new Loader.Getter_With_3_Params
     (GL_Get_Named_Buffer_Parameteriv, UInt, Enums.Buffer_Param,
      Low_Level.Bool);

   procedure Get_Named_Buffer_Parameter_Bitfield is new Loader.Getter_With_3_Params
     (GL_Get_Named_Buffer_Parameteriv, UInt, Enums.Buffer_Param,
      Low_Level.Bitfield);

   procedure Get_Named_Buffer_Parameter_Size is new Loader.Getter_With_3_Params
     (GL_Get_Named_Buffer_Parameteriv, UInt, Enums.Buffer_Param,
      Size);

   procedure Get_Named_Buffer_Parameter_Usage is new Loader.Getter_With_3_Params
     (GL_Get_Named_Buffer_Parameteriv, UInt, Enums.Buffer_Param,
      Objects.Buffers.Buffer_Usage);

   procedure Invalidate_Buffer_Data is new Loader.Procedure_With_1_Param
     (GL_Invalidate_Buffer_Data, UInt);

   procedure Invalidate_Buffer_Sub_Data is new Loader.Procedure_With_3_Params
     (GL_Invalidate_Buffer_Sub_Data, UInt, Low_Level.IntPtr, Low_Level.SizeIPtr);

   procedure Flush_Mapped_Named_Buffer_Range is new Loader.Procedure_With_3_Params
     (GL_Flush_Mapped_Named_Buffer_Range, UInt, Low_Level.IntPtr, Low_Level.SizeIPtr);

   procedure Copy_Named_Buffer_Sub_Data is new Loader.Procedure_With_5_Params
     (GL_Copy_Named_Buffer_Sub_Data, UInt, UInt, Low_Level.IntPtr, Low_Level.IntPtr,
      Low_Level.SizeIPtr);

   -----------------------------------------------------------------------------
   --                           Vertex Array Objects                          --
   -----------------------------------------------------------------------------

   procedure Create_Vertex_Arrays is new Loader.Getter_With_2_Params
     (GL_Create_Vertex_Arrays, Size, UInt);

   procedure Delete_Vertex_Arrays is new Loader.Array_Proc_With_2_Params
     (GL_Delete_Vertex_Arrays, Size, UInt, Low_Level.UInt_Array);

   procedure Bind_Vertex_Array is new Loader.Procedure_With_1_Param
     (GL_Bind_Vertex_Array, UInt);

   procedure Vertex_Array_Attrib_Format is new Loader.Procedure_With_6_Params
     (GL_Vertex_Array_Attrib_Format, UInt, Attributes.Attribute, Component_Count,
      Numeric_Type, Low_Level.Bool, UInt);

   procedure Vertex_Array_AttribI_Format is new Loader.Procedure_With_5_Params
     (GL_Vertex_Array_Attrib_I_Format, UInt, Attributes.Attribute, Component_Count,
      Numeric_Type, UInt);

   procedure Vertex_Array_AttribL_Format is new Loader.Procedure_With_5_Params
     (GL_Vertex_Array_Attrib_L_Format, UInt, Attributes.Attribute, Component_Count,
      Numeric_Type, UInt);

   procedure Vertex_Array_Attrib_Binding is new Loader.Procedure_With_3_Params
     (GL_Vertex_Array_Attrib_Binding, UInt, Attributes.Attribute, Objects.Vertex_Arrays.Binding);

   procedure Vertex_Array_Binding_Divisor is new Loader.Procedure_With_3_Params
     (GL_Vertex_Array_Binding_Divisor, UInt, Objects.Vertex_Arrays.Binding, UInt);

   procedure Vertex_Array_Vertex_Buffer is new Loader.Procedure_With_5_Params
     (GL_Vertex_Array_Vertex_Buffer, UInt, Objects.Vertex_Arrays.Binding, UInt, Low_Level.IntPtr, Size);

   procedure Vertex_Array_Element_Buffer is new Loader.Procedure_With_2_Params
     (GL_Vertex_Array_Element_Buffer, UInt, UInt);

   procedure Enable_Vertex_Array_Attrib is new Loader.Procedure_With_2_Params
     (GL_Enable_Vertex_Array_Attrib, UInt, Attributes.Attribute);

   procedure Disable_Vertex_Array_Attrib is new Loader.Procedure_With_2_Params
     (GL_Disable_Vertex_Array_Attrib, UInt, Attributes.Attribute);

   -----------------------------------------------------------------------------
   --                           Renderbuffer objects                          --
   -----------------------------------------------------------------------------

   procedure Create_Renderbuffers is new Loader.Getter_With_2_Params
     (GL_Create_Renderbuffers, Size, UInt);

   procedure Delete_Renderbuffers is new Loader.Array_Proc_With_2_Params
     (GL_Delete_Buffers, Size, UInt, Low_Level.UInt_Array);

   procedure Named_Renderbuffer_Storage is new Loader.Procedure_With_4_Params
     (GL_Named_Renderbuffer_Storage, UInt,
      Pixels.Internal_Format, Size, Size);

   procedure Named_Renderbuffer_Storage_Multisample is new Loader.Procedure_With_5_Params
     (GL_Named_Renderbuffer_Storage_Multisample, UInt, Size,
      Pixels.Internal_Format, Size, Size);

   procedure Bind_Renderbuffer is new Loader.Procedure_With_2_Params
     (GL_Bind_Renderbuffer, Low_Level.Enums.Renderbuffer_Kind, UInt);

   procedure Get_Named_Renderbuffer_Parameter_Int is new Loader.Getter_With_3_Params
     (GL_Get_Named_Renderbuffer_Parameteriv, UInt,
      Enums.Getter.Renderbuffer_Parameter, Int);

   procedure Get_Named_Renderbuffer_Parameter_Internal_Format is new
     Loader.Getter_With_3_Params (GL_Get_Named_Renderbuffer_Parameteriv,
                                  UInt, Enums.Getter.Renderbuffer_Parameter,
                                  Pixels.Internal_Format);

   -----------------------------------------------------------------------------
   --                    Framebuffer objects and handling                     --
   -----------------------------------------------------------------------------

   procedure Read_Pixels (X, Y : Int; Width, Height : Size;
                          Format : Pixels.Format; Data_Type : Pixels.Data_Type;
                          Data : System.Address);
   pragma Import (Convention => StdCall, Entity => Read_Pixels,
                  External_Name => "glReadPixels");

   procedure Logic_Op (Value : Framebuffer.Logic_Op);
   pragma Import (Convention => StdCall, Entity => Logic_Op,
                  External_Name => "glLogicOp");

   procedure Create_Framebuffers is new Loader.Getter_With_2_Params
     (GL_Create_Framebuffers, Size, UInt);

   procedure Delete_Framebuffers is new Loader.Array_Proc_With_2_Params
     (GL_Delete_Framebuffers, Size, UInt, Low_Level.UInt_Array);

   procedure Bind_Framebuffer is new Loader.Procedure_With_2_Params
     (GL_Bind_Framebuffer, Low_Level.Enums.Framebuffer_Kind, UInt);

   procedure Named_Framebuffer_Draw_Buffer is new Loader.Procedure_With_2_Params
     (GL_Named_Framebuffer_Draw_Buffer, UInt, Buffers.Color_Buffer_Selector);

   procedure Named_Framebuffer_Draw_Buffers is new Loader.Procedure_With_3_Params
     (GL_Named_Framebuffer_Draw_Buffers, UInt, Size, Buffers.Color_Buffer_List);

   procedure Named_Framebuffer_Read_Buffer is new Loader.Procedure_With_2_Params
     (GL_Named_Framebuffer_Read_Buffer, UInt, Buffers.Color_Buffer_Selector);

   function Check_Named_Framebuffer_Status is new Loader.Function_With_1_Param
     (GL_Check_Named_Framebuffer_Status, UInt,
      Objects.Framebuffers.Framebuffer_Status);

   procedure Named_Framebuffer_Renderbuffer is new Loader.Procedure_With_4_Params
     (GL_Named_Framebuffer_Renderbuffer, UInt, Objects.Framebuffers.Attachment_Point,
      Low_Level.Enums.Renderbuffer_Kind, UInt);

   procedure Named_Framebuffer_Texture is new Loader.Procedure_With_4_Params
     (GL_Named_Framebuffer_Texture, UInt, Objects.Framebuffers.Attachment_Point,
      UInt, Objects.Textures.Mipmap_Level);

   procedure Named_Framebuffer_Texture_Layer is new Loader.Procedure_With_5_Params
     (GL_Named_Framebuffer_Texture_Layer, UInt, Objects.Framebuffers.Attachment_Point,
      UInt, Objects.Textures.Mipmap_Level, Int);

   procedure Blit_Named_Framebuffer is new Loader.Procedure_With_12_Params
     (GL_Blit_Named_Framebuffer, UInt, UInt, Int, Int, Int, Int, Int, Int, Int, Int,
      Low_Level.Bitfield, Objects.Textures.Magnifying_Function);

   procedure Invalidate_Named_Framebuffer_Data is new Loader.Array_Proc_With_3_Params
     (GL_Invalidate_Named_Framebuffer_Data, UInt, Size,
      Objects.Framebuffers.Attachment_Point,
      Objects.Framebuffers.Attachment_List);

   procedure Invalidate_Named_Framebuffer_Sub_Data is new Loader.Procedure_With_7_Params
     (GL_Invalidate_Named_Framebuffer_Sub_Data, UInt, Size,
      Objects.Framebuffers.Attachment_List, Int, Int, Size, Size);

   procedure Named_Framebuffer_Parameter_Size is new Loader.Procedure_With_3_Params
     (GL_Named_Framebuffer_Parameteri, UInt, Enums.Framebuffer_Param, Size);

   procedure Named_Framebuffer_Parameter_Bool is new Loader.Procedure_With_3_Params
     (GL_Named_Framebuffer_Parameteri, UInt, Enums.Framebuffer_Param, Low_Level.Bool);

   procedure Get_Named_Framebuffer_Parameter_Size is new Loader.Procedure_With_3_Params
     (GL_Get_Named_Framebuffer_Parameteriv, UInt, Enums.Framebuffer_Param, Low_Level.Size_Access);

   procedure Get_Named_Framebuffer_Parameter_Bool is new Loader.Procedure_With_3_Params
     (GL_Get_Named_Framebuffer_Parameteriv, UInt, Enums.Framebuffer_Param, Low_Level.Bool_Access);

   procedure Clear_Named_Framebuffer_Color is new Loader.Procedure_With_4_Params
     (GL_Clear_Named_Framebufferfv, UInt, Low_Level.Enums.Only_Color_Buffer,
      Buffers.Draw_Buffer_Index, Colors.Color);

   type Depth_Pointer is access constant Buffers.Depth;
   procedure Clear_Named_Framebuffer_Depth is new Loader.Procedure_With_4_Params
     (GL_Clear_Named_Framebufferfv, UInt, Low_Level.Enums.Only_Depth_Buffer,
      Zero, Depth_Pointer);

   type Stencil_Pointer is access constant Buffers.Stencil_Index;
   procedure Clear_Named_Framebuffer_Stencil is new Loader.Procedure_With_4_Params
     (GL_Clear_Named_Framebufferiv, UInt, Low_Level.Enums.Only_Stencil_Buffer,
      Zero, Stencil_Pointer);

   procedure Clear_Named_Framebuffer_Depth_Stencil is new Loader.Procedure_With_5_Params
     (GL_Clear_Named_Framebufferfi, UInt, Low_Level.Enums.Only_Depth_Stencil_Buffer,
      Zero, Buffers.Depth, Buffers.Stencil_Index);

   -----------------------------------------------------------------------------
   --                                 Shaders                                 --
   -----------------------------------------------------------------------------

   procedure Get_Shader_Param is new Loader.Getter_With_3_Params
     (GL_Get_Shaderiv, UInt, Enums.Shader_Param, Int);

   procedure Get_Shader_Type is new Loader.Getter_With_3_Params
     (GL_Get_Shaderiv, UInt, Enums.Shader_Param, Objects.Shaders.Shader_Type);

   function Create_Shader is new Loader.Function_With_1_Param
     (GL_Create_Shader, Objects.Shaders.Shader_Type, UInt);

   procedure Delete_Shader is new Loader.Procedure_With_1_Param
     (GL_Delete_Shader, UInt);

   procedure Shader_Source is new Loader.Procedure_With_4_Params
     (GL_Shader_Source, UInt, Size, Low_Level.CharPtr_Array,
      Low_Level.Int_Array);

   procedure Get_Shader_Source is
     new Loader.String_Getter_With_4_Params
     (GL_Get_Shader_Source, Size, UInt);

   procedure Compile_Shader is new Loader.Procedure_With_1_Param
     (GL_Compile_Shader, UInt);

   procedure Release_Shader_Compiler is new Loader.Procedure_Without_Params
     (GL_Release_Shader_Compiler);

   procedure Get_Shader_Info_Log is
     new Loader.String_Getter_With_4_Params
     (GL_Get_Shader_Info_Log, Size, UInt);

   function Create_Program is new Loader.Function_Without_Params
     (GL_Create_Program, UInt);

   procedure Delete_Program is new Loader.Procedure_With_1_Param
     (GL_Delete_Program, UInt);

   procedure Get_Program_Param is new Loader.Getter_With_3_Params
     (GL_Get_Programiv, UInt, Enums.Program_Param, Int);

   procedure Program_Parameter_Bool is new Loader.Procedure_With_3_Params
     (GL_Program_Parameteri, UInt, Enums.Program_Set_Param, Low_Level.Bool);

   procedure Attach_Shader is new Loader.Procedure_With_2_Params
     (GL_Attach_Shader, UInt, UInt);

   procedure Link_Program is new Loader.Procedure_With_1_Param
     (GL_Link_Program, UInt);

   procedure Get_Program_Info_Log is
     new Loader.String_Getter_With_4_Params
     (GL_Get_Program_Info_Log, Size, UInt);

   procedure Get_Program_Stage is new Loader.Getter_With_4_Params
     (GL_Get_Program_Stageiv, UInt, Objects.Shaders.Shader_Type,
      Enums.Program_Stage_Param, Size);

   procedure Uniform_Subroutines is new Loader.Procedure_With_3_Params
     (GL_Uniform_Subroutinesuiv, Objects.Shaders.Shader_Type, Size, UInt_Array);

   procedure Get_Uniform_Subroutine is new Loader.Getter_With_3_Params
     (GL_Get_Uniform_Subroutineuiv, Objects.Shaders.Shader_Type,
      Objects.Programs.Uniform_Location_Type, Objects.Programs.Subroutine_Index_Type);

   procedure Use_Program is new Loader.Procedure_With_1_Param
     (GL_Use_Program, UInt);

   procedure Validate_Program is new Loader.Procedure_With_1_Param
     (GL_Validate_Program, UInt);

   function Get_Uniform_Location is new Loader.Function_With_2_Params
     (GL_Get_Uniform_Location, UInt, C.char_array, Int);

   procedure Bind_Attrib_Location is new Loader.Procedure_With_3_Params
     (GL_Bind_Attrib_Location, UInt, Attributes.Attribute, C.char_array);

   function Get_Attrib_Location is new Loader.Function_With_2_Params
     (GL_Get_Attrib_Location, UInt, C.char_array, Int);

   function Get_Attached_Shaders is new Loader.Array_Getter_With_4_Params
     (GL_Get_Attached_Shaders, UInt, UInt, UInt_Array);

   -----------------------------------------------------------------------------
   --                    Program interfaces and resources                     --
   -----------------------------------------------------------------------------

   procedure Get_Program_Interface is new Loader.Getter_With_4_Params
     (GL_Get_Program_Interfaceiv, UInt, Enums.Program_Interface,
      Enums.Program_Interface_Param, Low_Level.Int_Array);

   function Get_Program_Resource_Index is new Loader.Function_With_3_Params
     (GL_Get_Program_Resource_Index, UInt, Enums.Program_Interface,
      C.char_array, UInt);

   procedure Get_Program_Resource_Name is new Loader.String_Getter_With_6_Params
     (GL_Get_Program_Resource_Name, Size, UInt, Enums.Program_Interface, UInt);

   function Get_Program_Resource is new Loader.Array_Getter_With_8_Params
     (GL_Get_Program_Resourceiv, UInt, Enums.Program_Interface,
      UInt, Size, Enums.Program_Resource_Array, Int, Int_Array);

   function Get_Program_Resource_Location is new Loader.Function_With_3_Params
     (GL_Get_Program_Resource_Location, UInt, Enums.Program_Interface,
      C.char_array, Int);

   function Get_Program_Resource_Location_Index is new Loader.Function_With_3_Params
     (GL_Get_Program_Resource_Location_Index, UInt, Enums.Program_Interface,
      C.char_array, Int);

   -----------------------------------------------------------------------------
   --                                Pipelines                                --
   -----------------------------------------------------------------------------

   procedure Use_Program_Stages is new Loader.Procedure_With_3_Params
     (GL_Use_Program_Stages, UInt, Objects.Shaders.Shader_Type, UInt);

   procedure Create_Program_Pipelines is new Loader.Getter_With_2_Params
     (GL_Create_Program_Pipelines, Size, UInt);

   procedure Delete_Program_Pipelines is new Loader.Array_Proc_With_2_Params
     (GL_Delete_Program_Pipelines, Size, UInt, Low_Level.UInt_Array);

   procedure Bind_Program_Pipeline is new Loader.Procedure_With_1_Param
     (GL_Bind_Program_Pipeline, UInt);

   procedure Active_Shader_Program is new Loader.Procedure_With_2_Params
     (GL_Active_Shader_Program, UInt, UInt);

   procedure Get_Program_Pipeline_Param is new Loader.Getter_With_3_Params
     (GL_Get_Program_Pipelineiv, UInt, Enums.Program_Pipeline_Param, Int);

   procedure Get_Program_Pipeline_Info_Log is new Loader.String_Getter_With_4_Params
     (GL_Get_Program_Pipeline_Info_Log, Size, UInt);

   procedure Validate_Program_Pipeline is new Loader.Procedure_With_1_Param
     (GL_Validate_Program_Pipeline, UInt);

   function Create_Shader_Program is new Loader.Function_With_3_Params
     (GL_Create_Shader_Programv, Objects.Shaders.Shader_Type, Size,
      Low_Level.CharPtr_Array, UInt);

   -----------------------------------------------------------------------------
   --                                 Queries                                 --
   -----------------------------------------------------------------------------

   procedure Create_Queries is new Loader.Getter_With_3_Params
     (GL_Create_Queries, Objects.Queries.Async_Query_Type, Size, UInt);

   procedure Delete_Queries is new Loader.Array_Proc_With_2_Params
     (GL_Delete_Queries, Size, UInt, Low_Level.UInt_Array);

   procedure Begin_Query_Indexed is new Loader.Procedure_With_3_Params
     (GL_Begin_Query_Indexed, Objects.Queries.Async_Query_Type, UInt, UInt);

   procedure End_Query_Indexed is new Loader.Procedure_With_2_Params
     (GL_End_Query_Indexed, Objects.Queries.Async_Query_Type, UInt);

   procedure Begin_Conditional_Render is new Loader.Procedure_With_2_Params
     (GL_Begin_Conditional_Render, UInt, Objects.Queries.Query_Mode);

   procedure End_Conditional_Render is new Loader.Procedure_Without_Params
     (GL_End_Conditional_Render);

   procedure Query_Counter is new Loader.Procedure_With_2_Params
     (GL_Query_Counter, UInt, Objects.Queries.Timestamp_Query_Type);

   procedure Get_Query_Indexed_Param is new Loader.Getter_With_4_Params
     (GL_Get_Query_Indexed, Objects.Queries.Query_Type, UInt, Objects.Queries.Target_Param, Int);

   procedure Get_Query_Object_Int is new Loader.Getter_With_3_Params
     (GL_Get_Query_Objectiv, UInt, Objects.Queries.Query_Param, Int);

   procedure Get_Query_Object_UInt is new Loader.Getter_With_3_Params
     (GL_Get_Query_Objectuiv, UInt, Objects.Queries.Query_Param, UInt);

   -----------------------------------------------------------------------------
   --                                Samplers                                 --
   -----------------------------------------------------------------------------

   procedure Create_Samplers is new Loader.Getter_With_2_Params
     (GL_Create_Samplers, Size, UInt);

   procedure Delete_Samplers is new Loader.Array_Proc_With_2_Params
     (GL_Delete_Samplers, Size, UInt, Low_Level.UInt_Array);

   procedure Bind_Sampler is new Loader.Procedure_With_2_Params
     (GL_Bind_Sampler, UInt, UInt);

   procedure Bind_Samplers is new Loader.Array_Proc_With_3_Params
     (GL_Bind_Samplers, UInt, Size, UInt, Low_Level.UInt_Array);

   procedure Sampler_Parameter_Float is new Loader.Procedure_With_3_Params
     (GL_Sampler_Parameterf, UInt, Enums.Textures.Parameter, Single);

   procedure Sampler_Parameter_Floats is new Loader.Procedure_With_3_Params
     (GL_Sampler_Parameterfv, UInt, Enums.Textures.Parameter, Low_Level.Single_Array);

   procedure Get_Sampler_Parameter_Floats is new Loader.Getter_With_3_Params
     (GL_Get_Sampler_Parameterfv, UInt, Enums.Textures.Parameter, Low_Level.Single_Array);

   procedure Sampler_Parameter_Minifying_Function is new Loader.Procedure_With_3_Params
     (GL_Sampler_Parameteri, UInt, Enums.Textures.Parameter, Objects.Textures.Minifying_Function);

   procedure Sampler_Parameter_Magnifying_Function is new Loader.Procedure_With_3_Params
     (GL_Sampler_Parameteri, UInt, Enums.Textures.Parameter, Objects.Textures.Magnifying_Function);

   procedure Sampler_Parameter_Wrapping_Mode is new Loader.Procedure_With_3_Params
     (GL_Sampler_Parameteri, UInt, Enums.Textures.Parameter, Objects.Textures.Wrapping_Mode);

   procedure Sampler_Parameter_Compare_Kind is new Loader.Procedure_With_3_Params
     (GL_Sampler_Parameteri, UInt, Enums.Textures.Parameter, Enums.Textures.Compare_Kind);

   procedure Sampler_Parameter_Compare_Function is new Loader.Procedure_With_3_Params
     (GL_Sampler_Parameteri, UInt, Enums.Textures.Parameter, Compare_Function);

   procedure Get_Sampler_Parameter_Minifying_Function is new Loader.Getter_With_3_Params
     (GL_Get_Sampler_Parameteriv, UInt, Enums.Textures.Parameter, Objects.Textures.Minifying_Function);

   procedure Get_Sampler_Parameter_Magnifying_Function is new Loader.Getter_With_3_Params
     (GL_Get_Sampler_Parameteriv, UInt, Enums.Textures.Parameter, Objects.Textures.Magnifying_Function);

   procedure Get_Sampler_Parameter_Wrapping_Mode is new Loader.Getter_With_3_Params
     (GL_Get_Sampler_Parameteriv, UInt, Enums.Textures.Parameter, Objects.Textures.Wrapping_Mode);

   procedure Get_Sampler_Parameter_Compare_Kind is new Loader.Getter_With_3_Params
     (GL_Get_Sampler_Parameteriv, UInt, Enums.Textures.Parameter, Enums.Textures.Compare_Kind);

   procedure Get_Sampler_Parameter_Compare_Function is new Loader.Getter_With_3_Params
     (GL_Get_Sampler_Parameteriv, UInt, Enums.Textures.Parameter, Compare_Function);

   -----------------------------------------------------------------------------
   --                           Transform feedback                            --
   -----------------------------------------------------------------------------

   procedure Transform_Feedback_Varyings is new Loader.Procedure_With_4_Params
     (GL_Transform_Feedback_Varyings, UInt, Size, Low_Level.CharPtr_Array,
      Objects.Transform_Feedbacks.Outputs_Format);

   procedure Create_Transform_Feedbacks is new Loader.Getter_With_2_Params
     (GL_Create_Transform_Feedbacks, Size, UInt);

   procedure Delete_Transform_Feedbacks is new Loader.Array_Proc_With_2_Params
     (GL_Delete_Transform_Feedbacks, Size, UInt, Low_Level.UInt_Array);

   procedure Begin_Transform_Feedback is new Loader.Procedure_With_1_Param
     (GL_Begin_Transform_Feedback, Connection_Mode);

   procedure End_Transform_Feedback is new Loader.Procedure_Without_Params
     (GL_End_Transform_Feedback);

   procedure Pause_Transform_Feedback is new Loader.Procedure_Without_Params
     (GL_Pause_Transform_Feedback);

   procedure Resume_Transform_Feedback is new Loader.Procedure_Without_Params
     (GL_Resume_Transform_Feedback);

   procedure Bind_Transform_Feedback is new Loader.Procedure_With_2_Params
     (GL_Bind_Transform_Feedback, Low_Level.Enums.Transform_Feedback_Kind, UInt);

   procedure Transform_Feedback_Buffer_Base is new Loader.Procedure_With_3_Params
     (GL_Transform_Feedback_Buffer_Base, UInt, UInt, UInt);

   procedure Draw_Transform_Feedback is new Loader.Procedure_With_2_Params
     (GL_Draw_Transform_Feedback, Connection_Mode, UInt);

   procedure Draw_Transform_Feedback_Instanced is new Loader.Procedure_With_3_Params
     (GL_Draw_Transform_Feedback_Instanced, Connection_Mode, UInt, Size);

   procedure Draw_Transform_Feedback_Stream is new Loader.Procedure_With_3_Params
     (GL_Draw_Transform_Feedback_Stream, Connection_Mode, UInt, UInt);

   procedure Draw_Transform_Feedback_Stream_Instanced is new Loader.Procedure_With_4_Params
     (GL_Draw_Transform_Feedback_Stream_Instanced, Connection_Mode, UInt, UInt, Size);

   -----------------------------------------------------------------------------
   --                                Barriers                                 --
   -----------------------------------------------------------------------------

   procedure Texture_Barrier is new Loader.Procedure_Without_Params
     (GL_Texture_Barrier);

   procedure Memory_Barrier is new Loader.Procedure_With_1_Param
     (GL_Memory_Barrier, Low_Level.Bitfield);

   procedure Memory_Barrier_By_Region is new Loader.Procedure_With_1_Param
     (GL_Memory_Barrier_By_Region, Low_Level.Bitfield);

   -----------------------------------------------------------------------------
   --                  Transformation to window coordinates                   --
   -----------------------------------------------------------------------------

   procedure Depth_Range (Near, Far : Double);
   pragma Import (Convention => StdCall, Entity => Depth_Range,
                  External_Name => "glDepthRange");

   procedure Viewport (X, Y : Int; Width, Height : Size);
   pragma Import (Convention => StdCall, Entity => Viewport,
                  External_Name => "glViewport");

end GL.API;
