# Revisión de la prueba de paginación preliminar
**Libro:** *Introducción a la Dinámica Poblacional de Orquídeas* (Botanical Essays from Lankester Botanical Garden, Vol. 2)
**Autor:** Raymond L. Tremblay · **Fecha:** 15 de julio de 2026
**Archivo revisado:** Botanical Essays TREMBLAY WKG.pdf (22 páginas)

Este documento reúne (A) la dedicatoria definitiva y su bibliografía y (B) la lista de correcciones de la prueba, para devolver al equipo editorial.

Prioridad: 🔴 bloqueante · 🟠 consistencia · 🟡 tipografía/diseño

---

## A. Dedicatoria — texto definitivo (reemplaza el marcador en rojo de la p. iii)

El marcador de posición «Dedicatoria de este libro a las personas e instituciones que me han sido más queridas» debe sustituirse por la dedicatoria a **Michael J. Hutchings** (University of Sussex, Reino Unido). A continuación se transcribe el texto definitivo para su composición. En el libro digital las citas se generan automáticamente desde `book.bib`; aquí se muestran resueltas en formato autor-año para lectura del equipo editorial.

### Texto de la dedicatoria

> *Este libro está dedicado a*
>
> **Michael J. Hutchings**
>
> *University of Sussex, Reino Unido*
>
> Pocos investigadores han transformado tanto el estudio demográfico de las orquídeas como Michael J. Hutchings. Su seguimiento poblacional de *Ophrys sphegodes* en Castle Hill, iniciado en 1975 y continuado durante más de tres décadas, estableció un estándar para los estudios demográficos a largo plazo en plantas raras. Su trilogía sobre la biología poblacional de esta especie —desde el estudio demográfico inicial (Hutchings 1987a) y los patrones temporales del comportamiento de las plantas (Hutchings 1987b) hasta el análisis de tres décadas de demografía (Hutchings 2010)— mostró que las orquídeas terrestres exhiben fenómenos como la latencia vegetativa prolongada que invalidan los supuestos clásicos de los modelos matriciales, y obligó a la comunidad a desarrollar métodos cuantitativos más sofisticados.
>
> Su trabajo con Sue Waite (Waite & Hutchings 1991), aplicando modelos matriciales al manejo de poblaciones, fue uno de los primeros ejemplos del uso de MPP en orquídeas para informar decisiones de conservación. Más recientemente, sus colaboraciones con la siguiente generación de ecólogos poblacionales —Richard Shefferson, Hans Jacquemyn, Tiiu Kull, Ryo Mizuta y otros (Shefferson et al. 2017, 2018, 2020)— continúan empujando los límites del campo hacia la predicción evolutiva bajo cambio climático. De estas colaboraciones surgió también la extensa serie *Biological Flora of the British Isles*, que documenta en detalle el ciclo de vida y la demografía de numerosas orquídeas europeas (Jacquemyn et al. 2009, 2011, 2014, 2023; Meekers et al. 2012), así como una línea de investigación que aprovecha colecciones históricas de herbario para revelar la vulnerabilidad de la polinización frente al cambio climático (Robbirt et al. 2011, 2014; Hutchings et al. 2018).
>
> Pero más allá de sus contribuciones científicas, lo que distingue a Michael es su disponibilidad genuina para colaborar con cualquier ecólogo poblacional que se le acerque con una buena pregunta. Generaciones de estudiantes y colegas hemos contado con su lectura crítica, su rigor estadístico y su generosidad intelectual. Uno de nosotros (RLT) tuvo el privilegio de ser coautor con él de una revisión metodológica sobre conservación de orquídeas (Tremblay & Hutchings 2003) que sigue siendo punto de partida para muchos.
>
> Este libro es, en buena parte, una continuación del camino que Michael abrió.

El texto anterior y su bibliografía ya están integrados en la fuente del libro (`index.qmd`, sección «Dedicatoria»); las referencias citadas están en `book.bib`.

