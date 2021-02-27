--  SPDX-License-Identifier: Apache-2.0
--
--  Copyright (c) 2017 onox <denkpadje@gmail.com>
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

limited with Orka.Contexts;

with Orka.Inputs.Pointers;

package Orka.Windows is
   pragma Preelaborate;

   type Window is limited interface;

   type Window_Ptr is not null access all Window'Class;

   function Create_Window
     (Context            : Contexts.Surface_Context'Class;
      Width, Height      : Positive;
      Samples            : Natural := 0;
      Visible, Resizable : Boolean := True) return Window is abstract;

   function Pointer_Input
     (Object : Window) return Inputs.Pointers.Pointer_Input_Ptr is abstract;

   function Width (Object : Window) return Positive is abstract;

   function Height (Object : Window) return Positive is abstract;

   procedure Set_Title (Object : in out Window; Value : String) is abstract;
   --  Set the title of the window
   --
   --  Task safety: Must only be called from the environment task.

   procedure Close (Object : in out Window) is abstract;

   function Should_Close (Object : in out Window) return Boolean is abstract;

   procedure Process_Input (Object : in out Window) is abstract;
   --  Process window and input events
   --
   --  Task safety: Must only be called from the environment task.

   procedure Swap_Buffers (Object : in out Window) is abstract;
   --  Swap the front and back buffers of the window
   --
   --  Task safety: Must only be called from the rendering task.

   procedure Enable_Vertical_Sync (Object : in out Window; Enable : Boolean) is abstract;
   --  Request the vertical retrace synchronization or vsync to be enabled
   --  or disabled
   --
   --  Vsync causes the video driver to wait for a screen update before
   --  swapping the buffers. The video driver may ignore the request.
   --  Enablng vsync avoids tearing.

end Orka.Windows;
