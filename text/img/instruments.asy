picture instr;
picture beams;
picture optics;

void beam(picture pic=beams, path g, pen p) {
	real w = linewidth(p);
	int nlayers = 8;
	pen beampen = p + opacity(0.15) + squarecap;
	for (int i = 0; i < nlayers; ++i) {
		draw(pic, g, beampen + linewidth(w * (i + 1) / nlayers));
	}
}

void instr(picture pic=instr, path g) {
	path diag = min(g) -- max(g);
	pair c = midpoint(diag);
	path axis = reflect(c, c + up) * diag;
	axialshade(pic, g,
		gray(0.5), point(axis, 0),
		gray(0.9), point(axis, 1));
	draw(pic, g, black + 0.3);
}

void optics(picture pic=optics, path g) {
	path diag = min(g) -- max(g);
	pair c = midpoint(diag);
	path axis = reflect(c, c + up) * diag;
	axialshade(pic, g,
		mediumcyan + opacity(0.6), point(axis, 0),
		lightcyan + opacity(0.6), point(axis, 1));
}

path convexlens(pair pos, real angle=0, real scale=10) {
	path face = (0.1,-1) .. (0.25,0) .. (0.1,1);
	path shape = face -- reflect(down, up) * reverse(face) -- cycle;
	return shift(pos) * scale(scale) * rotate(angle) * shape;
}

path concavelens(pair pos, real angle=0, real scale=10) {
	path face = (0.25,-1) .. (0.1,0) .. (0.25,1);
	path shape = face -- reflect(down, up) * reverse(face) -- cycle;
	return shift(pos) * scale(scale) * rotate(angle) * shape;
}

path plate(pair pos, real angle=0, real scale=10, bool face=false) {
	path shape = box((-0.2,-1), (0.2,1));
	if (face) {
		shape = shift(-0.2,0) * shape;
	}
	return shift(pos) * scale(scale) * rotate(angle) * shape;
}

path rightprism(pair pos, real angle=0, real scale=10) {
	path shape = (0,-1) -- (1,0) -- (0,1) -- cycle;
	return shift(pos) * scale(scale) * rotate(angle) * shape;
}

void camera(picture pic=instr, transform T) {
	transform T = T * scale(10);
	path body = box((-5,-1.2), (-1,1.2));
	path cone = (-1,0.5){NE} .. {E}(0,1)
		-- (0,-1){W} .. {NW}(-1,-0.5) -- cycle;
	instr(pic, T * body);
	axialshade(pic, T * cone,
		gray(0.2), T * S,
		gray(0.8), T * N);
	draw(pic, T * cone, black + 0.3);
}

path cameracone(real length = 50, real angle = 20) {
	path axis = (0,0) -- (length / Cos(angle), 0);
	path edge = shift(0,10) * rotate(angle) * axis;
	return edge -- reflect(E, W) * reverse(edge) -- cycle;
}
