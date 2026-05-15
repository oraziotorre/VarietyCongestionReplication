# Lesotho School Entry Replication

This project was developed as part of the [*Computational Economics*](https://www.carloalberto.org/wp-content/uploads/2025/08/syllabus_ComputationalEconomics.pdf) course at Collegio Carlo Alberto.  

## Overview

This repository replicates the results from the paper:

> De Neve, J.-W., Moshoeshoe, R., & Bor, J. (2026).  
> *Age at School Entry and Human Capital Development: Evidence from Lesotho.*  
> American Economic Journal: Applied Economics.

The paper studies how the age at which children start primary school affects education, labor market outcomes, health, and demographic outcomes in Lesotho, using a regression discontinuity design based on a school entry cutoff.

The goal of this project is to reproduce the main empirical results, figures, and tables using Julia.

The original replication package is available on [OpenICPSR](https://www.openicpsr.org/openicpsr/project/217581/version/V1/view).

---

## Project Structure

```
lesotho-school-entry-replication/
│
├── images/
│
├── replication-package/
│   ├── LesothoSchoolEntryReplication.jl/
│   │   ├── Project.toml
│   │   ├── Manifest.toml
│   │   │
│   │   ├── src/
│   │   │   ├── LesothoSchoolEntryReplication.jl
│   │   │   ├── run_all.jl
│   │   │   ├── figures.jl
│   │   │   ├── tables.jl
│   │   │   └── utils.jl
│   │   │
│   │   ├── test/
│   │   │   └── runtests.jl
│   │   │
│   │   └── output/
│   │       ├── figures/
│   │       └── tables/
│   │
│   └── original-replication/
│
├── report_files/
├── report.qmd
├── report.html
│
├── .gitignore
└── README.md
```

---

## Installation

1. Install Julia (recommended version: **1.12.6**) and verify:

```bash
julia --version
```

2. Clone the repository and run Julia:
```bash
git clone https://github.com/oraziotorre/lesotho-school-entry-replication.git
cd lesotho-school-entry-replication
julia
```

## Running the Replication:

1. Activate the environment:
```julia
using Pkg
Pkg.activate("./replication-package/LesothoSchoolEntryReplication.jl")
```

2. Install the dependencies:
```julia
Pkg.instantiate()
```

3. Run the full replication:
```julia
using LesothoSchoolEntryReplication
run_all()
```

All replicated results are saved in:

```
replication-package/LesothoSchoolEntryReplication.jl/output/
```

Ensure that all required datasets are correctly placed in the `replication-package/original-replication/Raw_data/` folder.
If the data are missing or incomplete, you must first run the original replication using the Stata master script located at:
`replication-package/original-replication/Dofiles/_masterscript.do`

---

## Running Unit Tests

To run the unit tests:

```julia
using Pkg
Pkg.activate("./replication-package/LesothoSchoolEntryReplication.jl")
Pkg.test()
```

---

## Report

The replication report is written using Quarto.
See [https://quarto.org](https://quarto.org) for instructions for how to use quarto.

1. Install Quarto and verify:
```bash
quarto --version
```

2. Compile the report from the project root:
```bash
quarto render report.qmd
```

3. The compiled report will be available as:
- `.html` or `.pdf` in the main folder

---

## Authors

- Orazio Torre — Collegio Carlo Alberto & Politecnico di Torino  
- Dalila Maria Tamburrano — Collegio Carlo Alberto & Politecnico di Torino  
- Dalia Lemmi — Collegio Carlo Alberto & Politecnico di Torino  

---
