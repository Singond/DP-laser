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

if (!exist("wavelen1", "var"))
	wavelen;
end

## První sada (4. 8. 2022)
# Vlnová délka je nastavována na hodnoty 204:0.01:204.3 nm.
# (Pozor, data mají o snímek víc. Není jasné, jaké vlnové délce přísluší.
# Nejjasnější je 14. snímek

wl1 = 204:0.01:204.3;
printf("Maximum at wavelength: %.2f nm\n", wl1(14));

imshow(wavelen1(1).img(160:end,140:740,14), [0 5000]);
colorbar southoutside;

##
# To samé, tentokrát s vlnovými délkami 204.05:0.005:204.25 nm.
# Nejjasnější je 17. snímek

wl2 = 204.05:0.01:204.25;
printf("Maximum at wavelength: %.2f nm\n", wl2(17));

imshow(wavelen1(2).img(160:end,140:740,17), []);
colorbar southoutside;

## Druhá sada (9. 1. 2023)
#

if (!exist("wavelen2", "var"))
	wavelen;
end
kmax = 23;
printf("Maximum at wavelength: %.3f nm\n", wl(kmax));

imshow(wavelen2(1).img(:,:,kmax), [0 500]);
colorbar southoutside;
