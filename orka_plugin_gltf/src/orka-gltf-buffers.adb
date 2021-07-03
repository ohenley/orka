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

with Ada.Streams;
with Ada.Unchecked_Conversion;

with Orka.Base64;

package body Orka.glTF.Buffers is

   Data_Prefix : constant String := "data:application/octet-stream;base64,";

   function Base64_Encoded (Text : String) return Boolean is
     (Text'Length >= Data_Prefix'Length
        and then Text (Text'First .. Text'First + Data_Prefix'Length - 1) = Data_Prefix)
     with Inline;

   function Create_Buffer
     (Object    : Types.JSON_Value;
      Load_Path : not null access function (Path : String)
                    return Byte_Array_Pointers.Pointer) return Buffer
   is
      URI    : constant String := Object.Get ("uri").Value;
      Length : constant Long_Integer := Object.Get ("byteLength").Value;

      function Load_Data (URI : String) return Byte_Array_Pointers.Pointer is
         Encoded_Data : String renames URI (URI'First - 1 + Data_Prefix'Last + 1 .. URI'Last);
      begin
         if Base64_Encoded (URI) then
            declare
               Pointer : Byte_Array_Pointers.Pointer;
            begin
               Pointer.Set (new Byte_Array'(Base64.Decode (Encoded_Data)));
               return Pointer;
            end;
         else
            return Load_Path (URI);
         end if;
      end Load_Data;
   begin
      return Result : constant Buffer := Load_Data (URI) do
         pragma Assert (Result.Get.Value'Length = Length);
      end return;
   end Create_Buffer;

   function Create_Buffer_View
     (Buffers : Buffer_Vectors.Vector;
      Object  : Types.JSON_Value) return Buffer_View
   is
      Buffer : constant Long_Integer := Object.Get ("buffer").Value;
      Offset : constant Long_Integer := Object.Get ("byteOffset", 0).Value;
      Length : constant Long_Integer := Object.Get ("byteLength").Value;
      Target : constant Long_Integer := Object.Get ("target", 34962).Value;
      --  TODO target is optional: infer from accessors

      --  If byteStride is not defined, then data is tightly packed
      Packed : constant Boolean := not Object.Contains ("byteStride");
   begin
      return Result : Buffer_View (Packed => Packed) do
         Result.Buffer := Natural (Buffer);
         pragma Assert (Offset + Length <= Buffers (Result.Buffer).Get.Value'Length);

         Result.Offset := Natural (Offset);
         Result.Length := Natural (Length);
         Result.Target := Target_Kinds (Integer (Target));

         if not Packed then
            declare
               Stride : constant Long_Integer := Object.Get ("byteStride").Value;
            begin
               Result.Stride := Stride_Natural (Stride);
               pragma Assert (Result.Stride mod 4 = 0);
            end;
         end if;
      end return;
   end Create_Buffer_View;

   procedure Extract_From_Buffer
     (Buffers : Buffer_Vectors.Vector;
      View    : Buffer_View;
      Data    : out Element_Array)
   is
      use Ada.Streams;

      Offset : constant Stream_Element_Offset := Stream_Element_Offset (View.Offset);
      Length : constant Stream_Element_Offset := Stream_Element_Offset (View.Length);

      subtype Counted_Element_Array is Element_Array (Data'Range);

      function Convert is new Ada.Unchecked_Conversion
        (Source => Byte_Array, Target => Counted_Element_Array);
   begin
      Data := Convert (Byte_Array'(Buffers (View.Buffer).Get (Offset + 1 .. Offset + Length)));
   end Extract_From_Buffer;

   function Get_Buffers
     (Buffers   : Types.JSON_Value;
      Load_Path : not null access function (Path : String)
                    return Byte_Array_Pointers.Pointer) return Buffer_Vectors.Vector
   is
      Result : Buffer_Vectors.Vector (Capacity => Buffers.Length);
   begin
      for Buffer of Buffers loop
         Result.Append (Create_Buffer (Buffer, Load_Path));
      end loop;
      return Result;
   end Get_Buffers;

   function Get_Buffer_Views
     (Buffers : Buffer_Vectors.Vector;
      Views   : Types.JSON_Value) return Buffer_View_Vectors.Vector
   is
      Result : Buffer_View_Vectors.Vector (Capacity => Views.Length);
   begin
      for View of Views loop
         Result.Append (Create_Buffer_View (Buffers, View));
      end loop;
      return Result;
   end Get_Buffer_Views;

end Orka.glTF.Buffers;
