### A Pluto.jl notebook ###
# v0.19.38

using Markdown
using InteractiveUtils

# ╔═╡ 62484b61-c048-4e22-b14a-e44c22b58fec
# ╠═╡ show_logs = false
begin
	import Pkg
	Pkg.activate(Base.current_project())
	Pkg.instantiate()

	using DelimitedFiles
	using Printf
	using Statistics

	using LaTeXStrings
	using LsqFit
	using Plots
	using ImportKeysightBin
end

# ╔═╡ ad1ee392-40a9-4711-8771-20173bde62d5
md"""
# Kalibrace
Účelem této části bylo změřit závislost intenzity signálu EFISH na známé
intenzitě elektrického pole $E$ v reaktoru.
Elektrické pole bylo realizováno přiložením známého napětí na elektrody
v reaktoru před zapálením výboje. Elektrické pole je v tom případě považováno
za homogenní a určeno podle jednoduchého vztahu.
Intenzita odezvy byla naměřena pro několik hodnot napětí $U$ a získaná zívislost aproximována vhodnou modelovou funkcí.
"""

# ╔═╡ 3f209503-07a9-46c6-b41a-585c2d57d814
md"""
## Ověření opakovatelnosti
Za konstantních podmínek bylo naměřeno 100 jednotlivých snímků na osciloskopu,
jejichž účelem bylo ověřit opakovatelnost pokusu.
"""

# ╔═╡ 5f5e7440-d895-44de-b115-f33b7a61bb13
singleshots = map(readdir("data-22-01-24/oscilo/singleshot", join=true)) do file
	local U, efish, I, fd, meta = importkeysightbin(file)
	(; U, efish, I, fd, meta)
end

# ╔═╡ aba36890-2bfd-4e8a-be4c-9ac5b741012c
md"""
Vybrané snímky signálu E-FISH z fotonásobiče jsou níže:
"""

# ╔═╡ 7f24764f-1299-43a4-85f4-caa2b82cdb0c
singleshot_plot = with() do
	plot()
	for k in 1:9:length(singleshots)
		plot!(singleshots[k].efish, label=k)
	end
	xlabel!("čas \$t\$ [s]")
	ylabel!("signál E-FISH \$I\$ [a.u.]")
end

# ╔═╡ 77aea516-8998-4745-9999-74bbbb362a1f
md"""
Přiblížení na pulz je zde:
"""

# ╔═╡ ada7162b-c6de-4fe6-b772-18e56e1760f0
plot(singleshot_plot, xlim=(4.8e-8, 5.2e-8))

# ╔═╡ 7e6a0eb4-c8da-416f-83b2-f09ecf3833b2
md"""
Opakovatelnost pokusu se zdá být dobrá.
"""

# ╔═╡ f9baabe8-c809-4061-8e23-a2654d6adf04
md"""
## Závislost na napětí
Dále byla naměřena závislost signálu E-FISH na napětí mezi elektrodami.
Zpoždění laseru za napětím bylo konstantní, zesílení bylo nastaveno na 15
a vlnová délka na λ = 1064 nm.
Měřák energie ukazoval stabilně hodnotu 3,920–3,940 mJ.
Data byla zaznamenávána osciloskopem, každý snímek obsahuje 256 akumulací.
"""

# ╔═╡ 37331088-c330-4c9b-8ddd-2b773bfd59b1
begin
	index = readdlm("data-22-01-24/napeti_info.txt", skipstart = 1)
	calibration = NamedTuple[]
	for row in eachrow(index)
		file = @sprintf("data-22-01-24/oscilo/energie_napeti/napeti%02d.bin", row[2])
		local U, efish, I, fd, meta = importkeysightbin(file)
		push!(calibration, (; Us = row[1], U, efish, I, fd, meta))
	end
end

# ╔═╡ b07fcef5-e4e1-4e8c-b57d-6f0d5f346784
md"""
### Příklad dat
Níže je ukázka všech kanálů osciloskopu z jedné sady dat:
"""

# ╔═╡ 8413b7b1-32da-46e5-93f4-23ad83379666
x = calibration[1]

# ╔═╡ 2acaa8f7-f074-4973-b86b-ef1fe38de3c9
md"""
Napětí na zdroji je $(x.Us) V.
Průběh napětí mezi elektrodami zaznamenaný napěťovou sondou
(x 1000)
_Tektronix_ je v kanálu 1:
"""

