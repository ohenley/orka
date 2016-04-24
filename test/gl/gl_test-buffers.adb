--------------------------------------------------------------------------------
-- Copyright (c) 2015 onox <denkpadje@gmail.com>
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

with Interfaces.C;

with Ada.Text_IO;

with GL.Attributes;
with GL.Buffers;
with GL.Files;
with GL.Pixels;
with GL.Objects.Buffers;
with GL.Objects.Shaders;
with GL.Objects.Programs.Uniforms;
with GL.Objects.Vertex_Arrays;
with GL.Objects.Textures.Targets;
with GL.Objects.Framebuffers;
with GL.Objects.Renderbuffers;
with GL.Types;
with GL.Toggles;
with GL.Window;
with GL.Transforms;

with GL_Test.Display_Backend;

procedure GL_Test.Buffers is
   use GL.Buffers;
   use GL.Types;
   use GL.Objects.Vertex_Arrays;

   procedure Load_Vectors is new GL.Objects.Buffers.Load_To_Buffer
     (Single_Pointers);

   procedure Load_Scene_Data (Array_Cube  : Vertex_Array_Object;
                              Buffer_Cube : GL.Objects.Buffers.Buffer;
                              Program     : GL.Objects.Programs.Program) is
      use GL.Objects.Buffers;
      use GL.Attributes;

      Vertices : constant Single_Array
            -- Top
        := (-0.5, -0.5,  0.5,   1.0, 0.0, 0.0,   0.0, 0.0,
             0.5, -0.5,  0.5,   0.0, 1.0, 0.0,   1.0, 0.0,
             0.5,  0.5,  0.5,   0.0, 0.0, 1.0,   1.0, 1.0,
             0.5,  0.5,  0.5,   0.0, 0.0, 1.0,   1.0, 1.0,
            -0.5,  0.5,  0.5,   0.0, 0.0, 1.0,   0.0, 1.0,
            -0.5, -0.5,  0.5,   1.0, 0.0, 0.0,   0.0, 0.0,

            -- Right
             0.5, -0.5, -0.5,   1.0, 0.0, 0.0,   0.0, 0.0,
             0.5,  0.5, -0.5,   0.0, 1.0, 0.0,   1.0, 0.0,
             0.5,  0.5,  0.5,   0.0, 0.0, 1.0,   1.0, 1.0,
             0.5,  0.5,  0.5,   0.0, 0.0, 1.0,   1.0, 1.0,
             0.5, -0.5,  0.5,   0.0, 0.0, 1.0,   0.0, 1.0,
             0.5, -0.5, -0.5,   1.0, 0.0, 0.0,   0.0, 0.0,

            -- Left
            -0.5, -0.5, -0.5,   0.0, 1.0, 0.0,   1.0, 0.0,
            -0.5,  0.5, -0.5,   1.0, 0.0, 0.0,   1.0, 1.0,
            -0.5,  0.5,  0.5,   0.0, 0.0, 1.0,   0.0, 1.0,
            -0.5,  0.5,  0.5,   0.0, 0.0, 1.0,   0.0, 1.0,
            -0.5, -0.5,  0.5,   0.0, 0.0, 1.0,   0.0, 0.0,
            -0.5, -0.5, -0.5,   0.0, 1.0, 0.0,   1.0, 0.0,

            -- Front
            -0.5, -0.5, -0.5,   1.0, 0.0, 0.0,   0.0, 0.0,
             0.5, -0.5, -0.5,   0.0, 1.0, 0.0,   1.0, 0.0,
             0.5, -0.5,  0.5,   0.0, 0.0, 1.0,   1.0, 1.0,
             0.5, -0.5,  0.5,   0.0, 0.0, 1.0,   1.0, 1.0,
            -0.5, -0.5,  0.5,   0.0, 0.0, 1.0,   0.0, 1.0,
            -0.5, -0.5, -0.5,   1.0, 0.0, 0.0,   0.0, 0.0,

            -- Back
            -0.5,  0.5, -0.5,   0.0, 1.0, 0.0,   1.0, 0.0,
             0.5,  0.5, -0.5,   1.0, 0.0, 0.0,   1.0, 1.0,
             0.5,  0.5,  0.5,   0.0, 0.0, 1.0,   0.0, 1.0,
             0.5,  0.5,  0.5,   0.0, 0.0, 1.0,   0.0, 1.0,
            -0.5,  0.5,  0.5,   0.0, 0.0, 1.0,   0.0, 0.0,
            -0.5,  0.5, -0.5,   0.0, 1.0, 0.0,   1.0, 0.0,

            -- Floor
            -1.0, -1.0, -0.5,    0.2, 0.2, 0.2,   0.0, 0.0,
             1.0, -1.0, -0.5,    0.2, 0.2, 0.2,   0.0, 0.0,
             1.0,  1.0, -0.5,    0.2, 0.2, 0.2,   0.0, 0.0,
             1.0,  1.0, -0.5,    0.2, 0.2, 0.2,   0.0, 0.0,
            -1.0,  1.0, -0.5,    0.2, 0.2, 0.2,   0.0, 0.0,
            -1.0, -1.0, -0.5,    0.2, 0.2, 0.2,   0.0, 0.0);

      Attrib_Pos : constant Attribute :=
        GL.Objects.Programs.Attrib_Location (Program, "position");
      Attrib_Col : constant Attribute :=
        GL.Objects.Programs.Attrib_Location (Program, "color");
      Attrib_Tex : constant Attribute :=
        GL.Objects.Programs.Attrib_Location (Program, "texcoord");
   begin
      Array_Cube.Bind;
      Array_Buffer.Bind (Buffer_Cube);
      Load_Vectors (Array_Buffer, Vertices, Static_Draw);

      Set_Vertex_Attrib_Pointer (Attrib_Pos, 3, Single_Type, 8, 0);
      Enable_Vertex_Attrib_Array (Attrib_Pos);
      
      Set_Vertex_Attrib_Pointer (Attrib_Col, 3, Single_Type, 8, 3);
      Enable_Vertex_Attrib_Array (Attrib_Col);

      Set_Vertex_Attrib_Pointer (Attrib_Tex, 2, Single_Type, 8, 6);
      Enable_Vertex_Attrib_Array (Attrib_Tex);
   end Load_Scene_Data;

   procedure Load_Screen_Data (Array_Quad  : Vertex_Array_Object;
                               Buffer_Quad : GL.Objects.Buffers.Buffer;
                               Program     : GL.Objects.Programs.Program) is
      use GL.Objects.Buffers;
      use GL.Attributes;

      Vertices : constant Single_Array
        := (-1.0,  1.0, 0.0, 1.0,
             1.0,  1.0, 1.0, 1.0,
             1.0, -1.0, 1.0, 0.0,

             1.0, -1.0, 1.0, 0.0,
            -1.0, -1.0, 0.0, 0.0,
            -1.0,  1.0, 0.0, 1.0);

      Attrib_Pos : constant Attribute :=
        GL.Objects.Programs.Attrib_Location (Program, "position");
      Attrib_Tex : constant Attribute :=
        GL.Objects.Programs.Attrib_Location (Program, "texcoord");
   begin
      Array_Quad.Bind;
      Array_Buffer.Bind (Buffer_Quad);
      Load_Vectors (Array_Buffer, Vertices, Static_Draw);

      Set_Vertex_Attrib_Pointer (Attrib_Pos, 2, Single_Type, 4, 0);
      Enable_Vertex_Attrib_Array (Attrib_Pos);

      Set_Vertex_Attrib_Pointer (Attrib_Tex, 2, Single_Type, 4, 2);
      Enable_Vertex_Attrib_Array (Attrib_Tex);
   end Load_Screen_Data;

   procedure Load_Shaders (Vertex_Source, Fragment_Source : String;
                           Vertex_Shader, Fragment_Shader : GL.Objects.Shaders.Shader;
                           Program : GL.Objects.Programs.Program) is
   begin
      -- Load shader sources and compile shaders
      GL.Files.Load_Shader_Source_From_File
        (Vertex_Shader, Vertex_Source);
      GL.Files.Load_Shader_Source_From_File
        (Fragment_Shader, Fragment_Source);
      
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

      Program.Link;
      if not Program.Link_Status then
         Ada.Text_IO.Put_Line ("Program linking failed. Log:");
         Ada.Text_IO.Put_Line (Program.Info_Log);
         return;
      end if;
   end Load_Shaders;

   procedure Load_Texture (Texture : GL.Objects.Textures.Texture) is
      use GL.Objects.Textures;
      use GL.Objects.Textures.Targets;
      use GL.Pixels;

      Pixels : constant Single_Array
        := (0.1, 0.1, 0.1,   1.0, 1.0, 1.0,   0.1, 0.1, 0.1,   1.0, 1.0, 1.0,
            1.0, 1.0, 1.0,   0.1, 0.1, 0.1,   1.0, 1.0, 1.0,   0.1, 0.1, 0.1,
            0.1, 0.1, 0.1,   1.0, 1.0, 1.0,   0.1, 0.1, 0.1,   1.0, 1.0, 1.0,
            1.0, 1.0, 1.0,   0.1, 0.1, 0.1,   1.0, 1.0, 1.0,   0.1, 0.1, 0.1);
   begin
      Texture_2D.Bind (Texture);

      Texture_2D.Set_X_Wrapping (Clamp_To_Edge);
      Texture_2D.Set_Y_Wrapping (Clamp_To_Edge);

      Texture_2D.Set_Minifying_Filter (Nearest);
      Texture_2D.Set_Magnifying_Filter (Nearest);

      -- Load texture data
      Texture_2D_Target.Load_From_Data
        (Texture_2D, 0, GL.Pixels.Internal_Format'(GL.Pixels.RGB),
         4, 4, GL.Pixels.Format'(GL.Pixels.RGB), GL.Pixels.Float, Pixels'Address);
   end Load_Texture;

   procedure Load_Color_Texture (Texture : GL.Objects.Textures.Texture) is
      use GL.Objects.Textures;
      use GL.Objects.Textures.Targets;
      use GL.Pixels;
   begin
      Texture_2D.Bind (Texture);

      Texture_2D.Set_Minifying_Filter (Nearest);
      Texture_2D.Set_Magnifying_Filter (Nearest);

      Texture_2D.Load_Empty_Texture (0, GL.Pixels.RGB, 500, 500);
   end Load_Color_Texture;

   Scene_Vertex_Shader   : GL.Objects.Shaders.Shader
     (Kind => GL.Objects.Shaders.Vertex_Shader);
   Scene_Fragment_Shader : GL.Objects.Shaders.Shader
     (Kind => GL.Objects.Shaders.Fragment_Shader);
   Scene_Program         : GL.Objects.Programs.Program;

   Screen_Vertex_Shader   : GL.Objects.Shaders.Shader
     (Kind => GL.Objects.Shaders.Vertex_Shader);
   Screen_Fragment_Shader : GL.Objects.Shaders.Shader
     (Kind => GL.Objects.Shaders.Fragment_Shader);
   Screen_Program         : GL.Objects.Programs.Program;

   Vector_Buffer_Cube, Vector_Buffer_Quad : GL.Objects.Buffers.Buffer;
   Array_Cube, Array_Quad : GL.Objects.Vertex_Arrays.Vertex_Array_Object;

   Scene_Texture, Color_Texture : GL.Objects.Textures.Texture;
   FB : GL.Objects.Framebuffers.Framebuffer;
   RB : GL.Objects.Renderbuffers.Renderbuffer;

   Uni_Model, Uni_View, Uni_Proj, Uni_Color, Uni_Effect : GL.Objects.Programs.Uniforms.Uniform;

   Scene_Vertex_Source    : constant String := "../test/gl/shaders/buffers_scene.vert";
   Scene_Fragment_Source  : constant String := "../test/gl/shaders/buffers_scene.frag";
   Screen_Vertex_Source   : constant String := "../test/gl/shaders/buffers_screen.vert";
   Screen_Fragment_Source : constant String := "../test/gl/shaders/buffers_screen.frag";
