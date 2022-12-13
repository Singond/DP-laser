using DelimitedFiles
using Printf

using DataFrames
using ImportKeysightBin

include("calib.jl")

function loaddata(dataname::String, energyname::String, y::Float64)
	index = readdlm("data-22-02-03/$(dataname)_info.txt",
		comments=true, comment_char='%')
	if !isempty(energyname)
		energydata = readdlm("data-22-02-03/powermeter/$(energyname).txt",
			skipstart = 36)
	end

	x = DataFrame()
	for (row, (delay, fileno)) in enumerate(eachrow(index))
		filenostr = @sprintf("%05d", fileno)
		file = "data-22-02-03/$(dataname)/$(dataname)$(filenostr).bin"
		d = importkeysightbin(file)
		push!(x, (;t = delay, U = d[1], fd = d[2], I = d[3], efish = d[4]))
	end

	#x.E = elfield.(-minimum.(x.efish[2]))
	x
end

function process(x::DataFrame)
	x.Iefish = [-minimum(xi.efish[2]) for xi in eachrow(x)]
	x.E = elfield.(x.Iefish)
	x
end

D = Array{DataFrame}(undef, 13)
D[1]  = loaddata("perioda14kv0mm",     "571777_03", 0.0)
D[2]  = loaddata("perioda14kv0p1mm",   "571777_04", 0.1)
D[3]  = loaddata("perioda14kv0p2mm",   "571777_05", 0.2)
D[4]  = loaddata("perioda14kv0p3mm",   "571777_06", 0.3)
D[5]  = loaddata("peroda14kv0p4mm",    "571777_07", 0.4)
D[6]  = loaddata("perioda14kv0p5mm",   "571777_08", 0.5)
D[7]  = loaddata("perioda14kv0p6mm",   "571777_09", 0.6)
D[8]  = loaddata("perioda14kv0p7mm",   "",          0.7)
D[9]  = loaddata("perioda14kv-0p0mm",  "571777_11", 0.0)
D[10] = loaddata("perioda14kv-0p1mm",  "571777_12", -0.1)
D[11] = loaddata("perioda14kv-0p2mm",  "571777_13", -0.2)
D[12] = loaddata("perioda14kv-0p3mm",  "571777_14", -0.3)
D[13] = loaddata("perioda14kv-0p35mm", "571777_15", -0.35)

y  = [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.0 -0.1 -0.2 -0.3 -0.35]'
y .+= 0.4

X = map(process, D)
