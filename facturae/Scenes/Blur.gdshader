shader_type canvas_item;

uniform sampler2D screen_tex : hint_screen_texture, filter_linear_mipmap;
uniform float blur_size : hint_range(0.0, 10.0) = 4.0;

void fragment() {
    vec2 size = SCREEN_PIXEL_SIZE * blur_size;
    vec4 sum = vec4(0.0);
    
    // Muestreo básico 9x9 (usa floats para evitar el error)
    for (int x = -4; x <= 4; x++) {
        for (int y = -4; y <= 4; y++) {
            vec2 offset = vec2(float(x), float(y)) * size;
            sum += texture(screen_tex, SCREEN_UV + offset);
        }
    }

    sum /= 81.0; // promedio de 9x9
    COLOR = sum;
}
