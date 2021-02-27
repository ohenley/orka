--  SPDX-License-Identifier: Apache-2.0
--
--  Copyright (c) 2020 onox <denkpadje@gmail.com>
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

private with GL.Objects.Vertex_Arrays;

private with EGL.Objects.Displays;
private with EGL.Objects.Contexts;

with EGL.Objects.Devices;

package Orka.Contexts.EGL is

   type Wayland_EGL_Context is limited new Context with private;

   overriding
   function Create_Context
     (Version : Context_Version;
      Flags   : Context_Flags := (others => False)) return Wayland_EGL_Context;
   --  Raise Program_Error due to the missing native Wayland display
   --
   --  This function must be overriden and internally call the function below.

   function Create_Context
     (Window  : Standard.EGL.Native_Display_Ptr;
      Version : Context_Version;
      Flags   : Context_Flags := (others => False)) return Wayland_EGL_Context;
   --  Return a Wayland EGL context

   type Device_EGL_Context is limited new Context with private;

   overriding
   function Create_Context
     (Version : Context_Version;
      Flags   : Context_Flags := (others => False)) return Device_EGL_Context;
   --  Return a surfaceless EGL context using the default device

   function Create_Context
     (Device  : Standard.EGL.Objects.Devices.Device;
      Version : Context_Version;
      Flags   : Context_Flags := (others => False)) return Device_EGL_Context;
   --  Return a surfaceless EGL context using the given device

private

   type EGL_Context is abstract
     limited new Ada.Finalization.Limited_Controlled and Context with
   record
      Version  : Context_Version;
      Flags    : Context_Flags;
      Features : Feature_Array := (others => False);
      Vertex_Array : GL.Objects.Vertex_Arrays.Vertex_Array_Object;
   end record;

   overriding
   procedure Finalize (Object : in out EGL_Context);

   overriding
   procedure Enable (Object : in out EGL_Context; Subject : Feature);

   overriding
   function Enabled (Object : EGL_Context; Subject : Feature) return Boolean;

   overriding
   function Version (Object : EGL_Context) return Context_Version is (Object.Version);

   overriding
   function Flags (Object : EGL_Context) return Context_Flags is (Object.Flags);

   type Device_EGL_Context is limited new EGL_Context with record
      Context : Standard.EGL.Objects.Contexts.Context (Standard.EGL.Objects.Displays.Device);
   end record;

   overriding
   function Is_Current (Object : Device_EGL_Context) return Boolean is
     (Object.Context.Is_Current);

   overriding
   procedure Make_Current (Object : Device_EGL_Context);

   overriding
   procedure Make_Not_Current (Object : Device_EGL_Context);

   type Wayland_EGL_Context is limited new EGL_Context with record
      Context : Standard.EGL.Objects.Contexts.Context (Standard.EGL.Objects.Displays.Wayland);
   end record;

   overriding
   function Is_Current (Object : Wayland_EGL_Context) return Boolean is
     (Object.Context.Is_Current);

   overriding
   procedure Make_Current (Object : Wayland_EGL_Context);

   overriding
   procedure Make_Not_Current (Object : Wayland_EGL_Context);

end Orka.Contexts.EGL;