import instruments;

settings.outformat = "pdf";
size(360pt);

defaultpen(fontsize(10));

picture bottom;
picture top;

// Source
instr(box((100,-20), (180,20)));
label("laser", (140,0));

// Powermeter
instr(shift(-100,0) * box((-5,-5), (5,5)));
label("fotodioda", (-100,5), 2N);

// Main beam
pen laserpen = red + 5;
beam((-100,0) -- (100,0), laserpen);
label("$\omega$", (55,0), 1.5S, laserpen);
optics(convexlens((70,0), angle=0, scale=10));
label(minipage("\centering zaostřovací\\spojka", 40), (70,10), N);

// Discharge
pair dischargepos = (20,0);
path electrodepath = box((-15,-2), (15,2));
real hgap = 6;
instr(shift((hgap + 1) * N) * shift(dischargepos) * electrodepath);
instr(shift((hgap + 1) * S) * shift(dischargepos) * electrodepath);
path hplasmapath = box((-8,-hgap), (8,0));
axialshade(top, shift(dischargepos) * hplasmapath,
	white , dischargepos + hgap * S,
	lightmagenta, dischargepos);
axialshade(top, shift(dischargepos) * reflect(E, W) * hplasmapath,
	white, dischargepos + hgap * N,
	lightmagenta, dischargepos);
label(minipage("\centering výbojový\\prostor", 40), dischargepos, 5N);

// First mirror
pair mirror1 = (-60,0);
path mirror1path = plate(mirror1, angle=-45);
label(minipage("\centering dichroické\\zrcadlo", 40), mirror1, 5N);

// Collimating lens
pair lens2 = point(dischargepos -- mirror1, 0.6);
optics(convexlens(lens2));
label(minipage("\centering kolimační\\spojka", 40), lens2, 5S);

// EFISH path
picture efish;
pen efishpen = heavyblue + 3;
beam(efish, (mirror1 + 2down) -- (dischargepos + (0,-2)), efishpen);
label("$2\omega$", (mirror1 + 15*S), 1W, efishpen);
optics(mirror1path);


pair mirror2 = shift(mirror1) * rotate(-90) * (100,0);
path mirror2path = plate(mirror2, angle=45, face=true);
beam(efish, mirror1 -- mirror2, efishpen);
optics(mirror2path);
label("zrcadlo", (mirror2), 4W);

pair lens3 = shift(mirror2) * (80,0);
beam(efish, mirror2 -- lens3, efishpen);
optics(convexlens(lens3));
label(minipage("\centering zaostřovací\\spojka"), lens3, 5N);

pair monoch = mirror2 + (200,-10);
transform monochpos = shift(monoch);
instr(monochpos * box((-40,-20), (40,20)));
label("monochromátor", monochpos * (0,0));
beam(efish, lens3 -- monochpos * (-40,10), efishpen);

transform pmtpos = monochpos * shift(-80,-10);
pair pmt = pmtpos * (0,0);
beam(efish, monochpos * (-40,-10) -- pmt, efishpen);
instr(pmtpos * scale(10,5) * box((-1,-1),(1,1)));
label("fotonásobič", pmt, 3S);

unfill(efish, mirror1path);
unfill(efish, mirror2path);
add(beams, efish);

add(top, instr);
add(bottom);
add(beams);
add(optics);
add(top);
