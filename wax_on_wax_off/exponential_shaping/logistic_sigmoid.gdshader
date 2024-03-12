shader_type canvas_item;

// Logistic Sigmoid - voted by scientists best representation of the growth of organic populations
// (and other natural phenomena)
// Often used for wieghted signal response functions in nueral networks
uniform float _growth_amount : hint_range(0.01, 0.99, 0.01) = 0.5;

float logistic_sigmoid(float position, float growth_rate) {
	float epsilon = 0.00001;
	float min_growth = 0.0 + epsilon;
	float max_growth = 1.0 - epsilon;
	growth_rate = max(min_growth, min(max_growth, growth_rate));
	growth_rate = (1. / (1. - growth_rate) - 1.);
	
	//Note the values are normalized
	float A = 1.0 / (1.0 + exp(0. - ((position - 0.5) * growth_rate * 2.0)));
	float B = 1.0 / (1.0 + exp(growth_rate));
	float C = 1.0 / (1.0 + exp(0. - growth_rate));
	
	float y = (A - B) / (C - B);
	return y;
}

float plot(vec2 uv, float percent) {
	return smoothstep(percent - 0.01, percent, uv.y) - smoothstep(percent, percent + 0.01, uv.y);
}

void fragment() {
	vec2 uv = vec2(1. - UV.x, UV.y);
	float y = logistic_sigmoid(uv.x, _growth_amount);	
	vec3 color = vec3(1.0 - y);
	float percent = plot(uv, y);
	color = (1.0 - percent) * color + percent * vec3(0., 1., 0.0);
	COLOR = vec4(color, 1.);
}