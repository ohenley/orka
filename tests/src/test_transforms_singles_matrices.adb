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

with Ada.Numerics.Generic_Elementary_Functions;

with AUnit.Assertions;
with AUnit.Test_Caller;

with Orka.SIMD.SSE.Singles.Arithmetic;
with Orka.Transforms.Singles.Matrices;

package body Test_Transforms_Singles_Matrices is

   use Orka;
   use Orka.Transforms.Singles.Matrices;

   use AUnit.Assertions;

   use type Vector4;

   package EF is new Ada.Numerics.Generic_Elementary_Functions (Float_32);

   function To_Radians (Angle : Float_32) return Float_32 renames Vectors.To_Radians;

   function Is_Equivalent (Expected, Result : Float_32) return Boolean is
     (abs (Result - Expected) <= 2.0 * Float_32'Model_Epsilon);

   procedure Assert_Equivalent (Expected, Result : Vector4) is
   begin
      for I in Index_4D loop
         Assert (Is_Equivalent (Expected (I), Result (I)),
           "Unexpected element " & Expected (I)'Image & " instead of " & Result (I)'Image &
           " at " & I'Image);
      end loop;
   end Assert_Equivalent;

   procedure Assert_Equivalent (Expected, Result : Vector4; Column : Index_4D) is
   begin
      for Row in Index_4D loop
         Assert (Is_Equivalent (Expected (Row), Result (Row)),
           "Unexpected element " & Expected (Row)'Image & " instead of " & Result (Row)'Image &
           " at (" & Column'Image & ", " & Row'Image & ")");
      end loop;
   end Assert_Equivalent;

   package Caller is new AUnit.Test_Caller (Test);

   Test_Suite : aliased AUnit.Test_Suites.Test_Suite;

   function Suite return AUnit.Test_Suites.Access_Test_Suite is
      Name : constant String := "(Transforms - Singles - Matrices) ";
   begin
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test T function", Test_T'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test Rx function", Test_Rx'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test Ry function", Test_Ry'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test Rz function", Test_Rz'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test R function", Test_R'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test S function", Test_S'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test '+' operator (translate)", Test_Add_Offset'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test '*' operator (scale)", Test_Multiply_Factor'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test Rotate_At_Origin procedure", Test_Rotate_At_Origin'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test Rotate procedure", Test_Rotate'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test Rotate_X_At_Origin procedure", Test_Rotate_X_At_Origin'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test Rotate_Y_At_Origin procedure", Test_Rotate_Y_At_Origin'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test Rotate_Z_At_Origin procedure", Test_Rotate_Z_At_Origin'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test Rotate_X procedure", Test_Rotate_X'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test Rotate_Y procedure", Test_Rotate_Y'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test Rotate_Z procedure", Test_Rotate_Z'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test Translate procedure", Test_Translate'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test Scale_Factors procedure", Test_Scale_Factors'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test Scale_Factor procedure", Test_Scale_Factor'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test Transpose function", Test_Transpose'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test Diagonal function", Test_Diagonal'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test Main_Diagonal function", Test_Main_Diagonal'Access));
      Test_Suite.Add_Test (Caller.Create
        (Name & "Test Trace function", Test_Trace'Access));

      return Test_Suite'Access;
   end Suite;

   procedure Test_T (Object : in out Test) is
      Offset : constant Vector4 := (2.0, 3.0, 4.0, 1.0);

      Expected : constant Matrix4
        := ((1.0, 0.0, 0.0, 0.0),
            (0.0, 1.0, 0.0, 0.0),
            (0.0, 0.0, 1.0, 0.0),
            Offset);

      Result : constant Matrix4 := T (Offset);
   begin
      for I in Index_4D loop
         Assert_Equivalent (Expected (I), Result (I), I);
      end loop;
   end Test_T;

   procedure Test_Rx (Object : in out Test) is
      Angle : constant Float_32 := 60.0;

      CA : constant Float_32 := EF.Cos (Angle, 360.0);
      SA : constant Float_32 := EF.Sin (Angle, 360.0);

      Expected : constant Matrix4
        := ((1.0, 0.0, 0.0, 0.0),
            (0.0,  CA,  SA, 0.0),
            (0.0, -SA,  CA, 0.0),
            (0.0, 0.0, 0.0, 1.0));

      Result : constant Matrix4 := Rx (To_Radians (Angle));
   begin
      for I in Index_4D loop
         Assert_Equivalent (Expected (I), Result (I), I);
      end loop;
   end Test_Rx;

   procedure Test_Ry (Object : in out Test) is
      Angle : constant Float_32 := 60.0;

      CA : constant Float_32 := EF.Cos (Angle, 360.0);
      SA : constant Float_32 := EF.Sin (Angle, 360.0);

      Expected : constant Matrix4
        := ((CA,  0.0, -SA, 0.0),
            (0.0, 1.0, 0.0, 0.0),
            (SA,  0.0,  CA, 0.0),
            (0.0, 0.0, 0.0, 1.0));

      Result : constant Matrix4 := Ry (To_Radians (Angle));
   begin
      for I in Index_4D loop
         Assert_Equivalent (Expected (I), Result (I), I);
      end loop;
   end Test_Ry;

   procedure Test_Rz (Object : in out Test) is
      Angle : constant Float_32 := 60.0;

      CA : constant Float_32 := EF.Cos (Angle, 360.0);
      SA : constant Float_32 := EF.Sin (Angle, 360.0);

      Expected : constant Matrix4
        := ((CA,   SA, 0.0, 0.0),
            (-SA,  CA, 0.0, 0.0),
            (0.0, 0.0, 1.0, 0.0),
            (0.0, 0.0, 0.0, 1.0));

      Result : constant Matrix4 := Rz (To_Radians (Angle));
   begin
      for I in Index_4D loop
         Assert_Equivalent (Expected (I), Result (I), I);
      end loop;
   end Test_Rz;

   procedure Test_R (Object : in out Test) is
      Angle : constant Float_32 := 90.0;

      Expected : constant Matrix4 :=
        Rz (To_Radians (Angle)) * Ry (To_Radians (Angle)) * Rx (To_Radians (Angle));
      Result   : constant Matrix4 := R ((0.0, 1.0, 0.0, 1.0), To_Radians (Angle));
   begin
      for I in Index_4D loop
         Assert_Equivalent (Expected (I), Result (I), I);
      end loop;
   end Test_R;

   procedure Test_S (Object : in out Test) is
      Factors : constant Vector4 := (2.0, 3.0, 4.0, 1.0);

      Expected : constant Matrix4
        := ((Factors (X), 0.0, 0.0, 0.0),
            (0.0, Factors (Y), 0.0, 0.0),
            (0.0, 0.0, Factors (Z), 0.0),
            (0.0, 0.0, 0.0, 1.0));

      Result : constant Matrix4 := S (Factors);
   begin
      for I in Index_4D loop
         Assert_Equivalent (Expected (I), Result (I), I);
      end loop;
   end Test_S;

   procedure Test_Add_Offset (Object : in out Test) is
      use Orka.SIMD.SSE.Singles.Arithmetic;

      --  W of sum must be 1.0
      Offset_A : constant Vector4 := (2.0, 3.0, 4.0, 1.0);
      Offset_B : constant Vector4 := (-5.0, 3.0, 6.0, 0.0);

      Expected : constant Matrix4
        := ((1.0, 0.0, 0.0, 0.0),
            (0.0, 1.0, 0.0, 0.0),
            (0.0, 0.0, 1.0, 0.0),
            Offset_A + Offset_B);

      Result : constant Matrix4 := Offset_A + (Offset_B + Identity_Matrix);
   begin
      for I in Index_4D loop
         Assert_Equivalent (Expected (I), Result (I), I);
      end loop;
   end Test_Add_Offset;

   procedure Test_Multiply_Factor (Object : in out Test) is
      Factor_A : constant Float_32 := 2.0;
      Factor_B : constant Float_32 := 2.0;

      Total : constant Float_32 := Factor_A * Factor_B;

      Expected : constant Matrix4
        := ((Total, 0.0, 0.0, 0.0),
            (0.0, Total, 0.0, 0.0),
            (0.0, 0.0, Total, 0.0),
            (0.0, 0.0, 0.0, 1.0));

      Result : constant Matrix4 := Factor_A * (Factor_B * Identity_Matrix);
   begin
      for I in Index_4D loop
         Assert_Equivalent (Expected (I), Result (I), I);
      end loop;
   end Test_Multiply_Factor;

   procedure Test_Rotate_At_Origin (Object : in out Test) is
      Angle  : constant Float_32 := 90.0;
      Offset : constant Vector4 := (2.0, 3.0, 4.0, 1.0);

      Expected : constant Matrix4 :=
        Rz (To_Radians (Angle)) * Ry (To_Radians (Angle)) * Rx (To_Radians (Angle)) * T (Offset);
      Result   : constant Matrix4 := R ((0.0, 1.0, 0.0, 1.0), To_Radians (Angle)) * T (Offset);
   begin
      for I in Index_4D loop
         Assert_Equivalent (Expected (I), Result (I), I);
      end loop;
   end Test_Rotate_At_Origin;

   procedure Test_Rotate (Object : in out Test) is
      Angle  : constant Float_32 := 90.0;
      Offset : constant Vectors.Point := (2.0, 3.0, 4.0, 1.0);

      Expected : Matrix4 :=
        Rz (To_Radians (Angle)) * Ry (To_Radians (Angle)) * Rx (To_Radians (Angle));
      Result   : constant Matrix4 :=
        R ((0.0, 1.0, 0.0, 1.0), To_Radians (Angle), Offset) * T (Offset);
   begin
      Expected (W) := Vector4 (Offset);

      for I in Index_4D loop
         Assert_Equivalent (Expected (I), Result (I), I);
      end loop;
   end Test_Rotate;

   procedure Test_Rotate_X_At_Origin (Object : in out Test) is
      Angle  : constant Float_32  := 90.0;
      Offset : constant Vector4 := (2.0, 3.0, 4.0, 1.0);

      CA : constant Float_32 := EF.Cos (Angle, 360.0);
      SA : constant Float_32 := EF.Sin (Angle, 360.0);

      Expected : constant Matrix4
        := ((1.0,  0.0, 0.0, 0.0),
            (0.0,   CA,  SA, 0.0),
            (0.0,  -SA,  CA, 0.0),
            (2.0, -4.0, 3.0, 1.0));

      Result : constant Matrix4 := Rx (To_Radians (Angle)) * T (Offset);
   begin
      for I in Index_4D loop
         Assert_Equivalent (Expected (I), Result (I), I);
      end loop;
   end Test_Rotate_X_At_Origin;

   procedure Test_Rotate_Y_At_Origin (Object : in out Test) is
      Angle  : constant Float_32  := 90.0;
      Offset : constant Vector4 := (2.0, 3.0, 4.0, 1.0);

      CA : constant Float_32 := EF.Cos (Angle, 360.0);
      SA : constant Float_32 := EF.Sin (Angle, 360.0);

      Expected : constant Matrix4
        := ((CA,  0.0,  -SA, 0.0),
            (0.0, 1.0,  0.0, 0.0),
            (SA,  0.0,   CA, 0.0),
            (4.0, 3.0, -2.0, 1.0));

      Result : constant Matrix4 := Ry (To_Radians (Angle)) * T (Offset);
   begin
      for I in Index_4D loop
         Assert_Equivalent (Expected (I), Result (I), I);
      end loop;
   end Test_Rotate_Y_At_Origin;

   procedure Test_Rotate_Z_At_Origin (Object : in out Test) is
      Angle  : constant Float_32  := 90.0;
      Offset : constant Vector4 := (2.0, 3.0, 4.0, 1.0);

      CA : constant Float_32 := EF.Cos (Angle, 360.0);
      SA : constant Float_32 := EF.Sin (Angle, 360.0);

      Expected : constant Matrix4
        := ((CA,    SA, 0.0, 0.0),
            (-SA,   CA, 0.0, 0.0),
            (0.0,  0.0, 1.0, 0.0),
            (-3.0, 2.0, 4.0, 1.0));

      Result : constant Matrix4 := Rz (To_Radians (Angle)) * T (Offset);
   begin
      for I in Index_4D loop
         Assert_Equivalent (Expected (I), Result (I), I);
      end loop;
   end Test_Rotate_Z_At_Origin;

   procedure Test_Rotate_X (Object : in out Test) is
      Angle  : constant Float_32  := 90.0;
      Offset : constant Vectors.Point := (2.0, 3.0, 4.0, 1.0);

      CA : constant Float_32 := EF.Cos (Angle, 360.0);
      SA : constant Float_32 := EF.Sin (Angle, 360.0);

      Expected : constant Matrix4
        := ((1.0,  0.0, 0.0, 0.0),
            (0.0,   CA,  SA, 0.0),
            (0.0,  -SA,  CA, 0.0),
            Vector4 (Offset));

      Result : constant Matrix4 := Rx (To_Radians (Angle), Offset) * T (Offset);
   begin
      for I in Index_4D loop
         Assert_Equivalent (Expected (I), Result (I), I);
      end loop;
   end Test_Rotate_X;

   procedure Test_Rotate_Y (Object : in out Test) is
      Angle  : constant Float_32  := 90.0;
      Offset : constant Vectors.Point := (2.0, 3.0, 4.0, 1.0);

      CA : constant Float_32 := EF.Cos (Angle, 360.0);
      SA : constant Float_32 := EF.Sin (Angle, 360.0);

      Expected : constant Matrix4
        := ((CA,  0.0,  -SA, 0.0),
            (0.0, 1.0,  0.0, 0.0),
            (SA,  0.0,   CA, 0.0),
            Vector4 (Offset));

      Result : constant Matrix4 := Ry (To_Radians (Angle), Offset) * T (Offset);
   begin
      for I in Index_4D loop
         Assert_Equivalent (Expected (I), Result (I), I);
      end loop;
   end Test_Rotate_Y;

   procedure Test_Rotate_Z (Object : in out Test) is
      Angle  : constant Float_32  := 90.0;
      Offset : constant Vectors.Point := (2.0, 3.0, 4.0, 1.0);

      CA : constant Float_32 := EF.Cos (Angle, 360.0);
      SA : constant Float_32 := EF.Sin (Angle, 360.0);

      Expected : constant Matrix4
        := ((CA,    SA, 0.0, 0.0),
            (-SA,   CA, 0.0, 0.0),
            (0.0,  0.0, 1.0, 0.0),
            Vector4 (Offset));

      Result : constant Matrix4 := Rz (To_Radians (Angle), Offset) * T (Offset);
   begin
      for I in Index_4D loop
         Assert_Equivalent (Expected (I), Result (I), I);
      end loop;
   end Test_Rotate_Z;

   procedure Test_Translate (Object : in out Test) is
      Offset : constant Vector4 := (2.0, 3.0, 4.0, 1.0);

      Expected : constant Matrix4
        := ((1.0, 0.0, 0.0, 0.0),
            (0.0, 1.0, 0.0, 0.0),
            (0.0, 0.0, 1.0, 0.0),
            Offset);

      Result : constant Matrix4 := Offset + Identity_Matrix;
   begin
      for I in Index_4D loop
         Assert_Equivalent (Expected (I), Result (I), I);
      end loop;
   end Test_Translate;

   procedure Test_Scale_Factors (Object : in out Test) is
      Factors : constant Vector4 := (2.0, 3.0, 4.0, 0.0);

      Expected : constant Matrix4
        := ((Factors (X), 0.0, 0.0, 0.0),
            (0.0, Factors (Y), 0.0, 0.0),
            (0.0, 0.0, Factors (Z), 0.0),
            (0.0, 0.0, 0.0, 1.0));

      Result : constant Matrix4 := S (Factors) * Identity_Matrix;
   begin
      for I in Index_4D loop
         Assert_Equivalent (Expected (I), Result (I), I);
      end loop;
   end Test_Scale_Factors;

   procedure Test_Scale_Factor (Object : in out Test) is
      Factor : constant Float_32 := 2.0;

      Expected : constant Matrix4
        := ((Factor, 0.0, 0.0, 0.0),
            (0.0, Factor, 0.0, 0.0),
            (0.0, 0.0, Factor, 0.0),
            (0.0, 0.0, 0.0, 1.0));

      Result : constant Matrix4 := Factor * Identity_Matrix;
   begin
      for I in Index_4D loop
         Assert_Equivalent (Expected (I), Result (I), I);
      end loop;
   end Test_Scale_Factor;

   procedure Test_Transpose (Object : in out Test) is
      Value : constant Matrix4
        := ((1.0, 11.0, 14.0, 16.0),
            (5.0,  2.0, 12.0, 15.0),
            (8.0,  6.0,  3.0, 13.0),
            (10.0, 9.0,  7.0,  4.0));

      Expected : constant Matrix4
        := ((1.0,   5.0,  8.0, 10.0),
            (11.0,  2.0,  6.0,  9.0),
            (14.0, 12.0,  3.0,  7.0),
            (16.0, 15.0, 13.0,  4.0));

      Result : constant Matrix4 := Transpose (Value);
   begin
      for I in Index_4D loop
         Assert_Equivalent (Expected (I), Result (I), I);
      end loop;
   end Test_Transpose;

   procedure Test_Diagonal (Object : in out Test) is
      Values : constant Vector4 := (2.0, 3.0, 4.0, 5.0);

      A : Float_32 renames Values (X);
      B : Float_32 renames Values (Y);
      C : Float_32 renames Values (Z);
      D : Float_32 renames Values (W);

      Expected : constant Matrix4 :=
        ((A, 0.0, 0.0, 0.0),
         (0.0, B, 0.0, 0.0),
         (0.0, 0.0, C, 0.0),
         (0.0, 0.0, 0.0, D));

      Result : constant Matrix4 := Diagonal (Values);
   begin
      for I in Index_4D loop
         Assert_Equivalent (Expected (I), Result (I), I);
      end loop;
   end Test_Diagonal;

   procedure Test_Main_Diagonal (Object : in out Test) is
      Expected : constant Vector4 := (2.0, 3.0, 4.0, 5.0);

      Result : constant Vector4 := Main_Diagonal (Diagonal (Expected));
   begin
      Assert_Equivalent (Expected, Result);
   end Test_Main_Diagonal;

   procedure Test_Trace (Object : in out Test) is
      Values : constant Vector4 := (2.0, 3.0, 4.0, 5.0);

      Expected : constant Float_32 := Values (X) + Values (Y) + Values (Z) + Values (W);
      Result   : constant Float_32 := Trace (Diagonal (Values));
   begin
      Assert (Is_Equivalent (Expected, Result), "Unexpected Single");
   end Test_Trace;

end Test_Transforms_Singles_Matrices;
