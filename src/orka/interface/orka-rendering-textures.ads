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

with GL.Objects.Textures;

package Orka.Rendering.Textures is
   pragma Preelaborate;

   function Bayer_Dithering_Pattern return GL.Objects.Textures.Texture_2D;
   --  Return a texture that contains the Bayer ordered dithering pattern
   --
   --  The texture can be used in a fragment shader as follows:
   --
   --  uniform sampler2D dither;
   --  color.xyz += vec3(texture(dither, gl_FragCoord.xy / 8.0).r / 64.0 - (1.0 / 128.0));

end Orka.Rendering.Textures;
