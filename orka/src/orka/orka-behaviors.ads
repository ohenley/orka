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

with Orka.Transforms.Doubles.Vectors;

package Orka.Behaviors is
   pragma Preelaborate;

   subtype Vector4 is Orka.Transforms.Doubles.Vectors.Vector4;

   type Visibility is (Invisible, Visible);

   -----------------------------------------------------------------------------

   type Behavior is limited interface;

   type Behavior_Ptr is not null access all Behavior'Class;

   function Position (Object : Behavior) return Vector4 is abstract;

   procedure Fixed_Update (Object : in out Behavior; Delta_Time : Duration) is null;
   --  Called zero to multiple times per frame and before Update
   --
   --  Fixed_Update can be used to perform physics or other computations
   --  that require a stable Delta_Time that does not depend on the frame
   --  rate. If the game needs to catch up then Fixed_Update is called
   --  multiple times. If the game renders at a very high frame rate then
   --  Fixed_Update will not be called at all.

   procedure Update (Object : in out Behavior; Delta_Time : Duration) is null;
   --  Called once per frame and after any calls to Fixed_Update

   procedure After_Update
     (Object : in out Behavior;
      Delta_Time    : Duration;
      View_Position : Vector4) is null;
   --  Called once per frame and after Update

   procedure Visibility_Changed (Object : in out Behavior; State : Visibility) is null;

   procedure Render (Object : in out Behavior) is null;

   procedure After_Render (Object : in out Behavior) is null;

   -----------------------------------------------------------------------------

   type Behavior_Array is array (Positive range <>) of Behaviors.Behavior_Ptr;

   type Behavior_Array_Access is access Behavior_Array;

   Null_Behavior : constant Behavior_Ptr;

   function Empty_Behavior_Array return Behavior_Array_Access;

private

   type Origin_Behavior is new Behavior with null record;

   overriding
   function Position (Object : Origin_Behavior) return Vector4 is
     ((0.0, 0.0, 0.0, 1.0));

   Null_Behavior : constant Behavior_Ptr := new Origin_Behavior;

   function Empty_Behavior_Array return Behavior_Array_Access is
     (new Behavior_Array'(1 .. 0 => Null_Behavior));

end Orka.Behaviors;
