precision mediump float;

varying  vec2 vTexCoord0;
varying  vec2 vTexCoord1;
varying  vec4 vColor;

uniform sampler2D uTexture0;
uniform sampler2D uTexture1;

void main(){
    
    vec4 texel0 = texture2D(uTexture0, vTexCoord0);
    vec4 texel1 = texture2D(uTexture1, vTexCoord1);
    
    gl_FragColor = ((1.0 - texel1.a) * texel0 + texel1.a * texel1) * vColor;
}
