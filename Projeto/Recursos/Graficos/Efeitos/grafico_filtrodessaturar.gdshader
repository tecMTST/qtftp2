shader_type canvas_item;

// Declare screen texture uniform with proper hint :cite[4]:cite[6]
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// Control saturation (0.0 = fully grayscale, 1.0 = full color) :cite[1]
uniform float saturation : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    // Get the color from the screen texture beneath this CanvasLayer :cite[5]:cite[7]
    vec4 original_color = texture(SCREEN_TEXTURE, SCREEN_UV);
    
    // Calculate grayscale using luminance weights :cite[1]
    float gray = dot(original_color.rgb, vec3(0.299, 0.587, 0.114));
    
    // Mix between grayscale and original color based on saturation :cite[1]
    vec3 desaturated_color = mix(vec3(gray), original_color.rgb, saturation);
    
    // Output the final color
    COLOR = vec4(desaturated_color, original_color.a);
}