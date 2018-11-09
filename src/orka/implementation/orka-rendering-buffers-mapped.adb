--  Copyright (c) 2017 onox <denkpadje@gmail.com>
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

package body Orka.Rendering.Buffers.Mapped is

   function GL_Buffer (Object : Mapped_Buffer) return GL.Objects.Buffers.Buffer is
     (Object.Buffer.GL_Buffer);

   function Length (Object : Mapped_Buffer) return Natural is
     (Object.Buffer.Length);

   procedure Map
     (Object : in out Mapped_Buffer;
      Length : Size;
      Flags  : GL.Objects.Buffers.Access_Bits) is
   begin
      case Object.Kind is
         when Single_Vector_Type =>
            Pointers.Single_Vector4.Map_Range
              (Object.Buffer.Buffer, Flags, 0, Length, Object.Pointer_SV);
         when Double_Vector_Type =>
            Pointers.Double_Vector4.Map_Range
              (Object.Buffer.Buffer, Flags, 0, Length, Object.Pointer_DV);
         when Single_Matrix_Type =>
            Pointers.Single_Matrix4.Map_Range
              (Object.Buffer.Buffer, Flags, 0, Length, Object.Pointer_SM);
         when Double_Matrix_Type =>
            Pointers.Double_Matrix4.Map_Range
              (Object.Buffer.Buffer, Flags, 0, Length, Object.Pointer_DM);
         when Arrays_Command_Type =>
            Pointers.Arrays_Command.Map_Range
              (Object.Buffer.Buffer, Flags, 0, Length, Object.Pointer_AC);
         when Elements_Command_Type =>
            Pointers.Elements_Command.Map_Range
              (Object.Buffer.Buffer, Flags, 0, Length, Object.Pointer_EC);
         when Dispatch_Command_Type =>
            Pointers.Dispatch_Command.Map_Range
              (Object.Buffer.Buffer, Flags, 0, Length, Object.Pointer_DC);
      end case;
   end Map;

   -----------------------------------------------------------------------------

   overriding
   procedure Bind_Base
     (Object : Mapped_Buffer;
      Target : Buffer_Target;
      Index  : Natural)
   is
      Buffer_Target : access constant GL.Objects.Buffers.Buffer_Target;

      Offset : constant Size := Size (Object.Offset);
      Length : constant Size := Size (Object.Length);
   begin
      case Target is
         when Uniform =>
            Buffer_Target := GL.Objects.Buffers.Uniform_Buffer'Access;
         when Transform_Feedback =>
            Buffer_Target := GL.Objects.Buffers.Transform_Feedback_Buffer'Access;
         when Shader_Storage =>
            Buffer_Target := GL.Objects.Buffers.Shader_Storage_Buffer'Access;
         when Atomic_Counter =>
            Buffer_Target := GL.Objects.Buffers.Atomic_Counter_Buffer'Access;
      end case;

      case Object.Kind is
         when Single_Vector_Type =>
            Pointers.Single_Vector4.Bind_Range
              (Buffer_Target.all, Object.GL_Buffer, Index, Offset, Length);
         when Double_Vector_Type =>
            Pointers.Double_Vector4.Bind_Range
              (Buffer_Target.all, Object.GL_Buffer, Index, Offset, Length);
         when Single_Matrix_Type =>
            Pointers.Single_Matrix4.Bind_Range
              (Buffer_Target.all, Object.GL_Buffer, Index, Offset, Length);
         when Double_Matrix_Type =>
            Pointers.Double_Matrix4.Bind_Range
              (Buffer_Target.all, Object.GL_Buffer, Index, Offset, Length);
         when Arrays_Command_Type =>
            Pointers.Arrays_Command.Bind_Range
              (Buffer_Target.all, Object.GL_Buffer, Index, Offset, Length);
         when Elements_Command_Type =>
            Pointers.Elements_Command.Bind_Range
              (Buffer_Target.all, Object.GL_Buffer, Index, Offset, Length);
         when Dispatch_Command_Type =>
            Pointers.Dispatch_Command.Bind_Range
              (Buffer_Target.all, Object.GL_Buffer, Index, Offset, Length);
      end case;
   end Bind_Base;

   -----------------------------------------------------------------------------

   procedure Write_Data
     (Object : Mapped_Buffer;
      Data   : Orka.Types.Singles.Vector4_Array;
      Offset : Natural := 0) is
   begin
      Pointers.Single_Vector4.Set_Mapped_Data
        (Object.Pointer_SV, Size (Object.Offset + Offset), Data);
   end Write_Data;

   procedure Write_Data
     (Object : Mapped_Buffer;
      Data   : Orka.Types.Singles.Matrix4_Array;
      Offset : Natural := 0) is
   begin
      Pointers.Single_Matrix4.Set_Mapped_Data
        (Object.Pointer_SM, Size (Object.Offset + Offset), Data);
   end Write_Data;

   procedure Write_Data
     (Object : Mapped_Buffer;
      Data   : Orka.Types.Doubles.Vector4_Array;
      Offset : Natural := 0) is
   begin
      Pointers.Double_Vector4.Set_Mapped_Data
        (Object.Pointer_DV, Size (Object.Offset + Offset), Data);
   end Write_Data;

   procedure Write_Data
     (Object : Mapped_Buffer;
      Data   : Orka.Types.Doubles.Matrix4_Array;
      Offset : Natural := 0) is
   begin
      Pointers.Double_Matrix4.Set_Mapped_Data
        (Object.Pointer_DM, Size (Object.Offset + Offset), Data);
   end Write_Data;

   procedure Write_Data
     (Object : Mapped_Buffer;
      Data   : Indirect.Arrays_Indirect_Command_Array;
      Offset : Natural := 0) is
   begin
      Pointers.Arrays_Command.Set_Mapped_Data
        (Object.Pointer_AC, Size (Object.Offset + Offset), Data);
   end Write_Data;

   procedure Write_Data
     (Object : Mapped_Buffer;
      Data   : Indirect.Elements_Indirect_Command_Array;
      Offset : Natural := 0) is
   begin
      Pointers.Elements_Command.Set_Mapped_Data
        (Object.Pointer_EC, Size (Object.Offset + Offset), Data);
   end Write_Data;

   procedure Write_Data
     (Object : Mapped_Buffer;
      Data   : Indirect.Dispatch_Indirect_Command_Array;
      Offset : Natural := 0) is
   begin
      Pointers.Dispatch_Command.Set_Mapped_Data
        (Object.Pointer_DC, Size (Object.Offset + Offset), Data);
   end Write_Data;

   -----------------------------------------------------------------------------

   procedure Write_Data
     (Object : Mapped_Buffer;
      Value  : Orka.Types.Singles.Vector4;
      Offset : Natural) is
   begin
      Pointers.Single_Vector4.Set_Mapped_Data
        (Object.Pointer_SV, Size (Object.Offset + Offset), Value);
   end Write_Data;

   procedure Write_Data
     (Object : Mapped_Buffer;
      Value  : Orka.Types.Singles.Matrix4;
      Offset : Natural) is
   begin
      Pointers.Single_Matrix4.Set_Mapped_Data
        (Object.Pointer_SM, Size (Object.Offset + Offset), Value);
   end Write_Data;

   procedure Write_Data
     (Object : Mapped_Buffer;
      Value  : Orka.Types.Doubles.Vector4;
      Offset : Natural) is
   begin
      Pointers.Double_Vector4.Set_Mapped_Data
        (Object.Pointer_DV, Size (Object.Offset + Offset), Value);
   end Write_Data;

   procedure Write_Data
     (Object : Mapped_Buffer;
      Value  : Orka.Types.Doubles.Matrix4;
      Offset : Natural) is
   begin
      Pointers.Double_Matrix4.Set_Mapped_Data
        (Object.Pointer_DM, Size (Object.Offset + Offset), Value);
   end Write_Data;

   procedure Write_Data
     (Object : Mapped_Buffer;
      Value  : Indirect.Arrays_Indirect_Command;
      Offset : Natural) is
   begin
      Pointers.Arrays_Command.Set_Mapped_Data
        (Object.Pointer_AC, Size (Object.Offset + Offset), Value);
   end Write_Data;

   procedure Write_Data
     (Object : Mapped_Buffer;
      Value  : Indirect.Elements_Indirect_Command;
      Offset : Natural) is
   begin
      Pointers.Elements_Command.Set_Mapped_Data
        (Object.Pointer_EC, Size (Object.Offset + Offset), Value);
   end Write_Data;

   procedure Write_Data
     (Object : Mapped_Buffer;
      Value  : Indirect.Dispatch_Indirect_Command;
      Offset : Natural) is
   begin
      Pointers.Dispatch_Command.Set_Mapped_Data
        (Object.Pointer_DC, Size (Object.Offset + Offset), Value);
   end Write_Data;

end Orka.Rendering.Buffers.Mapped;