# ╔═╡ b76d27c5-70d1-469c-a883-34f63578343f
plot(x.U)

# ╔═╡ 305b5ef0-feb7-4490-9efb-ff33b5024a62
md"""
Signál z fotonásobiče (tedy odezva E-FISH), je v kanálu 2:
"""

# ╔═╡ b1eebdae-591b-4064-aede-2c1c0e84edd0
plot(x.efish)

# ╔═╡ 98fad782-ecdd-491e-9ab4-03702b9679a5
md"Signál proudové sondy _CT2_ je v kanálu 3:"

# ╔═╡ b3276e7d-977c-4de6-b36a-44c043f22ffe
plot(x.I)

# ╔═╡ e6db65b3-2e6d-4313-8a2f-785a63b9b61b
md"Signál z fotodiody _Thorlabs_ je v kanálu 4:"

# ╔═╡ 2cfa5484-3ad6-45f1-aea2-a5476c676587
plot(x.fd)

# ╔═╡ 58a6bb5a-5ec1-4b14-89e3-1bdf1c6f2fb5
md"""
### Ověření konstantnosti pulzu
Protože energie laseru byla nastavena na konstantní hodnotu,
nabízí se ověřit, zdali je konstantní i energie pulzu zaznamenaná fotodiodou.
Zde je signál fotodiody pro všechna měření:
"""

# ╔═╡ eea4bf6d-1409-4f52-b577-b4e6e3e56aa4
with(legend = :none) do
	plot(xlim=(40, 70))
	for (k, x) in enumerate(calibration)
		plot!(x.fd[1] * 1e9, k * ones(size(x.fd[2])), x.fd[2])
	end
	xlabel!("čas \$t\$ [ns]")
	ylabel!("číslo měření")
	zlabel!("signál fotodiody \$E_d\$ [a.u.]")
end

# ╔═╡ dd961d3e-d15f-4668-86e9-a4f71ef80a6d
md"""
Rozdíly jsou nepostřehnutelné, zde jsou táž data vykreslena přes sebe.
"""

# ╔═╡ 5c481058-7db3-4acb-8924-c1983d6b284a
fd_plot = with(legend = :none) do
	plot()
	for (k, x) in enumerate(calibration)
		plot!(x.fd[1]*1e9, x.fd[2])
	end
	xlabel!("čas \$t\$ [ns]")
	ylabel!("signál fotodiody \$E_d\$ [a.u.]")
end

# ╔═╡ 804fcb70-4875-436e-9783-5bc28219b571
md"""
Odlišnosti se projeví až při přiblížení. Zde je detail špičky signálu:
"""

# ╔═╡ 3bc61c71-b563-4fb4-a33a-c70826b22417
plot(fd_plot, xlim=(45, 45.6), ylim=(0.16, 0.18))

# ╔═╡ 74b7b696-67ca-4a6c-8eec-82d8cd7a1cb2
md"""
### Vyhodnocení
Celkem bylo provedeno $(length(calibration)) měření pro různé hodnoty napětí.
Napětí na zdroji $$U_s$$ bylo postupně nastavováno na hodnoty:
"""

# ╔═╡ 81e003ac-028f-4787-a593-bd7efd9e98bb
Us = getfield.(calibration, :Us)

# ╔═╡ 7476cbae-0d64-4aca-b02c-20842ca44322
md"""
Napětí mezi elektrodami $U_d$ snímané napěťovou sondou (1. kanál výše)
bylo pro další výpočty pro každou sadu zprůměrováno do jedné hodnoty.
"""

# ╔═╡ 0e6a3c6a-0ca0-4924-a83a-2e1d4c309b21
Ud = map(x -> mean(x.U[2]), calibration)  # [V]

# ╔═╡ 6edd6341-9d1f-478c-b56c-c1fd1de05bb3
md"Vzdálenost elektrod je pevná a v metrech činí:"

# ╔═╡ 8562d85a-c83e-4dda-bedc-d3f168a6a8e6
d = 1.0e-3  # [m]

# ╔═╡ 6e671f64-2154-4d90-85f5-49faf5f471f9
md"""
Dokud nehoří výboj, považujeme elektrické pole mezi elektrodami
za homogenní a jeho intenzitu můžeme určit podle vztahu:

$$E = \frac{U}{d + 2\frac{d_d}{\epsilon}}$$

kde $d$ je šířka mezery, $t$ je tloušťka každé z dielektrických bariér
a $\epsilon$ je jejich permitivita.
Bariéru tvoří podložní sklíčka o tloušťce 1,1 mm:
"""

