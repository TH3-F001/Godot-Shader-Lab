shader_type canvas_item;

//Double-Odd-Polynomial Seat - Modified Seat shaped function for more flexible easing
// Almost as flexible as bezier, but more performant

uniform float control_point : hint_range(0.01, 0.99, 0.001) = 0.5;
uniform float height : hint_range(0.01, 0.99, 0.001) = 0.5; 
uniform float plateau : hint_range(0.0, 10.0, 0.001) = 1; 

float dbl_odd_poly_seat(float position, float inflection_point, float seat_height, float plateau_length) {
	float epsilon = 0.00001;
	float min_inflection_point = 0.0 + epsilon;
	float max_inflection_point = 1.0 - epsilon;
	float min_seat_height = 0.0;
	float max_seat_height = 1.0;
	
	inflection_point = min(max_inflection_point, max(min_inflection_point, inflection_point));
	seat_height = min(max_seat_height, max(min_seat_height, seat_height));
	
	float actual_polynom_degree = 2. * plateau_length + 1.;
	float y = 0.;
	if (position <= inflection_point) {
		y = seat_height - seat_height * pow(1. - position / inflection_point, actual_polynom_degree);
	} else {
		y = seat_height + (1. - seat_height) * pow((position - inflection_point) / (1. - inflection_point), actual_polynom_degree);
	}
	
	return y;
}

float plot(vec2 uv, float percent) {
	return smoothstep(percent - 0.01, percent, uv.y) - smoothstep(percent, percent + 0.01, uv.y);
}

void fragment() {
	vec2 uv = vec2(1. - UV.x, UV.y);
	float y = dbl_odd_poly_seat(uv.x, control_point, height, plateau);	
	vec3 color = vec3(1.0 - y);
	float percent = plot(uv, y);
	color = (1.0 - percent) * color + percent * vec3(0., 1., 0.0);
	COLOR = vec4(color, 1.);
}