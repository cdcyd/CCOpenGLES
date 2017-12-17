attribute vec4 aPosition;  
attribute vec3 aNormal; 
attribute vec2 texCoord0; 
attribute vec2 texCoord1;

varying  vec2 vTexCoord0;
varying  vec2 vTexCoord1;
varying  vec4 vColor;

uniform mat4 uModelViewProjectionMatrix; // 图像变换
uniform mat3 uNormalMatrix; // 法线

void main ()
{
    vec3 eyeNormal = normalize(uNormalMatrix * aNormal);
    vec3 lightPosition = vec3(0.0, 0.0, 1.0);
    vec4 diffuseColor = vec4(0.8, 0.8, 0.8, 1.0);
    float nDotVP = max(0.0, dot(eyeNormal, normalize(lightPosition)));
    
    vColor = diffuseColor * nDotVP;
    
    vTexCoord0 = texCoord0;
    vTexCoord1 = texCoord1;
    
    gl_Position = uModelViewProjectionMatrix * aPosition;;
}
