prvni efish na novem laseru a fotonasobici
24. 1. 2022
Martina, Pavel, Honza Slaný

novy pikosekundovy laser
novy fotonasobic Photek
DBD v cistem dusiku

fotonasobic: -3900 V
v laserove draze nemame longpass filtr (protoze jsme na nej zapomneli)

osciloskop:
ch1 - napetova sonda Tektronix (*1000)
ch2 - efish signal z fotonasobice
ch3 - proudova sonda CT2
ch4 - fotodioda - nase Thorlabsi


singleshot***.bin - sada 100 singleshotu pri stejnych podminkach, pro overeni reprodukovatelnosti signalu

napeti**.bin: 
postupne jeste pred zapalenim vyboje zvysujeme napeti (stale ve stejnem miste periody), ukladame waveformy s 256 acc
energie laseru 0.900-0.910 mJ (velmi stabilne) (pri nastaene vlndelce meraku 619 nm), vskutecnosti 1.160 mJ na 1064 nm
 - laser na amp 1
napeti_bezlaseru: pred fotonasobicem je stinitko

energie**.bin:
napeti zdroje 2.01 Vpp
zvysovani energie laseru z amp 1 na vetsi amp
571777_01 .. amp 1 ... energie01
02	amp 2 ... energie02
3	3	3
4	4	4
5	5	5
6	8	6
7	8	7

Neukladaly se az potud vsechny kanaly osciloskopu, takze merime vse znova.

adresar 220134b

energie**.bin
mapeti zdroje 2.01 Vpp, vyboj jeste nehori (a myslime si ze dnes jeste nehorel)
zvysovani energie laseru z amp 1 na vetsi amp
256 acc na osciloskopu
571777_01.txt .. amp 1 ... energie01.bin
02	amp 2	02
3	3	3
4	4	4
5	5	5
6	7	6
7	10	7
8	14	8
9	17	9
10	20	10
11	25	11
12	21	12
13	18	13
14	15	14
15	12	15
16	8	16
17	6	17
18	3	18
19	1	19

laser amp 15

napeti**.bin
stala energie laseru - laser amp 15 - 3.920-3.940 mJ ... 571777_20.txt (jeden dlouhy soubor)
napeti na zdroji Vpp ... soubor napeti**.bin:
2.01	1
1.81	2
1.61	3
1.41	4
1.21	5
1.01	6
0.81	7
0.61	8
0.41	9
0.21	10
0.01	11
0.31	12
0.51	13
0.71	14
0.91	15
1.11	16
1.31	17
1.51	18
1.71	19
1.91	20
2.11	21 % nehori
2.31	22 % nehori
2.51	23 % hori vyboj, pekne po cele plose 
2.71	24 % hori vyboj, pekne po cele plose 

prehled_po_n23.bin - tvar napeti a proudu po mereni 23 (pri napajecim napeti 2.51 Vpp)

napeti zvednuto na 2.71 Vpp


prubeh signalu behem periody:
energie laseru: 571777_21.txt (jedno dlouhe mereni) - 3.920 mJ - amp 15
napeti 2.71 Vpp
merene napeti sondou je 14 kV (peak to peak)
perioda**.bin - zpozdeni na zpozdovaci us 
1	1700 % zhruba kladne maximum napeti
2	1702
3	1704

adresar perioda:
energie laseru: 571777_21.txt (jedno dlouhe mereni) - 3.910 mJ - amp 15
perioda**.bin - zpozdeni na zpozdovaci us 
1	1704
2	1706
3	1708
4	1710
5	1712
6	1714
7	1716
8	1718
9	1720
10	1722
11	1724
12	1726
13	1728
14	1730
%15	1732 % smazat
16	1730
17	1732
18	1734
19	1736
20	1738
21	1740
22	1742
23	1744
24	1746
25	1748
26	1750
27	1752
28	1754
29	1756
30	1758
31	1760
32	1762
33	1764
34	1766
35	1768
36	1770
37	1772
38	1774 
%39	1776 % smazat
40	1776 
41	1778
42	1780
43	1782
44	1784
45	1786
46	1788
47	1790
48	1792
49	1794
50	1796
51	1798
52	1800
53	1802
54	1804
perioda_dark - pred fotonasobicem je clona, vyboj jede


vypnut vyboj
perioda_no_discharge - vypnuty vyboj, fotonasobic otevreny





-----------------------------
Co chceme vyhodnocovat a kontrolovat:
- krivky fotonasobice pro ruzne signaly nanormovat -> maji vsechny stejny tvar? Nebo aspon nabehovou hranu? 
- je fotodioda porad stejna (pri stejne energii laseru)?
- vyhodnotit zvlast hloubku propadu i integral efishe, vyjde to stejne?
- hloubka propadu: zavislost na energii laseru (powermeterem i fotodiodou) - na osu x dat E**2
- hloubka propadu: zavislost na napeti bez vyboje - na osu x dat U**2
- hlobka propadu: jeji zavislost na periode





