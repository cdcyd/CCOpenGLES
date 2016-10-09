precision mediump float;

varying  vec2 vTexCoord;

uniform sampler2D uTexture0;

void main(){
    
    lowp vec4 rgba = vec4(0.4,0.4,0.4,1);
    
    rgba = texture2D(uTexture0,vTexCoord);
    
    gl_FragColor = rgba;
}
