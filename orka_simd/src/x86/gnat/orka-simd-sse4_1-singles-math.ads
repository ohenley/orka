--  SPDX-License-Identifier: Apache-2.0
--
--  Copyright (c) 2016 onox <denkpadje@gmail.com>
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

with Orka.SIMD.SSE.Singles;

package Orka.SIMD.SSE4_1.Singles.Math is
   pragma Pure;

   use Orka.SIMD.SSE.Singles;

   function Round (Elements : m128; Rounding : Unsigned_32) return m128
     with Import, Convention => Intrinsic, External_Name => "__builtin_ia32_roundps";

   function Round_Nearest_Integer (Elements : m128) return m128 is
     (Round (Elements, 0));
   --  Round each element to the nearest integer

   function Floor (Elements : m128) return m128 is
     (Round (Elements, 1));
   --  Round each element down to an integer value

   function Ceil (Elements : m128) return m128 is
     (Round (Elements, 2));
   --  Round each element up to an integer value

   function Round_Truncate (Elements : m128) return m128 is
     (Round (Elements, 3));
   --  Round each element to zero

end Orka.SIMD.SSE4_1.Singles.Math;
