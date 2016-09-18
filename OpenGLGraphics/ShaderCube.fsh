precision mediump float;

varying  vec2 vTexCoord0;
varying  vec4 vColor;

uniform sampler2D uSampler0;

void main(){
    
    lowp vec4 rgba = vec4(0.4,0.4,0.4,1);
    
    rgba = texture2D(uSampler0,vTexCoord0);
    
    gl_FragColor = rgba * vColor;
}