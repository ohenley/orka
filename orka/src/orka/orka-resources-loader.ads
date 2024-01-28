--  SPDX-License-Identifier: Apache-2.0
--
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

with Orka.Futures;
with Orka.Jobs.Queues;
with Orka.Resources.Locations;
with Orka.Resources.Loaders;

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

   procedure Add_Location (Location : Locations.Location_Ptr; Loader : Loaders.Loader_Ptr);
   --  Add a location that contains files that can be loaded by the
   --  given loader. Multiple loaders can be registered for a specific
   --  location and multiple locations can be registered for a specific
   --  loader.
   --
   --  A loader can only load resources that have a specific extension.
   --  The extension can be queried by calling the Loader.Extension function.

   function Load (Path : String) return Futures.Pointers.Mutable_Pointer;
   --  Load the given resource from a file system or archive and return
   --  a handle for querying the processing status of the resource. Calling
   --  this function may block until there is a free slot available for
   --  processing the data.

   procedure Shutdown;

private

   task Loader;

end Orka.Resources.Loader;
