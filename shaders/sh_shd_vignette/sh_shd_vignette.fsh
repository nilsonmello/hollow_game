varying vec2 v_vTexcoord; // Coordenadas de textura
varying vec4 v_vColour; // Cor do fragmento
uniform float darkness; // Valor de escuridão (0.0 a 1.0)

void main()
{
    // Obtém a cor original do fragmento
    vec4 originalColor = v_vColour;

    // Calcula a nova cor (aplicando a escuridão)
    vec4 darkenedColor = originalColor * (1.0 - darkness);

    // Define a cor do fragmento final
    gl_FragColor = darkenedColor;
}
