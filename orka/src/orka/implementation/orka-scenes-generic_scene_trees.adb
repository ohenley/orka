--  SPDX-License-Identifier: Apache-2.0
--
--  Copyright (c) 2016 onox <denkpadje@gmail.com>
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

package body Orka.Scenes.Generic_Scene_Trees is

   function To_Cursor (Object : Tree; Name : String) return Cursor is
      use type SU.Unbounded_String;
   begin
      for Level_Index in Object.Levels.First_Index .. Object.Levels.Last_Index loop
         declare
            Node_Level : Level renames Object.Levels (Level_Index);
         begin
            for Node_Index in Node_Level.Nodes.First_Index .. Node_Level.Nodes.Last_Index loop
               declare
                  Current_Node : Node renames Node_Level.Nodes (Node_Index);
               begin
                  if Current_Node.Name = Name then
                     return Cursor'(Level => Level_Index, Offset => Node_Index);
                  end if;
               end;
            end loop;
         end;
      end loop;
      raise Unknown_Node_Error;
   end To_Cursor;

   procedure Update_Tree (Object : in out Tree) is
   begin
      Object.Update_Tree (Transforms.Identity_Value);
   end Update_Tree;

   procedure Update_Tree (Object : in out Tree; Root_Transform : Transforms.Matrix4) is
      use Transforms;

      Root_Local   : constant Matrix4 :=
        Object.Levels (Object.Levels.First_Index).Local_Transforms.Element (1);
      Root_Visible : constant Boolean :=
        Object.Levels (Object.Levels.First_Index).Local_Visibilities.Element (1);
   begin
      --  Copy local data of root node to its world data
      Object.Levels (Object.Levels.First_Index).World_Transforms.Replace_Element
        (1, Root_Transform * Root_Local);
      Object.Levels (Object.Levels.First_Index).World_Visibilities.Replace_Element
        (1, Root_Visible);

      for Level_Index in Object.Levels.First_Index .. Object.Levels.Last_Index - 1 loop
         declare
            Current_Level : Level renames Object.Levels (Level_Index);
            Parent_Level_W : Matrix_Vectors.Vector  renames Current_Level.World_Transforms;
            Parent_Level_V : Boolean_Vectors.Vector renames Current_Level.World_Visibilities;
            Parent_Level_N : Node_Vectors.Vector    renames Current_Level.Nodes;

            procedure Update (Child_Level : in out Level) is
            begin
               for Parent_Index in Parent_Level_N.First_Index .. Parent_Level_N.Last_Index loop
                  declare
                     Parent_Transform : Matrix4 renames Parent_Level_W.Element (Parent_Index);
                     Parent_Visible   : Boolean renames Parent_Level_V.Element (Parent_Index);
                     Parent           : Node    renames Parent_Level_N.Element (Parent_Index);
                  begin
                     for Node_Index in Parent.Offset .. Parent.Offset + Parent.Count - 1 loop
                        declare
                           Local_Transform : Matrix4 renames
                             Child_Level.Local_Transforms.Element (Node_Index);
                           Local_Visible   : Boolean renames
                             Child_Level.Local_Visibilities.Element (Node_Index);
                        begin
                           Child_Level.World_Transforms.Replace_Element
                             (Node_Index, Parent_Transform * Local_Transform);
                           Child_Level.World_Visibilities.Replace_Element
                             (Node_Index, Parent_Visible and then Local_Visible);
                        end;
                     end loop;
                  end;
               end loop;
            end Update;
         begin
            Object.Levels.Update_Element (Level_Index + 1, Update'Access);
         end;
      end loop;
   end Update_Tree;

   procedure Set_Visibility (Object : in out Tree; Node : Cursor; Visible : Boolean) is
      Node_Level : Level renames Object.Levels (Node.Level);
   begin
      Node_Level.Local_Visibilities.Replace_Element (Node.Offset, Visible);
   end Set_Visibility;

   function Visibility (Object : Tree; Node : Cursor) return Boolean is
      Node_Level : Level renames Object.Levels (Node.Level);
   begin
      return Node_Level.World_Visibilities.Element (Node.Offset);
   end Visibility;

   procedure Set_Local_Transform
     (Object    : in out Tree;
      Node      : Cursor;
      Transform : Transforms.Matrix4)
   is
      Node_Level : Level renames Object.Levels (Node.Level);
   begin
      Node_Level.Local_Transforms.Replace_Element (Node.Offset, Transform);
   end Set_Local_Transform;

   function World_Transform (Object : Tree; Node : Cursor) return Transforms.Matrix4 is
      Node_Level : Level renames Object.Levels (Node.Level);
   begin
      return Node_Level.World_Transforms.Element (Node.Offset);
   end World_Transform;

   function Root_Name (Object : Tree) return String is
     (SU.To_String (Object.Levels (Object.Levels.First_Index).Nodes.Element (1).Name));

   function Create_Tree (Name : String) return Tree is
   begin
      return Object : Tree do
         Object.Levels.Append (Level'(others => <>));

         declare
            Root_Level : Level renames Object.Levels (Object.Levels.First_Index);
         begin
            Root_Level.Nodes.Append (Node'(Name   => SU.To_Unbounded_String (Name),
                                           Offset => 1,
                                           Count  => 0));
            Root_Level.Local_Transforms.Append (Transforms.Identity_Value);
            Root_Level.World_Transforms.Append (Transforms.Identity_Value);
            Root_Level.Local_Visibilities.Append (True);
            Root_Level.World_Visibilities.Append (True);
         end;
      end return;
   end Create_Tree;

   procedure Add_Node (Object : in out Tree; Name, Parent : String) is
   begin
      Object.Add_Node (SU.To_Unbounded_String (Name), Parent);
   end Add_Node;

   procedure Add_Node (Object : in out Tree; Name : SU.Unbounded_String; Parent : String) is
      Parent_Cursor : constant Cursor := To_Cursor (Object, Parent);
   begin
      --  Add a new level if parent is a leaf node
      if Parent_Cursor.Level = Positive (Object.Levels.Length) then
         Object.Levels.Append (Level'(others => <>));
      end if;

      declare
         Parent_Level : Level renames Object.Levels (Parent_Cursor.Level);
         Child_Level  : Level renames Object.Levels (Parent_Cursor.Level + 1);
         Parent_Node  : Node  renames Parent_Level.Nodes (Parent_Cursor.Offset);

         New_Node_Index : constant Positive := Parent_Node.Offset + Parent_Node.Count;

         procedure Increment_Offset (Parent : in out Node) is
         begin
            Parent.Offset := Parent.Offset + 1;
         end Increment_Offset;

         Parent_Last_Index : constant Positive := Parent_Level.Nodes.Last_Index;
      begin
         --  If the node (in level j) has a parent that is the last node in level i,
         --  then the node can simply be appended to level j, which is faster to do
         if Parent_Cursor.Offset = Parent_Last_Index then
            Child_Level.Nodes.Append (Node'(Name   => Name,
                                            Offset => 1,
                                            Count  => 0));
            Child_Level.Local_Transforms.Append (Transforms.Identity_Value);
            Child_Level.World_Transforms.Append (Transforms.Identity_Value);
            Child_Level.Local_Visibilities.Append (True);
            Child_Level.World_Visibilities.Append (True);
         else
            --  Insert new node and its transforms
            Child_Level.Nodes.Insert (New_Node_Index, Node'(Name   => Name,
                                                            Offset => 1,
                                                            Count  => 0));
            Child_Level.Local_Transforms.Insert (New_Node_Index, Transforms.Identity_Value);
            Child_Level.World_Transforms.Insert (New_Node_Index, Transforms.Identity_Value);
            Child_Level.Local_Visibilities.Insert (New_Node_Index, True);
            Child_Level.World_Visibilities.Insert (New_Node_Index, True);

            --  After inserting a new node (in level j), increment the offsets
            --  of all parents that come after the new node's parent (in level i)
            for Parent_Index in Parent_Cursor.Offset + 1 .. Parent_Last_Index loop
               Parent_Level.Nodes.Update_Element (Parent_Index, Increment_Offset'Access);
            end loop;
         end if;

         Parent_Node.Count := Parent_Node.Count + 1;
      end;
   end Add_Node;

   procedure Remove_Node (Object : in out Tree; Name : String) is
      use Ada.Containers;

      Node_Cursor : constant Cursor := To_Cursor (Object, Name);

      Current_First_Index : Positive := Node_Cursor.Offset;
      Current_Last_Index  : Positive := Node_Cursor.Offset;

      --  Assign a dummy value to silence any warnings about being uninitialized
      Next_First_Index, Next_Last_Index : Positive := Positive'Last;

      Empty_Level_Index : Positive := Object.Levels.Last_Index + 1;
   begin
      if Node_Cursor.Level = Positive'First and Node_Cursor.Offset = Positive'First then
         raise Root_Removal_Error with "Cannot remove root node";
      end if;

      --  If the node that is the root of the subtree that is going to
      --  be removed, has a parent, then reduce the count of this parent.
      if Node_Cursor.Level > Object.Levels.First_Index then
         declare
            Parent_Level : Level renames Object.Levels (Node_Cursor.Level - 1);
            After_Parent_Index : Positive := Parent_Level.Nodes.Last_Index + 1;
         begin
            for Parent_Index in
              Parent_Level.Nodes.First_Index .. Parent_Level.Nodes.Last_Index
            loop
               declare
                  Parent : Node renames Parent_Level.Nodes (Parent_Index);
               begin
                  if Node_Cursor.Offset in Parent.Offset .. Parent.Offset + Parent.Count - 1 then
                     Parent.Count := Parent.Count - 1;
                     After_Parent_Index := Parent_Index + 1;
                     exit;
                  end if;
               end;
            end loop;

            --  Reduce the offsets of any nodes that come after the parent node
            for Parent_Index in After_Parent_Index .. Parent_Level.Nodes.Last_Index loop
               declare
                  Parent : Node renames Parent_Level.Nodes (Parent_Index);
               begin
                  Parent.Offset := Parent.Offset - 1;
               end;
            end loop;
         end;
      end if;

      for Level_Index in Node_Cursor.Level .. Object.Levels.Last_Index loop
         declare
            Node_Level : Level renames Object.Levels (Level_Index);

            Min_Index : Positive'Base := Current_Last_Index + 1;
            Max_Index : Positive'Base := Current_First_Index - 1;
         begin
            --  Because child nodes in the next level (in all levels actually)
            --  are adjacent, we can just use the offset of the first node
            --  that is not a leaf node and the offset + count - 1 of the last
            --  node that is not a leaf node.
            for Node_Index in Current_First_Index .. Current_Last_Index loop
               declare
                  Current_Node : Node renames Node_Level.Nodes (Node_Index);
               begin
                  if Current_Node.Count /= 0 then
                     Min_Index := Positive'Min (Node_Index, Min_Index);
                     Max_Index := Positive'Max (Node_Index, Max_Index);
                  end if;
               end;
            end loop;

            --  Before removing the nodes and transforms, compute the range
            --  of the child nodes, if any, in the next level
            if Min_Index in Current_First_Index .. Current_Last_Index then
               declare
                  Min_Node : Node renames Node_Level.Nodes (Min_Index);
                  Max_Node : Node renames Node_Level.Nodes (Max_Index);
               begin
                  --  Nodes to iterate over in next level
                  Next_First_Index := Min_Node.Offset;
                  Next_Last_Index  := Max_Node.Offset + Max_Node.Count - 1;

                  --  There are child nodes that are going to be removed next
                  --  iteration, so we need to reduce the offset of the nodes
                  --  that come after Current_Last_Index.
                  declare
                     Count : constant Positive := Next_Last_Index - Next_First_Index + 1;
                  begin
                     for Parent_Index in Current_Last_Index + 1 .. Node_Level.Nodes.Last_Index loop
                        declare
                           Parent : Node renames Node_Level.Nodes (Parent_Index);
                        begin
                           Parent.Offset := Parent.Offset - Count;
                        end;
                     end loop;
                  end;
               end;
            end if;

            --  Remove all nodes between Current_First_Index .. Current_Last_Index in current level
            declare
               Count : constant Count_Type :=
                 Count_Type (Current_Last_Index - Current_First_Index + 1);
            begin
               Node_Level.Nodes.Delete (Current_First_Index, Count);
               Node_Level.Local_Transforms.Delete (Current_First_Index, Count);
               Node_Level.World_Transforms.Delete (Current_First_Index, Count);
               Node_Level.Local_Visibilities.Delete (Current_First_Index, Count);
               Node_Level.World_Visibilities.Delete (Current_First_Index, Count);
            end;

            --  Record the level index of the first empty level. Any levels down
            --  the tree should be(come) empty as well.
            if Node_Level.Nodes.Is_Empty then
               Empty_Level_Index := Positive'Min (Empty_Level_Index, Level_Index);
            end if;

            --  Exit if there are no nodes that have children
            exit when Min_Index not in Current_First_Index .. Current_Last_Index;

            --  If we reach this code here, then there is a node that has
            --  children. The variables below have been updated in the if
            --  block above.
            pragma Assert (Next_First_Index /= Positive'Last);
            pragma Assert (Next_Last_Index /= Positive'Last);
            Current_First_Index := Next_First_Index;
            Current_Last_Index  := Next_Last_Index;
         end;
      end loop;

      --  Remove empty levels
      if Empty_Level_Index < Object.Levels.Last_Index + 1 then
         declare
            Count : constant Count_Type :=
              Count_Type (Object.Levels.Last_Index - Empty_Level_Index + 1);
         begin
            Object.Levels.Delete (Empty_Level_Index, Count);
         end;
      end if;
   end Remove_Node;

end Orka.Scenes.Generic_Scene_Trees;
