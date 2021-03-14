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

with Orka.Transforms.Doubles.Matrices;
with Orka.Transforms.Doubles.Matrix_Conversions;

package body Orka.Cameras.Look_From_Cameras is

   procedure Set_Orientation
     (Object : in out Look_From_Camera;
      Roll, Pitch, Yaw : Angle) is
   begin
      Object.Roll  := Roll;
      Object.Pitch := Pitch;
      Object.Yaw   := Yaw;
   end Set_Orientation;

   overriding
   procedure Update (Object : in out Look_From_Camera; Delta_Time : Duration) is
      Using_Camera : constant Boolean := Object.Input.Button_Pressed (Inputs.Pointers.Right);
   begin
      Object.Input.Lock_Pointer (Using_Camera);

      if Using_Camera then
         Object.Yaw   := Normalize_Angle (Object.Yaw   + Object.Input.Delta_X * Object.Scale (X));
         Object.Pitch := Normalize_Angle (Object.Pitch + Object.Input.Delta_Y * Object.Scale (Y));
      end if;
   end Update;

   use Orka.Transforms.Doubles.Matrices;
   use Orka.Transforms.Doubles.Matrix_Conversions;

   overriding
   function View_Matrix (Object : Look_From_Camera) return Transforms.Matrix4 is
     (Convert (Ry (Object.Roll) * Rx (Object.Pitch) * Ry (Object.Yaw) * Object.Rotate_To_Up));

   overriding
   function View_Matrix_Inverse (Object : Look_From_Camera) return Transforms.Matrix4 is
     (Convert (Transpose (Object.Rotate_To_Up) *
        Ry (-Object.Yaw) * Rx (-Object.Pitch) * Ry (-Object.Roll)));

   overriding
   function Create_Camera
     (Input : Inputs.Pointers.Pointer_Input_Ptr;
      Lens  : Lens_Ptr;
      FB    : aliased Rendering.Framebuffers.Framebuffer) return Look_From_Camera is
   begin
      return Look_From_Camera'(Camera with
        Input  => Input,
        Lens   => Lens,
        FB     => FB'Access,
        others => <>);
   end Create_Camera;

end Orka.Cameras.Look_From_Cameras;
