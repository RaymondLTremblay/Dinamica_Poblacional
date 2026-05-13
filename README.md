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
├── index.qmd                  # Book landing page + Dedicatoria + Prefacio
├── 102-123-*.qmd              # Book chapters (numbered)
├── 117-118_Historia_*.qmd     # Historical chapters (Tamm, etc.)
├── Appendix_A_*.qmd           # Static appendices (species list, data sheets)
├── Apendice_Glosario.qmd      # Glossary (~144 terms)
├── Apendice_Indice_Fig_Tab.qmd  # Auto-generated figure/table index
├── Apendice_Indice_Temas.qmd  # Auto-generated topic/subject index
├── Agradecimientos.qmd        # Acknowledgments
├── _quarto.yml                # Quarto project config
├── _language.yml              # Spanish callout labels (e.g., callout-tip → "Recomendación")
├── book.bib                   # Bibliography (471 entries, peerj CSL)
├── peerj.csl                  # Citation style
├── images/                    # All figures and photos
├── data/                      # Datasets used in examples
├── scripts/                   # Build helpers (see below)
├── figuras_editor/            # Auto-generated: flat dump of figures for the book producer
├── DESCRIPTION                # R package dependencies
├── DinamicaPob.Rproj          # RStudio project file
└── .github/workflows/         # Auto-deploy to GitHub Pages
```

> **Note:** The `docs/` directory is a build artifact excluded from this repository. The book is built and deployed automatically via GitHub Actions.

### Build helpers (`scripts/`)

These run automatically during `quarto render` (configured as `pre-render` / `post-render` hooks in `_quarto.yml`). You don't need to invoke them by hand, but you can:

-   **`scripts/build_topic_index.py`** — regenerates `Apendice_Indice_Temas.qmd` (174 indexed terms drawn from the glossary, mapped to chapter/section appearances).
-   **`scripts/build_index_fig_tab.py`** — regenerates `Apendice_Indice_Fig_Tab.qmd` (52 figures, 7 captioned tables).
-   **`scripts/collect_figures.py`** — after render, copies every figure (static + R-chunk PNG + render_dual diagrams) into `figuras_editor/CC-Chapter_Name/NN_filename.png` for delivery to the book producer.
-   **`scripts/collect-figures.sh`** — shell wrapper around the above.
-   **`scripts/patch-orange-book.sh`** — Typst pagebreak compatibility patch (orange-book extension, Typst 0.13+).

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

# 2. Install R packages (all available on CRAN)
install.packages(c("knitr", "rmarkdown", "tidyverse", "popbio", "popdemo",
                   "Rage", "Rcompadre", "MCMCpack", "leaflet", "flextable",
                   "raretrans", "DiagrammeR", "DiagrammeRsvg", "rsvg",
                   "ggplot2", "dplyr", "janitor", "interpretCI", "gt"))

# 3. Render the book (from terminal at the project root)
#    quarto render               # HTML (default)
#    quarto render --to pdf      # PDF via Typst
```

Python 3 is also required (for the pre-render index scripts). No external Python packages needed — only the standard library.

### What happens during render

1.  **Pre-render** clears `_freeze`, patches Typst, regenerates the topic index and the figure/table index from the current state of the chapters.
2.  **Render** processes every `.qmd` into HTML (or PDF), executing R chunks.
3.  **Post-render** collects every figure produced by the render — markdown images + R-chunk PNGs + render_dual diagrams — into `figuras_editor/`, organized by chapter, for delivery to the book producer.

### Style and editorial conventions

See [`STYLE_GUIDE.md`](STYLE_GUIDE.md) for the editorial decisions applied throughout the book (Spanish vocabulary, citation style, decimal convention, italics rules, etc.).

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
