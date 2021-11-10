--  SPDX-License-Identifier: Apache-2.0
--
--  Copyright (c) 2021 onox <denkpadje@gmail.com>
--
--  Licensed under the Apache License, Version 2.0 (the "License");
--  you may not use this file except in compliance with the License.
--  You may obtain a copy of the License at
--
--      http://www.apache.org/licenses/LICENSE-2.0
--
--  Unless required by applicable law or agreed to in writing, software
--  distributed under the License is distributed on an "AS IS" BASIS,
--  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--  See the License for the specific language governing permissions and
--  limitations under the License.

private with Ada.Finalization;
private with Ada.Strings.Unbounded;

private with Wayland.Cursor;
private with Wayland.EGL;
private with Wayland.Protocols.Xdg_Shell;
private with Wayland.Protocols.Presentation_Time;
private with Wayland.Protocols.Idle_Inhibit_Unstable_V1;
private with Wayland.Protocols.Xdg_Decoration_Unstable_V1;
private with Wayland.Protocols.Pointer_Constraints_Unstable_V1;

private with EGL.Objects.Displays;
private with EGL.Objects.Surfaces;

with Wayland.Protocols.Client;

with EGL.Objects.Configs;
with EGL.Objects.Contexts;

with AWT.Inputs;
with AWT.Monitors;
with AWT.Windows;

package AWT.Wayland.Windows is
   pragma Preelaborate;

   type Wayland_Window is abstract limited new AWT.Windows.Window with private;

   procedure Sleep_Until_Swap
     (Object       : in out Wayland_Window;
      Time_To_Swap : Duration) is abstract;

   ----------------------------------------------------------------------------
   --                          Internal Subprograms                          --
   ----------------------------------------------------------------------------

   procedure Set_State
     (Object : in out Wayland_Window;
      State  : AWT.Inputs.Pointer_State);

   procedure Set_State
     (Object : in out Wayland_Window;
      State  : AWT.Inputs.Keyboard_State);

   procedure Update_Cursor (Object : in out Wayland_Window) is null;

   procedure Restore_Cursor (Object : in out Wayland_Window);

   type Surface_With_Window (Window : not null access Wayland_Window)
     is new WP.Client.Surface with null record;

   procedure Update_Animated_Cursor (Window : not null access Wayland_Window);

   procedure Set_EGL_Data
     (Object  : in out Wayland_Window;
      Context : EGL.Objects.Contexts.Context;
      Config  : EGL.Objects.Configs.Config;
      sRGB    : Boolean);

   procedure Make_Current
     (Object  : in out Wayland_Window;
      Context : Standard.EGL.Objects.Contexts.Context);

