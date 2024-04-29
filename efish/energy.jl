### A Pluto.jl notebook ###
# v0.19.38

using Markdown
using InteractiveUtils

# ╔═╡ 4f7cb0ef-c9c9-4d84-91d0-2e261836c03d
# ╠═╡ show_logs = false
begin
	import Pkg
	Pkg.activate(Base.current_project())
	Pkg.instantiate()

	using DelimitedFiles
	using Printf
	using Statistics

	using ImportKeysightBin
	using LaTeXStrings
	using NumericalIntegration
	using Plots
end

# ╔═╡ 16167ec8-0a91-4a41-ac66-45349cf2df65
md"""
# Tvar odezvy
Před dalším měřením je nutno zjistit, zdali je tvar odezvy EFISH výrazně závislý
na energii laserového pulzu.
Výboj nehoří, mezi elektrodami je napětí $U = 2\,\mathrm{V}$.
Energie laseru je postupně měněna od cca 1 do 6 mJ.
"""

# ╔═╡ 3c6e7861-8a34-44ad-9af4-fd33e0355293
begin
	index = readdlm("data-22-01-24/energie_info.txt", skipstart = 12)
	index = index[isa.(index[:,1], Number),:]  # Remove commented-out lines

	Xraw = NamedTuple[]
	for (power, amp, oscilo) in eachrow(index)
		powfile = @sprintf("data-22-01-24/powermeter/571777_%02d.txt", power)
		powdata = readdlm(powfile, skipstart = 36)
		Epulse = mean(powdata[:,2])  # Pulse energy
		oscfile = @sprintf("data-22-01-24/oscilo/energie_napeti/energie%02d.bin", oscilo)
		U, efish, I, fd, meta = importkeysightbin(oscfile)
		efish_peak = -minimum(efish[2])  # Extremum of efish signal (absolute value)
		push!(Xraw, (; U, efish, efish_peak, I, fd, Epulse))
	end
end

# ╔═╡ cbedfbb1-35d2-43b7-8003-350a0204a38e
with(legend = :bottomright) do
	plot()
	xlabel!("t [ns]")
	ylabel!("efish [a.u.]")
	xlims!((48.5, 51))
	title!("Odezva EFISH pro různé energie pulzu\n(naměřená)")
	for x in Xraw
		plot!(x.efish[1].*1e9, x.efish[2],
			label = @sprintf("%.2f mJ", x.Epulse*1e3))
	end
	current()
end

# ╔═╡ 7422b5c2-0c6d-47bd-a1bf-db000847e0f6
md"""
Některá data se zdají být posunuta vůči ostatním.
Zprůměrujeme tedy intenzitu před začátkem pulzu a tuto hodnotu
v celém odečteme v celém intervalu jako pozadí.
"""

# ╔═╡ d0d0a9bb-2fd4-4aa5-a9c4-3ebc73c14dab
Xcorr = map(Xraw) do x
	m = x.efish[1] .< 49.2e-9
	background = mean(x.efish[2][m])
	efish = (x.efish[1], x.efish[2] .- background)
	efish_peak = -minimum(efish[2])
	(; x.U, efish, efish_peak, x.I, x.fd, x.Epulse)
end

# ╔═╡ d57a92fa-af3d-4063-afac-96211cc23a25
with(legend = :bottomright) do
	plot()
	xlabel!("t [ns]")
	ylabel!("efish [a.u.]")
	xlims!((48.5, 51))
	title!("Odezva EFISH pro různé energie pulzu\n(bez pozadí)")
	for x in Xcorr
		plot!(x.efish[1].*1e9, x.efish[2],
			label = @sprintf("%.2f mJ", x.Epulse*1e3))
	end
	current()
end

# ╔═╡ b2f01251-e63a-469f-9b8a-d1c48728876b
md"""
## Normalizovaná odezva
Pro snazší porovnání tvaru byla každá odezva dělena svou maximální hodnotou.
Zdá se, že průběh hlavního pulzu odpovídá, a díky odečtení pozadí také
základní signál.
Největší rozdíly jsou patrny v poklesové části pulzu.
"""

