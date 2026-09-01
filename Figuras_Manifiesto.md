# Manifiesto de figuras — Dinámica Poblacional de Orquídeas

Inventario completo de TODAS las figuras del libro (estáticas markdown + generadas por código R), organizadas por capítulo y orden de aparición. Cada figura está enlazada con su ubicación esperada en `figuras_editor/<capítulo>/` y, cuando aplica, con el número de figura `Fig X.Y` del libro renderizado.

## Resumen

- **Total figuras**: 138
- **Capítulos con figuras**: 20
- **Por tipo**:
  - imagen markdown estática: **53**
  - PNG generado por chunk R (ggplot, plot, etc.): **50**
  - PNG generado por `render_dual()` (DOT → PNG): **32**
  - PNG generado por `ggsave()`: **2**
  - widget HTML (`plot_life_cycle`/`grViz`) sin PNG estático: **1**

## Cómo regenerar este manifiesto

```bash
quarto render                       # genera docs/*_files/figure-html/
Rscript scripts/collect_figures.R   # recolecta a figuras_editor/
```

Para auditar sin copiar: `Rscript scripts/collect_figures.R --audit`

## Inventario por capítulo

### 02-Introduccion

Archivo fuente: `102-Intro.qmd` — 3 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 2.1 | 152 | dynamic | `chunk 'fig-Pop-fig_1'` | `figuras_editor/02-Introduccion/Fig_2.1_fig-Pop-fig_1-1.png` | `figuras_editor/02-Introduccion/Fig_2.1_fig-Pop-fig_1-1.pdf` |  |
| 2 | 2.2 | 311 | static | `images/Tolumnia_variegata_Tremblay.jpeg` | `figuras_editor/02-Introduccion/Fig_2.2_Tolumnia_variegata_Tremblay.jpeg` | `` | *Tolumnia variegata*. Foto: Tremblay. Estudio demográfico: @calvo1993evolutionary. |
| 3 | 2.3 | 335 | static | `images/Demografia_de_una_poblacion.jpg` | `figuras_editor/02-Introduccion/Fig_2.3_Demografia_de_una_poblacion.jpg` | `` | Factores que influyen en la dinámica de una población. |

### 03-Ciclos_de_Vida

Archivo fuente: `103-Ciclos_de_Vida.qmd` — 12 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 3.1 | 20 | widget | `chunk 'CV1-setup-diagrams' (grViz)` | `[WIDGET HTML — sin PNG; chunk: CV1-setup-diagrams]` | `` |  |
| 2 | 3.2 | 163 | render_dual | `images/CV_2.png` | `figuras_editor/03-Ciclos_de_Vida/Fig_3.2_CV_2.png` | `figuras_editor/03-Ciclos_de_Vida/Fig_3.2_CV_2.pdf` |  |
| 3 | 3.3 | 189 | render_dual | `images/CV_3.png` | `figuras_editor/03-Ciclos_de_Vida/Fig_3.3_CV_3.png` | `figuras_editor/03-Ciclos_de_Vida/Fig_3.3_CV_3.pdf` |  |
| 4 | 3.4 | 251 | render_dual | `images/CV_5.png` | `figuras_editor/03-Ciclos_de_Vida/Fig_3.4_CV_5.png` | `figuras_editor/03-Ciclos_de_Vida/Fig_3.4_CV_5.pdf` |  |
| 5 | 3.5 | 287 | render_dual | `images/CV_6Telipogon_helleri.png` | `figuras_editor/03-Ciclos_de_Vida/Fig_3.5_CV_6Telipogon_helleri.png` | `figuras_editor/03-Ciclos_de_Vida/Fig_3.5_CV_6Telipogon_helleri.pdf` |  |
| 6 | 3.6 | 330 | render_dual | `images/CV7Prasophyllum_correctum.png` | `figuras_editor/03-Ciclos_de_Vida/Fig_3.6_CV7Prasophyllum_correctum.png` | `figuras_editor/03-Ciclos_de_Vida/Fig_3.6_CV7Prasophyllum_correctum.pdf` |  |
| 7 | 3.7 | 362 | render_dual | `images/CV8_Ophrys.png` | `figuras_editor/03-Ciclos_de_Vida/Fig_3.7_CV8_Ophrys.png` | `figuras_editor/03-Ciclos_de_Vida/Fig_3.7_CV8_Ophrys.pdf` |  |
| 8 | 3.8 | 369 | static | `images/Orchis_purpurea_1_Hans_Jacquemyn.jpg` | `figuras_editor/03-Ciclos_de_Vida/Fig_3.8_Orchis_purpurea_1_Hans_Jacquemyn.jpg` | `` | *Orchis purpurea*. Foto: Hans Jacquemyn. Estudio demográfico: @jacquemyn2010seed — la limitación por semillas restringe  |
| 9 | 3.9 | 405 | render_dual | `images/CV9_Op.png` | `figuras_editor/03-Ciclos_de_Vida/Fig_3.9_CV9_Op.png` | `figuras_editor/03-Ciclos_de_Vida/Fig_3.9_CV9_Op.pdf` |  |
| 10 | 3.10 | 408 | static | `images/Orchis_purpurea_2_Hans_Jacquemyn.jpg` | `figuras_editor/03-Ciclos_de_Vida/Fig_3.10_Orchis_purpurea_2_Hans_Jacquemyn.jpg` | `` | *Orchis purpurea*. Foto: Hans Jacquemyn. Estudio demográfico: @jacquemyn2010seed. |
| 11 | 3.11 | 450 | render_dual | `images/CV10.png` | `figuras_editor/03-Ciclos_de_Vida/Fig_3.11_CV10.png` | `figuras_editor/03-Ciclos_de_Vida/Fig_3.11_CV10.pdf` |  |
| 12 | 3.12 | 501 | static | `figs/CV11_Rage_plot.png` | `figuras_editor/03-Ciclos_de_Vida/Fig_3.12_CV11_Rage_plot.png` | `` | Diagrama de ciclo de vida construido con el paquete `Rage`. |

### 04-Recopilacion_datos_en_el_campo

