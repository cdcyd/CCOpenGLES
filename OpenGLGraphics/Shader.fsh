precision mediump float;

varying  vec2 texCoordVarying;

uniform sampler2D sam2DR;

void main(){
    
    lowp vec4 rgba = vec4(0.4,0.4,0.4,1);
    
    rgba = texture2D(sam2DR,texCoordVarying);
    
    gl_FragColor = rgba;
}