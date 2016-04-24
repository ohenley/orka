--------------------------------------------------------------------------------
-- Copyright (c) 2016 onox <denkpadje@gmail.com>
--
-- Permission to use, copy, modify, and/or distribute this software for any
-- purpose with or without fee is hereby granted, provided that the above
-- copyright notice and this permission notice appear in all copies.
--
-- THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
-- WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
-- MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
-- ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
-- WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
-- ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
-- OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
--------------------------------------------------------------------------------

with Ada.Text_IO;

with GL.Attributes;
with GL.Buffers;
with GL.Files;
with GL.Objects.Buffers;
with GL.Objects.Shaders;
with GL.Objects.Programs.Uniforms;
with GL.Objects.Vertex_Arrays;
with GL.Types;
with GL.Transforms;
with GL.Toggles;

with GL_Test.Display_Backend;

procedure GL_Test.Instancing is
   use GL.Buffers;
   use GL.Objects.Vertex_Arrays;
   use GL.Types;
   use GL.Transforms;

   procedure Load_Vectors is new GL.Objects.Buffers.Load_To_Buffer
     (Single_Pointers);
   procedure Load_Indices is new GL.Objects.Buffers.Load_To_Buffer
     (UInt_Pointers);
   procedure Load_Matrices is new GL.Objects.Buffers.Load_To_Buffer
     (Singles.Matrix4_Pointers);

   Instances_Dimension : constant := 40;
   Space_Between_Cubes : constant := 0.2;

   Matrices : Singles.Matrix4_Array (1 .. Instances_Dimension**3) := (others => Singles.Identity4);

   Indices : constant UInt_Array
     := (0, 1, 2,  --  Front
         2, 3, 0,
         0, 1, 5,  --  Top
         5, 0, 4,
         4, 5, 6,  --  Back
         6, 7, 4,
         1, 5, 6,  --  Right
         6, 2, 1,
         0, 4, 7,  --  Left
         7, 0, 3,
         3, 2, 7,  --  Bottom
         7, 6, 2);

   procedure Load_Data (Array1  : Vertex_Array_Object;
                        Buffer1, Buffer2, Buffer3 : GL.Objects.Buffers.Buffer;
                        Program : GL.Objects.Programs.Program) is
      use GL.Objects.Buffers;

      Vertices : constant Single_Array
        := (-0.5,  0.5, -0.5, 0.0, 0.0, 1.0,
             0.5,  0.5, -0.5, 1.0, 0.0, 0.0,
             0.5, -0.5, -0.5, 1.0, 1.0, 1.0,
            -0.5, -0.5, -0.5, 0.0, 1.0, 0.0,

            -0.5,  0.5,  0.5, 1.0, 0.0, 0.0,
             0.5,  0.5,  0.5, 0.0, 1.0, 0.0,
             0.5, -0.5,  0.5, 0.0, 0.0, 1.0,
            -0.5, -0.5,  0.5, 1.0, 1.0, 1.0);

      Attrib_Pos : constant GL.Attributes.Attribute :=
        GL.Objects.Programs.Attrib_Location (Program, "in_Position");
      Attrib_Color : constant GL.Attributes.Attribute :=
        GL.Objects.Programs.Attrib_Location (Program, "in_Color");
      Attrib_Model : constant GL.Attributes.Attribute :=
        GL.Objects.Programs.Attrib_Location (Program, "in_Model");

      use type GL.Attributes.Attribute;
   begin
      Array1.Bind;

      Array_Buffer.Bind (Buffer1);
      Load_Vectors (Array_Buffer, Vertices, Static_Draw);

      GL.Attributes.Enable_Vertex_Attrib_Array (Attrib_Pos);
      GL.Attributes.Enable_Vertex_Attrib_Array (Attrib_Color);

      GL.Attributes.Set_Vertex_Attrib_Pointer (Attrib_Pos, 3, Single_Type, 6, 0);
      GL.Attributes.Set_Vertex_Attrib_Pointer (Attrib_Color, 3, Single_Type, 6, 3);

      Element_Array_Buffer.Bind (Buffer2);
      Load_Indices (Element_Array_Buffer, Indices, Static_Draw);

      --  Load matrices for all the instances
      Array_Buffer.Bind (Buffer3);

      declare
         Index : Int := 1;

         X, Y, Z : Single;
         Distance_Multiplier : constant := 1.0 + Space_Between_Cubes;
      begin
         for Index_X in 1 .. Instances_Dimension loop
            X := Single (Index_X) * Distance_Multiplier;
            for Index_Y in 1 .. Instances_Dimension loop
               Y := Single (Index_Y) * Distance_Multiplier;
               for Index_Z in 1 .. Instances_Dimension loop
                  Z := Single (Index_Z) * Distance_Multiplier;

                  Translate (Matrices (Index), (X, Y, Z));
                  Index := Index + 1;
               end loop;
            end loop;
         end loop;
      end;
      Load_Matrices (Array_Buffer, Matrices, Static_Draw);

      GL.Attributes.Enable_Vertex_Attrib_Array (Attrib_Model);
      GL.Attributes.Enable_Vertex_Attrib_Array (Attrib_Model + 1);
      GL.Attributes.Enable_Vertex_Attrib_Array (Attrib_Model + 2);
      GL.Attributes.Enable_Vertex_Attrib_Array (Attrib_Model + 3);

      GL.Attributes.Set_Vertex_Attrib_Pointer (Attrib_Model, 4, Single_Type, 16, 0);
      GL.Attributes.Set_Vertex_Attrib_Pointer (Attrib_Model + 1, 4, Single_Type, 16, 4);
      GL.Attributes.Set_Vertex_Attrib_Pointer (Attrib_Model + 2, 4, Single_Type, 16, 8);
      GL.Attributes.Set_Vertex_Attrib_Pointer (Attrib_Model + 3, 4, Single_Type, 16, 12);

      GL.Attributes.Set_Vertex_Attrib_Divisor (Attrib_Model, 1);
      GL.Attributes.Set_Vertex_Attrib_Divisor (Attrib_Model + 1, 1);
      GL.Attributes.Set_Vertex_Attrib_Divisor (Attrib_Model + 2, 1);
      GL.Attributes.Set_Vertex_Attrib_Divisor (Attrib_Model + 3, 1);
   end Load_Data;

   procedure Load_Shaders (Vertex_Shader, Fragment_Shader : GL.Objects.Shaders.Shader;
                           Program : GL.Objects.Programs.Program) is
   begin
      -- load shader sources and compile shaders
      GL.Files.Load_Shader_Source_From_File
        (Vertex_Shader, "../test/gl/shaders/instancing.vert");
      GL.Files.Load_Shader_Source_From_File
        (Fragment_Shader, "../test/gl/shaders/instancing.frag");
      
      Vertex_Shader.Compile;
      Fragment_Shader.Compile;
      
      if not Vertex_Shader.Compile_Status then
         Ada.Text_IO.Put_Line ("Compilation of vertex shader failed. log:");
         Ada.Text_IO.Put_Line (Vertex_Shader.Info_Log);
      end if;
      if not Fragment_Shader.Compile_Status then
         Ada.Text_IO.Put_Line ("Compilation of fragment shader failed. log:");
         Ada.Text_IO.Put_Line (Fragment_Shader.Info_Log);
      end if;
      
      -- Set up program
      Program.Attach (Vertex_Shader);
      Program.Attach (Fragment_Shader);
      Program.Bind_Attrib_Location (0, "in_Position");
      Program.Bind_Attrib_Location (1, "in_Color");

      Program.Link;
      if not Program.Link_Status then
         Ada.Text_IO.Put_Line ("Program linking failed. Log:");
         Ada.Text_IO.Put_Line (Program.Info_Log);
         return;
      end if;
      Program.Use_Program;
   end Load_Shaders;

   Vertex_Shader   : GL.Objects.Shaders.Shader
     (Kind => GL.Objects.Shaders.Vertex_Shader);
   Fragment_Shader : GL.Objects.Shaders.Shader
     (Kind => GL.Objects.Shaders.Fragment_Shader);
   Program         : GL.Objects.Programs.Program;

   Vector_Buffer1, Vector_Buffer2, Vector_Buffer3 : GL.Objects.Buffers.Buffer;
   Array1 : GL.Objects.Vertex_Arrays.Vertex_Array_Object;

   Uni_View, Uni_Proj : GL.Objects.Programs.Uniforms.Uniform;
