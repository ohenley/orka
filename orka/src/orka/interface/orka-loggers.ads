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

package Orka.Loggers is
   pragma Preelaborate;

   type Severity is (Error, Warning, Failure, Success, Info, Debug);

   type Logger is synchronized interface;

   procedure Log
     (Object  : in out Logger;
      From    : String;
      Level   : Severity;
      Message : String) is abstract
   with Synchronization => By_Protected_Procedure;

   type Logger_Ptr is not null access all Logger'Class;

end Orka.Loggers;