**Corrección bibliográfica aplicada.** Las tres partes de la trilogía de Hutchings sobre *Ophrys sphegodes* deben quedar diferenciadas. En `book.bib` las claves `hutchings1987population` y `hutchings1987temporal` apuntaban ambas a la **Parte II** (pp. 729–742), de modo que la Parte I faltaba y las dos citas de la dedicatoria se duplicaban. Se corrigió `hutchings1987population` para que apunte a la **Parte I**:

- **Parte I** (`hutchings1987population`): *…Ophrys sphegodes* Mill. I. A demographic study from 1975 to 1984. *Journal of Ecology* 75(3): 711–727 (1987).
- **Parte II** (`hutchings1987temporal`): *…Ophrys sphegodes* Mill. II. Temporal patterns in behaviour. *Journal of Ecology* 75(3): 729–742 (1987).
- **Parte III** (`hutchings2010population`): *…Ophrys sphegodes* Mill. III. Demography over three decades. *Journal of Ecology* 98(4): 867–878 (2010).

### Referencias completas citadas en la dedicatoria

Lista verificada (16 referencias), en orden alfabético, para su composición junto con la dedicatoria:

1. Hutchings, M. J. (1987a). The population biology of the early spider orchid, *Ophrys sphegodes* Mill. I. A demographic study from 1975 to 1984. *Journal of Ecology*, 75(3), 711–727.
2. Hutchings, M. J. (1987b). The population biology of the early spider orchid, *Ophrys sphegodes* Mill. II. Temporal patterns in behaviour. *Journal of Ecology*, 75(3), 729–742.
3. Hutchings, M. J. (2010). The population biology of the early spider orchid *Ophrys sphegodes* Mill. III. Demography over three decades. *Journal of Ecology*, 98(4), 867–878.
4. Hutchings, M. J., Robbirt, K. M., Roberts, D. L., & Davy, A. J. (2018). Vulnerability of a specialised pollination mechanism to climate change revealed by a 356-year analysis. *Botanical Journal of the Linnean Society*, 186(4), 498–509. https://doi.org/10.1093/botlinnean/box086
5. Jacquemyn, H., Brys, R., Honnay, O., & Hutchings, M. J. (2009). Biological Flora of the British Isles: *Orchis mascula* (L.) L. *Journal of Ecology*, 97(2), 360–377. https://doi.org/10.1111/j.1365-2745.2008.01473.x
6. Jacquemyn, H., Brys, R., & Hutchings, M. J. (2011). Biological Flora of the British Isles: *Orchis anthropophora* (L.) All. (*Aceras anthropophorum* (L.) W. T. Aiton). *Journal of Ecology*, 99(6), 1551–1565. https://doi.org/10.1111/j.1365-2745.2011.01897.x
7. Jacquemyn, H., Brys, R., & Hutchings, M. J. (2014). Biological Flora of the British Isles: *Epipactis palustris*. *Journal of Ecology*, 102(5), 1341–1355. https://doi.org/10.1111/1365-2745.12287
8. Jacquemyn, H., Pankhurst, T., Jones, P. S., Brys, R., & Hutchings, M. J. (2023). Biological Flora of Britain and Ireland No. 304: *Liparis loeselii*. *Journal of Ecology*, 111(4), 943–966. https://doi.org/10.1111/1365-2745.14086
9. Meekers, T., Hutchings, M. J., Honnay, O., & Jacquemyn, H. (2012). Biological Flora of the British Isles: *Gymnadenia conopsea* s.l. *Journal of Ecology*, 100(5), 1269–1288. https://doi.org/10.1111/j.1365-2745.2012.02006.x
10. Robbirt, K. M., Davy, A. J., Hutchings, M. J., & Roberts, D. L. (2011). Validation of biological collections as a source of phenological data for use in climate change studies: a case study with the orchid *Ophrys sphegodes*. *Journal of Ecology*, 99(1), 235–241. https://doi.org/10.1111/j.1365-2745.2010.01727.x
11. Robbirt, K. M., Roberts, D. L., Hutchings, M. J., & Davy, A. J. (2014). Potential disruption of pollination in a sexually deceptive orchid by climatic change. *Current Biology*, 24(23), 2845–2849. https://doi.org/10.1016/j.cub.2014.10.033
12. Shefferson, R. P., Mizuta, R., & Hutchings, M. J. (2017). Predicting evolution in response to climate change: the example of sprouting probability in three dormancy-prone orchid species. *Royal Society Open Science*, 4(1), 160647.
13. Shefferson, R. P., Kull, T., Hutchings, M. J., Selosse, M.-A., Jacquemyn, H., et al. (2018). Drivers of vegetative dormancy across herbaceous perennial plant species. *Ecology Letters*, 21(5), 724–733. https://doi.org/10.1111/ele.12940
14. Shefferson, R. P., Jacquemyn, H., Kull, T., & Hutchings, M. J. (2020). The demography of terrestrial orchids: life history, population dynamics and conservation. *Botanical Journal of the Linnean Society*, 192(2), 315–332.
15. Tremblay, R. L., & Hutchings, M. J. (2003). Population dynamics in orchid conservation: a review of analytical methods based on the rare species *Lepanthes eltoroensis*. En *Orchid Conservation* (pp. 183–204). Natural History Publications (Borneo), Kota Kinabalu.
16. Waite, S., & Hutchings, M. J. (1991). The effects of different management regimes on the population dynamics of *Ophrys sphegodes*: analysis and description using matrix models. En T. C. E. Wells & J. H. Willems (Eds.), *Population ecology of terrestrial orchids* (pp. 161–175). SPB Academic Publishing, La Haya.

