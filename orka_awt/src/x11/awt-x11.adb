with Interfaces.C.Strings;

package body AWT.X11 is
   package ICS renames Interfaces.C.Strings;

   D : aliased Standard.X11.Display;

   function Get_Display return not null access Standard.X11.Display is
   begin
      D.Proxy := Standard.X11.X_Open_Display (ICS.Null_Ptr);
      return D'Access;
   end;
   
end AWT.X11;