#!/usr/bin/env python3
"""
collect_figures.py — recolecta todas las figuras del libro
"Introducción a la Dinámica Poblacional de Orquídeas" en una
estructura por capítulo numerado, con figuras prefijadas por su
posición de aparición.

Después de cada `quarto render`, este script genera:

figuras_editor/
├── 01-Introduccion/
│   ├── 01_Tolumnia_variegata_Tremblay.jpeg
│   └── 02_Demografia_de_una_poblacion.jpg
├── 02-Ciclos_de_Vida/
│   ├── 01_Orchis_purpurea_1_Hans_Jacquemyn.jpg
│   ├── 02_Orchis_purpurea_2_Hans_Jacquemyn.jpg
│   ├── 03_CV_2.png       ← generada por chunk de R
│   ├── 04_CV_3.png
│   └── ...
├── 03-Recopilacion_datos_en_el_campo/
│   └── ...
└── ...

Cada archivo lleva en su nombre la posición ordinal de la figura en
el capítulo, lo cual facilita al productor/editor saber dónde va cada
imagen sin tener que abrir el .qmd correspondiente.

Uso:
    python3 scripts/collect_figures.py
"""

from __future__ import annotations
import os
import re
import shutil
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DEST = ROOT / "figuras_editor"
DOCS = ROOT / "docs"
IMAGES = ROOT / "images"

# Orden y nombres legibles de los capítulos. Tomar de _quarto.yml sería
# ideal, pero por simplicidad usamos un mapeo directo.
CHAPTERS = [
    ("index.qmd",                              "00-Prefacio"),
    ("102-Intro.qmd",                          "01-Introduccion"),
    ("103-Ciclos_de_Vida.qmd",                 "02-Ciclos_de_Vida"),
    ("104-Recopilacion_datos_en_el_campo.qmd", "03-Recopilacion_datos_en_el_campo"),
    ("105-Transiciones.qmd",                   "04-Transiciones"),
    ("106-calcular_fecundidad.qmd",            "05-Fecundidad"),
    ("107-matU_matF_matC.qmd",                 "06-matU_matF_matC"),
    ("108-Bayesian_PPM.qmd",                   "07-Bayesian_PPM"),
    ("109-Crecimiento_poblacional.qmd",        "08-Crecimiento_poblacional"),
    ("110-Propriedades.qmd",                   "09-Propiedades"),
    ("111-Elasticidad.qmd",                    "10-Elasticidad"),
    ("112-Dinamica_de_Transiciones.qmd",       "11-Dinamica_transitoria"),
    ("113-Funciones_de_Transferencia.qmd",     "12-Funciones_de_Transferencia"),
    ("114-LTRE.qmd",                           "13-LTRE"),
    ("115-Metodos_de_simulaciones.qmd",        "14-Metodos_de_simulaciones"),
    ("117_Historia_breve.qmd",                 "15-Historia_breve"),
    ("118-Carl_Olaf_Tamm.qmd",                 "16-Carl_Olaf_Tamm"),
    ("119-COMPADRE_ORCHIDS.qmd",               "17-COMPADRE"),
    ("120-Rage_orquideas.qmd",                 "18-Rage"),
    ("121-Traduccion_protocolo_informacion.qmd","19-Protocolo"),
    ("122-Impacto_de_Datos_sin_Sentido.qmd",   "20-Datos_sin_sentido"),
    ("123-Conclusion.qmd",                     "21-Conclusion"),
    ("Appendix_A_Species_List.qmd",            "ApA-Lista_especies"),
    ("Appendix_B_Hoja_de_datos.qmd",           "ApB-Hoja_de_datos"),
    ("Appendix_C_Datos.qmd",                   "ApC-Datos"),
    ("Agradecimientos.qmd",                    "Agradecimientos"),
]

# Patrón de imagen markdown: ![alt](path){attrs}
IMG_PATTERN = re.compile(r'!\[[^\]]*\]\(([^)]+)\)')

# Patrón de inicio de chunk R: ```{r [label], ...}
# El label es un identificador (sin =) seguido de , } o espacio. Si el
# primer token contiene = (e.g. echo=FALSE), es un parámetro, no label.
CHUNK_HEADER = re.compile(
    r'^```\{r[\s,]+([a-zA-Z_][a-zA-Z0-9_.\-]*)(?=\s*[,}])'
)

# render_dual(dot, "path/to/file.png")
RENDER_DUAL = re.compile(r'render_dual\([^,]+,\s*"([^"]+)"\s*\)')


