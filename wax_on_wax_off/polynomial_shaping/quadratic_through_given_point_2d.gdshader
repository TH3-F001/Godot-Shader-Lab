shader_type canvas_item;

// Quadratic Through a Given Point - smooth parabolic easing
// defines an axis aligned quadratic (parabolo) which passes through a user defined point (a,b)
// not all points in the unit square will produce curves that pass through the locations 0,- and 1,1
uniform float _a : hint_range(0.01, 0.99, 0.001) = 0.5;
uniform float _b : hint_range(0.01, 0.99, 0.001) = 0.5; 


float quad_through_given_point(float x, float a, float b) {
	float epsilon = 0.00001;
	float min_a = 0.0 + epsilon;
	float max_a = 1.0 - epsilon;
	float min_b = 0.0;
	float max_b = 1.0;
	
	a = min(max_a, max(min_a, a));
	b = min(max_b, max(min_b, b));
	
	float A = (1. - b) / (1. - a) - (b / a);
	float B = (A * (a * a) - b) / a;
	float y = A * (x * x) - B * (x);
	y = min(1, max(0 ,y));
	
	return y;
}

float plot(vec2 uv, float percent) {
	return smoothstep(percent - 0.01, percent, uv.y) - smoothstep(percent, percent + 0.01, uv.y);
}

void fragment() {
	vec2 uv = vec2(1. - UV.x, UV.y);
	float y = quad_through_given_point(uv.x, _a, _b);	
	vec3 color = vec3(1.0 - y);
	float percent = plot(uv, y);
	color = (1.0 - percent) * color + percent * vec3(0., 1., 0.0);
	COLOR = vec4(color, 1.);
}