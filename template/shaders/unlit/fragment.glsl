#version 330 core

in vec3 o_positionWorld;
in vec3 o_normalWorld;
in vec3 o_tangent;
in vec2 o_uv0;
out vec4 FragColor;

uniform vec4 color;

uniform sampler2D colorTexture;

uniform sampler2D normalMap;

uniform sampler2D metalRoughnessMap;

uniform sampler2D aoMap;

uniform sampler2D emissiveMap;

uniform samplerCube skybox;

uniform vec3 cameraPosition;

const vec3 lightPos = vec3(-3.0, -3.0, -3.0);
const vec3 lightColor = vec3(1.0, 1.0, 1.0);
const vec3 materialAmbient = vec3(0.15, 0.15, 0.15);
const vec3 materialDiffuse = vec3(1.0, 1.0, 1.0);
const vec3 materialSpecular = vec3(1.0, 1.0, 1.0);
const float shininess = 16;

void main() {
    vec3 textureColor = (texture(colorTexture, o_uv0) * color).xyz;
    
    vec3 normal = texture(normalMap, o_uv0).xyz * 2.0 - 1.0;

    vec3 emissive = texture(emissiveMap, o_uv0).xyz;

    float metal = texture(metalRoughnessMap, o_uv0).z;

    float roughness = 0.6 + texture(metalRoughnessMap, o_uv0).y * 0.4;

    float ao = texture(aoMap, o_uv0).x;

    vec3 n = o_normalWorld;
    vec3 t = o_tangent;
    vec3 b = cross(n, t);

    mat3 tbn = mat3(t, b, n);

    vec3 newNormal = tbn * normal;

    // Phong

    // Ambient
    vec3 ambient = materialAmbient;

    // Diffuse
    vec3 lightDir = normalize(lightPos - o_positionWorld);
    vec3 diffuse = max(dot(newNormal, lightDir), 0.0) * materialDiffuse;

    // Specular
    vec3 viewDir = normalize(cameraPosition - o_positionWorld);
    vec3 reflectDir = reflect(-lightDir, newNormal);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), shininess);
    vec3 specular = spec * materialSpecular;

    // Réflexivité
    vec3 I = normalize(o_positionWorld - cameraPosition);
    vec3 reflection = reflect(I, normalize(newNormal));

    vec3 reflectedColor = texture(skybox, reflection).xyz;

    // Calculs finaux
    vec3 res1 = reflectedColor;
    vec3 res2 = textureColor * lightColor * (ambient + diffuse + metal * specular) * ao;

    vec3 result = emissive + (1.0 - roughness) * res1 + roughness * res2;

    FragColor = vec4(result, 1.0);
}