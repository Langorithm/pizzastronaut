shader_type canvas_item;

uniform sampler2D bg : hint_screen_texture, repeat_disable, filter_linear_mipmap;

void fragment() {
	vec4 glass = textureLod(bg,SCREEN_UV,3.0);

	COLOR += glass;
	COLOR /= 2.0;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
