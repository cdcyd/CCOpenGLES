attribute vec4 aPosition;  
attribute vec4 aColor;

varying  vec4 vColor;

uniform mat4 uModelViewProjectionMatrix;

void main ()
{
    vColor = aColor;

    gl_Position = uModelViewProjectionMatrix * aPosition;
}
