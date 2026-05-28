# Auditoría de `fig-cap` y `label: fig-*`

Quarto numera figuras consecutivamente sólo cuando un chunk de R/Python que produce figura lleva **tanto** `#| fig-cap: "..."` **como** `#| label: fig-...`. Este reporte lista los chunks que no cumplen ese criterio.


## Resumen

- Total chunks con figura: **98**

- ✓ con cap+label: **95**

- ⚠ con label pero sin fig-cap: **0**

- ⚠ con fig-cap pero sin label fig-*: **0**

- ✗ sin ninguno: **3**


## 103-Ciclos_de_Vida.qmd

| Línea | Label | fig-cap | fig-label | Snippet |
|------:|-------|:-------:|:---------:|---------|
| 16 | `CV1-setup-diagrams` | — | — | `# Carpeta de salida para PNGs. Los png_name pasados a render_dual()` |

## 112-Dinamica_de_Transiciones.qmd

| Línea | Label | fig-cap | fig-label | Snippet |
|------:|-------|:-------:|:---------:|---------|
| 458 | `trans11` | — | — | `abs.plot <- ggplot(data = Population_density) +` |
| 668 | `trans16` | — | — | `trans.plot <- ggplot(data = Population_density_complete) +` |
