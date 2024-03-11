shader_type canvas_item;
// Blinn-Wyvill Approximation to the Raised Inverted Cosine - Lite sin and cos

// sin and cos can be expensive to compute. If a situation calls for millions of trig_ops/sec
// you optimize this substantially by using an aproximation constucted from simple arithmatic
// blinn-wyvill's approximation diverges from the authentic trig functions by less than 0.1%
// (within the range [0-1] )


float plot(vec2 uv, float percent) {
	return smoothstep(percent - 0.01, percent, uv.y) - smoothstep(percent, percent + 0.01, uv.y);
}

float bw_cos_approximation(float radians) {
	const float coefficientA = 4.0 / 9.0;	
	const float coefficientB = 17.0 / 9.0;
	const float coefficientC = 22.0 / 9.0;

	float xSquared = radians * radians;
	float xQuad = xSquared * xSquared;
	float xSext = xQuad * xSquared;
	float result = coefficientA * xSext - coefficientB * xQuad + coefficientC * xSquared;
	return result;
	}

void fragment() {
	vec2 uv = vec2(1. - UV.x, UV.y);
	float y = bw_cos_approximation(uv.x);
	y = (0.5 * sin( y + TIME)) + 0.5;
	vec3 color = vec3(1.0 - y);
	float percent = plot(uv, y);
	color = (1.0 - percent) * color + percent * vec3(0., 1., 0.0);
	COLOR = vec4(color, 1.);
}