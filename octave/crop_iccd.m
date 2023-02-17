function x = crop_iccd(x, rows, cols)
	x.img  = x.img (rows(1):rows(2), cols(1):cols(2), :);
	x.dark = x.dark(rows(1):rows(2), cols(1):cols(2), :);
end
