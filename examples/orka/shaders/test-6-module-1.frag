#version 330 core

#extension GL_ARB_shading_language_420pack : require
#extension GL_ARB_explicit_uniform_location : require

flat in uint var_InstanceID;

in vec4 var_n;
in vec4 var_p;
in vec2 var_uv;

layout(location = 5) uniform mat4 view;
layout(location = 7) uniform vec4 lightPosition;

layout(location = 8) uniform sampler2DArray diffuseTexture;

out vec4 out_Color;

const float pi = 3.14159265358979323846264338327950288419716939937511;

struct Light {
    vec4 ambient;
    vec4 diffuse;
    vec4 specular;
};

struct Material {
    vec4 ambient;
    vec4 emission;
    vec4 specular;
    float shininess;
};

const Light light = {
    vec4(0.1, 0.1, 0.1, 1.0),
    vec4(1.0, 1.0, 1.0, 1.0),
    vec4(1.0, 1.0, 1.0, 1.0),
};

const Material material = {
    vec4(1.0, 1.0, 1.0, 1.0),
    vec4(0.0, 0.0, 0.0, 1.0),
    vec4(1.0, 1.0, 1.0, 1.0),
    20.0,
};

void main(void) {
    vec4 color = material.emission;
    vec4 tex_color = texture(diffuseTexture, vec3(var_uv, var_InstanceID));

    color += light.ambient * material.ambient * tex_color;
    vec3 normal = normalize(var_n.xyz);

    vec3 light_dir = normalize(lightPosition.xyz - var_p.xyz);
    vec3 view_dir = normalize(-var_p.xyz);

    float cosTi = max(dot(normal, light_dir), 0.0); // n.l factor

    // Phong shading:
    //float cosTh = max(dot(view_dir, reflect(-light_dir, normal)), 0.0);

    // Blinn-Phong shading:
    vec3 half_vector = normalize(view_dir + light_dir);
    float cosTh = max(dot(normal, half_vector), 0.0); // n.h factor

    vec4 Kd = light.diffuse * tex_color;
    vec4 Ks = light.specular * material.specular;

    Kd /= pi;
    Ks *= ((material.shininess + 8) / (8*pi));

    color += (Kd + Ks * pow(cosTh, material.shininess)) * cosTi;
    out_Color = color;
}
