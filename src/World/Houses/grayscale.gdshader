shader_type canvas_item;

uniform bool active = false;

void fragment() {
	if (active){
		float r = COLOR.r;
		float g = COLOR.g;
		float b = COLOR.b;
		
		float l = (r+g+b)/3.;
		
		COLOR.r = l;
		COLOR.g = l;
		COLOR.b = l;
	}
}

