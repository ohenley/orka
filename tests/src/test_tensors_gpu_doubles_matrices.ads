--  SPDX-License-Identifier: Apache-2.0
--
--  Copyright (c) 2022 onox <denkpadje@gmail.com>
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

with Orka.Numerics.Doubles.Tensors.GPU;

with Generic_Test_Tensors_Matrices;
with Test_Fixtures_GPU_Tensors;

use all type Orka.Numerics.Doubles.Tensors.GPU.GPU_QR_Factorization;

package Test_Tensors_GPU_Doubles_Matrices is new Generic_Test_Tensors_Matrices
  ("GPU - Doubles",
   Test_Fixtures_GPU_Tensors.Test_Fixture,
   Orka.Numerics.Doubles.Tensors,
   Orka.Numerics.Doubles.Tensors.GPU.GPU_Tensor,
   Orka.Numerics.Doubles.Tensors.GPU.GPU_QR_Factorization,
   Orka.Numerics.Doubles.Tensors.GPU.Initialize_Shaders);
