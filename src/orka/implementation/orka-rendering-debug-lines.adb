--  SPDX-License-Identifier: Apache-2.0
--
--  Copyright (c) 2019 onox <denkpadje@gmail.com>
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

with GL.Buffers;
with GL.Types;

with Orka.Rendering.Drawing;
with Orka.Rendering.Programs.Modules;

package body Orka.Rendering.Debug.Lines is

   function Create_Line
     (Location : Resources.Locations.Location_Ptr) return Line
   is
      use Rendering.Programs;
   begin
      return Result : Line :=
        (Program => Create_Program (Modules.Create_Module
           (Location, VS => "debug/line.vert", FS => "debug/line.frag")),
         others  => <>)
      do
         Result.Uniform_Visible  := Result.Program.Uniform ("visible");

         Result.Uniform_View     := Result.Program.Uniform ("view");
         Result.Uniform_Proj     := Result.Program.Uniform ("proj");
      end return;
   end Create_Line;

   procedure Render
     (Object     : in out Line;
      View, Proj : Transforms.Matrix4;
      Transforms, Colors, Points : Rendering.Buffers.Bindable_Buffer'Class)
   is
      use all type GL.Types.Compare_Function;
      use all type Rendering.Buffers.Indexed_Buffer_Target;

      Reverse_Function : constant array (GL.Types.Compare_Function) of GL.Types.Compare_Function :=
        (Never     => Always,
         Always    => Never,
         Less      => GEqual,
         Greater   => LEqual,
         LEqual    => Greater,
         GEqual    => Less,
         Equal     => Not_Equal,
         Not_Equal => Equal);

      Original_Function : constant GL.Types.Compare_Function := GL.Buffers.Depth_Function;
      Original_Mask     : constant Boolean                   := GL.Buffers.Depth_Mask;
   begin
      Object.Uniform_View.Set_Matrix (View);
      Object.Uniform_Proj.Set_Matrix (Proj);

      Object.Program.Use_Program;

      Transforms.Bind (Shader_Storage, 0);
      Colors.Bind (Shader_Storage, 1);
      Points.Bind (Shader_Storage, 2);

      --  Visible part of lines
      Object.Uniform_Visible.Set_Boolean (True);
      Orka.Rendering.Drawing.Draw (GL.Types.Lines, 0, 2, Instances => Points.Length / 2);

      --  Hidden part of lines
      GL.Buffers.Set_Depth_Function (Reverse_Function (Original_Function));
      GL.Buffers.Set_Depth_Mask (Enabled => False);

      Object.Uniform_Visible.Set_Boolean (False);
      Orka.Rendering.Drawing.Draw (GL.Types.Lines, 0, 2, Instances => Points.Length / 2);

      GL.Buffers.Set_Depth_Function (Original_Function);
      GL.Buffers.Set_Depth_Mask (Enabled => Original_Mask);
   end Render;

end Orka.Rendering.Debug.Lines;
