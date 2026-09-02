# Lista de limpieza del repositorio

Fecha: 2026-09-02. Estado de partida: **2.6 GB en disco**, de los cuales `.git` pesa 858 MB.

Nada de esta lista se ha ejecutado. Es una propuesta ordenada por riesgo: el grupo A
no toca el historial ni el contenido del libro, el grupo B sí cambia qué se versiona,
y el grupo D son decisiones que solo tú puedes tomar.

Todo lo que se borre aquí va a la papelera de Dropbox, así que es recuperable durante
30 días.

------------------------------------------------------------------------

## A. Borrar sin pensarlo (basura, duplicados y caché)

Ninguno de estos archivos es fuente del libro. Suman unos **660 MB**.

| Ruta | Tamaño | Qué es |
|----|----|----|
| `ziHlIoFI` | 145 MB | Zip sin extensión, nombre aleatorio, contiene una copia de `figuras_editor/`. Residuo de una descarga. No rastreado. |
| `zivDQFNU` | 81 MB | Lo mismo, pero **está rastreado en git**. Ver grupo B. |
| `figuras_editor 2/` | 75 MB | Copia en conflicto de Dropbox, anterior a la renumeración: contiene `Fig_3.10_CV10.pdf` donde la carpeta buena tiene `Fig_3.11_CV10.pdf`. Es exactamente la numeración que Franco reclamó. Borrarla evita reenviarla por error. |
| `_archive/` | 178 MB | Cuarentena de las limpiezas de 2026-06-02, 09-01 y 09-02. El propio `CLAUDE.md` dice que se revisa y se borra a mano. Ya cumplió. |
| `.claude/worktrees/` | 83 MB | Worktrees de git de sesiones del agente. Regenerables. |
| `.quarto/` | 98 MB | Caché de Quarto. Se regenera sola. |
| 11 carpetas `file<hex>/` | 264 KB | Widgets htmlwidgets temporales (`widget*.html`). Ya ignoradas por `.gitignore`, pero siguen en disco. |
| `.DS_Store` (varios) | 6 KB c/u | Finder. Están en `.gitignore`. |
| `scripts/__pycache__/` | pequeño | Bytecode de los hooks de Python. |
| `verificar_de_cap13.R` | 4 KB | El propio encabezado dice «archivo temporal, se puede borrar despues». Ya respondió su pregunta sobre `popdemo`. |

Opcionales, solo si no vas a entregar nada en los próximos días (se regeneran con un
render completo, que toma su tiempo):

- `docs/` (350 MB), salida del render. Ya ignorada por git; GitHub Pages la construye Actions.
- `docx_chapters/` (70 MB), los 28 .docx por capítulo. Ya ignorada.
- Los dos zips de entrega en la raíz: `Entrega_Editorial_2026-09-02.zip` (289 MB) y
  `Entrega_Figuras_2026-09-01.zip` (74 MB). El de figuras ya está entregado y superado
  por el paquete completo.

------------------------------------------------------------------------

## B. Sacar del control de versiones (conservando el archivo en disco)

Esto es lo que de verdad explica los 858 MB de `.git`.

| Ruta | Tamaño | Por qué |
|----|----|----|
| `figuras_editor/` | 75 MB, 232 archivos | `CLAUDE.md` ya lo declara generado («do not commit hand-edits»), pero está rastreado. Cada render completo reescribe los 232 archivos y ensucia el historial con binarios. |
| `zivDQFNU` | 81 MB | Zip basura rastreado por error. |
| `LANKASTER/` | 134 MB, 3 archivos | Dos Word de junio (`...Lankester_Juniio_2_2026.docx` y su gemelo), superados por la entrega de hoy, más `Prologos_Shefferson_Jacquemyn.docx`. Propuesta: mover los dos Word viejos a `_archive/`, conservar el de prólogos. |
| `sitemap.xml` | 3 KB | Está en `.gitignore` y a la vez rastreado. `.gitignore` solo afecta a lo no rastreado, así que la regla no hace nada. Decidir una de las dos cosas. |

Comandos, si decides hacerlo:

```bash
git rm -r --cached figuras_editor zivDQFNU LANKASTER sitemap.xml
git commit -m "Dejar de versionar salidas generadas y binarios de entrega"
git gc --prune=now --aggressive
```

`git gc` recupera espacio de objetos sueltos, pero **no borra lo que ya está en commits
antiguos**. Reducir `.git` de verdad exige reescribir el historial (`git filter-repo`),
y eso rompe los clones de los coautores y cambia los hashes que respalda el DOI de
Zenodo. No lo recomiendo.

------------------------------------------------------------------------

## C. Reglas que faltan en `.gitignore`

```
# Salida generada por el post-render (no versionar)
figuras_editor/
figuras_editor 2/

# Paquete completo para la editorial (regenerable)
Entrega_Editorial_*.zip

# Temporal del script de empaquetado
.entrega_tmp/

# Python
__pycache__/
```

Nota: `Entrega_Figuras_*.zip` ya está; `Entrega_Editorial_*.zip` no lo estaba.

------------------------------------------------------------------------

## D. Dudosos: decides tú

