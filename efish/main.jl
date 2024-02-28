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
	using Statistics
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
	nothing
end

# ╔═╡ b0ee89cd-7f55-4ede-b8ef-963f669abef6
md"""
# E-FISH
"""

# ╔═╡ cee03886-7477-4b64-ab87-22affe4128fd
md"""
## Kalibrace
Měřením signálu E-FISH generovaného ve známém elektrickém poli
bylo získáno několik kalibračních funkcí pro různé polohy paprsku.
Postup je obdobný tomu popsanému v `calibration.jl`.
"""

# ╔═╡ 6a2506ef-95bf-4c2d-8d89-fd1de690bf0e
load_calibration(dir) = map(readdir(dir, join=true) |>
                            filter(contains("000"))) do file
	local U, fd, I, efish, meta = importkeysightbin(file)
	(; U, fd, I, efish, meta)
end

# ╔═╡ 99e960a4-815f-4245-9979-64b6598e1583
function process_calibration(data, Udmax=Inf)
	frames = map(data) do x
		Ud = mean(x.U[2])
		Iefish = -minimum(x.efish[2])
		(; x..., Ud, Iefish)
	end

	Ud = [x.Ud for x in frames]
	Iefish = [x.Iefish for x in frames]
	E = reference_field.(Ud)

	s = Ud .< Udmax
	p, q, model, elfield = calibration_nonlinear(E[s], Iefish[s])

	(Ud, E, Iefish, model, model_params=(p, q), elfield, frames)
end

# ╔═╡ cc31ba73-065b-42a1-999b-16101563d3f4
function process_calibration(dir::String, args...)
	process_calibration(load_calibration(dir), args...)
end

# ╔═╡ 498f248b-b16e-467e-ab0c-a903b14d8883
Udmax = 5200

# ╔═╡ ad460ed7-cfb6-4465-a7ba-c17f2450ddf1
calib0 = process_calibration("data-22-02-03/kalibrace0", Udmax)

# ╔═╡ cbfe5e58-83ad-4649-9153-eb987f8adc73
calib1 = process_calibration("data-22-02-03/kalibrace-0p35mm", Udmax)

# ╔═╡ 72c871fb-91a6-4b66-b6db-a471d5884be6
calib2 = process_calibration("data-22-02-03/kalibrace0b", Udmax)

# ╔═╡ f591ed8e-adb1-42de-8976-19474917a0bb
with(legend = :topleft) do
	plot(calib0.frames[20].U...)
end

# ╔═╡ c21000e4-8540-44ee-bf99-8fd8b1064ab3
with(legend = :topleft) do
	plot(calib0.frames[20].I...)
end

# ╔═╡ 1111eb0c-d64d-4480-8bc0-9caaedd01c7d
with(legend = :topleft) do
	plot(calib0.frames[20].efish...)
end

# ╔═╡ f8c28b0f-1362-4680-9ab6-8113ef4240bd
with(legend = :topleft) do
	plot(calib0.frames[20].fd...)
end

# ╔═╡ 6e8db23b-0f31-4159-ac16-6e23ef8a89d5
with(legend = :topleft) do
	scatter(calib0.E, calib0.Iefish, label="0 mm", color=1)
	plot!(calib0.model, color=1, label=nothing)
	scatter!(calib1.E, calib1.Iefish, label="-0.35 mm", color=2)
	plot!(calib1.model, color=2, label=nothing)
	scatter!(calib2.E, calib2.Iefish, label="0 mm (later)", color=3)
	plot!(calib2.model, color=3, label=nothing)
	xlabel!("E [V/m]")
	ylabel!("I [a.u.]")
end

# ╔═╡ 6e3ba49e-da04-42e2-b6f4-1d529f1ed504
with(legend = :topleft) do
	plot(calib0.elfield, label="0 mm", color=1)
	plot!(E -> calib0.elfield(E, left_branch=true), label=nothing, color=1)
	plot!(calib1.elfield, label="-0.35 mm", color=2)
	plot!(E -> calib1.elfield(E, left_branch=true), label=nothing, color=2)
	plot!(calib2.elfield, label="0 mm (later)", color=3)
	plot!(E -> calib2.elfield(E, left_branch=true), label=nothing, color=3)
	xlabel!("I [a.u.]")
	ylabel!("E [V/m]")
end

# ╔═╡ 6e568ec1-a89f-4ace-ae7f-ed8a85379ff6
md"""
## Měření elektrického pole výboje
Získaná kalibrační funkce byla využita k určení elektrického pole
v zapáleném výboji.
Laser byl nastaven na zesílení 15, energie pulzu činila 4,00 mJ.
Osciloskop zaznamenával data s 16 akumulacemi.
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
Zde je příklad časového vývoje intenzity E-FISH z jednoho laserového pulzu.
"""

# ╔═╡ c57517a5-acb0-49dc-be11-0df4de36d87f
n = 100

# ╔═╡ 90f6fb3f-72d7-4cb9-a7a3-22144551ad66
md"""
Například $(n). pulz:
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
		plot!(x.t, x.y, x.E)
	end
	xlabel!("čas \$t\$ [s]")
	ylabel!("poloha \$y\$ [mm]")
	zlabel!("intenzita elektrického pole \$E\$ [V/m]")
end

# ╔═╡ 23d18426-81ef-41db-846e-96305d4f97c7
md"""
Totéž jako plocha (Julia neumí výše uvedený graf vyplnit).
"""

# ╔═╡ ad9d4cce-3e96-4e84-b868-a9fafc6639cf
with(legend = :none) do
	local t = X[1].t
	local E = reduce(hcat, map(x -> x.E, X))
	local p = sortperm(y)
	surface(t, y[p], E[:,p]')
	xlabel!("čas \$t\$ [s]")
	ylabel!("poloha \$y\$ [mm]")
	zlabel!("intenzita elektrického pole \$E\$ [V/m]")
end

# ╔═╡ Cell order:
# ╟─b0ee89cd-7f55-4ede-b8ef-963f669abef6
# ╠═66784c75-f417-4302-bc45-01d4749633e0
# ╟─cee03886-7477-4b64-ab87-22affe4128fd
# ╠═8dbb2228-6ea2-11ed-2f9e-df0225fee6bb
# ╠═6a2506ef-95bf-4c2d-8d89-fd1de690bf0e
# ╠═99e960a4-815f-4245-9979-64b6598e1583
# ╠═cc31ba73-065b-42a1-999b-16101563d3f4
# ╠═498f248b-b16e-467e-ab0c-a903b14d8883
# ╠═ad460ed7-cfb6-4465-a7ba-c17f2450ddf1
# ╠═cbfe5e58-83ad-4649-9153-eb987f8adc73
# ╠═72c871fb-91a6-4b66-b6db-a471d5884be6
# ╠═f591ed8e-adb1-42de-8976-19474917a0bb
# ╠═c21000e4-8540-44ee-bf99-8fd8b1064ab3
# ╠═1111eb0c-d64d-4480-8bc0-9caaedd01c7d
# ╠═f8c28b0f-1362-4680-9ab6-8113ef4240bd
# ╠═6e8db23b-0f31-4159-ac16-6e23ef8a89d5
# ╠═6e3ba49e-da04-42e2-b6f4-1d529f1ed504
# ╟─6e568ec1-a89f-4ace-ae7f-ed8a85379ff6
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
# ╟─23d18426-81ef-41db-846e-96305d4f97c7
# ╠═ad9d4cce-3e96-4e84-b868-a9fafc6639cf