begin
   Display_Backend.Init;
   Display_Backend.Configure_Minimum_OpenGL_Version (Major => 3, Minor => 3);
   Display_Backend.Set_Not_Resizable;
   Display_Backend.Open_Window (Width => 500, Height => 500);
   Ada.Text_IO.Put_Line ("Initialized GLFW window");

   Vertex_Shader.Initialize_Id;
   Fragment_Shader.Initialize_Id;
   Program.Initialize_Id;

   Vector_Buffer1.Initialize_Id;
   Vector_Buffer2.Initialize_Id;
   Vector_Buffer3.Initialize_Id;
   Array1.Initialize_Id;

   Ada.Text_IO.Put_Line ("Initialized objects");

   Load_Shaders (Vertex_Shader, Fragment_Shader, Program);
   Ada.Text_IO.Put_Line ("Loaded shaders");

   Load_Data (Array1, Vector_Buffer1, Vector_Buffer2, Vector_Buffer3, Program);
   Ada.Text_IO.Put_Line ("Loaded data");

   declare
      Matrix_View, Matrix_Proj : Singles.Matrix4;
      Mouse_X, Mouse_Y, Mouse_Z, Distance_Center : Single;

      Clamping_Was_Enabled : Boolean := False;
      Clamping_Enabled : Boolean := True;
   begin
      Distance_Center := Single (Instances_Dimension);
      Distance_Center := Distance_Center + (Distance_Center - 1.0) * Space_Between_Cubes;
      Distance_Center := Distance_Center / 2.0 - 0.5 + 1.2;

      Display_Backend.Set_Zoom_Distance (100.0);

      Uni_View  := Program.Uniform_Location ("view");
      Uni_Proj  := Program.Uniform_Location ("proj");

      --  Projection matrix
      Matrix_Proj := Perspective (45.0, 1.0, 10.0, 200.0);
      GL.Objects.Programs.Uniforms.Set_Single (Uni_Proj, Matrix_Proj);

      GL.Toggles.Enable (GL.Toggles.Depth_Test);

      Ada.Text_IO.Put_Line ("Instances of cube: " & Positive'Image (Matrices'Length));
      Ada.Text_IO.Put_Line ("Usage: Press space key to enable/disable depth clamping.");

      while not Display_Backend.Get_Window.Should_Close loop
         Clear (Buffer_Bits'(Color => True, Depth => True, others => False));

         Clamping_Enabled := Display_Backend.Get_Effect (2) = 0;
         if Clamping_Enabled then
            GL.Toggles.Enable (GL.Toggles.Depth_Clamp);
         else
            GL.Toggles.Disable (GL.Toggles.Depth_Clamp);
         end if;

         if Clamping_Enabled /= Clamping_Was_Enabled then
            Ada.Text_IO.Put_Line ("Clamping enabled: " & Boolean'Image (Clamping_Enabled));
         end if;
         Clamping_Was_Enabled := Clamping_Enabled;

         Mouse_X := Single (Display_Backend.Get_Mouse_X);
         Mouse_Y := Single (Display_Backend.Get_Mouse_Y);
         Mouse_Z := Single (Display_Backend.Get_Zoom_Distance);

         --  View matrix
         Matrix_View := Singles.Identity4;
         Translate (Matrix_View, (0.0, 0.0, -Mouse_Z));
         Rotate_X (Matrix_View, Mouse_Y);
         Rotate_Y (Matrix_View, Mouse_X);
         Translate (Matrix_View, (-Distance_Center, -Distance_Center, -Distance_Center));

         --  Set uniform
         GL.Objects.Programs.Uniforms.Set_Single (Uni_View, Matrix_View);

         GL.Objects.Buffers.Draw_Elements (Triangles, Indices'Length, UInt_Type, Matrices'Length);

         Display_Backend.Swap_Buffers;
         Display_Backend.Poll_Events;
      end loop;
   end;

   Display_Backend.Shutdown;
end GL_Test.Instancing;
