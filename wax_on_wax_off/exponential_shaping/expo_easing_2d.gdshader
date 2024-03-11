shader_type canvas_item;

//Exponential Easing - does what it says on the tin

uniform float ease : hint_range(0.01, 0.99, 0.001) = 0.5;

float expo_ease(float position, float ease_amount) {
	float epsilon = 0.00001;
	float min_ease_amount = 0.0 + epsilon;
	float max_ease_amount = 1.0 - epsilon;
	ease_amount = max(min_ease_amount, min(max_ease_amount, ease_amount));
	
	if (ease_amount < 0.5) {
		//emphasis
		ease_amount = 2.0 * (ease_amount);
		float y = pow(position, ease_amount);
		return y;
	} else {
		//de-emphasis
		ease_amount = 2.0 * (ease_amount - 0.5);
		float y = pow(position, 1.0/(1.0 - ease_amount));
		return y;
	}
}

float plot(vec2 uv, float percent) {
	return smoothstep(percent - 0.01, percent, uv.y) - smoothstep(percent, percent + 0.01, uv.y);
}

void fragment() {
	vec2 uv = vec2(1. - UV.x, UV.y);
	float y = expo_ease(uv.x, ease);	
	vec3 color = vec3(1.0 - y);
	float percent = plot(uv, y);
	color = (1.0 - percent) * color + percent * vec3(0., 1., 0.0);
	COLOR = vec4(color, 1.);
}