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

with GL.Attributes;
with GL.Buffers;
with GL.Objects.Buffers;
with GL.Types.Colors;

with Orka.Buffers;
with Orka.Meshes.Buffers;
with Orka.Programs.Modules;

with GL_Test.Display_Backend;

procedure Orka_Test.Test_2_Two_Triangles is
   use GL.Types;
   use GL.Objects.Buffers;

   use Orka.Meshes;
   use Orka.Programs;

   function Load_Mesh_1 (Program : Orka.Programs.Program) return Mesh is
      VBO_1, VBO_2 : Orka.Buffers.Buffer := Orka.Buffers.Create_Buffer (Static_Draw);

      Vertices : constant Single_Array
        := (-0.3,  0.5, -1.0,
            -0.8, -0.5, -1.0,
             0.2, -0.5, -1.0);

      Color_Vertices : constant Colors.Basic_Color_Array
        := ((1.0, 0.0, 0.0),
            (0.0, 1.0, 0.0),
            (0.0, 0.0, 1.0));
   begin
      --  Upload vertices and color data to VBO's
      VBO_1.Set_Data (Vertices);
      VBO_2.Set_Data (Color_Vertices);

      --  Create mesh and its attributes
      return Result : Mesh := Orka.Meshes.Create_Mesh (Triangles) do
         declare
            Attributes_Pos : Buffers.Attribute_Buffer := Result.Add_Attribute_Buffer (Single_Type);
            Attributes_Col : Buffers.Attribute_Buffer := Result.Add_Attribute_Buffer (Single_Type);
         begin
            Attributes_Pos.Add_Attribute (Program.Attribute_Location ("in_Position"), 3);
            Attributes_Pos.Set_Buffer (VBO_1);

            Attributes_Col.Add_Attribute (Program.Attribute_Location ("in_Color"), 3);
            Attributes_Col.Set_Buffer (VBO_2);
         end;
      end return;
   end Load_Mesh_1;

   function Load_Mesh_2 (Program : Orka.Programs.Program) return Mesh is
      VBO_3 : Orka.Buffers.Buffer := Orka.Buffers.Create_Buffer (Static_Draw);

      Vertices : constant Single_Array
        := (-0.2,  0.5, -1.0,
             0.3, -0.5, -1.0,
             0.8,  0.5, -1.0);
   begin
      --  Upload vertices data to VBO
      VBO_3.Set_Data (Vertices);

      --  Create mesh and its attributes
      return Result : Mesh := Orka.Meshes.Create_Mesh (Triangles) do
         declare
            Attributes_Pos : Buffers.Attribute_Buffer := Result.Add_Attribute_Buffer (Single_Type);
         begin
            Attributes_Pos.Add_Attribute (Program.Attribute_Location ("in_Position"), 3);
            Attributes_Pos.Set_Buffer (VBO_3);
         end;
      end return;
   end Load_Mesh_2;
begin
   GL_Test.Display_Backend.Init (Major => 3, Minor => 2);
   GL_Test.Display_Backend.Set_Not_Resizable;
   GL_Test.Display_Backend.Open_Window (Width => 500, Height => 500);

   declare
      use GL.Buffers;

      Program_1 : constant Program := Orka.Programs.Create_Program (Modules.Create_Module
        (VS => "../test/gl/shaders/opengl3.vert",
         FS => "../test/gl/shaders/opengl3.frag"));

      Triangle_1 : constant Mesh := Load_Mesh_1 (Program_1);
      Triangle_2 : constant Mesh := Load_Mesh_2 (Program_1);
   begin
      Program_1.Use_Program;

      while not GL_Test.Display_Backend.Get_Window.Should_Close loop
         Clear (Buffer_Bits'(Color => True, Depth => True, others => False));

         Triangle_1.Draw (0, 3);
         GL.Attributes.Set_Single (Program_1.Attribute_Location ("in_Color"), 1.0, 0.0, 0.0);
         Triangle_2.Draw (0, 3);

         GL_Test.Display_Backend.Swap_Buffers_And_Poll_Events;
      end loop;
   end;

   GL_Test.Display_Backend.Shutdown;
end Orka_Test.Test_2_Two_Triangles;
