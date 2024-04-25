rayleigh_air.data = [...
0.200  1.080  3.2378  3.612e-25
0.210  1.074  3.1737  2.836e-25
0.220  1.070  3.1222  2.269e-25
0.230  1.066  3.0799  1.841e-25
0.240  1.064  3.0445  1.515e-25
0.250  1.062  3.0146  1.259e-25
0.260  1.060  2.9890  1.056e-25
0.270  1.059  2.9669  8.939e-26
0.280  1.057  2.9475  7.614e-26
0.290  1.056  2.9306  6.534e-26
0.300  1.055  2.9155  5.642e-26
0.310  1.055  2.9022  4.903e-26
0.320  1.054  2.8902  4.279e-26
0.330  1.053  2.8795  3.752e-26
0.340  1.053  2.8698  3.307e-26
0.350  1.052  2.8611  2.924e-26
0.360  1.052  2.8531  2.598e-26
0.370  1.052  2.8458  2.317e-26
0.380  1.051  2.8392  2.071e-26
0.390  1.051  2.8331  1.858e-26
0.400  1.051  2.8275  1.673e-26];

rayleigh_air.wl = rayleigh_air.data(:,1) * 1e3;            # [nm]
rayleigh_air.Fk = rayleigh_air.data(:,2);                  # [-]
rayleigh_air.refrind = 1 + rayleigh_air.data(:,3) * 1e-4;  # [-]
rayleigh_air.xsect = rayleigh_air.data(:,4) * 1e-4;        # [m2]

function [dxs, xsect, Fk, rho0]  = dxsect(wl, rayleigh_air)
	xsect = interp1(rayleigh_air.wl, rayleigh_air.xsect, wl, "extrap");
	Fk = interp1(rayleigh_air.wl, rayleigh_air.Fk, wl, "extrap");
	rho0 = 6 * (Fk  - 1) / (3 + 7 * Fk);
	dxs = (3 * xsect / (8 * pi)) * (2 - rho0) / (2 + rho0);
end

rayleigh_air.dxsect = @(wl) dxsect(wl, rayleigh_air);
