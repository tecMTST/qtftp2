shader_type canvas_item;

// Uniforms for controlling the animation
uniform float progress : hint_range(0, 1) = 0.0;
uniform float circle_thickness : hint_range(0, 0.5) = 0.05;
uniform vec4 circle_color : source_color = vec4(0.855, 0.047, 0.082, 1.0);
uniform vec4 checkmark_color : source_color = vec4(0.855, 0.047, 0.082, 1.0);
uniform bool reverse = false; // Controls forward/reverse animation

// New uniforms for outline and shadow
uniform float outline_width : hint_range(0, 0.1) = 0.02;
uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec2 shadow_offset = vec2(0.01, 0.01);
uniform vec4 shadow_color : source_color = vec4(0.0, 0.0, 0.0, 0.4);

// Uniform to control the aspect ratio and scaling
uniform vec2 container_size = vec2(1.0, 1.0);
uniform float size_scale = 1.2; // How much to scale the container beyond the circle

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
    // Adjust UV coordinates based on container aspect ratio
    vec2 aspect_correction = vec2(1.0, container_size.x / container_size.y);
    vec2 adjusted_uv = (UV - 0.5) * aspect_correction * size_scale + 0.5;
    vec2 centered_uv = adjusted_uv - 0.5;
    float dist = length(centered_uv);
    
    // Animation timing
    float expand_time = 0.3;    // Circle expands
    float hold_time = 0.1;      // Full circle held
    float reveal_time = 0.25;   // Hole expands
    float checkmark_draw_time = 0.15; // Checkmark drawing
    
    // Adjust progress for reverse animation
    float actual_progress = reverse ? (1.0 - progress) : progress;
    
    // Circle animation - adjust for scaling
    float max_radius = 0.5 / size_scale;
    float outer_radius = 0.0;
    float inner_radius = 0.0;
    
    if (actual_progress < expand_time) {
        outer_radius = actual_progress / expand_time * max_radius;
        inner_radius = 0.0;
    } else if (actual_progress < expand_time + hold_time) {
        outer_radius = max_radius;
        inner_radius = 0.0;
    } else if (actual_progress < expand_time + hold_time + reveal_time) {
        float hole_progress = (actual_progress - expand_time - hold_time) / reveal_time;
        outer_radius = max_radius;
        inner_radius = hole_progress * (max_radius - circle_thickness / size_scale);
    } else {
        outer_radius = max_radius;
        inner_radius = max_radius - circle_thickness / size_scale;
    }
    
    // Calculate proportional outline width based on progress
    float current_outline_width = outline_width / size_scale;
    if (actual_progress < expand_time) {
        current_outline_width = outline_width * (actual_progress / expand_time) / size_scale;
    }
    
    // Calculate outline radii
    float outer_outline_radius = outer_radius + current_outline_width;
    float inner_outline_radius = max(0.0, inner_radius - current_outline_width);
    
    // Shadow rendering (applied first)
    vec4 shadow_result = vec4(0.0);
    vec2 adjusted_shadow_offset = shadow_offset / size_scale;
    vec2 shadow_uv = centered_uv - adjusted_shadow_offset;
    float shadow_dist = length(shadow_uv);
    
    // Circle shadow - account for the hole
    if (shadow_dist < outer_radius && shadow_dist > inner_radius) {
        shadow_result = mix(shadow_result, shadow_color, shadow_color.a);
    }
    
    // Checkmark shadow
    float check_start = expand_time + hold_time + reveal_time;
    if (actual_progress >= check_start) {
        vec2 check_uv = shadow_uv * 3.0;
        
        float line_thickness = 0.1 / size_scale;
        float check_progress = clamp((actual_progress - check_start) / checkmark_draw_time, 0.0, 1.0);
        
        vec2 line1_start = vec2(0.6, -0.6) / size_scale;
        vec2 line1_end   = vec2(-0.6, 0.6) / size_scale;
        vec2 line2_start = vec2(-0.6, -0.6) / size_scale;
        vec2 line2_end   = vec2(0.6, 0.6) / size_scale;
        
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
        
        if (check_alpha > 0.0) {
            shadow_result = mix(shadow_result, shadow_color, shadow_color.a);
        }
    }
    
    // Main rendering (circle and checkmark)
    vec4 main_result = vec4(0.0);
    
    // Draw circle outline
    if (dist < outer_outline_radius && dist > inner_outline_radius) {
        main_result = outline_color;
    }
    
    // Draw circle
    if (dist < outer_radius && dist > inner_radius) {
        main_result = circle_color;
    }
    
    // Checkmark animation
    if (actual_progress >= check_start) {
        vec2 check_uv = centered_uv * 3.0;
        
        float line_thickness = 0.1 / size_scale;
        float outline_line_thickness = line_thickness + current_outline_width * 2.0;
        float check_progress = clamp((actual_progress - check_start) / checkmark_draw_time, 0.0, 1.0);
        
        vec2 line1_start = vec2(0.6, -0.6) / size_scale;
        vec2 line1_end   = vec2(-0.6, 0.6) / size_scale;
        vec2 line2_start = vec2(-0.6, -0.6) / size_scale;
        vec2 line2_end   = vec2(0.6, 0.6) / size_scale;
        
        float dist_to_line1 = distance_to_line_segment(check_uv, line1_start, line1_end);
        float dist_to_line2 = distance_to_line_segment(check_uv, line2_start, line2_end);
        
        float check_alpha = 0.0;
        float outline_alpha = 0.0;
        
        if (check_progress < 0.5) {
            // First stroke
            float segment_progress = check_progress * 2.0;
            vec2 current_end = mix(line1_start, line1_end, segment_progress);
            
            // Check for outline
            if (distance_to_line_segment(check_uv, line1_start, current_end) < outline_line_thickness) {
                outline_alpha = 1.0;
            }
            
            // Check for main line
            if (distance_to_line_segment(check_uv, line1_start, current_end) < line_thickness) {
                check_alpha = 1.0;
            }
        } else {
            // Both strokes
            float segment_progress = (check_progress - 0.5) * 2.0;
            vec2 current_end = mix(line2_start, line2_end, segment_progress);
            
            // Check for outlines
            if (dist_to_line1 < outline_line_thickness || 
                distance_to_line_segment(check_uv, line2_start, current_end) < outline_line_thickness) {
                outline_alpha = 1.0;
            }
            
            // Check for main lines
            if (dist_to_line1 < line_thickness || 
                distance_to_line_segment(check_uv, line2_start, current_end) < line_thickness) {
                check_alpha = 1.0;
            }
        }
        
        // Once fully drawn, keep the checkmark visible
        if (check_progress >= 1.0) {
            if (dist_to_line1 < outline_line_thickness || dist_to_line2 < outline_line_thickness) {
                outline_alpha = 1.0;
            }
            if (dist_to_line1 < line_thickness || dist_to_line2 < line_thickness) {
                check_alpha = 1.0;
            }
        }
        
        // Apply checkmark with outline
        if (outline_alpha > 0.0) {
            main_result = mix(main_result, outline_color, outline_alpha);
        }
        if (check_alpha > 0.0) {
            main_result = mix(main_result, checkmark_color, check_alpha);
        }
    }
    
    // Combine shadow and main result (shadow goes beneath)
    if (shadow_result.a > 0.0 && main_result.a == 0.0) {
        COLOR = shadow_result;
    } else {
        COLOR = main_result;
    }
}