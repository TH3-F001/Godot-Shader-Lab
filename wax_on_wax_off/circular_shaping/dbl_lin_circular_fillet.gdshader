shader_type canvas_item ;
//Double Linear with Circular Fillet - CHUNGUS
// Joins two straight lines with a circular arc with an adjustable radius

uniform float A : hint_range(0.01, 0.99, 0.001) = 0.5;
uniform float B : hint_range(0.01, 0.99, 0.001) = 0.5;
uniform float R : hint_range(0.01, 0.99, 0.001) = 0.5;
//Calculates the perpendicular distance from a point to a line in 2D space (Ax + By + C = 0)
float line_to_point(float line_coefficient_a, float line_coefficient_b, float line_coefficient_c, float point_x, float point_y) {
	float distance = 0.0;
float line_vector_norm = sqrt((line_coefficient_a * line_coefficient_a) + (line_coefficient_b * line_coefficient_b));

	if (line_vector_norm != 0.0) {
		distance = (line_coefficient_a * point_x + line_coefficient_b * point_y + line_coefficient_c) / line_vector_norm;
	}
	return distance;
}


void compute_fillet_parameters(
    float p1x, float p1y,
    float p2x, float p2y,
    float p3x, float p3y,
    float p4x, float p4y,
    float r,
    out float arc_center_x, out float arc_center_y,
    out float arc_start_angle, out float arc_end_angle,
    out float arc_radius,
    out float arc_start_x, out float arc_start_y,
    out float arc_end_x, out float arc_end_y
)
	{
		float c1   = p2x * p1y - p1x * p2y;
		float a1   = p2y - p1y;
		float b1   = p1x - p2x;
		float c2   = p4x * p3y - p3x * p4y;
		float a2   = p4y - p3y;
		float b2   = p3x - p4x;
		
		if ((a1 * b2) == (a2 * b1)) { // parallel or coincident lines
			return;
		}
		
		float d1, d2;
		float mpx, mpy;
		mpx = (p3x + p4x) / 2.;
		mpy = (p3y + p4y) / 2.;
		d1 = line_to_point(a1, b1, c1, mpx, mpy); // find distance p1p2 to p3
		if (d1 == 0.) {
			return;
		}
		mpx = (p1x + p2x) / 2.;
		mpy = (p1y + p2y) / 2.;
		d2 = line_to_point(a2, b2, c2, mpx, mpy); // find distance p2p4 to p2
		if (d2 == 0.) {
			return;
		}
		
		float c1p, c2p, d;
		float rr = r;
		if (d1 <= 0.0) {
			rr = -rr;
		}
		c1p = c1 - rr * sqrt((a1 * a1) + (b1 * b1)); // Line parrallel l1 at d
		rr = r;
		if (d2 <= 0.0) {
			rr = -rr;
		}
		c2p = c2 - rr * sqrt((a2 * a2) + (b2 *b2));
		d = (a1 * b2) - (a2 * b1);
		
		float pcx = (c2p * b1 - c1p * b2) / d;
		float pcy = (c1p * a2 - c2p * a1) / d;
		float pax = 0.;
		float pay = 0.;
		float pbx = 0.;
		float pby = 0.;
		float dp, cp;
		
		dp = (a1 * a1) + (b1 * b1);
		if (dp != 0.0) {
			cp = a1 * pcy - b1 * pcx;
			pax = (-a1 * c1 - b1 * cp) / dp;
			pay = (a1 * cp - b1 * c1) / dp;
		}
		dp = (a2 * a2) + (b2 * b2);
		if (dp != 0.0) {
			cp = a2 * pcy - b2 * pcx;
			pbx = (-a2 * c2 - b2 * cp) / dp;
			pby = (a2 * cp - b2 * c2) / dp; 
		}
		
		float gv1x = pax - pcx;
		float gv1y = pay - pcy;
		float gv2x = pbx - pcx;
		float gv2y = pby - pcy;
		
		float arc_start = atan(gv1y, gv1x);
		float arc_angle = 0.0;
		float dd = sqrt(((gv1x * gv1x) + (gv1y * gv1y)) * ((gv2x * gv2x) + (gv2y * gv2y)));
		if (dd != 0.0) {
			arc_angle = (acos((gv1x * gv2x + gv1y * gv2y) / dd)); 
		}
		float cross_product = (gv1x * gv2y - gv2x * gv1y);
		if (cross_product < 0.0) {
			arc_start -= arc_angle;
		}
		
		float arc1 = arc_start;
		float arc2 = arc_start + arc_angle;
		if (cross_product < 0.0) {
			arc1 = arc_start + arc_angle;
			arc2 = arc_start;
		}
		
		arc_center_x = pcx;
		arc_center_y = pcy;
		arc_start_angle = arc1;
		arc_end_angle = arc2;
		arc_radius = r;
		arc_start_x = arc_center_x + arc_radius * cos(arc_start_angle);
		arc_start_y = arc_center_y + arc_radius * sin(arc_start_angle);
		arc_end_x = arc_center_x + arc_radius * cos(arc_end_angle);
		arc_end_y = arc_center_y + arc_radius * sin(arc_end_angle);
	}


float circular_fillet(float x, float a, float b, float r) {
	float epsilon = 0.00001;
	float min_a = 0.0 + epsilon;
	float max_a = 1.0 - epsilon;
	float max_b = 1.0 - epsilon;
	float min_b = 0.0 + epsilon;
	a = max(min_a, min(max_a, a));
	b = max(min_b, min(max_b, b));
	
	float arc_center_x, arc_center_y;
	float arc_start_angle, arc_end_angle;
	float arc_radius;
	float arc_start_x, arc_start_y;
	float arc_end_x, arc_end_y;

	compute_fillet_parameters(0., 0., a, b, a, b, 1., 1., r, 
                              arc_center_x, arc_center_y, 
                              arc_start_angle, arc_end_angle, 
                              arc_radius, 
                              arc_start_x, arc_start_y, 
                              arc_end_x, arc_end_y);
	float t = 0.;
	float y = 0.;
	x = max(0., min(1., x));
	
	if (x <= arc_start_x) {
		t = x / arc_start_x;
		y = t * arc_start_y;
	} else if (x >= arc_end_x) {
		t = (x - arc_end_x) / (1. - arc_end_x);
		y = arc_end_y + t * (1. - arc_end_y);
	} else {
		if (x >= arc_center_x){
			y = arc_center_y - sqrt((arc_radius * arc_radius) - (( x - arc_center_x) * ( x - arc_center_x)));
		} else {
			y = arc_center_y + sqrt((arc_radius * arc_radius) - (( x - arc_center_x) * ( x - arc_center_x)));
		}
	} 
	return y;
}
	

float plot(vec2 uv, float percent) {
	return smoothstep(percent - 0.01, percent, uv.y) - smoothstep(percent, percent + 0.01, uv.y);
}


void fragment() {
	vec2 uv = vec2(1. - UV.x, UV.y);
	float y = circular_fillet(uv.x, A, B, R);	
	vec3 color = vec3(1.0 - y);
	float percent = plot(uv, y);
	color = (1.0 - percent) * color + percent * vec3(0., 1., 0.0);
	COLOR = vec4(color, 1.);
}