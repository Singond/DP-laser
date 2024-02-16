### A Pluto.jl notebook ###
# v0.19.38

using Markdown
using InteractiveUtils

# ╔═╡ 62484b61-c048-4e22-b14a-e44c22b58fec
begin
	import Pkg
	Pkg.activate(Base.current_project())
	Pkg.instantiate()

	using LaTeXStrings
	using LsqFit
	using Plots
	using ImportKeysightBin
end

# ╔═╡ 55cfde6d-ff4c-4e84-9570-85905899b046
include("calib.jl")

# ╔═╡ ad1ee392-40a9-4711-8771-20173bde62d5
md"""
# Kalibrace
Účelem této části bylo změřit závislost intenzity signálu EFISH na známé
intenzitě elektrického pole $E$ v reaktoru.
Elektrické pole bylo realizováno přiložením známého napětí na elektrody
v reaktoru před zapálením výboje. Elektrické pole je v tom případě považováno
za homogenní a určeno podle vztahu

$$E = \frac{U}{d}$$

Intenzita odezvy byla naměřena pro několik hodnot napětí $U$ a získaná zívislost aproximována vhodnou modelovou funkcí.
"""

# ╔═╡ 2a850e6a-68ee-48bd-83b6-e233f99a14c6
md"""
## Lineární model
Naměřená data jsou zde:
"""

# ╔═╡ c82f6174-9f76-4aed-8fb2-10731c0a3628
with(legend = :topleft) do
	scatter(Ud, efish, label = "naměřená data", markersize = 8)
	xlabel!("U [V]")
	ylabel!("I [a.u.]")
end

# ╔═╡ eae75067-dab9-4cf4-8116-a8d6975788f9
md"""
Napětí na elektrodách bylo přepočteno na intenzitu elektrického pole
podle výše uvedeného vztahu.
Z dat byly odstraněny body změřené při hořícím výboji.
Zbylé body byly proloženy polynomem druhého stupně, čímž byla získána
následující závislost.
"""

# ╔═╡ 90751086-2f45-4bb7-84c7-1d1b87f9b241
latexstring("🐟 = $(round(a*1e7, sigdigits=3))\\cdot10^{-7}E^2 + $(round(b*1e4, sigdigits=3))\\cdot10^{-4}E + $(round(c, sigdigits=3))")

# ╔═╡ 5a19ff01-e7a5-4ede-b569-a10e08e29a42
md"""
## Nelineární model
Předpokládaná závislost má ve skutečnosti tvar:

$$🐟 = p (E + q)^2$$

Parametry tohoto modelu byly nalezeny nelineární metodou nejmenších čtverců,
s výchozími hodnotami spočetnými podle předchozího modelu.
Výsledná závislost je následující:
"""

# ╔═╡ c39dddb1-0371-42b7-a5a3-2e38c9bba4e0
latexstring("🐟 = $(round(p*1e7, sigdigits=3))\\cdot10^{-7} (E + $(round(q, sigdigits=3)))^2")

# ╔═╡ 672cd756-20bd-4421-abf0-8a02e3ba901f
md"""
## Porovnání
Oba modely se dobře shodují, rozdíl mezi nimi je nepostřehnutelný:
"""

# ╔═╡ 929bb8a5-5464-495c-92dc-c57ac81068d2
with(legend = :topleft) do
	scatter(E, efish, label = "naměřená data", markersize = 8)
	plot!(calib_l, color = 1, label = "lineární model")
	plot!(calib, color = 2, label = "nelineární model")
	xlabel!("E [V/m]")
	ylabel!("I [a.u.]")
end

# ╔═╡ 754553fc-c996-47ec-9195-d7841a28af20
md"""
Výsledná kalibrační funkce je inverze získaného modelu opravená tak,
aby nevracela záporné hodnoty intenzity $E$:
"""

# ╔═╡ 141ffd5e-315a-4718-9da7-333793698511
with(legend = :none) do
	plot(elfield)
	xlabel!("I [a.u.]")
	ylabel!("U [V]")
end

# ╔═╡ Cell order:
# ╟─ad1ee392-40a9-4711-8771-20173bde62d5
# ╠═62484b61-c048-4e22-b14a-e44c22b58fec
# ╟─2a850e6a-68ee-48bd-83b6-e233f99a14c6
# ╠═55cfde6d-ff4c-4e84-9570-85905899b046
# ╠═c82f6174-9f76-4aed-8fb2-10731c0a3628
# ╟─eae75067-dab9-4cf4-8116-a8d6975788f9
# ╟─90751086-2f45-4bb7-84c7-1d1b87f9b241
# ╟─5a19ff01-e7a5-4ede-b569-a10e08e29a42
# ╟─c39dddb1-0371-42b7-a5a3-2e38c9bba4e0
# ╟─672cd756-20bd-4421-abf0-8a02e3ba901f
# ╠═929bb8a5-5464-495c-92dc-c57ac81068d2
# ╟─754553fc-c996-47ec-9195-d7841a28af20
# ╠═141ffd5e-315a-4718-9da7-333793698511
