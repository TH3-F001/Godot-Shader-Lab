shader_type canvas_item;

//Circular Interpolation: Ease-in/out
// This circular arc offers quick and easy easing iun or out of the unit square
// less efficient because it uses square root, but easy to code

uniform bool ease_in = false;



float circular_ease_in(float position) {
	float y = 1. - sqrt(1. - position*position);
	return y;
}

float circular_ease_out(float position) {
	float y = sqrt(1.0 - (1.0 - position) * (1.0 - position));
	return y;
}

float circular_ease(float position, bool e_in) {
	if (e_in) {
		return circular_ease_in(position);
	} else {
		return circular_ease_out(position);
	}
}

float plot(vec2 uv, float percent) {
	return smoothstep(percent - 0.01, percent, uv.y) - smoothstep(percent, percent + 0.01, uv.y);
}

void fragment() {
	vec2 uv = vec2(1. - UV.x, UV.y);
	float y = circular_ease(uv.x, ease_in);	
	vec3 color = vec3(1.0 - y);
	float percent = plot(uv, y);
	color = (1.0 - percent) * color + percent * vec3(0., 1., 0.0);
	COLOR = vec4(color, 1.);
}