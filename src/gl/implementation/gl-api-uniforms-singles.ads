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

package GL.API.Uniforms.Singles is
   pragma Preelaborate;

   use GL.Types.Singles;

   procedure Uniform1 is new Loader.Procedure_With_3_Params
     ("glProgramUniform1f", UInt, Int, Single);

   procedure Uniform1v is new Loader.Procedure_With_4_Params
     ("glProgramUniform1fv", UInt, Int, Size, Single_Array);

   procedure Uniform2 is new Loader.Procedure_With_4_Params
     ("glProgramUniform2f", UInt, Int, Single, Single);

   procedure Uniform2v is new Loader.Procedure_With_4_Params
     ("glProgramUniform2fv", UInt, Int, Size, Vector2_Array);

   procedure Uniform3 is new Loader.Procedure_With_5_Params
     ("glProgramUniform3f", UInt, Int, Single, Single, Single);

   procedure Uniform3v is new Loader.Procedure_With_4_Params
     ("glProgramUniform3fv", UInt, Int, Size, Vector3_Array);

   procedure Uniform4 is new Loader.Procedure_With_6_Params
     ("glProgramUniform4f", UInt, Int, Single, Single, Single, Single);

   procedure Uniform4v is new Loader.Procedure_With_4_Params
     ("glProgramUniform4fv", UInt, Int, Size, Vector4_Array);    

   procedure Uniform_Matrix2 is new Loader.Procedure_With_5_Params
     ("glProgramUniformMatrix2fv", UInt, Int, Size, Low_Level.Bool,
      Matrix2_Array);

   procedure Uniform_Matrix3 is new Loader.Procedure_With_5_Params
     ("glProgramUniformMatrix3fv", UInt, Int, Size, Low_Level.Bool,
      Matrix3_Array);

   procedure Uniform_Matrix4 is new Loader.Procedure_With_5_Params
     ("glProgramUniformMatrix4fv", UInt, Int, Size, Low_Level.Bool,
      Matrix4_Array);

end GL.API.Uniforms.Singles;
