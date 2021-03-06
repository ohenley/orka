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

with Ahven; use Ahven;

with GL.Types;

with Orka.SIMD.SSE.Singles.Arithmetic;
with Orka.Transforms.Singles.Matrices;

package body Test_Transforms_Singles_Matrices is

   use GL.Types;
   use Orka.SIMD;
   use Orka.Transforms.Singles.Matrices;

   use type Vector4;

   package Elementary_Functions is new Ada.Numerics.Generic_Elementary_Functions (Single);

   overriding
   procedure Initialize (T : in out Test) is
   begin
      T.Set_Name ("Matrices");

      T.Add_Test_Routine (Test_T'Access, "Test T function");
      T.Add_Test_Routine (Test_Rx'Access, "Test Rx function");
      T.Add_Test_Routine (Test_Ry'Access, "Test Ry function");
      T.Add_Test_Routine (Test_Rz'Access, "Test Rz function");
      T.Add_Test_Routine (Test_R'Access, "Test R function");
      T.Add_Test_Routine (Test_S'Access, "Test S function");
      T.Add_Test_Routine (Test_Add_Offset'Access, "Test '+' operator (translate)");
      T.Add_Test_Routine (Test_Multiply_Factor'Access, "Test '*' operator (scale)");
      T.Add_Test_Routine (Test_Rotate_At_Origin'Access, "Test Rotate_At_Origin procedure");
      T.Add_Test_Routine (Test_Rotate'Access, "Test Rotate procedure");
      T.Add_Test_Routine (Test_Rotate_X_At_Origin'Access, "Test Rotate_X_At_Origin procedure");
      T.Add_Test_Routine (Test_Rotate_Y_At_Origin'Access, "Test Rotate_Y_At_Origin procedure");
      T.Add_Test_Routine (Test_Rotate_Z_At_Origin'Access, "Test Rotate_Z_At_Origin procedure");
      T.Add_Test_Routine (Test_Rotate_X'Access, "Test Rotate_X procedure");
      T.Add_Test_Routine (Test_Rotate_Y'Access, "Test Rotate_Y procedure");
      T.Add_Test_Routine (Test_Rotate_Z'Access, "Test Rotate_Z procedure");
      T.Add_Test_Routine (Test_Translate'Access, "Test Translate procedure");
      T.Add_Test_Routine (Test_Scale_Factors'Access, "Test Scale_Factors procedure");
      T.Add_Test_Routine (Test_Scale_Factor'Access, "Test Scale_Factor procedure");
      T.Add_Test_Routine (Test_Transpose'Access, "Test Transpose procedure");
   end Initialize;

   procedure Test_T is
      Offset : constant Vector4 := (2.0, 3.0, 4.0, 1.0);

      Expected : constant Matrix4
        := ((1.0, 0.0, 0.0, 0.0),
            (0.0, 1.0, 0.0, 0.0),
            (0.0, 0.0, 1.0, 0.0),
            Offset);

      Result : constant Matrix4 := T (Offset);
   begin
      for I in Index_Homogeneous loop
         Assert (Expected (I) = Result (I), "Unexpected vector at " & Index_Homogeneous'Image (I));
      end loop;
   end Test_T;

   procedure Test_Rx is
      Angle : constant Single := 60.0;

      CA : constant Single := Elementary_Functions.Cos (Angle, 360.0);
      SA : constant Single := Elementary_Functions.Sin (Angle, 360.0);

      Expected : constant Matrix4
        := ((1.0, 0.0, 0.0, 0.0),
            (0.0,  CA,  SA, 0.0),
            (0.0, -SA,  CA, 0.0),
            (0.0, 0.0, 0.0, 1.0));

      Result : constant Matrix4 := Rx (Angle);
   begin
      for I in Index_Homogeneous loop
         Assert (Expected (I) = Result (I), "Unexpected vector at " & Index_Homogeneous'Image (I));
      end loop;
   end Test_Rx;

   procedure Test_Ry is
      Angle : constant Single := 60.0;

      CA : constant Single := Elementary_Functions.Cos (Angle, 360.0);
      SA : constant Single := Elementary_Functions.Sin (Angle, 360.0);

      Expected : constant Matrix4
        := ((CA,  0.0, -SA, 0.0),
            (0.0, 1.0, 0.0, 0.0),
            (SA,  0.0,  CA, 0.0),
            (0.0, 0.0, 0.0, 1.0));

      Result : constant Matrix4 := Ry (Angle);
   begin
      for I in Index_Homogeneous loop
         Assert (Expected (I) = Result (I), "Unexpected vector at " & Index_Homogeneous'Image (I));
      end loop;
   end Test_Ry;

   procedure Test_Rz is
      Angle : constant Single := 60.0;

      CA : constant Single := Elementary_Functions.Cos (Angle, 360.0);
      SA : constant Single := Elementary_Functions.Sin (Angle, 360.0);

      Expected : constant Matrix4
        := ((CA,   SA, 0.0, 0.0),
            (-SA,  CA, 0.0, 0.0),
            (0.0, 0.0, 1.0, 0.0),
            (0.0, 0.0, 0.0, 1.0));

      Result : constant Matrix4 := Rz (Angle);
   begin
      for I in Index_Homogeneous loop
         Assert (Expected (I) = Result (I), "Unexpected vector at " & Index_Homogeneous'Image (I));
      end loop;
   end Test_Rz;

   procedure Test_R is
      Angle : constant Single := 90.0;

      Expected : constant Matrix4 := Rz (Angle) * Ry (Angle) * Rx (Angle);
      Result   : constant Matrix4 := R ((0.0, 1.0, 0.0, 1.0), Angle);
   begin
      for I in Index_Homogeneous loop
         Assert (Expected (I) = Result (I), "Unexpected vector at " & Index_Homogeneous'Image (I));
      end loop;
   end Test_R;

   procedure Test_S is
      Factors : constant Vector4 := (2.0, 3.0, 4.0, 1.0);

      Expected : constant Matrix4
        := ((Factors (X), 0.0, 0.0, 0.0),
            (0.0, Factors (Y), 0.0, 0.0),
            (0.0, 0.0, Factors (Z), 0.0),
            (0.0, 0.0, 0.0, 1.0));

      Result : constant Matrix4 := S (Factors);
   begin
      for I in Index_Homogeneous loop
         Assert (Expected (I) = Result (I), "Unexpected vector at " & Index_Homogeneous'Image (I));
      end loop;
   end Test_S;

   procedure Test_Add_Offset is
      use Orka.SIMD.SSE.Singles.Arithmetic;

      --  W of sum must be 1.0
      Offset_A : constant Vector4 := (2.0, 3.0, 4.0, 1.0);
      Offset_B : constant Vector4 := (-5.0, 3.0, 6.0, 0.0);

      Expected : constant Matrix4
        := ((1.0, 0.0, 0.0, 0.0),
            (0.0, 1.0, 0.0, 0.0),
            (0.0, 0.0, 1.0, 0.0),
            Offset_A + Offset_B);

      Result : constant Matrix4 := Offset_A + (Offset_B + Identity_Value);
   begin
      for I in Index_Homogeneous loop
         Assert (Expected (I) = Result (I), "Unexpected vector at " & Index_Homogeneous'Image (I));
      end loop;
   end Test_Add_Offset;

   procedure Test_Multiply_Factor is
      Factor_A : constant Single := 2.0;
      Factor_B : constant Single := 2.0;

      Total : constant Single := Factor_A * Factor_B;

      Expected : constant Matrix4
        := ((Total, 0.0, 0.0, 0.0),
            (0.0, Total, 0.0, 0.0),
            (0.0, 0.0, Total, 0.0),
            (0.0, 0.0, 0.0, 1.0));

      Result : constant Matrix4 := Factor_A * (Factor_B * Identity_Value);
   begin
      for I in Index_Homogeneous loop
         Assert (Expected (I) = Result (I), "Unexpected vector at " & Index_Homogeneous'Image (I));
      end loop;
   end Test_Multiply_Factor;

   procedure Test_Rotate_At_Origin is
      Angle  : constant Single := 90.0;
      Offset : constant Vector4 := (2.0, 3.0, 4.0, 1.0);

      Expected : constant Matrix4 := Rz (Angle) * Ry (Angle) * Rx (Angle) * T (Offset);
      Result   : Matrix4 := T (Offset);
   begin
      Rotate_At_Origin (Result, (0.0, 1.0, 0.0, 1.0), Angle);

      for I in Index_Homogeneous loop
         Assert (Expected (I) = Result (I), "Unexpected vector at " & Index_Homogeneous'Image (I));
      end loop;
   end Test_Rotate_At_Origin;

   procedure Test_Rotate is
      Angle  : constant Single := 90.0;
      Offset : constant Vector4 := (2.0, 3.0, 4.0, 1.0);

      Expected : Matrix4 := Rz (Angle) * Ry (Angle) * Rx (Angle);
      Result   : Matrix4 := T (Offset);
   begin
      Expected (W) := Offset;
      Rotate (Result, (0.0, 1.0, 0.0, 1.0), Angle, Offset);

      for I in Index_Homogeneous loop
         Assert (Expected (I) = Result (I), "Unexpected vector at " & Index_Homogeneous'Image (I));
      end loop;
   end Test_Rotate;

   procedure Test_Rotate_X_At_Origin is
      Angle  : constant Single  := 90.0;
      Offset : constant Vector4 := (2.0, 3.0, 4.0, 1.0);

      CA : constant Single := Elementary_Functions.Cos (Angle, 360.0);
      SA : constant Single := Elementary_Functions.Sin (Angle, 360.0);

      Expected : constant Matrix4
        := ((1.0,  0.0, 0.0, 0.0),
            (0.0,   CA,  SA, 0.0),
            (0.0,  -SA,  CA, 0.0),
            (2.0, -4.0, 3.0, 1.0));

      Result : Matrix4 := T (Offset);
   begin
      Rotate_X_At_Origin (Result, Angle);

      for I in Index_Homogeneous loop
         Assert (Expected (I) = Result (I), "Unexpected vector at " & Index_Homogeneous'Image (I));
      end loop;
   end Test_Rotate_X_At_Origin;

   procedure Test_Rotate_Y_At_Origin is
      Angle  : constant Single  := 90.0;
      Offset : constant Vector4 := (2.0, 3.0, 4.0, 1.0);

      CA : constant Single := Elementary_Functions.Cos (Angle, 360.0);
      SA : constant Single := Elementary_Functions.Sin (Angle, 360.0);

      Expected : constant Matrix4
        := ((CA,  0.0,  -SA, 0.0),
            (0.0, 1.0,  0.0, 0.0),
            (SA,  0.0,   CA, 0.0),
            (4.0, 3.0, -2.0, 1.0));

      Result : Matrix4 := T (Offset);
   begin
      Rotate_Y_At_Origin (Result, Angle);

      for I in Index_Homogeneous loop
         Assert (Expected (I) = Result (I), "Unexpected vector at " & Index_Homogeneous'Image (I));
      end loop;
   end Test_Rotate_Y_At_Origin;

   procedure Test_Rotate_Z_At_Origin is
      Angle  : constant Single  := 90.0;
      Offset : constant Vector4 := (2.0, 3.0, 4.0, 1.0);

      CA : constant Single := Elementary_Functions.Cos (Angle, 360.0);
      SA : constant Single := Elementary_Functions.Sin (Angle, 360.0);

      Expected : constant Matrix4
        := ((CA,    SA, 0.0, 0.0),
            (-SA,   CA, 0.0, 0.0),
            (0.0,  0.0, 1.0, 0.0),
            (-3.0, 2.0, 4.0, 1.0));

      Result : Matrix4 := T (Offset);
   begin
      Rotate_Z_At_Origin (Result, Angle);

      for I in Index_Homogeneous loop
         Assert (Expected (I) = Result (I), "Unexpected vector at " & Index_Homogeneous'Image (I));
      end loop;
   end Test_Rotate_Z_At_Origin;

   procedure Test_Rotate_X is
      Angle  : constant Single  := 90.0;
      Offset : constant Vector4 := (2.0, 3.0, 4.0, 1.0);

      CA : constant Single := Elementary_Functions.Cos (Angle, 360.0);
      SA : constant Single := Elementary_Functions.Sin (Angle, 360.0);

      Expected : constant Matrix4
        := ((1.0,  0.0, 0.0, 0.0),
            (0.0,   CA,  SA, 0.0),
            (0.0,  -SA,  CA, 0.0),
            Offset);

      Result : Matrix4 := T (Offset);
   begin
      Rotate_X (Result, Angle, Offset);

      for I in Index_Homogeneous loop
         Assert (Expected (I) = Result (I), "Unexpected vector at " & Index_Homogeneous'Image (I));
      end loop;
   end Test_Rotate_X;

   procedure Test_Rotate_Y is
      Angle  : constant Single  := 90.0;
      Offset : constant Vector4 := (2.0, 3.0, 4.0, 1.0);

      CA : constant Single := Elementary_Functions.Cos (Angle, 360.0);
      SA : constant Single := Elementary_Functions.Sin (Angle, 360.0);

      Expected : constant Matrix4
        := ((CA,  0.0,  -SA, 0.0),
            (0.0, 1.0,  0.0, 0.0),
            (SA,  0.0,   CA, 0.0),
            Offset);

      Result : Matrix4 := T (Offset);
   begin
      Rotate_Y (Result, Angle, Offset);

      for I in Index_Homogeneous loop
         Assert (Expected (I) = Result (I), "Unexpected vector at " & Index_Homogeneous'Image (I));
      end loop;
   end Test_Rotate_Y;

   procedure Test_Rotate_Z is
      Angle  : constant Single  := 90.0;
      Offset : constant Vector4 := (2.0, 3.0, 4.0, 1.0);

      CA : constant Single := Elementary_Functions.Cos (Angle, 360.0);
      SA : constant Single := Elementary_Functions.Sin (Angle, 360.0);

      Expected : constant Matrix4
        := ((CA,    SA, 0.0, 0.0),
            (-SA,   CA, 0.0, 0.0),
            (0.0,  0.0, 1.0, 0.0),
            Offset);

      Result : Matrix4 := T (Offset);
   begin
      Rotate_Z (Result, Angle, Offset);

      for I in Index_Homogeneous loop
         Assert (Expected (I) = Result (I), "Unexpected vector at " & Index_Homogeneous'Image (I));
      end loop;
   end Test_Rotate_Z;

   procedure Test_Translate is
      Offset : constant Vector4 := (2.0, 3.0, 4.0, 1.0);

      Expected : constant Matrix4
        := ((1.0, 0.0, 0.0, 0.0),
            (0.0, 1.0, 0.0, 0.0),
            (0.0, 0.0, 1.0, 0.0),
            Offset);

      Result : Matrix4 := Identity_Value;
   begin
      Translate (Result, Offset);

      for I in Index_Homogeneous loop
         Assert (Expected (I) = Result (I), "Unexpected vector at " & Index_Homogeneous'Image (I));
      end loop;
   end Test_Translate;

   procedure Test_Scale_Factors is
      Factors : constant Vector4 := (2.0, 3.0, 4.0, 0.0);

      Expected : constant Matrix4
        := ((Factors (X), 0.0, 0.0, 0.0),
            (0.0, Factors (Y), 0.0, 0.0),
            (0.0, 0.0, Factors (Z), 0.0),
            (0.0, 0.0, 0.0, 1.0));

      Result : Matrix4 := Identity_Value;
   begin
      Scale (Result, Factors);

      for I in Index_Homogeneous loop
         Assert (Expected (I) = Result (I), "Unexpected vector at " & Index_Homogeneous'Image (I));
      end loop;
   end Test_Scale_Factors;

   procedure Test_Scale_Factor is
      Factor : constant Single := 2.0;

      Expected : constant Matrix4
        := ((Factor, 0.0, 0.0, 0.0),
            (0.0, Factor, 0.0, 0.0),
            (0.0, 0.0, Factor, 0.0),
            (0.0, 0.0, 0.0, 1.0));

      Result : Matrix4 := Identity_Value;
   begin
      Scale (Result, Factor);

      for I in Index_Homogeneous loop
         Assert (Expected (I) = Result (I), "Unexpected vector at " & Index_Homogeneous'Image (I));
      end loop;
   end Test_Scale_Factor;

   procedure Test_Transpose is
      Result : Matrix4
        := ((1.0, 11.0, 14.0, 16.0),
            (5.0,  2.0, 12.0, 15.0),
            (8.0,  6.0,  3.0, 13.0),
            (10.0, 9.0,  7.0,  4.0));

      Expected : constant Matrix4
        := ((1.0,   5.0,  8.0, 10.0),
            (11.0,  2.0,  6.0,  9.0),
            (14.0, 12.0,  3.0,  7.0),
            (16.0, 15.0, 13.0,  4.0));
   begin
      Transpose (Result);

      for I in Index_Homogeneous loop
         Assert (Expected (I) = Result (I), "Unexpected vector at " & Index_Homogeneous'Image (I));
      end loop;
   end Test_Transpose;

end Test_Transforms_Singles_Matrices;
