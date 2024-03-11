shader_type canvas_item;

// Double Cubic Seat With Linear Blend - Modified Seat shaped function for smoother easing
// Better performance than bezier curves
// First parameter - position
// Second parameter - single variable to control location of the inflection point
// Third parameter - controls the amount to blend
// The adjustable flattening around the inflection point makes this a useful shaping function
// for lensing or magnifying evenly spaced data

uniform float control_point : hint_range(0.01, 0.99, 0.001) = 0.5;
uniform float blend : hint_range(0.01, 0.99, 0.001) = 0.5; 

float dcslb(float position, float inflection_point, float blend_amount) {
	float epsilon = 0.00001;
	float min_inflection_point = epsilon;
	float max_inflection_point = 1.0 - epsilon;
	float min_blend_amount = 0.0;
	float max_blend_amount = 1.0;
	inflection_point = min(max_inflection_point, max(min_inflection_point, inflection_point));
	blend_amount = min(max_blend_amount, max(min_blend_amount, blend_amount));
	blend_amount = 1.0 - blend_amount;
	
	float y = 0.0;
	if (position <= inflection_point){
		y = blend_amount * position + (1. - blend_amount) * inflection_point * (1. - pow(1. - position / inflection_point, 3.0));	
	} else {
		y = blend_amount * position + (1. - blend_amount) * (inflection_point + (1. - inflection_point) * pow((position - inflection_point) / (1. - inflection_point), 3.0));
	}
	return y;
}

float plot(vec2 uv, float percent) {
	return smoothstep(percent - 0.01, percent, uv.y) - smoothstep(percent, percent + 0.01, uv.y);
}

void fragment() {
	vec2 uv = vec2(1. - UV.x, UV.y);
	float y = dcslb(uv.x, control_point, blend);	
	vec3 color = vec3(1.0 - y);
	float percent = plot(uv, y);
	color = (1.0 - percent) * color + percent * vec3(0., 1., 0.0);
	COLOR = vec4(color, 1.);
}