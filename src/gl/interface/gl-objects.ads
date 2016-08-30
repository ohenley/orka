--  Copyright (c) 2012 Felix Krause <contact@flyx.org>
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

with Ada.Finalization;

with GL.Types;

package GL.Objects is
   pragma Preelaborate;

   use GL.Types;

   type GL_Object is abstract new Ada.Finalization.Controlled with private;

   -- creates the object in OpenGL memory.
   overriding procedure Initialize (Object : in out GL_Object);

   -- Increases reference count.
   overriding procedure Adjust (Object : in out GL_Object);

   -- Decreases reference count. Destroys texture when it reaches zero.
   overriding procedure Finalize (Object : in out GL_Object);

   -- Create an OpenGL ID for this object. This has to be done before
   -- the object is used in any way. After calling this procedure,
   -- Initialized will be true.
   procedure Initialize_Id (Object : in out GL_Object) is abstract;

   -- Deletes the ID of an object. After calling this procedure,
   -- Initialized will be false.
   procedure Delete_Id (Object : in out GL_Object) is abstract;

   -- Check whether the object is set up to be used with OpenGL
   -- (i.e. whether Initialize_Id has been called on the object).
   function Initialized (Object : GL_Object) return Boolean;

   -- This getter is provided for low-level access. Its primary use is to
   -- interact with other C interfaces (e.g. OpenCL)
   function Raw_Id (Object : GL_Object) return UInt;
   -- Setter for low-level access
   procedure Set_Raw_Id (Object : GL_Object; Id : UInt);

   overriding
   function "=" (Left, Right : GL_Object) return Boolean;

   No_Object_Bound_Exception : exception;
private

   type GL_Object_Reference is record
      GL_Id           : UInt;
      Reference_Count : Natural;
      Initialized     : Boolean := True;
   end record;

   type GL_Object_Reference_Access is access all GL_Object_Reference;

   type GL_Object is abstract new Ada.Finalization.Controlled with record
      Reference : GL_Object_Reference_Access;
   end record;

   pragma Inline (Raw_Id);
   pragma Inline (Set_Raw_Id);

end GL.Objects;
