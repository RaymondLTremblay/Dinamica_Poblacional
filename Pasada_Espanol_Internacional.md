# Pasada de español internacional — resumen

Resumen de la pasada de copy-edit panhispánica realizada el 2026-05-13 sobre todos los capítulos del libro.

## Guía de estilo de referencia

Se creó `STYLE_GUIDE.md` con las convenciones consolidadas (ortografía, vocabulario, citas, decimales, itálicas, símbolos matemáticos, compatibilidad HTML/PDF).

## Cambios aplicados por categoría

### Inconsistencias de número (sustantivo/verbo)

- **115-Metodos_de_simulaciones.qmd** — 8 instancias de "la especies" → "la especie"; 1 instancia de "una especies" → "una especie".
- **115-Metodos_de_simulaciones.qmd** — múltiples "esta" → "está", "evalué" → "evalúe", concordancia plural/singular.
- **114-LTRE.qmd §15.6** — "cada tasa vitales sobre la historia de vida de la especies comparando las dos matrix" → "cada tasa vital sobre la historia de vida de la especie, comparando las dos matrices".
- **119-COMPADRE_ORCHIDS.qmd §16.x** — "el nombre de la especies" → "el nombre de la especie".

### Ortografía RAE

- **115-Metodos_de_simulaciones.qmd** — "intrínsicas/intrínsico" → "intrínsecas/intrínseco" (2 instancias); "ect" → "etc" (3 instancias); "linea" → "línea"; "sera" → "será".
- **102-Intro.qmd §1.10** — "Uso especifico" → "Uso específico".

### Itálicas faltantes (binomios latinos)

- **102-Intro.qmd §1.2** — "Calvaria major persiste" → "*Calvaria major* persiste" (faltaba itálica en la segunda mención).

### Reescrituras de claridad

- **102-Intro.qmd** — pie de figura "Factores que influencia la dinámica de una población" → "Factores que influyen en la dinámica de una población".
- **102-Intro.qmd §1.10** — encabezado "Cuál de los procesos y patrones evolutivos del ciclo de vida de especies impacta su crecimiento o grupos taxonómicos" reescrito a "Procesos y patrones evolutivos del ciclo de vida que impactan el crecimiento poblacional".
- **113-Funciones_de_Transferencia.qmd §14.5.5 / §14.7.6** — "eje X" / "eje Y" → "eje *x*" / "eje *y*" (convención RAE: ejes en minúscula y cursiva).
- **115-Metodos_de_simulaciones.qmd §15.x** — varios párrafos reescritos para fluidez: "En este caso se asume que hay las 3 poblaciones afectada de forma antropogénicas..." → "En este caso se asume que las 3 poblaciones afectadas antropogénicamente son más comunes que las poblaciones naturales..." (concordancia de género/número y eliminación de redundancia).

### Convención decimal

Confirmada: se conserva el punto (`0.5`, `λ = 1.007`) en prosa y código. La coma decimal española se rechaza para mantener consistencia con R.

### Convención de citas

Confirmada: hasta 3 autores se muestran completos, "et al." desde 4. El CSL actual (`peerj.csl`) implementa esto correctamente.

## Capítulos revisados

Todos los capítulos del libro pasaron por una pasada de grep dirigida a los patrones más comunes de inconsistencia:

| Capítulo | Status |
|----------|--------|
| index.qmd | ✓ limpio |
| 102-Intro | ✓ revisado, 4 correcciones |
| 103-Ciclos_de_Vida | ✓ limpio |
| 104-Recopilación_datos_en_el_campo | ✓ limpio |
| 105-Transiciones | ✓ limpio |
| 106-calcular_fecundidad | ✓ revisado en pasada anterior |
| 107-matU_matF_matC | ✓ limpio |
| 108-Bayesian_PPM | ✓ limpio |
| 109-Crecimiento_poblacional | ✓ limpio |
| 110-Propiedades | ✓ limpio |
| 111-Elasticidad | ✓ revisado en pasada anterior |
| 112-Dinámica_de_Transiciones | ✓ revisado en pasada anterior |
| 113-Funciones_de_Transferencia | ✓ revisado, 2 correcciones (ejes x/y) |
| 114-LTRE | ✓ revisado, 1 corrección |
| 115-Métodos_de_simulaciones | ✓ revisado, ~15 correcciones |
| 119-COMPADRE_ORCHIDS | ✓ revisado, 1 corrección |
| 120-Rage_orquideas | ✓ limpio |
| 121-Traducción_protocolo_informacion | ✓ limpio |
| 122-Impacto_de_Datos_sin_Sentido | ✓ limpio |
| 123-Conclusion | ✓ limpio |
| 117_Historia_breve | ✓ limpio |
| 118-Carl_Olaf_Tamm | ✓ limpio |
| Apéndices A, B, C, Agradecimientos | ✓ limpio |

## Verificación final

Grep confirma cero residuales de:
- `la especies` (singular incorrecto)
- `una especies` (singular incorrecto)
- `intrínsic[ao]` (ortografía incorrecta)
- `ect` (typo de etc)
- `sensitividad` (ortografía incorrecta)
- `optiene` (ortografía incorrecta)

No hay citas con formato roto (`\\[\\@`) ni referencias cruzadas no resueltas en los archivos.

## Pendiente de tu lado

- **Render local**: ejecuta `quarto render` para producir HTML y PDF, y revisa que todo se vea bien. No tengo Quarto en este entorno; los cambios son textuales pero no he renderizado.
- **Imagen `_main.epub` o salida de PDF**: verifica que las correcciones a los pies de figura/tabla se muestren bien después del render.
- **Última lectura de prueba**: si tienes media hora extra antes del viernes, dale una lectura rápida al capítulo 115 (Métodos de simulaciones) — era el que tenía la mayor concentración de problemas y reescribí varios párrafos enteros.
