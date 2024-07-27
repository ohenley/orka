--  SPDX-License-Identifier: Apache-2.0
--
--  Copyright (c) 2024 onox <denkpadje@gmail.com>
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

with Orka.SIMD.AVX2.Longs.Compare;
with Orka.SIMD.AVX2.Longs.Swizzle;

package body Orka.SIMD.AVX2.Longs.Math.Emulation is

   use SIMD.AVX2.Longs.Compare;
   use SIMD.AVX2.Longs.Swizzle;

   function Min (Left, Right : m256l) return m256l is
     (Blend (Left, Right, Right < Left));

   function Max (Left, Right : m256l) return m256l is
     (Blend (Left, Right, Right > Left));

end Orka.SIMD.AVX2.Longs.Math.Emulation;
