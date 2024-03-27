## Excitační profil

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

if (!exist("W", "var") || !isfield(W, "fit"))
	wavelen_main;
end

## Naměřená data
# Energie pulzu byla postupně nastavována na několik hodnot
# a profil změřen pro každou z nich.
# Zde jsou průměrné energie pulzu při každém snímku měření.
# Tyto hodnoty byly pro každý profil zprůměrovány do jediné hodnoty,
# která byla přisouzena všem pulzům.

figure();
hold on;
for w = W(1:5)
	plot(w.E(:,1),...
		"displayname", sprintf("amp %d", w.amp));
end
hold off;
title("Průměrná energie pulzu jednotlivých snímků\nbez prostorového filtru (1. měřič)");
xlabel("snímek");
ylabel("energie E [?]");
legend show;

figure();
hold on;
for w = W(6:end)
	plot(w.E(:,1),...
		"displayname", sprintf("amp %d", w.amp));
end
hold off;
title("Průměrná energie pulzu jednotlivých snímků\ns prostorovým filtrem (1. měřič)");
xlabel("snímek");
ylabel("energie E [?]");
legend show;

## Excitační profil
# Naměřené excitační profily jsou níže.
# Na prvním obrázku jsou profily excitované neupraveným laserovým svazkem
# podělené průměrnou energií pulzu.
# Bohužel se ukázalo, že svislý profil laserového svazku se pro různé
# energie pulzu výrazně liší a tato data proto nejsou věrohodná.

figure();
title("Excitační profil normalizovaný energií pulzu\n(bez prostorového filtru)");
xlabel("vlnová délka \\lambda [nm]");
ylabel("intenzita LIF F [a.u.]");
hold on;
for x = W([1:5])
	plot(x.wl, x.in ./ x.Em,
		"displayname", sprintf("%.3f \\mu{}J", x.Em*1e6));
end
hold off;
xlim([min(x.wl) max(x.wl)]);
legend show;

##
# Proměnlivost svazku jsme se pokusili potlačit použitím prostorového filtru.
# Došlo tím ke snížení celkové energie svazku pronikajícího do plazmatu,
# protože jeho větší část byla odstíněna filtrem, ale profil intenzity byl
# méně náchylný na změnu energie pulzu.
#
# Profily jsou pro snazší porovnání opět vyděleny průměrnou energií pulzu.
# Je vidět, že intenzita LIF odpovídající vyšším energiím pulzu
# je po takovéto normalizaci nižší.
# Tento stav odpovídá očekávání, neboť u vyšších energií je výraznější
# vliv saturace.

figure();
title("Excitační profil normalizovaný energií pulzu\n(s~prostorovým filtrem)");
xlabel("vlnová délka \\lambda [nm]");
ylabel("intenzita LIF F [a.u.]");
hold on;
for x = W([6:end])
	plot(x.wl, x.in ./ x.Em,
		"displayname", sprintf("%.3f \\mu{}J", x.Em*1e6));
end
hold off;
xlim([min(x.wl) max(x.wl)]);
legend show;

##
# Excitační profily bez normalizace jsou níže.

figure();
title("Excitační profil\n(s prostorovým filtrem)");
xlabel("vlnová délka \\lambda [nm]");
ylabel("intenzita LIF F [a.u.]");
hold on;
for x = W([6:end])
	plot(x.wl, x.in,...
		"displayname", sprintf("%.3f \\mu{}J", x.Em*1e6));
end
hold off;
xlim([min(x.wl) max(x.wl)]);
legend show;

##
# Naměřenými daty byl proložen Voigtův profil.
# Detail aproximace je níže spolu s určenými parametry \sigma a \gamma
# Voigtova profilu.

figure();
title("Excitační profil\n(s prostorovým filtrem)");
xlabel("vlnová délka \\lambda [nm]");
ylabel("intenzita LIF F [a.u.]");
hold on;
for x = W([1:5])
	plot_fit_voigt(x.wl, x.in, x.fit, "-",...
		"displayname", sprintf(...
			"%.3f \\mu{}J, \\sigma=%.2g nm, \\gamma=%.2g nm",...
			x.Em*1e6, x.fit.p(1), x.fit.p(2)));
end
hold off;
xlim([196.00 196.07]);
legend show;
