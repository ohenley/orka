--  SPDX-License-Identifier: Apache-2.0
--
--  Copyright (c) 2021 onox <denkpadje@gmail.com>
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

with Ada.Streams;
with Ada.Unchecked_Conversion;

with AWT.OS;
--  with AWT.Registry;

package body AWT.Drag_And_Drop is

   protected body Signal is
      procedure Set is
      begin
         Signaled := True;
      end Set;

      entry Wait when Signaled is
      begin
         Signaled := False;
      end Wait;
   end Signal;

   function Supported_Actions return AWT.Inputs.Actions is
     (False, False, False);

   function Valid_Action return AWT.Inputs.Action_Kind is
     (None);

   procedure Set_Action (Action : AWT.Inputs.Action_Kind) is
   begin
      null;
   end Set_Action;

   procedure Finish (Action : AWT.Inputs.Action_Kind) is
   begin
      null;
   end Finish;

   procedure Get (Callback : not null Receive_Callback) is
   begin
      null;
   end Get;

   function Get return String is
   begin
      return "";
   end Get;

end AWT.Drag_And_Drop;
