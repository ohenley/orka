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

with Ada.Containers.Indefinite_Hashed_Maps;
with Ada.Strings.Hash;

with GL.Types;

with Orka.Containers.Bounded_Vectors;

package Orka.glTF.Meshes is
   pragma Preelaborate;

   subtype Primitive_Mode is GL.Types.Connection_Mode
     range GL.Types.Points .. GL.Types.Triangle_Strip;

   package Attribute_Maps is new Ada.Containers.Indefinite_Hashed_Maps
     (Key_Type        => String,
      Element_Type    => Natural,
      Hash            => Ada.Strings.Hash,
      Equivalent_Keys => "=");

   type Primitive is record
      Attributes : Attribute_Maps.Map;
      Indices    : Natural_Optional;
      Material   : Natural_Optional;
      Mode       : Primitive_Mode;
   end record;

   package Primitive_Vectors is new Orka.Containers.Bounded_Vectors (Natural, Primitive);

   type Mesh is record
      --  Orka.Resources.Models.glTF can handle only one primitive per mesh
      Primitives : Primitive_Vectors.Vector (Capacity => 1);
      Name       : SU.Unbounded_String;
   end record;

   package Mesh_Vectors is new Orka.Containers.Bounded_Vectors (Natural, Mesh);

   function Get_Meshes
     (Meshes : Types.JSON_Value) return Mesh_Vectors.Vector;

end Orka.glTF.Meshes;
