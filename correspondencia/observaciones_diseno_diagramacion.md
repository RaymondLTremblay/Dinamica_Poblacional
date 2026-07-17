# Observaciones sobre diseño y diagramación — Prueba preliminar
**Libro:** *Introducción a la Dinámica Poblacional de Orquídeas* (Botanical Essays from Lankester Botanical Garden, Vol. 2)
**Autor:** Raymond L. Tremblay · **Fecha:** 16 de julio de 2026
**Archivo revisado:** Botanical Essays TREMBLAY WKG.pdf (22 páginas)

Estas notas se centran exclusivamente en **diseño y diagramación** (tipografía, tamaños, tablas y leyendas, acomodo de imágenes, numeración y presentación), según lo solicitado. No incluyen observaciones de contenido.

**Impresión general:** la estructura de la diagramación es sólida —una sola columna, márgenes generosos, titulillos en versalitas, jerarquía clara de encabezados—. Sin embargo, **la elección tipográfica es el punto más débil de la prueba**: la fuente del **cuerpo** no transmite el aire profesional que merece el libro, y la fuente de las **tablas** resulta difícil de leer. Por eso, además de las observaciones generales, incluimos abajo una **especificación tipográfica concreta** (familias, tamaños e interlínea) para acordar con el equipo de diseño.

---

## 1. Especificación tipográfica recomendada (lo más importante)

Recomendamos **fijar explícitamente** la tipografía de cada elemento en lugar de dejarla al azar de la diagramación. Un dato técnico refuerza esto: en la prueba, el símbolo **λ** desaparece y queda como «( )» vacío (p. 11, p. 14) porque la fuente actual **no incluye los glifos griegos**. Cualquier fuente que se elija debe cubrir español (tildes, ñ, ¿¡) **y** griego/matemático (λ, ρ, α, μ, Σ…).

Proponemos dos sistemas coherentes. **Sistema A** (tipografías comerciales, estándar en edición académica) o **Sistema B** (libres, con la ventaja de unificar el libro impreso con el libro digital, que ya las usa). Cualquiera de los dos es muy superior a lo actual.

| Elemento | Fuente — Sistema A (comercial) | Fuente — Sistema B (libre) | Tamaño / interlínea* | Peso / estilo |
|---|---|---|---|---|
| Título de portada y de capítulo | Minion Pro (o Adobe Garamond Pro) | Libertinus Serif | 18–22 pt | Versalitas, regular |
| Encabezado de sección `X.Y` | Minion Pro | Libertinus Serif | 12–13 pt (+ espacio superior) | Semibold / negrita |
| Subsección `X.Y.Z` | Minion Pro | Libertinus Serif | 11 pt | Cursiva |
| Cuerpo de texto | Minion Pro (o Sabon / Garamond) | Libertinus Serif | 10.5–11 pt / 14–15 pt | Regular (redonda) — NO negrita |
| Texto de tablas | **Source Sans 3 (elegida)** | **Source Sans 3 (elegida)** | 9–9.5 pt / 12 pt | Regular, cifras tabulares |
| Cifras numéricas en tablas | Source Sans 3 | Source Sans 3 | igual que la tabla | Cifras tabulares, alineadas a la derecha |
| Leyendas de figura/tabla | Source Sans 3 | Source Sans 3 | 8.5–9 pt | Cursiva para nombres científicos |
| Código (monoespaciada) | Source Code Pro | JetBrains Mono | 9–9.5 pt | Regular |

\* *Los tamaños son un punto de partida y dependen del tamaño de página final; conviene calibrarlos sobre una prueba real.*

> **Aclaración:** ninguna fuente de la tabla va en negrita por defecto. El **cuerpo de texto es regular (redonda)**; la negrita se reserva para los encabezados de sección. La **hoja de muestra adjunta** (`muestra_tipografica.docx`) presenta cada elemento en su tamaño y estilo reales, con la fuente y el tamaño rotulados al lado.

Notas clave:

- [ ] **Fuente del cuerpo.** Sustituir por una fuente de libro pensada para lectura extensa (Minion Pro es el estándar de la industria; Libertinus Serif es la equivalente libre y ya cubre griego/matemático, con lo que **resuelve el problema de la λ**). Esto es lo que más elevará la percepción de "profesional".
- [ ] **Fuente de las tablas — DECIDIDA: Source Sans 3.** Tras comparar varias opciones (`comparacion_fuentes_tabla.docx`), se eligió **Source Sans 3**, una sans humanista libre, muy legible y neutra (equivalente libre de Myriad/Frutiger). Especificación: **9–9.5 pt**, **cifras tabulares** (ancho fijo) para alinear los números, columnas numéricas a la derecha y **aire suficiente entre filas**. (Se descartaron Libertinus Sans —formas cerradas, menos legible— y cualquier fuente condensada.)
- [ ] **Coherencia serif + sans + monoespaciada.** Serif para el cuerpo, sans para tablas/leyendas/rótulos y monoespaciada para código es un sistema de tres voces limpio y profesional; conviene mantenerlo consistente en todo el libro.
- [ ] **Solicitud práctica:** antes de decidir, pedir al diseño una **hoja de muestra** con la fuente elegida aplicada a un caso real —una página de texto, la tabla grande de las pp. 16–17, un bloque de código y una leyenda de figura— para evaluarla sobre contenido verdadero.

## 2. Jerarquía y titulares

