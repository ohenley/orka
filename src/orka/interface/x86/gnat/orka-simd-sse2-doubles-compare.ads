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

package Orka.SIMD.SSE2.Doubles.Compare is
   pragma Preelaborate;

   function "=" (Left, Right : m128d) return m128d
     with Import, Convention => Intrinsic, External_Name => "__builtin_ia32_cmpeqpd";

   function ">=" (Left, Right : m128d) return m128d
     with Import, Convention => Intrinsic, External_Name => "__builtin_ia32_cmpgepd";

   function ">" (Left, Right : m128d) return m128d
     with Import, Convention => Intrinsic, External_Name => "__builtin_ia32_cmpgtpd";

   function "<=" (Left, Right : m128d) return m128d
     with Import, Convention => Intrinsic, External_Name => "__builtin_ia32_cmplepd";

   function "<" (Left, Right : m128d) return m128d
     with Import, Convention => Intrinsic, External_Name => "__builtin_ia32_cmpltpd";

   function "/=" (Left, Right : m128d) return m128d
     with Import, Convention => Intrinsic, External_Name => "__builtin_ia32_cmpneqpd";

   function Not_Greater_Or_Equal (Left, Right : m128d) return m128d
     with Import, Convention => Intrinsic, External_Name => "__builtin_ia32_cmpngepd";

   function Not_Greater_Than (Left, Right : m128d) return m128d
     with Import, Convention => Intrinsic, External_Name => "__builtin_ia32_cmpngtpd";

   function Not_Less_Equal (Left, Right : m128d) return m128d
     with Import, Convention => Intrinsic, External_Name => "__builtin_ia32_cmpnlepd";

   function Not_Less_Than (Left, Right : m128d) return m128d
     with Import, Convention => Intrinsic, External_Name => "__builtin_ia32_cmpnltpd";

   function Not_Nan (Left, Right : m128d) return m128d
     with Import, Convention => Intrinsic, External_Name => "__builtin_ia32_cmpordpd";
   --  True if neither of the elements in Left and Right are Nan, false otherwise

   function Nan (Left, Right : m128d) return m128d
     with Import, Convention => Intrinsic, External_Name => "__builtin_ia32_cmpunordpd";
   --  True if either or both elements in Left and Right are Nan, false otherwise

   function Is_True (Elements : m128d; Position : Index_2D) return Boolean;
   --  Return true if an element at the given position is not zero, false otherwise.
   --
   --  A comparison using one of the operators above may result in elements
   --  consisting of all 1's. Trying to directly read such an element by
   --  using an index (like 'Elements (X)' for example) may result
   --  in a Constraint_Error. Use this function to check if an element is
   --  not zero after comparison using one of the operators above.

end Orka.SIMD.SSE2.Doubles.Compare;
