shader_type spatial;

uniform float color_id;
uniform float mesh_id;

global uniform float palette_size;
global uniform float mesh_count;

vec3 get_albedo_color() {
	return vec3(color_id / (palette_size - 1.0) + 0.5 / palette_size, 1.0, mesh_id / mesh_count);
}

void fragment() {
	ALBEDO = get_albedo_color();
}

void light() {
	float d = clamp(dot(NORMAL, LIGHT), 0.0, 1.0) * ATTENUATION * LIGHT_COLOR.r;
	DIFFUSE_LIGHT = vec3(0.0,round(d * 16.0)/16.0,1.0);
}