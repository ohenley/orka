with Ada.Text_IO; use Ada.Text_IO;

with AWT;

with Orka.Contexts;
with Orka.Contexts.AWT;

procedure Example_X11 is
begin
   Put_Line ("Initializing...");
   AWT.Initialize;
   Put_Line ("Initialized");

   declare
      Context : constant Orka.Contexts.Surface_Context'Class :=
        Orka.Contexts.AWT.Create_Context
          (Version => (4, 2),
           Flags   => (Debug | Robust => True, others => False));
   begin
      null;
   end;
end;