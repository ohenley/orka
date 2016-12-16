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

package body Orka.Buffers.MDI is

   function Create_Batch (Vertex_Length : Positive) return Batch is
   begin
      return (Vertex_Length => Vertex_Length, others => <>);
   end Create_Batch;

   procedure Append (Object : in out Batch;
                     Vertices : not null Indirect.Single_Array_Access;
                     Indices  : not null Indirect.UInt_Array_Access;
                     Instance_Index : out Natural) is
   begin
      Instance_Index := Object.Length;

      Object.Vertices.Append (Vertices);
      Object.Indices.Append (Indices);
   end Append;

   procedure Clear (Object : in out Batch) is
   begin
      for Vertices of Object.Vertices loop
         Indirect.Free_Array (Vertices);
      end loop;
      for Indices of Object.Indices loop
         Indirect.Free_Array (Indices);
      end loop;
      Object.Vertices.Clear;
      Object.Indices.Clear;
   end Clear;

   function Length (Object : Batch) return Natural
     is (Natural (Object.Vertices.Length));

   function Create_Buffers (Object : Batch;
                            Usage   : GL.Objects.Buffers.Buffer_Usage;
                            Visible : Boolean := True) return MDI_Buffers
   is
      Commands  : Indirect.Elements_Indirect_Command_Array (1 .. Int (Object.Length));
      Instances : constant UInt := (if Visible then 1 else 0);

      VBO_Length, IBO_Length : Size := 0;

      Instances_Array : UInt_Array (0 .. Int (Object.Length - 1));
   begin
      --  Compute size of vertex and index buffers
      for I in Commands'Range loop
         VBO_Length := VBO_Length + Object.Vertices (I).all'Length;
         IBO_Length := IBO_Length + Object.Indices  (I).all'Length;
      end loop;

      declare
         Vertices : Single_Array (0 .. VBO_Length - 1);
         Indices  : UInt_Array   (0 .. IBO_Length - 1);

         Part_Vertex_Count, Part_Index_Count : Size;
         Vertex_Offset, Index_Offset : Size := 0;

         VA_First, VA_Last : Size := 0;
         IA_First, IA_Last : Size := 0;
      begin
         for I in Commands'Range loop
            Part_Vertex_Count := Object.Vertices (I).all'Length / Positive_Size (Object.Vertex_Length);
            Part_Index_Count  := Object.Indices  (I).all'Length;

            VA_First := Vertex_Offset * Positive_Size (Object.Vertex_Length);
            VA_Last  := VA_First + Part_Vertex_Count * Positive_Size (Object.Vertex_Length) - 1;

            IA_First := Index_Offset;
            IA_Last  := IA_First + Part_Index_Count - 1;

            --  Copy part data to a slice of the vertices and indices arrays
            Vertices (VA_First .. VA_Last) := Object.Vertices (I).all;
            Indices  (IA_First .. IA_Last) := Object.Indices (I).all;

            --  Create draw command
            Commands (I) := (Count         => UInt (Part_Index_Count),
                             Instances     => Instances,
                             First_Index   => UInt (Index_Offset),
                             Base_Vertex   => UInt (Vertex_Offset),
                             Base_Instance => UInt (I - Commands'First));

            Vertex_Offset := Vertex_Offset + Part_Vertex_Count;
            Index_Offset  := Index_Offset  + Part_Index_Count;
         end loop;

         pragma Assert (Vertices'Last = VA_Last);
         pragma Assert (Indices'Last  = IA_Last);

         for I in Instances_Array'Range loop
            Instances_Array (I) := UInt (I);
         end loop;

         return Result : MDI_Buffers := (others => Orka.Buffers.Create_Buffer (Usage)) do
            Result.Vertex_Buffer.Set_Data  (Vertices);
            Result.Index_Buffer.Set_Data   (Indices);
            Result.Command_Buffer.Set_Data (Commands);
            Result.Instances_Buffer.Set_Data (Instances_Array);
         end return;
      end;
   end Create_Buffers;

end Orka.Buffers.MDI;