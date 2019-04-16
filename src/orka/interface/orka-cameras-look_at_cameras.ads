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

package Orka.Cameras.Look_At_Cameras is
   pragma Preelaborate;

   type Look_At_Camera is new First_Person_Camera and Observing_Camera with private;

   overriding
   procedure Look_At
     (Object : in out Look_At_Camera;
      Target : Behaviors.Behavior_Ptr);

   procedure Set_Up_Direction
     (Object    : in out Look_At_Camera;
      Direction : Transforms.Vector4);

   overriding
   function View_Matrix (Object : Look_At_Camera) return Transforms.Matrix4;

   overriding
   procedure Update (Object : in out Look_At_Camera; Delta_Time : Duration) is null;
   --  Look_At camera does not need to implement Update because the
   --  view matrix does not depend on the pointer (it is computed using
   --  the camera's and target's positions)

   overriding
   function Create_Camera
     (Input : Inputs.Pointers.Pointer_Input_Ptr;
      Lens  : Lens_Ptr;
      FB    : Rendering.Framebuffers.Framebuffer_Ptr) return Look_At_Camera;

private

   type Look_At_Camera is new First_Person_Camera and Observing_Camera with record
      Target : Behaviors.Behavior_Ptr := Behaviors.Null_Behavior;
      Up     : Transforms.Vector4 := (0.0, 1.0, 0.0, 0.0);
   end record;

end Orka.Cameras.Look_At_Cameras;
