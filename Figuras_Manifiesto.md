# Manifiesto de figuras — Dinámica Poblacional de Orquídeas

Inventario completo de TODAS las figuras del libro (estáticas markdown + generadas por código R), organizadas por capítulo y orden de aparición. Cada figura está enlazada con su ubicación esperada en `figuras_editor/<capítulo>/` y, cuando aplica, con el número de figura `Fig X.Y` del libro renderizado.

## Resumen

- **Total figuras**: 130
- **Capítulos con figuras**: 19
- **Por tipo**:
  - imagen markdown estática: **53**
  - PNG generado por chunk R (ggplot, plot, etc.): **50**
  - PNG generado por `render_dual()` (DOT → PNG): **25**
  - PNG generado por `ggsave()`: **2**

## Cómo regenerar este manifiesto

```bash
quarto render                       # genera docs/*_files/figure-html/
Rscript scripts/collect_figures.R   # recolecta a figuras_editor/
```

Para auditar sin copiar: `Rscript scripts/collect_figures.R --audit`

## Inventario por capítulo

### 01-Introduccion

Archivo fuente: `102-Intro.qmd` — 3 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 1.1 | 144 | dynamic | `chunk 'fig-Pop-fig_1'` | `figuras_editor/01-Introduccion/Fig_1.1_fig-Pop-fig_1-1.png` | `figuras_editor/01-Introduccion/Fig_1.1_fig-Pop-fig_1-1.pdf` |  |
| 2 | 1.2 | 291 | static | `images/Tolumnia_variegata_Tremblay.jpeg` | `figuras_editor/01-Introduccion/Fig_1.2_Tolumnia_variegata_Tremblay.jpeg` | `` | *Tolumnia variegata*. Foto: Tremblay |
| 3 | 1.3 | 315 | static | `images/Demografia_de_una_poblacion.jpg` | `figuras_editor/01-Introduccion/Fig_1.3_Demografia_de_una_poblacion.jpg` | `` | Factores que influyen en la dinámica de una población |

### 02-Ciclos_de_Vida

Archivo fuente: `103-Ciclos_de_Vida.qmd` — 11 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 2.1 | 158 | render_dual | `images/CV_2.png` | `figuras_editor/02-Ciclos_de_Vida/Fig_2.1_CV_2.png` | `figuras_editor/02-Ciclos_de_Vida/Fig_2.1_CV_2.pdf` |  |
| 2 | 2.2 | 184 | render_dual | `images/CV_3.png` | `figuras_editor/02-Ciclos_de_Vida/Fig_2.2_CV_3.png` | `figuras_editor/02-Ciclos_de_Vida/Fig_2.2_CV_3.pdf` |  |
| 3 | 2.3 | 242 | render_dual | `images/CV_5.png` | `figuras_editor/02-Ciclos_de_Vida/Fig_2.3_CV_5.png` | `figuras_editor/02-Ciclos_de_Vida/Fig_2.3_CV_5.pdf` |  |
| 4 | 2.4 | 278 | render_dual | `images/CV_6Telipogon_helleri.png` | `figuras_editor/02-Ciclos_de_Vida/Fig_2.4_CV_6Telipogon_helleri.png` | `figuras_editor/02-Ciclos_de_Vida/Fig_2.4_CV_6Telipogon_helleri.pdf` |  |
| 5 | 2.5 | 317 | render_dual | `images/CV7Prasophyllum_correctum.png` | `figuras_editor/02-Ciclos_de_Vida/Fig_2.5_CV7Prasophyllum_correctum.png` | `figuras_editor/02-Ciclos_de_Vida/Fig_2.5_CV7Prasophyllum_correctum.pdf` |  |
| 6 | 2.6 | 349 | render_dual | `images/CV8_Ophrys.png` | `figuras_editor/02-Ciclos_de_Vida/Fig_2.6_CV8_Ophrys.png` | `figuras_editor/02-Ciclos_de_Vida/Fig_2.6_CV8_Ophrys.pdf` |  |
| 7 | 2.7 | 356 | static | `images/Orchis_purpurea_1_Hans_Jacquemyn.jpg` | `figuras_editor/02-Ciclos_de_Vida/Fig_2.7_Orchis_purpurea_1_Hans_Jacquemyn.jpg` | `` | *Orchis purpurea*. Foto: Hans Jacquemyn |
| 8 | 2.8 | 392 | render_dual | `images/CV9_Op.png` | `figuras_editor/02-Ciclos_de_Vida/Fig_2.8_CV9_Op.png` | `figuras_editor/02-Ciclos_de_Vida/Fig_2.8_CV9_Op.pdf` |  |
| 9 | 2.9 | 395 | static | `images/Orchis_purpurea_2_Hans_Jacquemyn.jpg` | `figuras_editor/02-Ciclos_de_Vida/Fig_2.9_Orchis_purpurea_2_Hans_Jacquemyn.jpg` | `` | *Orchis purpurea*. Foto: Hans Jacquemyn |
| 10 | 2.10 | 433 | render_dual | `images/CV10.png` | `figuras_editor/02-Ciclos_de_Vida/Fig_2.10_CV10.png` | `figuras_editor/02-Ciclos_de_Vida/Fig_2.10_CV10.pdf` |  |
| 11 | 2.11 | 484 | static | `figs/CV11_Rage_plot.png` | `figuras_editor/02-Ciclos_de_Vida/Fig_2.11_CV11_Rage_plot.png` | `` | Diagrama de ciclo de vida construido con el paquete `Rage`. |

### 03-Recopilacion_datos_en_el_campo

