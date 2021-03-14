--  SPDX-License-Identifier: Apache-2.0
--
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

with GL.API;

package body GL.Toggles is

   procedure Enable (Subject : Toggle) is
   begin
      API.Enable.Ref (Subject);
   end Enable;

   procedure Disable (Subject : Toggle) is
   begin
      API.Disable.Ref (Subject);
   end Disable;

   procedure Set (Subject : Toggle; Value : Toggle_State) is
   begin
      if Value = Enabled then
         API.Enable.Ref (Subject);
      else
         API.Disable.Ref (Subject);
      end if;
   end Set;

   function State (Subject : Toggle) return Toggle_State is
     ((if API.Is_Enabled.Ref (Subject) then Enabled else Disabled));

   procedure Enable (Subject : Toggle_Indexed; Index : Types.UInt) is
   begin
      API.Enable_I.Ref (Subject, Index);
   end Enable;

   procedure Disable (Subject : Toggle_Indexed; Index : Types.UInt) is
   begin
      API.Disable_I.Ref (Subject, Index);
   end Disable;

   procedure Set (Subject : Toggle_Indexed; Index : Types.UInt; Value : Toggle_State) is
   begin
      if Value = Enabled then
         API.Enable_I.Ref (Subject, Index);
      else
         API.Disable_I.Ref (Subject, Index);
      end if;
   end Set;

   function State (Subject : Toggle_Indexed; Index : Types.UInt) return Toggle_State is
     ((if API.Is_Enabled_I.Ref (Subject, Index) then Enabled else Disabled));

end GL.Toggles;
