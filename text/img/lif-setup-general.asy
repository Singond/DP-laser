import instruments;

settings.outformat = "pdf";
size(360pt);

defaultpen(fontsize(10));

picture bottom;
picture top;

pen laser = heavyred + 5;

// Source
instr(shift(140,100) * box((-40,-20), (40,20)));
label("laser", (140,100));

beam((0,100) -- (100,100), laser);
optics(rightprism((0,100), angle=-45));

pair fresnelpos = (10,50);
path rhombbase = (-5,0) -- (5,0) -- (-5,25) -- (-15,25) -- cycle;
path rhomb1 = shift(fresnelpos) * rhombbase;
path rhomb2 = shift(fresnelpos) * reflect(E,W) * rhombbase;
optics(rhomb1);
optics(rhomb2);

pair prism2pos = (0,0);
beam(
	(0,100) -- fresnelpos + (-10,25)
		-- fresnelpos + (-10,25) -- fresnelpos -- fresnelpos + (-10,-25)
		-- fresnelpos + (-10,-25) -- prism2pos,
	laser);
unfill(beams, rightprism((0,100), angle=135));
optics(rightprism(prism2pos, angle=45));
label(minipage("\centering{Fresnelovy\\hranoly}", 40), fresnelpos, 3*E);

pair lens1pos = (40,0);
beam(prism2pos -- lens1pos, laser);
unfill(beams, rightprism(prism2pos, angle=225));
optics(plate((lens1pos)));
label(minipage("\centering{válcová\\rozptylka}"), lens1pos + 10down, S);

pair lens2pos = (80,0);
beam(lens1pos -- lens2pos, laser);
optics(convexlens((lens2pos)));
label(minipage("\centering{spojka}"), lens2pos, 5N);

pair lens3pos = (120,0);
beam(lens2pos -- lens3pos, laser);
optics(concavelens((lens3pos)));
label(minipage("\centering{válcová\\rozptylka}"), lens3pos + 10down, S);

pair detpos = (250,0);
beam(lens3pos -- detpos, laser);
instr(shift(detpos) * box((-20,-10), (20,10)));
label("měřič", detpos);

pair flamepos = (180,0);
radialshade(circle(flamepos, 10), orange, flamepos, 0, paleyellow, flamepos, 8);
label("plazma", flamepos, 5N);

pair camerapos = (180,-60);
transform cameratform = shift(camerapos) * rotate(90);
camera(cameratform);
label("ICCD", camerapos + 15right + 30down, E);

axialshade(cameratform * cameracone(50, 15),
	paleblue, cameratform * (0,0),
	white, cameratform * (50,0));

add(top, instr);
add(bottom);
add(beams);
add(optics);
add(top);