# ╔═╡ 6465f45d-a08f-4444-9fd4-441c4acf6921
with(legend = :bottomright) do
	plot()
	xlabel!("t [ns]")
	ylabel!("efish [a.u.]")
	xlims!((48.5, 51))
	title!("Normalizovaná odezva EFISH")
	for x in Xcorr
		plot!(x.efish[1].*1e9, x.efish[2]./x.efish_peak,
			label = @sprintf("%.2f mJ", x.Epulse*1e3))
	end
	current()
end

# ╔═╡ a404dd8c-5d13-4a1b-b84d-8d9e6000aa94
md"""
Dále pracujme s normalizovanými daty:
"""

# ╔═╡ 466cea63-bbf4-4334-8257-177f228002b5
X = Xcorr

# ╔═╡ b575c692-13fe-49d7-b515-c37aa6d8f34f
md"""
# Intenzita odezvy
Dále je nutno najít vhodný parametr pro popis intenzity odezvy EFISH.
Nabízí se její integrál, ale v úvahu připadá také prostý extrém signálu.
Pro vyhodnocení byla použita data uvedená výše.
"""

# ╔═╡ 415ee871-bd26-4e11-bf73-422800b04f47
md"""
## Maximální hodnota
Níže jsou vynesena maxima signálu EFISH proti energii pulzu z výše uvedeného měření.
Spodní větev odpovídá zvyšování energie, prudký skok značí zapálení výboje.
Horní větev je opačný proces: snižování energie a následné zhasnutí výboje.
"""

# ╔═╡ 0a2d69cb-e8e5-4f9d-acbc-4440a5f63f50
Epulse = [x.Epulse for x in X]

# ╔═╡ b245859c-7519-4825-ba16-d654ed3fce24
efish_peak = [x.efish_peak for x in X]

# ╔═╡ 6a82cf94-1707-468b-8c85-c101ec82b138
with(legend = :none) do
	plot(Epulse*1e3, efish_peak; markershape = :circle)
	title!("Intenzita EFISH podle maximální hodnoty")
	xlabel!(L"E_\mathrm{laser}")
	ylabel!(L"\max(I)\ [\mathrm{a.u.}]")
end

# ╔═╡ 70472573-f8e8-4230-8c77-42087b4f84e8
md"""
## Integrál
Podobný graf pro integrál celého signálu je níže.
Průběh odpovídá extrémům jen vzdáleně.

Je ovšem nutno upozornit, že integrál byl pro jednoduchost počítán
z celých datových sad.
Omezit integrační interval na oblast kolem pulzu by mohlo výsledky
trochu změnit, snad k lepšímu.
"""

# ╔═╡ 97a59953-1e19-48b6-a4c6-4029eddbb236
efish_int = [-integrate(x.efish...)[1] for x in X]

# ╔═╡ 35266884-6576-4517-a495-97bfc77401f1
with(legend = :none) do
	plot(Epulse*1e3, efish_int*1e8; markershape = :circle, markersize = 4)
	title!("Intenzita EFISH podle integrálu")
	xlabel!(L"E_\mathrm{laser}")
	ylabel!(L"\int(I)\mathrm{d}t\ [\mathrm{a.u.}]")
end

# ╔═╡ 635fb8b5-16ac-406b-bc99-977fb1a7519e
md"""
## Korelace obou parametrů
Níže je vykreslena vzájemná závislost maxima signálu a jeho integrálu.
Korelace je velmi vysoká, při dalším zpracování tedy postačí jako referenční
hodnotu signálu E-FISH brát jeho maximum.
"""

# ╔═╡ bfb0a570-4aa4-461f-a47c-e7d10840799a
with(legend = :none, markeralpha = 0.5) do
	plot(efish_peak, efish_int*1e8, markershape = :circle, markeralpha = 0.5)
	title!("Porovnání maxima a integrálu EFISH")
	xlabel!(L"\max(I)\ [\mathrm{a.u.}]")
	ylabel!(L"\int(I)\mathrm{d}t\ [\mathrm{a.u.}]")
