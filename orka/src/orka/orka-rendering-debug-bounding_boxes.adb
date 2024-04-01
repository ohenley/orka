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

with GL.Types;

with Orka.Rendering.Drawing;
with Orka.Rendering.Programs.Modules;
with Orka.Rendering.States;

package body Orka.Rendering.Debug.Bounding_Boxes is

   function Create_Bounding_Box
     (Location : Resources.Locations.Location_Ptr;
      Color    : Transforms.Vector4 := [1.0, 1.0, 1.0, 1.0]) return Bounding_Box
   is
      use Rendering.Programs;
   begin
      return Result : Bounding_Box :=
        (Program => Create_Program (Modules.Create_Module
           (Location, VS => "debug/bbox.vert", FS => "debug/line.frag")),
         others  => <>)
      do
         Result.Program.Uniform ("color").Set_Vector (Color);

         Result.Uniform_Visible  := Result.Program.Uniform ("visible");
         Result.Uniform_View     := Result.Program.Uniform ("view");
         Result.Uniform_Proj     := Result.Program.Uniform ("proj");
      end return;
   end Create_Bounding_Box;

   procedure Set_Data
     (Object     : in out Bounding_Box;
      View, Proj : Transforms.Matrix4;
      Transforms, Bounds : Rendering.Buffers.Buffer) is
   begin
      Object.Uniform_View.Set_Matrix (View);
      Object.Uniform_Proj.Set_Matrix (Proj);

      Object.Transforms := Transforms;
      Object.Bounds := Bounds;
   end Set_Data;

   procedure Render (Object : Bounding_Box) is
      use all type Rendering.Buffers.Indexed_Buffer_Target;
   begin
      Object.Transforms.Bind (Shader_Storage, 0);
      Object.Bounds.Bind (Shader_Storage, 1);

      Orka.Rendering.Drawing.Draw (GL.Types.Lines, 0, 2 * 12, Instances => Object.Transforms.Length);
   end Render;

   overriding procedure Run (Object : BBox_Hidden_Program_Callback) is
   begin
      Object.Data.Program.Use_Program;
      Object.Data.Uniform_Visible.Set_Boolean (False);
      Object.Data.Render;
   end Run;

   overriding procedure Run (Object : BBox_Visible_Program_Callback) is
   begin
      Object.Data.Program.Use_Program;
      Object.Data.Uniform_Visible.Set_Boolean (True);
      Object.Data.Render;
   end Run;

   function Create_Graph
     (Object       : Bounding_Box;
      Color, Depth : Orka.Rendering.Textures.Texture_Description) return Orka.Frame_Graphs.Frame_Graph
   is
      use Orka.Frame_Graphs;

      Graph : aliased Orka.Frame_Graphs.Frame_Graph
        (Maximum_Passes    => 2,   --  1 pass for hidden lines and 1 pass for visible lines
         Maximum_Handles   => 4,   --  Reading/Writing 2x color + depth buffers
         Maximum_Resources => 6);  --  3 resources for color buffer and 2 for depth buffer
      --  RC1 --> PV --> RC2 --> PH --> RC3;
      --  RD1 -/    \--> RD2 -/
      --                       \------> [RD2]

      State_Hidden  : constant Orka.Rendering.States.State := (Depth_Func => GL.Types.LEqual, others => <>);
      State_Visible : constant Orka.Rendering.States.State := (State_Hidden with delta Depth_Func => GL.Types.Greater);

      Pass_Hidden  : Render_Pass'Class := Graph.Add_Pass ("bbox-hidden", State_Hidden, Object.Callback_Hidden'Unchecked_Access);
      Pass_Visible : Render_Pass'Class := Graph.Add_Pass ("bbox-visible", State_Visible, Object.Callback_Visible'Unchecked_Access);

      Resource_Color_V1 : constant Orka.Frame_Graphs.Resource :=
        (Name        => +"bbox-color",
         Description => Color,
         others      => <>);

      Resource_Depth_V1 : constant Orka.Frame_Graphs.Resource :=
        (Name        => +"bbox-depth",
         Description => Depth,
         others      => <>);

      Resource_Color_V2 : constant Orka.Frame_Graphs.Resource :=
        Pass_Visible.Add_Input_Output (Resource_Color_V1, Framebuffer_Attachment, 0);
      Resource_Depth_V2 : constant Orka.Frame_Graphs.Resource :=
        Pass_Visible.Add_Input_Output (Resource_Depth_V1, Framebuffer_Attachment, 1);

      Resource_Color_V3 : constant Orka.Frame_Graphs.Resource :=
        Pass_Hidden.Add_Input_Output (Resource_Color_V2, Framebuffer_Attachment, 0);
   begin
      Pass_Hidden.Add_Input (Resource_Depth_V2, Framebuffer_Attachment, 1);

      Graph.Import ([Resource_Color_V1, Resource_Depth_V1]);
      Graph.Export ([Resource_Color_V3, Resource_Depth_V2]);

      return Graph;
   end Create_Graph;

end Orka.Rendering.Debug.Bounding_Boxes;
