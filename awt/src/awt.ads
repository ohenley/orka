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

package AWT with SPARK_Mode => On is
   pragma Preelaborate;

   function Is_Initialized return Boolean;

   procedure Initialize
     with Pre  => not Is_Initialized,
          Post =>     Is_Initialized;
   --  Initialize the AWT library
   --
   --  On the Wayland platform this will open a connection to the
   --  compositor and bind some objects for a few Wayland interfaces.
   --  If one wants to be able to bind additional objects for interfaces
   --  with which AWT is not familiar, set a callback with
   --  AWT.Wayland.Set_Callback before calling this procedure.

   function Process_Events return Boolean
     with Pre => Is_Initialized;

   function Process_Events (Timeout : Duration) return Boolean
     with Pre => Is_Initialized;

   Initialization_Error : exception;

   Internal_Error : exception;

end AWT;
