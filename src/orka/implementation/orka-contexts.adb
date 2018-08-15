--  Copyright (c) 2018 onox <denkpadje@gmail.com>
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

with GL.Buffers;
with GL.Clipping;
with GL.Shading;
with GL.Toggles;
with GL.Types;

package body Orka.Contexts is

   procedure Enable (Object : in out Context; Subject : Feature) is
   begin
      case Subject is
         when Reversed_Z =>
            --  Enable reversed Z for better depth precision at great distances
            --  See https://developer.nvidia.com/content/depth-precision-visualized
            --  for a visualization
            GL.Clipping.Set_Clipping (GL.Clipping.Lower_Left, GL.Clipping.Zero_To_One);
            GL.Buffers.Set_Depth_Clear_Value (0.0);
            GL.Buffers.Set_Depth_Function (GL.Types.Greater);
         when Multisample =>
            --  Enable MSAA
            GL.Toggles.Enable (GL.Toggles.Multisample);
         when Sample_Shading =>
            if not Object.Enabled (Multisample) then
               raise Program_Error with "MSAA not enabled";
            end if;

            --  Enable shading per-sample. Applies if MSAA is enabled.
            --  Provides better anti-aliasing for certain cases like
            --  alpha-tested transparency
            GL.Shading.Set_Minimum_Sample_Shading (1.0);
            GL.Toggles.Enable (GL.Toggles.Sample_Shading);
      end case;
      Object.Features (Subject) := True;
   end Enable;

   function Enabled (Object : Context; Subject : Feature) return Boolean is
     (Object.Features (Subject));

end Orka.Contexts;