# ╔═╡ c34e42c6-5042-46e9-b945-0476e6ecef9b
d_d = 1.1e-3;  # [m]

# ╔═╡ 59717cac-ea2d-4f11-880d-c0db8e7011dd
md"""
Jejich permitivita byla Martinou stanovena na 4.7:
"""

# ╔═╡ d4582726-d248-4a90-96a7-f4abd5b21b80
ϵ = 4.7

# ╔═╡ 5e53f5b5-ff41-41cb-a3a5-a60038c8c8f7
reference_field(U) = U ./ (d + 2 * d_d/ϵ)

# ╔═╡ 4a0404ae-46e7-4398-a31d-19998b0132da
E = reference_field(Ud)

# ╔═╡ 2004ff82-d8bc-4ea4-ba8a-186efe12f8a5
md"""
Na základě dřívějšího vyhodnocení tvaru odezvy (porovnání extrému a integrálu)
bylo rozhodnuto, že za referenční hodnotu poslouží prostý extrém signálu
stejně dobře jako jeho integrál.
Intenzitu odezvy E-FISH tedy pro jednoduchost určíme jako extrém signálu.
"""

# ╔═╡ 12730d22-ba1c-4fa3-9240-b1740315211a
efish = [-minimum(x.efish[2]) for x in calibration]

# ╔═╡ 1e193865-c02d-4782-9bf4-1031287d9ec1
md"""
Takto určená intenzita E-FISH je pro jednotlivá napětí zde:
"""

# ╔═╡ 535b799a-b1e4-4761-af75-8953cba1ab2d
with(legend = :none) do
	scatter(Ud, efish, markersize = 6)
	xlabel!("\$U_d\$ [V]")
	ylabel!("\$I\$ [a.u.]")
end

# ╔═╡ b3a5d91a-0195-45d9-b29d-5ee55b9e43a4
with(legend = :none) do
	scatter(Ud.^2, efish, markersize = 6)
	xlabel!("\$U_d^2\$ [V2]")
	ylabel!("\$I\$ [a.u.]")
end

# ╔═╡ 876c5625-d10b-40af-b032-e5acd192d894
md"""
Po přepočtení napětí na intenzitu elektrického pole:
"""

# ╔═╡ c82f6174-9f76-4aed-8fb2-10731c0a3628
with(legend = :none) do
	scatter(E, efish, markersize = 6)
	xlabel!("\$E\$ [V/m]")
	ylabel!("\$I\$ [a.u.]")
end

# ╔═╡ 09bb19e9-d7c4-434e-bffd-39eccf28bc6e
md"""
Signál (v souladu s předpokladem) parabolicky roste s napětím.
Ve vyšších napětích (zhruba od $$U_d$$ = 5 kV) je tato závislost porušena.
Pozorování reaktoru potvrdilo, že tato oblast odpovídá zapálenému výboji.

Pro kalibraci byla použita jen závislost v oblasti bez hořícího výboje:
"""

# ╔═╡ aaed6db3-1865-4947-8996-28cf291981ee
s = Ud .< 5000

# ╔═╡ 81aeb72e-5eb0-44b3-84ba-e64627c43423
md"""
Tato závislost bude proložena modelovou funkcí,
která při dalších měřeních umožní zpětný přepočet signálu E-FISH
na intenzitu elektrického pole.
"""

# ╔═╡ 2a850e6a-68ee-48bd-83b6-e233f99a14c6
md"""
## Lineární model
Body zbylé po odstranění hodnot odpovídajících hořícímu výboji
byly proloženy polynomem druhého stupně metodou nejmenších čtverců:
"""

# ╔═╡ 1bd3a07e-f592-4099-878b-587805e68004
function calibration_linear(E, Iefish)
	a, b, c = [E.^2 E ones(length(E))] \ Iefish
	calib_l(E) = a*E^2 + b*E + c
	(a, b, c), calib_l
end

# ╔═╡ 38aa525f-a59b-4bad-aaab-0fbad160a3ff
(a, b, c), calib_l = calibration_linear(E[s], efish[s])

