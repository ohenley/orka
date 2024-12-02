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

private with Orka.OS;

private with EGL.Objects.Displays;
private with EGL.Objects.Surfaces;


with EGL.Objects.Configs;
with EGL.Objects.Contexts;

with AWT.Inputs;
with AWT.Monitors;
with AWT.Windows;

package AWT.Win.Windows is
   pragma Preelaborate;

   type Win_Window is limited new AWT.Windows.Window with private;

   procedure Make_Current
     (Object  : in out Win_Window;
      Context : Standard.EGL.Objects.Contexts.Context);

private

   type Win_Window is
     limited new Ada.Finalization.Limited_Controlled and AWT.Windows.Window with null record;

   overriding
   procedure Create_Window
     (Object                        : aliased in out Win_Window;
      ID, Title                     : String;
      Width, Height                 : Positive;
      Visible, Resizable, Decorated : Boolean := True;
      Transparent                   : Boolean := False);

   overriding
   procedure Finalize (Object : in out Win_Window);

   overriding
   procedure Set_Application_ID (Object : in out Win_Window; ID : String);

   overriding
   procedure Set_Title (Object : in out Win_Window; Title : String);

   overriding
   procedure Set_Size (Object : in out Win_Window; Width, Height : Positive);

   overriding
   procedure Set_Size_Limits
     (Object : in out Win_Window;
      Min_Width, Min_Height, Max_Width, Max_Height : Natural);

   overriding
   procedure Set_Size_Mode (Object : in out Win_Window; Mode : AWT.Windows.Size_Mode);

   overriding
   procedure Set_Size_Mode
     (Object  : in out Win_Window;
      Mode    : AWT.Windows.Size_Mode;
      Monitor : AWT.Monitors.Monitor'Class);

   overriding
   procedure Set_Framebuffer_Scale (Object : in out Win_Window; Scale : Positive);

   overriding
   procedure Set_Raw_Pointer_Motion (Object : in out Win_Window; Enable : Boolean);

   overriding
   procedure Set_Margin
     (Object : in out Win_Window;
      Margin : Natural);

   overriding
   procedure Set_Visible (Object : in out Win_Window; Visible : Boolean);

   overriding
   procedure Set_Pointer_Cursor
     (Object : in out Win_Window;
      Cursor : AWT.Inputs.Cursors.Pointer_Cursor);

   overriding
   procedure Set_Pointer_Mode
     (Object : in out Win_Window;
      Mode   : AWT.Inputs.Pointer_Mode);

   overriding
   function Raw_Pointer_Motion (Object : Win_Window) return Boolean;

   overriding
   function State (Object : Win_Window) return AWT.Windows.Window_State;

   overriding
   function State (Object : Win_Window) return AWT.Windows.Framebuffer_State;

   overriding
   function State (Object : in out Win_Window) return AWT.Inputs.Pointer_State;

   overriding
   function State (Object : in out Win_Window) return AWT.Inputs.Keyboard_State;

   overriding
   procedure Close (Object : in out Win_Window);

   overriding
   function Should_Close (Object : Win_Window) return Boolean;

   overriding
   procedure Swap_Buffers (Object : in out Win_Window);

   overriding
   procedure Set_Vertical_Sync (Object : in out Win_Window; Enable : Boolean);

   overriding
   function On_Close (Object : Win_Window) return Boolean;


end AWT.Win.Windows;
