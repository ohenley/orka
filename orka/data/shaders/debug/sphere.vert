#version 420 core

#extension GL_ARB_shader_storage_buffer_object : require

// SPDX-License-Identifier: Apache-2.0
//
// Copyright (c) 2019 onox <denkpadje@gmail.com>
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

uniform mat4 view;
uniform mat4 proj;

uniform int cellsHorizontal;
uniform int cellsVertical;

layout(std430, binding = 0) readonly restrict buffer matrixBuffer {
    mat4 world[];
};

struct Spheroid {
    float semiMajorAxis;
    float flattening;
};

layout(std430, binding = 1) readonly restrict buffer sphereBuffer {
    Spheroid spheres[];
};

out vec4 vs_normal;
out float vs_lon;
out float vs_lat;

const float pi = 3.14159265358979323846;

float lonStep = (2.0 * pi) / float(cellsHorizontal);
float latStep = (1.0 * pi) / float(cellsVertical);

vec3 get_vertex(float lonIndex, float latIndex) {
    float lonAngle = lonIndex * lonStep;
    float latAngle = pi / 2.0 - latIndex * latStep;

    float xy = cos(latAngle);
    float z = sin(latAngle);

    float x = xy * cos(lonAngle);
    float y = xy * sin(lonAngle);

    return vec3(x, y, z);
};

const uint lonOffset[] = {0, 0, 1, 0, 1, 1};
const uint latOffset[] = {0, 1, 0, 1, 0, 1};

void main() {
    const int instanceID = gl_InstanceID;

    uint indexID     = gl_VertexID % 3;
    uint triangleID  = gl_VertexID / 3;
    uint quadIndexID = triangleID % 2 + indexID;

    // Add + 1 to the cellsHorizontal so that the first quad at row i+1
    // is below the last quad of row i
    float baseLon = (triangleID / 2) % (cellsHorizontal + 1);
    float baseLat = (triangleID / 2) / (cellsHorizontal + 1);

    float lonIndex = baseLon + lonOffset[quadIndexID];
    float latIndex = baseLat + latOffset[quadIndexID];

    vec4 vertex = vec4(get_vertex(lonIndex, latIndex), 1.0);
    vec3 normal = vertex.xyz;

    // Take the last size in spheres[] if there are not enough in the buffer
    const int sizeID = min(instanceID, spheres.length() - 1);

    // Convert from geodetic coordinates to geocentric coordinates
    // using the semi-major axis and the flattening of the sphere.
    // See https://en.wikipedia.org/wiki/Geographic_coordinate_conversion

    // Semi-major axis and flattening (semi-minor axis b = a * (1.0 - f))
    const float a = spheres[sizeID].semiMajorAxis;
    const float f = spheres[sizeID].flattening;
    // f = (a - b) / a

    const float e2 = 2.0 * f - f * f;
    // e is eccentricity. See https://en.wikipedia.org/wiki/Flattening

    // Radius of curvature in the prime vertical
    const float N = a / sqrt(1.0 - e2 * vertex.z * vertex.z);

    // 1 - e2 = b**2 / a**2
    vertex.xyz *= vec3(N, N, (1.0 - e2) * N);

    gl_Position = proj * (view * (world[instanceID] * vertex));

    vs_normal = vec4(normal, 1.0);
    vs_lon = lonIndex;
    vs_lat = latIndex;
}
