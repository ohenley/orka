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

with System.Multiprocessors;

with Orka.Jobs.Executors;
with Orka.Jobs.Queues;
with Orka.Jobs.Workers;

generic
   Maximum_Queued_Jobs : Positive;
   --  Maximum number of jobs that can be enqueued
   --
   --  Should be no less than the largest width (number of jobs at a
   --  particular level) of any job graph.

   Maximum_Job_Graphs  : Positive;
   --  Maximum number of separate job graphs
   --
   --  For each job graph, a Future object is acquired. The number of
   --  concurrent acquired objects is bounded by this number.
package Orka.Jobs.System is

   package Queues is new Jobs.Queues
     (Maximum_Graphs => Maximum_Job_Graphs,
      Capacity       => Maximum_Queued_Jobs);

   Queue : aliased Queues.Queue;

   Number_Of_Workers : constant Standard.System.Multiprocessors.CPU;

   procedure Execute_GPU_Jobs;
   --  Dequeue and execute GPU jobs in the calling task

   procedure Shutdown;

private

   package SM renames Standard.System.Multiprocessors;

   use type SM.CPU;

   Number_Of_Workers : constant SM.CPU := SM.Number_Of_CPUs - 1;
   --  For n logical CPU's we spawn n - 1 workers (1 CPU is dedicated
   --  to rendering)

   package Executors is new Jobs.Executors
     (Queues, Maximum_Enqueued_By_Job => Maximum_Queued_Jobs);

   package Workers is new Jobs.Workers
     (Executors, Queue'Access, "Worker", Number_Of_Workers);

   procedure Shutdown renames Workers.Shutdown;

end Orka.Jobs.System;
