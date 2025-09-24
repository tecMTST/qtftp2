shader_type canvas_item;

uniform float burn_progress : hint_range(0.0, 1.0) = 0.0;
uniform float completion_wipe_progress : hint_range(0.0, 1.0) = 0.0;
uniform float noise_force : hint_range(0.0, 2.0) = 2.0;
uniform vec4 burn_color : source_color = vec4(0.855, 0.047, 0.082, 1.0);
uniform float border_width : hint_range(0.0, 0.3) = 0.3;
uniform float burn_direction = 145.0;
uniform vec4 completion_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float wipe_direction = 145.0;
uniform float wipe_softness : hint_range(0.0, 0.2) = 0.2;

vec2 degrees_to_vector(float deg) {
    return vec2(cos(radians(deg)), sin(radians(deg)));
}

float perlin_noise(vec2 uv) {
    vec2 i = floor(uv);
    vec2 f = fract(uv);
    
    vec2 grad00 = vec2(cos(i.x * 12.9898 + i.y * 78.233), sin(i.x * 12.9898 + i.y * 78.233));
    vec2 grad10 = vec2(cos((i.x + 1.0) * 12.9898 + i.y * 78.233), sin((i.x + 1.0) * 12.9898 + i.y * 78.233));
    vec2 grad01 = vec2(cos(i.x * 12.9898 + (i.y + 1.0) * 78.233), sin(i.x * 12.9898 + (i.y + 1.0) * 78.233));
    vec2 grad11 = vec2(cos((i.x + 1.0) * 12.9898 + (i.y + 1.0) * 78.233), sin((i.x + 1.0) * 12.9898 + (i.y + 1.0) * 78.233));
    
    float dot00 = dot(grad00, f);
    float dot10 = dot(grad10, f - vec2(1.0, 0.0));
    float dot01 = dot(grad01, f - vec2(0.0, 1.0));
    float dot11 = dot(grad11, f - vec2(1.0, 1.0));
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(dot00, dot10, u.x), mix(dot01, dot11, u.x), u.y) * 0.5 + 0.5;
}

float smooth_organic_noise(vec2 uv, float frequency) {
    float value = 0.0;
    float amplitude = 0.5;
    
    for (int i = 0; i < 4; i++) {
        vec2 organic_variation = vec2(sin(uv.y * 3.14159 * float(i + 1)) * 0.1, 
                                     cos(uv.x * 3.14159 * float(i + 2)) * 0.1);
        
        value += perlin_noise(uv * frequency + organic_variation) * amplitude;
        frequency *= 2.0;
        amplitude *= 0.5;
    }
    
    return value;
}

void fragment() {
    // Get original texture color
    vec4 original_color = texture(TEXTURE, UV);
    vec2 uv = UV;
    
    // Calculate completion and wiping
    float completion_progress = clamp(completion_wipe_progress / 0.75, 0.0, 1.0);
    float wipe_progress = clamp((completion_wipe_progress - 0.25) / 0.75, 0.0, 1.0);
    
    // Generate smooth organic noise (NO GRAIN)
    float noise_value = smooth_organic_noise(uv * 8.0, 1.0);
    
    // Calculate burn effect - FIXED THRESHOLD RANGE
    vec2 burn_dir = degrees_to_vector(burn_direction);
    float burn_value = dot(uv * 2.0 - 1.0, burn_dir) + (noise_value * noise_force);
    
    // FIXED: Extended threshold range to ensure complete dissolve
    float burn_threshold = mix(-3.0, 3.0, burn_progress); // Changed from -1.5/1.5 to -3.0/3.0
    
    // Calculate wipe effect
    vec2 wipe_dir = degrees_to_vector(wipe_direction);
    float wipe_value = dot(uv * 2.0 - 1.0, wipe_dir);
    float wipe_threshold = mix(-2.0, 2.0, wipe_progress);
    float wipe_alpha = smoothstep(wipe_threshold - wipe_softness, wipe_threshold + wipe_softness, wipe_value);
    
    // Initialize final color
    vec4 final_color = original_color.a > 0.01 ? original_color : vec4(0.0);
    
    // Store completion color separately
    vec4 completion_result = final_color;
    
    // Only process if we have texture content
    if (original_color.a > 0.01) {
        // 1. BURN: Apply burn effect
        if (burn_value < burn_threshold) {
            if (burn_value > (burn_threshold - border_width)) {
                completion_result = burn_color;
            } else {
                completion_result = vec4(0.0);
            }
        }
        // 2. COMPLETION: Smooth paint over effect
        else if (completion_progress > 0.0) {
            float smooth_coverage = completion_progress * completion_progress * (3.0 - 2.0 * completion_progress);
            
            if (completion_progress >= 0.999) {
                completion_result = completion_color;
            } else {
                completion_result = mix(original_color, completion_color, smooth_coverage);
            }
        }
        
        // 3. WIPE: Apply soft wipe to the final result
        if (wipe_progress > 0.0) {
            final_color = completion_result;
            final_color.a *= wipe_alpha;
        } else {
            final_color = completion_result;
        }
    }
    
    COLOR = final_color;
}