shader_type canvas_item;

uniform vec4 outline_color : source_color;
uniform float outline_size = 1.5;
uniform bool show_outline = false;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    // Se o outline estiver desativado, apenas renderiza a textura
    if (!show_outline) {
        COLOR = tex_color;
    }
	else {
	    // Se o pixel atual é opaco, renderiza normalmente
	    if (tex_color.a > 0.0) {
	        COLOR = tex_color;
	    }
		else {
			 // Verifica vizinhança para aplicar contorno
		    bool has_neighbor = false;
		    for (float x = -outline_size; x <= outline_size; x++) {
		        for (float y = -outline_size; y <= outline_size; y++) {
		            if (x == 0.0 && y == 0.0) continue; // ignora o próprio pixel
		            vec2 offset = vec2(x, y) * TEXTURE_PIXEL_SIZE;
		            vec4 neighbor = texture(TEXTURE, UV + offset);
		            if (neighbor.a > 0.0) {
		                has_neighbor = true;
		            }
		        }
		    }
		    if (has_neighbor) {
		        COLOR = outline_color;
		    } else {
		        discard;
		    }
		}
	}
}
