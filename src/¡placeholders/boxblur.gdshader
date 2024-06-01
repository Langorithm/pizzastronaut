shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest_mipmap;
uniform float blur_strength : hint_range(0.0, 5.0, 0.2) = 3.;
uniform float blur_weight : hint_range(0.0, 1.0, 0.01) = .5;

void fragment() {
	//float strength = blur_strength_multilier * (COLOR.r+COLOR.g+COLOR.b)/3.;
	COLOR = textureLod(screen_texture, SCREEN_UV, blur_strength);
	//COLOR.a = alpha;
}
