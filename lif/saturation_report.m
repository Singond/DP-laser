## Saturace LIF

##
# <latex>
# \lstset{
# 	basicstyle=\small\ttfamily,
# 	frame=none,
# 	literate=
# 		{á}{{\'a}}1 {é}{{\'e}}1 {í}{{\'i}}1 {ó}{{\'o}}1 {ú}{{\'u}}1
# 		{Á}{{\'A}}1 {É}{{\'E}}1 {Í}{{\'I}}1 {Ó}{{\'O}}1 {Ú}{{\'U}}1
# 		{ý}{{\'y}}1 {ů}{{\r u}}1 {Ý}{{\'Y}}1 {Ů}{{\r U}}1
# 		{č}{{\v c}}1 {ď}{{\v d}}1 {ě}{{\v e}}1 {ň}{{\v n}}1 {ř}{{\v r}}1
# 		{š}{{\v s}}1 {ť}{{\v t}}1 {ž}{{\v z}}1
# 		{Č}{{\v C}}1 {Ď}{{\v D}}1 {Ē}{{\v E}}1 {Ň}{{\v N}}1 {Ř}{{\v R}}1
# 		{Š}{{\v S}}1 {Ť}{{\v T}}1 {Ž}{{\v Z}}1
# }
# </latex>

##
# Byla provedena dvě měření závislosti intenzity LIF na energii laseru,
# každá pro jiný rozsah energií laseru.
saturation_base;

##
# Příklad snímku z kamery je zde:
figure();
imshow(saturation(1).img(:,:,24), [0 9000],
	"colormap", ocean);
title("Snímek LIF");

##
# Energie laseru byla při každém měření plynyle měněna v požadovaném rozsahu.
# Některé hodnoty uvnitř druhé sady měření (|saturation2|) byly mimo rozsah
# detektoru, tyto nebyly uvažovány.
figure();
Escale = 1e6;
plot(
	saturation(1).pwrdata{1}(:,1),
	saturation(1).pwrdata{1}(:,2) * Escale,
	"-", "displayname", "saturation1",
	saturation(2).pwrdata{1}(:,1),
	saturation(2).pwrdata{1}(:,2) * Escale,
	"-", "displayname", "saturation2");
title("Energie pulzu v průběhu měření");
xlim([0 max(saturation(2).pwrdata{1}(:,1))]);
xlabel("čas t [s]");
ylabel("energie laserového pulzu E [\\mu{}J]");

##
# Zaznamenaná energie byla pro každý snímek zprůměrována:
figure();
plot(
	saturation(1).E * Escale, "d",
	saturation(2).E * Escale, "o");
title("Průměrná energie pulzu v jednotlivých snímcích");
xlabel("snímek");
ylabel("energie laserového pulzu E [\\mu{}J]");

## Bez rozlišení
# Závislost intenzity integrované přes celý snímek
saturation_overall_show

## Horizontální rozlišení
# Intenzity v jednotlivých sloupcích byly sečteny
# a další vyhodnocení bylo tedy rozlišené jen v ose x.
warning off;
saturation_x_show;

## Plné rozlišení
# Energie laseru byla na základě Rayleighova rozptylu rozdělena
# po svislé ose y.
saturation_full;
figure("name", "Svislé rozdělení energie laseru");
clf;
hold on;
for k = 1:8:length(saturation(1).E)/2
	plot(saturation(1).ypos, saturation(1).Ly(:,k), "d",
		"displayname", sprintf("%g J", saturation(1).E(k)));
end
hold off;
xlabel("svislá poloha y [px]");
ylabel("intenzita laseru \\epsilon [\\mu{}J]");
legend show;
