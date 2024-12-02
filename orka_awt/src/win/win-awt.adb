package body Win.AWT is

   function Get_Display (Display : Standard.Win.Display) return Standard.EGL.Native_Display_Ptr is
      (Convert (Display.Proxy));
   
end Win.AWT;