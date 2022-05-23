using Printf

using DelimitedFiles
using ImportKeysightBin

index = readdlm("data/napeti_info.txt", skipstart = 1)

X = NamedTuple[]
for row in eachrow(index)
	file = @sprintf("data/oscilo/energie_napeti/napeti%02d.bin", row[2])
	U, efish, I, fd, meta = importkeysightbin(file)
	push!(X, (;Ud = row[1], U, efish, I, fd))
end

elfield(efish) = -minimum(efish)

Ud = getfield.(X, :Ud)
Ecalib = [elfield(x.efish[2]) for x in X]

# Fit the data with a second-order polynomial

# The parabolic part seems to end at around Ud = 2
s = Ud .< 2

# Fit it
β = [Ud[s].^2 Ud[s] ones(sum(s))] \ Ecalib[s]

calib(U) = β[1]*U^2 + β[2]*U + β[3]
