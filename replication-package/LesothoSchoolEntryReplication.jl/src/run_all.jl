function run_all()

    #################################################
    # PATHS
    #################################################

    REPLICATION_ROOT = normpath(
        joinpath(@__DIR__, "..", "..")
    )

    ORIGINAL = joinpath(
        REPLICATION_ROOT,
        "original-replication"
    )

    RAW_DATA = joinpath(ORIGINAL, "Raw_data")

    MICS_DATA = joinpath(RAW_DATA, "MICS")

    OUTPUT = joinpath(@__DIR__, "..", "output")

    FIGURES = joinpath(OUTPUT, "figures")

    mkpath(FIGURES)

    #################################################
    # LOAD CODE
    #################################################

    include(joinpath(@__DIR__, "..", "src", "figures.jl"))

    #################################################
    # RUN
    #################################################

    println("===================================")
    println("RUNNING FIGURE REPLICATION")
    println("===================================")

    figure_school_entry_mics(MICS_DATA, FIGURES)

    println("===================================")
    println("DONE")
    println("===================================")

end