--  Copyright (c) 2015 onox <denkpadje@gmail.com>
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

with GL.API;
with GL.Enums;

package body GL.Objects.Pipelines is

   procedure Use_Program_Stages (Object : Pipeline; Shader : Shaders.Shader_Type;
                                 Program : Programs.Program) is
   begin
      API.Use_Program_Stages (Object.Reference.GL_Id, Shader, Program.Raw_Id);
      Raise_Exception_On_OpenGL_Error;
   end Use_Program_Stages;

   procedure Set_Active_Program (Object : Pipeline; Program : Programs.Program) is
   begin
      API.Active_Shader_Program (Object.Reference.GL_Id, Program.Raw_Id);
      Raise_Exception_On_OpenGL_Error;
   end Set_Active_Program;

   procedure Bind (Object : Pipeline) is
   begin
      API.Bind_Program_Pipeline (Object.Reference.GL_Id);
      Raise_Exception_On_OpenGL_Error;
   end Bind;

   function Validate (Object : Pipeline) return Boolean is
      Status_Value : Int := 0;
   begin
      API.Validate_Program_Pipeline (Object.Reference.GL_Id);
      Raise_Exception_On_OpenGL_Error;
      API.Get_Program_Pipeline_Param (Object.Reference.GL_Id, Enums.Validate_Status,
                                      Status_Value);
      Raise_Exception_On_OpenGL_Error;
      return Status_Value /= 0;
   end Validate;

   function Info_Log (Object : Pipeline) return String is
      Log_Length : Size := 0;
   begin
      API.Get_Program_Pipeline_Param (Object.Reference.GL_Id, Enums.Info_Log_Length,
                                      Log_Length);
      Raise_Exception_On_OpenGL_Error;

      if Log_Length = 0 then
         return "";
      end if;

      declare
         Info_Log : String (1 .. Integer (Log_Length));
      begin
         API.Get_Program_Pipeline_Info_Log (Object.Reference.GL_Id, Log_Length,
                                            Log_Length, Info_Log);
         Raise_Exception_On_OpenGL_Error;
         return Info_Log (1 .. Integer (Log_Length));
      end;
   end Info_Log;

   overriding
   procedure Initialize_Id (Object : in out Pipeline) is
      New_Id : UInt := 0;
   begin
      API.Create_Program_Pipelines (1, New_Id);
      Raise_Exception_On_OpenGL_Error;
      Object.Reference.GL_Id := New_Id;
      Object.Reference.Initialized := True;
   end Initialize_Id;

   overriding
   procedure Delete_Id (Object : in out Pipeline) is
   begin
      API.Delete_Program_Pipelines (1, (1 => Object.Reference.GL_Id));
      Raise_Exception_On_OpenGL_Error;
      Object.Reference.GL_Id := 0;
      Object.Reference.Initialized := False;
   end Delete_Id;

end GL.Objects.Pipelines;