# ╔═╡ ad0486f8-f6a8-413b-8dff-02d4b2360329
md"""
Tím byla získána následující funkční závislost:
"""

# ╔═╡ 90751086-2f45-4bb7-84c7-1d1b87f9b241
latexstring("🐟 = $(round(a*1e14, sigdigits=3))\\cdot10^{-14}E^2 + $(round(b*1e7, sigdigits=3))\\cdot10^{-7}E + $(round(c, sigdigits=3))")

# ╔═╡ 5a19ff01-e7a5-4ede-b569-a10e08e29a42
md"""
## Nelineární model
Předpokládaná závislost má ve skutečnosti tvar:

$$🐟 = p (E + q)^2$$

(vrchol paraboly se tedy nachází na vodorovné ose).
Parametry tohoto modelu byly nalezeny nelineární metodou nejmenších čtverců,
s výchozími hodnotami spočtenými podle předchozího modelu:
"""

# ╔═╡ e83da9e3-f27d-4848-842d-901a21ec9a51
function calibration_nonlinear(E, Iefish; β0 = [])
	if isempty(β0)
		(a, b, c), _ = calibration_linear(E, Iefish)
		β0 = [a; b/(2a)]
	end

	# Fit the data
	calib(E, β) = β[1] .* (E .+ β[2]).^2
	fit = curve_fit(calib, E, Iefish, β0)
	p, q = fit.param

	# Model function
	calib(E) = calib(E, fit.param)

	# Reverse model function
	elfield(efish; left_branch=false) = if left_branch
		-sqrt(efish/p) - q
	else
		sqrt(efish/p) - q
	end

	p, q = fit.param
	(; p, q, calib, elfield)
end

# ╔═╡ ce4be157-807c-4324-b09d-fb7c253317cc
calib_example = calibration_nonlinear(E[s], efish[s], β0=[a; b/(2a)])

# ╔═╡ f451d831-6eb7-4317-8fc2-ce7f29515bb5
md"""
Výsledná závislost je tato:
"""

# ╔═╡ c39dddb1-0371-42b7-a5a3-2e38c9bba4e0
latexstring("""
🐟 = $(round(calib_example.p*1e14, sigdigits=3))\\cdot10^{-14}
(E + $(round(calib_example.q*1e-5, sigdigits=3))\\cdot10^{5})^2
""")

# ╔═╡ 672cd756-20bd-4421-abf0-8a02e3ba901f
md"""
## Porovnání
Oba modely se dobře shodují, rozdíl mezi nimi je nepostřehnutelný:
"""

# ╔═╡ 929bb8a5-5464-495c-92dc-c57ac81068d2
with(legend = :topleft) do
	scatter(E, efish, label = "naměřená data", markersize = 6)
	plot!(calib_l, color = 1, label = "lineární model")
	plot!(calib_example.calib, color = 2, label = "nelineární model")
	xlabel!("E [V/m]")
	ylabel!("I [a.u.]")
end

# ╔═╡ 754553fc-c996-47ec-9195-d7841a28af20
md"""
Výsledná kalibrační funkce je inverze získaného modelu opravená tak,
aby nevracela záporné hodnoty intenzity $E$:
"""

# ╔═╡ 664f233b-0b35-4d95-b832-6475e97f3ab7
calib_example.elfield

# ╔═╡ 141ffd5e-315a-4718-9da7-333793698511
with(legend = :none) do
	plot(calib_example.elfield)
	xlabel!("I [a.u.]")
	ylabel!("E [V/m]")
end