Archivo fuente: `104-Recopilacion_datos_en_el_campo.qmd` — 23 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 4.1 | 59 | static | `images/L_autum_epifita.jpg` | `figuras_editor/04-Recopilacion_datos_en_el_campo/Fig_4.1_L_autum_epifita.jpg` | `` | Crecimiento epífito de *Laelia autumnalis* sobre las ramas y tronco de un encino. Foto: Aucencia Emeterio-Lara. Estudio  |
| 2 | 4.2 | 86 | static | `images/L_autum_rupicola.jpg` | `figuras_editor/04-Recopilacion_datos_en_el_campo/Fig_4.2_L_autum_rupicola.jpg` | `` | *Laelia autumnalis* en su hábitat rupícola. Foto: Aucencia Emeterio-Lara. Estudio demográfico: @emeterio2021does. |
| 3 | 4.3 | 110 | static | `images/Trichocentrum_undulatum_9_Hong_Liu.jpeg` | `figuras_editor/04-Recopilacion_datos_en_el_campo/Fig_4.3_Trichocentrum_undulatum_9_Hong_Liu.jpeg` | `` | *Trichocentrum undulatum*. Foto: Hong Liu. Estudio demográfico: @borrero2023populations — modelos matriciales muestran q |
| 4 | 4.4 | 114 | static | `images/Trichocentrum_undulatum_1_Hong_Liu.jpg` | `figuras_editor/04-Recopilacion_datos_en_el_campo/Fig_4.4_Trichocentrum_undulatum_1_Hong_Liu.jpg` | `` | *Trichocentrum undulatum*. Foto: Hong Liu. Estudio demográfico: @borrero2023populations. |
| 5 | 4.5 | 136 | static | `images/lepanthes_rupestris.jpeg` | `figuras_editor/04-Recopilacion_datos_en_el_campo/Fig_4.5_lepanthes_rupestris.jpeg` | `` | *Lepanthes rupestris* con inflorescencias seca y activa. Foto: Raymond L. Tremblay. Estudio demográfico: @tremblay2015st |
| 6 | 4.6 | 159 | static | `images/Pk_modulo.jpeg` | `figuras_editor/04-Recopilacion_datos_en_el_campo/Fig_4.6_Pk_modulo.jpeg` | `` | *Prosthechea karwinskii*. Foto: Mariana Hernández-Apolinar. Estudio demográfico: @elliott2014demography. |
| 7 | 4.7 | 172 | static | `images/Ci_modulo.png` | `figuras_editor/04-Recopilacion_datos_en_el_campo/Fig_4.7_Ci_modulo.png` | `` | *Cypripedium irapeanum*. Foto: Claudia C. Gutiérrez-Paredes. Estudios poblacionales: @hernandez2012ecological — aspectos |
| 8 | 4.8 | 185 | static | `images/V_planifolia_monopo.png` | `figuras_editor/04-Recopilacion_datos_en_el_campo/Fig_4.8_V_planifolia_monopo.png` | `` | *Vanilla planifolia*. Foto: Mark Blackman. |
| 9 | 4.9 | 191 | static | `images/Ls_simpodio.jpg` | `figuras_editor/04-Recopilacion_datos_en_el_campo/Fig_4.9_Ls_simpodio.jpg` | `` | *Laelia speciosa*. Foto: Leonel López-Toledo. Estudio demográfico: @hernandez1992dinamica. |
| 10 | 4.10 | 220 | static | `images/Figura_4.10.jpg` | `figuras_editor/04-Recopilacion_datos_en_el_campo/Fig_4.10_Figura_4.10.jpg` | `` | Técnica de rapel usada para el muestreo de orquídeas rupícolas: *Dendrobium*. Foto: Hong Liu, 2020. |
| 11 | 4.11 | 224 | static | `images/Ascenso_Pk.jpg` | `figuras_editor/04-Recopilacion_datos_en_el_campo/Fig_4.11_Ascenso_Pk.jpg` | `` | Muestreo de orquídeas epífitas con ascenso de una sola cuerda: *Prosthechea karwinskii*. Foto: Alonso Argüero. |
| 12 | 4.12 | 237 | static | `images/Cattling_y_Johannson.png` | `figuras_editor/04-Recopilacion_datos_en_el_campo/Fig_4.12_Cattling_y_Johannson.png` | `` | Zonificación de árboles hospederos, basada en los modelos Catling (1986) y Johansson (1974). Dibujo de A. Emeterio-Lara. |
| 13 | 4.13 | 294 | static | `images/Ls_xyz.png` | `figuras_editor/04-Recopilacion_datos_en_el_campo/Fig_4.13_Ls_xyz.png` | `` | Distribución tridimensional de *Laelia speciosa* sobre *Quercus deserticola*, basada en @hernandez1992dinamica. Figura d |
| 14 | 4.14 | 300 | static | `images/tree_dist.png` | `figuras_editor/04-Recopilacion_datos_en_el_campo/Fig_4.14_tree_dist.png` | `` | Distribución espacial de los árboles hospederos de *Laelia speciosa*. Los círculos dentro del área de muestreo represent |
| 15 | 4.15 | 311 | static | `images/Triangulation_Method.jpg` | `figuras_editor/04-Recopilacion_datos_en_el_campo/Fig_4.15_Triangulation_Method.jpg` | `` | Método de triangulación para el muestreo de orquídeas terrestres. Se ilustra la forma de determinar la posición ($P_{x}$ |
| 16 | 4.16 | 345 | static | `images/C_irap_plantula.jpeg` | `figuras_editor/04-Recopilacion_datos_en_el_campo/Fig_4.16_C_irap_plantula.jpeg` | `` | Plántula de *Cypripedium irapeanum*. Foto: Claudia Gutiérrez-Paredes. Estudios poblacionales: @hernandez2012ecological. |
| 17 | 4.17 | 351 | static | `images/Lepanthes_woodburyana.jpg` | `figuras_editor/04-Recopilacion_datos_en_el_campo/Fig_4.17_Lepanthes_woodburyana.jpg` | `` | *Lepanthes woodburyana*. Foto: Edwin Guevara. Estudio demográfico: @tremblay2003population. |
| 18 | 4.18 | 383 | static | `images/Cypripedium_acaule.jpg` | `figuras_editor/04-Recopilacion_datos_en_el_campo/Fig_4.18_Cypripedium_acaule.jpg` | `` | Uso de etiquetas de aluminio en marcaje de *Cypripedium acaule*. Foto: Tremblay. |
| 19 | 4.19 | 387 | static | `images/Laelia_cincho.png` | `figuras_editor/04-Recopilacion_datos_en_el_campo/Fig_4.19_Laelia_cincho.png` | `` | Uso de etiquetas de aluminio en marcaje con cinchos de plástico en *Laelia autumnalis*. Foto por Aucencia Emeterio-Lara. |
| 20 | 4.20 | 425 | static | `images/alambrelaelia.jpg` | `figuras_editor/04-Recopilacion_datos_en_el_campo/Fig_4.20_alambrelaelia.jpg` | `` | Marcaje de *Laelia speciosa* abrazando el tronco con alambre plastificado y etiquetas de *dymo*. Foto: Mariana Hernández |
| 21 | 4.21 | 431 | static | `images/Lep_eltoroensis.png` | `figuras_editor/04-Recopilacion_datos_en_el_campo/Fig_4.21_Lep_eltoroensis.png` | `` | Los individuos de *Lepanthes eltoroensis* fueron identificados con una etiqueta de plástico clavada al tronco del árbol; |
| 22 | 4.22 | 437 | static | `images/Cirap_marcaje.png` | `figuras_editor/04-Recopilacion_datos_en_el_campo/Fig_4.22_Cirap_marcaje.png` | `` | Marcaje de *Cypripedium irapeanum* con cinta de *dymo*. Foto: Hernández-Apolinar. |
| 23 | 4.23 | 441 | static | `images/Cyp_acaule_flag.jpg` | `figuras_editor/04-Recopilacion_datos_en_el_campo/Fig_4.23_Cyp_acaule_flag.jpg` | `` | Marcaje de *Cypripedium acaule* con banderitas. Foto: Tremblay. |

### 05-Transiciones

Archivo fuente: `105-Transiciones.qmd` — 1 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 5.1 | 480 | render_dual | `images/Trans14_Cyp_calceolus_clon.png` | `figuras_editor/05-Transiciones/Fig_5.1_Trans14_Cyp_calceolus_clon.png` | `figuras_editor/05-Transiciones/Fig_5.1_Trans14_Cyp_calceolus_clon.pdf` |  |

### 06-Fecundidad

Archivo fuente: `106-calcular_fecundidad.qmd` — 5 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 6.1 | 144 | static | `images/Diagrama_fecundidad.png` | `figuras_editor/06-Fecundidad/Fig_6.1_Diagrama_fecundidad.png` | `` | Diagrama del proceso de fecundidad en orquídeas, mostrando la cadena de filtros sucesivos: producción floral, polinizaci |
| 2 | 6.2 | 165 | static | `images/Cant_Hojas_Prob_Fr_Brassavola.jpg` | `figuras_editor/06-Fecundidad/Fig_6.2_Cant_Hojas_Prob_Fr_Brassavola.jpg` | `` | Relación entre la cantidad de hojas y la probabilidad de floración en *Brassavola cucullata* en las islas Saba y San Eus |
| 3 | 6.3 | 190 | render_dual | `images/fec-life-cycle-1.png` | `figuras_editor/06-Fecundidad/Fig_6.3_fec-life-cycle-1.png` | `figuras_editor/06-Fecundidad/Fig_6.3_fec-life-cycle-1.pdf` |  |
| 4 | 6.4 | 228 | render_dual | `images/fec-matA-pl.png` | `figuras_editor/06-Fecundidad/Fig_6.4_fec-matA-pl.png` | `figuras_editor/06-Fecundidad/Fig_6.4_fec-matA-pl.pdf` |  |
| 5 | 6.5 | 255 | render_dual | `images/fec-matA-pl2.png` | `figuras_editor/06-Fecundidad/Fig_6.5_fec-matA-pl2.png` | `figuras_editor/06-Fecundidad/Fig_6.5_fec-matA-pl2.pdf` |  |

### 07-matU_matF_matC

Archivo fuente: `107-matU_matF_matC.qmd` — 5 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 7.1 | 69 | static | `images/Matrices_A_U_F_C.jpg` | `figuras_editor/07-matU_matF_matC/Fig_7.1_Matrices_A_U_F_C.jpg` | `` | Relación entre matrices; Diseño: Samuel Gascoigne. |
| 2 | 7.2 | 94 | render_dual | `images/matU_matA1.png` | `figuras_editor/07-matU_matF_matC/Fig_7.2_matU_matA1.png` | `figuras_editor/07-matU_matF_matC/Fig_7.2_matU_matA1.pdf` |  |
| 3 | 7.3 | 126 | render_dual | `images/matU_matA2.png` | `figuras_editor/07-matU_matF_matC/Fig_7.3_matU_matA2.png` | `figuras_editor/07-matU_matF_matC/Fig_7.3_matU_matA2.pdf` |  |
| 4 | 7.4 | 331 | render_dual | `images/matU_mat13_Cyp_cal_clon.png` | `figuras_editor/07-matU_matF_matC/Fig_7.4_matU_mat13_Cyp_cal_clon.png` | `figuras_editor/07-matU_matF_matC/Fig_7.4_matU_mat13_Cyp_cal_clon.pdf` |  |
| 5 | 7.5 | 421 | render_dual | `images/matU_mat18_Aechmea_clon.png` | `figuras_editor/07-matU_matF_matC/Fig_7.5_matU_mat18_Aechmea_clon.png` | `figuras_editor/07-matU_matF_matC/Fig_7.5_matU_mat18_Aechmea_clon.pdf` |  |

### 08-Bayesian_PPM

Archivo fuente: `108-Bayesian_PPM.qmd` — 6 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 8.1 | 143 | render_dual | `images/bayes2.png` | `figuras_editor/08-Bayesian_PPM/Fig_8.1_bayes2.png` | `figuras_editor/08-Bayesian_PPM/Fig_8.1_bayes2.pdf` |  |
| 2 | 8.2 | 209 | static | `images/Lepanthes_eltoroensis_Edwin_Guevara.jpg` | `figuras_editor/08-Bayesian_PPM/Fig_8.2_Lepanthes_eltoroensis_Edwin_Guevara.jpg` | `` | *Lepanthes eltoroensis*. Foto: Edwin Guevara. Estudio demográfico: @tremblay2003population. |
| 3 | 8.3 | 211 | static | `images/Lepanthes_eltoroensis_Phorophyte_Edwin_Guevara.jpg` | `figuras_editor/08-Bayesian_PPM/Fig_8.3_Lepanthes_eltoroensis_Phorophyte_Edwin_Guevara.jpg` | `` | *Lepanthes eltoroensis*. Foto: Edwin Guevara. Estudio demográfico: @tremblay2003population. |
| 4 | 8.4 | 344 | render_dual | `images/bayes11.png` | `figuras_editor/08-Bayesian_PPM/Fig_8.4_bayes11.png` | `figuras_editor/08-Bayesian_PPM/Fig_8.4_bayes11.pdf` |  |
| 5 | 8.5 | 546 | dynamic | `chunk 'fig-bayes16'` | `figuras_editor/08-Bayesian_PPM/Fig_8.5_fig-bayes16-1.png` | `figuras_editor/08-Bayesian_PPM/Fig_8.5_fig-bayes16-1.pdf` |  |
| 6 | 8.6 | 646 | dynamic | `chunk 'fig-bayes19'` | `figuras_editor/08-Bayesian_PPM/Fig_8.6_fig-bayes19-1.png` | `figuras_editor/08-Bayesian_PPM/Fig_8.6_fig-bayes19-1.pdf` |  |

### 09-Crecimiento_poblacional

Archivo fuente: `109-Crecimiento_poblacional.qmd` — 4 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 9.1 | 91 | render_dual | `images/cre_pop_1_Laelia_p1.png` | `figuras_editor/09-Crecimiento_poblacional/Fig_9.1_cre_pop_1_Laelia_p1.png` | `figuras_editor/09-Crecimiento_poblacional/Fig_9.1_cre_pop_1_Laelia_p1.pdf` |  |
| 2 | 9.2 | 113 | render_dual | `images/cre_pop_1b_Laelia_p2.png` | `figuras_editor/09-Crecimiento_poblacional/Fig_9.2_cre_pop_1b_Laelia_p2.png` | `figuras_editor/09-Crecimiento_poblacional/Fig_9.2_cre_pop_1b_Laelia_p2.pdf` |  |
| 3 | 9.3 | 180 | dynamic | `chunk 'fig-cre-pop-projection-2'` | `figuras_editor/09-Crecimiento_poblacional/Fig_9.3_fig-cre-pop-projection-2-1.png` | `figuras_editor/09-Crecimiento_poblacional/Fig_9.3_fig-cre-pop-projection-2-1.pdf` |  |
| 4 | 9.4 | 199 | dynamic | `chunk 'fig-cre-pop-projection-3'` | `figuras_editor/09-Crecimiento_poblacional/Fig_9.4_fig-cre-pop-projection-3-1.png` | `figuras_editor/09-Crecimiento_poblacional/Fig_9.4_fig-cre-pop-projection-3-1.pdf` |  |

### 10-Propiedades

Archivo fuente: `110-Propriedades.qmd` — 6 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 10.1 | 158 | render_dual | `images/Indice5_Lr1_No_erg.png` | `figuras_editor/10-Propiedades/Fig_10.1_Indice5_Lr1_No_erg.png` | `figuras_editor/10-Propiedades/Fig_10.1_Indice5_Lr1_No_erg.pdf` |  |
| 2 | 10.2 | 251 | render_dual | `images/Indice_Lr1_Irr.png` | `figuras_editor/10-Propiedades/Fig_10.2_Indice_Lr1_Irr.png` | `figuras_editor/10-Propiedades/Fig_10.2_Indice_Lr1_Irr.pdf` |  |
| 3 | 10.3 | 339 | dynamic | `chunk 'fig-Indice10'` | `figuras_editor/10-Propiedades/Fig_10.3_fig-Indice10-1.png` | `figuras_editor/10-Propiedades/Fig_10.3_fig-Indice10-1.pdf` |  |
| 4 | 10.4 | 378 | static | `images/Spathoglottis_plicata_Tremblay.jpeg` | `figuras_editor/10-Propiedades/Fig_10.4_Spathoglottis_plicata_Tremblay.jpeg` | `` | *Spathoglottis plicata*. Foto: Tremblay. Estudio demográfico: @falcon2017quantifying. |
| 5 | 10.5 | 443 | dynamic | `chunk 'fig-Indice13'` | `figuras_editor/10-Propiedades/Fig_10.5_fig-Indice13-1.png` | `figuras_editor/10-Propiedades/Fig_10.5_fig-Indice13-1.pdf` |  |
| 6 | 10.6 | 559 | dynamic | `chunk 'fig-indice16'` | `figuras_editor/10-Propiedades/Fig_10.6_fig-indice16-1.png` | `figuras_editor/10-Propiedades/Fig_10.6_fig-indice16-1.pdf` |  |

### 11-Elasticidad

Archivo fuente: `111-Elasticidad.qmd` — 6 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 11.1 | 227 | static | `images/Lepanthes_eltoroensis_Tremblay.jpeg` | `figuras_editor/11-Elasticidad/Fig_11.1_Lepanthes_eltoroensis_Tremblay.jpeg` | `` | *Lepanthes eltoroensis*. Foto: Tremblay. Estudio demográfico: @tremblay2003population. |
| 2 | 11.2 | 265 | static | `images/Lepanthes_caritensis_Edwin_Guevara.jpg` | `figuras_editor/11-Elasticidad/Fig_11.2_Lepanthes_caritensis_Edwin_Guevara.jpg` | `` | *Lepanthes caritensis*. Foto: Edwin Guevara. Estudio demográfico: @tremblay1997lepanthes. |
| 3 | 11.3 | 269 | static | `images/Lepanthes_caritensis_Phorophyte.jpg` | `figuras_editor/11-Elasticidad/Fig_11.3_Lepanthes_caritensis_Phorophyte.jpg` | `` | *Lepanthes caritensis*. Foto: Edwin Guevara. Estudio demográfico: @tremblay1997lepanthes. |
| 4 | 11.4 | 274 | dynamic | `chunk 'fig-Elas7'` | `figuras_editor/11-Elasticidad/Fig_11.4_fig-Elas7-1.png` | `figuras_editor/11-Elasticidad/Fig_11.4_fig-Elas7-1.pdf` |  |
| 5 | 11.5 | 306 | dynamic | `chunk 'fig-Elas8'` | `figuras_editor/11-Elasticidad/Fig_11.5_fig-Elas8-1.png` | `figuras_editor/11-Elasticidad/Fig_11.5_fig-Elas8-1.pdf` |  |
| 6 | 11.6 | 348 | static | `images/Laelia_speciosa_Eduardo_A._Perez_Garcia.jpeg` | `figuras_editor/11-Elasticidad/Fig_11.6_Laelia_speciosa_Eduardo_A._Perez_Garcia.jpeg` | `` | *Laelia speciosa*. Foto: Eduardo A. Pérez García. Estudio demográfico: @hernandez1992dinamica. |

### 12-Dinamica_transitoria

Archivo fuente: `112-Dinamica_de_Transiciones.qmd` — 9 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 12.1 | 105 | static | `images/Lepanthes_rupestris_Tremblay.jpeg` | `figuras_editor/12-Dinamica_transitoria/Fig_12.1_Lepanthes_rupestris_Tremblay.jpeg` | `` | *Lepanthes rupestris*. Foto: Tremblay. Estudio demográfico: @tremblay2015stable. |
| 2 | 12.2 | 230 | dynamic | `chunk 'fig-trans4'` | `figuras_editor/12-Dinamica_transitoria/Fig_12.2_fig-trans4-1.png` | `figuras_editor/12-Dinamica_transitoria/Fig_12.2_fig-trans4-1.pdf` |  |
| 3 | 12.3 | 294 | dynamic | `chunk 'fig-trans6'` | `figuras_editor/12-Dinamica_transitoria/Fig_12.3_fig-trans6-1.png` | `figuras_editor/12-Dinamica_transitoria/Fig_12.3_fig-trans6-1.pdf` |  |
| 4 | 12.4 | 350 | dynamic | `chunk 'fig-trans8'` | `figuras_editor/12-Dinamica_transitoria/Fig_12.4_fig-trans8-1.png` | `figuras_editor/12-Dinamica_transitoria/Fig_12.4_fig-trans8-1.pdf` |  |
| 5 | 12.5 | 408 | dynamic | `chunk 'fig-trans10'` | `figuras_editor/12-Dinamica_transitoria/Fig_12.5_fig-trans10-1.png` | `figuras_editor/12-Dinamica_transitoria/Fig_12.5_fig-trans10-1.pdf` |  |
| 6 | 12.6 | 577 | dynamic | `chunk 'fig-trans14'` | `figuras_editor/12-Dinamica_transitoria/Fig_12.6_fig-trans14-1.png` | `figuras_editor/12-Dinamica_transitoria/Fig_12.6_fig-trans14-1.pdf` |  |
| 7 | 12.7 | 616 | dynamic | `chunk 'fig-trans15'` | `figuras_editor/12-Dinamica_transitoria/Fig_12.7_fig-trans15-1.png` | `figuras_editor/12-Dinamica_transitoria/Fig_12.7_fig-trans15-1.pdf` |  |
| 8 | 12.8 | 821 | dynamic | `chunk 'fig-trans22'` | `figuras_editor/12-Dinamica_transitoria/Fig_12.8_fig-trans22-1.png` | `figuras_editor/12-Dinamica_transitoria/Fig_12.8_fig-trans22-1.pdf` |  |
| 9 | 12.9 | 887 | dynamic | `chunk 'fig-trans23'` | `figuras_editor/12-Dinamica_transitoria/Fig_12.9_fig-trans23-1.png` | `figuras_editor/12-Dinamica_transitoria/Fig_12.9_fig-trans23-1.pdf` |  |

### 13-Funciones_de_Transferencia

Archivo fuente: `113-Funciones_de_Transferencia.qmd` — 11 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 13.1 | 309 | dynamic | `chunk 'fig-tf-nLr0-init'` | `figuras_editor/13-Funciones_de_Transferencia/Fig_13.1_fig-tf-nLr0-init-1.png` | `figuras_editor/13-Funciones_de_Transferencia/Fig_13.1_fig-tf-nLr0-init-1.pdf` |  |
| 2 | 13.2 | 356 | dynamic | `chunk 'fig-tf-tf5-calc'` | `figuras_editor/13-Funciones_de_Transferencia/Fig_13.2_fig-tf-tf5-calc-1.png` | `figuras_editor/13-Funciones_de_Transferencia/Fig_13.2_fig-tf-tf5-calc-1.pdf` |  |
| 3 | 13.3 | 394 | dynamic | `chunk 'fig-tf-tf9-calc'` | `figuras_editor/13-Funciones_de_Transferencia/Fig_13.3_fig-tf-tf9-calc-1.png` | `figuras_editor/13-Funciones_de_Transferencia/Fig_13.3_fig-tf-tf9-calc-1.pdf` |  |
| 4 | 13.4 | 435 | dynamic | `chunk 'fig-tf-tf8-calc'` | `figuras_editor/13-Funciones_de_Transferencia/Fig_13.4_fig-tf-tf8-calc-1.png` | `figuras_editor/13-Funciones_de_Transferencia/Fig_13.4_fig-tf-tf8-calc-1.pdf` |  |
| 5 | 13.5 | 497 | dynamic | `chunk 'fig-transF3'` | `figuras_editor/13-Funciones_de_Transferencia/Fig_13.5_fig-transF3-1.png` | `figuras_editor/13-Funciones_de_Transferencia/Fig_13.5_fig-transF3-1.pdf` |  |
| 6 | 13.6 | 565 | dynamic | `chunk 'fig-tf-n0-init'` | `figuras_editor/13-Funciones_de_Transferencia/Fig_13.6_fig-tf-n0-init-1.png` | `figuras_editor/13-Funciones_de_Transferencia/Fig_13.6_fig-tf-n0-init-1.pdf` |  |
| 7 | 13.7 | 595 | dynamic | `chunk 'fig-tf-par-mfrow'` | `figuras_editor/13-Funciones_de_Transferencia/Fig_13.7_fig-tf-par-mfrow-1.png` | `figuras_editor/13-Funciones_de_Transferencia/Fig_13.7_fig-tf-par-mfrow-1.pdf` |  |
| 8 | 13.8 | 625 | dynamic | `chunk 'fig-tf-etype-matrix'` | `figuras_editor/13-Funciones_de_Transferencia/Fig_13.8_fig-tf-etype-matrix-1.png` | `figuras_editor/13-Funciones_de_Transferencia/Fig_13.8_fig-tf-etype-matrix-1.pdf` |  |
| 9 | 13.9 | 646 | dynamic | `chunk 'fig-tf-tfmatL-init'` | `figuras_editor/13-Funciones_de_Transferencia/Fig_13.9_fig-tf-tfmatL-init-1.png` | `figuras_editor/13-Funciones_de_Transferencia/Fig_13.9_fig-tf-tfmatL-init-1.pdf` |  |
| 10 | 13.10 | 661 | dynamic | `chunk 'fig-transF5'` | `figuras_editor/13-Funciones_de_Transferencia/Fig_13.10_fig-transF5-1.png` | `figuras_editor/13-Funciones_de_Transferencia/Fig_13.10_fig-transF5-1.pdf` |  |
| 11 | 13.11 | 1089 | dynamic | `chunk 'fig-tf-grid-cowplot'` | `figuras_editor/13-Funciones_de_Transferencia/Fig_13.11_fig-tf-grid-cowplot-1.png` | `figuras_editor/13-Funciones_de_Transferencia/Fig_13.11_fig-tf-grid-cowplot-1.pdf` |  |

### 14-LTRE

Archivo fuente: `114-LTRE.qmd` — 7 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 14.1 | 150 | static | `images/Imagen1.jpg` | `figuras_editor/14-LTRE/Fig_14.1_Imagen1.jpg` | `` | Matrices de proyección poblacional de *Oncidium brachyandrum* en dos hospederos (*Quercus martinezii* y *Q. rugosa*), co |
| 2 | 14.2 | 213 | render_dual | `images/LTRE2_Oncidium_brachyandrum_Quercus_martinezii.png` | `figuras_editor/14-LTRE/Fig_14.2_LTRE2_Oncidium_brachyandrum_Quercus_martinezii.png` | `figuras_editor/14-LTRE/Fig_14.2_LTRE2_Oncidium_brachyandrum_Quercus_martinezii.pdf` |  |
| 3 | 14.3 | 272 | render_dual | `images/LTRE3_Oncidium_brachyandrum_Quercus_rugosa.png` | `figuras_editor/14-LTRE/Fig_14.3_LTRE3_Oncidium_brachyandrum_Quercus_rugosa.png` | `figuras_editor/14-LTRE/Fig_14.3_LTRE3_Oncidium_brachyandrum_Quercus_rugosa.pdf` |  |
| 4 | 14.4 | 508 | dynamic | `chunk 'fig-LTRE15'` | `figuras_editor/14-LTRE/Fig_14.4_fig-LTRE15-1.png` | `figuras_editor/14-LTRE/Fig_14.4_fig-LTRE15-1.pdf` |  |
| 5 | 14.5 | 547 | dynamic | `chunk 'fig-LTRE16'` | `figuras_editor/14-LTRE/Fig_14.5_fig-LTRE16-1.png` | `figuras_editor/14-LTRE/Fig_14.5_fig-LTRE16-1.pdf` |  |
| 6 | 14.6 | 713 | dynamic | `chunk 'fig-LRE25'` | `figuras_editor/14-LTRE/Fig_14.6_fig-LRE25-1.png` | `figuras_editor/14-LTRE/Fig_14.6_fig-LRE25-1.pdf` |  |
| 7 | 14.7 | 734 | dynamic | `chunk 'fig-LRE26'` | `figuras_editor/14-LTRE/Fig_14.7_fig-LRE26-1.png` | `figuras_editor/14-LTRE/Fig_14.7_fig-LRE26-1.pdf` |  |

### 15-Metodos_de_simulaciones

Archivo fuente: `115-Metodos_de_simulaciones.qmd` — 9 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 15.1 | 122 | static | `images/Serapias_cordigera_5_Giuseppe_Pellegrino.jpeg` | `figuras_editor/15-Metodos_de_simulaciones/Fig_15.1_Serapias_cordigera_5_Giuseppe_Pellegrino.jpeg` | `` | *Serapias cordigera*. Foto: Giuseppe Pellegrino. Estudio demográfico: @pellegrino2014effects. |
| 2 | 15.2 | 239 | static | `images/Serapias_cordigera_7_Giuseppe_Pellegrino.jpg` | `figuras_editor/15-Metodos_de_simulaciones/Fig_15.2_Serapias_cordigera_7_Giuseppe_Pellegrino.jpg` | `` | *Serapias cordigera*. Foto: Giuseppe Pellegrino. Estudio demográfico: @pellegrino2014effects. |
| 3 | 15.3 | 242 | dynamic | `chunk 'fig-sim4'` | `figuras_editor/15-Metodos_de_simulaciones/Fig_15.3_fig-sim4-1.png` | `figuras_editor/15-Metodos_de_simulaciones/Fig_15.3_fig-sim4-1.pdf` |  |
| 4 | 15.4 | 265 | dynamic | `chunk 'fig-sim5'` | `figuras_editor/15-Metodos_de_simulaciones/Fig_15.4_fig-sim5-1.png` | `figuras_editor/15-Metodos_de_simulaciones/Fig_15.4_fig-sim5-1.pdf` |  |
| 5 | 15.5 | 311 | dynamic | `chunk 'fig-sim7'` | `figuras_editor/15-Metodos_de_simulaciones/Fig_15.5_fig-sim7-1.png` | `figuras_editor/15-Metodos_de_simulaciones/Fig_15.5_fig-sim7-1.pdf` |  |
| 6 | 15.6 | 433 | dynamic | `chunk 'fig-sim-diverging-colors'` | `figuras_editor/15-Metodos_de_simulaciones/Fig_15.6_fig-sim-diverging-colors-1.png` | `figuras_editor/15-Metodos_de_simulaciones/Fig_15.6_fig-sim-diverging-colors-1.pdf` |  |
| 7 | 15.7 | 456 | static | `images/Serapias_cordigera_3_Giuseppe_Pellegrino.jpeg` | `figuras_editor/15-Metodos_de_simulaciones/Fig_15.7_Serapias_cordigera_3_Giuseppe_Pellegrino.jpeg` | `` | *Serapias cordigera*. Foto: Giuseppe Pellegrino. Estudio demográfico: @pellegrino2014effects. |
| 8 | 15.8 | 699 | dynamic | `chunk 'fig-sim18'` | `figuras_editor/15-Metodos_de_simulaciones/Fig_15.8_fig-sim18-1.png` | `figuras_editor/15-Metodos_de_simulaciones/Fig_15.8_fig-sim18-1.pdf` |  |
| 9 | 15.9 | 951 | ggsave | `images/distribucion_beta_Serapias_A3.png` | `figuras_editor/15-Metodos_de_simulaciones/Fig_15.9_distribucion_beta_Serapias_A3.png` | `figuras_editor/15-Metodos_de_simulaciones/Fig_15.9_distribucion_beta_Serapias_A3.pdf` |  |

### 17-Rage

Archivo fuente: `120-Rage_orquideas.qmd` — 8 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 17.1 | 181 | dynamic | `chunk 'fig-Rage8'` | `figuras_editor/17-Rage/Fig_17.1_fig-Rage8-1.png` | `figuras_editor/17-Rage/Fig_17.1_fig-Rage8-1.pdf` |  |
| 2 | 17.2 | 208 | dynamic | `chunk 'fig-Rage9'` | `figuras_editor/17-Rage/Fig_17.2_fig-Rage9-1.png` | `figuras_editor/17-Rage/Fig_17.2_fig-Rage9-1.pdf` |  |
| 3 | 17.3 | 305 | ggsave | `images/Duración_Epi_Ter.png` | `figuras_editor/17-Rage/Fig_17.3_Duración_Epi_Ter.png` | `figuras_editor/17-Rage/Fig_17.3_Duración_Epi_Ter.pdf` |  |
| 4 | 17.4 | 620 | dynamic | `chunk 'fig-Rage29'` | `figuras_editor/17-Rage/Fig_17.4_fig-Rage29-1.png` | `figuras_editor/17-Rage/Fig_17.4_fig-Rage29-1.pdf` |  |
| 5 | 17.5 | 670 | dynamic | `chunk 'fig-Rage31'` | `figuras_editor/17-Rage/Fig_17.5_fig-Rage31-1.png` | `figuras_editor/17-Rage/Fig_17.5_fig-Rage31-1.pdf` |  |
| 6 | 17.6 | 692 | dynamic | `chunk 'fig-Rage32'` | `figuras_editor/17-Rage/Fig_17.6_fig-Rage32-1.png` | `figuras_editor/17-Rage/Fig_17.6_fig-Rage32-1.pdf` |  |
| 7 | 17.7 | 754 | dynamic | `chunk 'fig-Rage35'` | `figuras_editor/17-Rage/Fig_17.7_fig-Rage35-1.png` | `figuras_editor/17-Rage/Fig_17.7_fig-Rage35-1.pdf` |  |
| 8 | 17.8 | 866 | dynamic | `chunk 'fig-Rage_compare_plot'` | `figuras_editor/17-Rage/Fig_17.8_fig-Rage_compare_plot-1.png` | `figuras_editor/17-Rage/Fig_17.8_fig-Rage_compare_plot-1.pdf` |  |

### 18-Protocolo

Archivo fuente: `121-Traduccion_protocolo_informacion.qmd` — 5 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 18.1 | 101 | static | `images/Survey_paper.png` | `figuras_editor/18-Protocolo/Fig_18.1_Survey_paper.png` | `` | Survey results from experts in population ecology that participated (n = 60). Participants ranked their confidence in th |
| 2 | 18.2 | 111 | static | `images/Database_paper.png` | `figuras_editor/18-Protocolo/Fig_18.2_Database_paper.png` | `` | Both plant and animal MPM papers show similar heterogeneity in the presented components of MPMs. Percentage of peer-revi |
| 3 | 18.3 | 115 | static | `images/COMPADRE_MADRE.png` | `figuras_editor/18-Protocolo/Fig_18.3_COMPADRE_MADRE.png` | `` | Across plant and animal MPM papers, most publications do not contain sufficient information for reproducibility. Proport |
| 4 | 18.4 | 212 | render_dual | `images/Proto1_diagrama_ciclo.png` | `figuras_editor/18-Protocolo/Fig_18.4_Proto1_diagrama_ciclo.png` | `figuras_editor/18-Protocolo/Fig_18.4_Proto1_diagrama_ciclo.pdf` |  |
| 5 | 18.5 | 367 | static | `images/Matrices_A_U_F_C.jpg` | `figuras_editor/18-Protocolo/Fig_18.5_Matrices_A_U_F_C.jpg` | `` | Decomposing an MPM into its submatrices allows for the isolation of otherwise masked vital rates. Matrix **A** represent |

### 19-Datos_sin_sentido

Archivo fuente: `122-Impacto_de_Datos_sin_Sentido.qmd` — 11 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 19.1 | 125 | render_dual | `images/sin_sentido_2_Sp1matA.png` | `figuras_editor/19-Datos_sin_sentido/Fig_19.1_sin_sentido_2_Sp1matA.png` | `figuras_editor/19-Datos_sin_sentido/Fig_19.1_sin_sentido_2_Sp1matA.pdf` |  |
| 2 | 19.2 | 197 | static | `images/Erycina_crista-galli_Diana_Molina_Ozuma.jpg` | `figuras_editor/19-Datos_sin_sentido/Fig_19.2_Erycina_crista-galli_Diana_Molina_Ozuma.jpg` | `` | *Erycina crista-galli*. Foto: Diana Molina Ozuma. Estudio demográfico: @mondragon2007life. |
| 3 | 19.3 | 282 | render_dual | `images/sin_sentido_6_Sp1matA_NT.png` | `figuras_editor/19-Datos_sin_sentido/Fig_19.3_sin_sentido_6_Sp1matA_NT.png` | `figuras_editor/19-Datos_sin_sentido/Fig_19.3_sin_sentido_6_Sp1matA_NT.pdf` |  |
| 4 | 19.4 | 355 | render_dual | `images/sin_sentido_8_Sp1matU_NS.png` | `figuras_editor/19-Datos_sin_sentido/Fig_19.4_sin_sentido_8_Sp1matU_NS.png` | `figuras_editor/19-Datos_sin_sentido/Fig_19.4_sin_sentido_8_Sp1matU_NS.pdf` |  |
| 5 | 19.5 | 417 | render_dual | `images/sin_sentido_9_SerapiaA.png` | `figuras_editor/19-Datos_sin_sentido/Fig_19.5_sin_sentido_9_SerapiaA.png` | `figuras_editor/19-Datos_sin_sentido/Fig_19.5_sin_sentido_9_SerapiaA.pdf` |  |
| 6 | 19.6 | 460 | dynamic | `chunk 'fig-sin_sentido_10'` | `figuras_editor/19-Datos_sin_sentido/Fig_19.6_fig-sin_sentido_10-1.png` | `figuras_editor/19-Datos_sin_sentido/Fig_19.6_fig-sin_sentido_10-1.pdf` |  |
| 7 | 19.7 | 536 | render_dual | `images/sin_sentido_11_Sp1matA_Fert2.png` | `figuras_editor/19-Datos_sin_sentido/Fig_19.7_sin_sentido_11_Sp1matA_Fert2.png` | `figuras_editor/19-Datos_sin_sentido/Fig_19.7_sin_sentido_11_Sp1matA_Fert2.pdf` |  |
| 8 | 19.8 | 513 | dynamic | `chunk 'fig-sin_sentido_11'` | `figuras_editor/19-Datos_sin_sentido/Fig_19.8_fig-sin_sentido_11-2.png` | `figuras_editor/19-Datos_sin_sentido/Fig_19.8_fig-sin_sentido_11-2.pdf` |  |
| 9 | 19.9 | 642 | render_dual | `images/sin_sentido_15_Dirichlet.png` | `figuras_editor/19-Datos_sin_sentido/Fig_19.9_sin_sentido_15_Dirichlet.png` | `figuras_editor/19-Datos_sin_sentido/Fig_19.9_sin_sentido_15_Dirichlet.pdf` |  |
| 10 | 19.10 | 681 | dynamic | `chunk 'fig-sin_sentido_17'` | `figuras_editor/19-Datos_sin_sentido/Fig_19.10_fig-sin_sentido_17-1.png` | `figuras_editor/19-Datos_sin_sentido/Fig_19.10_fig-sin_sentido_17-1.pdf` |  |
| 11 | 19.11 | 740 | dynamic | `chunk 'fig-sin_sentido_19'` | `figuras_editor/19-Datos_sin_sentido/Fig_19.11_fig-sin_sentido_19-1.png` | `figuras_editor/19-Datos_sin_sentido/Fig_19.11_fig-sin_sentido_19-1.pdf` |  |

### 21-Historia_breve

Archivo fuente: `117_Historia_breve.qmd` — 1 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 21.1 | 127 | static | `images/Vanhecke_figure.png` | `figuras_editor/21-Historia_breve/Fig_21.1_Vanhecke_figure.png` | `` | *Dactylorhiza praetermissa*; de la publicación. |

### 22-Carl_Olof_Tamm

Archivo fuente: `118-Carl_Olaf_Tamm.qmd` — 4 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | 22.1 | 104 | static | `images/Dactylorhiza_sambucina_James_D._Ackerman.jpg` | `figuras_editor/22-Carl_Olof_Tamm/Fig_22.1_Dactylorhiza_sambucina_James_D._Ackerman.jpg` | `` | *Dactylorhiza sambucina*. Foto: James D. Ackerman. Estudios poblacionales: @oien2002flowering — seguimiento a largo plaz |
| 2 | 22.2 | 147 | static | `images/Dactylorhiza_maculata_James_D._Ackerman.jpg` | `figuras_editor/22-Carl_Olof_Tamm/Fig_22.2_Dactylorhiza_maculata_James_D._Ackerman.jpg` | `` | *Dactylorhiza maculata con hormigas y spittle bugs*. Foto: James D. Ackerman. Estudios poblacionales: @oien2002flowering |
| 3 | 22.3 | 351 | render_dual | `images/OCTamm_11_Dactylorhiza.png` | `figuras_editor/22-Carl_Olof_Tamm/Fig_22.3_OCTamm_11_Dactylorhiza.png` | `figuras_editor/22-Carl_Olof_Tamm/Fig_22.3_OCTamm_11_Dactylorhiza.pdf` |  |
| 4 | 22.4 | 446 | dynamic | `chunk 'fig-OCTamm_17'` | `figuras_editor/22-Carl_Olof_Tamm/Fig_22.4_fig-OCTamm_17-1.png` | `figuras_editor/22-Carl_Olof_Tamm/Fig_22.4_fig-OCTamm_17-1.pdf` |  |

### ApA-Lista_especies

Archivo fuente: `Appendix_A_Species_List.qmd` — 2 figura(s)

| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |
|---|---------|------:|------|----------------|-----|-----|---------|
| 1 | A.1 | 166 | static | `images/Spiranthes_delitescens_Mitchel_Mcclaran.jpg` | `figuras_editor/ApA-Lista_especies/Fig_1_Spiranthes_delitescens_Mitchel_Mcclaran.jpg` | `` | *Spiranthes delitescens*. Foto: Mitchel McClaran. Estudio demográfico: @mcclaran1992population. |
| 2 | A.2 | 170 | static | `images/Trichocentrum_undulatum_8_Hong_Liu.jpg` | `figuras_editor/ApA-Lista_especies/Fig_2_Trichocentrum_undulatum_8_Hong_Liu.jpg` | `` | *Trichocentrum undulatum*. Foto: Hong Liu. Estudio demográfico: @borrero2023populations. |

## Figuras tipo widget (HTML) sin PNG

Los siguientes chunks producen un diagrama interactivo (`plot_life_cycle` o `grViz`) que NO se exporta automáticamente como PNG. Para incluirlos en la entrega física al editor: añadir `plc_save()`/`grviz_save()` o tomar captura desde la versión HTML del libro.

| Capítulo | Línea | Función | Chunk |
|----------|------:|---------|-------|
| 03-Ciclos_de_Vida | 20 | `grViz()` | `CV1-setup-diagrams` |
