import instruments;

settings.outformat = "pdf";
size(360pt);

defaultpen(fontsize(10));

picture bottom;
picture top;

// Reactor
picture react;
instr(react, box((-24,-5), (24,5)));
instr(react, circle((0,0), 15));
label(react, "reaktor", (0,15), N);
add(bottom, react);

// Source
instr(box((100,-20), (180,20)));
label("laser", (140,0));

// Powermeter
instr(shift(-80,0) * box((-10,-5), (10,5)));
label(minipage("\centering{měřič\\energie}", 35), (-80,5), N);

// Main beam
pen laserpen = heavyred + 5;
beam((-80,0) -- (100,0), laserpen);
label("1064 nm", (45,0),1.5N, laserpen);
optics(convexlens((70,0), angle=0, scale=10));
label("$f = 50\,\mathrm{mm}$", (70,10), N);

// Discharge
radialshade(top, scale(7) * box(SW, NE),
	magenta, (0,0), 0, palemagenta, (0,0), 6);

// Photodiode
transform pos = shift(24,0) * rotate(-50);
beam(pos * ((0,0) -- (30,0)), laserpen + 1);
instr(pos * shift(30,0) * box((-10,-5), (10,5)));
label(top, "fotodioda", pos * (30,0), 5S);

// EFISH path
picture efish;
pen efishpen = heavygreen + 3;
pair mirror1 = (-60,0);
path mirror1path = plate(mirror1, angle=-35);
beam(efish, (mirror1 + 2down) -- (0,-2), efishpen);
label("532 nm", (-38,0), 2S, efishpen);
optics(mirror1path);

pair mirror2 = shift(mirror1) * rotate(-70) * (100,0);
path mirror2path = plate(mirror2, angle=65, face=true);
beam(efish, mirror1 -- mirror2, efishpen);
optics(mirror2path);
pair lens2 = point(mirror1 -- mirror2, 0.4);
optics(convexlens(lens2, angle=-70));
label("$f = 50\,\mathrm{mm}$", lens2, 5E);

pair prism1 = shift(mirror2) * rotate(20) * (70,0);
path prism1path = shift(prism1 + 2down) * scale(10) * polygon(3);
beam(efish, mirror2 -- prism1, efishpen);
optics(prism1path);
label(minipage("\centering{disperzní\\hranol}"), prism1 + 10down, S);

transform pmtpos = shift(prism1) * rotate(-20);
pair pmt = pmtpos * (75,0);
beam(efish, prism1 -- pmt, efishpen);
fill(bottom, pmtpos * box((44,-10), (46,10)), black);
label("irisová clona", pmtpos * (45,12), N);
optics(plate(pmtpos * (55,0), angle=-20));
label("filtr 532 nm", pmtpos * (55,10), 2E);
instr(pmtpos * shift(75,0) * scale(10,5) * box((-1,-1),(1,1)));
label("fotonásobič", shift(15,0) * pmt, E);

picture efish2;
beam(efish2,
	intersectionpoint(prism1path, mirror2 -- prism1)
		-- intersectionpoint(prism1path, prism1 -- pmt),
	efishpen);
clip(efish2, prism1path);

unfill(efish, mirror1path);
unfill(efish, mirror2path);
unfill(efish, prism1path);
add(beams, efish);
add(beams, efish2);

add(top, instr);
add(bottom);
add(beams);
add(optics);
add(top);