- [ ] La jerarquía de encabezados funciona (capítulo centrado en mayúsculas → sección `X.Y` en negrita → subsección `X.Y.Z` en cursiva). Sugerencia menor: aumentar el espacio **antes** de cada encabezado respecto al de después, para que "abra" su bloque.
- [ ] Si se conserva una tipografía display de mucho contraste para los titulares, **verificar que las astas finas no se rompan ni se empasten** al imprimir según prensa y papel; en cuerpos pequeños las Didone sufren. Un peso algo más robusto evita el problema.

## 3. Numeración y tabla de contenidos

- [ ] **Numeración — RESUELTO.** En el **índice (tabla de contenidos) se muestran solo dos niveles** (capítulo.sección; p. ej. 3.1, 3.4), para que quede limpio y consistente entre capítulos. En el **cuerpo del texto se conservan hasta tres niveles** de encabezado (p. ej. 3.4.1), útiles para las referencias internas, pero esos terceros niveles **no aparecen en el índice**. (Ya configurado en la fuente; el HTML mantiene tres niveles también en el índice.)
- [ ] Al completar la paginación, alinear la columna de folios del índice a la derecha de forma consistente.

## 4. Tablas y leyendas

- [ ] Cambiar la **retícula cerrada** (recuadro con líneas en todas las celdas) por una **retícula abierta** tipo *booktabs*: solo filete superior, filete bajo el encabezado y filete inferior, sin líneas verticales. Se lee más limpio y combina con el estilo clásico.
- [ ] Alinear **columnas numéricas a la derecha** con cifras tabulares y homogeneizar el relleno de las celdas.
- [ ] En tablas que continúan de página, **repetir la fila de encabezado** y rotular «(continuación)».
- [ ] Un **estilo único de leyenda de tabla** (peso, tamaño, posición encima de la tabla) en todo el libro.

## 5. Imágenes y figuras

- [ ] Las **fotografías** están **demasiado grandes**: no hace falta dedicar una página completa a una foto. Reducir su tamaño y **componer el texto alrededor** (text wrap) para aprovechar mejor la página y evitar páginas casi vacías. Un tamaño de media caja o menos suele bastar para una foto de especie.
- [ ] El **diagrama Fig. 2.2** está en estilo *clip-art* (cajas cian, íconos de archivo) que **choca con la tipografía** del libro y no reproduce bien en B/N. Rediseñarlo en una paleta sobria/escala de grises coherente con el diseño.
- [ ] Confirmar **≥300 dpi** en todas las imágenes al tamaño final.
- [ ] Fijar una convención de **acomodo** (figuras al pie o al inicio) y un **ancho estándar**, aplicados en todo el libro.
- [ ] Unificar el formato de **leyendas de figura** (rótulo «Figura X.Y», peso, cursiva para nombres científicos).

## 6. Bloques de código (scripts)

- [ ] **Tipografía del código — RESUELTO: JetBrains Mono** (la misma del libro digital, así impreso y digital coinciden). Requisitos a mantener: distinción clara entre `0`/`O`, `1`/`l`/`I`, `rn`/`m`; **desactivar las ligaduras de programación** para que `<-`, `>=`, `%>%` se impriman como caracteres literales; 9–9.5 pt, un solo tamaño de código en todo el libro.
- [ ] Verificar que las **líneas largas de código no se desborden** de la caja.
- [ ] Si el libro se imprime en B/N, usar un coloreado de sintaxis seguro en escala de grises (ver consulta de color, §9).

## 7. Composición del texto

- [ ] La **justificación general se ve correcta**. Única observación puntual: evitar que se **partan al final de renglón los nombres propios y el código** (en la prueba aparece «de-COM(P)ADRE» cortado); COMPADRE, raretrans, ggplot2, etc. no deberían dividirse.

## 8. Preliminares y aperturas de capítulo

- [ ] Confirmar si el título "flotando" arriba a la derecha en la **portadilla (p. i)** es intencional.
- [ ] Confirmar si el filete decorativo solo en la página izquierda de la **portada** es deliberado (asimetría).
- [ ] Aperturas de capítulo sobrias y correctas (bien que **omitan el titulillo**); si se quiere reforzar el arranque, un tratamiento consistente (más aire o filete).

## 9. Color, folios y varios

- [ ] **Consulta sobre color (aclaración, para confirmar con diseño).** Conviene confirmar la **política de color del libro** —a color, B/N, o color solo en pliegos— porque afecta al diagrama Fig. 2.2 (hoy en azul) y al coloreado del código. No es una observación crítica, solo una aclaración para diagramar en consecuencia.
- [ ] Folios centrados al pie: bien.
- [ ] Considerar un **Índice de figuras / Índice de tablas** en las preliminares.

---

## Preguntas para el equipo de diseño

1. ¿El libro se imprimirá **a color, en B/N, o color solo en pliegos** seleccionados?
2. ¿Qué **familias tipográficas** y **tamaños** por nivel están usando actualmente? (para partir de ahí)
3. ¿Cuál es el **tamaño de página** final y los **márgenes** definitivos?
4. ¿Pueden enviar una **hoja de muestra** con la tipografía propuesta aplicada a una página de texto, a la tabla grande y a un bloque de código?

---

*Nota: los aspectos de contenido (erratas, marcadores de posición, numeración de secciones repetida, dedicatoria y referencias) se documentan por separado en `revision_prueba_paginacion_preliminar`, para no mezclarlos con esta revisión de diseño.*
