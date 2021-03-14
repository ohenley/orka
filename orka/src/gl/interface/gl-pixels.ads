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

with GL.Types;

private with GL.Low_Level;

package GL.Pixels is
   pragma Preelaborate;

   use GL.Types;

   type Internal_Format_Buffer_Texture is (RGBA8, RGBA16, R8, R16, RG8, RG16, R16F,
                                           R32F, RG16F, RG32F,
                                           R8I, R8UI, R16I, R16UI, R32I, R32UI,
                                           RG8I, RG8UI, RG16I, RG16UI, RG32I, RG32UI,
                                           RGBA32F, RGB32F, RGBA16F, RGB16F,
                                           RGBA32UI, RGB32UI, RGBA16UI, RGBA8UI,
                                           RGBA32I, RGB32I, RGBA16I, RGBA8I);

   type Internal_Format is (R3_G3_B2, RGB4, RGB5, RGB8, RGB10, RGB12, RGB16,
                            RGBA2, RGBA4, RGB5_A1, RGBA8, RGB10_A2, RGBA12, RGBA16,
                            Depth_Component16, Depth_Component24,
                            R8, R16, RG8, RG16, R16F, R32F, RG16F, RG32F,
                            R8I, R8UI, R16I, R16UI, R32I, R32UI,
                            RG8I, RG8UI, RG16I, RG16UI, RG32I, RG32UI,
                            RGBA32F, RGB32F, RGBA16F, RGB16F,
                            Depth24_Stencil8, R11F_G11F_B10F, RGB9_E5,
                            SRGB8, SRGB8_Alpha8,
                            Depth_Component32F, Depth32F_Stencil8, Stencil_Index8,
                            RGBA32UI, RGB32UI, RGBA16UI, RGB16UI, RGBA8UI, RGB8UI,
                            RGBA32I, RGB32I, RGBA16I, RGB16I, RGBA8I, RGB8I,
                            R8_SNorm, RG8_SNorm, RGB8_SNorm, RGBA8_SNorm,
                            R16_SNorm, RG16_SNorm, RGB16_SNorm, RGBA16_SNorm, RGB10_A2UI);
   --  Table 8.12 of the OpenGL specification

   type Compressed_Format is
     (Compressed_Red_RGTC1,
      Compressed_Signed_Red_RGTC1,
      Compressed_RG_RGTC2,
      Compressed_Signed_RG_RGTC2,

      Compressed_RGBA_BPTC_Unorm,
      Compressed_SRGB_Alpha_BPTC_UNorm,
      Compressed_RGB_BPTC_Signed_Float,
      Compressed_RGB_BPTC_Unsigned_Float,

      Compressed_R11_EAC,
      Compressed_Signed_R11_EAC,
      Compressed_RG11_EAC,
      Compressed_Signed_RG11_EAC,
      Compressed_RGB8_ETC2,
      Compressed_SRGB8_ETC2,
      Compressed_RGB8_Punchthrough_Alpha1_ETC2,
      Compressed_SRGB8_Punchthrough_Alpha1_ETC2,
      Compressed_RGBA8_ETC2_EAC,
      Compressed_SRGB8_Alpha8_ETC2_EAC,

      --  ASTC (not part of OpenGL core)
      Compressed_RGBA_ASTC_4x4_KHR,
      Compressed_RGBA_ASTC_5x4_KHR,
      Compressed_RGBA_ASTC_5x5_KHR,
      Compressed_RGBA_ASTC_6x5_KHR,
      Compressed_RGBA_ASTC_6x6_KHR,
      Compressed_RGBA_ASTC_8x5_KHR,
      Compressed_RGBA_ASTC_8x6_KHR,
      Compressed_RGBA_ASTC_8x8_KHR,
      Compressed_RGBA_ASTC_10x5_KHR,
      Compressed_RGBA_ASTC_10x6_KHR,
      Compressed_RGBA_ASTC_10x8_KHR,
      Compressed_RGBA_ASTC_10x10_KHR,
      Compressed_RGBA_ASTC_12x10_KHR,
      Compressed_RGBA_ASTC_12x12_KHR,

      Compressed_SRGB8_ALPHA8_ASTC_4x4_KHR,
      Compressed_SRGB8_ALPHA8_ASTC_5x4_KHR,
      Compressed_SRGB8_ALPHA8_ASTC_5x5_KHR,
      Compressed_SRGB8_ALPHA8_ASTC_6x5_KHR,
      Compressed_SRGB8_ALPHA8_ASTC_6x6_KHR,
      Compressed_SRGB8_ALPHA8_ASTC_8x5_KHR,
      Compressed_SRGB8_ALPHA8_ASTC_8x6_KHR,
      Compressed_SRGB8_ALPHA8_ASTC_8x8_KHR,
      Compressed_SRGB8_ALPHA8_ASTC_10x5_KHR,
      Compressed_SRGB8_ALPHA8_ASTC_10x6_KHR,
      Compressed_SRGB8_ALPHA8_ASTC_10x8_KHR,
      Compressed_SRGB8_ALPHA8_ASTC_10x10_KHR,
      Compressed_SRGB8_ALPHA8_ASTC_12x10_KHR,
      Compressed_SRGB8_ALPHA8_ASTC_12x12_KHR);
   --  Specific compressed internal formats of Table 8.14 of the OpenGL specification

   type Format is (Stencil_Index, Depth_Component, Red, Green, Blue,
                   RGB, RGBA, BGR, BGRA, RG, RG_Integer, Depth_Stencil,
                   Red_Integer, Green_Integer, Blue_Integer,
                   RGB_Integer, RGBA_Integer, BGR_Integer, BGRA_Integer);
   --  Table 8.3 of the OpenGL specification

   type Data_Type is (Byte, Unsigned_Byte, Short, Unsigned_Short, Int,
                      Unsigned_Int, Float, Half_Float, Unsigned_Byte_3_3_2,
                      Unsigned_Short_4_4_4_4,
                      Unsigned_Short_5_5_5_1,
                      Unsigned_Int_8_8_8_8,
                      Unsigned_Int_10_10_10_2,
                      Unsigned_Byte_2_3_3_Rev,
                      Unsigned_Short_5_6_5,
                      Unsigned_Short_5_6_5_Rev,
                      Unsigned_Short_4_4_4_4_Rev,
                      Unsigned_Short_1_5_5_5_Rev,
                      Unsigned_Int_8_8_8_8_Rev,
                      Unsigned_Int_2_10_10_10_Rev,
                      Unsigned_Int_24_8,
                      Unsigned_Int_10F_11F_11F_Rev,
                      Unsigned_Int_5_9_9_9_Rev,
                      Float_32_Unsigned_Int_24_8_Rev);
   --  Table 8.2 of the OpenGL specification

   type Channel_Data_Type is (None, Int_Type, Unsigned_Int_Type, Float_Type,
                              Unsigned_Normalized, Signed_Normalized);

   type Alignment is (Bytes, Even_Bytes, Words, Double_Words);

   procedure Set_Pack_Alignment (Value : Alignment);
   function Pack_Alignment return Alignment;

   procedure Set_Pack_Compressed_Block_Width  (Value : Size);
   procedure Set_Pack_Compressed_Block_Height (Value : Size);
   procedure Set_Pack_Compressed_Block_Depth  (Value : Size);
   procedure Set_Pack_Compressed_Block_Size   (Value : Size);

   function Pack_Compressed_Block_Width  return Size;
   function Pack_Compressed_Block_Height return Size;
   function Pack_Compressed_Block_Depth  return Size;
   function Pack_Compressed_Block_Size   return Size;

   procedure Set_Unpack_Alignment (Value : Alignment);
   function Unpack_Alignment return Alignment;

   procedure Set_Unpack_Compressed_Block_Width  (Value : Size);
   procedure Set_Unpack_Compressed_Block_Height (Value : Size);
   procedure Set_Unpack_Compressed_Block_Depth  (Value : Size);
   procedure Set_Unpack_Compressed_Block_Size   (Value : Size);

   function Unpack_Compressed_Block_Width  return Size;
   function Unpack_Compressed_Block_Height return Size;
   function Unpack_Compressed_Block_Depth  return Size;
   function Unpack_Compressed_Block_Size   return Size;

