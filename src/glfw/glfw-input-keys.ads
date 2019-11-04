--  SPDX-License-Identifier: Apache-2.0
--
--  Copyright (c) 2013 Felix Krause <contact@flyx.org>
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

package Glfw.Input.Keys is
   pragma Preelaborate;

   type Action is (Release, Press, Repeat);

   type Key is (Unknown,
                Space,
                Apostrophe,
                Comma,
                Minus,
                Period,
                Slash,
                Key_0,
                Key_1,
                Key_2,
                Key_3,
                Key_4,
                Key_5,
                Key_6,
                Key_7,
                Key_8,
                Key_9,
                Semicolon,
                Equal,
                A,
                B,
                C,
                D,
                E,
                F,
                G,
                H,
                I,
                J,
                K,
                L,
                M,
                N,
                O,
                P,
                Q,
                R,
                S,
                T,
                U,
                V,
                W,
                X,
                Y,
                Z,
                Left_Bracket,
                Backslash,
                Right_Bracket,
                Grave_Accent,
                World_1,
                World_2,
                Escape,
                Enter,
                Tab,
                Backspace,
                Insert,
                Delete,
                Right,
                Left,
                Down,
                Up,
                Page_Up,
                Page_Down,
                Home,
                Key_End,
                Caps_Lock,
                Scroll_Lock,
                Num_Lock,
                Print_Screen,
                Pause,
                F1,
                F2,
                F3,
                F4,
                F5,
                F6,
                F7,
                F8,
                F9,
                F10,
                F11,
                F12,
                F13,
                F14,
                F15,
                F16,
                F17,
                F18,
                F19,
                F20,
                F21,
                F22,
                F23,
                F24,
                F25,
                Numpad_0,
                Numpad_1,
                Numpad_2,
                Numpad_3,
                Numpad_4,
                Numpad_5,
                Numpad_6,
                Numpad_7,
                Numpad_8,
                Numpad_9,
                Numpad_Decimal,
                Numpad_Divide,
                Numpad_Multiply,
                Numpad_Substract,
                Numpad_Add,
                Numpad_Enter,
                Numpad_Equal,
                Left_Shift,
                Left_Control,
                Left_Alt,
                Left_Super,
                Right_Shift,
                Right_Control,
                Right_Alt,
                Right_Super,
                Menu);

   type Modifiers is record
      Shift   : Boolean;
      Control : Boolean;
      Alt     : Boolean;
      Super   : Boolean;
   end record;

   type Scancode is new Interfaces.C.int;

   function Key_Name
     (Key  : Input.Keys.Key;
      Code : Input.Keys.Scancode) return String;

   function Key_Code (Key : Input.Keys.Key) return Input.Keys.Scancode;

private
   for Action use (Release => 0,
                   Press   => 1,
                   Repeat  => 2);
   for Action'Size use Interfaces.C.int'Size;

   for Key use (Unknown       => -1,
                Space         => 32,
                Apostrophe    => 39,
                Comma         => 44,
                Minus         => 45,
                Period        => 46,
                Slash         => 47,
                Key_0         => 48,
                Key_1         => 49,
                Key_2         => 50,
                Key_3         => 51,
                Key_4         => 52,
                Key_5         => 53,
                Key_6         => 54,
                Key_7         => 55,
                Key_8         => 56,
                Key_9         => 57,
                Semicolon     => 59,
                Equal         => 61,
                A             => 65,
                B             => 66,
                C             => 67,
                D             => 68,
                E             => 69,
                F             => 70,
                G             => 71,
                H             => 72,
                I             => 73,
                J             => 74,
                K             => 75,
                L             => 76,
                M             => 77,
                N             => 78,
                O             => 79,
                P             => 80,
                Q             => 81,
                R             => 82,
                S             => 83,
                T             => 84,
                U             => 85,
                V             => 86,
                W             => 87,
                X             => 88,
                Y             => 89,
                Z             => 90,
                Left_Bracket  => 91,
                Backslash     => 92,
                Right_Bracket => 93,
                Grave_Accent  => 96,
                World_1       => 161,
                World_2       => 162,
                Escape        => 256,
                Enter         => 257,
                Tab           => 258,
                Backspace     => 259,
                Insert        => 260,
                Delete        => 261,
                Right         => 262,
                Left          => 263,
                Down          => 264,
                Up            => 265,
                Page_Up       => 266,
                Page_Down     => 267,
                Home          => 268,
                Key_End       => 269,
                Caps_Lock     => 280,
                Scroll_Lock   => 281,
                Num_Lock      => 282,
                Print_Screen  => 283,
                Pause         => 284,
                F1            => 290,
                F2            => 291,
                F3            => 292,
                F4            => 293,
                F5            => 294,
                F6            => 295,
                F7            => 296,
                F8            => 297,
                F9            => 298,
                F10           => 299,
                F11           => 300,
                F12           => 301,
                F13           => 302,
                F14           => 303,
                F15           => 304,
                F16           => 305,
                F17           => 306,
                F18           => 307,
                F19           => 308,
                F20           => 309,
                F21           => 310,
                F22           => 311,
                F23           => 312,
                F24           => 313,
                F25           => 314,
                Numpad_0      => 320,
                Numpad_1      => 321,
                Numpad_2      => 322,
                Numpad_3      => 323,
                Numpad_4      => 324,
                Numpad_5      => 325,
                Numpad_6      => 326,
                Numpad_7      => 327,
                Numpad_8      => 328,
                Numpad_9      => 329,
                Numpad_Decimal   => 330,
                Numpad_Divide    => 331,
                Numpad_Multiply  => 332,
                Numpad_Substract => 333,
                Numpad_Add       => 334,
                Numpad_Enter     => 335,
                Numpad_Equal     => 336,
                Left_Shift       => 340,
                Left_Control     => 341,
                Left_Alt         => 342,
                Left_Super       => 343,
                Right_Shift      => 344,
                Right_Control    => 345,
                Right_Alt        => 346,
                Right_Super      => 347,
                Menu             => 348);
   for Key'Size use Interfaces.C.int'Size;

   for Modifiers use record
      Shift   at 0 range 0 .. 0;
      Control at 0 range 1 .. 1;
      Alt     at 0 range 2 .. 2;
      Super   at 0 range 3 .. 3;
   end record;
   pragma Warnings (Off);
   for Modifiers'Size use Interfaces.C.int'Size;
   pragma Warnings (On);
   pragma Convention (C_Pass_By_Copy, Modifiers);

   for Scancode'Size use Interfaces.C.int'Size;

   pragma Convention (C, Key_Code);

end Glfw.Input.Keys;
