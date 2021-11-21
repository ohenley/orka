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

with Orka.SIMD.AVX2.Integers.Arithmetic;
with Orka.SIMD.AVX2.Integers.Convert;
with Orka.SIMD.AVX2.Integers.Logical;
with Orka.SIMD.AVX2.Integers.Shift;

package body Orka.SIMD.AVX2.Integers.Random is

   --  This is an Ada port of xoshiro128++ random number generator.
   --
   --  https://arxiv.org/abs/1805.01407
   --  doi:10.1145/3460772
   --  https://arxiv.org/abs/1910.06437
   --
   --  David Blackman and Sebastiano Vigna.
   --  Scrambled linear pseudorandom number generators. ACM Trans. Math. Softw., 47:1−32, 2021.
   --
   --  The following comment is from https://prng.di.unimi.it/xoshiro128plusplus.c:
   --
   --  /*  Written in 2019 by David Blackman and Sebastiano Vigna (vigna@acm.org)
   --
   --  To the extent possible under law, the author has dedicated all copyright
   --  and related and neighboring rights to this software to the public domain
   --  worldwide. This software is distributed without any warranty.
   --
   --  See <http://creativecommons.org/publicdomain/zero/1.0/>. */
   --
   --  /* This is xoshiro128++ 1.0, one of our 32-bit all-purpose, rock-solid
   --     generators. It has excellent speed, a state size (128 bits) that is
   --     large enough for mild parallelism, and it passes all tests we are aware
   --     of.
   --
   --     For generating just single-precision (i.e., 32-bit) floating-point
   --     numbers, xoshiro128+ is even faster.
   --
   --     The state must be seeded so that it is not everywhere zero. */
   procedure Next (S : in out State; Value : out m256i) is
      use Orka.SIMD.AVX2.Integers.Arithmetic;
      use Orka.SIMD.AVX2.Integers.Logical;
      use Orka.SIMD.AVX2.Integers.Shift;

      function Rotate_Left (X : m256i; K : Bits_Count) return m256i is
        (Shift_Bits_Left_Zeros (X, K) or Shift_Bits_Right_Zeros (X, 32 - K));

      --  xoshiro128++ (xoshiro128+ is just S (0) + S (3))
      Result : constant m256i := Rotate_Left (S (0) + S (3), 7) + S (0);

      T : constant m256i := Shift_Bits_Left_Zeros (S (1), 9);
   begin
      S (2) := S (2) xor S (0);
      S (3) := S (3) xor S (1);
      S (1) := S (1) xor S (2);
      S (0) := S (0) xor S (3);

      S (2) := S (2) xor T;

      S (3) := Rotate_Left (S (3), 11);

      Value := Result;
   end Next;

   procedure Next (S : in out State; Value : out m256) is
      Result : m256i;
   begin
      Next (S, Result);
      Value := SIMD.AVX2.Integers.Convert.To_Unit_Floats (Result);
   end Next;

   procedure Reset (S : out State; Seed : Integer_32) is
   begin
      for I in S'Range loop
         S (I) :=
           (Seed + 0,
            Seed + 1,
            Seed + 2,
            Seed + 3,
            Seed + 4,
            Seed + 5,
            Seed + 6,
            Seed + 7);
      end loop;
   end Reset;

end Orka.SIMD.AVX2.Integers.Random;
