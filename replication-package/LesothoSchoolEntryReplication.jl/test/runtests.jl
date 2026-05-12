using TestItemRunner
using LesothoSchoolEntryReplication
 
@run_package_tests
 
# ---------------------------------------------------------------------------
# 1. La funzione ritorna un oggetto Plots.Plot senza errori
# ---------------------------------------------------------------------------
@testitem "figure_maternal_education restituisce un Plot" begin
    using LesothoSchoolEntryReplication
    using DataFrames, Plots, Random
 
    Random.seed!(42)
    n = 12 * 20
    df = DataFrame(
        birthmo_child = Vector{Union{Missing,Int}}(repeat(1:12, inner=20)),
        brthord       = Vector{Union{Missing,Int}}(ones(Int, n)),
        momsec        = Vector{Union{Missing,Float64}}(rand(n) .* 0.4 .+ 0.4),
    )
 
    p = figure_maternal_education(df)
    @test p isa Plots.Plot
end
 
# ---------------------------------------------------------------------------
# 2. Solo primogeniti (brthord == 1) vengono usati
# ---------------------------------------------------------------------------
@testitem "figure_maternal_education usa solo primogeniti" begin
    using LesothoSchoolEntryReplication
    using DataFrames, Plots, Random
 
    Random.seed!(42)
    n = 12 * 20
    df_base = DataFrame(
        birthmo_child = Vector{Union{Missing,Int}}(repeat(1:12, inner=20)),
        brthord       = Vector{Union{Missing,Int}}(ones(Int, n)),
        momsec        = Vector{Union{Missing,Float64}}(rand(n) .* 0.4 .+ 0.4),
    )
 
    # Aggiungiamo secondogeniti con momsec impossibile: se inclusi il plot cambierebbe
    df_extra = copy(df_base[1:60, :])
    df_extra.brthord .= 2
    df_extra.momsec  .= 9999.0
    df_mixed = vcat(df_base, df_extra)
 
    p_base  = figure_maternal_education(df_base)
    p_mixed = figure_maternal_education(df_mixed)
 
    @test ylims(p_base) == ylims(p_mixed)
end
 
# ---------------------------------------------------------------------------
# 3. Righe con birthmo_child missing vengono scartate senza crash
# ---------------------------------------------------------------------------
@testitem "figure_maternal_education scarta righe con birthmo_child missing" begin
    using LesothoSchoolEntryReplication
    using DataFrames, Plots, Random
 
    Random.seed!(42)
    n = 12 * 20
    df = DataFrame(
        birthmo_child = Vector{Union{Missing,Int}}(repeat(1:12, inner=20)),
        brthord       = Vector{Union{Missing,Int}}(ones(Int, n)),
        momsec        = Vector{Union{Missing,Float64}}(rand(n) .* 0.4 .+ 0.4),
    )
 
    df_miss = copy(df[1:10, :])
    df_miss.birthmo_child .= missing
    df_with_miss = vcat(df, df_miss)
 
    @test_nowarn figure_maternal_education(df_with_miss)
end
 
# ---------------------------------------------------------------------------
# 4. Esattamente 12 punti scatter (uno per mese)
# ---------------------------------------------------------------------------
@testitem "figure_maternal_education produce esattamente 12 punti" begin
    using LesothoSchoolEntryReplication
    using DataFrames, Plots, Random
 
    Random.seed!(42)
    n = 12 * 30
    df = DataFrame(
        birthmo_child = Vector{Union{Missing,Int}}(repeat(1:12, inner=30)),
        brthord       = Vector{Union{Missing,Int}}(ones(Int, n)),
        momsec        = Vector{Union{Missing,Float64}}(rand(n) .* 0.4 .+ 0.4),
    )
 
    p  = figure_maternal_education(df)
    xs = p.series_list[1][:x]
 
    @test length(xs) == 12
    @test sort(collect(xs)) == collect(1:12)
end
 
# ---------------------------------------------------------------------------
# 5. I valori y (medie di momsec) stanno in [0, 1]
# ---------------------------------------------------------------------------
@testitem "figure_maternal_education valori y nel range [0,1]" begin
    using LesothoSchoolEntryReplication
    using DataFrames, Plots, Random
 
    Random.seed!(42)
    n = 12 * 50
    df = DataFrame(
        birthmo_child = Vector{Union{Missing,Int}}(repeat(1:12, inner=50)),
        brthord       = Vector{Union{Missing,Int}}(ones(Int, n)),
        momsec        = Vector{Union{Missing,Float64}}(rand(n) .* 0.4 .+ 0.4),
    )
 
    p  = figure_maternal_education(df)
    ys = p.series_list[1][:y]
 
    @test all(0.0 .<= ys .<= 1.0)
end
 
# ---------------------------------------------------------------------------
# 6. La vline tratteggiata a x = 6.5 è presente
# ---------------------------------------------------------------------------
@testitem "figure_maternal_education ha la vline a 6.5" begin
    using LesothoSchoolEntryReplication
    using DataFrames, Plots, Random
 
    Random.seed!(42)
    n = 12 * 20
    df = DataFrame(
        birthmo_child = Vector{Union{Missing,Int}}(repeat(1:12, inner=20)),
        brthord       = Vector{Union{Missing,Int}}(ones(Int, n)),
        momsec        = Vector{Union{Missing,Float64}}(rand(n) .* 0.4 .+ 0.4),
    )
 
    p = figure_maternal_education(df)
    vline_series = filter(s -> s[:linestyle] == :dash, p.series_list)
 
    @test length(vline_series) >= 1
    @test any(s -> 6.5 in s[:x], vline_series)
end
 
# ---------------------------------------------------------------------------
# 7. DataFrame vuoto → errore esplicito
# ---------------------------------------------------------------------------
@testitem "figure_maternal_education con DataFrame vuoto lancia errore" begin
    using LesothoSchoolEntryReplication
    using DataFrames
 
    df_empty = DataFrame(
        birthmo_child = Union{Missing,Int}[],
        brthord       = Union{Missing,Int}[],
        momsec        = Union{Missing,Float64}[],
    )
 
    @test_throws Exception figure_maternal_education(df_empty)
end