# Manifiesto de figuras — Dinámica Poblacional de Orquídeas

Inventario completo de figuras embebidas en el libro, organizadas por capítulo y orden de aparición. Generado para el productor/editor del libro.

## Resumen

- **Total figuras markdown**: 50
- **Capítulos con figuras**: 16
- **Archivos únicos en `images/`**: 49

Las figuras generadas por código R (gráficos ggplot, diagramas de ciclo de vida producidos por `plot_life_cycle()`, etc.) no se inventarían aquí — éstas se regeneran en cada render desde el código.

## Estructura de carpetas sugerida para producción

Para el armado del libro físico/digital, sugerimos reorganizar las imágenes en subcarpetas por capítulo. El estado actual del repositorio tiene todo en `images/` plano, lo que dificulta para el productor saber qué imagen va en qué capítulo. La estructura propuesta:

```
figuras/
├── 01-introduccion/
│   ├── Tolumnia_variegata_Tremblay.jpeg
│   └── Demografia_de_una_poblacion.jpg
├── 02-ciclos-de-vida/
│   ├── Orchis_purpurea_1_Hans_Jacquemyn.jpg
│   └── Orchis_purpurea_2_Hans_Jacquemyn.jpg
├── 03-recopilacion-datos/
│   ├── Trichocentrum_undulatum_1_Hong_Liu.jpg
│   ├── Trichocentrum_undulatum_9_Hong_Liu.jpeg
│   └── ... (21 archivos)
└── ...
```

El renombrado de las rutas en los `.qmd` no se ha hecho — sólo presentamos el inventario. Si quieres que reorganice físicamente las imágenes en subcarpetas y actualice todas las rutas, dilo.

## Inventario por capítulo

### 1. Introducción

Archivo fuente: `102-Intro.qmd` — 2 figura(s)

| # | Línea | Sección | Imagen | Caption / autor |
|---|------:|---------|--------|----------------|
| 1 | 335 | Procesos y patrones evolutivos del ciclo de vida q | `Tolumnia_variegata_Tremblay.jpeg` | *Tolumnia variegata*. Foto: Tremblay |
| 2 | 355 | Visualización de la dinámica poblacional | `Demografia_de_una_poblacion.jpg` | Factores que influyen en la dinámica de una población |

### 10. Elasticidad

Archivo fuente: `111-Elasticidad.qmd` — 4 figura(s)

| # | Línea | Sección | Imagen | Caption / autor |
|---|------:|---------|--------|----------------|
| 1 | 232 | Comparación entre especies | `Lepanthes_eltoroensis_Tremblay.jpeg` | *Lepanthes eltoroensis*. Foto: Tremblay |
| 2 | 268 | Comparación entre especies | `Lepanthes_caritensis_Edwin_Guevara.jpg` | *Lepanthes caritensis*. Foto: Edwin Guevara |
| 3 | 272 | Comparación entre especies | `Lepanthes_caritensis_Phorophyte.jpg` | *Lepanthes caritensis*. Foto: Edwin Guevara |
| 4 | 355 | Elasticidad y LTRE: prospectivo versus retrospecti | `Laelia_speciosa_Eduardo_A._Perez_Garcia.jpeg` | *Laelia speciosa*. Foto: Eduardo A. Pérez García |

### 11. Dinámica transitoria

Archivo fuente: `112-Dinamica_de_Transiciones.qmd` — 1 figura(s)

| # | Línea | Sección | Imagen | Caption / autor |
|---|------:|---------|--------|----------------|
| 1 | 130 | Análisis de la dinámica a largo plazo | `Lepanthes_rupestris_Tremblay.jpeg` | *Lepanthes rupestris*. Foto: Tremblay |

### 13. LTRE

Archivo fuente: `114-LTRE.qmd` — 1 figura(s)

| # | Línea | Sección | Imagen | Caption / autor |
|---|------:|---------|--------|----------------|
| 1 | 163 | Matrices de proyecciones y ciclo de vida por espec | `Imagen1.jpg` |  |

### 14. Métodos de simulaciones

Archivo fuente: `115-Metodos_de_simulaciones.qmd` — 3 figura(s)

