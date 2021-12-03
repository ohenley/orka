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

with Orka.SIMD.AVX.Longs.Convert;
with Orka.SIMD.AVX.Doubles.Arithmetic;
with Orka.SIMD.AVX2.Longs.Shift;

package Orka.SIMD.AVX2.Longs.Convert is
   pragma Pure;

   use SIMD.AVX.Doubles;
   use SIMD.AVX.Doubles.Arithmetic;
   use SIMD.AVX2.Longs.Shift;

   function Convert (Elements : m256l) return m256d renames SIMD.AVX.Longs.Convert.Convert;

   Smallest_Elements : constant m256d := (others => 2.0**(-Float_64'Machine_Mantissa));

   function To_Unit_Floats (Elements : m256l) return m256d is
     (Convert (Shift_Bits_Right_Zeros (Elements, Float_64'Size - Float_64'Machine_Mantissa))
        * Smallest_Elements)
   with Inline;
   --  Return floating-point numbers in the 0 .. 1 interval

end Orka.SIMD.AVX2.Longs.Convert;
