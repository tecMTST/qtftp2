shader_type canvas_item;

// Uniforms for controlling the animation
uniform float progress : hint_range(0, 1) = 0.0;
uniform float circle_thickness : hint_range(0, 0.5) = 0.02;
uniform vec4 circle_color : source_color = vec4(0.0, 1.0, 0.0, 1.0);
uniform vec4 checkmark_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform bool reverse = false; // Controls forward/reverse animation

// Helper function to calculate distance to a line segment
float distance_to_line_segment(vec2 p, vec2 a, vec2 b) {
    vec2 ab = b - a;
    vec2 ap = p - a;
    
    float dot_ab_ap = dot(ab, ap);
    if (dot_ab_ap <= 0.0) return length(ap);
    
    float dot_ab_ab = dot(ab, ab);
    if (dot_ab_ap >= dot_ab_ab) return length(p - b);
    
    return length(ap - ab * (dot_ab_ap / dot_ab_ab));
}

void fragment() {
    // Get UV coordinates centered at (0.5, 0.5)
    vec2 centered_uv = UV - 0.5;
    float dist = length(centered_uv);
    
    // Animation timing
    float expand_time = 0.3;    // Circle expands
    float hold_time = 0.1;      // Full circle held
    float reveal_time = 0.25;   // Hole expands
    float checkmark_draw_time = 0.15; // Checkmark drawing
    
    // Adjust progress for reverse animation
    float actual_progress = reverse ? (1.0 - progress) : progress;
    
    // Circle animation
    float outer_radius = 0.0;
    float inner_radius = 0.0;
    
    if (actual_progress < expand_time) {
        outer_radius = actual_progress / expand_time * 0.5;
        inner_radius = 0.0;
    } else if (actual_progress < expand_time + hold_time) {
        outer_radius = 0.5;
        inner_radius = 0.0;
    } else if (actual_progress < expand_time + hold_time + reveal_time) {
        float hole_progress = (actual_progress - expand_time - hold_time) / reveal_time;
        outer_radius = 0.5;
        inner_radius = hole_progress * (0.5 - circle_thickness);
    } else {
        outer_radius = 0.5;
        inner_radius = 0.5 - circle_thickness;
    }
    
    // Draw circle
    if (dist < outer_radius && dist > inner_radius) {
        COLOR = circle_color;
    } else {
        // Checkmark animation
        float check_start = expand_time + hold_time + reveal_time;
        
        if (actual_progress >= check_start) {
            vec2 check_uv = centered_uv * 3.0;
            
            float line_thickness = 0.1;
            float check_progress = clamp((actual_progress - check_start) / checkmark_draw_time, 0.0, 1.0);
            
            vec2 line1_start = vec2(-0.6, 0.0);
            vec2 line1_end   = vec2(-0.2, 0.6);
            vec2 line2_start = vec2(-0.2, 0.6);
            vec2 line2_end   = vec2(0.4, -0.7);
            
            float dist_to_line1 = distance_to_line_segment(check_uv, line1_start, line1_end);
            float dist_to_line2 = distance_to_line_segment(check_uv, line2_start, line2_end);
            
            float check_alpha = 0.0;
            
            if (check_progress < 0.5) {
                // First stroke
                float segment_progress = check_progress * 2.0;
                vec2 current_end = mix(line1_start, line1_end, segment_progress);
                if (distance_to_line_segment(check_uv, line1_start, current_end) < line_thickness) {
                    check_alpha = 1.0;
                }
            } else {
                // Both strokes
                float segment_progress = (check_progress - 0.5) * 2.0;
                vec2 current_end = mix(line2_start, line2_end, segment_progress);
                if (dist_to_line1 < line_thickness || distance_to_line_segment(check_uv, line2_start, current_end) < line_thickness) {
                    check_alpha = 1.0;
                }
            }
            
            // Once fully drawn, keep the checkmark visible
            if (check_progress >= 1.0) {
                if (dist_to_line1 < line_thickness || dist_to_line2 < line_thickness) {
                    check_alpha = 1.0;
                }
            }
            
            COLOR = mix(vec4(0.0), checkmark_color, check_alpha);
        } else {
            COLOR = vec4(0.0, 0.0, 0.0, 0.0);
        }
    }
}
