using DataFrames
using Statistics
using ReadStatTables
using Plots

########################################################
# Helper function
########################################################

function mean_se(x)

    vals = collect(skipmissing(x))

    m = mean(vals)
    se = std(vals) / sqrt(length(vals))

    return (
        y = m,
        se_y = se
    )
end

########################################################
# Figure 1A
########################################################

function figure_school_entry_mics(MICS_DATA, FIGURES)

    println("Running Figure 1A...")

    df = DataFrame(
        readstat(joinpath(MICS_DATA, "mics6hl.dta"))
    )

    df.birthyr   = convert(Vector{Union{Missing,Int}}, df.birthyr)
    df.birthmoyr = convert(Vector{Union{Missing,Int}}, df.birthmoyr)

    filter!(
        row -> row.birthyr >= 2011 &&
               row.birthyr <= 2013,
        df
    )

    gdf = combine(
    groupby(df, :birthmoyr),
    :grade1ormore => mean_se => AsTable
    )

    gdf.yu = gdf.y .+ 1.96 .* gdf.se_y
    gdf.yl = gdf.y .- 1.96 .* gdf.se_y

    gdf.rank = 1:nrow(gdf)

    p = scatter(
        gdf.rank,
        gdf.y,
        xlabel = "Month and year of birth",
        ylabel = "Probability attending grade 1+",
        legend = false,
        title = "(a) Entry into primary school",
        xticks = (1:36, string.(1:36))
    )

    plot!(
        gdf.rank,
        gdf.yu,
        seriestype = :scatter,
        markersize = 0
    )

    for i in 1:nrow(gdf)
        plot!(
            [gdf.rank[i], gdf.rank[i]],
            [gdf.yl[i], gdf.yu[i]],
            lw = 1
        )
    end

    savefig(
        p,
        joinpath(FIGURES, "MOB_and_SchoolEntry_panelA.png")
    )

    println("Figure 1A completed.")
end