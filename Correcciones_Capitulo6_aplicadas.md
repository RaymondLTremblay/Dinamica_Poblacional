# Correcciones aplicadas — Capítulo 6 (Fecundidad)

Resumen de los cambios aplicados al archivo `106-calcular_fecundidad.qmd` (y `book.bib`) en respuesta a las observaciones de Aucencia Emeterio-Lara (`Observaciones_Capitulo6_Fecundidad.pdf`).

## Cambios aplicados directamente

1. **§6.1 ¶2 — guiones eliminados.** Se reemplazaron los guiones medios "—como floración, producción de semillas o reclutamiento—" por comas: ", como floración, producción de semillas o reclutamiento,".

2. **§6.5 ¶2 — cita duplicada eliminada.** En el párrafo "Es importante destacar que la autopolinización no implica necesariamente autogamia estricta…" aparecía `[@talalaj2017ability]` dos veces. Se conservó únicamente la segunda mención (la que va junto a `@talalaj2015mechanism`).

3. **`book.bib` — año añadido a Llabrés Fernández 2015.** La entrada `@llabres2015estudio` no tenía campo `year`. Se añadió `year={2015}`.

4. **§6.8 ¶2 — doble paréntesis arreglado.** La cita `[@arditti1967factors]` estaba dentro de paréntesis, generando "((Arditti, 1967))" en el render. Se reestructuró usando comas: "…etapas de germinación, desde la imbibición hasta el desarrollo de plántulas con dos hojas [@arditti1967factors], la mortalidad…".

5. **§6.10 ¶1 — "uno o pocos años" clarificado.** Se añadió "(1-3 años)" después de "uno o pocos años" y se incluyó la frase de contraste: "en contraste con los 8-19 años requeridos por las especies de mayor tamaño". También se itálico *Pleurothalliinae* (convención taxonómica).

## Marcado para tu revisión (no aplicado)

6. **Cita Meléndez-Ackerman 2000 vs Ackerman 2020.** Aucencia preguntó si la cita en §6.4 ¶3 "Akerman, Ackerman & Rodriguez-Robles, 2000" debería ser "Ackerman et al., 2020?". La cita actual `[@melendez2000reproduction]` corresponde a *Meléndez-Ackerman, Ackerman & Rodriguez-Robles (2000)* sobre *Comparettia falcata* y el contexto (correlación entre flores producidas y frutos abortados tras polinización manual) encaja con ese paper. Es posible que Aucencia haya leído "Meléndez-Ackerman" como "Akerman" y se haya confundido. Si quieres confirmar, revisa el paper original o cámbialo a `@ackerman2020small`.

7. **Cita Henneresse con tres autores.** Aucencia sugiere "Henneresse et al?" para `@henneresse2017effects`. La renderización depende del CSL (`peerj.csl`); muchos estilos muestran los tres autores cuando hay exactamente tres, y "et al." sólo a partir de cuatro. Si prefieres "et al." desde tres autores, habría que editar o sustituir el CSL del libro — cambio global que afectaría todas las citas. Lo dejo pendiente de tu decisión.

## Verificación

El capítulo se mantiene íntegro: títulos, citas y bloques de código no se modificaron (excepto las correcciones puntuales). La entrada de `book.bib` para Llabrés ahora tiene año, por lo que la referencia se renderizará correctamente.
