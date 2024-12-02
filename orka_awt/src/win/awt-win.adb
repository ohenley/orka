with Interfaces.C.Strings;

package body AWT.Win is
   package ICS renames Interfaces.C.Strings;

   D : aliased Standard.Win.Display;

   function Get_Display return not null access Standard.Win.Display is
   begin
      D.Proxy := Standard.Win.X_Open_Display (ICS.Null_Ptr);
      return D'Access;
   end;
   
end AWT.Win;