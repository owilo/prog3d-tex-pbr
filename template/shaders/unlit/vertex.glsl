#version 330 core

layout(location = 0) in vec3 position;
layout(location = 1) in vec3 normal;
layout(location = 2) in vec3 tangent;
layout(location = 3) in vec2 uv0;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;
//uniform mat4 mvp;
//uniform mat4 modelView;
//uniform mat4 normalMatrix;

out vec3 o_positionWorld;
out vec3 o_normalWorld;
out vec3 o_tangent;
out vec2 o_uv0;


void main() {
    mat3 normalMatrix = mat3(transpose(inverse(model)));
	o_uv0 = vec2(uv0.x, -uv0.y); // Ne fonctionne pas si Y n'est pas inversé
    vec4 positionWorld = model * vec4(position, 1.0);
    o_positionWorld = positionWorld.xyz;
    o_normalWorld = normalMatrix * normal;
    o_tangent = normalMatrix * tangent;
    gl_Position = projection * view * positionWorld;
}