//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 params;

void main() {
	vec4 flash_color = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	float frame_factor = params.x;
	float flash_half_width = params.y;
	
	// Using flash_half_width instead of flash_width because
	// adding 1 to sin and dividing it by 2 puts it between 0 and 1.
	// rgb values here are between 0 and 1
	flash_color.rgb += (sin(frame_factor) + 1.0) * flash_half_width;
	
    gl_FragColor = flash_color;
}
