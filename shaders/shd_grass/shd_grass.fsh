varying vec2 v_vTexcoord; 
varying vec4 v_vColour;
uniform float u_time; 
uniform float tile;

void main() {
    vec2 id = fract(tile * v_vTexcoord);
    
    float swayIntensity = (- id.y + 1.) / 400.;
    float yOffset = sin(u_time) * swayIntensity;

    vec2 displacedTexcoord = vec2( v_vTexcoord.x + yOffset,  v_vTexcoord.y);

    gl_FragColor = v_vColour * texture2D(gm_BaseTexture, displacedTexcoord);
}
