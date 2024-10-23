varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float darkness;

void main()
{
    vec4 originalColor = v_vColour;

    vec4 darkenedColor = originalColor * (1.0 - darkness);

    gl_FragColor = darkenedColor;
}
