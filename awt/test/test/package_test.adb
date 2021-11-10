with Ada.Text_IO;

with GL.Types;

with Orka.Logging;
with Orka.Resources.Locations.Directories;
with Orka.Rendering.Programs.Modules;
with Orka.Rendering.Drawing;
with Orka.Windows;

with AWT.Drag_And_Drop;

package body Package_Test is

   use all type Orka.Logging.Source;
   use all type Orka.Logging.Severity;
   use Orka.Logging;

   package Messages is new Orka.Logging.Messages (Window_System);

   protected body Dnd_Signal is
      procedure Set is
      begin
         Dropped := True;
      end Set;

      entry Wait when Dropped is
      begin
         Dropped := False;
      end Wait;
   end Dnd_Signal;

   overriding
   function On_Close (Object : in out Test_Window) return Boolean is
   begin
      Ada.Text_IO.Put_Line ("Test_Window.On_Close");
      return True;
   end On_Close;

   overriding
   procedure On_Drag
     (Object : in out Test_Window;
      X, Y   : AWT.Inputs.Fixed)
   is
      use all type AWT.Inputs.Action_Kind;
      use type AWT.Inputs.Fixed;
   begin
      Messages.Log (Debug, "user dragged at " & X'Image & Y'Image);
      AWT.Drag_And_Drop.Set_Action (if X < 300.0 and Y < 300.0 then Copy else None);
   end On_Drag;

   overriding
   procedure On_Drop
     (Object : in out Test_Window)
   is
      use all type AWT.Inputs.Action_Kind;

      Action : constant AWT.Inputs.Action_Kind := AWT.Drag_And_Drop.Valid_Action;
   begin
      Messages.Log (Info, "user dropped! action: " & Action'Image);

      if Action /= None then
         Dnd_Signal.Set;
      end if;
   end On_Drop;

   overriding
   procedure On_Configure
     (Object       : in out Test_Window;
      State        : Standard.AWT.Windows.Window_State) is
   begin
      Ada.Text_IO.Put_Line ("Configure xdg_surface:" &
        State.Width'Image & State.Height'Image & State.Margin'Image);

      Object.Resize := State.Visible and State.Width > 0 and State.Height > 0;
   end On_Configure;

   procedure Post_Initialize (Object : in out Test_Window) is
      Location_Shaders : constant Orka.Resources.Locations.Location_Ptr :=
        Orka.Resources.Locations.Directories.Create_Location ("./");

      Alpha : constant GL.Types.Single := (if Object.State.Transparent then 0.5 else 1.0);
   begin
      Object.FB := Orka.Rendering.Framebuffers.Get_Default_Framebuffer (Object);
      Object.FB.Set_Default_Values ((Color => (0.0, 0.0, 0.0, Alpha), others => <>));
      Object.FB.Use_Framebuffer;
      Messages.Log (Debug, "FB default window: " & Object.Width'Image & Object.Height'Image);

      Object.Program  := Orka.Rendering.Programs.Create_Program
        (Orka.Rendering.Programs.Modules.Create_Module
           (Location_Shaders,
            VS => "cursor.vert",
            FS => "cursor.frag"));
      Object.Program.Use_Program;

      Object.Cursor := Object.Program.Uniform ("cursor");
   end Post_Initialize;

   procedure Render (Object : in out Test_Window) is
      use type GL.Types.Single;
      use Standard.AWT.Inputs;

      Window_State  : constant Standard.AWT.Windows.Window_State := Object.State;
      Pointer_State : constant Standard.AWT.Inputs.Pointer_State := Object.State;

      subtype Single is GL.Types.Single;

      Width  : constant Single := Single (Window_State.Width + 2 * Window_State.Margin);
      Height : constant Single := Single (Window_State.Height + 2 * Window_State.Margin);

      PX : constant Single := Single (Pointer_State.Position (X));
      PY : constant Single := Single (Pointer_State.Position (Y));

      Horizontal : constant GL.Types.Single := PX / Width * 2.0 - 1.0;
      Vertical   : constant GL.Types.Single := PY / Height * 2.0 - 1.0;

      Alpha : constant GL.Types.Single := (if Window_State.Transparent then 0.5 else 1.0);
   begin
--      Messages.Log (Debug, PX'Image & Width'Image & Horizontal'Image);
      if Object.Resize then
         Object.Resize := False;

         Object.FB := Orka.Rendering.Framebuffers.Get_Default_Framebuffer (Object);
         Object.FB.Set_Default_Values ((Color => (0.0, 0.0, 0.0, Alpha), others => <>));
         Object.FB.Use_Framebuffer;
         Messages.Log (Debug, "FB default window, new size: " &
           Object.Width'Image & Object.Height'Image);
      end if;

      Object.FB.Clear ((Color => True, others => False));

      Object.Cursor.Set_Vector (GL.Types.Single_Array'(Horizontal, -Vertical));
      Orka.Rendering.Drawing.Draw (GL.Types.Points, 0, 1);

      Object.Swap_Buffers;
   end Render;

   overriding
   function Create_Window
     (Context            : Orka.Contexts.Surface_Context'Class;
      Width, Height      : Positive;
      Title              : String  := "";
      Samples            : Natural := 0;
      Visible, Resizable : Boolean := True;
      Transparent        : Boolean := False) return Test_Window is
   begin
      return Result : constant Test_Window :=
        (Orka.Contexts.EGL.AWT.Create_Window
          (Context, Width, Height, Title, Samples,
           Visible     => Visible,
           Resizable   => Resizable,
           Transparent => Transparent) with others => <>);
   end Create_Window;

end Package_Test;
