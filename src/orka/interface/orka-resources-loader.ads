--  Copyright (c) 2018 onox <denkpadje@gmail.com>
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

with Ada.Real_Time;

with Orka.Containers.Ring_Buffers;
with Orka.Futures;
with Orka.Jobs.Queues;

generic
   with package Queues is new Orka.Jobs.Queues (<>);

   Job_Queue : Queues.Queue_Ptr;

   Maximum_Requests : Positive;
   --  Maximum number of resources waiting to be read from a file system
   --  or archive. Resources are read sequentially, but may be processed
   --  concurrently. This number depends on how fast the hardware can read
   --  the requested resources.

   Task_Name : String := "Resource Loader";
package Orka.Resources.Loader is

   function Load (Path : String) return Futures.Pointers.Constant_Reference;
   --  Load the given resource from a file system or archive and return
   --  a handle for querying the processing status of the resource. Calling
   --  this function may block until there is a free slot available for
   --  processing the data.

   procedure Shutdown;

private

   type Load_Ptr is not null access procedure
     (Bytes   : in out Byte_Array_Access;
      Time    : Ada.Real_Time.Time_Span;
      Path    : SU.Unbounded_String;
      Enqueue : not null access procedure (Element : Jobs.Job_Ptr));

   procedure Empty_Loader
     (Bytes   : in out Byte_Array_Access;
      Time    : Ada.Real_Time.Time_Span;
      Path    : SU.Unbounded_String;
      Enqueue : not null access procedure (Element : Jobs.Job_Ptr)) is null;
   --  This null procedure is needed because without it the declaration
   --  of a Read_Request in the task body will generate an access
   --  check failure.

   type Read_Request is record
      Path   : SU.Unbounded_String;
      Load   : Load_Ptr := Empty_Loader'Access;
      Future : Futures.Pointers.Pointer;
   end record;

   Null_Request : constant Read_Request := (others => <>);

   function Get_Null_Request return Read_Request is (Null_Request);

   package Buffers is new Orka.Containers.Ring_Buffers
     (Read_Request, Get_Null_Request);

   protected Queue is
      entry Enqueue (Element : Read_Request);

      entry Dequeue (Element : out Read_Request; Stop : out Boolean);

      procedure Shutdown;
   private
      Requests    : Buffers.Buffer (Maximum_Requests);
      Should_Stop : Boolean := False;
   end Queue;

   task Loader;

end Orka.Resources.Loader;
