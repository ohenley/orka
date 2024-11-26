package body X11.AWT is

   function Get_Display (Display : Standard.X11.Display) return Standard.EGL.Native_Display_Ptr is
      (Convert (Display.Proxy));
   
end X11.AWT;