# Correcciones aplicadas — Capítulo 13 (Dinámica transitoria)

Resumen de los cambios aplicados al archivo `112-Dinamica_de_Transiciones.qmd` en respuesta a los comentarios de Mariana Hernández-Apolinar (Correcciones_Capitulo13_Dinámica transitoria.docx).

## Cambios aplicados directamente

1. **`library(flextable)` añadida** al bloque de librerías de R requeridas para el módulo (p. 175).
2. **Preposición "de" → "a"** en construcciones del tipo `[sustantivo] de largo/corto plazo` → `[sustantivo] a largo/corto plazo`. Se conservaron las construcciones con `en el largo/corto plazo` y los paréntesis explicativos `(corto plazo)` / `(largo plazo)`. Cubre títulos de §13.3, §13.5.1, §13.5 (encabezado), §13.6, y los párrafos correspondientes en §13.4, §13.5.1, §13.6, §13.7, §13.8 y §13.9.1, además de dos comentarios de código `## PROYECCIÓN DE LA DINÁMICA A CORTO PLAZO`.
3. **Oración añadida al final del §13.5.1** ("Análisis de la dinámica a largo plazo"): «Con este objetivo, se requiere contar con la matriz de transición y la estructura poblacional inicial para, finalmente, estimar la tasa de crecimiento a largo plazo.»
4. **`### Crecimiento asintótico` se convirtió en `b) *Crecimiento asintótico*`** (inciso paralelo al `a)` "Matriz de transición y estructura poblacional inicial"). La primera oración se reescribió a: «El crecimiento de la población de tipo asintótico, $λ$ (de ahora en adelante $λ_{max}$), se estima en *R* con la función `lambda`. Este crecimiento se alcanza a largo plazo si se mantienen las condiciones constantes de la población...».
5. **§13.6 reestructurada**:
   - El inciso `a) Selección de la estructura poblacional inicial...` se convirtió en subsección `### Selección de la estructura poblacional inicial`.
   - La lista numerada 1-5 de escenarios se convirtió en cinco subsecciones `####` (Límite inferior, Inicio I, Estructura estable de la población, Inicio II, Límite superior). En la numeración de Quarto quedan como 13.6.1.1 … 13.6.1.5.
   - El callout-note sobre la sensibilidad a la estructura inicial se movió antes de los cinco escenarios, donde sirve como contexto introductorio.
6. **"Dinámica poblacional absoluta" promovida** de `###` a `##` (queda como §13.7). Se añadió `### Proyección por escenarios` como contenedor de los cinco escenarios `####` (queda como §13.7.1, con sub-escenarios 13.7.1.1 … 13.7.1.5). La subsección `### Gráfica de la dinámica absoluta escenario 1, 3 y 5` queda como §13.7.2.
7. **Gráfica de los 5 escenarios** (`trans23`): se cambió `eval=FALSE` por `eval=TRUE` (con `echo=FALSE`) para que la figura se renderice. Reemplaza la nota de Mariana sobre "incorporar la gráfica como imagen" — ahora se genera dinámicamente desde el código.

## Numeración resultante de §13 (después de los cambios)

| § | Título |
|---|---|
| 13.1 | Variación temporal de las transiciones demográficas |
| 13.2 | Modelación de transiciones variables en el tiempo |
| 13.3 | Dinámica poblacional a largo y corto plazo |
| 13.4 | Modelos de dinámica transitoria |
| 13.5 | Proyecto de dinámica transitoria o a corto plazo |
| 13.5.1 | Análisis de la dinámica a largo plazo |
| 13.6 | Análisis de la dinámica a corto plazo |
| 13.6.1 | Selección de la estructura poblacional inicial |
| 13.6.1.1 – 13.6.1.5 | (escenarios) |
| 13.7 | Dinámica poblacional absoluta |
| 13.7.1 | Proyección por escenarios |
| 13.7.1.1 – 13.7.1.5 | (escenarios) |
| 13.7.2 | Gráfica de la dinámica absoluta escenario 1, 3 y 5 |
| 13.8 | Dinámica poblacional transitoria estandarizada |
| 13.9 | Gráfica de la dinámica poblacional transitoria estandarizada por escenario |
| 13.10 | Gráfica de la dinámica poblacional transitoria estandarizada |
| 13.10.1 | Índices transitorios |
| 13.10.1.1 | Cálculo de los límites transitorios |
| 13.10.1.2 | Crear una tabla de los índices transitorios |
| 13.10.2 | Tabla de los índices transitorios |
| 13.11 | Gráfica de dinámica poblacional transitoria integrando los índices transitorios |

## Discrepancia menor con la propuesta de Mariana

Mariana sugirió que los cinco escenarios bajo "Dinámica poblacional absoluta" se numeraran **13.7.2.1 – 13.7.2.5** (implicando un `13.7.1` no nombrado y un contenedor `13.7.2`). En la implementación quedaron en **13.7.1.1 – 13.7.1.5** porque el contenedor que añadí ("Proyección por escenarios") es la primera y única subsección que precede a los escenarios — un `13.7.1` adicional sin contenido propio sería redundante. La estructura resultante es equivalente; solo cambia el segundo dígito.

El nombre del contenedor "Proyección por escenarios" no aparece literalmente en los comentarios de Mariana. Puedes renombrarlo si tienes una preferencia distinta (ej. "Escenarios", "Resultados por escenario").

## No aplicado / pendiente de tu decisión

Ninguno. Todos los puntos de la hoja de Mariana se atendieron.
