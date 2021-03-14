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

with Ada.Unchecked_Deallocation;

package body Orka.Jobs is

   procedure Free (Pointer : in out Job_Ptr) is
      type Job_Access is access all Job'Class;

      procedure Free is new Ada.Unchecked_Deallocation
        (Object => Job'Class, Name => Job_Access);
   begin
      Free (Job_Access (Pointer));
   end Free;

   overriding
   procedure Adjust (Object : in out Counter_Controlled) is
   begin
      Object.Counter := new Zero_Counter;
   end Adjust;

   overriding
   procedure Finalize (Object : in out Counter_Controlled) is
      procedure Free is new Ada.Unchecked_Deallocation
        (Object => Zero_Counter, Name => Zero_Counter_Access);
   begin
      if Object.Counter /= null then
         Free (Object.Counter);
      end if;

      --  Idempotence: next call to Finalize has no effect
      Object.Counter := null;
   end Finalize;

   overriding
   procedure Execute
     (Object  : No_Job;
      Context : Execution_Context'Class) is
   begin
      raise Program_Error with "Cannot execute Null_Job";
   end Execute;

   overriding
   function Decrement_Dependencies (Object : in out Abstract_Job) return Boolean is
      Zero : Boolean := False;
   begin
      Object.Dependencies.Counter.Decrement (Zero);
      return Zero;
   end Decrement_Dependencies;

   overriding
   function Has_Dependencies (Object : Abstract_Job) return Boolean is
   begin
      return Object.Dependencies.Counter.Count > 0;
   end Has_Dependencies;

   overriding
   procedure Set_Dependency
     (Object : access Abstract_Job; Dependency : Job_Ptr) is
   begin
      Object.Dependencies.Counter.Increment;
      Abstract_Job (Dependency.all).Dependent := Job_Ptr (Object);
   end Set_Dependency;

   overriding
   procedure Set_Dependencies
     (Object : access Abstract_Job; Dependencies : Dependency_Array) is
   begin
      Object.Dependencies.Counter.Add (Dependencies'Length);
      for Dependency of Dependencies loop
         Abstract_Job (Dependency.all).Dependent := Job_Ptr (Object);
      end loop;
   end Set_Dependencies;

   procedure Chain (Jobs : Dependency_Array) is
   begin
      for Index in Jobs'First .. Jobs'Last - 1 loop
         Jobs (Index + 1).Set_Dependency (Jobs (Index));
      end loop;
   end Chain;

   function Parallelize
     (Job   : Parallel_Job_Ptr;
      Clone : Parallel_Job_Cloner;
      Length, Slice : Positive) return Job_Ptr is
   begin
      return new Parallel_For_Job'
        (Abstract_Job with
          Length => Length,
          Slice  => Slice,
          Job    => Job,
          Clone  => Clone);
   end Parallelize;

   overriding
   procedure Execute
     (Object  : Parallel_For_Job;
      Context : Execution_Context'Class)
   is
      Slice_Length : constant Positive := Positive'Min (Object.Length, Object.Slice);

      Slices    : constant Positive := Object.Length / Slice_Length;
      Remaining : constant Natural  := Object.Length rem Slice_Length;

      Array_Length : constant Positive := Slices + (if Remaining /= 0 then 1 else 0);

      Parallel_Jobs : constant Dependency_Array (1 .. Array_Length)
        := Object.Clone (Object.Job, Array_Length);

      From, To : Positive := 1;
   begin
      for Slice_Index in 1 .. Slices loop
         To := From + Slice_Length - 1;
         Parallel_Job'Class (Parallel_Jobs (Slice_Index).all).Set_Range (From, To);
         From := To + 1;
      end loop;
      if Remaining /= 0 then
         To := From + Remaining - 1;
         Parallel_Job'Class (Parallel_Jobs (Parallel_Jobs'Last).all).Set_Range (From, To);
      end if;
      pragma Assert (To = Object.Length);

      for Job of Parallel_Jobs loop
         Context.Enqueue (Job);
      end loop;

      --  Object is still a (useless) dependency of Object.Dependent,
      --  but the worker that called this Execute procedure will decrement
      --  Object.Dependent.Dependencies after this procedure is done

      declare
         Original_Job : Job_Ptr := Job_Ptr (Object.Job);
      begin
         --  Copies of Object.Job have been made in Parallel_Jobs
         --  and these will be freed when they have been executed by
         --  workers. However, Object.Job itself will never be enqueued and
         --  executed by a worker (it just exists so we can copy it) so
         --  we need to manually free it.
         Free (Original_Job);
      end;
   end Execute;

   overriding
   procedure Execute
     (Object  : Abstract_Parallel_Job;
      Context : Execution_Context'Class) is
   begin
      Abstract_Parallel_Job'Class (Object).Execute (Context, Object.From, Object.To);
   end Execute;

   overriding
   procedure Set_Range (Object : in out Abstract_Parallel_Job; From, To : Positive) is
   begin
      Object.From := From;
      Object.To   := To;
   end Set_Range;

end Orka.Jobs;
