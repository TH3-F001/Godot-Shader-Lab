shader_type canvas_item;

//Double Elliptic Sigmoid - a generalization of the double-circle sigmoid

uniform float Horizontal : hint_range(0.01, 0.99, 0.001) = 0.5;
uniform float Vertical : hint_range(0.01, 0.99, 0.001) = 0.5;

float dbl_elliptic_sigmoid(float position, float h_control, float v_control) {
	float epsilon = 0.00001;
	float min_h_control = 0.0 + epsilon;
	float max_h_control = 1.0 - epsilon;
	float min_v_control = 0.0 + epsilon;
	float max_v_control = 1.0 - epsilon;
	h_control = max(min_h_control, min(max_h_control, h_control));
	v_control = max(min_v_control, min(max_v_control, v_control));
	
	float y = 0.;
	if (position <= h_control) {
		y = v_control * (1. - (sqrt(pow(h_control,2) - pow(position, 2)) / h_control ));
	} else {
		y = v_control + ((1. - v_control) / (1. - h_control)) * sqrt(pow(1. - h_control, 2) - pow(position - 1., 2));
	}
	return y;
}

float plot(vec2 uv, float percent) {
	return smoothstep(percent - 0.01, percent, uv.y) - smoothstep(percent, percent + 0.01, uv.y);
}

void fragment() {
	vec2 uv = vec2(1. - UV.x, UV.y);
	float y = dbl_elliptic_sigmoid(uv.x, Horizontal, Vertical);	
	vec3 color = vec3(1.0 - y);
	float percent = plot(uv, y);
	color = (1.0 - percent) * color + percent * vec3(0., 1., 0.0);
	COLOR = vec4(color, 1.);
}