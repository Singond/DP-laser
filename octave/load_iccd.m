## -*- texinfo -*-
## @deftypefn  {} {@var{x} =} load_iccd (@var{file})
## @deftypefnx {} {@var{x} =} load_iccd (@dots{}, @qcode{"dark"}, @
##     @var{darkfile})
## @deftypefnx {} {@var{x} =} load_iccd (@dots{}, @qcode{"power"}, @
##     @var{powerfile})
## @deftypefnx {} {@var{x} =} load_iccd (@dots{}, @qcode{"nodark"})
## @deftypefnx {} {@var{x} =} load_iccd (@dots{}, @qcode{"nopower"})
##
## Load image data from ICCD camera.
## @end deftypefn
function x = load_iccd(data, varargin)
	p = inputParser;
	p.addParameter("dark", "");
	p.addParameter("power", "");
	p.addSwitch("nodark");
	p.addSwitch("nopower");
	p.parse(varargin{:});
	args = p.Results;

	[dir, name, ext] = fileparts(data);
	if (isempty(args.dark))
		dark = fullfile(dir, [name "_dark" ext]);
	else
		dark = args.dark;
	end
	if (isempty(args.power))
		pwr = fullfile(dir, [name ".txt"]);
	else
		pwr = args.power;
	end

	[x.img, x.imgm] = read_princeton_spe(data);
	x.xpos = 1:size(x.img, 2);
	x.ypos = (1:size(x.img, 1))';
	x.acc = x.imgm.accum;
	x.readout = x.imgm.readouttime;

	if (isfile(dark))
		[x.dark, x.darkm] = read_princeton_spe(dark);
	elseif (!args.nodark)
		x.dark = [];
		x.darkm = [];
		warning("load_data: No dark image for %s", name);
	endif

	if (isfile(pwr))
		[p, x.pwrmeta] = read_starlab(pwr, "emptyvalue", nan);
		c = cell();
		for k = 2:size(p, 2)
			t = p(:,1);
			v = p(:,k);
			m = !isnan(v);
			c = [c; {[t(m) v(m)]}];
		endfor
		x.pwrdata = c;
	elseif (!args.nopower)
		x.pwrdata = {};
		warning("load_data: No power data for %s", name);
	endif
end
