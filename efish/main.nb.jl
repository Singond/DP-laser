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

	using DataFrames
	using ImportKeysightBin
	using LsqFit
	using Plots
end

# ╔═╡ 8dbb2228-6ea2-11ed-2f9e-df0225fee6bb
include("main.jl");

# ╔═╡ b0ee89cd-7f55-4ede-b8ef-963f669abef6
md"""
# E-FISH
"""

# ╔═╡ c41639b2-19bc-4e49-ab6f-835c8fcbe218
x = loaddata("perioda14kv0mm", "571777_01", 0.0)

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
	plot(x.efish[n])
	xlabel!("čas \$t\$ [s]")
	ylabel!("signál E-FISH \$I\$ [a.u.]")
end

# ╔═╡ 07ea01af-e03a-470f-b52d-71faab19fefa
md"""
## Perioda
Průběh maxima (absolutní) intenzity jednotlivých pulzů v jedné periodě:
"""

# ╔═╡ 955ad2af-3ab8-40ce-9999-402a647be7df
I = [-minimum(xi.efish[2]) for xi in eachrow(x)]

# ╔═╡ cde6d098-33fc-4a7d-9498-81584e8d235f
with(legend = :none) do
	scatter(x.t, I)
	xlabel!("čas \$t\$ [s]")
	ylabel!("signál E-FISH \$I\$ [a.u.]")
end

# ╔═╡ db270dba-8414-4a35-b837-964f5cdfb63d
md"""
Příslušná intenzita elektrického pole:
"""

# ╔═╡ 85861ca1-9ba0-4a66-8c2a-982f552e0c9e
E = elfield.(I)

# ╔═╡ 50a2722b-66e1-4310-a398-152f28caf118
with(legend = :none) do
	scatter(x.t, E)
	xlabel!("čas \$t\$ [s]")
	ylabel!("intenzita elektrického pole \$E\$ [V/m]")
end

# ╔═╡ Cell order:
# ╟─b0ee89cd-7f55-4ede-b8ef-963f669abef6
# ╠═66784c75-f417-4302-bc45-01d4749633e0
# ╟─8dbb2228-6ea2-11ed-2f9e-df0225fee6bb
# ╠═c41639b2-19bc-4e49-ab6f-835c8fcbe218
# ╟─8216d6a0-61cb-4d96-bc40-4d5be490ca7e
# ╠═c57517a5-acb0-49dc-be11-0df4de36d87f
# ╟─90f6fb3f-72d7-4cb9-a7a3-22144551ad66
# ╠═74daeaaf-f5a2-4a19-8918-36f2d2710fe8
# ╟─07ea01af-e03a-470f-b52d-71faab19fefa
# ╠═955ad2af-3ab8-40ce-9999-402a647be7df
# ╠═cde6d098-33fc-4a7d-9498-81584e8d235f
# ╟─db270dba-8414-4a35-b837-964f5cdfb63d
# ╠═85861ca1-9ba0-4a66-8c2a-982f552e0c9e
# ╠═50a2722b-66e1-4310-a398-152f28caf118
