attribute vec4 position;  

attribute vec2 texCoord0; 

varying  vec2 vTexCoord;

uniform mat4 uModelViewProjectionMatrix; // 图像变换

void main ()
{
    gl_Position = position * uModelViewProjectionMatrix;
    
    vTexCoord = texCoord0;
}
