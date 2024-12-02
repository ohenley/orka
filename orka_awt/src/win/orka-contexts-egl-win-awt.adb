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

with Win.AWT;
with AWT.Win;
with EGL;
with EGL.Objects.Configs;

package body Orka.Contexts.EGL.Win.AWT is

   overriding
   function Create_Context
     (Version : Orka.Contexts.Context_Version;
      Flags   : Orka.Contexts.Context_Flags := (others => False)) return AWT_Context is
   begin
      if not Standard.AWT.Is_Initialized then
         Standard.AWT.Initialize;
      end if;

      declare
         D : Standard.Win.Display := Standard.AWT.Win.Get_Display.all;
         ND : Standard.EGL.Native_Display_Ptr := Standard.Win.AWT.Get_Display (D);
      begin
         return Create_Context (ND, Version, Flags);
      end;
   
   end Create_Context;

   overriding
   function Create_Window
     (Context            : aliased in out Orka.Contexts.Surface_Context'Class;
      Width, Height      : Positive;
      Title              : String  := "";
      Samples            : Natural := 0;
      Visible, Resizable : Boolean := True;
      Transparent        : Boolean := False) return AWT_Window
   is
      package EGL_Configs renames Standard.EGL.Objects.Configs;

      use all type Standard.EGL.Objects.Contexts.Buffer_Kind;

      package SU renames Standard.AWT.SU;

      function Flags return String is
         Result : SU.Unbounded_String;
      begin
         if Visible then
            SU.Append (Result, " visible");
         end if;

         if Resizable then
            SU.Append (Result, " resizable");
         end if;

         if Transparent then
            SU.Append (Result, " transparent");
         end if;

         return SU.To_String (Result)(2 .. SU.Length (Result));
      end Flags;

      Object : AWT_Context renames AWT_Context (Context);
   begin
      return Result : AWT_Window (Context => Object'Access) do
         declare
            Configs : constant EGL_Configs.Config_Array :=
              EGL_Configs.Get_Configs
                (Object.Context.Display,
                 8, 8, 8, (if Transparent then 8 else 0),
                 24, 8, EGL_Configs.Sample_Size (Samples));

            Used_Config : EGL_Configs.Config renames Configs (Configs'First);
         begin
            -- Result.Set_EGL_Data (Object.Context, Used_Config, sRGB => False);

            Result.Create_Window ("", Title, Width, Height,
              Visible     => Visible,
              Resizable   => Resizable,
              Decorated   => True,
              Transparent => Transparent);

            Result.Make_Current (Object.Context);

            pragma Assert (Object.Context.Buffer = Back);

         end;
      end return;
   end Create_Window;

   function Framebuffer_Resized (Object : in out AWT_Window) return Boolean is
      Result : constant Boolean := Object.Resize;
   begin
      Object.Resize := False;
      return Result;
   end Framebuffer_Resized;

   overriding
   procedure Make_Current
     (Object : AWT_Context;
      Window : in out Orka.Windows.Window'Class) is
   begin
      if Window not in AWT_Window'Class then
         raise Constraint_Error;
      end if;

      AWT_Window (Window).Make_Current (Object.Context);
   end Make_Current;

   overriding
   function Width (Object : AWT_Window) return Positive is
   begin
      return 1;
   end Width;

   overriding
   function Height (Object : AWT_Window) return Positive is
   begin
      return 1;
   end Height;

   ----------------------------------------------------------------------------

   overriding
   procedure On_Configure
     (Object : in out AWT_Window;
      State  : Standard.AWT.Windows.Window_State) is
   begin
      null;
   end On_Configure;

   overriding
   procedure On_Move
     (Object   : in out AWT_Window;
      Monitor  : Standard.AWT.Monitors.Monitor'Class;
      Presence : Standard.AWT.Windows.Monitor_Presence) is
   begin
      null;
   end On_Move;
   
end Orka.Contexts.EGL.Win.AWT;