> Nota: en el texto se usan «1987a» (Parte I) y «1987b» (Parte II) para distinguir los dos artículos de Hutchings de 1987.

- [ ] 🔴 Sustituir el texto de dedicatoria provisional (rojo) por la versión definitiva transcrita arriba, con su lista de referencias.

---

## B. Correcciones de la prueba

### B.1 Prioridad crítica — marcadores de posición y errores (🔴)

**Página de créditos / imprenta (p. iii)**
- [ ] 🔴 «EDITOIAL COMMITTEE» → **EDITORIAL COMMITTEE**.
- [ ] 🔴 «Reserach Center» aparece **dos veces** → **Research Center**.
- [ ] 🔴 ISSN `0000-0000` e ISBN `0-00000-00-0` siguen siendo valores de relleno; insertar los definitivos.
- [ ] 🟠 Nombre del autor inconsistente: aquí «Raymond Tremblay»; en la portada «Raymond L. Tremblay». Unificar.

**Marcadores de posición en el texto**
- [ ] 🔴 «**TÍTULO DEL PÁRRAFO?**» (en rojo) aparece en el índice (§2.10) y en el cuerpo (p. 17). La sección 2.10 no tiene título.
- [ ] 🔴 Firma de la conclusión (índice §20.1, en rojo): «Por: Raymond L Tremblay, Demetria Mondragón y Aucencia Emeterio-Lara» — es una nota editorial, no el texto final.
- [ ] 🔴 En el índice, los números de página son «**00**» de la p. 11 en adelante (solo el Cap. 1 está paginado).

**Contenido faltante**
- [ ] 🔴 §1.7 «Lista de paquetes usados en el libro» (p. 10): aparece el bloque de código pero **falta la lista/tabla de paquetes que debe generar**. La lista es contenido necesario del capítulo y hay que añadirla (la tabla de paquetes, no solo el código). **La lista lista para pegar está en el Anexo al final de este documento.**

