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

wavelen_base;

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
