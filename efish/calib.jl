using Printf
using DelimitedFiles

using ImportKeysightBin
using LsqFit

d = 1.0e-3  # Discharge gap width [m]

index = readdlm("data-22-01-24/napeti_info.txt", skipstart = 1)

X = NamedTuple[]
for row in eachrow(index)
	file = @sprintf("data-22-01-24/oscilo/energie_napeti/napeti%02d.bin", row[2])
	local U, efish, I, fd, meta = importkeysightbin(file)
	U[2] .*= 1000
	push!(X, (;Ud = row[1], U, efish, I, fd))
end

Ud = getfield.(X, :Ud)  # Voltage between plates
E = Ud ./ d             # Electric field between plates (assuming homogeneous)
efish = [-minimum(x.efish[2]) for x in X]  # E-FISH intensity

# The parabolic part seems to end at around Ud = 2.
# This is probably the part without discharge.
s = Ud .< 2

# Fit this part of data with a second-order polynomial.
a, b, c = [E[s].^2 E[s] ones(sum(s))] \ efish[s]
calib_l(E) = a*E^2 + b*E + c

# The assumed dependency is actually efish = a * (E + b)^2
# (the parabola vertex is at the x axis).
# Find its parameters, using the previous fit as a starting point.
calib(E, β) = β[1] .* (E .+ β[2]).^2
β0 = [a; b/(2a)]
fit = curve_fit(calib, E[s], efish[s], β0)
calib(E) = calib(E, fit.param)
p, q = fit.param

# Invert the fitted function to obtain conversion from E-FISH intensity
# to the corresponding electric field.
elfield(efish) = max(sqrt(efish/p) - q, 0)