**Glifo λ (lambda) que desaparece**
- [ ] 🔴 El símbolo λ se pierde en el texto corrido y aparece como «( )» vacío. Ejemplos: p. 11 «la tasa de crecimiento poblacional ( )»; p. 14 «( )»; índice 13.5.1 y 17.1.5 «Matriz de proyección poblacional ( )» y «Valor Propio Dominante ( )». Es un problema de fuente/codificación (en otras entradas del índice sí aparece: 9.2, 9.11, 8.13). Comunicarlo explícitamente al tipógrafo.

**Erratas en títulos**
- [ ] 🔴 Lista «Estructura del libro», ítem 5 (p. 4): «Relación entre las **matriz** de transiciones, fecundidad y **clonaj3**» → «las **matrices**… clonaj**e**».
- [ ] 🟠 «**História**» (grafía portuguesa) en índice §1.3 y cuerpo §9; en otras partes se usa correctamente «Historia». Unificar a **Historia**.
- [ ] 🟠 Título de la tabla: «El uso potencial de **la diferentes acercamiento**» → «de **los diferentes acercamientos**».

### B.2 Numeración (parece un fallo de contador/referencias cruzadas) (🟠)

> **Decisión sobre la profundidad de niveles (2026-07-15).** Para la versión **impresa** (PDF y Word) se limitó la numeración y la tabla de contenidos a **dos niveles** (capítulo + sección: `3.1`, `3.2`, `3.4`…). Los encabezados de tercer nivel (p. ej. «Especies epífitas/terrestres») siguen en el cuerpo pero **sin numerar** y fuera del índice. El formato **HTML/web conserva tres niveles**. El cambio ya está aplicado en la fuente Quarto (`toc-depth: 2`, `section-numbering: 1.1` / `number-depth: 2`).
>
> **Solicitud al tipógrafo:** aplicar en la maquetación impresa el mismo límite de **dos niveles** (numeración y tabla de contenidos). Esto elimina de raíz la inconsistencia de profundidad y los números de cuatro niveles del índice actual (p. ej. `3.4.1`, `8.10.4`, `13.3.1`).

- [ ] 🟠 La tabla de usos de PPM está numerada de **tres formas distintas**: «2.1.1» (p. 16), «3.1.1 Continuación» (p. 17) e índice «2.9.1». Es la misma tabla.
- [ ] 🟠 El contador de sección salta al Capítulo 3 dentro del Capítulo 2: en la p. 21 dice «**3**.10.7» cuando debería ser 2.10.7.
- [ ] 🟠 «2.1.1» se usa dos veces — para la tabla y para el recuadro de librerías de R (p. 12).
- [ ] 🟠 Números sueltos fundidos en los títulos del índice: «…No Lineales**209**», «…Perturbación **213**», «…poblacional ( ) **211**», «…estado **212**».
- [ ] 🟠 La lista narrativa «Estructura del libro» (Cap. 1) va del 1 al 17, **omite el 18** y salta al 19.

### B.3 Consistencia (🟠)

- [ ] 🟠 **Nombres de colaboradores.** «Ernesto **Mujíca** Benitez» (portada) vs «Ernesto **Mujica**» (firma Cap. 2, p. 11); «**Benitez**» probablemente «Benítez»; «Raymond L. Tremblay» vs «Raymond L Tremblay» (falta el punto).
- [ ] 🟠 **Mezcla de idiomas.** La página de imprenta y los titulillos están en inglés («Published», «All rights reserved», titulillo verso «TREMBLAY **and** COLLABORATORS») mientras el libro está en español. Si la portadilla de serie es deliberadamente bilingüe, está bien; pero el titulillo «and Collaborators» sobre texto en español parece un descuido → considerar «y colaboradores».
- [ ] 🟠 Uso variable de mayúscula en «bayesiano/Bayesiano» (título §8 vs cuerpo). Unificar criterio.

### B.4 Tipografía y producción (🟡)

