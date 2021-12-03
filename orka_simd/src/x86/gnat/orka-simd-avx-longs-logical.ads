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

package Orka.SIMD.AVX.Longs.Logical is
   pragma Pure;

   function Test_All_Zero (Elements, Mask : m256l) return Boolean
     with Inline_Always;

   function Test_All_Ones (Elements, Mask : m256l) return Boolean
     with Inline_Always;

   function Test_Mix_Ones_Zeros (Elements, Mask : m256l) return Boolean
     with Inline_Always;

end Orka.SIMD.AVX.Longs.Logical;
