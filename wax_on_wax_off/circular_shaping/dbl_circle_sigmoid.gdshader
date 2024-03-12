shader_type canvas_item;

// Double-Circle Sigmoid - a sigmoid for by meeting two circular arcs

uniform float growth : hint_range(0.01, 0.99, 0.001) = 0.5;

float dbl_cricle_sigmoid(float position, float growth_rate) {
	float min_growth = 0.0;
	float max_growth = 1.0;
	growth_rate = max(min_growth, min(max_growth, growth_rate));
	
	
	float reduction_squared = (1. - growth_rate) * (1. - growth_rate);
	float diff_squared = (position - 1.) * (position - 1.);
	float y = 0.;
	if (position <= growth_rate) {
		y = growth_rate - sqrt(growth_rate * growth_rate - position * position);
	} else {
		y = growth_rate + sqrt(reduction_squared - diff_squared);
	}
	return y;
}

float plot(vec2 uv, float percent) {
	return smoothstep(percent - 0.01, percent, uv.y) - smoothstep(percent, percent + 0.01, uv.y);
}

void fragment() {
	vec2 uv = vec2(1. - UV.x, UV.y);
	float y = dbl_cricle_sigmoid(uv.x, growth);	
	vec3 color = vec3(1.0 - y);
	float percent = plot(uv, y);
	color = (1.0 - percent) * color + percent * vec3(0., 1., 0.0);
	COLOR = vec4(color, 1.);
}