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

with Ada.Containers.Indefinite_Holders;

with GL.API;

package body GL.Objects.Transform_Feedbacks is

   Error_Checking_Suspended : Boolean := False;

   package Feedback_Object_Holder is new Ada.Containers.Indefinite_Holders
     (Element_Type => Feedback_Object'Class);

   type Feedback_Object_Target_Array is array (Low_Level.Enums.Transform_Feedback_Kind)
     of Feedback_Object_Holder.Holder;
   Current_Feedback_Objects : Feedback_Object_Target_Array;

   procedure Bind (Target : Feedback_Target; Object : Feedback_Object'Class) is
      Holder : Feedback_Object_Holder.Holder := Current_Feedback_Objects (Target.Kind);
   begin
      if Holder.Is_Empty or else Object /= Holder.Element then
         API.Bind_Transform_Feedback (Target.Kind, Object.Reference.GL_Id);
         if not Error_Checking_Suspended then
            Raise_Exception_On_OpenGL_Error;
         end if;
         Holder.Replace_Element (Object);
      end if;
   end Bind;

   procedure Bind_Base (Object : Feedback_Object;
                        Buffer : Objects.Buffers.Buffer'Class;
                        Index  : Natural) is
   begin
      API.Transform_Feedback_Buffer_Base (Object.Reference.GL_Id, UInt (Index), Buffer.Raw_Id);
      Raise_Exception_On_OpenGL_Error;
   end Bind_Base;

   function Current (Target : Feedback_Target) return Feedback_Object'Class is
      Holder : constant Feedback_Object_Holder.Holder := Current_Feedback_Objects (Target.Kind);
   begin
      if Holder.Is_Empty then
         raise No_Object_Bound_Exception with GL.Low_Level.Enums.Transform_Feedback_Kind'Image (Target.Kind);
      else
         return Holder.Element;
      end if;
   end Current;

   procedure Draw_Transform_Feedback (Object : Feedback_Object; Mode : Connection_Mode) is
   begin
      API.Draw_Transform_Feedback (Mode, Object.Reference.GL_Id);
      Raise_Exception_On_OpenGL_Error;
   end Draw_Transform_Feedback;

   procedure Draw_Transform_Feedback (Object : Feedback_Object;
                                      Mode : Connection_Mode; Instances : Size) is
   begin
      API.Draw_Transform_Feedback_Instanced (Mode, Object.Reference.GL_Id,
                                             Instances);
      Raise_Exception_On_OpenGL_Error;
   end Draw_Transform_Feedback;

   procedure Draw_Transform_Feedback_Stream (Object : Feedback_Object; Mode : Connection_Mode;
                                             Stream : Natural) is
   begin
      API.Draw_Transform_Feedback_Stream (Mode, Object.Reference.GL_Id, UInt (Stream));
      Raise_Exception_On_OpenGL_Error;
   end Draw_Transform_Feedback_Stream;

   procedure Draw_Transform_Feedback_Stream (Object : Feedback_Object; Mode : Connection_Mode;
                                             Stream : Natural; Instances : Size) is
   begin
      API.Draw_Transform_Feedback_Stream_Instanced (Mode, Object.Reference.GL_Id,
                                                    UInt (Stream), Instances);
      Raise_Exception_On_OpenGL_Error;
   end Draw_Transform_Feedback_Stream;

   overriding
   procedure Initialize_Id (Object : in out Feedback_Object) is
      New_Id : UInt := 0;
   begin
      API.Create_Transform_Feedbacks (1, New_Id);
      Raise_Exception_On_OpenGL_Error;

      Object.Reference.GL_Id := New_Id;
      Object.Reference.Initialized := True;
   end Initialize_Id;

   overriding
   procedure Delete_Id (Object : in out Feedback_Object) is
   begin
      API.Delete_Transform_Feedbacks (1, (1 => Object.Reference.GL_Id));
      Raise_Exception_On_OpenGL_Error;

      Object.Reference.GL_Id := 0;
      Object.Reference.Initialized := False;
   end Delete_Id;

   function Begin_Feedback (Object : Feedback_Object; Mode : Feedback_Connection_Mode)
     return Active_Feedback'Class is
   begin
      API.Begin_Transform_Feedback (Mode);
      Raise_Exception_On_OpenGL_Error;
      Error_Checking_Suspended := True;
      return Active_Feedback'(Ada.Finalization.Limited_Controlled
        with Feedback => Object, Mode => Mode, Finalized => False);
   end Begin_Feedback;

   overriding
   procedure Finalize (Object : in out Active_Feedback) is
   begin
      if not Object.Finalized then
         API.End_Transform_Feedback;
         Error_Checking_Suspended := False;
         Object.Finalized := True;
      end if;
   end Finalize;

   function Pause_Feedback (Object : Active_Feedback) return Paused_Feedback'Class is
   begin
      API.Pause_Transform_Feedback;
      Raise_Exception_On_OpenGL_Error;
      Error_Checking_Suspended := True;
      return Paused_Feedback'(Ada.Finalization.Limited_Controlled
        with Feedback => Object.Feedback, Finalized => False);
   end Pause_Feedback;

   overriding
   procedure Finalize (Object : in out Paused_Feedback) is
   begin
      if not Object.Finalized then
         --  Re-bind if no longer bound
         if Active_Transform_Feedback.Current /= Feedback_Object'Class (Object.Feedback) then
            Active_Transform_Feedback.Bind (Object.Feedback);
         end if;
         API.Resume_Transform_Feedback;
         Error_Checking_Suspended := False;
         Object.Finalized := True;
      end if;
   end Finalize;

end GL.Objects.Transform_Feedbacks;
