# Dinámica Poblacional con Ejemplos de Orquídeas

[![License: CC BY-NC 4.0](https://img.shields.io/badge/License-CC%20BY--NC%204.0-lightgrey.svg)](http://creativecommons.org/licenses/by-nc/4.0/) [![Quarto](https://img.shields.io/badge/Built%20with-Quarto-blue)](https://quarto.org) [![GitHub Pages](https://img.shields.io/badge/Live%20Book-GitHub%20Pages-green)](https://raymondltremblay.github.io/Dinamica_Poblacional)

📖 **Read the book online:** [raymondltremblay.github.io/Dinamica_Poblacional](https://raymondltremblay.github.io/Dinamica_Poblacional)

------------------------------------------------------------------------

## Descripción / About

Este libro digital es una introducción al estudio de la **Dinámica Poblacional** usando R, con ejemplos centrados en orquídeas. Los capítulos están organizados de lo más básico a lo más complejo en la recolección de datos, análisis e interpretación de resultados.

This open digital book introduces **Population Dynamics** using R, with orchid case studies. Chapters progress from foundational concepts to advanced matrix modeling, stochastic simulations, and population viability analysis (PVA).

### Topics covered

-   Life history tables and survival analysis
-   Stage-structured matrix models (Leslie / Lefkovitch)
-   Population growth rate (λ) estimation
-   Elasticity and sensitivity analysis
-   Stochastic simulations and environmental variability
-   Population Viability Analysis (PVA)
-   Spatial and temporal variation
-   COMPADRE database analysis

------------------------------------------------------------------------

## Authors

**Raymond L. Tremblay** (Autor Principal) Universidad de Puerto Rico, Recinto de Humacao, Departamento de Biología

**Co-authors:** - Aucencia Emeterio-Lara — ECOSUR, México - Edgar J. González — UNAM, México - Elaine González — Universidad de Artemisa, Cuba - Mariana Hernández-Apolinar — UNAM, México - Demetria Mondragón — IPN, México - Ernesto Mujíca Benitez — Universidad de Artemisa, Cuba - Paola Portillo Tzompa — UNAM, México - Adriana Ramírez Martínez — IPN, México - Tamara Ticktin — University of Hawaii at Manoa, USA

------------------------------------------------------------------------

## Repository Structure

```         
Dinamica_Poblacional/
├── index.qmd               # Book landing page
├── 102-123-*.qmd           # Book chapters (numbered)
├── _quarto.yml             # Quarto project config
├── images/                 # All figures and photos
├── data/                   # Datasets used in examples
├── DESCRIPTION             # R package dependencies
├── book.bib                # Bibliography
├── DinamicaPob.Rproj       # RStudio project file
└── .github/workflows/      # Auto-deploy to GitHub Pages
```

> **Note:** The `docs/` directory is a build artifact excluded from this repository. The book is built and deployed automatically via GitHub Actions.

------------------------------------------------------------------------

## Building the Book Locally

### Prerequisites

-   [R](https://cran.r-project.org/) \>= 4.5.0
-   [Quarto](https://quarto.org/docs/get-started/) \>= 1.4
-   [RStudio](https://posit.co/download/rstudio-desktop/) (recommended)

### Steps

``` r
# 1. Clone the repo
#    git clone https://github.com/RaymondLTremblay/Dinamica_Poblacional.git

# 2. Install R packages
install.packages("remotes")
remotes::install_github("atyre2/raretrans")
# Install remaining packages from DESCRIPTION
install.packages(c("knitr", "rmarkdown", "tidyverse", "popbio", "popdemo",
                   "Rage", "Rcompadre", "MCMCpack", "leaflet", "flextable"))

# 3. Render the book (from RStudio Terminal)
#    quarto render --to html
```

------------------------------------------------------------------------

## Contributing

Issues and suggestions are welcome via [GitHub Issues](https://github.com/RaymondLTremblay/Dinamica_Poblacional/issues).

------------------------------------------------------------------------

## License

This work is licensed under a [Creative Commons Attribution-NonCommercial 4.0 International License](http://creativecommons.org/licenses/by-nc/4.0/).

[![CC BY-NC 4.0](https://i.creativecommons.org/l/by-nc/4.0/88x31.png)](http://creativecommons.org/licenses/by-nc/4.0/)

------------------------------------------------------------------------

## Citation

If you use this material, please cite:

> Tremblay, R. L., Emeterio-Lara, A., González, E. J., González, E., Hernández-Apolinar, M., Mondragón, D., Mujíca Benitez, E., Portillo Tzompa, P., Ramírez Martínez, A., & Ticktin, T. (2026). *Dinámica Poblacional con Ejemplos de Orquídeas*. GitHub. https://raymondltremblay.github.io/Dinamica_Poblacional
