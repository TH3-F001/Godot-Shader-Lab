shader_type spatial;
render_mode specular_toon;

uniform float height_scale = 0.5;
uniform sampler2D noise;
uniform sampler2D normalmap;

varying vec2 pos;



float wave(vec2 position) {
	position += texture(noise, position / 10.).x * 2.0 - 1.0;
	vec2 wv = 1.0 - abs(sin(position));
	return pow(1.0 - pow(wv.x * wv.y, 0.65), 4.0);
}

float height(vec2 position, float time) {
	float d = wave((position + time) * 0.5) * 0.4;
	d += wave((position - time) * 0.2) * 0.6;
	d += wave((position + time) * 0.11) * 0.5;

	
  	return d;
}

void vertex() {
	pos = VERTEX.xz / 2.0 + 0.5;
	float k = height(pos, TIME);
	VERTEX.y += k;
	NORMAL = normalize(vec3(k - height(pos + vec2(0.1, 0.0), TIME), 0.1, k - height(pos + vec2(0.0, 0.1), TIME)));
}
void fragment() {
	float fresnel = sqrt(1.0 - dot(NORMAL, VIEW));
	RIM = 0.2;
	METALLIC = 0.0;
	ROUGHNESS = 0.01 * (1.0 - fresnel);
	ALBEDO = vec3(0.01, 0.03, 0.05) + (0.02 * fresnel);
	//NORMAL_MAP = texture(normalmap, pos).xyz;
}