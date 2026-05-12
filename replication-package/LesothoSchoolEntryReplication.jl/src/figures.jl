using DataFrames
using Statistics
using ReadStatTables
using Plots
using Plots.PlotMeasures


function figure_school_entry_mics_A(df)
    local_df = copy(df)

    local_df.birthyr      = Vector{Union{Missing,Int}}(local_df.birthyr)
    local_df.birthmoyr    = Vector{Union{Missing,Int}}(local_df.birthmoyr)
    local_df.grade1ormore = Vector{Union{Missing,Float64}}(local_df.grade1ormore)

    filter!(row -> !ismissing(row.birthyr) && 2011 <= row.birthyr <= 2013, local_df)

    gdf = combine(groupby(local_df, :birthmoyr),:grade1ormore => mean_se => AsTable)

    sort!(gdf, :birthmoyr)

    gdf.yu   = gdf.y .+ 1.96 .* gdf.se_y
    gdf.yl   = gdf.y .- 1.96 .* gdf.se_y
    gdf.rank = 1:nrow(gdf)

    months = [
        "Jan","Feb","Mar","Apr","May","Jun",
        "Jul","Aug","Sep","Oct","Nov","Dec"
    ]

    xlabels = String[]

    for yr in 2011:2013
        for mo in months
            push!(xlabels, "$mo $yr")
        end
    end

    xlabels = xlabels[1:36]

    p = scatter(
        gdf.rank,
        gdf.y,

        xlabel = "Month and year of birth",
        ylabel = "Probability currently attending grade 1 or higher",

        legend = false,
        title  = "(a) Entry into primary school",

        xticks       = (1:36, xlabels),
        xrotation    = 90,
        tickfontsize = 5,

        xlims = (0, 37),
        ylims = (-0.05, 1.05),

        markercolor = :steelblue,
        markersize  = 4,

        grid = true,

        left_margin   = 10mm,
        bottom_margin = 20mm
    )

    for i in 1:nrow(gdf)

        plot!(
            [gdf.rank[i], gdf.rank[i]],
            [gdf.yl[i], gdf.yu[i]],

            lw    = 1,
            color = :steelblue,
            label = false
        )
    end

    vline!(
        [18.5],

        color = :black,
        lw = 1,
        linestyle = :dash,
        label = false
    )

    return p
end


function figure_school_entry_mics_B(df)
    local_df = copy(df)

    local_df.birthmo = Vector{Union{Missing,Int}}(local_df.birthmo)
    local_df.grade   = Vector{Union{Missing,Int}}(local_df.grade)
    local_df.grade_r = Vector{Union{Missing,Int}}(local_df.grade_r)
    local_df.schage  = Vector{Union{Missing,Float64}}(local_df.schage)

    filter!(row -> coalesce(row.grade == 1, false) && coalesce(row.grade_r == 0, false), local_df)

    gdf = combine(groupby(local_df, :birthmo), :schage => mean_se => AsTable)

    sort!(gdf, :birthmo)

    gdf.yu = gdf.y .+ 1.96 .* gdf.se_y
    gdf.yl = gdf.y .- 1.96 .* gdf.se_y

    month_labels = [
        "Jan","Feb","Mar","Apr","May","Jun",
        "Jul","Aug","Sep","Oct","Nov","Dec"
    ]

    p = scatter(
        gdf.birthmo,
        gdf.y,

        xlabel = "Month of birth",
        ylabel = "Age at beginning of school year (years)",

        legend = false,
        title  = "(b) Average age at entry into grade 1",

        xticks       = (1:12, month_labels),
        xrotation    = 45,
        tickfontsize = 6,

        xlims = (0, 13),
        ylims = (5.0, 6.35),

        yticks = (
            [5.0, 5.25, 5.5, 5.75, 6.0, 6.25],
            ["5", "5.25", "5.5", "5.75", "6", "6.25"]
        ),

        markercolor = :steelblue,
        markersize  = 4,

        grid = true,

        left_margin   = 10mm,
        bottom_margin = 15mm
    )

    for i in 1:nrow(gdf)

        plot!(
            [gdf.birthmo[i], gdf.birthmo[i]],
            [gdf.yl[i], gdf.yu[i]],

            lw    = 1,
            color = :steelblue,
            label = false
        )
    end

    vline!(
        [6.5],

        color = :black,
        lw = 1,
        linestyle = :dash,
        label = false
    )

    return p
