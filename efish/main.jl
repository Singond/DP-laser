### A Pluto.jl notebook ###
# v0.19.38

using Markdown
using InteractiveUtils

# ╔═╡ 66784c75-f417-4302-bc45-01d4749633e0
# ╠═╡ show_logs = false
begin
	import Pkg
	Pkg.activate(Base.current_project())
	Pkg.instantiate()

	using DelimitedFiles
	using Printf

	using DataFrames
	using ImportKeysightBin
	using LsqFit
	using Plots
end

# ╔═╡ 8dbb2228-6ea2-11ed-2f9e-df0225fee6bb
# ╠═╡ show_logs = false
begin
	include("calibration.jl");
end

# ╔═╡ b0ee89cd-7f55-4ede-b8ef-963f669abef6
md"""
# E-FISH
"""

# ╔═╡ 17006e36-a1f7-4fe9-ad6f-4dfd828e7228
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
		push!(x, (;t = delay, U = d[1], fd = d[2], I = d[3], efish = d[4], y))
	end

	#x.E = elfield.(-minimum.(x.efish[2]))
	x
end

# ╔═╡ c41639b2-19bc-4e49-ab6f-835c8fcbe218
begin
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
	D
end

# ╔═╡ 9c5600ab-836e-471f-8f1b-a04e0d60ce1a
X = map(D) do x
	x.Iefish = [-minimum(xi.efish[2]) for xi in eachrow(x)]
	x.E = elfield.(x.Iefish)
	x
end

# ╔═╡ d65f93a9-124a-4a94-9ba7-39f6983773a5
y = map(x -> x.y[1], X)

# ╔═╡ 8216d6a0-61cb-4d96-bc40-4d5be490ca7e
md"""
## Pulz
"""

# ╔═╡ c57517a5-acb0-49dc-be11-0df4de36d87f
n = 100

# ╔═╡ 90f6fb3f-72d7-4cb9-a7a3-22144551ad66
md"""
Časový vývoj intenzity E-FISH při $(n). pulzu:
"""

# ╔═╡ 74daeaaf-f5a2-4a19-8918-36f2d2710fe8
with(legend = :none) do
	plot(X[1].efish[n])
	xlabel!("čas \$t\$ [s]")
	ylabel!("signál E-FISH \$I\$ [a.u.]")
end

# ╔═╡ 07ea01af-e03a-470f-b52d-71faab19fefa
md"""
## Perioda
Průběh maxima (absolutní) intenzity jednotlivých pulzů v jedné periodě:
"""

# ╔═╡ cde6d098-33fc-4a7d-9498-81584e8d235f
with(legend = :none) do
	plot()
	for x in X
		plot3d!(x.t, x.y, x.Iefish)
	end
	xlabel!("čas \$t\$ [s]")
	ylabel!("poloha \$y\$ [mm]")
	zlabel!("signál E-FISH \$I\$ [a.u.]")
end

# ╔═╡ db270dba-8414-4a35-b837-964f5cdfb63d
md"""
Příslušná intenzita elektrického pole:
"""

# ╔═╡ 50a2722b-66e1-4310-a398-152f28caf118
with(legend = :none) do
	plot()
	for x in X
		#plot3d!(x.t, x.y, x.E, fc=:match, fillto=0)
		#plot!(x.t, x.y, x.E, ribbon=2e5)
		plot!(x.t, x.y, x.E, ribbon=2e5)
	end
	xlabel!("čas \$t\$ [s]")
	ylabel!("poloha \$y\$ [mm]")
	zlabel!("intenzita elektrického pole \$E\$ [V/m]")
end

# ╔═╡ Cell order:
# ╟─b0ee89cd-7f55-4ede-b8ef-963f669abef6
# ╠═66784c75-f417-4302-bc45-01d4749633e0
# ╠═8dbb2228-6ea2-11ed-2f9e-df0225fee6bb
# ╠═17006e36-a1f7-4fe9-ad6f-4dfd828e7228
# ╠═c41639b2-19bc-4e49-ab6f-835c8fcbe218
# ╠═9c5600ab-836e-471f-8f1b-a04e0d60ce1a
# ╠═d65f93a9-124a-4a94-9ba7-39f6983773a5
# ╟─8216d6a0-61cb-4d96-bc40-4d5be490ca7e
# ╠═c57517a5-acb0-49dc-be11-0df4de36d87f
# ╟─90f6fb3f-72d7-4cb9-a7a3-22144551ad66
# ╠═74daeaaf-f5a2-4a19-8918-36f2d2710fe8
# ╟─07ea01af-e03a-470f-b52d-71faab19fefa
# ╠═cde6d098-33fc-4a7d-9498-81584e8d235f
# ╟─db270dba-8414-4a35-b837-964f5cdfb63d
# ╠═50a2722b-66e1-4310-a398-152f28caf118
