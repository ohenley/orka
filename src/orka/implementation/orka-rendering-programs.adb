--  Copyright (c) 2015 onox <denkpadje@gmail.com>
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

with Orka.Rendering.Programs.Modules;
with Orka.Rendering.Programs.Uniforms;

package body Orka.Rendering.Programs is

   package Program_Holder is new Ada.Containers.Indefinite_Holders
     (Element_Type => Program);

   Current_Program : Program_Holder.Holder;

   function Create_Program (Modules   : Programs.Modules.Module_Array;
                            Separable : Boolean := False) return Program is
      use type GL.Types.Int;
   begin
      return Result : Program do
         Result.GL_Program.Set_Separable (Separable);

         --  Attach all shaders to the program before linking
         Programs.Modules.Attach_Shaders (Modules, Result);

         Result.GL_Program.Link;
         Programs.Modules.Detach_Shaders (Modules, Result);

         if not Result.GL_Program.Link_Status then
            raise Program_Link_Error with Result.GL_Program.Info_Log;
         end if;

         --  Construct arrays of subroutine indices per shader kind
         Result.Has_Subroutines := False;
         Result.Subroutines_Modified := False;
         for Shader_Kind in Programs.Modules.Non_Compute_Shader_Type loop
            declare
               Locations : constant GL.Types.Size
                 := Result.GL_Program.Subroutine_Uniform_Locations (Shader_Kind);
               subtype Indices_Array is GL.Types.UInt_Array (0 .. Locations - 1);
            begin
               if Indices_Array'Length > 0 then
                  Result.Has_Subroutines := True;
               end if;
               Result.Subroutines (Shader_Kind)
                 := Subroutines_Holder.To_Holder (Indices_Array'(others => GL.Types.UInt'Last));
            end;
         end loop;
      end return;
   end Create_Program;

   function Create_Program (Module    : Programs.Modules.Module;
                            Separable : Boolean := False) return Program is
   begin
      return Create_Program (Modules.Module_Array'(1 => Module), Separable);
   end Create_Program;

   function GL_Program (Object : Program) return GL.Objects.Programs.Program
     is (Object.GL_Program);

   function Has_Subroutines (Object : Program) return Boolean
     is (Object.Has_Subroutines);

   procedure Use_Subroutines (Object : in out Program) is
   begin
      for Shader_Kind in Programs.Modules.Non_Compute_Shader_Type loop
         declare
            Indices : GL.Types.UInt_Array renames Object.Subroutines (Shader_Kind).Element;
         begin
            if Indices'Length > 0 then
               GL.Objects.Programs.Set_Uniform_Subroutines (Shader_Kind, Indices);
            end if;
         end;
      end loop;
      Object.Subroutines_Modified := False;
   end Use_Subroutines;

   procedure Use_Program (Object : in out Program) is
   begin
      if Current_Program.Is_Empty or else Object /= Current_Program.Element then
         Object.GL_Program.Use_Program;
         Current_Program.Replace_Element (Object);
         if Object.Has_Subroutines then
            Object.Use_Subroutines;
         end if;
      elsif Object.Subroutines_Modified then
         Object.Use_Subroutines;
      end if;
   end Use_Program;

   function Attribute_Location (Object : Program; Name : String)
      return GL.Attributes.Attribute is
   begin
      return Object.GL_Program.Attrib_Location (Name);
   end Attribute_Location;

   procedure Set_Subroutine_Function
     (Object   : in out Program;
      Shader   : GL.Objects.Shaders.Shader_Type;
      Location : Uniform_Location;
      Index    : Subroutine_Index)
   is
      procedure Set_Index (Indices : in out GL.Types.UInt_Array) is
      begin
         Indices (Location) := Index;
      end Set_Index;
   begin
      Object.Subroutines (Shader).Update_Element (Set_Index'Access);
      Object.Subroutines_Modified := True;
   end Set_Subroutine_Function;

   function Uniform_Sampler (Object : Program; Name : String)
     return Uniforms.Uniform_Sampler is
   begin
      return Uniforms.Create_Uniform_Sampler (Object, Name);
   end Uniform_Sampler;

   function Uniform_Image (Object : Program; Name : String)
     return Uniforms.Uniform_Image is
   begin
      return Uniforms.Create_Uniform_Image (Object, Name);
   end Uniform_Image;

   function Uniform_Subroutine
     (Object : in out Program;
      Shader : GL.Objects.Shaders.Shader_Type;
      Name   : String) return Uniforms.Uniform_Subroutine is
   begin
      return Uniforms.Create_Uniform_Subroutine (Object, Shader, Name);
   end Uniform_Subroutine;

   function Uniform_Block (Object : Program; Name : String)
     return Uniforms.Uniform_Block is
   begin
      return Uniforms.Create_Uniform_Block (Object, Name);
   end Uniform_Block;

   function Uniform (Object : Program; Name : String)
     return Uniforms.Uniform is
   begin
      return Uniforms.Create_Uniform_Variable (Object, Name);
   end Uniform;

end Orka.Rendering.Programs;
