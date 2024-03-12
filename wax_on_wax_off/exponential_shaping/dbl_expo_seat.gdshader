shader_type canvas_item;

//Double-Exponential Seat - nicer derivs and more sensitive than cubic seat, at expense of CPU cycles
uniform float control_point : hint_range(0.001, 0.999, 0.001) = 0.5;
//uniform float seat_height : hint_range(0.01, 0.99, 0.001) = 0.5;

float dbl_expo_seat(float position, float inflection_point) {
	float epsilon = 0.00001;
	float min_inflection = 0.0 + epsilon;
	float max_inflection = 1.0 - epsilon;
	inflection_point = min(max_inflection, max(min_inflection, inflection_point));
	
	float y = 0.;
	if (position <= 0.5) {
		y = (pow(2. * position, 1. - inflection_point)) / 2.0;
	} else {
		y = 1. - (pow(2. * (1. - position), 1. - inflection_point)) / 2.0;
	}
	return y;
}

float plot(vec2 uv, float percent) {
	return smoothstep(percent - 0.01, percent, uv.y) - smoothstep(percent, percent + 0.01, uv.y);
}

void fragment() {
	vec2 uv = vec2(1. - UV.x, UV.y);
	float y = dbl_expo_seat(uv.x, control_point);	
	vec3 color = vec3(1.0 - y);
	float percent = plot(uv, y);
	color = (1.0 - percent) * color + percent * vec3(0., 1., 0.0);
	COLOR = vec4(color, 1.);
}