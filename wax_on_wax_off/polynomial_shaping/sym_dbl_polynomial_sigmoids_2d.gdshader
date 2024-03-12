shader_type canvas_item;

 //Symmetric Double-Polynomial Sigmoids - Modified Seat shaped function for more natural easing

uniform int growth_rate : hint_range(-49, 49, 2) = 1;  

float sym_dbl_polynomial_sigmoid(float position, int steepness_factor) {
    float y = 0.0;
    if ((steepness_factor % 2) == 0) {
        // Even polynomial
        if (position <= 0.5) {
            y = pow(2.0 * position, float(steepness_factor)) / 2.0;
        } else {
            y = 1.0 - pow(2.0 * (position - 1.0), float(steepness_factor)) / 2.0;
        }
    } else {
        // Odd polynomial
        if (position <= 0.5) {
            y = pow(2.0 * position, float(steepness_factor)) / 2.0;
        } else {
            // Adjusting to correct version for symmetry in odd n cases
            y = 1.0 - pow(2.0 * (1.0 - position), float(steepness_factor)) / 2.0;
        }
    }
    return y;
}


float plot(vec2 uv, float percent) {
	return smoothstep(percent - 0.01, percent, uv.y) - smoothstep(percent, percent + 0.01, uv.y);
}



void fragment() {
	vec2 uv = vec2(1. - UV.x, UV.y);
	float y = sym_dbl_polynomial_sigmoid(uv.x, growth_rate);	
	vec3 color = vec3(1.0 - y);
	float percent = plot(uv, y);
	color = (1.0 - percent) * color + percent * vec3(0., 1., 0.0);
	COLOR = vec4(color, 1.);
}