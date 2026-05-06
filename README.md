# Replication Project

## Overview

This repository replicates the results from the paper:

> De Neve, J.-W., Moshoeshoe, R., & Bor, J. (2026).  
> *Age at School Entry and Human Capital Development: Evidence from Lesotho.*  
> American Economic Journal: Applied Economics.

The paper studies how the age at which children start primary school affects education, labor market outcomes, health, and demographic outcomes in Lesotho, using a regression discontinuity design based on a school entry cutoff.

The goal of this project is to reproduce the main empirical results, figures, and tables using Julia.

---

## Project Structure

```
.
├── output/             # Replicated figures and tables
├── report/             # Replication report (Quarto)
└── README.md
```

---

## Installation

1. Install Julia (recommended version: 1.x)

2. Clone the repository:
```bash
git clone <your-repo-url>
cd <your-repo-name>
```

3. Install dependencies:
```julia
using Pkg
Pkg.activate(".")
Pkg.instantiate()
```

---

## Running Unit Tests

To run the unit tests:

```julia
using Pkg
Pkg.activate(".")
Pkg.test()
```

---

## Running the Replication

To run the full replication pipeline:

```julia
include("run_all.jl")
run_all()
```

This script performs the following steps:
- loads and cleans the data
- implements the regression discontinuity design (RDD)
- reproduces the main empirical results
- generates figures and tables
- saves outputs in the `output/` folder

---

## Output

All replicated results are saved in:

```
output/
```

This includes:
- Figures (RDD plots, main results)
- Tables (regression outputs)

---

## Report

The replication report is written using Quarto.

### Compile the report

1. Navigate to:
```
report/
```

2. Run:
```bash
quarto render
```

### Report output

The compiled report will be available as:
- `.html` or `.pdf` in the `report/` folder

---

## Methodology

The replication focuses on reproducing the main identification strategy of the paper:

- Regression Discontinuity Design (RDD)
- Cutoff: June 30 school entry rule
- Treatment: being born after the cutoff (starting school later)

Key outcomes include:
- Years of schooling
- Literacy and skills
- Labor market outcomes
- Fertility and marriage
- Health outcomes

---

## Notes

- Ensure all required datasets are correctly placed in the `data/` folder
- The entire pipeline can be executed using `run_all()`
- Results may differ slightly due to data access, cleaning choices, or software differences

---

## Authors

- Orazio Torre — Collegio Carlo Alberto & Politecnico di Torino  
- Dalila Maria Tamburrano — Collegio Carlo Alberto & Politecnico di Torino  
- Dalia Lemmi — Collegio Carlo Alberto & Politecnico di Torino  

---

# CompEcon Project Template 

This is the replication project template. 

## Step Number 1

* Click top right on `use this template`, then `create a new repository`.
* Choose a suitable name for your replication project.
* Clone your new repository to your computer.
* Open this locally in VScode.

(you get a nice preview of this document in VScode by executing command `Markdown: Open preview` - type this into the command 😉 )

This page should contain concise information for how to

1. install your julia package
2. run the unit tests
3. run the replication output (there needs to be a single entry point that runs everything, ideally called `run_all()`)
4. gives instructions for how to compile and where to see your replication [report](report.qmd). See [https://quarto.org](https://quarto.org) for instructions for how to use quarto.

## First steps

1. Copy the original replication package into the folder `replication-package`
2. (optional) follow instructions in `replication-package` to replicate desired exhibits
3. set up your julia package in this repo. To do so, start the julia REPL in this location (alt-J alt-O, otherwise look in command palette)
4. Choose a name for your replication package, for example `XYZ.jl` (choose something better and replace `XYZ` throughout with your choice!)
5. Generate your julia package in this directory with
   
    ```julia
    using Pkg
    Pkg.generate("XYZ.jl")
    ```
6. In the VScode file browser on the left, investigate the newly created directory
7. Activate your package:
   
    ```julia
    julia> Pkg.activate("XYZ.jl")

    # load it
    julia> using XYZ

    # run function
    julia> XYZ.greet()
    Hello World!
    ```
8. Edit the code in `XYZ.jl/src/XYZ.jl`, maybe adding a word to the greet function. Save the file. Call the function again.
   
    ```julia
    julia> XYZ.greet()
    Hello World, Earthlings!
    ```


