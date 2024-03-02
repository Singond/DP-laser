import roundedpath;

settings.outformat = "pdf";

picture react;
pen reactpen = gray(0.4) + linewidth(2);
path reacthalf = (100,20) -- (100,60) -- (-100,60) -- (-100,20);
reacthalf = roundedpath(reacthalf, 10);
draw(react, reacthalf, reactpen);
draw(react, reflect(E, W) * reacthalf, reactpen);
path stand = roundedpath((-10,0) -- (-10,-20) -- (10,-20) -- (10,0), 5) -- cycle;
fill(react, shift(70,-60) * stand, reactpen);
fill(react, shift(-70,-60) * stand, reactpen);

picture reactwin;
pair topstart = (0,20);
pair botstart = (0,-20);
pair topend = (60,20);
pair botend = (20,-20);
draw(reactwin, topstart -- topend, reactpen);
draw(reactwin, botstart -- botend + (2,0), reactpen);
path winface = topend + (0,1) -- botend + (0,-1);
fill(reactwin, winface -- shift(6,0) * reverse(winface) -- cycle, palecyan);

add(react, shift(100,0) * reactwin);
add(react, scale(-1,1) * shift(100,0) * reactwin);
label(react, minipage("křemenná\\okénka", 50), (120,-30), SE);

pen barrierpen = palecyan;
path barrier = box((-80,8), (80,12));
fill(react, barrier, barrierpen);
fill(react, reflect(E,W) * barrier, barrierpen);
draw(react, (-90,90) -- (-90,10) -- (-85,10)
    ^^ (-90,10) -- (-90,-10) -- (-85,-10));
label(react, minipage("podložní\\sklíčka", 35), (-90,90), N);

pen circuitpen = gray(0.3) + 1;
pen electrodepen = circuitpen;
path electrode = box((-60,12), (60,16));
fill(react, electrode, electrodepen);
fill(react, reflect(E,W) * electrode, electrodepen);
label(react, "elektrody", (6,24), E);

draw(react, (0,16) -- (0,100), circuitpen);
draw(react, circle((0,110), 10), circuitpen);
label(react, "V", (0,110), circuitpen);

draw(react, (0,120) -- (0,140), circuitpen);
draw(react, circle((0,150), 10), circuitpen);
path sine = (-pi,0){NE} .. {E}(-pi/2,1){E} .. {SE}(0,0){SE}
    .. {E}(pi/2,-1){E} .. {NE}(pi,0);
draw(react, shift(0, 150) * scale(2, 3) * sine, circuitpen);

draw(react, (0,-16) -- (0,-100), circuitpen);
draw(react, circle((0,-110), 10), circuitpen);
label(react, "A", (0,-110), circuitpen);

draw(react, (0,-120) -- (0,-140), circuitpen);
path[] ground = (-10,0) -- (10,0) ^^ (-6,-5) -- (6,-5) ^^ (-2,-10) -- (2,-10);
draw(react, shift(0,-140) * ground, circuitpen);

axialshade(react, box((-60,0), (60,8)), white, 8*N, magenta, 0);
axialshade(react, box((-60,0), (60,-8)), white, 8*S, magenta, 0);
label(react, "výboj", (0,0));

pen shortdashed = linetype(new real[] {2, 2});

pair gasin = (75,0);
pair gasout = (-75,0);
pen gaspen = lightblue + 4;
draw(react, shift(gasin) * circle(0, 4), gaspen);
draw(react, shift(gasout) * circle(0, 4), gaspen);

draw(gasin + (100,40){W} .. {W}gasin + (5,0), gaspen + shortdashed);
add(react);
draw(gasout{W} .. {W}gasout - (100,40), gaspen);
label("$\mathrm{N}_2$", gasin + (135,45), N);
draw(gasout - (110,40) -- gasout - (150,40), gaspen + 1, Arrow(size=10));
draw(gasin + (150,40) -- gasin + (110,40), gaspen + 1, Arrow(size=10));

// path beam = (-200,0) -- (200,0);
// draw(new path[] {shift(4*up) * beam, beam, shift(4*down) * beam},
//     new pen[] {white, red, white});