private

   package SU renames Ada.Strings.Unbounded;

   package II renames WP.Idle_Inhibit_Unstable_V1;
   package XD renames WP.Xdg_Decoration_Unstable_V1;
   package PC renames WP.Pointer_Constraints_Unstable_V1;
   package WC renames Standard.Wayland.Cursor;

   subtype Unsigned_32 is Standard.Wayland.Unsigned_32;

   type Xdg_Surface_With_Window (Window : not null access Wayland_Window)
     is new WP.Xdg_Shell.Xdg_Surface with null record;

   type Xdg_Toplevel_With_Window (Window : not null access Wayland_Window)
     is new WP.Xdg_Shell.Xdg_Toplevel with null record;

   type Toplevel_Decoration_With_Window (Window : not null access Wayland_Window)
     is new XD.Toplevel_Decoration_V1 with null record;

   type Locked_Pointer_With_Window (Window : not null access Wayland_Window)
     is new PC.Locked_Pointer_V1 with null record;

   type Frame;

   type Feedback_With_Frame (Data : not null access Frame)
     is new WP.Presentation_Time.Presentation_Feedback with null record;

   type Frame_Index is mod 16;

   type Frame is limited record
      Window      : access Wayland_Window;
      Feedback    : Feedback_With_Frame (Frame'Access);
      Index       : Frame_Index;
      Start, Stop : Duration := 0.0;
   end record;

   type Frame_Array is array (Frame_Index) of Frame;

   function Make_Frames (Window : not null access Wayland_Window) return Frame_Array
     with Post => (for all FB of Make_Frames'Result => FB.Window /= null);

   protected type Frame_Handler_With_Window (Window : not null access Wayland_Window) is
      entry Before_Swap_Buffers (Time_To_Swap : out Duration; Do_Swap : out Boolean);
      procedure After_Swap_Buffers;

      procedure On_Frame_Output (Index : Frame_Index; Refresh : Duration);
      procedure On_Frame_Presented (Index : Frame_Index; Timestamp, Refresh : Duration);
      procedure On_Frame_Discarded (Index : Frame_Index);

      procedure Set_Size
        (Width, Height : Positive;
         Margin        : Natural;
         Serial        : Unsigned_32);

      entry Set_Has_Buffer (Value : Boolean);

      procedure Finalize;
   private
      Max_In_Flight   : Duration := 0.0;
      Latest_Stop     : Duration := 0.0;
      Default_Refresh : Duration := 0.0;

      Resize_Width, Resize_Height, Resize_Margin : Natural := 0;
      Resize_Serial : Unsigned_32;

      Has_Buffer : Boolean := False;
      Swapping   : Boolean := False;

      Pending : Natural := 0;
      Frames  : Frame_Array := Make_Frames (Window);
   end Frame_Handler_With_Window;

   type Cursor_Hotspot_Coordinate is array (AWT.Inputs.Dimension) of Natural;

   type Wayland_Window is
     abstract limited new Ada.Finalization.Limited_Controlled and AWT.Windows.Window with
   record
      Pending_State, Current_State : AWT.Windows.Window_State;
      Pending_Scale, Current_Scale : Positive := 1;

      Restore_Width  : Natural := 0;
      Restore_Height : Natural := 0;
      Restore_Margin : Natural := 0;
      Restore_ID     : SU.Unbounded_String;
      Restore_Title  : SU.Unbounded_String;

      Initial_Configure : Boolean := True;

      Surface : Surface_With_Window (Wayland_Window'Access);

      XDG_Surface  : Xdg_Surface_With_Window (Wayland_Window'Access);
      XDG_Toplevel : Xdg_Toplevel_With_Window (Wayland_Window'Access);

      Decoration   : Toplevel_Decoration_With_Window (Wayland_Window'Access);

      Frame_Handler : Frame_Handler_With_Window (Wayland_Window'Access);

      --  Wayland.EGL
      EGL_Window  : Standard.Wayland.EGL.Window;

      --  EGL
      EGL_Surface : EGL.Objects.Surfaces.Surface (EGL.Objects.Displays.Wayland);
      EGL_Context : EGL.Objects.Contexts.Context (EGL.Objects.Displays.Wayland);
      EGL_Config  : EGL.Objects.Configs.Config;
      EGL_sRGB    : Boolean;

      Should_Close : Boolean := False with Atomic;

      Idle_Inhibitor : II.Idle_Inhibitor_V1;

      Pointer_State  : AWT.Inputs.Pointer_State;
      Keyboard_State : AWT.Inputs.Keyboard_State;

      Locked_Pointer        : Locked_Pointer_With_Window (Wayland_Window'Access);
      Locked_Position       : AWT.Inputs.Coordinate;
      Unlocked_Pointer_Mode : AWT.Inputs.Pointer_Mode;
      Raw_Pointer_Motion    : Boolean := False;

      Cursor_Surface : WP.Client.Surface;
      Cursor_Hotspot : Cursor_Hotspot_Coordinate := (others => 0);
      Cursor         : AWT.Inputs.Cursors.Pointer_Cursor := AWT.Inputs.Cursors.Default;
      Cursor_Images  : Positive := 1;
   end record;

   overriding
   procedure Create_Window
     (Object                        : aliased in out Wayland_Window;
      ID, Title                     : String;
      Width, Height                 : Positive;
      Visible, Resizable, Decorated : Boolean := True;
      Transparent                   : Boolean := False);

   overriding procedure Finalize (Object : in out Wayland_Window);

   overriding
   procedure Set_Application_ID (Object : in out Wayland_Window; ID : String);

   overriding
   procedure Set_Application_Title (Object : in out Wayland_Window; Title : String);

   overriding
   procedure Set_Size (Object : in out Wayland_Window; Width, Height : Positive);

   overriding
   procedure Set_Size_Limits
     (Object : in out Wayland_Window;
      Min_Width, Min_Height, Max_Width, Max_Height : Natural);

   overriding
   procedure Set_Size_Mode (Object : in out Wayland_Window; Mode : AWT.Windows.Size_Mode);

   overriding
   procedure Set_Size_Mode
     (Object  : in out Wayland_Window;
      Mode    : AWT.Windows.Size_Mode;
      Monitor : AWT.Monitors.Monitor'Class);

   overriding
   procedure Set_Framebuffer_Scale (Object : in out Wayland_Window; Scale : Positive);

   overriding
   procedure Set_Raw_Pointer_Motion (Object : in out Wayland_Window; Enable : Boolean);

   overriding
   procedure Set_Margin
     (Object : in out Wayland_Window;
      Margin : Natural);

   overriding
   procedure Set_Visible (Object : in out Wayland_Window; Visible : Boolean);

   overriding
   procedure Set_Pointer_Cursor
     (Object : in out Wayland_Window;
      Cursor : AWT.Inputs.Cursors.Pointer_Cursor);

   overriding
   procedure Set_Pointer_Mode
     (Object : in out Wayland_Window;
      Mode   : AWT.Inputs.Pointer_Mode);

   overriding
   function Raw_Pointer_Motion (Object : Wayland_Window) return Boolean;

   overriding
   function State (Object : Wayland_Window) return AWT.Windows.Window_State;

   overriding
   function State (Object : Wayland_Window) return AWT.Windows.Framebuffer_State;

   overriding
   function State (Object : Wayland_Window) return AWT.Inputs.Pointer_State;

   overriding
   function State (Object : Wayland_Window) return AWT.Inputs.Keyboard_State;

   overriding
   procedure Close (Object : in out Wayland_Window);

   overriding
   function Should_Close (Object : Wayland_Window) return Boolean;

   overriding
   procedure Swap_Buffers (Object : in out Wayland_Window);

   overriding
   procedure Set_Vertical_Sync (Object : in out Wayland_Window; Enable : Boolean);

   overriding
   function On_Close (Object : Wayland_Window) return Boolean;

   function On_Change_Cursor
     (Object : in out Wayland_Window;
      Name   : AWT.Inputs.Cursors.Pointer_Cursor;
      Cursor : WC.Cursor'Class) return WC.Cursor_Image'Class;

end AWT.Wayland.Windows;
