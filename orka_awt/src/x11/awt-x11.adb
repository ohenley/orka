package body AWT.X11 is

   D : aliased X_11.Display;

   function Get_Display return not null access X_11.Display is
     (D'Access);
   
end AWT.X11;