| # | Línea | Sección | Imagen | Caption / autor |
|---|------:|---------|--------|----------------|
| 1 | 138 | Entrada de datos | `Serapias_cordigera_5_Giuseppe_Pellegrino.jpeg` | *Serapias cordigera*. Foto: Guiseppe Pelligrino |
| 2 | 247 | Cual es la distribución de la cantidad de individu | `Serapias_cordigera_7_Giuseppe_Pellegrino.jpg` | *Serapias cordigera*. Foto: Guiseppe Pelligrino |
| 3 | 454 | Estocasticidad temporal | `Serapias_cordigera_3_Giuseppe_Pellegrino.jpeg` | *Serapias cordigera*. Foto: Guiseppe Pelligrino |

### 15. Historia breve

Archivo fuente: `117_Historia_breve.qmd` — 1 figura(s)

| # | Línea | Sección | Imagen | Caption / autor |
|---|------:|---------|--------|----------------|
| 1 | 94 | Publicaciones sin MPP | `Vanhecke_figure.png` | *Dactylorhiza praetermissa*; de la publicación |

### 16. Carl Olaf Tamm

Archivo fuente: `118-Carl_Olaf_Tamm.qmd` — 2 figura(s)

| # | Línea | Sección | Imagen | Caption / autor |
|---|------:|---------|--------|----------------|
| 1 | 119 | El padre de la ecología de poblaciones en orquídea | `Dactylorhiza_sambucina_James_D._Ackerman.jpg` | *Dactylorhiza sambucina*. Foto: James D. Ackerman |
| 2 | 158 | El padre de la ecología de poblaciones en orquídea | `Dactylorhiza_maculata_James_D._Ackerman.jpg` | *Dactylorhiza maculata con hormigas y spittle bugs*. Foto: James D. Ackerman |

### 19. Protocolo

Archivo fuente: `121-Traduccion_protocolo_informacion.qmd` — 4 figura(s)

| # | Línea | Sección | Imagen | Caption / autor |
|---|------:|---------|--------|----------------|
| 1 | 66 | "A standard protocol to report discrete stage-stru | `Survey_paper.png` | FIGURA 1: Resultados de la encuesta a expertos en ecología de poblaciones que participaron (n = 60). Los participantes c |
| 2 | 76 | "A standard protocol to report discrete stage-stru | `Database_paper.png` | FIGURA2: Tanto los artículos sobre MPP de plantas como de animales muestran patrones similares en cuanto a qué component |
| 3 | 80 | "A standard protocol to report discrete stage-stru | `COMPADRE_MADRE.png` | FIGURA 3: En los artículos sobre MPP de plantas y animales, la mayoría de las publicaciones no contienen suficiente info |
| 4 | 342 | hidden code to produce figures | `Matrices_A_U_F_C.jpg` | FIGURA 4: La descomposición de un MPP en sus submatrices permite aislar tasas vitales que de otro modo estarían enmascar |

### 2. Ciclos de Vida

Archivo fuente: `103-Ciclos_de_Vida.qmd` — 2 figura(s)

| # | Línea | Sección | Imagen | Caption / autor |
|---|------:|---------|--------|----------------|
| 1 | 309 | *Cypripedium parviflorum*, *Epipactis atrorubens*  | `Orchis_purpurea_1_Hans_Jacquemyn.jpg` | *Orchis purpurea*. Foto: Hans Jacquemyn |
| 2 | 341 | *Cypripedium parviflorum*, *Epipactis atrorubens*  | `Orchis_purpurea_2_Hans_Jacquemyn.jpg` | *Orchis purpurea*. Foto: Hans Jacquemyn |

### 20. Datos sin sentido

Archivo fuente: `122-Impacto_de_Datos_sin_Sentido.qmd` — 1 figura(s)

| # | Línea | Sección | Imagen | Caption / autor |
|---|------:|---------|--------|----------------|
| 1 | 211 | Un cambio pequeño en la mortalidad. | `Erycina_crista-galli_Diana_Molina_Ozuma.jpg` | *Erycina crista-galli*. Foto: Diana Molina Ozuma |

### 3. Recopilación de datos en el campo

Archivo fuente: `104-Recopilacion_datos_en_el_campo.qmd` — 21 figura(s)