Archivo fuente: `104-Recopilacion_datos_en_el_campo.qmd` — 23 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 3.1 | 58 | static | `images/L_autum_epifita.jpg` | `figuras_editor/03-Recopilacion_datos_en_el_campo/Fig_3.1_L_autum_epifita.jpg` | `` | Crecimiento epífito de *Laelia autumnalis* sobre las ramas y tronco de un encino. Foto: Aucencia Emeterio-Lara |
| 2 | 3.2 | 87 | static | `images/L_autum_rupicola.jpg` | `figuras_editor/03-Recopilacion_datos_en_el_campo/Fig_3.2_L_autum_rupicola.jpg` | `` | *Laelia autumnalis* en su hábitat rupícola, crédito: Foto: Aucencia Emeterio-Lara |
| 3 | 3.3 | 113 | static | `images/Trichocentrum_undulatum_9_Hong_Liu.jpeg` | `figuras_editor/03-Recopilacion_datos_en_el_campo/Fig_3.3_Trichocentrum_undulatum_9_Hong_Liu.jpeg` | `` | *Trichocentrum undulatum*. Foto: Hong Liu |
| 4 | 3.4 | 119 | static | `images/Trichocentrum_undulatum_1_Hong_Liu.jpg` | `figuras_editor/03-Recopilacion_datos_en_el_campo/Fig_3.4_Trichocentrum_undulatum_1_Hong_Liu.jpg` | `` | *Trichocentrum undulatum*. Foto: Hong Liu |
| 5 | 3.5 | 143 | static | `images/lepanthes_rupestris.jpeg` | `figuras_editor/03-Recopilacion_datos_en_el_campo/Fig_3.5_lepanthes_rupestris.jpeg` | `` | *Lepanthes rupestris* con inflorescencias seca y activa. Foto: Raymond L. Tremblay |
| 6 | 3.6 | 168 | static | `images/Pk_modulo.jpeg` | `figuras_editor/03-Recopilacion_datos_en_el_campo/Fig_3.6_Pk_modulo.jpeg` | `` | *Prosthechea karwinskii*. Foto: Mariana Hernández-Apolinar |
| 7 | 3.7 | 183 | static | `images/Ci_modulo.png` | `figuras_editor/03-Recopilacion_datos_en_el_campo/Fig_3.7_Ci_modulo.png` | `` | *Cypripedium irapeanum*. Foto: Claudia C. Gutiérrez-Paredes |
| 8 | 3.8 | 198 | static | `images/V_planifolia_monopo.png` | `figuras_editor/03-Recopilacion_datos_en_el_campo/Fig_3.8_V_planifolia_monopo.png` | `` | *Vanilla planifolia*. Foto: Mark Blackman |
| 9 | 3.9 | 206 | static | `images/Ls_simpodio.jpg` | `figuras_editor/03-Recopilacion_datos_en_el_campo/Fig_3.9_Ls_simpodio.jpg` | `` | *Laelia speciosa*. Foto: Leonel López-Toledo |
| 10 | 3.10 | 237 | static | `images/Figura_4.10.jpg` | `figuras_editor/03-Recopilacion_datos_en_el_campo/Fig_3.10_Figura_4.10.jpg` | `` | Técnica de rapel usada para el muestreo de orquídeas rupícolas: *Dendrobium*. Foto: Hong Liu, 2020. |
| 11 | 3.11 | 243 | static | `images/Ascenso_Pk.jpg` | `figuras_editor/03-Recopilacion_datos_en_el_campo/Fig_3.11_Ascenso_Pk.jpg` | `` | Muestreo de orquídeas epífitas con ascenso de una sola cuerda: *Prosthechea karwinskii*. Foto: Alonso Argüero |
| 12 | 3.12 | 257 | static | `images/Cattling_y_Johannson.png` | `figuras_editor/03-Recopilacion_datos_en_el_campo/Fig_3.12_Cattling_y_Johannson.png` | `` | Zonificación de árboles hospedero, basada en los modelos Catling (1986) y Johansson (1974). Dibujo de A. Emeterio-Lara |
| 13 | 3.13 | 313 | static | `images/Ls_xyz.png` | `figuras_editor/03-Recopilacion_datos_en_el_campo/Fig_3.13_Ls_xyz.png` | `` | Distribución tridimensional de *Laelia speciosa* sobre *Quercus deserticola*, basada en @hernandez1992dinamica. Figura d |
| 14 | 3.14 | 319 | static | `images/tree_dist.png` | `figuras_editor/03-Recopilacion_datos_en_el_campo/Fig_3.14_tree_dist.png` | `` | Distribución espacial de los árboles hospedero de *Laelia speciosa*. Los círculos dentro del área de muestreo representa |
| 15 | 3.15 | 331 | static | `images/Triangulation_Method.jpg` | `figuras_editor/03-Recopilacion_datos_en_el_campo/Fig_3.15_Triangulation_Method.jpg` | `` | Método de triangulación para el muestreo de orquídeas terrestres. Se ilustra la forma de determinar la posición ($P_{x}$ |
| 16 | 3.16 | 365 | static | `images/C_irap_plantula.jpeg` | `figuras_editor/03-Recopilacion_datos_en_el_campo/Fig_3.16_C_irap_plantula.jpeg` | `` | Plántula de *Cypripedium irapeanum*. Foto: Claudia Gutiérrez-Paredes |
| 17 | 3.17 | 373 | static | `images/Lepanthes_woodburyana.jpg` | `figuras_editor/03-Recopilacion_datos_en_el_campo/Fig_3.17_Lepanthes_woodburyana.jpg` | `` | *Lepanthes woodburyana*. Foto: Edwin Guevara |
| 18 | 3.18 | 405 | static | `images/Cypripedium_acaule.jpg` | `figuras_editor/03-Recopilacion_datos_en_el_campo/Fig_3.18_Cypripedium_acaule.jpg` | `` | Uso de etiquetas de aluminio en marcaje de *Cypripedium acaule*. Foto: Tremblay |
| 19 | 3.19 | 411 | static | `images/Laelia_cincho.png` | `figuras_editor/03-Recopilacion_datos_en_el_campo/Fig_3.19_Laelia_cincho.png` | `` | Uso de etiquetas de aluminio en marcaje con cinchos de plástico en *Laelia autumnalis*. Foto por Aucencia Emeterio-Lara |
| 20 | 3.20 | 449 | static | `images/alambrelaelia.jpg` | `figuras_editor/03-Recopilacion_datos_en_el_campo/Fig_3.20_alambrelaelia.jpg` | `` | Marcaje de *Laelia speciosa* abrazando el tronco con alambre plastificado y etiquetas de *dymo*. Foto: Mariana Hernández |
| 21 | 3.21 | 457 | static | `images/Lep_eltoroensis.png` | `figuras_editor/03-Recopilacion_datos_en_el_campo/Fig_3.21_Lep_eltoroensis.png` | `` | Los individuos de *Lepanthes eltoroensis* fueron identificados con una etiqueta de plástico clavada al tronco del árbol; |
| 22 | 3.22 | 465 | static | `images/Cirap_marcaje.png` | `figuras_editor/03-Recopilacion_datos_en_el_campo/Fig_3.22_Cirap_marcaje.png` | `` | Marcaje de *Cypripedium irapeanum* con cinta de *dymo*. Foto: Hernández-Apolinar |
| 23 | 3.23 | 471 | static | `images/Cyp_acaule_flag.jpg` | `figuras_editor/03-Recopilacion_datos_en_el_campo/Fig_3.23_Cyp_acaule_flag.jpg` | `` | Marcaje de *Cypripedium acaule* con banderitas. Foto: Tremblay |

### 05-Fecundidad

Archivo fuente: `106-calcular_fecundidad.qmd` — 5 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 5.1 | 121 | static | `images/Diagrama_fecundidad.png` | `figuras_editor/05-Fecundidad/Fig_5.1_Diagrama_fecundidad.png` | `` | Diagrama del proceso de fecundidad en orquídeas, mostrando la cadena de filtros sucesivos: producción floral, polinizaci |
| 2 | 5.2 | 144 | static | `images/Cant_Hojas_Prob_Fr_Brassavola.jpg` | `figuras_editor/05-Fecundidad/Fig_5.2_Cant_Hojas_Prob_Fr_Brassavola.jpg` | `` | Relación entre la cantidad de hojas y la probabilidad de floración en *Brassavola cucullata* en las islas Saba y San Eus |
| 3 | 5.3 | 170 | render_dual | `images/fec-life-cycle-1.png` | `figuras_editor/05-Fecundidad/Fig_5.3_fec-life-cycle-1.png` | `figuras_editor/05-Fecundidad/Fig_5.3_fec-life-cycle-1.pdf` |  |
| 4 | 5.4 | 206 | render_dual | `images/fec-matA-pl.png` | `figuras_editor/05-Fecundidad/Fig_5.4_fec-matA-pl.png` | `figuras_editor/05-Fecundidad/Fig_5.4_fec-matA-pl.pdf` |  |
| 5 | 5.5 | 233 | render_dual | `images/fec-matA-pl2.png` | `figuras_editor/05-Fecundidad/Fig_5.5_fec-matA-pl2.png` | `figuras_editor/05-Fecundidad/Fig_5.5_fec-matA-pl2.pdf` |  |

### 06-matU_matF_matC

Archivo fuente: `107-matU_matF_matC.qmd` — 3 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 6.1 | 65 | static | `images/Matrices_A_U_F_C.jpg` | `figuras_editor/06-matU_matF_matC/Fig_6.1_Matrices_A_U_F_C.jpg` | `` | Relación entre matrices; Diseño: Samuel Gascoigne |
| 2 | 6.2 | 90 | render_dual | `images/matU_matA1.png` | `figuras_editor/06-matU_matF_matC/Fig_6.2_matU_matA1.png` | `figuras_editor/06-matU_matF_matC/Fig_6.2_matU_matA1.pdf` |  |
| 3 | 6.3 | 122 | render_dual | `images/matU_matA2.png` | `figuras_editor/06-matU_matF_matC/Fig_6.3_matU_matA2.png` | `figuras_editor/06-matU_matF_matC/Fig_6.3_matU_matA2.pdf` |  |

### 07-Bayesian_PPM

Archivo fuente: `108-Bayesian_PPM.qmd` — 6 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 7.1 | 139 | render_dual | `images/bayes2.png` | `figuras_editor/07-Bayesian_PPM/Fig_7.1_bayes2.png` | `figuras_editor/07-Bayesian_PPM/Fig_7.1_bayes2.pdf` |  |
| 2 | 7.2 | 218 | static | `images/Lepanthes_eltoroensis_Edwin_Guevara.jpg` | `figuras_editor/07-Bayesian_PPM/Fig_7.2_Lepanthes_eltoroensis_Edwin_Guevara.jpg` | `` | *Lepanthes eltoroensis*. Foto: Edwin Guevara |
| 3 | 7.3 | 220 | static | `images/Lepanthes_eltoroensis_Phorophyte_Edwin_Guevara.jpg` | `figuras_editor/07-Bayesian_PPM/Fig_7.3_Lepanthes_eltoroensis_Phorophyte_Edwin_Guevara.jpg` | `` | *Lepanthes eltoroensis*. Foto: Edwin Guevara |
| 4 | 7.4 | 353 | render_dual | `images/bayes11.png` | `figuras_editor/07-Bayesian_PPM/Fig_7.4_bayes11.png` | `figuras_editor/07-Bayesian_PPM/Fig_7.4_bayes11.pdf` |  |
| 5 | 7.5 | 522 | dynamic | `chunk 'fig-bayes16'` | `figuras_editor/07-Bayesian_PPM/Fig_7.5_fig-bayes16-1.png` | `figuras_editor/07-Bayesian_PPM/Fig_7.5_fig-bayes16-1.pdf` |  |
| 6 | 7.6 | 614 | dynamic | `chunk 'fig-bayes19'` | `figuras_editor/07-Bayesian_PPM/Fig_7.6_fig-bayes19-1.png` | `figuras_editor/07-Bayesian_PPM/Fig_7.6_fig-bayes19-1.pdf` |  |

### 08-Crecimiento_poblacional

Archivo fuente: `109-Crecimiento_poblacional.qmd` — 4 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 8.1 | 83 | render_dual | `images/cre_pop_1_Laelia_p1.png` | `figuras_editor/08-Crecimiento_poblacional/Fig_8.1_cre_pop_1_Laelia_p1.png` | `figuras_editor/08-Crecimiento_poblacional/Fig_8.1_cre_pop_1_Laelia_p1.pdf` |  |
| 2 | 8.2 | 105 | render_dual | `images/cre_pop_1b_Laelia_p2.png` | `figuras_editor/08-Crecimiento_poblacional/Fig_8.2_cre_pop_1b_Laelia_p2.png` | `figuras_editor/08-Crecimiento_poblacional/Fig_8.2_cre_pop_1b_Laelia_p2.pdf` |  |
| 3 | 8.3 | 168 | dynamic | `chunk 'fig-cre-pop-projection-2'` | `figuras_editor/08-Crecimiento_poblacional/Fig_8.3_fig-cre-pop-projection-2-1.png` | `figuras_editor/08-Crecimiento_poblacional/Fig_8.3_fig-cre-pop-projection-2-1.pdf` |  |
| 4 | 8.4 | 187 | dynamic | `chunk 'fig-cre-pop-projection-3'` | `figuras_editor/08-Crecimiento_poblacional/Fig_8.4_fig-cre-pop-projection-3-1.png` | `figuras_editor/08-Crecimiento_poblacional/Fig_8.4_fig-cre-pop-projection-3-1.pdf` |  |

### 09-Propiedades

Archivo fuente: `110-Propriedades.qmd` — 6 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 9.1 | 194 | render_dual | `images/Indice5_Lr1_No_erg.png` | `figuras_editor/09-Propiedades/Fig_9.1_Indice5_Lr1_No_erg.png` | `figuras_editor/09-Propiedades/Fig_9.1_Indice5_Lr1_No_erg.pdf` |  |
| 2 | 9.2 | 287 | render_dual | `images/Indice_Lr1_Irr.png` | `figuras_editor/09-Propiedades/Fig_9.2_Indice_Lr1_Irr.png` | `figuras_editor/09-Propiedades/Fig_9.2_Indice_Lr1_Irr.pdf` |  |
| 3 | 9.3 | 365 | dynamic | `chunk 'fig-Indice10'` | `figuras_editor/09-Propiedades/Fig_9.3_fig-Indice10-1.png` | `figuras_editor/09-Propiedades/Fig_9.3_fig-Indice10-1.pdf` |  |
| 4 | 9.4 | 404 | static | `images/Spathoglottis_plicata_Tremblay.jpeg` | `figuras_editor/09-Propiedades/Fig_9.4_Spathoglottis_plicata_Tremblay.jpeg` | `` | *Spathoglottis plicata*. Foto: Tremblay |
| 5 | 9.5 | 467 | dynamic | `chunk 'fig-Indice13'` | `figuras_editor/09-Propiedades/Fig_9.5_fig-Indice13-1.png` | `figuras_editor/09-Propiedades/Fig_9.5_fig-Indice13-1.pdf` |  |
| 6 | 9.6 | 631 | dynamic | `chunk 'fig-indice16'` | `figuras_editor/09-Propiedades/Fig_9.6_fig-indice16-1.png` | `figuras_editor/09-Propiedades/Fig_9.6_fig-indice16-1.pdf` |  |

### 10-Elasticidad

Archivo fuente: `111-Elasticidad.qmd` — 6 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 10.1 | 201 | static | `images/Lepanthes_eltoroensis_Tremblay.jpeg` | `figuras_editor/10-Elasticidad/Fig_10.1_Lepanthes_eltoroensis_Tremblay.jpeg` | `` | *Lepanthes eltoroensis*. Foto: Tremblay |
| 2 | 10.2 | 240 | static | `images/Lepanthes_caritensis_Edwin_Guevara.jpg` | `figuras_editor/10-Elasticidad/Fig_10.2_Lepanthes_caritensis_Edwin_Guevara.jpg` | `` | *Lepanthes caritensis*. Foto: Edwin Guevara |
| 3 | 10.3 | 246 | static | `images/Lepanthes_caritensis_Phorophyte.jpg` | `figuras_editor/10-Elasticidad/Fig_10.3_Lepanthes_caritensis_Phorophyte.jpg` | `` | *Lepanthes caritensis*. Foto: Edwin Guevara |
| 4 | 10.4 | 252 | dynamic | `chunk 'fig-Elas7'` | `figuras_editor/10-Elasticidad/Fig_10.4_fig-Elas7-1.png` | `figuras_editor/10-Elasticidad/Fig_10.4_fig-Elas7-1.pdf` |  |
| 5 | 10.5 | 284 | dynamic | `chunk 'fig-Elas8'` | `figuras_editor/10-Elasticidad/Fig_10.5_fig-Elas8-1.png` | `figuras_editor/10-Elasticidad/Fig_10.5_fig-Elas8-1.pdf` |  |
| 6 | 10.6 | 327 | static | `images/Laelia_speciosa_Eduardo_A._Perez_Garcia.jpeg` | `figuras_editor/10-Elasticidad/Fig_10.6_Laelia_speciosa_Eduardo_A._Perez_Garcia.jpeg` | `` | *Laelia speciosa*. Foto: Eduardo A. Pérez García |

### 11-Dinamica_transitoria

Archivo fuente: `112-Dinamica_de_Transiciones.qmd` — 9 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 11.1 | 137 | static | `images/Lepanthes_rupestris_Tremblay.jpeg` | `figuras_editor/11-Dinamica_transitoria/Fig_11.1_Lepanthes_rupestris_Tremblay.jpeg` | `` | *Lepanthes rupestris*. Foto: Tremblay |
| 2 | 11.2 | 258 | dynamic | `chunk 'fig-trans4'` | `figuras_editor/11-Dinamica_transitoria/Fig_11.2_fig-trans4-1.png` | `figuras_editor/11-Dinamica_transitoria/Fig_11.2_fig-trans4-1.pdf` |  |
| 3 | 11.3 | 322 | dynamic | `chunk 'fig-trans6'` | `figuras_editor/11-Dinamica_transitoria/Fig_11.3_fig-trans6-1.png` | `figuras_editor/11-Dinamica_transitoria/Fig_11.3_fig-trans6-1.pdf` |  |
| 4 | 11.4 | 378 | dynamic | `chunk 'fig-trans8'` | `figuras_editor/11-Dinamica_transitoria/Fig_11.4_fig-trans8-1.png` | `figuras_editor/11-Dinamica_transitoria/Fig_11.4_fig-trans8-1.pdf` |  |
| 5 | 11.5 | 429 | dynamic | `chunk 'fig-trans10'` | `figuras_editor/11-Dinamica_transitoria/Fig_11.5_fig-trans10-1.png` | `figuras_editor/11-Dinamica_transitoria/Fig_11.5_fig-trans10-1.pdf` |  |
| 6 | 11.6 | 594 | dynamic | `chunk 'fig-trans14'` | `figuras_editor/11-Dinamica_transitoria/Fig_11.6_fig-trans14-1.png` | `figuras_editor/11-Dinamica_transitoria/Fig_11.6_fig-trans14-1.pdf` |  |
| 7 | 11.7 | 633 | dynamic | `chunk 'fig-trans15'` | `figuras_editor/11-Dinamica_transitoria/Fig_11.7_fig-trans15-1.png` | `figuras_editor/11-Dinamica_transitoria/Fig_11.7_fig-trans15-1.pdf` |  |
| 8 | 11.8 | 836 | dynamic | `chunk 'fig-trans22'` | `figuras_editor/11-Dinamica_transitoria/Fig_11.8_fig-trans22-1.png` | `figuras_editor/11-Dinamica_transitoria/Fig_11.8_fig-trans22-1.pdf` |  |
| 9 | 11.9 | 904 | dynamic | `chunk 'fig-trans23'` | `figuras_editor/11-Dinamica_transitoria/Fig_11.9_fig-trans23-1.png` | `figuras_editor/11-Dinamica_transitoria/Fig_11.9_fig-trans23-1.pdf` |  |

### 12-Funciones_de_Transferencia

Archivo fuente: `113-Funciones_de_Transferencia.qmd` — 11 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 12.1 | 275 | dynamic | `chunk 'fig-tf-nLr0-init'` | `figuras_editor/12-Funciones_de_Transferencia/Fig_12.1_fig-tf-nLr0-init-1.png` | `figuras_editor/12-Funciones_de_Transferencia/Fig_12.1_fig-tf-nLr0-init-1.pdf` |  |
| 2 | 12.2 | 322 | dynamic | `chunk 'fig-tf-tf5-calc'` | `figuras_editor/12-Funciones_de_Transferencia/Fig_12.2_fig-tf-tf5-calc-1.png` | `figuras_editor/12-Funciones_de_Transferencia/Fig_12.2_fig-tf-tf5-calc-1.pdf` |  |
| 3 | 12.3 | 360 | dynamic | `chunk 'fig-tf-tf9-calc'` | `figuras_editor/12-Funciones_de_Transferencia/Fig_12.3_fig-tf-tf9-calc-1.png` | `figuras_editor/12-Funciones_de_Transferencia/Fig_12.3_fig-tf-tf9-calc-1.pdf` |  |
| 4 | 12.4 | 401 | dynamic | `chunk 'fig-tf-tf8-calc'` | `figuras_editor/12-Funciones_de_Transferencia/Fig_12.4_fig-tf-tf8-calc-1.png` | `figuras_editor/12-Funciones_de_Transferencia/Fig_12.4_fig-tf-tf8-calc-1.pdf` |  |
| 5 | 12.5 | 459 | dynamic | `chunk 'fig-transF3'` | `figuras_editor/12-Funciones_de_Transferencia/Fig_12.5_fig-transF3-1.png` | `figuras_editor/12-Funciones_de_Transferencia/Fig_12.5_fig-transF3-1.pdf` |  |
| 6 | 12.6 | 527 | dynamic | `chunk 'fig-tf-n0-init'` | `figuras_editor/12-Funciones_de_Transferencia/Fig_12.6_fig-tf-n0-init-1.png` | `figuras_editor/12-Funciones_de_Transferencia/Fig_12.6_fig-tf-n0-init-1.pdf` |  |
| 7 | 12.7 | 557 | dynamic | `chunk 'fig-tf-par-mfrow'` | `figuras_editor/12-Funciones_de_Transferencia/Fig_12.7_fig-tf-par-mfrow-1.png` | `figuras_editor/12-Funciones_de_Transferencia/Fig_12.7_fig-tf-par-mfrow-1.pdf` |  |
| 8 | 12.8 | 587 | dynamic | `chunk 'fig-tf-etype-matrix'` | `figuras_editor/12-Funciones_de_Transferencia/Fig_12.8_fig-tf-etype-matrix-1.png` | `figuras_editor/12-Funciones_de_Transferencia/Fig_12.8_fig-tf-etype-matrix-1.pdf` |  |
| 9 | 12.9 | 608 | dynamic | `chunk 'fig-tf-tfmatL-init'` | `figuras_editor/12-Funciones_de_Transferencia/Fig_12.9_fig-tf-tfmatL-init-1.png` | `figuras_editor/12-Funciones_de_Transferencia/Fig_12.9_fig-tf-tfmatL-init-1.pdf` |  |
| 10 | 12.10 | 623 | dynamic | `chunk 'fig-transF5'` | `figuras_editor/12-Funciones_de_Transferencia/Fig_12.10_fig-transF5-1.png` | `figuras_editor/12-Funciones_de_Transferencia/Fig_12.10_fig-transF5-1.pdf` |  |
| 11 | 12.11 | 1051 | dynamic | `chunk 'fig-tf-grid-cowplot'` | `figuras_editor/12-Funciones_de_Transferencia/Fig_12.11_fig-tf-grid-cowplot-1.png` | `figuras_editor/12-Funciones_de_Transferencia/Fig_12.11_fig-tf-grid-cowplot-1.pdf` |  |

### 13-LTRE

Archivo fuente: `114-LTRE.qmd` — 5 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 13.1 | 172 | static | `images/Imagen1.jpg` | `figuras_editor/13-LTRE/Fig_13.1_Imagen1.jpg` | `` | Cuadro 1. Matrices de proyección poblacional de *Oncidium brachyandrum* en dos hospederos (*Quercus martinezii* y *Q. ru |
| 2 | 13.2 | 523 | dynamic | `chunk 'fig-LTRE15'` | `figuras_editor/13-LTRE/Fig_13.2_fig-LTRE15-1.png` | `figuras_editor/13-LTRE/Fig_13.2_fig-LTRE15-1.pdf` |  |
| 3 | 13.3 | 559 | dynamic | `chunk 'fig-LTRE16'` | `figuras_editor/13-LTRE/Fig_13.3_fig-LTRE16-1.png` | `figuras_editor/13-LTRE/Fig_13.3_fig-LTRE16-1.pdf` |  |
| 4 | 13.4 | 711 | dynamic | `chunk 'fig-LRE25'` | `figuras_editor/13-LTRE/Fig_13.4_fig-LRE25-1.png` | `figuras_editor/13-LTRE/Fig_13.4_fig-LRE25-1.pdf` |  |
| 5 | 13.5 | 732 | dynamic | `chunk 'fig-LRE26'` | `figuras_editor/13-LTRE/Fig_13.5_fig-LRE26-1.png` | `figuras_editor/13-LTRE/Fig_13.5_fig-LRE26-1.pdf` |  |

### 14-Metodos_de_simulaciones

Archivo fuente: `115-Metodos_de_simulaciones.qmd` — 9 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 14.1 | 146 | static | `images/Serapias_cordigera_5_Giuseppe_Pellegrino.jpeg` | `figuras_editor/14-Metodos_de_simulaciones/Fig_14.1_Serapias_cordigera_5_Giuseppe_Pellegrino.jpeg` | `` | *Serapias cordigera*. Foto: Guiseppe Pelligrino |
| 2 | 14.2 | 263 | static | `images/Serapias_cordigera_7_Giuseppe_Pellegrino.jpg` | `figuras_editor/14-Metodos_de_simulaciones/Fig_14.2_Serapias_cordigera_7_Giuseppe_Pellegrino.jpg` | `` | *Serapias cordigera*. Foto: Guiseppe Pelligrino |
| 3 | 14.3 | 266 | dynamic | `chunk 'fig-sim4'` | `figuras_editor/14-Metodos_de_simulaciones/Fig_14.3_fig-sim4-1.png` | `figuras_editor/14-Metodos_de_simulaciones/Fig_14.3_fig-sim4-1.pdf` |  |
| 4 | 14.4 | 288 | dynamic | `chunk 'fig-sim5'` | `figuras_editor/14-Metodos_de_simulaciones/Fig_14.4_fig-sim5-1.png` | `figuras_editor/14-Metodos_de_simulaciones/Fig_14.4_fig-sim5-1.pdf` |  |
| 5 | 14.5 | 330 | dynamic | `chunk 'fig-sim7'` | `figuras_editor/14-Metodos_de_simulaciones/Fig_14.5_fig-sim7-1.png` | `figuras_editor/14-Metodos_de_simulaciones/Fig_14.5_fig-sim7-1.pdf` |  |
| 6 | 14.6 | 448 | dynamic | `chunk 'fig-sim-diverging-colors'` | `figuras_editor/14-Metodos_de_simulaciones/Fig_14.6_fig-sim-diverging-colors-1.png` | `figuras_editor/14-Metodos_de_simulaciones/Fig_14.6_fig-sim-diverging-colors-1.pdf` |  |
| 7 | 14.7 | 471 | static | `images/Serapias_cordigera_3_Giuseppe_Pellegrino.jpeg` | `figuras_editor/14-Metodos_de_simulaciones/Fig_14.7_Serapias_cordigera_3_Giuseppe_Pellegrino.jpeg` | `` | *Serapias cordigera*. Foto: Guiseppe Pelligrino |
| 8 | 14.8 | 714 | dynamic | `chunk 'fig-sim18'` | `figuras_editor/14-Metodos_de_simulaciones/Fig_14.8_fig-sim18-1.png` | `figuras_editor/14-Metodos_de_simulaciones/Fig_14.8_fig-sim18-1.pdf` |  |
| 9 | 14.9 | 918 | ggsave | `mi_gragico.tiff` | `figuras_editor/14-Metodos_de_simulaciones/Fig_14.9_mi_gragico.tiff` | `figuras_editor/14-Metodos_de_simulaciones/Fig_14.9_mi_gragico.pdf` |  |

### 15-Historia_breve

Archivo fuente: `117_Historia_breve.qmd` — 1 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 15.1 | 104 | static | `images/Vanhecke_figure.png` | `figuras_editor/15-Historia_breve/Fig_15.1_Vanhecke_figure.png` | `` | *Dactylorhiza praetermissa*; de la publicación |

### 16-Carl_Olaf_Tamm

Archivo fuente: `118-Carl_Olaf_Tamm.qmd` — 3 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 16.1 | 129 | static | `images/Dactylorhiza_sambucina_James_D._Ackerman.jpg` | `figuras_editor/16-Carl_Olaf_Tamm/Fig_16.1_Dactylorhiza_sambucina_James_D._Ackerman.jpg` | `` | *Dactylorhiza sambucina*. Foto: James D. Ackerman |
| 2 | 16.2 | 167 | static | `images/Dactylorhiza_maculata_James_D._Ackerman.jpg` | `figuras_editor/16-Carl_Olaf_Tamm/Fig_16.2_Dactylorhiza_maculata_James_D._Ackerman.jpg` | `` | *Dactylorhiza maculata con hormigas y spittle bugs*. Foto: James D. Ackerman |
| 3 | 16.3 | 457 | dynamic | `chunk 'fig-OCTamm_17'` | `figuras_editor/16-Carl_Olaf_Tamm/Fig_16.3_fig-OCTamm_17-1.png` | `figuras_editor/16-Carl_Olaf_Tamm/Fig_16.3_fig-OCTamm_17-1.pdf` |  |

### 18-Rage

Archivo fuente: `120-Rage_orquideas.qmd` — 8 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 18.1 | 179 | dynamic | `chunk 'fig-Rage8'` | `figuras_editor/18-Rage/Fig_18.1_fig-Rage8-1.png` | `figuras_editor/18-Rage/Fig_18.1_fig-Rage8-1.pdf` |  |
| 2 | 18.2 | 206 | dynamic | `chunk 'fig-Rage9'` | `figuras_editor/18-Rage/Fig_18.2_fig-Rage9-1.png` | `figuras_editor/18-Rage/Fig_18.2_fig-Rage9-1.pdf` |  |
| 3 | 18.3 | 301 | ggsave | `images/Duración_Epi_Ter.png` | `figuras_editor/18-Rage/Fig_18.3_Duración_Epi_Ter.png` | `figuras_editor/18-Rage/Fig_18.3_Duración_Epi_Ter.pdf` |  |
| 4 | 18.4 | 603 | dynamic | `chunk 'fig-Rage29'` | `figuras_editor/18-Rage/Fig_18.4_fig-Rage29-1.png` | `figuras_editor/18-Rage/Fig_18.4_fig-Rage29-1.pdf` |  |
| 5 | 18.5 | 649 | dynamic | `chunk 'fig-Rage31'` | `figuras_editor/18-Rage/Fig_18.5_fig-Rage31-1.png` | `figuras_editor/18-Rage/Fig_18.5_fig-Rage31-1.pdf` |  |
| 6 | 18.6 | 669 | dynamic | `chunk 'fig-Rage32'` | `figuras_editor/18-Rage/Fig_18.6_fig-Rage32-1.png` | `figuras_editor/18-Rage/Fig_18.6_fig-Rage32-1.pdf` |  |
| 7 | 18.7 | 731 | dynamic | `chunk 'fig-Rage35'` | `figuras_editor/18-Rage/Fig_18.7_fig-Rage35-1.png` | `figuras_editor/18-Rage/Fig_18.7_fig-Rage35-1.pdf` |  |
| 8 | 18.8 | 839 | dynamic | `chunk 'fig-Rage_compare_plot'` | `figuras_editor/18-Rage/Fig_18.8_fig-Rage_compare_plot-1.png` | `figuras_editor/18-Rage/Fig_18.8_fig-Rage_compare_plot-1.pdf` |  |

### 19-Protocolo

Archivo fuente: `121-Traduccion_protocolo_informacion.qmd` — 4 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 19.1 | 79 | static | `images/Survey_paper.png` | `figuras_editor/19-Protocolo/Fig_19.1_Survey_paper.png` | `` | FIGURA 1: Resultados de la encuesta a expertos en ecología de poblaciones que participaron (n = 60). Los participantes c |
| 2 | 19.2 | 89 | static | `images/Database_paper.png` | `figuras_editor/19-Protocolo/Fig_19.2_Database_paper.png` | `` | FIGURA2: Tanto los artículos sobre MPP de plantas como de animales muestran patrones similares en cuanto a qué component |
| 3 | 19.3 | 93 | static | `images/COMPADRE_MADRE.png` | `figuras_editor/19-Protocolo/Fig_19.3_COMPADRE_MADRE.png` | `` | FIGURA 3: En los artículos sobre MPP de plantas y animales, la mayoría de las publicaciones no contienen suficiente info |
| 4 | 19.4 | 345 | static | `images/Matrices_A_U_F_C.jpg` | `figuras_editor/19-Protocolo/Fig_19.4_Matrices_A_U_F_C.jpg` | `` | FIGURA 4: La descomposición de un MPP en sus submatrices permite aislar tasas vitales que de otro modo estarían enmascar |

### 20-Datos_sin_sentido

Archivo fuente: `122-Impacto_de_Datos_sin_Sentido.qmd` — 11 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 20.1 | 153 | render_dual | `images/sin_sentido_2_Sp1matA.png` | `figuras_editor/20-Datos_sin_sentido/Fig_20.1_sin_sentido_2_Sp1matA.png` | `figuras_editor/20-Datos_sin_sentido/Fig_20.1_sin_sentido_2_Sp1matA.pdf` |  |
| 2 | 20.2 | 217 | static | `images/Erycina_crista-galli_Diana_Molina_Ozuma.jpg` | `figuras_editor/20-Datos_sin_sentido/Fig_20.2_Erycina_crista-galli_Diana_Molina_Ozuma.jpg` | `` | *Erycina crista-galli*. Foto: Diana Molina Ozuma |
| 3 | 20.3 | 302 | render_dual | `images/sin_sentido_6_Sp1matA_NT.png` | `figuras_editor/20-Datos_sin_sentido/Fig_20.3_sin_sentido_6_Sp1matA_NT.png` | `figuras_editor/20-Datos_sin_sentido/Fig_20.3_sin_sentido_6_Sp1matA_NT.pdf` |  |
| 4 | 20.4 | 370 | render_dual | `images/sin_sentido_8_Sp1matU_NS.png` | `figuras_editor/20-Datos_sin_sentido/Fig_20.4_sin_sentido_8_Sp1matU_NS.png` | `figuras_editor/20-Datos_sin_sentido/Fig_20.4_sin_sentido_8_Sp1matU_NS.pdf` |  |
| 5 | 20.5 | 425 | render_dual | `images/sin_sentido_9_SerapiaA.png` | `figuras_editor/20-Datos_sin_sentido/Fig_20.5_sin_sentido_9_SerapiaA.png` | `figuras_editor/20-Datos_sin_sentido/Fig_20.5_sin_sentido_9_SerapiaA.pdf` |  |
| 6 | 20.6 | 463 | dynamic | `chunk 'fig-sin_sentido_10'` | `figuras_editor/20-Datos_sin_sentido/Fig_20.6_fig-sin_sentido_10-1.png` | `figuras_editor/20-Datos_sin_sentido/Fig_20.6_fig-sin_sentido_10-1.pdf` |  |
| 7 | 20.7 | 535 | render_dual | `images/sin_sentido_11_Sp1matA_Fert2.png` | `figuras_editor/20-Datos_sin_sentido/Fig_20.7_sin_sentido_11_Sp1matA_Fert2.png` | `figuras_editor/20-Datos_sin_sentido/Fig_20.7_sin_sentido_11_Sp1matA_Fert2.pdf` |  |
| 8 | 20.8 | 512 | dynamic | `chunk 'fig-sin_sentido_11'` | `figuras_editor/20-Datos_sin_sentido/Fig_20.8_fig-sin_sentido_11-2.png` | `figuras_editor/20-Datos_sin_sentido/Fig_20.8_fig-sin_sentido_11-2.pdf` |  |
| 9 | 20.9 | 637 | render_dual | `images/sin_sentido_15_Dirichlet.png` | `figuras_editor/20-Datos_sin_sentido/Fig_20.9_sin_sentido_15_Dirichlet.png` | `figuras_editor/20-Datos_sin_sentido/Fig_20.9_sin_sentido_15_Dirichlet.pdf` |  |
| 10 | 20.10 | 676 | dynamic | `chunk 'fig-sin_sentido_17'` | `figuras_editor/20-Datos_sin_sentido/Fig_20.10_fig-sin_sentido_17-1.png` | `figuras_editor/20-Datos_sin_sentido/Fig_20.10_fig-sin_sentido_17-1.pdf` |  |
| 11 | 20.11 | 734 | dynamic | `chunk 'fig-sin_sentido_19'` | `figuras_editor/20-Datos_sin_sentido/Fig_20.11_fig-sin_sentido_19-1.png` | `figuras_editor/20-Datos_sin_sentido/Fig_20.11_fig-sin_sentido_19-1.pdf` |  |

### ApA-Lista_especies

Archivo fuente: `Appendix_A_Species_List.qmd` — 2 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | A.1 | 169 | static | `images/Trichocentrum_undulatum_8_Hong_Liu.jpg` | `figuras_editor/ApA-Lista_especies/Fig_A.1_Trichocentrum_undulatum_8_Hong_Liu.jpg` | `` | *Trichocentrum undulatum*. Foto: Hong Liu |
| 2 | A.2 | 194 | static | `images/Spiranthes_delitescens_Mitchel_Mcclaran.jpg` | `figuras_editor/ApA-Lista_especies/Fig_A.2_Spiranthes_delitescens_Mitchel_Mcclaran.jpg` | `` | *Spiranthes delitescens*. Foto: Mitchel McClaran |
