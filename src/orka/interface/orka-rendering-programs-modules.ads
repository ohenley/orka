--  Copyright (c) 2016 onox <denkpadje@gmail.com>
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

with Ada.Containers.Indefinite_Holders;

with GL.Objects.Shaders;

package Orka.Rendering.Programs.Modules is
   pragma Preelaborate;

   type Module is tagged private;

   type Module_Array is array (Positive range <>) of aliased Module;

   function Create_Module (VS, TCS, TES, GS, FS : String := "")
     return Module;

   procedure Attach_Shaders (Modules : Module_Array; Program : Programs.Program);

   procedure Detach_Shaders (Modules : Module_Array; Program : Programs.Program);

   Shader_Compile_Error : exception;

   subtype Non_Compute_Shader_Type is GL.Objects.Shaders.Shader_Type
     range GL.Objects.Shaders.Fragment_Shader .. GL.Objects.Shaders.Tess_Control_Shader;

private

   use type GL.Objects.Shaders.Shader;

   package Shader_Holder is new Ada.Containers.Indefinite_Holders
     (Element_Type => GL.Objects.Shaders.Shader);

   type Shader_Array is array (Non_Compute_Shader_Type) of Shader_Holder.Holder;

   type Module is tagged record
      Shaders : Shader_Array;
   end record;

end Orka.Rendering.Programs.Modules;