| # | Línea | Sección | Imagen | Caption / autor |
|---|------:|---------|--------|----------------|
| 1 | 102 | Apariencia e identificación visual preliminar | `Trichocentrum_undulatum_9_Hong_Liu.jpeg` | *Trichocentrum undulatum*. Foto: Hong Liu |
| 2 | 106 | Apariencia e identificación visual preliminar | `Trichocentrum_undulatum_1_Hong_Liu.jpg` | *Trichocentrum undulatum*. Foto: Hong Liu |
| 3 | 128 | Etapas o estados de desarrollo en orquídeas {#sec- | `lepanthes_rupestris.jpeg` | *Lepanthes rupestris* con inflorescencias seca y activa. Foto: Tremblay |
| 4 | 149 | Ontogenia y estrategias de crecimiento | `Pk_modulo.jpeg` | *Prosthechea karwinskii*. Foto: Mariana Hernández-Apolinar |
| 5 | 168 | Ontogenia y estrategias de crecimiento | `Ci_modulo.png` | *Cypripedium irapeanum*. Foto: Claudia C. Gutiérrez-Paredes |
| 6 | 178 | Ontogenia y estrategias de crecimiento | `V_planifolia_monopo.png` | *Vanilla planifolia*. Foto: Mark Blackman |
| 7 | 184 | Ontogenia y estrategias de crecimiento | `Ls_simpodio.jpg` | *Laelia speciosa*. Foto: Leonel López-Toledo |
| 8 | 214 | Métodos y técnicas de muestreo | `Aucencia_ascenso.jpg` | Muestreo de orquídeas epífitas con ascenso de una sola cuerda: a) *Laelia autumnalis*. Foto: Aucencia Emeterio-Lara |
| 9 | 218 | Métodos y técnicas de muestreo | `Ascenso_Pk.jpg` | Muestreo de orquídeas epífitas con ascenso de una sola cuerda: *Prosthechea karwinskii*. Foto: Alonso Argüero |
| 10 | 231 | Zona de distribución de orquídeas en árboles | `Cattling_y_Johannson.png` | Zonificación de árboles hospedero, basada en los modelos Catling (1986) y Johansson (1974). Dibujo por A. Emeterio Lara |
| 11 | 292 | Epifitas_zonas | `Ls_xyz.png` | Distribución tri-dimensional de las orquídeas en los árboles |
| 12 | 298 | Epifitas_zonas | `tree_dist.png` | Distribución espacial de los forófitos y el tamaño de cubierta foliar en el área de muestreo |
| 13 | 307 | Orquídeas terrestres | `Triangulation_Method.jpg` | Método de triangulación para muestreo terrestre: los P_x representan la posición de cada planta. Dos distancias son medi |
| 14 | 339 | Identificación y etiquetado de individuos | `C_irap_plantula.jpeg` | Plántula de *Cypripedium irapeanum*. Foto: Claudia Gutiérrez-Paredes |
| 15 | 345 | Identificación y etiquetado de individuos | `Lepanthes_woodburyana.jpg` | *Lepanthes woodburyana*. Foto: Edwin Guevara |
| 16 | 379 | Material recomendado para marcar o etiquetar un in | `Cypripedium_acaule.jpg` | Uso de etiquetas de aluminio en marcaje de *Cypripedium acaule*. Foto: Tremblay |
| 17 | 383 | Material recomendado para marcar o etiquetar un in | `Laelia_cincho.png` | Uso de etiquetas de aluminio en marcaje con cinchos de plástico en *Laelia autumnalis*. Foto por Aucencia Emeterio-Lara |
| 18 | 417 | Colocación de la etiqueta | `alambrelaelia.jpg` | Marcaje de *Laelia speciosa* abrazando el tronco con alambre plastificado y etiquetas de *dymo*. Foto: Mariana Hernández |
| 19 | 423 | Colocación de la etiqueta | `Lep_eltoroensis.png` | Los individuos de *Lepanthes eltoroensis* fueron identificados con una etiqueta de plástico clavada al tronco del árbol; |
| 20 | 429 | Colocación de la etiqueta | `Cirap_marcaje.png` | Marcaje de *Cypripedium irapeanum* con cinta de *dymo*. Foto: Hernández-Apolinar |
| 21 | 433 | Colocación de la etiqueta | `Cyp_acaule_flag.jpg` | Marcaje de *Cypripedium acaule* con banderitas. Foto: Tremblay |