end


function run_figure1(df, FIGURES)

    @info "Running Figure 1A"
    pA = figure_school_entry_mics_A(df)

    @info "Running Figure 1B"
    pB = figure_school_entry_mics_B(df)

    combined = plot(pA, pB, layout = (1, 2), size = (900, 600), dpi  = 100, left_margin = 12mm)
    output_path = joinpath(FIGURES, "MOB_and_SchoolEntry.png")

    savefig(combined, output_path)

end

function figure_maternal_education(df_bh)
    local_df = copy(df_bh)

    # Keep only first-born children
    local_df.brthord        = Vector{Union{Missing,Int}}(local_df.brthord)
    local_df.birthmo_child  = Vector{Union{Missing,Int}}(local_df.birthmo_child)
    local_df.momsec         = Vector{Union{Missing,Float64}}(local_df.momsec)

    filter!(row -> coalesce(row.brthord == 1, false) && !ismissing(row.birthmo_child), local_df)

    # Collapse: mean and SE of momsec by birth month
    gdf = combine(groupby(local_df, :birthmo_child), :momsec => mean_se => AsTable)
    sort!(gdf, :birthmo_child)

    gdf.yu = gdf.y .+ 1.96 .* gdf.se_y
    gdf.yl = gdf.y .- 1.96 .* gdf.se_y

    month_labels = [
        "Jan","Feb","Mar","Apr","May","Jun",
        "Jul","Aug","Sep","Oct","Nov","Dec"
    ]

    p = scatter(
        gdf.birthmo_child,
        gdf.y,

        xlabel = "Month of birth of first child",
        ylabel = "Probability mother attained secondary school",

        legend = false,

        xticks       = (1:12, month_labels),
        xrotation    = 0,
        tickfontsize = 7,

        xlims = (0, 13),
        ylims = (0.4, 0.7),
        yticks = ([0.4, 0.5, 0.6, 0.7], ["0.4", "0.5", "0.6", "0.7"]),

        markercolor = :white,
        markerstrokecolor = :gray40,
        markersize  = 4,

        grid = true,
        gridstyle = :dot,
        gridcolor = :gray70,

        framestyle = :box,

        left_margin   = 10mm,
        bottom_margin = 10mm,
        right_margin  = 5mm,
        top_margin    = 5mm,

        size = (700, 450),
        dpi  = 150
    )

    # Confidence interval caps (rcap style)
    for i in 1:nrow(gdf)
        plot!(
            [gdf.birthmo_child[i], gdf.birthmo_child[i]],
            [gdf.yl[i], gdf.yu[i]],
            lw    = 1,
            color = :gray40,
            label = false
        )
        # top cap
        plot!(
            [gdf.birthmo_child[i] - 0.15, gdf.birthmo_child[i] + 0.15],
            [gdf.yu[i], gdf.yu[i]],
            lw = 1, color = :gray40, label = false
        )
        # bottom cap
        plot!(
            [gdf.birthmo_child[i] - 0.15, gdf.birthmo_child[i] + 0.15],
            [gdf.yl[i], gdf.yl[i]],
            lw = 1, color = :gray40, label = false
        )
    end

    # Vertical dashed line between June and July
    vline!(
        [6.5],
        color     = :black,
        lw        = 1,
        linestyle = :dash,
        label     = false
    )

    return p
end


function run_figure3(df_bh, FIGURES)
    @info "Running Figure 3"
    p = figure_maternal_education(df_bh)
    output_path = joinpath(FIGURES, "placebo_maternaleducation.png")
    savefig(p, output_path)
end


function run_all_figures(MICS_DATA, FIGURES)

    include(joinpath(@__DIR__, "..", "src", "utils.jl"))
    df = DataFrame(readstat(joinpath(MICS_DATA, "mics6hl.dta")))

    @info "Creating Figure 1..."
    run_figure1(df, FIGURES)
    @info "Figure 1 completed."

    df_bh = DataFrame(readstat(joinpath(MICS_DATA, "micsbh.dta")))

    @info "Creating Figure 3..."
    run_figure3(df_bh, FIGURES)
    @info "Figure 3 completed."

end