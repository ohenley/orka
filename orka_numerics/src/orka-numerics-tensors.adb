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

package body Orka.Numerics.Tensors is

   function Elements (Shape : Tensor_Shape) return Natural is
      Result : Natural := 1;
   begin
      for Elements of Shape loop
         Result := Result * Elements;
      end loop;

      return Result;
   end Elements;

   function Add (Left, Right : Tensor_Shape; Dimension : Tensor_Dimension) return Tensor_Shape is
      Result : Tensor_Shape := Left;
   begin
      Result (Dimension) := Result (Dimension) + Right (Dimension);

      return Result;
   end Add;

   function To_Index (Index : Tensor_Index; Shape : Tensor_Shape) return Index_Type is
      Result : Index_Type := Index (Index'Last);
      Size   : Natural    := Shape (Index'Last);
   begin
      for Dimension in reverse 1 .. Index'Last - 1 loop
         Result := (Index (Dimension) - 1) * Size + Result;
         Size   := Size * Shape (Dimension);
      end loop;

      return Result;
   end To_Index;

   function Shape (Index : Tensor_Range) return Tensor_Shape is
   begin
      return Result : Tensor_Shape (Index'Range) do
         for Dimension in Result'Range loop
            Result (Dimension) := Index (Dimension).Stop - Index (Dimension).Start + 1;
         end loop;
      end return;
   end Shape;

   function Full_Range (Shape : Tensor_Shape; Index : Tensor_Range) return Tensor_Range is
      Result : Tensor_Range (Shape'Range);
   begin
      for Dimension in Result'Range loop
         if Dimension in Index'Range then
            Result (Dimension) := Index (Dimension);
         else
            Result (Dimension) := (Start => 1, Stop => Shape (Dimension));
         end if;
      end loop;

      return Result;
   end Full_Range;

   function Full_Shape
     (Dimensions : Tensor_Dimension;
      Shape      : Tensor_Shape;
      Justify    : Alignment) return Tensor_Shape
   is
      Result : Tensor_Shape (1 .. Dimensions) := (others => 1);
      Offset : constant Tensor_Dimension'Base :=
        (case Justify is
           when Left  => 0,
           when Right => Result'Last - Shape'Last);
   begin
      for Dimension in Shape'Range loop
         Result (Offset + Dimension) := Shape (Dimension);
      end loop;

      return Result;
   end Full_Shape;

   function Trim (Value : Natural) return String is
      Result : constant String := Value'Image;
   begin
      return Result (Result'First + 1 .. Result'Last);
   end Trim;

   function Image (Shape : Tensor_Shape) return String is
     (case Shape'Length is
        when 1 =>
           "(" & Trim (Shape (1)) & ")",
        when 2 =>
           "(" & Trim (Shape (1)) & ", " & Trim (Shape (2)) & ")",
        when others =>
           raise Program_Error);

   ----------------------------------------------------------------------------

   package body Generic_Random is

      --  Box-Muller method for the standard normal distribution
      --
      --  Alternatively, (U_1 + ... + U_12) - 6.0 uses the central limit
      --  theorem to approximate the standard normal distribution with
      --  samples limited to (-6, 6). 0.00034 % of the actual standard normal
      --  distribution falls outside this range.
      function Normal (Shape : Tensor_Shape) return Random_Tensor is
        (Multiply (Sqrt (-2.0 * Log (Uniform (Shape) + Element'Model_Small)),
           Cos ((2.0 * Ada.Numerics.Pi) * Uniform (Shape))));

      function Binomial
        (Shape : Tensor_Shape;
         N     : Positive;
         P     : Probability) return Random_Tensor
      is
         Result : Random_Tensor := Zeros (Shape);
      begin
         for Index in 1 .. N loop
            Result := Result + (1.0 and (Uniform (Shape) <= Element (P)));
         end loop;

         return Result;
      end Binomial;

      function Geometric (Shape : Tensor_Shape; P : Probability) return Random_Tensor is
        (Floor (Exponential (Shape, -EF.Log (Element (1.0 - P) + Element'Model_Small))));

      function Poisson (Shape : Tensor_Shape; Lambda : Element) return Random_Tensor is
         U : constant Random_Tensor := Uniform (Shape);

         use EF;

         I    : Random_Tensor := Zeros (Shape);
         Expr : Random_Tensor := Fill (Shape, Ada.Numerics.e ** (-Lambda));
         Sum  : Random_Tensor := Expr;
      begin
         loop
            declare
               Loop_Condition : constant Random_Tensor := U > Sum;
            begin
               exit when not Any_True (Loop_Condition);

               --  Using inverse transform sampling (with y is lambda):
               --  P = min{p = 0, 1, 2, ... | U <= exp(-y) * Sum (y^i / i! for i in 0 .. p)}
               I    := I + (1.0 and Loop_Condition);
               Expr := Expr * Lambda / I;
               Sum  := Sum + (Expr and Loop_Condition);
            end;
         end loop;

         return I;
      end Poisson;

      function Gamma (Shape : Tensor_Shape; K, Theta : Element) return Random_Tensor is
         D : constant Element := K - 1.0 / 3.0;
         C : constant Element := 1.0 / EF.Sqrt (9.0 * D);

         Result   : Random_Tensor := Zeros (Shape);
         Fraction : Random_Tensor := Zeros (Shape);
      begin
         for I in 1 .. Integer (Element'Floor (K)) loop
            Result := Result + Log (Uniform (Shape) + Element'Model_Small);
         end loop;

         --  Marsaglia's transformation-rejection method [1]
         --
         --  [1] "A Simple Method for Generating Gamma Variables", Marsaglia G., Tsang W.,
         --      ACM Trans. Math. Softw., 26.3:363−372, 2000
         --
         --  See https://en.wikipedia.org/wiki/Gamma_distribution
         declare
            Loop_Condition : Random_Tensor := Fraction /= Fraction;
         begin
            loop
               declare
                  X : constant Random_Tensor := Normal (Shape);
                  U : constant Random_Tensor := Log (Uniform (Shape) + Element'Model_Small);

                  V  : constant Random_Tensor := Power (1.0 + C * X, 3);
                  DV : constant Random_Tensor := D * V;

                  --  (Check that -1.0 / C < X, otherwise Log (V) will fail because V <= 0.0)
                  If_Condition : constant Random_Tensor :=
                    V > 0.0 and -1.0 / C < X and
                      U < 0.5 * Power (X, 2) + D - DV
                            + D * Log (Max (0.0, V) + Element'Model_Small);
               begin
                  --  Update Fraction with value DV but not if the element was already true before
                  Fraction := Fraction + DV and And_Not (Loop_Condition, If_Condition);

                  Loop_Condition := Loop_Condition or If_Condition;
                  exit when All_True (Loop_Condition);
               end;
            end loop;
         end;

         return Theta * (Fraction - Result);
      end Gamma;

      --  Beta (Alpha, Beta) = X / (X + Y) where X ~ Gamma(Alpha, Theta) and Y ~ Gamma(Beta, Theta)
      function Beta (Shape : Tensor_Shape; Alpha, Beta : Element) return Random_Tensor is
         X : constant Random_Tensor := Gamma (Shape, Alpha, 1.0);
         Y : constant Random_Tensor := Gamma (Shape, Beta, 1.0);
      begin
         return X / (X + Y);
      end Beta;

      function Test_Statistic_T_Test (Data : Random_Tensor; True_Mean : Element) return Element is
         Sample_Mean : constant Element := Data.Mean;
         Sample_Std  : constant Element := Data.Standard_Deviation (Offset => 1);
      begin
         return (Sample_Mean - True_Mean) / (Sample_Std / EF.Sqrt (Element (Data.Elements)));
      end Test_Statistic_T_Test;

      function Threshold_T_Test
        (Data  : Random_Tensor;
         Level : Probability) return Element
      is
         Sample_Std : constant Element := Data.Standard_Deviation (Offset => 1);

         use EF;

         --  Simple approximation by Shore (1982)
--         T_Value : constant Element := 5.5556 * (1.0 - Element (Level / (1.0 - Level))**0.1186);

         --  "A handy approximation for the error function and its inverse", Winitzki S., 2008,
         --  equation 7.
         function Inverse_Erf (X : Probability) return Element is
            A        : constant := 0.147;
            Two_Pi_A : constant := 2.0 / (Ada.Numerics.Pi * A);

            Ln_X2          : constant Element := Log (1.0 - Element (X)**2);
            Two_Pi_A_Ln_X2 : constant Element := Two_Pi_A + Ln_X2 / 2.0;
         begin
            return Sqrt (Sqrt (Two_Pi_A_Ln_X2**2 - Ln_X2 / A) - Two_Pi_A_Ln_X2);
         end Inverse_Erf;

         --  Quantile function of standard normal distribution
         T_Value : constant Element := Sqrt (2.0) * Inverse_Erf (2.0 * (1.0 - Level) - 1.0);
      begin
         return T_Value * (Sample_Std / EF.Sqrt (Element (Data.Elements)));
      end Threshold_T_Test;

   end Generic_Random;

end Orka.Numerics.Tensors;
