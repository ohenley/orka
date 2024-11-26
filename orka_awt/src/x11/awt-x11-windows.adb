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

package body AWT.X11.Windows is

   procedure Make_Current
     (Object  : in out X11_Window;
      Context : Standard.EGL.Objects.Contexts.Context) is
   begin
      null;
   end Make_Current;

   overriding
   procedure Create_Window
     (Object                        : aliased in out X11_Window;
      ID, Title                     : String;
      Width, Height                 : Positive;
      Visible, Resizable, Decorated : Boolean := True;
      Transparent                   : Boolean := False) is
   begin
      null;
   end Create_Window;

   overriding
   procedure Finalize (Object : in out X11_Window) is
   begin
      null;
   end Finalize;

   overriding
   procedure Set_Application_ID (Object : in out X11_Window; ID : String) is
   begin
      null;
   end Set_Application_ID;

   overriding
   procedure Set_Title (Object : in out X11_Window; Title : String) is
   begin
      null;
   end Set_Title;

   overriding
   procedure Set_Size (Object : in out X11_Window; Width, Height : Positive) is
   begin
      null;
   end Set_Size;

   overriding
   procedure Set_Size_Limits
     (Object : in out X11_Window;
      Min_Width, Min_Height, Max_Width, Max_Height : Natural) is
   begin
      null;
   end Set_Size_Limits;

   overriding
   procedure Set_Size_Mode (Object : in out X11_Window; Mode : AWT.Windows.Size_Mode) is
   begin
      null;
   end Set_Size_Mode;

   overriding
   procedure Set_Size_Mode
     (Object  : in out X11_Window;
      Mode    : AWT.Windows.Size_Mode;
      Monitor : AWT.Monitors.Monitor'Class) is
   begin
      null;
   end Set_Size_Mode;

   overriding
   procedure Set_Framebuffer_Scale (Object : in out X11_Window; Scale : Positive) is
   begin
      null;
   end Set_Framebuffer_Scale;

   overriding
   procedure Set_Raw_Pointer_Motion (Object : in out X11_Window; Enable : Boolean) is
   begin
      null;
   end Set_Raw_Pointer_Motion;

   overriding
   procedure Set_Margin
     (Object : in out X11_Window;
      Margin : Natural) is
   begin
      null;
   end Set_Margin;

   overriding
   procedure Set_Visible (Object : in out X11_Window; Visible : Boolean) is
   begin
      null;
   end Set_Visible;

   overriding
   procedure Set_Pointer_Cursor
     (Object : in out X11_Window;
      Cursor : AWT.Inputs.Cursors.Pointer_Cursor) is
   begin
      null;
   end Set_Pointer_Cursor;

   overriding
   procedure Set_Pointer_Mode
     (Object : in out X11_Window;
      Mode   : AWT.Inputs.Pointer_Mode) is
   begin
      null;
   end Set_Pointer_Mode;

   overriding
   function Raw_Pointer_Motion (Object : X11_Window) return Boolean is
   begin
      return False;
   end Raw_Pointer_Motion;

   overriding
   function State (Object : X11_Window) return AWT.Windows.Window_State is 
      (others => <>);

   overriding
   function State (Object : X11_Window) return AWT.Windows.Framebuffer_State is
      (others => <>);

   overriding
   function State (Object : in out X11_Window) return AWT.Inputs.Pointer_State is
      (others => <>);

   overriding
   function State (Object : in out X11_Window) return AWT.Inputs.Keyboard_State is
      (others => <>);

   overriding
   procedure Close (Object : in out X11_Window) is
   begin
      null;
   end Close;

   overriding
   function Should_Close (Object : X11_Window) return Boolean is
   begin
      return False;
   end Should_Close;

   overriding
   procedure Swap_Buffers (Object : in out X11_Window) is
   begin
      null;
   end Swap_Buffers;

   overriding
   procedure Set_Vertical_Sync (Object : in out X11_Window; Enable : Boolean) is
   begin
      null;
   end Set_Vertical_Sync;

   overriding
   function On_Close (Object : X11_Window) return Boolean is
   begin
      return False;
   end On_Close;


end AWT.X11.Windows;