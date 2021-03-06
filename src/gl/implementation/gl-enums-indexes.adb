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

package body GL.Enums.Indexes is
   
   function Representation (Value : Index) return Int is
   begin
      return Min_Representation + Value;
   end Representation;
   
   function Value (Representation : Int) return Index is
   begin
      return Representation - Min_Representation;
   end Value;
   
   function Get_Max return Int is
      Max : Int := 0;
   begin
      API.Get_Integer (Getter_Param, Max);
      return Max - 1;
   end Get_Max;
   
end GL.Enums.Indexes;
