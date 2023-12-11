D_R je v souboru `pimax_1024.dat`, je to kvantová účinnost kamery.

D_F získat součtem pro všechny fluorescenční čáry:
D_F = \sum_i T_i C_i A_{32i}.

Ve vzorci pro n nahradit M_F/E_F výrazem \frac{\beta M_F}{\ln(1 + \beta E_F}.
(To celé nazvěme \alpha.)
Saturační parametr \beta získat fitem dat pro saturaci (intenzita-vln. délka)
vztahem s neznámými parametry \alpha a \beta:
M = (\alpha/\beta) \ln(1 + \beta E_F).

Počáteční fit je možno provést nahrazením výše uvedeného vztahu vztahem:
M = \frac{a E}{1 + bE} (vyjádřit 1/M).
Potom a \approx \alpha a b \approx \beta/2.

B = A * lambda**3 / (8 * pi * planck) * g3/g1.
Pro nás je g3/g1 = 3/5. (J3 = 1, J1 = 2, g = 2J+1)

Zkontrolovat homogennost saturačního parametru \beta v prostoru
a šířky excitační čáry.
