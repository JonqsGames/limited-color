shader_type spatial;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture;

global uniform sampler2D palette : filter_nearest, repeat_disable, source_color;
global uniform float palette_size;
global uniform sampler2D bayer_matrix : filter_nearest;

void vertex() {
	POSITION = vec4(VERTEX, 1.0);
}

void fragment() {
	vec3 screen_color = texture(screen_texture, SCREEN_UV).rgb;
	vec2 scale = VIEWPORT_SIZE / vec2(textureSize(bayer_matrix,0));
	ALBEDO = texture(palette, vec2(screen_color.r, 0.5)).rgb;
	// Outline test
	vec2 screen_size = vec2(textureSize(screen_texture, 0));
	float px = 0.5/screen_size.x;
	float py = 0.5/screen_size.y;
	float d = screen_color.b;
	float du = texture(screen_texture, SCREEN_UV+vec2(0.0, py)).b;
	float dd = texture(screen_texture, SCREEN_UV+vec2(0.0, -py)).b;
	float dr = texture(screen_texture, SCREEN_UV+vec2(px, 0.0)).b;
	float dl = texture(screen_texture, SCREEN_UV+vec2(-px, 0.0)).b;
	float outline = 0.0 + abs(abs(d)-abs(du)) + abs(abs(d)-abs(dd)) + abs(abs(d)-abs(dl)) + abs(abs(d)-abs(dr));
	ALBEDO = mix(ALBEDO,  texture(palette, vec2(palette_size - screen_color.r, 0.5)).rgb, outline);
	// Shadow dither
	float bayer_value = texture(bayer_matrix, SCREEN_UV * scale).r;
	ALBEDO = mix(texture(palette, vec2(0.0, 0.5)).rgb,ALBEDO, float(screen_color.g > bayer_value / (outline * 3.0 + 1.0)));
}
