--  SPDX-License-Identifier: Apache-2.0
--
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

with System;

with Interfaces.C.Strings;

with Ada.Unchecked_Deallocation;

with GL.API;
with GL.Enums.Getter;

package body GL.Debug is

   Any : constant Low_Level.Enum := 16#1100#;

   Current_Callback : Callback_Reference := null;

   procedure Debug_Callback
     (From      : Source;
      Kind      : Message_Type;
      ID        : GL.Types.UInt;
      Level     : Severity;
      Length    : GL.Types.Size;
      C_Message : C.Strings.chars_ptr;
      User_Data : System.Address)
   with Convention => StdCall;

   procedure Debug_Callback
     (From      : Source;
      Kind      : Message_Type;
      ID        : GL.Types.UInt;
      Level     : Severity;
      Length    : GL.Types.Size;
      C_Message : C.Strings.chars_ptr;
      User_Data : System.Address)
   is
      Message : constant String := C.Strings.Value (C_Message, C.size_t (Length));
   begin
      if Current_Callback /= null then
         Current_Callback (From, Kind, Level, ID, Message);
      end if;
   end Debug_Callback;

   procedure Set_Message_Callback (Callback : not null Callback_Reference) is
   begin
      API.Debug_Message_Callback.Ref (Debug_Callback'Address, System.Null_Address);
      Current_Callback := Callback;
   end Set_Message_Callback;

   procedure Disable_Message_Callback is
   begin
      API.Debug_Message_Callback.Ref (System.Null_Address, System.Null_Address);
      Current_Callback := null;
   end Disable_Message_Callback;

   procedure Set (From : Source; Kind : Message_Type; Level : Severity;
                  Enabled : Boolean) is
      Identifiers : Types.UInt_Array (1 .. 0);
   begin
      API.Debug_Message_Control.Ref
        (From, Kind, Level, 0, Identifiers, Low_Level.Bool (Enabled));
   end Set;

   procedure Set (Level : Severity; Enabled : Boolean) is
      Identifiers : Types.UInt_Array (1 .. 0);
   begin
      API.Debug_Message_Control_Level.Ref
        (Any, Any, Level, 0, Identifiers, Low_Level.Bool (Enabled));
   end Set;

   procedure Set (From : Source; Kind : Message_Type; Identifiers : Types.UInt_Array;
                  Enabled : Boolean) is
   begin
      API.Debug_Message_Control_Any_Level.Ref
        (From, Kind, Any, Types.Size (Identifiers'Length),
         Identifiers, Low_Level.Bool (Enabled));
   end Set;

   procedure Insert_Message (From : Source; Kind : Message_Type; Level : Severity;
                             Identifier : UInt; Message : String) is
      pragma Assert (From in Third_Party | Application);
   begin
      API.Debug_Message_Insert.Ref (From, Kind, Identifier, Level,
                                Types.Size (Message'Length), C.To_C (Message));
   end Insert_Message;

   function Push_Debug_Group (From : Source; Identifier : UInt; Message : String)
     return Active_Group'Class is
      pragma Assert (From in Third_Party | Application);
   begin
      API.Push_Debug_Group.Ref (From, Identifier,
                            Types.Size (Message'Length), C.To_C (Message));
      return Active_Group'(Ada.Finalization.Limited_Controlled with Finalized => False);
   end Push_Debug_Group;

   overriding
   procedure Finalize (Object : in out Active_Group) is
   begin
      if not Object.Finalized then
         API.Pop_Debug_Group.Ref.all;
         Object.Finalized := True;
      end if;
   end Finalize;

   procedure Annotate (Object : GL.Objects.GL_Object'Class; Message : String) is
   begin
      API.Object_Label.Ref
        (Object.Identifier, Object.Raw_Id, Types.Size (Message'Length), C.To_C (Message));
   end Annotate;

   function Get_Label (Object : GL.Objects.GL_Object'Class) return String is
      procedure Free is new Ada.Unchecked_Deallocation
         (Object => Types.Size, Name => GL.Low_Level.Size_Access);

      C_Size : GL.Low_Level.Size_Access := new Types.Size'(0);
      Label_Size : Types.Size := 0;
   begin
      API.Get_Object_Label_Length.Ref
        (Object.Identifier, Object.Raw_Id, 0,
         C_Size, Interfaces.C.Strings.Null_Ptr);

      --  Deallocate before potentially raising an exception
      Label_Size := C_Size.all;
      Free (C_Size);

      if Label_Size = 0 then
         return "";
      end if;

      declare
         Label : String (1 .. Integer (Label_Size));
      begin
         API.Get_Object_Label.Ref
           (Object.Identifier, Object.Raw_Id, Label_Size, Label_Size, Label);
         return Label;
      end;
   end Get_Label;

   function Max_Message_Length return Size is
      Result : Int := 0;
   begin
      API.Get_Integer.Ref (Enums.Getter.Max_Debug_Message_Length, Result);
      return Result;
   end Max_Message_Length;

   package body Messages is
      procedure Log (Level : Severity; Message : String) is
      begin
         GL.Debug.Insert_Message (From, Kind, Level, ID, Message);
      end Log;
   end Messages;

end GL.Debug;
