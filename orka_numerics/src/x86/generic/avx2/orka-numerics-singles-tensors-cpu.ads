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

with Orka.Numerics.Tensors.SIMD_CPU;

with Orka.SIMD.AVX.Singles.Arithmetic;
with Orka.SIMD.AVX.Singles.Compare;
with Orka.SIMD.AVX.Singles.Logical;
with Orka.SIMD.AVX.Singles.Math;
with Orka.SIMD.AVX2.Integers.Arithmetic;
with Orka.SIMD.AVX2.Integers.Logical;
with Orka.SIMD.AVX2.Integers.Random;
with Orka.SIMD.AVX2.Integers.Shift;
with Orka.SIMD.AVX.Integers.Logical;

package Orka.Numerics.Singles.Tensors.CPU is new Orka.Numerics.Singles.Tensors.SIMD_CPU
  (SIMD.AVX.Index_Double_Homogeneous,
   Integer_32,
   SIMD.AVX.Integers.m256i,
   SIMD.AVX2.Integers.Arithmetic."+",
   SIMD.AVX2.Integers.Logical."and",
   SIMD.AVX2.Integers.Shift.Shift_Elements_Left_Zeros,
   SIMD.AVX2.Integers.Shift.Shift_Elements_Right_Zeros,
   SIMD.AVX.Integers.Logical.Test_All_Ones,
   SIMD.AVX.Integers.Logical.Test_All_Zero,
   SIMD.AVX.Singles.m256,
   SIMD.AVX.Singles.Arithmetic."*",
   SIMD.AVX.Singles.Arithmetic."/",
   SIMD.AVX.Singles.Arithmetic."+",
   SIMD.AVX.Singles.Arithmetic."-",
   SIMD.AVX.Singles.Arithmetic."-",
   SIMD.AVX.Singles.Arithmetic."abs",
   SIMD.AVX.Singles.Arithmetic.Sum,
   SIMD.AVX.Singles.Arithmetic.Divide_Or_Zero,
   SIMD.AVX.Singles.Math.Sqrt,
   SIMD.AVX.Singles.Math.Min,
   SIMD.AVX.Singles.Math.Max,
   SIMD.AVX.Singles.Math.Ceil,
   SIMD.AVX.Singles.Math.Floor,
   SIMD.AVX.Singles.Math.Round_Nearest_Integer,
   SIMD.AVX.Singles.Math.Round_Truncate,
   SIMD.AVX.Singles.Logical.And_Not,
   SIMD.AVX.Singles.Logical."and",
   SIMD.AVX.Singles.Logical."or",
   SIMD.AVX.Singles.Logical."xor",
   SIMD.AVX.Singles.Compare."=",
   SIMD.AVX.Singles.Compare."/=",
   SIMD.AVX.Singles.Compare.">",
   SIMD.AVX.Singles.Compare."<",
   SIMD.AVX.Singles.Compare.">=",
   SIMD.AVX.Singles.Compare."<=",
   SIMD.AVX2.Integers.Random.State,
   SIMD.AVX2.Integers.Random.Next,
   SIMD.AVX2.Integers.Random.Reset);
pragma Preelaborate (Orka.Numerics.Singles.Tensors.CPU);
