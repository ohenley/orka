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

package body Orka.Rendering.Buffers.MDI is

   procedure Append
     (Object : in out Batch;
      Positions : not null Indirect.Half_Array_Access;
      Normals   : not null Indirect.Half_Array_Access;
      UVs       : not null Indirect.Half_Array_Access;
      Indices   : not null Indirect.UInt_Array_Access)
   is
      Index_Count  : constant Natural := Indices'Length;
      Vertex_Count : constant Natural := Positions'Length / 3;
      --  TODO Don't hardcode

      pragma Assert (Positions'Length = Normals'Length);
      pragma Assert (Vertex_Count = UVs'Length / 2);

      Commands : Indirect.Elements_Indirect_Command_Array (1 .. 1);
   begin
      Commands (1) :=
        (Count         => UInt (Index_Count),
         Instances     => (if Object.Visible then 1 else 0),
         First_Index   => UInt (Object.Index_Offset),
         Base_Vertex   => UInt (Object.Vertex_Offset),
         Base_Instance => UInt (Object.Index));

      --  Upload attributes to VBO's
      Object.Positions.Set_Data (Positions.all, Offset => Object.Vertex_Offset * 3);
      Object.Normals.Set_Data   (Normals.all,   Offset => Object.Vertex_Offset * 3);
      Object.UVs.Set_Data       (UVs.all,       Offset => Object.Vertex_Offset * 2);

      --  Upload indices to IBO
      Object.Indices.Set_Data (Indices.all, Offset => Object.Index_Offset);

      --  Upload command to command buffer
      Object.Commands.Set_Data (Commands, Offset => Object.Index);

      Object.Index_Offset  := Object.Index_Offset  + Index_Count;
      Object.Vertex_Offset := Object.Vertex_Offset + Vertex_Count;
      Object.Index := Object.Index + 1;
   end Append;

   function Create_Batch
     (Parts, Vertices, Indices : Positive;
      Format  : not null access Rendering.Vertex_Formats.Vertex_Format;
      Flags   : GL.Objects.Buffers.Storage_Bits;
      Visible : Boolean := True) return Batch
   is
      Instances_Array : UInt_Array (0 .. Int (Parts - 1));
   begin
      return Result : Batch do
         Result.Visible := Visible;

         --  Create array with the draw ID's
         for I in Instances_Array'Range loop
            Instances_Array (I) := UInt (I);
         end loop;

         Result.Instances := Buffers.Create_Buffer (Flags, Instances_Array);
         Result.Commands  := Buffers.Create_Buffer (Flags, Types.Elements_Command_Type, Parts);

         --  Attributes
         Result.Positions := Buffers.Create_Buffer (Flags, Format.Attribute_Kind (1), Vertices * 3);
         Result.Normals   := Buffers.Create_Buffer (Flags, Format.Attribute_Kind (2), Vertices * 3);
         Result.UVs       := Buffers.Create_Buffer (Flags, Format.Attribute_Kind (3), Vertices * 2);
         --  TODO Don't hardcode vector size factors

         --  Indices
         case Format.Index_Kind is
            when GL.Types.UByte_Type =>
               Result.Indices := Buffers.Create_Buffer (Flags, UByte_Type, Indices);
            when GL.Types.UShort_Type =>
               Result.Indices := Buffers.Create_Buffer (Flags, UShort_Type, Indices);
            when GL.Types.UInt_Type =>
               Result.Indices := Buffers.Create_Buffer (Flags, UInt_Type, Indices);
         end case;
      end return;
   end Create_Batch;

end Orka.Rendering.Buffers.MDI;
