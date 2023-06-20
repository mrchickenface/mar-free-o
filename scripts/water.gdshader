shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	vec2 distortedUV = SCREEN_UV + texture(TEXTURE, UV).r * 0.05;
	vec4 screenColour = texture(screen_texture, distortedUV);
	COLOR = screenColour;
}