private

   for Internal_Format_Buffer_Texture use (RGBA8    => 16#8058#,
                                           RGBA16   => 16#805B#,

                                           R8     => 16#8229#,
                                           R16    => 16#822A#,
                                           RG8    => 16#822B#,
                                           RG16   => 16#822C#,
                                           R16F   => 16#822D#,
                                           R32F   => 16#822E#,
                                           RG16F  => 16#822F#,
                                           RG32F  => 16#8230#,
                                           R8I    => 16#8231#,
                                           R8UI   => 16#8232#,
                                           R16I   => 16#8233#,
                                           R16UI  => 16#8234#,
                                           R32I   => 16#8235#,
                                           R32UI  => 16#8236#,
                                           RG8I   => 16#8237#,
                                           RG8UI  => 16#8238#,
                                           RG16I  => 16#8239#,
                                           RG16UI => 16#823A#,
                                           RG32I  => 16#823B#,
                                           RG32UI => 16#823C#,

                                           RGBA32F  => 16#8814#,
                                           RGB32F   => 16#8815#,
                                           RGBA16F  => 16#881A#,
                                           RGB16F   => 16#881B#,

                                           RGBA32UI => 16#8D70#,
                                           RGB32UI  => 16#8D71#,
                                           RGBA16UI => 16#8D76#,
                                           RGBA8UI  => 16#8D7C#,
                                           RGBA32I  => 16#8D82#,
                                           RGB32I   => 16#8D83#,
                                           RGBA16I  => 16#8D88#,
                                           RGBA8I   => 16#8D8E#);
   for Internal_Format_Buffer_Texture'Size use Low_Level.Enum'Size;

   for Internal_Format use (R3_G3_B2 => 16#2A10#,

                            RGB4     => 16#804F#,
                            RGB5     => 16#8050#,
                            RGB8     => 16#8051#,
                            RGB10    => 16#8052#,
                            RGB12    => 16#8053#,
                            RGB16    => 16#8054#,
                            RGBA2    => 16#8055#,
                            RGBA4    => 16#8056#,
                            RGB5_A1  => 16#8057#,
                            RGBA8    => 16#8058#,
                            RGB10_A2 => 16#8059#,
                            RGBA12   => 16#805A#,
                            RGBA16   => 16#805B#,

                            Depth_Component16 => 16#81A5#,
                            Depth_Component24 => 16#81A6#,

                            R8     => 16#8229#,
                            R16    => 16#822A#,
                            RG8    => 16#822B#,
                            RG16   => 16#822C#,
                            R16F   => 16#822D#,
                            R32F   => 16#822E#,
                            RG16F  => 16#822F#,
                            RG32F  => 16#8230#,
                            R8I    => 16#8231#,
                            R8UI   => 16#8232#,
                            R16I   => 16#8233#,
                            R16UI  => 16#8234#,
                            R32I   => 16#8235#,
                            R32UI  => 16#8236#,
                            RG8I   => 16#8237#,
                            RG8UI  => 16#8238#,
                            RG16I  => 16#8239#,
                            RG16UI => 16#823A#,
                            RG32I  => 16#823B#,
                            RG32UI => 16#823C#,

                            RGBA32F => 16#8814#,
                            RGB32F  => 16#8815#,
                            RGBA16F => 16#881A#,
                            RGB16F  => 16#881B#,

                            Depth24_Stencil8 => 16#88F0#,

                            R11F_G11F_B10F => 16#8C3A#,
                            RGB9_E5        => 16#8C3D#,

                            SRGB8          => 16#8C41#,
                            SRGB8_Alpha8   => 16#8C43#,

                            Depth_Component32F => 16#8CAC#,
                            Depth32F_Stencil8  => 16#8CAD#,
                            Stencil_Index8     => 16#8D48#,

                            RGBA32UI => 16#8D70#,
                            RGB32UI  => 16#8D71#,
                            RGBA16UI => 16#8D76#,
                            RGB16UI  => 16#8D77#,
                            RGBA8UI  => 16#8D7C#,
                            RGB8UI   => 16#8D7D#,
                            RGBA32I  => 16#8D82#,
                            RGB32I   => 16#8D83#,
                            RGBA16I  => 16#8D88#,
                            RGB16I   => 16#8D89#,
                            RGBA8I   => 16#8D8E#,
                            RGB8I    => 16#8D8F#,

                            R8_SNorm    => 16#8F94#,
                            RG8_SNorm   => 16#8F95#,
                            RGB8_SNorm  => 16#8F96#,
                            RGBA8_SNorm => 16#8F97#,
                            R16_SNorm   => 16#8F98#,
                            RG16_SNorm  => 16#8F99#,
                            RGB16_SNorm => 16#8F9A#,
                            RGBA16_SNorm => 16#8F9B#,

                            RGB10_A2UI => 16#906F#);
   for Internal_Format'Size use Low_Level.Enum'Size;

   for Compressed_Format use
     (Compressed_Red_RGTC1                      => 16#8DBB#,
      Compressed_Signed_Red_RGTC1               => 16#8DBC#,
      Compressed_RG_RGTC2                       => 16#8DBD#,
      Compressed_Signed_RG_RGTC2                => 16#8DBE#,

      Compressed_RGBA_BPTC_Unorm                => 16#8E8C#,
      Compressed_SRGB_Alpha_BPTC_UNorm          => 16#8E8D#,
      Compressed_RGB_BPTC_Signed_Float          => 16#8E8E#,
      Compressed_RGB_BPTC_Unsigned_Float        => 16#8E8F#,

      Compressed_R11_EAC                        => 16#9270#,
      Compressed_Signed_R11_EAC                 => 16#9271#,
      Compressed_RG11_EAC                       => 16#9272#,
      Compressed_Signed_RG11_EAC                => 16#9273#,
      Compressed_RGB8_ETC2                      => 16#9274#,
      Compressed_SRGB8_ETC2                     => 16#9275#,
      Compressed_RGB8_Punchthrough_Alpha1_ETC2  => 16#9276#,
      Compressed_SRGB8_Punchthrough_Alpha1_ETC2 => 16#9277#,
      Compressed_RGBA8_ETC2_EAC                 => 16#9278#,
      Compressed_SRGB8_Alpha8_ETC2_EAC          => 16#9279#,

      --  ASTC (not part of OpenGL core)
      Compressed_RGBA_ASTC_4x4_KHR              => 16#93B0#,
      Compressed_RGBA_ASTC_5x4_KHR              => 16#93B1#,
      Compressed_RGBA_ASTC_5x5_KHR              => 16#93B2#,
      Compressed_RGBA_ASTC_6x5_KHR              => 16#93B3#,
      Compressed_RGBA_ASTC_6x6_KHR              => 16#93B4#,
      Compressed_RGBA_ASTC_8x5_KHR              => 16#93B5#,
      Compressed_RGBA_ASTC_8x6_KHR              => 16#93B6#,
      Compressed_RGBA_ASTC_8x8_KHR              => 16#93B7#,
      Compressed_RGBA_ASTC_10x5_KHR             => 16#93B8#,
      Compressed_RGBA_ASTC_10x6_KHR             => 16#93B9#,
      Compressed_RGBA_ASTC_10x8_KHR             => 16#93BA#,
      Compressed_RGBA_ASTC_10x10_KHR            => 16#93BB#,
      Compressed_RGBA_ASTC_12x10_KHR            => 16#93BC#,
      Compressed_RGBA_ASTC_12x12_KHR            => 16#93BD#,

      Compressed_SRGB8_ALPHA8_ASTC_4x4_KHR      => 16#93D0#,
      Compressed_SRGB8_ALPHA8_ASTC_5x4_KHR      => 16#93D1#,
      Compressed_SRGB8_ALPHA8_ASTC_5x5_KHR      => 16#93D2#,
      Compressed_SRGB8_ALPHA8_ASTC_6x5_KHR      => 16#93D3#,
      Compressed_SRGB8_ALPHA8_ASTC_6x6_KHR      => 16#93D4#,
      Compressed_SRGB8_ALPHA8_ASTC_8x5_KHR      => 16#93D5#,
      Compressed_SRGB8_ALPHA8_ASTC_8x6_KHR      => 16#93D6#,
      Compressed_SRGB8_ALPHA8_ASTC_8x8_KHR      => 16#93D7#,
      Compressed_SRGB8_ALPHA8_ASTC_10x5_KHR     => 16#93D8#,
      Compressed_SRGB8_ALPHA8_ASTC_10x6_KHR     => 16#93D9#,
      Compressed_SRGB8_ALPHA8_ASTC_10x8_KHR     => 16#93DA#,
      Compressed_SRGB8_ALPHA8_ASTC_10x10_KHR    => 16#93DB#,
      Compressed_SRGB8_ALPHA8_ASTC_12x10_KHR    => 16#93DC#,
      Compressed_SRGB8_ALPHA8_ASTC_12x12_KHR    => 16#93DD#);
   for Compressed_Format'Size use Low_Level.Enum'Size;

   for Format use (Stencil_Index   => 16#1901#,
                   Depth_Component => 16#1902#,
                   Red             => 16#1903#,
                   Green           => 16#1904#,
                   Blue            => 16#1905#,
                   RGB             => 16#1907#,
                   RGBA            => 16#1908#,
                   BGR             => 16#80E0#,
                   BGRA            => 16#80E1#,
                   RG              => 16#8227#,
                   RG_Integer      => 16#8228#,
                   Depth_Stencil   => 16#84F9#,
                   Red_Integer     => 16#8D94#,
                   Green_Integer   => 16#8D95#,
                   Blue_Integer    => 16#8D96#,
                   RGB_Integer     => 16#8D98#,
                   RGBA_Integer    => 16#8D99#,
                   BGR_Integer     => 16#8D9A#,
                   BGRA_Integer    => 16#8D9B#);
   for Format'Size use Low_Level.Enum'Size;

   for Data_Type use (Byte           => 16#1400#,
                      Unsigned_Byte  => 16#1401#,
                      Short          => 16#1402#,
                      Unsigned_Short => 16#1403#,
                      Int            => 16#1404#,
                      Unsigned_Int   => 16#1405#,
                      Float          => 16#1406#,
                      Half_Float     => 16#140B#,
                      Unsigned_Byte_3_3_2         => 16#8032#,
                      Unsigned_Short_4_4_4_4      => 16#8033#,
                      Unsigned_Short_5_5_5_1      => 16#8034#,
                      Unsigned_Int_8_8_8_8        => 16#8035#,
                      Unsigned_Int_10_10_10_2     => 16#8036#,
                      Unsigned_Byte_2_3_3_Rev     => 16#8362#,
                      Unsigned_Short_5_6_5        => 16#8363#,
                      Unsigned_Short_5_6_5_Rev    => 16#8364#,
                      Unsigned_Short_4_4_4_4_Rev  => 16#8365#,
                      Unsigned_Short_1_5_5_5_Rev  => 16#8366#,
                      Unsigned_Int_8_8_8_8_Rev    => 16#8367#,
                      Unsigned_Int_2_10_10_10_Rev => 16#8368#,
                      Unsigned_Int_24_8           => 16#84FA#,
                      Unsigned_Int_10F_11F_11F_Rev   => 16#8C3B#,
                      Unsigned_Int_5_9_9_9_Rev       => 16#8C3E#,
                      Float_32_Unsigned_Int_24_8_Rev => 16#8DAD#);
   for Data_Type'Size use Low_Level.Enum'Size;

   for Channel_Data_Type use (None                => 0,
                              Int_Type            => 16#1404#,
                              Unsigned_Int_Type   => 16#1405#,
                              Float_Type          => 16#1406#,
                              Unsigned_Normalized => 16#8C17#,
                              Signed_Normalized   => 16#8F9C#);
   for Channel_Data_Type'Size use Low_Level.Enum'Size;

   for Alignment use (Bytes        => 1,
                      Even_Bytes   => 2,
                      Words        => 4,
                      Double_Words => 8);
   for Alignment'Size use Types.Int'Size;
end GL.Pixels;
