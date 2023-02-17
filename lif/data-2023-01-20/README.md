LIF 2023-01-20
==============

vzorek: 10 ppb Se v 1M HCl
borohydrid: 0.5% BH4 v 0.4% KOH
prutoky: 700 sccm Ar za separator + 75 sccm Ar generatorem (nastaveno 72 sccm),
300 sccm H2 za separator (nastaveno 270 sccm), z generovani udajne vznika 11 sccm H2

na kamere je misto filtru dvojice kremennych sklicek



Spectral scans
--------------
Wavelength is varied by tuning the laser.
Initially without spatial filter, added with `scan9`.

Starting from `scan13`, the powermeters are swapped.
The higher-resolution powermeter is now right behind the splitter,
the other one is unused.
If the intensity of the reflected beam is needed, it has to be estimated
based on the correspondence between the powermeters in previous datasets.

```
name    from[nm]  step[nm]  to[nm]  amp  notes
scan1   195.8     0.005     196.2   50
scan2   195.95    0.001     196.2   50   Error, ran out of selenium during measurement
scan3   195.95    0.001     196.2   50   Detected some extra minor peaks, repeating
scan4   195.95    0.001     196.2   50
scan5   195.95    0.001     196.2   40
scan6   195.95    0.001     196.2   30
scan7   195.95    0.001     196.2   20
scan8   195.95    0.001     196.2   13
scan9   195.95    0.001     196.2   50   Added spatial filter.
scan10  195.95    0.001     196.2   40
scan11  195.95    0.001     196.2   30
scan12  195.95    0.001     196.2   24
scan13  195.95    0.001     196.2   15   Swapped powermeters.
```


Saturace, doba zivota
---------------------

Laser na 196.032 nm
saturace1
saturace1
selenblank - po dvacatem obr prepnuto z 10 ppb na blank, po obr. 100 prepnuto zpet na 10 ppb Se.
decay1 - gate width 2 ns, krok 1 ns , amp50
decay2 - gate width 2 ns, krok 500 ps
obr1: plamen (bez laseru) s akumulaci 10000
stred: v ose plamene jde imbusacek
caliper4mm, 3mm, 2mm

laserovy svazek sel 2-6 mm nad vrchem trubicky


Mereni prostoroveho rozlozeni signalu nad plamenem
--------------------------------------------------

vyska:
pred atomizatorem je jeste jedna svisla clonka, za ni prochazi uzky svisly svazek cca 3mm*1mm
za atomizatorem neni cerny plech, takze je trochu svetlejsi dark
prutoky plynu: 700 sccm Ar, 300 sccm H2
amp50
pocatecni podminky (0mm): laser zacina 1 mm nad trubickou a konci 4 mm nad trubickou
vyska [mm] / snimky od / do
0	1	6
1	8	13
2	17	23
3	27	29
4	32	35
5	37	39
6	42	47
7	49	53
8	56	60

vyska2:
vyska [mm] /  snimky od / do
0	1	5
1	8	13
2	17	23
3	26	31
4	34	38
5	41	45
6	48	53
7	56	59
8	62	65
9	69	72
10	75	79
11	82	86
12	90	93
13	96	101
14	104	112

vyska3:
zmena prutoku plynu: 100+75 sccm Ar, 150 sccm H2
vyska [mm] /  snimky od / do
0	1	8
1	11	18
2	22	28
3	32	38
4	42	47
5	51	63

vyska4:
zmena prutoku plynu: 100+75 sccm Ar, 50 sccm H2 (nastaveno 45)
vyska [mm] /  snimky od / do
0	1	7
1	10	18
2	21	29
3	33	40


Rayleigh
--------

odstranena sterbinka pro prostorove rozlozeni
odsunut atomizator
odebran filtr (tj sklenena sklicka) z kamery

rayleigh1 - pravdepodobne svisla polarizace, amp50
rayleigh2 - amp30
rayleigh3 - amp20
rayleigh4 - amp10 - energie jsou ale pod moznostmi meraku

rayleigh_cas - 100:0.5:130 ns, 2ns expozice, amp50

rayleigh_zafresnelem - pokus o horizontalni polarizaci, ale vetsina laseru se absorbovala v fresnelove hranolu

