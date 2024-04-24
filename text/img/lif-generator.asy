import roundedpath;
usepackage("siunitx");
usepackage("mhchem");

settings.outformat = "pdf";
size(360pt);
defaultpen(fontsize(10));

picture pipes;
picture instr;

pen hosepen = gray + 3 + squarecap + opacity(0.7);

void hose(picture pic=pipes, path g, pen p=hosepen) {
	draw(pic, g, p);
}

void pitcher(picture pic=instr, transform T=identity,
		pen fillpen=invisible) {
	fillpen = opacity(0.5) + fillpen;
	T = T * scale(2.5);
	path pbottom = (-1,0) -- (-1,-1.5) -- (1,-1.5) -- (1,0);
	path ptop = (1,0) -- (1,1.5) -- (-1.35,1.5) -- (-1.0,1.0) -- (-1,0);
	pbottom = roundedpath(pbottom, 0.2);
	fill(pic, T * (pbottom -- cycle), fillpen);
	draw(pic, T * (pbottom -- ptop -- cycle), Cyan + 1);
}

pitcher(shift(-50,10), deepgreen);
pitcher(shift(-50,0), deepcyan);
pitcher(shift(-50,-10), lightolive);
label("$\ce{Se} + \ce{HCl}$", (-53,10), W);
label("$\ce{NaBH4} + \ce{KOH}$", (-53,0), W);
label("odpad", (-53,-10), W);

transform pumppos = shift(-30,0);
pair pumpin1 = (-4,5);
pair pumpin2 = (-4,0);
pair pumpin3 = (-4,-5);
pair pumpout1 = (4,5);
pair pumpout2 = (4,0);
pair pumpout3 = (4,-5);
draw(pumppos * box((-4,-8), (4,8)));
fill(instr, circle(pumppos * (0,5), 1.5), mediumgray);
fill(instr, circle(pumppos * (0,0), 1.5), mediumgray);
fill(instr, circle(pumppos * (0,-5), 1.5), mediumgray);
path pumparrow = scale(1.5) * polygon(3);
fill(instr, pumppos * shift(0, 5) * rotate(-90) * pumparrow, black);
fill(instr, pumppos * shift(0, 0) * rotate(-90) * pumparrow, black);
fill(instr, pumppos * shift(0,-5) * rotate(+90) * pumparrow, black);
hose(pumppos * (pumpin1 -- pumpout1));
hose(pumppos * (pumpin2 -- pumpout2));
hose(pumppos * (pumpin3 -- pumpout3));
label(minipage("\centering peristaltické\\čerpadlo", 80), pumppos * (0,-13));

hose((-50, 8){N} .. (-45, 15){E} .. {E}pumppos*pumpin1);
hose((-50, -2){N} .. (-45,  5){E} .. {E}pumppos*pumpin2);
hose((-50,-12){N} .. (-45,-5){E} .. {E}pumppos*pumpin3);

pair pumpjoin = (8,2.5);
hose((pumppos * pumpout1){E} .. {S}(pumppos * pumpjoin));
hose((pumppos * pumpout2){E} .. {N}(pumppos * pumpjoin));
fill(circle(pumppos * pumpjoin, 1), hosepen + opacity(1));

hose((-20,15){E} .. tension 0.8 .. {S}(-1,2.5));
fill(circle((-1,2.5), 1), hosepen + opacity(1));
arrow("\ce{Ar}", (-20,15), W);

hose((pumppos * pumpjoin) -- (8.5,2.5) .. (9,3){N}
	.. tension 2.5 .. (10,13) .. {S}(11,11));
arrow("\ce{H2Se}", (-5,5), W);
hose((pumppos * pumpout3) -- (8,-5){E} .. {N}(11,-2) -- (11,5));
arrow("kapalná složka", (-15,-8), E);

path separatortop = (14,6) -- (14,12){N} .. (10,16) .. {S}(6,12) -- (6,6);
path separatorbot = (6,6) -- (6,4) -- (14,4) -- (14,6);
separatorbot = roundedpath(separatorbot, 0.2);
draw(separatorbot -- separatortop -- cycle, Cyan + 1);
fill(separatorbot -- (14,6) -- (6,6) -- cycle, lightolive + opacity(0.5));
label("separátor", (15,10), E);
arrow("$\ce{H2Se} + \ce{H_2} + \ce{Ar}$", (-5,23), E + 0.1*N);

pair atompos = (-15,25);
hose((10,15){N}..{N}atompos);
axialshade(box(atompos, atompos + (-1,15)),
	palecyan + opacity(0.5), (atompos),
	deepcyan + opacity(0.5), atompos - (1.5,0));
axialshade(box(atompos, atompos + (1,15)),
	palecyan + opacity(0.5), (atompos),
	deepcyan + opacity(0.5), atompos + (1.5,0));
fill(box(atompos + (1,5), atompos + (8,6)), deepcyan + opacity(0.3));
label("atomizátor", atompos + (-1,7.5), W);
arrow("\ce{H2}", atompos + (8,5.5), E);

path flame = (0,0){E} .. {N}(1,0.5) .. (0,7);
flame = flame -- reverse(reflect(down, up) * flame) -- cycle;
fill(shift(atompos + (0,15)) * scale(1,1.4) * flame, yellow);
radialshade(shift(atompos + (0,15)) * flame,
	orange, atompos + (0,16), 0.2,
	yellow, atompos + (0,16), 5);
label(minipage("\centering difuzní\\plamen"), atompos + (0,28));
label("\ce{Se}", atompos + (1.5,21), E);

pen laser = deepmagenta + 2 + opacity(0.3);
draw(atompos + (-35,17) -- atompos + (20,17), laser);
label("laser (\SI[locale=DE]{196.03}{\nano\metre})", atompos + (-10,19), W);

add(pipes);
add(instr);
