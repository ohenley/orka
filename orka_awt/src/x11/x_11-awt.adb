package body X_11.AWT is

   function Get_Display (Display : X_11.Display) return Standard.EGL.Native_Display_Ptr is
      Display_Ptr : X_11.Display_Ptr := new X_11.Display;
   begin
      return Convert (Display_Ptr);
   end Get_Display;
   
end X_11.AWT;