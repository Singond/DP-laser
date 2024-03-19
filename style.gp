set samples 200, 200
set isosamples 50,50

set decimalsign ','
#set border 3
#set xtics out nomirror
#set ytics out nomirror

# Line styles (based on "set 1" from gnuplot-palettes)
set linetype 1 lw 2 lc rgb '#377EB8' pt 5  ps 1.4 # blue
set linetype 2 lw 2 lc rgb '#E41A1C' pt 13 ps 2   # red
set linetype 3 lw 2 lc rgb '#4DAF4A' pt 9  ps 2   # green
set linetype 4 lw 2 lc rgb '#984EA3' pt 11 ps 2   # purple
set linetype 5 lw 2 lc rgb '#FF7F00' pt 7  ps 1.5 # orange
set linetype 6 lw 2 lc rgb '#DDDD33' pt 15 ps 2   # yellow
set linetype 7 lw 2 lc rgb '#A65628' pt 3  ps 1.3 # brown
set linetype 8 lw 2 lc rgb '#F781BF' pt 9  ps 2   # pink

set macros

# Padding axis ranges
padding_amount = 0.05
xpadding = "set offsets graph padding_amount, graph padding_amount"
ypadding = "set offsets 0, 0, graph padding_amount, graph padding_amount"
padding = "set offsets graph padding_amount, graph padding_amount, \
	graph padding_amount, graph padding_amount"
