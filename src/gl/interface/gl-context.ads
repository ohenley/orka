--  SPDX-License-Identifier: Apache-2.0
--
--  Copyright (c) 2013 Felix Krause <contact@flyx.org>
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

with Ada.Strings.Unbounded;

package GL.Context is
   pragma Preelaborate;

   type String_List is array (Positive range <>) of
     Ada.Strings.Unbounded.Unbounded_String;

   function Major_Version return Natural;
   function Minor_Version return Natural;
   --  These two require OpenGL 3

   function Version_String return String;
   --  Legacy (deprecated in OpenGL 3)

   function Vendor return String;
   function Renderer return String;

   function Extensions return String_List;
   function Has_Extension
     (Extensions : String_List;
      Name       : String) return Boolean;
   --  Uses OpenGL 3 interface

   function Primary_Shading_Language_Version return String;

   function Supported_Shading_Language_Versions return String_List;
   function Supports_Shading_Language_Version
     (Versions : String_List;
      Name     : String) return Boolean;
   --  Available since OpenGL 4.3
end GL.Context;
