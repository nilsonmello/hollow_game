//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float time;
uniform vec2 texel; // Tamanho do texel

// Parâmetros de controle da oscilação
const float frequencyX = 1.;       // Frequência de oscilação horizontal
const float frequencyY = 1.;       // Frequência de oscilação vertical
const float speed = 2.;        // Velocidade do movimento
const float noiseFrequency = 1.;

float snoise(vec2 co)
{
    float a = 12.9898;
    float b = 78.233;
    float c = 43758.5453;
    float dt = dot(co.xy, vec2(a, b));
    float sn = mod(dt, 3.14);
    return fract(sin(sn) * c);
}

void main()
{
    // Reduz a resolução da amostragem para criar blocos maiores
    //vec2 blockCoord = floor(v_vTexcoord / texel) * texel;
     vec2 tex_coordinate = floor(v_vTexcoord / texel)*texel;
     
     float increase = tex_coordinate.y;
     vec2 amplitude_as = texel;
    
     float noise = snoise(tex_coordinate);
     
    // Calcula deslocamento em cada eixo usando seno, cosseno e ruído para um movimento mais orgânico
     float offsetX = ceil(sin(tex_coordinate.y + noise * noiseFrequency * 100. + time * .5 * speed * .8)) * amplitude_as.x ;
     float offsetY = ceil(cos(tex_coordinate.x + noise * noiseFrequency * 40. + time * .5 * speed * .8) * 2.) * amplitude_as.y;

    // Aplica o deslocamento calculado à coordenada de textura
    vec2 variation = vec2(offsetX, offsetY);

    // Usa a coordenada alterada para amostrar a textura
    vec4 base_color = v_vColour * texture2D(gm_BaseTexture, tex_coordinate + variation);

    gl_FragColor = base_color;
}