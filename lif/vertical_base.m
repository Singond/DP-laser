pkg load singon-plasma;
addpath ../octave;

X = struct([]);
x = load_iccd("data-2023-01-20/vyska.SPE");
x.sccmAr = 775;
x.sccmH2 = 300;
x.control = [
	0	1	6
	1	8	13
	2	17	23
	3	27	29
	4	32	35
	5	37	39
	6	42	47
	7	49	53
	8	56	60];
X(end+1) = x;

x = load_iccd("data-2023-01-20/vyska2.SPE");
x.sccmAr = 775;
x.sccmH2 = 300;
x.control = [
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
	14	104	112];
X(end+1) = x;

x = load_iccd("data-2023-01-20/vyska3.SPE");
x.sccmAr = 100 + 75;
x.sccmH2 = 150;
x.control = [
	0	1	8
	1	11	18
	2	22	28
	3	32	38
	4	42	47
	5	51	63];
X(end+1) = x;

x = load_iccd("data-2023-01-20/vyska4.SPE");
x.sccmAr = 100 + 75;
x.sccmH2 = 50;
x.control = [
	0	1	7
	1	10	18
	2	21	29
	3	33	40];
X(end+1) = x;

X = arrayfun(@correct_iccd, X);

vertical = X;
