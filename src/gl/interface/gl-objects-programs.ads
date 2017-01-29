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

with GL.Attributes;
with GL.Objects.Shaders.Lists;
with GL.Objects.Transform_Feedbacks;
limited with GL.Objects.Programs.Uniforms;

package GL.Objects.Programs is
   pragma Preelaborate;

   type Program is new GL_Object with private;

   procedure Attach (Subject : Program; Shader : Shaders.Shader);

   procedure Link (Subject : Program);

   function Link_Status (Subject : Program) return Boolean;

   function Info_Log (Subject : Program) return String;

   procedure Use_Program (Subject : Program);
   --  Use the shaders of the given program durting rendering
   --
   --  If you have subroutines in in some of its shaders, you must
   --  subsequently call Set_Uniform_Subroutines, because the subroutine
   --  state is completely lost after having called Use_Program.

   procedure Set_Binary_Retrievable (Subject : Program; Retrievable : Boolean);
   function Binary_Retrievable (Subject : Program) return Boolean;

   procedure Set_Separable (Subject : Program; Separable : Boolean);
   function Separable (Subject : Program) return Boolean;

   procedure Set_Feedback_Outputs (Object : Program; Names : String_Array;
                                   Format : Transform_Feedbacks.Outputs_Format);

   function Uniform_Location (Subject : Program; Name : String)
     return Programs.Uniforms.Uniform;

   procedure Bind_Attrib_Location (Subject : Program;
                                   Index : Attributes.Attribute;
                                   Name : String);

   function Attrib_Location (Subject : Program; Name : String)
     return Attributes.Attribute;

   function Attached_Shaders (Object : Program) return Shaders.Lists.List;

   overriding
   procedure Initialize_Id (Object : in out Program);

   procedure Initialize_Id (Object : in out Program; Kind : Shaders.Shader_Type; Source : String);

   overriding
   procedure Delete_Id (Object : in out Program);

   overriding
   function Identifier (Object : Program) return Types.Debug.Identifier is
     (Types.Debug.Program);

   Attribute_Inactive_Error : exception;
   Uniform_Inactive_Error   : exception;

   -----------------------------------------------------------------------------
   --                               Subroutines                               --
   -----------------------------------------------------------------------------

   subtype Subroutine_Index_Type is UInt;
   subtype Uniform_Location_Type is Int range -1 .. Int'Last;

   type Subroutine_Index_Array is array (Size range <>) of Subroutine_Index_Type;

   Invalid_Index : constant Subroutine_Index_Type;

   function Active_Subroutines (Object : Program; Shader : Shaders.Shader_Type)
     return Size;
   --  Return total number of subroutine functions

   function Active_Subroutine_Uniforms (Object : Program; Shader : Shaders.Shader_Type)
     return Size;
   --  Return total number of subroutine uniforms indices
   --
   --  A subroutine uniform that is an array has multiple locations, but
   --  has one index.

   function Active_Subroutine_Max_Length (Object : Program; Shader : Shaders.Shader_Type)
     return Size;
   --  Return the largest name of all subroutine functions used by the
   --  given stage

   function Active_Subroutine_Uniform_Max_Length (Object : Program; Shader : Shaders.Shader_Type)
     return Size;
   --  Return the largest name of all subroutine uniforms used in the
   --  given stage

   function Subroutine_Name (Object : Program; Shader : Shaders.Shader_Type;
                             Index  : Subroutine_Index_Type) return String;
   --  Return the name of the subroutine function given its index

   function Subroutine_Uniform_Name (Object : Program; Shader : Shaders.Shader_Type;
                                     Index  : Subroutine_Index_Type) return String;
   --  Return the name of the subroutine uniform given its index

   function Subroutine_Index (Object : Program; Shader : Shaders.Shader_Type; Name : String)
     return Subroutine_Index_Type;
   --  Return the index of the subroutine function given its name

   function Subroutine_Uniform_Location (Object : Program;
                                         Shader : Shaders.Shader_Type;
                                         Name   : String)
     return Uniform_Location_Type;
   --  Return the location of a subroutine uniform
   --
   --  The location of the uniform is used when setting the subroutine
   --  function (using the index of the function) that should be used
   --  during rendering.

   --  TODO GetActiveSubroutineUniformiv: get info about a uniform given its index:
   --   * Num_Compatible_Subroutines (number of subroutine functions for the uniform)
   --   * Compatible_Subroutines (list of indices of the subroutine functions)
   --   * Uniform_Size (number of array elements if subroutine uniform is in an array)
   --   * Uniform_Name_Length (length of uniform's name)

   function Subroutine_Indices_Uniform (Object : Program;
                                        Shader : Shaders.Shader_Type;
                                        Index  : Subroutine_Index_Type)
     return Subroutine_Index_Array;
   --  Return the indices of compatible subroutines for the given subroutine uniform

   function Active_Subroutine_Uniform_Locations (Object : Program; Shader : Shaders.Shader_Type)
     return Size;
   --  Return number of active subroutine uniform locations
   --
   --  All locations between 0 .. Active_Subroutine_Uniform_Locations'Result - 1
   --  are active locations. A subroutine uniform that is an array has one
   --  index, but multiple locations.
   --
   --  This function is used to determine length of array given to
   --  Set_Uniform_Subroutines.

   procedure Set_Uniform_Subroutines (Shader : Shaders.Shader_Type; Indices : UInt_Array)
     with Pre => Indices'First = 0;
   --  Use the given indices of the subroutine functions to set the active
   --  subroutine uniforms
   --
   --  Size of Indices must be equal to Active_Subroutine_Uniform_Locations.
   --  You must call this program after Programs.Use_Program, Pipelines.Bind,
   --  or Pipelines.Use_Program_Stages.
   --
   --  This procedure can be used as follows:
   --
   --  1. Use Active_Subroutine_Uniform_Locations to create a new UInt_Array
   --     with the correct length.
   --  2. Call Subroutine_Index to get the index of a subroutine function.
   --     This will be a *value* in the array.
   --  3. Call Subroutine_Uniform_Location to get the location of a subroutine
   --     uniform. This will be a *key* in the array.
   --  4. Assign the value (function index) to the key (uniform location) in
   --     the array.
   --  5. Repeat steps 2 to 4 for all active subroutine uniforms.

   function Uniform_Subroutine (Shader : Shaders.Shader_Type; Location : Uniform_Location_Type)
     return Subroutine_Index_Type;
   --  Return the current index (subroutine function) of a subroutine uniform
   --
   --  Use Subroutine_Name to get the name given its index returned by
   --  this function.

private
   Invalid_Index : constant Subroutine_Index_Type := 16#FFFFFFFF#;
   
   type Program is new GL_Object with null record;
end GL.Objects.Programs;
