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

with GL.Types;

package GL.Drawing is
   pragma Preelaborate;

   use GL.Types;

   procedure Draw_Arrays (Mode : Connection_Mode; Offset, Count : Size);

   procedure Draw_Arrays
     (Mode : Connection_Mode;
      Offset, Count, Instances : Size;
      Base_Instance : Size := 0);

   procedure Draw_Multiple_Arrays (Mode : Connection_Mode; Offsets, Counts : Size_Array)
     with Pre => Offsets'Length = Counts'Length;

   procedure Draw_Multiple_Arrays_Indirect (Mode : Connection_Mode; Count : Size);

   procedure Draw_Multiple_Arrays_Indirect_Count
     (Mode         : Connection_Mode;
      Count_Offset : Natural;
      Max_Count    : Size)
   with Pre => Count_Offset mod 4 = 0;

   procedure Draw_Elements
     (Mode       : Connection_Mode; Count : Size;
      Index_Type : Unsigned_Numeric_Type;
      Index_Offset : Natural);

   procedure Draw_Elements
     (Mode       : Connection_Mode; Count : Size;
      Index_Type : Unsigned_Numeric_Type;
      Instances  : Size;
      Index_Offset  : Natural;
      Base_Instance : Size := 0);

   procedure Draw_Elements_Base_Vertex_Base_Instance
     (Mode       : Connection_Mode; Count : Size;
      Index_Type : Unsigned_Numeric_Type;
      Instances  : Size;
      Vertex_Offset, Index_Offset : Natural;
      Base_Instance : Size := 0);

   procedure Draw_Multiple_Elements (Mode : Connection_Mode;
                                     Index_Type : Unsigned_Numeric_Type;
                                     Counts, Index_Offsets : Size_Array)
     with Pre => Counts'Length = Index_Offsets'Length;

   procedure Draw_Multiple_Elements_Base_Vertex (Mode : Connection_Mode;
                                     Index_Type : Unsigned_Numeric_Type;
                                     Counts, Vertex_Offsets, Index_Offsets : Size_Array)
     with Pre => Counts'Length = Vertex_Offsets'Length and
                 Counts'Length = Index_Offsets'Length;

   procedure Draw_Multiple_Elements_Indirect
     (Mode       : Connection_Mode;
      Index_Type : Unsigned_Numeric_Type;
      Count      : Size);

   procedure Draw_Multiple_Elements_Indirect_Count
     (Mode         : Connection_Mode;
      Index_Type   : Unsigned_Numeric_Type;
      Count_Offset : Natural;
      Max_Count    : Size)
   with Pre => Count_Offset mod 4 = 0;

end GL.Drawing;