def parse_figures_in_chapter(qmd_path: Path) -> list[dict]:
    """
    Parse a .qmd file and return an ordered list of figure references.

    Each entry is one of:
      - {'type': 'static', 'src': 'images/foo.jpg'}      → markdown image
      - {'type': 'dynamic', 'chunk': 'bayes16',
         'src': None}                                     → R chunk figure
      - {'type': 'render_dual', 'src': 'images/CV_2.png'} → render_dual call

    Returns figures in the order they appear in the document.
    """
    if not qmd_path.exists():
        return []

    content = qmd_path.read_text(encoding='utf-8')
    lines = content.splitlines()

    figures = []
    in_chunk = False
    chunk_label = None
    chunk_produces_figure = False
    chunk_eval_false = False  # si el chunk tiene eval=FALSE no se renderiza

    for i, line in enumerate(lines):
        # Track chunk state
        stripped = line.strip()
        if stripped.startswith('```{r') or stripped.startswith('```{python'):
            in_chunk = True
            m = CHUNK_HEADER.match(stripped)
            chunk_label = m.group(1) if m and m.group(1) else None
            if chunk_label and chunk_label.endswith(','):
                chunk_label = chunk_label[:-1]
            # Detectar eval=FALSE en la cabecera (e.g., {r chunk, eval=FALSE})
            chunk_eval_false = bool(re.search(r'\beval\s*=\s*FALSE\b', stripped))
            chunk_produces_figure = False
            continue
        if stripped == '```' and in_chunk:
            # End of chunk — record si produce figura Y no está deshabilitado
            if chunk_produces_figure and chunk_label and not chunk_eval_false:
                figures.append({
                    'type': 'dynamic',
                    'chunk': chunk_label,
                    'src': None,
                })
            in_chunk = False
            chunk_label = None
            chunk_produces_figure = False
            chunk_eval_false = False
            continue

        # Detectar `#| eval: false` o `#| eval: FALSE` dentro del chunk
        if in_chunk and re.match(r'\s*#\|\s*eval\s*:\s*(false|FALSE)\b', line):
            chunk_eval_false = True
            continue

        if in_chunk:
            # Detectar llamadas que sí producen un PNG en docs/*_files/figure-html/.
            # Las siguientes NO producen PNG y se excluyen:
            #   - plot_life_cycle(), DiagrammeR::grViz()  → widgets HTML
            #   - flextable(), kable(), gt(), datatable() → tablas (no figuras)
            # Las que sí producen PNG son ggplot, plot, barplot, hist, boxplot,
            # image, contour, persp, etc.
            figure_calls = ('ggplot(', 'plot(', 'barplot(',
                            'hist(', 'boxplot(', 'image(',
                            'contour(', 'persp(', 'pairs(',
                            'matplot(', 'curve(')
            # Pero excluir si la línea sólo llama plot_life_cycle o grViz
            non_figure = ('plot_life_cycle(', 'grViz(', 'flextable(',
                          'kable(', 'gt(', 'datatable(')
            if any(c in line for c in figure_calls) and not any(n in line for n in non_figure):
                chunk_produces_figure = True
            # render_dual() — generates a static PNG with known path
            m = RENDER_DUAL.search(line)
            if m:
                figures.append({
                    'type': 'render_dual',
                    'src': m.group(1),
                })
                chunk_produces_figure = False  # don't double-count
        else:
            # Outside chunks: look for markdown images
            for m in IMG_PATTERN.finditer(line):
                src = m.group(1)
                # Skip dynamic R chunk references like `r fig.cap`
                if 'images/' in src or src.endswith(('.png', '.jpg', '.jpeg', '.svg', '.gif')):
                    figures.append({
                        'type': 'static',
                        'src': src,
                    })
    return figures


def safe_name(s: str) -> str:
    """Make a string safe for use as a filename component."""
    s = re.sub(r'[^\w\.\-]', '_', s)
    s = re.sub(r'_+', '_', s)
    return s.strip('_')


