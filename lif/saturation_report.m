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
# Energie laseru byla při každém měření plynyle měněna v požadovaném rozsahu.
# Některé hodnoty uvnitř druhé sady měření (|saturation2|) byly mimo rozsah
# detektoru, tyto nebyly uvažovány.
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
plot(
	saturation(1).E * Escale, "d",
	saturation(2).E * Escale, "o");
title("Energie pulzu v jednotlivých snímcích");
xlabel("snímek");
ylabel("energie laserového pulzu E [\\mu{}J]");

##
# Závislost intenzity integrované přes celý snímek
saturation_overall_show
