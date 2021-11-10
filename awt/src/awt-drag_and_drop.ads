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

with Ada.Strings.Unbounded;

with AWT.Inputs;

package AWT.Drag_And_Drop is

   package SU renames Ada.Strings.Unbounded;

   type Receive_Callback is access protected procedure (Value : SU.Unbounded_String);

   use all type AWT.Inputs.Action_Kind;

   function Supported_Actions return AWT.Inputs.Actions;

   function Valid_Action return AWT.Inputs.Action_Kind;

   procedure Set_Action (Action : AWT.Inputs.Action_Kind);
   --  Set the requested action that must happen when the user
   --  drops something on the current focused window

   procedure Finish (Action : AWT.Inputs.Action_Kind)
     with Pre => Action /= Ask and Valid_Action /= None;
   --  Finish the current drag-and-drop operation.
   --
   --  To accept the operation, use Copy or Move. If the last set
   --  action was Ask, then the value may either be Copy or Move,
   --  otherwise it must match the last set action.
   --
   --  To reject the operation, use None.

   procedure Get (Callback : not null Receive_Callback)
     with Pre => Valid_Action /= None;
   --  Receive data from a drag-and-drop operation
   --
   --  Before calling this procedure, call function Valid_Actions
   --  to determine what kind of operation needs to take place. If "Ask" is
   --  true, then the application may want to show menu to let the user
   --  choose.
   --
   --  After the given callback has been executed, finish the operation
   --  by calling Finish to accept or reject the received data.

   function Get return String;

end AWT.Drag_And_Drop;
