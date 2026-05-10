using DataFrames
using Statistics
using ReadStatTables
using Plots
using Plots.PlotMeasures

function mean_se(x)
    vals = collect(skipmissing(x))
    n = length(vals)
    n == 0 && return (y = missing, se_y = missing)
    n == 1 && return (y = vals[1], se_y = 0.0)
    m = mean(vals)
    se = std(vals) / sqrt(n)
    return (y = m, se_y = se)
end

function figure_school_entry_mics_A(MICS_DATA)

    println("Running Figure 1A...")

    df = DataFrame(readstat(joinpath(MICS_DATA, "mics6hl.dta")))

    df.birthyr      = Vector{Union{Missing,Int}}(df.birthyr)
    df.birthmoyr    = Vector{Union{Missing,Int}}(df.birthmoyr)
    df.grade1ormore = Vector{Union{Missing,Float64}}(df.grade1ormore)

    filter!(row -> !ismissing(row.birthyr) && 2011 <= row.birthyr <= 2013, df)

    gdf = combine(
        groupby(df, :birthmoyr),
        :grade1ormore => mean_se => AsTable
    )

    sort!(gdf, :birthmoyr)

    gdf.yu   = gdf.y .+ 1.96 .* gdf.se_y
    gdf.yl   = gdf.y .- 1.96 .* gdf.se_y
    gdf.rank = 1:nrow(gdf)

    # Build x-tick labels matching Stata: "Jan 2011" ... "Dec 2013"
    months   = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
    xlabels  = String[]
    for yr in 2011:2013
        for mo in months
            push!(xlabels, "$mo $yr")
        end
    end
    # Only keep the 36 labels that correspond to actual ranks
    xlabels = xlabels[1:36]

    p = scatter(
        gdf.rank,
        gdf.y,
        xlabel        = "Month and year of birth",
        ylabel        = "Probability currently attending grade 1 or higher",
        legend        = false,
        title         = "(a) Entry into primary school",
        xticks        = (1:36, xlabels),
        xrotation     = 90,
        tickfontsize  = 5,
        xlims         = (0, 37),
        ylims         = (-0.05, 1.05),
        markercolor   = :steelblue,
        markersize    = 4,
        grid          = true,
        left_margin   = 10mm,
        bottom_margin = 20mm,
    )

    # Error bars (rcap equivalent)
    for i in 1:nrow(gdf)
        plot!(
            [gdf.rank[i], gdf.rank[i]],
            [gdf.yl[i], gdf.yu[i]],
            lw    = 1,
            color = :steelblue,
            label = false
        )
    end

    # Vertical line at 18.5 (between Jun 2012 and Jul 2012)
    vline!([18.5], color = :black, lw = 1, linestyle = :dash, label = false)

    println("Figure 1A completed.")
    return p
end


function figure_school_entry_mics_B(MICS_DATA)

    println("Running Figure 1B...")

    df = DataFrame(readstat(joinpath(MICS_DATA, "mics6hl.dta")))

    df.birthmo = Vector{Union{Missing,Int}}(df.birthmo)
    df.grade   = Vector{Union{Missing,Int}}(df.grade)
    df.grade_r = Vector{Union{Missing,Int}}(df.grade_r)
    df.schage  = Vector{Union{Missing,Float64}}(df.schage)

    filter!(row ->
        coalesce(row.grade == 1, false) &&
        coalesce(row.grade_r == 0, false),
        df
    )

    gdf = combine(
        groupby(df, :birthmo),
        :schage => mean_se => AsTable
    )

    sort!(gdf, :birthmo)

    gdf.yu = gdf.y .+ 1.96 .* gdf.se_y
    gdf.yl = gdf.y .- 1.96 .* gdf.se_y

    month_labels = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]

    p = scatter(
        gdf.birthmo,
        gdf.y,
        xlabel        = "Month of birth",
        ylabel        = "Age at beginning of school year (years)",
        legend        = false,
        title         = "(b) Average age at entry into grade 1",
        xticks        = (1:12, month_labels),
        xrotation     = 45,
        tickfontsize  = 6,
        xlims         = (0, 13),
        ylims         = (5.0, 6.35),
        yticks        = ([5.0, 5.25, 5.5, 5.75, 6.0, 6.25],
                         ["5", "5.25", "5.5", "5.75", "6", "6.25"]),
        markercolor   = :steelblue,
        markersize    = 4,
        grid          = true,
        left_margin   = 10mm,
        bottom_margin = 15mm,
    )

    # Error bars
    for i in 1:nrow(gdf)
        plot!(
            [gdf.birthmo[i], gdf.birthmo[i]],
            [gdf.yl[i], gdf.yu[i]],
            lw    = 1,
            color = :steelblue,
            label = false
        )
    end

    # Vertical line at 6.5 (between Jun and Jul)
    vline!([6.5], color = :black, lw = 1, linestyle = :dash, label = false)

    println("Figure 1B completed.")
    return p
end


function run_figure1(MICS_DATA, FIGURES)

    pA = figure_school_entry_mics_A(MICS_DATA)
    pB = figure_school_entry_mics_B(MICS_DATA)

    # Combine side by side, matching Stata's graph combine col(2)
    combined = plot(
        pA, pB,
        layout      = (1, 2),
        size        = (900, 600),
        dpi         = 100,
        left_margin = 12mm,
    )

    savefig(combined, joinpath(FIGURES, "MOB_and_SchoolEntry.png"))

    println("Figure 1 (A + B) saved as JPG.")
end