### 5. Fecundidad

Archivo fuente: `106-calcular_fecundidad.qmd` — 2 figura(s)

| # | Línea | Sección | Imagen | Caption / autor |
|---|------:|---------|--------|----------------|
| 1 | 103 | Reclutamiento | `Diagrama_fecundidad.png` |  |
| 2 | 124 | Tiempo de inversión para alcanzar la fase reproduc | `Cant_Hojas_Prob_Fr_Brassavola.jpg` |  |

### 6. matU, matF y matC

Archivo fuente: `107-matU_matF_matC.qmd` — 1 figura(s)

| # | Línea | Sección | Imagen | Caption / autor |
|---|------:|---------|--------|----------------|
| 1 | 53 | Tres tipos de matrices | `Matrices_A_U_F_C.jpg` | Relación entre matrices; Diseño: Samuel Gascoigne |

### 7. Acercamiento bayesiano

Archivo fuente: `108-Bayesian_PPM.qmd` — 2 figura(s)

| # | Línea | Sección | Imagen | Caption / autor |
|---|------:|---------|--------|----------------|
| 1 | 240 | Obtención de la matriz de proyección | `Lepanthes_eltoroensis_Edwin_Guevara.jpg` | *Lepanthes eltoroensis*. Foto: Edwin Guevara |
| 2 | 242 | Obtención de la matriz de proyección | `Lepanthes_eltoroensis_Phorophyte_Edwin_Guevara.jpg` | *Lepanthes eltoroensis*. Foto: Edwin Guevara |

### 9. Propiedades

Archivo fuente: `110-Propriedades.qmd` — 1 figura(s)

| # | Línea | Sección | Imagen | Caption / autor |
|---|------:|---------|--------|----------------|
| 1 | 390 | Valor reproductivo | `Spathoglottis_plicata_Tremblay.jpeg` | *Spathoglottis plicata*. Foto: Tremblay |

### A. Lista de especies

Archivo fuente: `Appendix_A_Species_List.qmd` — 2 figura(s)

| # | Línea | Sección | Imagen | Caption / autor |
|---|------:|---------|--------|----------------|
| 1 | 153 | Lista completa de MPP en orquídeas {.unnumbered} | `Trichocentrum_undulatum_8_Hong_Liu.jpg` | *Trichocentrum undulatum*. Foto: Hong Liu |
| 2 | 177 | Especies de orquídeas estudiadas sin MPP {.unnumbe | `Spiranthes_delitescens_Mitchel_Mcclaran.jpg` | *Spiranthes delitescens*. Foto: Mitchel McClaran |

## Nota sobre alt-text

El alt-text (texto alternativo para accesibilidad y SEO) actualmente coincide con el caption en la mayoría de las figuras —es decir, el alt-text es el nombre de la especie y autor. Para mejorar accesibilidad para lectores con dispositivos asistivos, se recomienda añadir descripciones del contenido visual usando `fig-alt`. Ej.:

```markdown
![*Lepanthes caritensis*. Foto: Edwin Guevara](images/Lepanthes_caritensis.jpg){
  fig-alt="Orquídea miniatura con flores rojas creciendo sobre la corteza de un tronco musgoso"
}
```

Las captions actuales sirven como etiqueta visual pero no describen lo que se ve en la imagen, lo cual es lo que necesita un lector que use un lector de pantalla.

## Archivos faltantes o problemáticos

Los siguientes archivos son referenciados desde código R (`render_dual()`, `ggsave()`) y se generan dinámicamente al renderizar el libro. **No es necesario añadirlos manualmente al folder** porque el código los crea:

- `CV10.png`, `CV7Prasophyllum_correctum.png`, `CV8_Ophrys.png`, `CV9_Os.png`, `CV_2.png`, `CV_3.png`, `CV_5.png`, `CV_6Telipogon_helleri.png` (Cap. 2 — diagramas de ciclo de vida)
- `Lenght_survey.png`, `Terr_Epi_lambda.png` (Cap. 18 — comentados con `#ggsave()`, no se generan)