begin
   Display_Backend.Init;
   Display_Backend.Configure_Minimum_OpenGL_Version (Major => 3, Minor => 2);
   Display_Backend.Set_Not_Resizable;
   Display_Backend.Open_Window (Width => 500, Height => 500);
   Ada.Text_IO.Put_Line ("Initialized GLFW window");

   -- Generate shaders and program for scene
   Scene_Vertex_Shader.Initialize_Id;
   Scene_Fragment_Shader.Initialize_Id;
   Scene_Program.Initialize_Id;

   -- Generate shaders and program for post-processing
   Screen_Vertex_Shader.Initialize_Id;
   Screen_Fragment_Shader.Initialize_Id;
   Screen_Program.Initialize_Id;

   -- Generate Vertex Buffer Objects
   Vector_Buffer_Cube.Initialize_Id;
   Vector_Buffer_Quad.Initialize_Id;

   -- Generate Vertex Array Objects
   Array_Cube.Initialize_Id;
   Array_Quad.Initialize_Id;

   -- Generate texture and frame/render buffers
   Scene_Texture.Initialize_Id;
   Color_Texture.Initialize_Id;
   FB.Initialize_Id;
   RB.Initialize_Id;

   Ada.Text_IO.Put_Line ("Initialized objects");

   -- Compile shaders and attach them to the programs
   Load_Shaders (Scene_Vertex_Source, Scene_Fragment_Source,
                 Scene_Vertex_Shader, Scene_Fragment_Shader, Scene_Program);
   Load_Shaders (Screen_Vertex_Source, Screen_Fragment_Source,
                 Screen_Vertex_Shader, Screen_Fragment_Shader, Screen_Program);

   Ada.Text_IO.Put_Line ("Loaded shaders");

   -- Upload vertices to GPU
   Load_Scene_Data (Array_Cube, Vector_Buffer_Cube, Scene_Program);
   Load_Screen_Data (Array_Quad, Vector_Buffer_Quad, Screen_Program);

   Ada.Text_IO.Put_Line ("Loaded data");

   -- Load checkerboard texture
   GL.Objects.Textures.Set_Active_Unit (0);
   Load_Texture (Scene_Texture);

   -- Use post-processing program
   Screen_Program.Use_Program;
   GL.Objects.Programs.Uniforms.Set_Int (Screen_Program.Uniform_Location ("texFrameBuffer"), 0);

   -- Create frame buffer
   GL.Objects.Framebuffers.Draw_Target.Bind (FB);

   -- Attach color texture to frame buffer
   Load_Color_Texture (Color_Texture);
   GL.Objects.Framebuffers.Draw_Target.Attach_Texture (GL.Objects.Framebuffers.Color_Attachment_0, Color_Texture, 0);

   -- Create render buffer object for depth and stencil buffers
   GL.Objects.Renderbuffers.Active_Renderbuffer.Bind (RB);
   GL.Objects.Renderbuffers.Active_Renderbuffer.Allocate (GL.Pixels.Depth24_Stencil8, 500, 500);
   GL.Objects.Framebuffers.Draw_Target.Attach_Renderbuffer (GL.Objects.Framebuffers.Depth_Stencil_Attachment, RB);

   Ada.Text_IO.Put_Line ("Loaded textures and buffers");

   Uni_Model := Scene_Program.Uniform_Location ("model");
   Uni_View  := Scene_Program.Uniform_Location ("view");
   Uni_Proj  := Scene_Program.Uniform_Location ("proj");

   Uni_Color := Scene_Program.Uniform_Location ("overrideColor");

   Uni_Effect := Screen_Program.Uniform_Location ("effect");

   Ada.Text_IO.Put_Line ("Loaded uniforms");

   Ada.Text_IO.Put_Line ("Usage: Right click and drag mouse to move camera around cube.");
   Ada.Text_IO.Put_Line ("Usage: Use scroll wheel to zoom in and out.");
   Ada.Text_IO.Put_Line ("Usage: Press space key to cycle between post-processing effects.");

   declare
      Width, Height : Interfaces.C.int;
      Matrix_Model, Matrix_View, Matrix_Proj : Singles.Matrix4;

      Mouse_X, Mouse_Y, Mouse_Z : Single;

      use GL.Transforms;
      use type Singles.Matrix4;
   begin
      while not Display_Backend.Get_Window.Should_Close loop
         Display_Backend.Get_Window.Get_Framebuffer_Size (Width, Height);

         Mouse_X := Single (Display_Backend.Get_Mouse_X);
         Mouse_Y := Single (Display_Backend.Get_Mouse_Y);

         if Display_Backend.Get_Zoom_Distance > 10.0 then
            Display_Backend.Set_Zoom_Distance (10.0);
         end if;
         Mouse_Z := Single (Display_Backend.Get_Zoom_Distance);

         -- Model matrix
         Matrix_Model := Singles.Identity4;

         -- View matrix
         Matrix_View := Singles.Identity4;

         Translate (Matrix_View, (0.0, 0.0, -Mouse_Z));
         Rotate_X (Matrix_View, Mouse_Y);
         Rotate_Z (Matrix_View, Mouse_X);

         -- Projection matrix
         Matrix_Proj := Perspective (45.0, 1.0, 0.1, 20.0);

         -- Bind frame buffer and draw 3D scene
         GL.Objects.Framebuffers.Draw_Target.Bind (FB);
         Array_Cube.Bind;
         GL.Toggles.Enable (GL.Toggles.Depth_Test);
         Scene_Program.Use_Program;

         GL.Objects.Textures.Set_Active_Unit (0);
         GL.Objects.Textures.Targets.Texture_2D.Bind (Scene_Texture);

         GL.Window.Set_Viewport (GL.Types.Int'(0), GL.Types.Int'(0), GL.Types.Int (Width), GL.Types.Int (Height));
         Clear (Buffer_Bits'(Color => True, Depth => True, others => False));

         -- Set uniforms
         GL.Objects.Programs.Uniforms.Set_Single (Uni_Model, Matrix_Model);
         GL.Objects.Programs.Uniforms.Set_Single (Uni_View, Matrix_View);
         GL.Objects.Programs.Uniforms.Set_Single (Uni_Proj, Matrix_Proj);

         -- Draw cube
         GL.Objects.Vertex_Arrays.Draw_Arrays (Triangles, 0, 30);

         -- Draw floor
         GL.Toggles.Enable (GL.Toggles.Stencil_Test);

         ---------------------------------------------------------------

         Set_Stencil_Function (Always, 1, 16#FF#);  -- Set any stencil to 1
         Set_Stencil_Operation (Keep, Keep, Replace);
         Set_Stencil_Mask (16#FF#);  -- Allow writing to stencil buffer

         Depth_Mask (False);
         Clear (Buffer_Bits'(Stencil => True, others => False));
         GL.Objects.Vertex_Arrays.Draw_Arrays (Triangles, 30, 6);

         Set_Stencil_Function (Equal, 1, 16#FF#);  -- Pass test if stencil value is 1
         Set_Stencil_Mask (16#00#);  -- Don't write anything to stencil buffer
         Depth_Mask (True);

         -- Start drawing reflection cube
         Translate (Matrix_Model, (0.0, 0.0, -1.0));
         Scale (Matrix_Model, (1.0, 1.0, -1.0));

         GL.Objects.Programs.Uniforms.Set_Single (Uni_Model, Matrix_Model);
         GL.Objects.Programs.Uniforms.Set_Single (Uni_Color, 0.3, 0.3, 0.3);
         GL.Objects.Vertex_Arrays.Draw_Arrays (Triangles, 0, 30);
         -- End drawing reflection cube

         GL.Objects.Programs.Uniforms.Set_Single (Uni_Color, 1.0, 1.0, 1.0);

         ---------------------------------------------------------------

         GL.Toggles.Disable (GL.Toggles.Stencil_Test);

         -- Bind default frame buffer
         GL.Objects.Framebuffers.Draw_Target.Bind (GL.Objects.Framebuffers.Default_Framebuffer);

         Array_Quad.Bind;
         GL.Toggles.Disable (GL.Toggles.Depth_Test);
         Screen_Program.Use_Program;

         -- Set uniforms
         GL.Objects.Programs.Uniforms.Set_Int (Uni_Effect, Int (Display_Backend.Get_Effect (5)));

         GL.Objects.Textures.Set_Active_Unit (0);
         GL.Objects.Textures.Targets.Texture_2D.Bind (Color_Texture);

         GL.Objects.Vertex_Arrays.Draw_Arrays (Triangles, 0, 6);

         -- Swap front and back buffers
         GL.Flush;
         Display_Backend.Swap_Buffers;

         -- Poll for and process events
         Display_Backend.Poll_Events;
      end loop;
   end;

   Display_Backend.Shutdown;
end GL_Test.Buffers;
