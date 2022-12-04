using DelimitedFiles
using Printf

using DataFrames
using ImportKeysightBin

include("calib.jl")

function loaddata(dataname::String, energyname::String)
	index = readdlm("data-22-02-03/$(dataname)_info.txt", skipstart = 1)
	energydata = readdlm("data-22-02-03/powermeter/$(energyname).txt",
		skipstart = 36)

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

d = loaddata("perioda14kv0mm", "571777_01")