end

# ╔═╡ aa8a6929-02f8-4035-8caa-8effc6e5b94b
md"""
# Závislost na energii laseru
Na závěr je porovnána intenzita E-FISH na energii laseru určenou dvěma způsoby:
Z měřiče výkonu a z integrálu signálu fotodiody.
"""

# ╔═╡ a698dbd3-49ab-4bb7-aad1-ba3332bb2c30
md"Z měřiče výkonu:"

# ╔═╡ 348b66a1-2c77-4df1-9845-69ad003bd08d
with(legend = :none) do
	plot()
	local Epulse = [x.Epulse for x in X]
	local efish = [x.efish for x in X]
	plot(Epulse.^2*1e6, efish_peak, markershape=:circle)
	xlabel!(L"E_\mathrm{laser}^2")
	ylabel!(L"I\ [\mathrm{a.u.}]")
end

# ╔═╡ 0028c9c4-7b9e-4a8e-aef7-bcc3037178e2
md"Z fotodiody:"

# ╔═╡ e0a1a2ab-f3f3-4e21-a337-f4c896abc518
Xen = map(X) do x
	Epulse_fd = integrate(x.fd...)[1]
	(; x..., Epulse_fd)
end

# ╔═╡ d7c60c6c-03bd-48ed-acc0-f9c7e461d023
with(legend = :none) do
	plot()
	local Epulse_fd = [x.Epulse_fd for x in Xen]
	local efish = [x.efish for x in Xen]
	plot(Epulse_fd.^2*1e20, efish_peak, markershape=:circle)
	xlabel!(L"E_\mathrm{fd}^2")
	ylabel!(L"I\ [\mathrm{a.u.}]")
end

# ╔═╡ Cell order:
# ╟─16167ec8-0a91-4a41-ac66-45349cf2df65
# ╠═4f7cb0ef-c9c9-4d84-91d0-2e261836c03d
# ╠═3c6e7861-8a34-44ad-9af4-fd33e0355293
# ╠═cbedfbb1-35d2-43b7-8003-350a0204a38e
# ╟─7422b5c2-0c6d-47bd-a1bf-db000847e0f6
# ╠═d0d0a9bb-2fd4-4aa5-a9c4-3ebc73c14dab
# ╠═d57a92fa-af3d-4063-afac-96211cc23a25
# ╟─b2f01251-e63a-469f-9b8a-d1c48728876b
# ╠═6465f45d-a08f-4444-9fd4-441c4acf6921
# ╟─a404dd8c-5d13-4a1b-b84d-8d9e6000aa94
# ╠═466cea63-bbf4-4334-8257-177f228002b5
# ╟─b575c692-13fe-49d7-b515-c37aa6d8f34f
# ╟─415ee871-bd26-4e11-bf73-422800b04f47
# ╠═0a2d69cb-e8e5-4f9d-acbc-4440a5f63f50
# ╠═b245859c-7519-4825-ba16-d654ed3fce24
# ╠═6a82cf94-1707-468b-8c85-c101ec82b138
# ╟─70472573-f8e8-4230-8c77-42087b4f84e8
# ╠═97a59953-1e19-48b6-a4c6-4029eddbb236
# ╠═35266884-6576-4517-a495-97bfc77401f1
# ╟─635fb8b5-16ac-406b-bc99-977fb1a7519e
# ╠═bfb0a570-4aa4-461f-a47c-e7d10840799a
# ╟─aa8a6929-02f8-4035-8caa-8effc6e5b94b
# ╟─a698dbd3-49ab-4bb7-aad1-ba3332bb2c30
# ╠═348b66a1-2c77-4df1-9845-69ad003bd08d
# ╟─0028c9c4-7b9e-4a8e-aef7-bcc3037178e2
# ╠═e0a1a2ab-f3f3-4e21-a337-f4c896abc518
# ╠═d7c60c6c-03bd-48ed-acc0-f9c7e461d023
