varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float radius; 
uniform float smooth;
vec3 borderColor = vec3(0.2, 0.2, 0.2); // Cinza escuro

float circle(vec2 pos, float size, float smooth) {
    return smoothstep(size - smooth, size + smooth, distance(pos, vec2(0.5)));
}

void main() {
    vec4 color = v_vColour;
    vec2 pos = v_vTexcoord;

    // Aplica a cor das bordas e mantém a transparência
    color.rgb = borderColor * circle(pos, radius, smooth);

    // Mantém a transparência com base na função circle
    color.a *= circle(pos, radius, smooth);

    gl_FragColor = color;
}
