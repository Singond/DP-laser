settings.outformat = "pdf";
// size(360pt);
unitsize(1pt);
defaultpen(fontsize(10));

pen circuitpen = gray(0.3) + 1;

real hgap = 10;
path electrodepath = box((-40,0), (40,2));
fill(shift(hgap * N) * electrodepath, circuitpen);
fill(shift(hgap * S) * reflect(E, W) * electrodepath, circuitpen);

pen laserpen = palered;
pen efishpen = lightblue;

real conelen = 120;
real conehwidth = 12;
path lasercone = (0,0) -- (-conelen, conehwidth)
	-- (-conelen, -conehwidth) -- cycle;
path lasercone = lasercone -- reflect(S,N) * lasercone -- cycle;
fill(lasercone, laserpen);
arrow("laser $\omega$", (-120,0), 2W, lightred);

path efishcone = scale(1,0.5) * lasercone;
path knife = (-40,-40) -- (-40,40);
path e1 = firstcut(efishcone, knife).before;
path e2 = lastcut(efishcone, knife).after;
efishcone = e1 -- e2 -- cycle;
axialshade(efishcone,
	laserpen, (-80,0),
	efishpen, (40,0));
label("$2\omega$", (130,0), efishpen);

pair srcpos = (0,40);
draw(srcpos + (0,-10) -- (0, hgap + 2), circuitpen);
draw(circle(srcpos, 10), circuitpen);
path sine = (-pi,0){NE} .. {E}(-pi/2,1){E} .. {SE}(0,0){SE}
    .. {E}(pi/2,-1){E} .. {NE}(pi,0);
draw(shift(srcpos) * scale(2, 3) * sine, circuitpen);

pair groundpos = (0,-40);
path[] ground = (-10,0) -- (10,0) ^^ (-6,-5) -- (6,-5) ^^ (-2,-10) -- (2,-10);
draw((0,-hgap - 1) -- groundpos, circuitpen);
draw(shift(groundpos) * ground, circuitpen);
