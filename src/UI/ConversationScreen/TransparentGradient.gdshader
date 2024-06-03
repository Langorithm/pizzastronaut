shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
		float alpha = 1.-UV.y*(UV.y)*(UV.y)*(UV.y)*(UV.y);
		COLOR.a = min(COLOR.a,alpha*alpha*alpha*alpha);
}
