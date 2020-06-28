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

with Ada.Unchecked_Conversion;

with EGL.API;
with EGL.Errors;

package body EGL.Objects.Contexts is

   Major_Version       : constant Int := 16#3098#;
   Minor_Version       : constant Int := 16#30FB#;
   Context_Flags_Bits  : constant Int := 16#30FC#;
   OpenGL_Profile_Mask : constant Int := 16#30FD#;

   --  EGL 1.5
--   OpenGL_Debug                       : constant Int := 16#31B0#;
--   OpenGL_Forward_Compatible          : constant Int := 16#31B1#;
--   OpenGL_Robust                      : constant Int := 16#31B2#;

   OpenGL_No_Error                    : constant Int := 16#31B3#;
   OpenGL_Reset_Notification_Strategy : constant Int := 16#31BD#;

   No_Reset_Notification : constant Int := 16#31BE#;
   Lose_Context_On_Reset : constant Int := 16#31BF#;

   OpenGL_Core_Profile : constant Int := 16#0000_0001#;

   type Flag_Bits is record
      Debug   : Boolean := False;
      Forward : Boolean := True;
      Robust  : Boolean := False;
   end record;

   for Flag_Bits use record
      Debug   at 0 range 0 .. 0;
      Forward at 0 range 1 .. 1;
      Robust  at 0 range 2 .. 2;
   end record;
   for Flag_Bits'Size use Int'Size;

   function Create_Context
     (Display : Displays.Display;
      Version : Context_Version;
      Flags   : Context_Flags) return Context
   is
      No_Config  : constant ID_Type := ID_Type (System.Null_Address);
      No_Context : constant ID_Type := ID_Type (System.Null_Address);
      No_Surface : constant ID_Type := ID_Type (System.Null_Address);

      function Convert is new Ada.Unchecked_Conversion (Flag_Bits, Int);

      Flags_Mask : constant Flag_Bits :=
        (Debug   => Flags.Debug,
         Forward => True,
         Robust  => Flags.Robust);

      Attributes : constant Int_Array :=
        (Major_Version, Int (Version.Major),
         Minor_Version, Int (Version.Minor),
         Context_Flags_Bits, Convert (Flags_Mask),
         OpenGL_Profile_Mask, OpenGL_Core_Profile,

         --  EGL 1.5
--         OpenGL_Debug, (if Flags.Debug then 1 else 0),
--         OpenGL_Forward_Compatible, 1,
--         OpenGL_Robust, (if Flags.Robust then 1 else 0),

         OpenGL_Reset_Notification_Strategy,
           (if Flags.Robust then Lose_Context_On_Reset else No_Reset_Notification));

      No_Error : constant Int_Array := (OpenGL_No_Error, 1);

      Extensions : constant String_List := Display.Extensions;
   begin
      if not Boolean (API.Bind_API (OpenGL_API)) then
         Errors.Raise_Exception_On_EGL_Error;
      end if;

      Check_Extension (Extensions, "EGL_KHR_create_context");
      Check_Extension (Extensions, "EGL_KHR_no_config_context");
      Check_Extension (Extensions, "EGL_KHR_surfaceless_context");

      declare
         Can_Have_No_Error : constant Boolean :=
           Flags.No_Error and then Has_Extension (Extensions, "EGL_KHR_create_context_no_error");

         ID : constant ID_Type :=
           API.Create_Context (Display.ID, No_Config, No_Context,
             Attributes & (if Can_Have_No_Error then No_Error else (1 .. 0 => <>)) & None);
      begin
         if ID = No_Context then
            Errors.Raise_Exception_On_EGL_Error;
         end if;

         --  TODO Support attaching a surface later (+ set viewport, scissor, draw and read buffer)
         if not API.Make_Current (Display.ID, No_Surface, No_Surface, ID) then
            Errors.Raise_Exception_On_EGL_Error;
         end if;

         return Result : Context (Display.Platform) do
            Result.Reference.ID := ID;
            Result.Display      := Display;
         end return;
      end;
   end Create_Context;

   overriding procedure Pre_Finalize (Object : in out Context) is
      No_Context : constant ID_Type := ID_Type (System.Null_Address);
   begin
      pragma Assert (Object.ID /= No_Context);
      if not Boolean (API.Destroy_Context (Object.Display.ID, Object.ID)) then
         Errors.Raise_Exception_On_EGL_Error;
      end if;
      Object.Reference.ID := No_Context;
   end Pre_Finalize;

end EGL.Objects.Contexts;
