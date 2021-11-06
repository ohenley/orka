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

with AUnit.Assertions;
with AUnit.Test_Caller;
with AUnit.Test_Fixtures;

with Orka.Numerics.Singles.Tensors.CPU;

package body Test_Tensors_Singles_Matrices is

   use Orka.Numerics.Singles.Tensors;
   use Orka.Numerics.Singles.Tensors.CPU;
   use type Orka.Numerics.Singles.Tensors.Element;

   use AUnit.Assertions;

   procedure Assert_Equal (Expected : Element_Array; Actual : CPU_Tensor) is
   begin
      Assert (Actual.Elements = Expected'Length,
        "Unexpected size of tensor: " & Actual.Elements'Image);

      for I in Expected'Range loop
         Assert (Expected (I) = Actual (I), "Unexpected element at index " & I'Image & ": " &
           Element'Image (Actual (I)) & " instead of " & Element'Image (Expected (I)));
      end loop;
   end Assert_Equal;

   ----------------------------------------------------------------------------

   type Test is new AUnit.Test_Fixtures.Test_Fixture with null record;

   procedure Test_Flatten (Object : in out Test) is
      Tensor_1 : constant CPU_Tensor := Identity (3);
      Tensor_2 : constant CPU_Tensor := Tensor_1.Flatten;
   begin
      Assert (Tensor_1.Dimensions = 2, "Unexpected dimensions:" & Tensor_1.Dimensions'Image);
      Assert (Tensor_2.Dimensions = 1, "Unexpected dimensions:" & Tensor_2.Dimensions'Image);

      Assert (Tensor_1.Shape = (3, 3), "Unexpected shape:" & Image (Tensor_1.Shape));
      Assert (Tensor_2.Shape = (1 => 9), "Unexpected shape:" & Image (Tensor_2.Shape));

      Assert (Tensor_1.Elements = 9, "Unexpected number of elements:" & Tensor_1.Elements'Image);
      Assert (Tensor_2.Elements = 9, "Unexpected number of elements:" & Tensor_2.Elements'Image);
   end Test_Flatten;

   procedure Test_Identity_Square (Object : in out Test) is
      Tensor_1 : constant CPU_Tensor := Identity (3);

      Tensor_2 : constant CPU_Tensor := Identity (3, Offset => 1);
      --  0 1 0
      --  0 0 1
      --  0 0 0

      Tensor_3 : constant CPU_Tensor := Identity (3, Offset => -1);
      --  0 0 0
      --  1 0 0
      --  0 1 0

      Values_1 : constant Element_Array := (1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0);
      Values_2 : constant Element_Array := (0.0, 1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0);
      Values_3 : constant Element_Array := (0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0, 0.0);
   begin
      Assert_Equal (Values_1, Tensor_1.Flatten);
      Assert_Equal (Values_2, Tensor_2.Flatten);
      Assert_Equal (Values_3, Tensor_3.Flatten);
   end Test_Identity_Square;

   procedure Test_Identity_Not_Square (Object : in out Test) is
      Tensor_1 : constant CPU_Tensor := Identity (3);
      Tensor_2 : constant CPU_Tensor := Identity (Rows => 3, Columns => 3);
      --  1 0 0
      --  0 1 0
      --  0 0 1

      Tensor_3 : constant CPU_Tensor := Identity (Rows => 3, Columns => 2);
      --  1 0
      --  0 1
      --  0 0

      Tensor_4 : constant CPU_Tensor := Identity (Rows => 2, Columns => 3, Offset => 1);
      --  0 1 0
      --  0 0 1

      Values_3 : constant Element_Array := (1.0, 0.0, 0.0, 1.0, 0.0, 0.0);
      Values_4 : constant Element_Array := (0.0, 1.0, 0.0, 0.0, 0.0, 1.0);
   begin
      Assert (Tensor_1 = Tensor_2, "Identity matrices not equal");

      Assert_Equal (Values_3, Tensor_3.Flatten);
      Assert_Equal (Values_4, Tensor_4.Flatten);
   end Test_Identity_Not_Square;

   procedure Test_Reshape (Object : in out Test) is
      Values : constant Element_Array := (1.0, 2.0, 3.0, 4.0, 5.0, 6.0);

      Shape_1D : constant Tensor_Shape := (1 => Values'Length);
      Shape_2D : constant Tensor_Shape := (2, 3);

      Tensor_1 : constant CPU_Tensor := To_Tensor (Values);
      Tensor_2 : constant CPU_Tensor := Tensor_1.Reshape (Shape_2D);

      Tensor_3 : constant CPU_Tensor := Tensor_2.Reshape (Tensor_1.Elements);
      Tensor_4 : constant CPU_Tensor := Tensor_1.Reshape (Tensor_1.Elements);
   begin
      Assert (Tensor_1.Shape = Shape_1D, "Unexpected shape: " & Image (Tensor_1.Shape));
      Assert (Tensor_2.Shape = Shape_2D, "Unexpected shape: " & Image (Tensor_2.Shape));
      Assert (Tensor_3.Shape = Shape_1D, "Unexpected shape: " & Image (Tensor_3.Shape));
      Assert (Tensor_4.Shape = Shape_1D, "Unexpected shape: " & Image (Tensor_4.Shape));
   end Test_Reshape;

   procedure Test_Concatenate (Object : in out Test) is
      Left_1 : constant CPU_Tensor := Diagonal ((1.0, 2.0, 3.0));
      --  1 0 0
      --  0 2 0
      --  0 0 3

      Right_1 : constant CPU_Tensor := To_Tensor ((4.0, 5.0, 6.0, 7.0, 8.0, 9.0)).Reshape ((2, 3));
      --  4 5 6
      --  7 8 9

      Right_2 : constant CPU_Tensor := To_Tensor ((4.0, 5.0, 6.0, 7.0, 8.0, 9.0)).Reshape ((3, 2));
      --  4 5
      --  6 7
      --  8 9

      Expected_1 : constant Element_Array :=
        (1.0, 0.0, 0.0, 0.0, 2.0, 0.0, 0.0, 0.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0);
      Expected_2 : constant Element_Array :=
        (1.0, 0.0, 0.0, 4.0, 5.0, 0.0, 2.0, 0.0, 6.0, 7.0, 0.0, 0.0, 3.0, 8.0, 9.0);

      Actual_1 : constant CPU_Tensor := Left_1.Concatenate (Right_1, Dimension => 1);
      --  1 0 0
      --  0 2 0
      --  0 0 3
      --  4 5 6
      --  7 8 9

      Actual_2 : constant CPU_Tensor := Left_1.Concatenate (Right_2, Dimension => 2);
      --  1 0 0 4 5
      --  0 2 0 6 7
      --  0 0 3 8 9
   begin
      Assert (Actual_1 = (Left_1 & Right_1), "Tensors not equal");
      Assert_Equal (Expected_1, Actual_1.Flatten);
      Assert_Equal (Expected_2, Actual_2.Flatten);
   end Test_Concatenate;

   procedure Test_Main_Diagonal (Object : in out Test) is
      Tensor_1 : constant CPU_Tensor := Identity (3);

      Tensor_2 : constant CPU_Tensor := Identity (3, Offset => 1);
      --  0 1 0
      --  0 0 1
      --  0 0 0

      Expected_1 : constant Element_Array := (1.0, 1.0, 1.0);
      Expected_2 : constant Element_Array := (0.0, 0.0, 0.0);
      Expected_3 : constant Element_Array := (1.0, 1.0, 0.0);

      Actual_1 : constant CPU_Tensor := Tensor_1.Main_Diagonal;
      Actual_2 : constant CPU_Tensor := Tensor_2.Main_Diagonal;
      Actual_3 : constant CPU_Tensor := Tensor_2.Main_Diagonal (Offset => 1);
   begin
      Assert_Equal (Expected_1, Actual_1);
      Assert_Equal (Expected_2, Actual_2);
      Assert_Equal (Expected_3, Actual_3);
   end Test_Main_Diagonal;

   procedure Test_Diagonal (Object : in out Test) is
      Expected_1 : constant Element_Array := (1.0, 2.0, 3.0);
      Expected_2 : constant Element_Array := (0.0, 0.0, 0.0);
      Expected_3 : constant Element_Array := (1.0, 2.0, 0.0);

      Tensor_1 : constant CPU_Tensor := Diagonal (Expected_1);
      --  1 0 0
      --  0 2 0
      --  0 0 3

      Tensor_2 : constant CPU_Tensor := Diagonal (Expected_1, Offset => 1);
      --  0 1 0
      --  0 0 2
      --  0 0 0

      Tensor_3 : constant CPU_Tensor := Diagonal (To_Tensor (Expected_1));
   begin
      Assert_Equal (Expected_1, Tensor_1.Main_Diagonal);
      Assert_Equal (Expected_2, Tensor_2.Main_Diagonal);
      Assert_Equal (Expected_3, Tensor_2.Main_Diagonal (Offset => 1));

      Assert_Equal (Expected_1, Tensor_3.Main_Diagonal);
   end Test_Diagonal;

   procedure Test_Trace (Object : in out Test) is
      Tensor_1 : constant CPU_Tensor := Diagonal ((1.0, 2.0, 3.0));
      Tensor_2 : constant CPU_Tensor := Diagonal ((1.0, 2.0, 3.0, 4.0, 5.0));
      Tensor_3 : constant CPU_Tensor := To_Tensor ((1.0, 2.0, 3.0, 4.0, 5.0, 6.0));

      Expected_1 : constant Element := 6.0;
      Expected_2 : constant Element := 15.0;
      Expected_3 : constant Element := 6.0;
      Expected_4 : constant Element := 5.0;

      Actual_1 : constant Element := Tensor_1.Trace;
      Actual_2 : constant Element := Tensor_2.Trace;
      Actual_3 : constant Element := Tensor_3.Reshape ((2, 3)).Trace;
      Actual_4 : constant Element := Tensor_3.Reshape ((3, 2)).Trace;
   begin
      Assert (Expected_1 = Actual_1, "Unexpected trace: " & Actual_1'Image);
      Assert (Expected_2 = Actual_2, "Unexpected trace: " & Actual_2'Image);
      Assert (Expected_3 = Actual_3, "Unexpected trace: " & Actual_3'Image);
      Assert (Expected_4 = Actual_4, "Unexpected trace: " & Actual_4'Image);
   end Test_Trace;

   procedure Test_Constant_Indexing_Index_Row (Object : in out Test) is
      Tensor : constant CPU_Tensor := Diagonal ((1.0, 2.0, 3.0));
      --  1 0 0
      --  0 2 0
      --  0 0 3
   begin
      Assert_Equal ((1.0, 0.0, 0.0), Tensor (1));
      Assert_Equal ((0.0, 2.0, 0.0), Tensor (2));
      Assert_Equal ((0.0, 0.0, 3.0), Tensor (3));
   end Test_Constant_Indexing_Index_Row;

   procedure Test_Constant_Indexing_Index_Value (Object : in out Test) is
      Main_Diagonal : constant Element_Array := (1.0, 2.0, 3.0);
      Tensor : constant CPU_Tensor := Diagonal (Main_Diagonal);
   begin
      for Index in Main_Diagonal'Range loop
         Assert (Main_Diagonal (Index) = Tensor ((Index, Index)),
           "Unexpected element: " & Element'Image (Tensor ((Index, Index))));
      end loop;
   end Test_Constant_Indexing_Index_Value;

   procedure Test_Constant_Indexing_Index_Boolean (Object : in out Test) is
      Values : constant Boolean_Array := (True, False, True);

      Main_Diagonal : constant Element_Array := (1.0, 2.0, 3.0);
      Tensor : constant CPU_Tensor := Diagonal (Main_Diagonal) /= 2.0;
   begin
      for Index in Values'Range loop
         Assert (Values (Index) = Tensor ((Index, Index)),
           "Unexpected element: " & Boolean'Image (Tensor ((Index, Index))));
      end loop;
   end Test_Constant_Indexing_Index_Boolean;

   procedure Test_Constant_Indexing_Range (Object : in out Test) is
      Tensor : constant CPU_Tensor := Diagonal ((1.0, 2.0, 3.0, 4.0));
      --  1 0 0 0
      --  0 2 0 0
      --  0 0 3 0
      --  0 0 0 4

      Expected_1 : constant CPU_Tensor := Tensor (Range_Type'(2, 3));
      --  0 2 0 0
      --  0 0 3 0

      Expected_2 : constant CPU_Tensor := Tensor (Tensor_Range'((3, 4), (2, 4)));
      --  0 3 0
      --  0 0 4

      Actual_1   : constant CPU_Tensor := To_Tensor ((0.0, 2.0, 0.0, 0.0, 0.0, 0.0, 3.0, 0.0))
        .Reshape ((2, 4));
      Actual_2   : constant CPU_Tensor := To_Tensor ((0.0, 3.0, 0.0, 0.0, 0.0, 4.0))
        .Reshape ((2, 3));
   begin
      Assert (Expected_1 = Actual_1, "Unexpected tensor of shape " & Image (Actual_1.Shape));
      Assert (Expected_2 = Actual_2, "Unexpected tensor of shape " & Image (Actual_2.Shape));
   end Test_Constant_Indexing_Range;

   procedure Test_Constant_Indexing_Tensor (Object : in out Test) is
      Tensor : constant CPU_Tensor := To_Tensor ((1.0, 2.0, 3.0, 4.0, 5.0, 6.0)).Reshape ((2, 3));
      --  1 2 3
      --  4 5 6

      Expected_1 : constant Element_Array := (5.0, 6.0);
      Expected_2 : constant Element_Array := (1.0, 2.0, 3.0, 4.0);
      Expected_3 : constant Element_Array := (2.0, 4.0, 6.0);

      Actual_1 : constant CPU_Tensor := Tensor (Tensor > 4.0);
      --  5 6

      Actual_2 : constant CPU_Tensor := Tensor (Tensor <= 4.0);
      --  1 2 3 4

      Actual_3 : constant CPU_Tensor := Tensor (Tensor mod 2.0 = 0.0);
      --  2 4 6

      Actual_4 : constant CPU_Tensor := Tensor (Tensor = 0.0);
   begin
      Assert_Equal (Expected_1, Actual_1);
      Assert_Equal (Expected_2, Actual_2);
      Assert_Equal (Expected_3, Actual_3);

      Assert (Actual_4.Elements = 0, "Unexpected number of elements: " & Actual_4.Elements'Image);
   end Test_Constant_Indexing_Tensor;

   procedure Test_Operator_Multiply_Inner (Object : in out Test) is
   begin
      Assert (False, "FIXME");
   end Test_Operator_Multiply_Inner;

   procedure Test_Operator_Power (Object : in out Test) is
   begin
      --  A**0 = I
      --  A**1 = A
      --  A**2 = A * A
      --  A**3 = A * A * A
      --  A**-1 = A.Inverse
      --  A**-2 = A.Inverse ** 2
      Assert (False, "FIXME");
   end Test_Operator_Power;

   procedure Test_Outer (Object : in out Test) is
      Tensor_1 : constant CPU_Tensor := To_Tensor ((1.0, 2.0, 3.0));
      Tensor_2 : constant CPU_Tensor := To_Tensor ((1 => 1.0));

      Expected_1 : constant Element_Array := (1.0, 2.0, 3.0, 2.0, 4.0, 6.0, 3.0, 6.0, 9.0);
      Expected_2 : constant Element_Array := (1.0, 2.0, 3.0);
      Expected_3 : constant Element_Array := (1.0, 2.0, 3.0);

      Actual_1   : constant CPU_Tensor := Outer (Tensor_1, Tensor_1);
      Actual_2   : constant CPU_Tensor := Outer (Tensor_1, Tensor_2);
      Actual_3   : constant CPU_Tensor := Outer (Tensor_2, Tensor_1);
   begin
      Assert (Actual_1.Shape = (3, 3), "Unexpected shape: " & Image (Actual_1.Shape));
      Assert (Actual_2.Shape = (3, 1), "Unexpected shape: " & Image (Actual_2.Shape));
      Assert (Actual_3.Shape = (1, 3), "Unexpected shape: " & Image (Actual_3.Shape));

      Assert_Equal (Expected_1, Actual_1.Flatten);
      Assert_Equal (Expected_2, Actual_2.Flatten);
      Assert_Equal (Expected_3, Actual_3.Flatten);
   end Test_Outer;

   procedure Test_Inverse (Object : in out Test) is
   begin
      Assert (False, "FIXME");
   end Test_Inverse;

   procedure Test_Transpose (Object : in out Test) is
   begin
      Assert (False, "FIXME");
   end Test_Transpose;

   procedure Test_Any_True (Object : in out Test) is
   begin
      Assert (False, "FIXME");
   end Test_Any_True;

   procedure Test_All_True (Object : in out Test) is
   begin
      Assert (False, "FIXME");
   end Test_All_True;

   procedure Test_Reduction_Binary_Operator (Object : in out Test) is
   begin
      Assert (False, "FIXME");
   end Test_Reduction_Binary_Operator;

   procedure Test_Reduction_Number (Object : in out Test) is
   begin
      Assert (False, "FIXME");
   end Test_Reduction_Number;

   ----------------------------------------------------------------------------

   package Caller is new AUnit.Test_Caller (Test);

   Test_Suite : aliased AUnit.Test_Suites.Test_Suite;

   function Suite return AUnit.Test_Suites.Access_Test_Suite is
      Name : constant String := "(Tensors/Singles/Matrices) ";
   begin
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test function Flatten", Test_Flatten'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test function Identity (square)", Test_Identity_Square'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test function Identity (not square)", Test_Identity_Not_Square'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test function Reshape", Test_Reshape'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test function Concatenate", Test_Concatenate'Access));

      Test_Suite.Add_Test (Caller.Create
        (Name & "Test function Main_Diagonal", Test_Main_Diagonal'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test function Diagonal", Test_Diagonal'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test function Trace", Test_Trace'Access));

      Test_Suite.Add_Test (Caller.Create
        (Name & "Test indexing row using index", Test_Constant_Indexing_Index_Row'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test indexing value using index", Test_Constant_Indexing_Index_Value'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test indexing value using index (boolean)",
         Test_Constant_Indexing_Index_Boolean'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test indexing using range", Test_Constant_Indexing_Range'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test indexing using tensor", Test_Constant_Indexing_Tensor'Access));

      Test_Suite.Add_Test (Caller.Create
        (Name & "Test '*' operator (inner product)", Test_Operator_Multiply_Inner'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test '**'", Test_Operator_Power'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test function Outer (outer product)", Test_Outer'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test function Inverse", Test_Inverse'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test function Transpose", Test_Transpose'Access));

      --  TODO Statistics: Min, Max, Quantile, Median, Mean, Variance (with Dimension parameter)

      Test_Suite.Add_Test (Caller.Create
        (Name & "Test function Any_True", Test_Any_True'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test function All_True", Test_All_True'Access));

      --  Expressions
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test reduction binary operator", Test_Reduction_Binary_Operator'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test reduction number", Test_Reduction_Number'Access));

      --  TODO Cumulative, Reduce (with Dimension parameter)

      return Test_Suite'Access;
   end Suite;

end Test_Tensors_Singles_Matrices;
