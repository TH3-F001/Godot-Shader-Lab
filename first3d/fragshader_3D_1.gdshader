shader_type spatial;

uniform float speed = 0.05;
uniform float amplitude = 1.;
uniform float frequency = 1.0;
uniform float offset = -0.4;

void vertex() {
	// Called for every vertex the material is visible on.
}


void fragment() {
	vec4 color = vec4(0., 0., 0., 0.);
	float scroll = mod(TIME * speed, 1.);
	vec2 uv = UV;
	float wave = amplitude * sin((UV.x + TIME * speed) * frequency * 2.0 * PI);
	uv.y += wave + offset;
	color.b += (sin(TIME + 0.5)* uv.x);
	color.r += (cos(TIME + 1. )* uv.y);

	ALBEDO = mix(color.xyz, vec3(0.0) ,abs(wave));
	
}