def main():
    if DEST.exists():
        try:
            shutil.rmtree(DEST)
        except PermissionError as e:
            print(f"⚠️  No se pudo borrar {DEST}: {e}\n"
                  f"   Borra manualmente y vuelve a correr.", file=sys.stderr)
            sys.exit(1)
    DEST.mkdir(parents=True)

    total_copied = 0
    chapters_with_figs = 0
    # Warnings agrupadas para imprimir resumen al final
    missing_static = []          # (chapter, src)
    missing_render_dual = []     # (chapter, src)
    chapters_no_render_dir = []  # chapters whose docs/*_files/figure-html/ doesn't exist
    missing_chunks = []          # (chapter, chunk) — chunk no produjo PNG

    for qmd_file, chapter_label in CHAPTERS:
        qmd_path = ROOT / qmd_file
        figures = parse_figures_in_chapter(qmd_path)
        if not figures:
            continue

        chapter_dir = DEST / chapter_label
        chapter_dir.mkdir(parents=True, exist_ok=True)
        chapters_with_figs += 1

        qmd_stem = Path(qmd_file).stem
        figure_html_dir = DOCS / f"{qmd_stem}_files" / "figure-html"
        dir_warned = False  # solo avisar una vez por capítulo

        pos = 0
        for fig in figures:
            pos += 1
            pos_str = f"{pos:02d}"

            if fig['type'] == 'static':
                src_path = ROOT / fig['src']
                if not src_path.exists():
                    missing_static.append((chapter_label, fig['src']))
                    continue
                dest_name = f"{pos_str}_{safe_name(src_path.name)}"
                shutil.copy2(src_path, chapter_dir / dest_name)
                total_copied += 1

            elif fig['type'] == 'render_dual':
                src_path = ROOT / fig['src']
                if not src_path.exists():
                    missing_render_dual.append((chapter_label, fig['src']))
                    continue
                dest_name = f"{pos_str}_{safe_name(src_path.name)}"
                shutil.copy2(src_path, chapter_dir / dest_name)
                total_copied += 1

            elif fig['type'] == 'dynamic':
                chunk = fig['chunk']
                if not figure_html_dir.exists():
                    if not dir_warned:
                        chapters_no_render_dir.append(chapter_label)
                        dir_warned = True
                    continue
                # Quarto puede generar varios PNGs por chunk con sufijos -1, -2.
                matches = sorted(figure_html_dir.glob(f"{chunk}-*"))
                if not matches:
                    matches = sorted(figure_html_dir.glob(f"{chunk}.*"))
                if not matches:
                    missing_chunks.append((chapter_label, chunk))
                    continue
                for j, mfile in enumerate(matches, start=1):
                    suffix = f"_{j}" if len(matches) > 1 else ""
                    dest_name = f"{pos_str}{suffix}_{safe_name(mfile.name)}"
                    shutil.copy2(mfile, chapter_dir / dest_name)
                    total_copied += 1

    # Imprimir reporte
    print(f"\n✓ Recolectadas {total_copied} figuras en {chapters_with_figs} capítulos.")
    print(f"  Carpeta de destino: {DEST.relative_to(ROOT)}/")

    # Resumen de advertencias (silencioso por defecto, pasar --verbose para detalle)
    n_warnings = (len(missing_static) + len(missing_render_dual) +
                  len(chapters_no_render_dir) + len(missing_chunks))
    if n_warnings:
        verbose = '--verbose' in sys.argv or '-v' in sys.argv
        print(f"\n  Advertencias: {n_warnings}", file=sys.stderr)
        if missing_static:
            print(f"    {len(missing_static)} imágenes estáticas referenciadas "
                  f"no existen en disco (probablemente código comentado).",
                  file=sys.stderr)
        if missing_render_dual:
            print(f"    {len(missing_render_dual)} archivos de render_dual no existen "
                  f"(corre `quarto render` para generarlos).",
                  file=sys.stderr)
        if chapters_no_render_dir:
            print(f"    {len(chapters_no_render_dir)} capítulos sin figuras dinámicas "
                  f"generadas: probablemente todos sus chunks son widgets "
                  f"(plot_life_cycle, grViz) o tablas (flextable).",
                  file=sys.stderr)
        if missing_chunks:
            print(f"    {len(missing_chunks)} chunks marcados como productores de "
                  f"figura pero sin PNG correspondiente (similar a lo anterior).",
                  file=sys.stderr)
        print(f"    (Pasar --verbose para ver el detalle.)", file=sys.stderr)

        if verbose:
            print("\n  Detalle de advertencias:", file=sys.stderr)
            for c, s in missing_static:
                print(f"    [{c}] estática faltante: {s}", file=sys.stderr)
            for c, s in missing_render_dual:
                print(f"    [{c}] render_dual faltante: {s}", file=sys.stderr)
            for c in chapters_no_render_dir:
                print(f"    [{c}] sin carpeta de render", file=sys.stderr)
            for c, ch in missing_chunks:
                print(f"    [{c}] chunk {ch!r} sin PNG", file=sys.stderr)


if __name__ == '__main__':
    main()
