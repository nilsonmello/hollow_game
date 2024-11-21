//
// Simple passthrough vertex shader
//


attribute vec3 in_Position;                  // (x,y,z)
//attribute vec3 in_Normal;                  // (x,y,z)     unused in this shader.
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec2 in_TextureCoord;              // (u,v)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float time;

float noise(vec3 pos)
{
    return fract(sin(pos.x * 100. + pos.y * 1029.) * 1102.);
}


void main()
{
    vec3 pos = in_Position;
     float rng = noise(pos);
    pos.x += sin(time*rng)*6.;
     pos.y += cos(time*rng)*3.;
     
    vec4 object_space_pos = vec4( pos, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    
    v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord;
}