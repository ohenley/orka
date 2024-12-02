with System;
with Interfaces.C;
with Interfaces.C.Strings;

package Win is
   pragma Preelaborate;
   pragma Linker_Options ("-lX11");
   --pragma Linker_Options ("-lXext");

   package ICS renames Interfaces.C.Strings;
   package IC renames interfaces.C;

   Exposure_Mask         : constant := 32768;
   Expose                : constant := 12;

   type X_Display_Access is new System.Address;
   type X_Window is new IC.Unsigned_Long;

   type Display is record
      Proxy : Standard.X11.X_Display_Access;
   end record;

   type X_Expose_Event is record
         W      : X_Window;                      
         Xx     : IC.int;
         Y      : IC.int;
         Width  : IC.int;
         Height : IC.int;
         Count  : IC.int;
   end record;
   
   type X_Event is record 
        Event_Type   : IC.int;                        
        Serial       : IC.unsigned_long;                     
        Send_Event   : Boolean;                                
        Display      : X_Display_Access;                   
        Expose       : X_Expose_Event;
    end record;
   type X_Event_Access is access all X_Event;

   
   type X_Drawable is new IC.Unsigned_Long;
   type X_Graphic_Context is new System.Address;
   type X_Graphic_Context_Access is access all X_Graphic_Context;

   type Const_Char_Access is access constant IC.char;

   function X_Open_Display
     (Display_Name : ICS.Chars_Ptr) return X_Display_Access
   with Import => True, Convention => C, External_Name => "XOpenDisplay";

   function X_Default_Screen (Display : X_Display_Access) return IC.Int
   with Import => True, Convention => C, External_Name => "XDefaultScreen";

   function X_Default_Root_Window (Display : X_Display_Access) return X_Window
   with Import => True, Convention => C, External_Name => "XDefaultRootWindow";

   function X_Black_Pixel
     (Display : X_Display_Access; Screen_Number : IC.Int) return IC.Unsigned_Long
   with Import => True, Convention => C, External_Name => "XBlackPixel";

   function X_White_Pixel
     (Display : X_Display_Access; Screen_Number : IC.Int) return IC.Unsigned_Long
   with Import => True, Convention => C, External_Name => "XWhitePixel";

   function X_Create_Simple_Window
     (Display      : X_Display_Access;
      Parent       : X_Window;
      X            : IC.Int;
      Y            : IC.Int;
      Width        : IC.Unsigned;
      Height       : IC.Unsigned;
      Border_Width : IC.Unsigned;
      Border       : IC.Unsigned_Long;
      Background   : IC.Unsigned_Long) return X_Window
   with
     Import => True,
     Convention => c,
     External_Name => "XCreateSimpleWindow";

   procedure X_Map_Window (Display : X_Display_Access; W : X_Window)
   with Import => True, Convention => C, External_Name => "XMapWindow";

   procedure X_Select_Input
     (Display : X_Display_Access; W : X_Window; Event_Mask : IC.Long)
   with Import => True, Convention => C, External_Name => "XSelectInput";

   procedure X_Next_Event
     (Display : X_Display_Access; Event_Return : X_Event_Access)
   with Import => True, Convention => c, External_Name => "XNextEvent";

   procedure X_Draw_String
     (Display : X_Display_Access;
      D       : X_Drawable;
      GC      : X_Graphic_Context_Access;
      XX      : IC.Int;
      Y       : IC.Int;
      String  : IC.Char_Array;
      Length  : IC.Int)
   with Import => True, Convention => C, External_Name => "XDrawString";

   function X_Default_Graphic_Context
     (Display : X_Display_Access; Screen_Number : IC.Int)
      return X_Graphic_Context_Access
   with Import => True, Convention => C, External_Name => "XDefaultGC";

end Win;