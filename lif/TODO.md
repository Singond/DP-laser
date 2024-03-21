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


Saturace
========
Ani prostorový filtr nepomohl úplně, saturační parametr stále není homogenní.
Podle Rayleigho rozptylu je vidět, že energie laseru není rozdělena stejně
pro různé energie pulzu.
Měření nízkého a vysokého rozsahu energií na sebe nesedí, protože se měnilo
výškové rozložení intenzity laseru – i proto fity nedávají dobré výsledky.
Je ale vidět, že ve vodorovném směru je beta homogenní, přestože se podmínky
v plameni radiálně mění. Z toho je vidět, že beta nezávisí na podmínkách
a lze proto vzít jednu konstatní hodnotu (integrální).
Napsat, že výsledky nejsou pro prostorově rozlišené vyhodnocení vhodné
a saturaci vyhodnotit z integrální intenzity.

Excitační profil
================
(závislost na vlnové délce laseru)

Fitnout Voigtův profil (možno i s pozadím) upravený pro saturaci
(viz Pavlův papír).
Ověřit, jak závisí parametry profilu na prostorové poloze.
Kromě \sigma a \gamma se dívat hlavně na maximum.
\sigma a \gamma můžou hodně lítat, protože jsou korelované
(dvě různé hodnoty mohou vést k velmi podobnému tvaru),
ale maximum by mělo vycházet rozumně.
Používat data s prostorovým filtrem, protože tvary a intenzity
na sebe sedí mnohem lépe.

Použijeme-li saturovaný Voigtův profil, měla by se data shodovat lépe.

Koncentrace
===========
Použít vztah (4) z Pavlova připravovaného článku.

Pro d\sigma / d\Omega použít vztah (49) z Milesova článku o Rayleigho rozptylu
a tabulku 2 tamtéž, kde jsou konstanty.
