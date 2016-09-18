attribute vec4 aPosition;  
attribute vec3 aNormal;
attribute vec2 aTexCoord0; 

varying  vec2 vTexCoord0;
varying  vec4 vColor;

uniform mat4 uModelViewProjectionMatrix; // 图像变换
uniform mat3 uNormalMatrix; // 法线

void main (){
    
    vec3 eyeNormal = normalize(uNormalMatrix * aNormal);
    vec3 lightPosition = vec3(0.0, 0.0, 1.0);
    vec4 diffuseColor = vec4(0.8, 0.8, 0.8, 1.0);
    float nDotVP = max(0.0, dot(eyeNormal, normalize(lightPosition))); 
    NSLog();          
    // 光照
    vColor = diffuseColor * nDotVP;
    
    // 纹理
    vTexCoord0 = aTexCoord0;
    
    // 顶点
    gl_Position = uModelViewProjectionMatrix * aPosition;
}
