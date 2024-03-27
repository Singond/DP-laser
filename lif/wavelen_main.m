pkg load optim;

if (!exist("W", "var"))
	wavelen_base;
end

W_old = W;
W = struct([]);
for x = W_old
	x.inn = x.in ./ max(x.in(:));
	x.Em = mean(x.E(:,1));
	#wt = [];
	#wt = log(x.in);
	#wt = x.in;
	#wt = log(x.in) + 1;
	wt = log(x.in + 0.5 * range(x.in));
	[~, x.fit] = fit_voigt(x.wl, x.in, wt);
	W(end+1) = x;
end
clear W_old;