Ninguno tiene referencias en `.qmd`, `_quarto.yml`, `R/` ni `scripts/`. Que no se
referencien no significa que sobren, solo que nada del render los usa.

**Archivos de trabajo sin uso actual**

- `Functions.qmd` (apéndice «Functions Used in This Book», no está en `_quarto.yml`) y
  `R_Funciones_in_Book.R`, que es el script que lo genera. Son una pareja: o vuelven al
  libro como apéndice, o se archivan juntos.
- `split_chapters.R`: parte el PDF del libro en PDF por capítulo. Útil, pero no lo usa
  ningún hook. Su sitio natural es `scripts/`.
- `Orchid_Species.csv` (raíz): ¿es la fuente del Apéndice A o una versión vieja?
- `styles.css`: el libro se estiliza con `theme.scss` y `theme-dark.scss`.
- `Funding_Request_Book_Summary.qmd` y su `.docx`: documento administrativo, no del libro.

**Bibliografías y estilos de cita**

- `ftExtra.bib` (155 KB): cero referencias.
- `grateful-refs.bib`: solo aparece en una línea comentada de `index.qmd`.
- `peerj.csl`: sustituido por `lankesteriana.csl` desde 2026-05-29. Sigue listado en
  `.SHARED_ASSETS`; si lo borras, quítalo también de ahí.

**Andamiaje de paquete R en un repo que es un libro**

- `DESCRIPTION`, `NAMESPACE`, `.Rbuildignore`. No hay `R/` con funciones exportadas ni
  se instala este repo como paquete. Si no piensas convertirlo en paquete, sobran.

**Scripts de un solo uso, ya aplicados**

`migrate_chunk_labels.R`, `add_fig_anchors.R`, `apply_captions.R`,
`extract_todo_chunks.R`, `compare_palettes.R`, `collect-figures.sh` (marcado «legacy» en
`CLAUDE.md`), `renumerar_entrega_figuras.py`, `check_inline_order.py`, `_qmd.py`.

Propuesta: no borrarlos (documentan cómo llegó el libro a su estado actual) sino
moverlos a `scripts/_oneshot/` y anotarlo en la tabla de `CLAUDE.md`. Así queda claro de
un vistazo qué se corre y qué no.

------------------------------------------------------------------------

## E. Lo que NO hay que tocar

Reviso esto porque es la tentación obvia con 69 MB en `images/`.

De los **125 archivos** de `images/` y `figs/`, solo **2** no aparecen citados en ningún
sitio: `images/Aucencia_ascenso.jpg` (125 KB) y `images/CV9_Os.png` (110 KB). Los otros
34 que un `grep` ingenuo marca como huérfanos son los **PDF vectoriales hermanos** que
generan `save_plot_png()`, `plc_save()` y `grviz_save()`: nadie los nombra en el texto
porque `collect_figures.R` los encuentra por el nombre del `.png`. Borrarlos dejaría al
editor sin las versiones vectoriales.

Conclusión: `images/` y `figs/` están limpias. No hagas barrido masivo ahí.

------------------------------------------------------------------------

## Resumen

| Grupo | Recupera | Riesgo |
|----|----|----|
| A (basura y caché) | ~660 MB, hasta 1.4 GB con `docs/`, `docx_chapters/` y los zips | Ninguno |
| B (dejar de versionar) | Frena el crecimiento futuro de `.git` | Bajo, ningún archivo desaparece del disco |
| C (`.gitignore`) | Evita repetir el problema | Ninguno |
| D (dudosos) | Poco espacio, mucha claridad | Requiere tu criterio |

------------------------------------------------------------------------

## VEREMOS en el futuro

Anotado, no urgente. Nada de esto hace falta ahora: el libro compila y la entrega salió.

**Quitar `packages.bib` de `index.qmd`.** Ese archivo tiene 9 entradas (`R-base`,
`R-knitr`, `R-rmarkdown`, `R-bookdown` y variantes) y **ninguna se cita en ningún
capítulo**. Es residuo de la época de bookdown, cuando `knitr::write_bib()` lo generaba
solo. `index.qmd` es el único capítulo que lo declara, y esa declaración fue la causa
del fallo del 2026-09-02 al renderizar por capítulo.

Estado actual: resuelto por el otro lado, enlazando `packages.bib` en `.SHARED_ASSETS`
(`scripts/render_docx_per_chapter.R`). Funciona y no molesta.

Si algún día se retoma: borrar las dos líneas de `packages.bib` del YAML de `index.qmd`
(queda `bibliography: book.bib`, que es lo que `_quarto.yml` ya define para todo el
libro, así que `index.qmd` podría no declarar bibliografía en absoluto), mover
`packages.bib` a `_archive/`, y dejar igualmente la entrada en `.SHARED_ASSETS` como
red de seguridad por si otro capítulo declara su propio `.bib`. Hay que rehacer el
render de `index.qmd` para confirmar, aunque al no citarse nada de ese archivo la
bibliografía del Word no debería cambiar.

Recordatorio de fondo, por si la duda vuelve: la editorial nunca recibe archivos `.bib`.
El paquete lleva `.docx`, PDF e imágenes. Citeproc resuelve las citas y escribe la lista
de referencias como texto dentro del Word durante el render. El `.bib` es insumo de
compilación, no entregable.
