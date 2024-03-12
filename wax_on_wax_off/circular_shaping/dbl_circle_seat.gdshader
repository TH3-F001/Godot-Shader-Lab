shader_type canvas_item;

//Double-Circle Seat 
// formed by the meating of two circular arcs which join with a horizontal tangent
// computationally expensive due to square roots

uniform float control_point : hint_range(0.01, 0.99, 0.001) = 0.5;

float dbl_circle_seat(float position, float inflection_point) {
	float min_inflection = 0.;
	float max_inflection = 1.;
	inflection_point = max(min_inflection, min(max_inflection, inflection_point));
	
	float y = 0.;
	float inflection_squared = inflection_point * inflection_point;
	float reduction_squared = (1. - inflection_point) * (1. - inflection_point);
	float diff_squared = (position - inflection_point) * (position - inflection_point);
	
	if (position <= inflection_point) {
		y = sqrt(inflection_squared - diff_squared);
	} else {
		y = 1. - sqrt(reduction_squared - diff_squared);
	}
	return y;
	
}

float plot(vec2 uv, float percent) {
	return smoothstep(percent - 0.01, percent, uv.y) - smoothstep(percent, percent + 0.01, uv.y);
}

void fragment() {
	vec2 uv = vec2(1. - UV.x, UV.y);
	float y = dbl_circle_seat(uv.x, control_point);	
	vec3 color = vec3(1.0 - y);
	float percent = plot(uv, y);
	color = (1.0 - percent) * color + percent * vec3(0., 1., 0.0);
	COLOR = vec4(color, 1.);
}