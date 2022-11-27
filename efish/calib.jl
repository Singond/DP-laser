using Printf

using DelimitedFiles
using ImportKeysightBin

d = 1.1e-3  # Discharge gap width [m]

index = readdlm("data-22-01-24/napeti_info.txt", skipstart = 1)

X = NamedTuple[]
for row in eachrow(index)
	file = @sprintf("data-22-01-24/oscilo/energie_napeti/napeti%02d.bin", row[2])
	U, efish, I, fd, meta = importkeysightbin(file)
	push!(X, (;Ud = row[1], U, efish, I, fd))
end

Ud = getfield.(X, :Ud)  # Voltage between plates
E = Ud ./ d             # Electric field between plates (assuming homogeneous)
efishint = [-minimum(x.efish[2]) for x in X]  # E-FISH intensity

# The parabolic part seems to end at around Ud = 2.
# This is probably the part without discharge.
s = Ud .< 2

# Fit this part of data with a second-order polynomial.
β = [E[s].^2 E[s] ones(sum(s))] \ efishint[s]
calib(E) = β[1]*E^2 + β[2]*E + β[3]
# Inverse
elfield(efish) = (- β[2] + sqrt(β[2]^2 - 4*β[1] * (β[3] - efish))) / (2*β[1])
