import instruments;

settings.outformat = "pdf";
size(360pt);

defaultpen(fontsize(10));

picture bottom;
picture top;

pen laser = heavyred + 5;

// Source
instr(shift(-60,100) * box((-40,-20), (40,20)));
label("laser", (-60,100));

beam((-20,100) -- (0,100), laser);
optics(rightprism((0,100), scale=12, angle=-135));

pair filterpos = (0,50);
optics(convexlens(shift(0,15) * filterpos, angle=90));
diaphragm(shift(filterpos) * rotate(90));
optics(convexlens(shift(0,-15) * filterpos, angle=90));
path filterwedge = (0.5,0) -- (2.5,-15) -- (4,-15) --
	(4,15) -- (2.5,15) -- cycle;
draw(shift(filterpos + (15,0)) * ((0,20) -- (5,20) -- (5,-20) -- (0,-20)));
label(minipage("\centering{prostorový\\filtr}", 40), filterpos, 7*E);

pair splitterpos = (0,0);
optics(plate(splitterpos, angle=45, face=true));
label(minipage("\centering{dělič svazku\\(křemenné sklo)}", 100),
	splitterpos, 3*W);

pair det1pos = (0,-90);
instr(shift(det1pos) * box((-10,-20), (10,20)));
label(Label("měřič", Rotate(N)), det1pos);

beam((0,100) -- det1pos, laser);
unfill(beams, rightprism((0,100), angle=45));
unfill(beams, shift(filterpos) * filterwedge);
unfill(beams, shift(filterpos) * reflect(N, S) * filterwedge);

laser = laser + 2;

pair dia1pos = (50,0);
beam(splitterpos -- dia1pos, laser);
diaphragm(shift(dia1pos));
label(minipage("\centering{irisová\\clona}"), dia1pos + 10down, S);

pair dia2pos = (100,0);
beam(dia1pos -- dia2pos, laser);
diaphragm(shift(dia2pos));
label(minipage("\centering{(svislá\\štěrbina)}"), dia2pos + 10down, S);

pair det2pos = (250,0);
beam(dia2pos -- det2pos, laser);
instr(shift(det2pos) * box((-20,-10), (20,10)));
label("měřič", det2pos);

pair flamepos = (180,0);
radialshade(circle(flamepos, 10), orange, flamepos, 0, paleyellow, flamepos, 8);
label(minipage("\centering{atomizátor\\s~plamenem}"), flamepos, 5N);

pair camerapos = (180,-60);
transform cameratform = shift(camerapos) * rotate(90);
camera(cameratform);
label(Label("ICCD", Rotate(N)), camerapos + 30down);

axialshade(cameratform * cameracone(50, 15),
	paleblue, cameratform * (0,0),
	white, cameratform * (50,0));

add(top, instr);
add(bottom);
add(beams);
add(optics);
add(top);
