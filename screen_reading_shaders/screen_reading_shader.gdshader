shader_type spatial;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear;

uniform float brightness = 1.0;
uniform float contrast = 1.0;
uniform float saturation = 1.0;

void fragment() {
	vec3 current_pixel = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;
	
    current_pixel.rgb = mix(vec3(0.0), current_pixel.rgb, brightness);
    current_pixel.rgb = mix(vec3(0.5), current_pixel.rgb, contrast);
    current_pixel.rgb = mix(vec3(dot(vec3(1.0), current_pixel.rgb) * 0.33333), current_pixel.rgb, saturation);
	
	//COLOR.rgb = current_pixel;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
