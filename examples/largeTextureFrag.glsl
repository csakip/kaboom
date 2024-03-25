uniform vec2 u_offset;
uniform float u_scale;

// return true if the number is odd
bool odd(float n) {
	return mod(floor(n), 2.0) == 1.0;
}

// return the multiple of delta closest to value
vec2 closestMul(vec2 delta, vec2 value) {
	return delta * floor((value / delta) + 0.5);
}

// return the distance of value to the closest multiple of delta
vec2 mulDist(vec2 delta, vec2 value) {
	return abs(value - closestMul(delta, value));
}

// align the given point to a pixel center if thickness is odd,
// otherwise align the point to a crossing point between pixels
vec2 alignPixel(vec2 point, float thickness) {
	if(odd(thickness))
		return floor(point) + 0.5;
	else
		return floor(point + 0.5);
}

vec4 drawGrid(
	vec2 position,
	vec2 origin,
	vec2 gridSize,
	float thickness,
	vec4 bgColor,
	vec4 lineColor
) {
    // align the origin to the closest pixel center
	origin = alignPixel(origin, thickness);

	vec2 relP = position - origin;

	// vec2 mul = closestMul(gridSize, relP);

  // pixel distance
	vec2 dist = mulDist(gridSize, relP);

	if(min(dist.x, dist.y) <= thickness * 0.5) {
		return lineColor;
	}

	return bgColor;
}

vec4 frag(vec2 pos, vec2 uv, vec4 color, sampler2D tex) {
	// gl_FragCoord is in screen space

	// origin of the grid (crossing point of the axes)
	// vec2 origin = vec2(0.0, 0.0);
	// thickness for the main grid lines
	float thickness = 1.0;	
	// size of the grid
	vec2 gridSize = vec2(50.0 * u_scale); 
	// color of the main grid lines
	vec4 lineColor = vec4(0.4, 0.4, 0.4, 1.0);

	return drawGrid(gl_FragCoord.xy, vec2(u_offset.x, -u_offset.y), gridSize, thickness, texture2D(tex, uv), lineColor);

	// if (int(mod(gl_FragCoord.x + u_offset.x, u_pitch)) == 0 ||
	// 		int(mod(gl_FragCoord.y - u_offset.y, u_pitch)) == 0) {
	// 		return vec4(texture2D(tex, uv).rgb, 0.7);
	// } else {
	// 		return texture2D(tex, uv);
	// }
}