# ╔═╡ Cell order:
# ╟─ad1ee392-40a9-4711-8771-20173bde62d5
# ╠═62484b61-c048-4e22-b14a-e44c22b58fec
# ╟─3f209503-07a9-46c6-b41a-585c2d57d814
# ╠═5f5e7440-d895-44de-b115-f33b7a61bb13
# ╟─aba36890-2bfd-4e8a-be4c-9ac5b741012c
# ╠═7f24764f-1299-43a4-85f4-caa2b82cdb0c
# ╟─77aea516-8998-4745-9999-74bbbb362a1f
# ╠═ada7162b-c6de-4fe6-b772-18e56e1760f0
# ╟─7e6a0eb4-c8da-416f-83b2-f09ecf3833b2
# ╟─f9baabe8-c809-4061-8e23-a2654d6adf04
# ╠═37331088-c330-4c9b-8ddd-2b773bfd59b1
# ╟─b07fcef5-e4e1-4e8c-b57d-6f0d5f346784
# ╠═8413b7b1-32da-46e5-93f4-23ad83379666
# ╟─2acaa8f7-f074-4973-b86b-ef1fe38de3c9
# ╠═b76d27c5-70d1-469c-a883-34f63578343f
# ╟─305b5ef0-feb7-4490-9efb-ff33b5024a62
# ╠═b1eebdae-591b-4064-aede-2c1c0e84edd0
# ╟─98fad782-ecdd-491e-9ab4-03702b9679a5
# ╠═b3276e7d-977c-4de6-b36a-44c043f22ffe
# ╟─e6db65b3-2e6d-4313-8a2f-785a63b9b61b
# ╠═2cfa5484-3ad6-45f1-aea2-a5476c676587
# ╟─58a6bb5a-5ec1-4b14-89e3-1bdf1c6f2fb5
# ╠═eea4bf6d-1409-4f52-b577-b4e6e3e56aa4
# ╟─dd961d3e-d15f-4668-86e9-a4f71ef80a6d
# ╠═5c481058-7db3-4acb-8924-c1983d6b284a
# ╟─804fcb70-4875-436e-9783-5bc28219b571
# ╠═3bc61c71-b563-4fb4-a33a-c70826b22417
# ╟─74b7b696-67ca-4a6c-8eec-82d8cd7a1cb2
# ╠═81e003ac-028f-4787-a593-bd7efd9e98bb
# ╟─7476cbae-0d64-4aca-b02c-20842ca44322
# ╠═0e6a3c6a-0ca0-4924-a83a-2e1d4c309b21
# ╟─6edd6341-9d1f-478c-b56c-c1fd1de05bb3
# ╠═8562d85a-c83e-4dda-bedc-d3f168a6a8e6
# ╟─6e671f64-2154-4d90-85f5-49faf5f471f9
# ╠═c34e42c6-5042-46e9-b945-0476e6ecef9b
# ╟─59717cac-ea2d-4f11-880d-c0db8e7011dd
# ╠═d4582726-d248-4a90-96a7-f4abd5b21b80
# ╠═5e53f5b5-ff41-41cb-a3a5-a60038c8c8f7
# ╠═4a0404ae-46e7-4398-a31d-19998b0132da
# ╟─2004ff82-d8bc-4ea4-ba8a-186efe12f8a5
# ╠═12730d22-ba1c-4fa3-9240-b1740315211a
# ╟─1e193865-c02d-4782-9bf4-1031287d9ec1
# ╠═535b799a-b1e4-4761-af75-8953cba1ab2d
# ╠═b3a5d91a-0195-45d9-b29d-5ee55b9e43a4
# ╟─876c5625-d10b-40af-b032-e5acd192d894
# ╠═c82f6174-9f76-4aed-8fb2-10731c0a3628
# ╟─09bb19e9-d7c4-434e-bffd-39eccf28bc6e
# ╠═aaed6db3-1865-4947-8996-28cf291981ee
# ╟─81aeb72e-5eb0-44b3-84ba-e64627c43423
# ╟─2a850e6a-68ee-48bd-83b6-e233f99a14c6
# ╠═1bd3a07e-f592-4099-878b-587805e68004
# ╠═38aa525f-a59b-4bad-aaab-0fbad160a3ff
# ╟─ad0486f8-f6a8-413b-8dff-02d4b2360329
# ╟─90751086-2f45-4bb7-84c7-1d1b87f9b241
# ╟─5a19ff01-e7a5-4ede-b569-a10e08e29a42
# ╠═e83da9e3-f27d-4848-842d-901a21ec9a51
# ╠═ce4be157-807c-4324-b09d-fb7c253317cc
# ╟─f451d831-6eb7-4317-8fc2-ce7f29515bb5
# ╟─c39dddb1-0371-42b7-a5a3-2e38c9bba4e0
# ╟─672cd756-20bd-4421-abf0-8a02e3ba901f
# ╠═929bb8a5-5464-495c-92dc-c57ac81068d2
# ╟─754553fc-c996-47ec-9195-d7841a28af20
# ╠═664f233b-0b35-4d95-b832-6475e97f3ab7
# ╠═141ffd5e-315a-4718-9da7-333793698511