- [ ] 🟡 **La partición de palabras parece usar el diccionario de idioma equivocado.** El texto justificado corta palabras de forma extraña y, en algún caso, parte nombres/código — p. ej. «de-COM(P)ADRE». Confirmar que el diccionario de partición **español** está activo y aplicar tratamiento sin separación a nombres de paquetes/bases de datos (COMPADRE, raretrans, ggplot2).
- [ ] 🟡 **Figura 2.2** (diagrama de flujo azul): el estilo de recuadros e íconos tipo clip-art choca con la tipografía clásica del libro. Recomiendo redibujarla en una paleta sobria y coherente. La Figura 2.1 (foto de *Tolumnia*) está bien.

### B.5 Estructura y sugerencias de maquetación (🟡)

- [ ] 🟡 Considerar un **Índice de figuras / Índice de tablas** en las páginas preliminares.
- [ ] 🟡 Las etiquetas de parte («I Historia», «II Apéndices») chocan visualmente con los números romanos del preliminar y con la «I» que cierra el índice. Un estilo diferenciado (p. ej. «PARTE I») ayudaría a distinguirlas.
- [ ] 🟡 La ubicación de la portadilla (bloque de texto flotante arriba a la derecha, p. i) es inusual — confirmar que es intencional.
- [ ] 🟡 Verificar que el enlace del libro digital esté activo: `raymondltremblay.github.io/Diagnostico_Poblacional/`.

---

## Valoración general
Es una primera prueba sólida: la maquetación del cuerpo, los titulillos y la integración de figuras funcionan. Los pendientes son casi todos de **finalización** (dedicatoria definitiva, marcadores de posición, páginas «00»), un **fallo de numeración automática** que mete «3.x» dentro del Capítulo 2, y el **glifo λ ausente**. Esos son los primeros que conviene devolver al tipógrafo.

---

## Anexo — Lista de paquetes para la §1.7

Lista obtenida escaneando todos los archivos `.qmd`, `.R` y `.Rprofile` del proyecto (llamadas a `library()`, `require()` y `paquete::función()`), tal como lo hace el código de la §1.7. Son **57 paquetes** de terceros (instalables desde CRAN o GitHub), en orden alfabético:

binom, bookdown, broom, car, colorspace, cowplot, devtools, DiagrammeR, DiagrammeRsvg, distributional, dplyr, e1071, flextable, ftExtra, ggdist, ggplot2, ggpubr, ggtext, grateful, gt, htmltools, htmlwidgets, interpretCI, janitor, jsonlite, knitr, latex2exp, leaflet, magick, MCMCpack, officer, pacman, pdftools, plyr, popbio, popdemo, purrr, quarto, Rage, raretrans, Rcompadre, readr, readxl, remotes, renv, reshape2, rsvg, scales, skimr, stringr, styler, tibble, tidyr, tidyverse, webshot2, WRS2, yaml.

**Notas para composición:**

- Se excluyeron los paquetes que vienen incluidos con R y no requieren instalación (`base`, `methods`, `stats`, `utils`, `tools`, `grDevices`, `codetools`).
- Se depuraron tres falsos positivos del escaneo automático: `interceptCI` (era un residuo de una copia de trabajo; el paquete real es `interpretCI`), `pre.r` (es un selector CSS `.pre.r::before`, no un paquete) y `pkg` (aparece en un comentario de documentación, no es un paquete).
- Las **versiones** de cada paquete no se incluyen aquí porque dependen de la instalación concreta; en el libro digital se rellenan automáticamente al renderizar (`utils::packageVersion()`). Si la versión impresa necesita los números de versión, conviene tomarlos de un render de R actualizado.
- Los paquetes principales de análisis (`popbio`, `popdemo`, `raretrans`, `Rage`, `Rcompadre`, `ggplot2`, `dplyr`, `tidyr`) ya se describen en la §1.5; esta lista de la §1.7 es el inventario completo (análisis + soporte + construcción del libro).
