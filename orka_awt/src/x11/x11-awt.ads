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

private with Ada.Unchecked_Conversion;

with EGL;

package X11.AWT is
   pragma Preelaborate;

   ----------------------------------------------------------------------------
   --                          Internal Subprograms                          --
   ----------------------------------------------------------------------------

   function Get_Display (Display : Standard.X11.Display) return Standard.EGL.Native_Display_Ptr;

private

   function Convert is new Ada.Unchecked_Conversion
     (Source => Standard.X11.X_Display_Access, Target => Standard.EGL.Native_Display_Ptr);

end X11.AWT;