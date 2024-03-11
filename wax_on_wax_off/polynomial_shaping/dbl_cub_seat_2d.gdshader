shader_type canvas_item;

// Double Cubic Seat - Seat shaped function for easing
// Formed by joining two 3rd order polynomial (cubic) curves
// curves meet at a horizontal inflection point at the control coordinate (control_point,seat_height) in the unit square
uniform float control_point : hint_range(0.01, 0.99, 0.001) = 0.5;
uniform float seat_height : hint_range(0.01, 0.99, 0.001) = 0.5;

float double_cubic_seat(float position, float inflection_point, float _seat_height) {
    float epsilon = 0.00001;
    float minControlPoint = epsilon;
    float maxControlPoint = 1.0 - epsilon;
    float minSeatHeight = 0.0;
    float maxSeatHeight = 1.0;
    inflection_point = min(maxControlPoint, max(minControlPoint, inflection_point));
    _seat_height = min(maxSeatHeight, max(minSeatHeight, _seat_height));
    
    float y = 0.;
    if (position <= inflection_point) {
        y = _seat_height - _seat_height * pow(1. - position / inflection_point, 3.0);
    } else {
        y = _seat_height + (1.0 - _seat_height) * pow((position - inflection_point) / (1.0 - inflection_point), 3.0);
    } 
    return y;
}

float plot(vec2 uv, float percent) {
	return smoothstep(percent - 0.01, percent, uv.y) - smoothstep(percent, percent + 0.01, uv.y);
}



void fragment() {
    vec2 uv = vec2(1.0 - UV.x, UV.y); // Flipping the x coordinate for Godot's coordinate system
    float position = uv.x;
    float y = double_cubic_seat(position, control_point, seat_height);
    
    vec3 color = vec3(1.0 - y);
    float percent = plot(uv, y);
    color = (1.0 - percent) * color + percent * vec3(0.0, 1.0, 0.0); // The line will be green
    COLOR = vec4(color, 1.0);
}