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
│   ├── 02_CV_2.png       ← generada por render_dual()
│   └── ...
└── ...

Cada archivo lleva en su nombre la posición ordinal de la figura en
el capítulo, lo cual facilita al productor/editor saber dónde va cada
imagen sin tener que abrir el .qmd correspondiente.

Adicionalmente, el script genera/actualiza:
  - Figuras_Inventario.csv  — tabla con todas las figuras y su ubicación
  - Figuras_Manifiesto.md   — reporte legible para el editor

Uso:
    python3 scripts/collect_figures.py            # silencioso
    python3 scripts/collect_figures.py --verbose  # muestra todas las advertencias
    python3 scripts/collect_figures.py --audit    # no copia, solo reporta
"""

from __future__ import annotations
import csv
import os
import re
import shutil
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DEST = ROOT / "figuras_editor"
DOCS = ROOT / "docs"
IMAGES = ROOT / "images"
CSV_PATH = ROOT / "Figuras_Inventario.csv"
MD_PATH = ROOT / "Figuras_Manifiesto.md"

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
IMG_PATTERN = re.compile(r'!\[([^\]]*)\]\(([^)]+)\)')

# Patrón de inicio de chunk R. Acepta:
#   ```{r}                       → sin label
#   ```{r label}                 → label sin coma
#   ```{r label, opts}           → label seguido por coma
#   ```{r, opts}                 → coma después de r (sin label) → unnamed
#   ```{r, label, opts}          → coma después de r, luego label
# Devuelve el label si existe, o None.
CHUNK_START = re.compile(r'^```\{(r|python)([\s,]+(.*))?\}')

# render_dual(dot, "path/to/file.png")
RENDER_DUAL = re.compile(r'render_dual\s*\([^,]+,\s*["\']([^"\']+)["\']\s*\)')

# ggsave("path/file.png", ...)  o  ggsave(filename = "...")
GGSAVE_QUOTED = re.compile(r'ggsave\s*\(\s*(?:filename\s*=\s*)?["\']([^"\']+)["\']')

# save_plot_png(obj, file = "path/file.png", ...) o save_plot_png(obj, "path")
SAVE_PLOT_PNG = re.compile(
    r'save_plot_png\s*\([^,]+,\s*(?:file\s*=\s*)?["\']([^"\']+)["\']'
)

# plc_save(..., png = "path/file.png")  — atajo R/figuras_helpers.R
# grviz_save(..., png = "path/file.png")
PLC_OR_GRVIZ_SAVE = re.compile(
    r'(?:plc_save|grviz_save)\s*\([^)]*?png\s*=\s*["\']([^"\']+)["\']'
)

# Llamadas que generan PNGs en docs/<qmd>_files/figure-html/
FIGURE_CALLS = ('ggplot(', 'plot(', 'barplot(', 'hist(', 'boxplot(',
                'image(', 'contour(', 'persp(', 'pairs(', 'matplot(',
                'curve(', 'autoplot(', 'ggarrange(', 'grid.arrange(',
                'plot_grid(',          # cowplot::plot_grid
                'stage.vector.plot(',  # popbio
                'image.plot(')         # fields

# Llamadas que producen widgets HTML (NO generan PNG en docs/figure-html/)
WIDGET_CALLS = ('plot_life_cycle(', 'grViz(',)

# Llamadas que generan tablas (no figuras)
TABLE_CALLS = ('flextable(', 'kable(', 'gt(', 'datatable(', 'huxtable(')


def extract_chunk_label(header_line: str) -> tuple[str | None, bool]:
    """
    Extract the chunk label from a chunk header line.

    Returns (label_or_None, skip).

    `skip` es True si el chunk tiene `eval=FALSE` o `include=FALSE` — en ambos
    casos el chunk no produce salida visible.

    Notes:
      - `\`\`\`{r}`                  → (None, False) — unnamed chunk
      - `\`\`\`{r label}`            → ('label', False)
      - `\`\`\`{r label, opt=...}`   → ('label', False)
      - `\`\`\`{r, opt=...}`         → (None, False) — coma sin label
      - `\`\`\`{r, label, ...}`      → ('label', False) — formato inválido
                                       que knitr trata como unnamed
    """
    m = CHUNK_START.match(header_line.strip())
    if not m:
        return None, False
    rest = m.group(3) or ""
    eval_false = bool(re.search(r'\beval\s*=\s*(FALSE|F)\b', rest) or
                      re.search(r'\binclude\s*=\s*(FALSE|F)\b', rest))
    # Split by comma; the first non-empty token that isn't a `key=value` is label
    label = None
    tokens = [t.strip() for t in rest.split(',')]
    for tok in tokens:
        if not tok:
            continue
        if '=' in tok or ':' in tok:
            continue
        if re.match(r'^[a-zA-Z_][a-zA-Z0-9_.\-]*$', tok):
            label = tok
            break
        else:
            break
    return label, eval_false


def parse_figures_in_chapter(qmd_path: Path) -> list[dict]:
    """
    Parse a .qmd file and return an ordered list of figure references.

    Cada entrada es uno de:
      - {'type': 'static',  'src': 'images/foo.jpg', 'line': N, 'caption': '...'}
      - {'type': 'render_dual', 'src': 'images/CV_2.png', 'line': N}
      - {'type': 'ggsave', 'src': 'images/foo.png', 'line': N}
      - {'type': 'dynamic',  'chunk': 'bayes16',     'line': N,
                             'unnamed_idx': N|None}  → ggplot/plot chunk → PNG
      - {'type': 'widget',   'chunk': 'CV_1b',       'line': N,
                             'fn': 'plot_life_cycle'}  → SIN PNG (solo widget)
    """
    if not qmd_path.exists():
        return []

    content = qmd_path.read_text(encoding='utf-8')
    lines = content.splitlines()

    figures = []
    in_chunk = False
    chunk_label = None
    chunk_start_line = None
    chunk_eval_false = False
    chunk_produces_figure = False
    chunk_widget_fn = None  # nombre de la función widget detectada
    unnamed_counter = 0  # contador de chunks SIN label (knitr genera unnamed-chunk-N)

    for i, line in enumerate(lines):
        stripped = line.strip()

        # Inicio de chunk
        if (stripped.startswith('```{r') or stripped.startswith('```{python')) and not in_chunk:
            in_chunk = True
            chunk_start_line = i + 1
            chunk_label, chunk_eval_false = extract_chunk_label(stripped)
            chunk_produces_figure = False
            chunk_widget_fn = None
            if chunk_label is None:
                unnamed_counter += 1
            continue

        # Fin de chunk
        if stripped == '```' and in_chunk:
            if not chunk_eval_false:
                if chunk_widget_fn:
                    figures.append({
                        'type': 'widget',
                        'chunk': chunk_label,
                        'line': chunk_start_line,
                        'fn': chunk_widget_fn,
                    })
                elif chunk_produces_figure:
                    figures.append({
                        'type': 'dynamic',
                        'chunk': chunk_label,
                        'line': chunk_start_line,
                        'unnamed_idx': unnamed_counter if chunk_label is None else None,
                    })
            in_chunk = False
            chunk_label = None
            chunk_start_line = None
            chunk_eval_false = False
            chunk_produces_figure = False
            chunk_widget_fn = None
            continue

        # eval: false  o  include: false  dentro del chunk
        if in_chunk and re.match(
            r'\s*#\|\s*(eval|include)\s*:\s*(false|FALSE|F)\b', line):
            chunk_eval_false = True
            continue

        if in_chunk:
            # Quitar comentarios de R (todo lo que va después de #) ANTES de
            # buscar llamadas. Esto evita falsos positivos de `#plot(...)`.
            # Aproximación simple: cortar en el primer # que no esté dentro
            # de comillas. Si la línea entera empieza con espacios + #, ignorar.
            code_only = line.split('#', 1)[0] if not _hash_inside_string(line) else line

            # Detección de render_dual primero (tiene prioridad)
            m = RENDER_DUAL.search(code_only)
            if m:
                figures.append({
                    'type': 'render_dual',
                    'src': m.group(1),
                    'line': i + 1,
                })
                chunk_produces_figure = False
                continue

            # Detección de plc_save() / grviz_save() — atajos que ADEMÁS
            # guardan PNG en images/. Se tratan como render_dual.
            m = PLC_OR_GRVIZ_SAVE.search(code_only)
            if m:
                figures.append({
                    'type': 'render_dual',
                    'src': m.group(1),
                    'line': i + 1,
                })
                chunk_produces_figure = False
                chunk_widget_fn = None  # cancela el flag de widget
                continue

            # Detección de save_plot_png(p, file = "path")
            m = SAVE_PLOT_PNG.search(code_only)
            if m:
                figures.append({
                    'type': 'render_dual',
                    'src': m.group(1),
                    'line': i + 1,
                })
                chunk_produces_figure = False
                chunk_widget_fn = None  # cancela el flag de widget
                continue
            # save_plot_png con ruta dinámica (file.path(...)) — solo cancelamos
            # el flag de widget; el PNG real se referencia con markdown ![]()
            # más abajo y se cuenta como `static`.
            if 'save_plot_png(' in code_only:
                chunk_widget_fn = None
                chunk_produces_figure = False
                continue

            # Detección de ggsave
            m = GGSAVE_QUOTED.search(code_only)
            if m:
                figures.append({
                    'type': 'ggsave',
                    'src': m.group(1),
                    'line': i + 1,
                })
                chunk_produces_figure = False
                continue

            # Widget HTML (no produce PNG)
            for w in WIDGET_CALLS:
                if w in code_only and not any(t in code_only for t in TABLE_CALLS):
                    chunk_widget_fn = w.rstrip('(')
                    break

            # Llamadas a figura que SÍ producen PNG.
            # Nota: en R es común el patrón `p <- ggplot(...)` seguido en una
            # línea posterior por `p` (sola) para imprimir. Por simplicidad
            # marcamos el chunk como productor de figura si tiene CUALQUIER
            # llamada a ggplot/plot/etc. — aunque ocasionalmente sea solo
            # asignación. El costo: el script reporta "missing_chunks" para
            # esos chunks (sin afectar la entrega real al editor, ya que no
            # hay PNG que copiar).
            if any(c in code_only for c in FIGURE_CALLS) and not any(t in code_only for t in TABLE_CALLS):
                if not chunk_widget_fn:
                    chunk_produces_figure = True

        else:
            # Fuera de chunks: imagen markdown
            for m in IMG_PATTERN.finditer(line):
                alt = m.group(1)
                src = m.group(2)
                # Saltar referencias a variables R interpoladas
                if src.startswith('`') or '{{' in src:
                    continue
                if 'images/' in src or 'figs/' in src or src.endswith(
                        ('.png', '.jpg', '.jpeg', '.svg', '.gif', '.tiff', '.tif')):
                    figures.append({
                        'type': 'static',
                        'src': src,
                        'line': i + 1,
                        'caption': alt,
                    })
    return figures


def safe_name(s: str) -> str:
    s = re.sub(r'[^\w\.\-]', '_', s)
    s = re.sub(r'_+', '_', s)
    return s.strip('_')


def _hash_inside_string(line: str) -> bool:
    """
    Heurística: True si el primer `#` de `line` está dentro de una cadena
    delimitada por "..." o '...'. Esto previene cortar líneas como
    `ggsave("file#1.png")` cuyo `#` no es un comentario.
    """
    in_dq = False
    in_sq = False
    for ch in line:
        if ch == '"' and not in_sq:
            in_dq = not in_dq
        elif ch == "'" and not in_dq:
            in_sq = not in_sq
        elif ch == '#' and not in_dq and not in_sq:
            return False
        elif ch == '#':
            return True
    return False


def try_clear_dir(d: Path) -> bool:
    """Intenta borrar el contenido de d. Devuelve True si tuvo éxito."""
    if not d.exists():
        return True
    ok = True
    for child in sorted(d.iterdir()):
        try:
            if child.is_dir():
                shutil.rmtree(child)
            else:
                child.unlink()
        except (PermissionError, OSError):
            ok = False
    return ok


def main():
    audit = '--audit' in sys.argv
    verbose = '--verbose' in sys.argv or '-v' in sys.argv

    if not audit:
        # Borrar todo el contenido de DEST por capítulo (más robusto en Dropbox)
        if DEST.exists():
            for child in sorted(DEST.iterdir()):
                if child.is_dir():
                    try_clear_dir(child)
        else:
            DEST.mkdir(parents=True)

    # Recolectar info por capítulo
    chapter_records = []  # lista de {chapter, qmd_file, figures: [{pos, type, src, ...}]}
    total_copied = 0
    chapters_with_figs = 0
    warnings = {
        'missing_static': [],     # (chapter, src, line)
        'missing_render_dual': [],
        'missing_ggsave': [],
        'no_render_dir': [],
        'missing_chunks': [],     # (chapter, chunk_or_idx, line)
        'widgets_no_png': [],     # (chapter, chunk, line, fn) — plot_life_cycle/grViz
    }

    for qmd_file, chapter_label in CHAPTERS:
        qmd_path = ROOT / qmd_file
        figures = parse_figures_in_chapter(qmd_path)
        if not figures:
            continue

        chapter_dir = DEST / chapter_label
        if not audit:
            chapter_dir.mkdir(parents=True, exist_ok=True)
        chapters_with_figs += 1

        qmd_stem = Path(qmd_file).stem
        figure_html_dir = DOCS / f"{qmd_stem}_files" / "figure-html"
        dir_warned = False

        records = []
        pos = 0
        for fig in figures:
            pos += 1
            pos_str = f"{pos:02d}"
            rec = {'pos': pos, 'line': fig.get('line'), 'type': fig['type'],
                   'src_qmd': None, 'figura_editor': None, 'caption': fig.get('caption', '')}

            if fig['type'] == 'static':
                src_path = ROOT / fig['src']
                rec['src_qmd'] = fig['src']
                if not src_path.exists():
                    warnings['missing_static'].append((chapter_label, fig['src'], fig['line']))
                    rec['figura_editor'] = '[FALTA EN DISCO]'
                else:
                    dest_name = f"{pos_str}_{safe_name(src_path.name)}"
                    rec['figura_editor'] = f"figuras_editor/{chapter_label}/{dest_name}"
                    if not audit:
                        try:
                            shutil.copy2(src_path, chapter_dir / dest_name)
                            total_copied += 1
                        except OSError as e:
                            print(f"⚠ no se pudo copiar {src_path} → {chapter_dir / dest_name}: {e}",
                                  file=sys.stderr)

            elif fig['type'] == 'render_dual':
                src_path = ROOT / fig['src']
                rec['src_qmd'] = fig['src']
                if not src_path.exists():
                    warnings['missing_render_dual'].append((chapter_label, fig['src'], fig['line']))
                    rec['figura_editor'] = '[FALTA — correr quarto render]'
                else:
                    dest_name = f"{pos_str}_{safe_name(src_path.name)}"
                    rec['figura_editor'] = f"figuras_editor/{chapter_label}/{dest_name}"
                    if not audit:
                        try:
                            shutil.copy2(src_path, chapter_dir / dest_name)
                            total_copied += 1
                        except OSError as e:
                            print(f"⚠ no se pudo copiar {src_path}: {e}", file=sys.stderr)

            elif fig['type'] == 'ggsave':
                # ggsave puede ir a images/ o a otra carpeta — buscar en ambas
                src_path = ROOT / fig['src']
                if not src_path.exists():
                    # Probar nombre relativo desde IMAGES
                    src_path2 = IMAGES / Path(fig['src']).name
                    if src_path2.exists():
                        src_path = src_path2
                rec['src_qmd'] = fig['src']
                if not src_path.exists():
                    warnings['missing_ggsave'].append((chapter_label, fig['src'], fig['line']))
                    rec['figura_editor'] = '[FALTA — correr quarto render]'
                else:
                    dest_name = f"{pos_str}_{safe_name(src_path.name)}"
                    rec['figura_editor'] = f"figuras_editor/{chapter_label}/{dest_name}"
                    if not audit:
                        try:
                            shutil.copy2(src_path, chapter_dir / dest_name)
                            total_copied += 1
                        except OSError as e:
                            print(f"⚠ no se pudo copiar {src_path}: {e}", file=sys.stderr)

            elif fig['type'] == 'widget':
                # plot_life_cycle / grViz: producen widget HTML, NO PNG
                rec['src_qmd'] = f"chunk '{fig.get('chunk') or '(sin label)'}' ({fig['fn']})"
                rec['figura_editor'] = f"[WIDGET HTML — sin PNG; chunk: {fig.get('chunk') or 'sin_label'}]"
                warnings['widgets_no_png'].append(
                    (chapter_label, fig.get('chunk'), fig['line'], fig['fn']))

            elif fig['type'] == 'dynamic':
                chunk = fig['chunk']
                rec['src_qmd'] = f"chunk '{chunk or '(sin label)'}'"
                if not figure_html_dir.exists():
                    if not dir_warned:
                        warnings['no_render_dir'].append(chapter_label)
                        dir_warned = True
                    rec['figura_editor'] = '[FALTA — correr quarto render]'
                    continue

                # Si tiene label, buscar por label; si no, buscar unnamed-chunk-N
                if chunk:
                    matches = sorted(figure_html_dir.glob(f"{chunk}-*"))
                    if not matches:
                        matches = sorted(figure_html_dir.glob(f"{chunk}.*"))
                else:
                    idx = fig.get('unnamed_idx')
                    if idx:
                        matches = sorted(figure_html_dir.glob(f"unnamed-chunk-{idx}-*"))
                    else:
                        matches = []

                if not matches:
                    warnings['missing_chunks'].append(
                        (chapter_label, chunk or f"unnamed-{fig.get('unnamed_idx')}", fig['line']))
                    rec['figura_editor'] = '[FALTA — correr quarto render]'
                else:
                    paths_listed = []
                    for j, mfile in enumerate(matches, start=1):
                        suffix = f"_{j}" if len(matches) > 1 else ""
                        dest_name = f"{pos_str}{suffix}_{safe_name(mfile.name)}"
                        paths_listed.append(f"figuras_editor/{chapter_label}/{dest_name}")
                        if not audit:
                            try:
                                shutil.copy2(mfile, chapter_dir / dest_name)
                                total_copied += 1
                            except OSError as e:
                                # Limpiar el archivo destino de 0 bytes que cp deja
                                # cuando falla con "Resource deadlock avoided"
                                dst = chapter_dir / dest_name
                                if dst.exists() and dst.stat().st_size == 0:
                                    try: dst.unlink()
                                    except OSError: pass
                                print(f"⚠ no se pudo copiar {mfile}: {e}", file=sys.stderr)
                    rec['figura_editor'] = '; '.join(paths_listed)

            records.append(rec)

        chapter_records.append({
            'chapter': chapter_label,
            'qmd_file': qmd_file,
            'figures': records,
        })

    # === Generar CSV e MD ===
    write_csv(chapter_records)
    write_manifest(chapter_records, warnings)

    # === Reporte en consola ===
    mode = "AUDITORÍA (sin copiar)" if audit else "RECOLECCIÓN"
    print(f"\n✓ {mode}: {sum(len(c['figures']) for c in chapter_records)} figuras "
          f"en {len(chapter_records)} capítulos.")
    if not audit:
        print(f"  Copiadas: {total_copied}")
        print(f"  Destino:  {DEST.relative_to(ROOT)}/")
    print(f"  Inventario: {CSV_PATH.name}")
    print(f"  Manifiesto: {MD_PATH.name}")

    n_warn = sum(len(v) for v in warnings.values())
    if n_warn:
        print(f"\n  Advertencias: {n_warn}", file=sys.stderr)
        for k, v in warnings.items():
            if v:
                print(f"    {k}: {len(v)}", file=sys.stderr)
        if verbose:
            for k, items in warnings.items():
                if items:
                    print(f"\n  -- {k} --", file=sys.stderr)
                    for it in items:
                        print(f"    {it}", file=sys.stderr)
        else:
            print("  (Pasar --verbose para ver el detalle)", file=sys.stderr)


def write_csv(chapter_records):
    with CSV_PATH.open('w', encoding='utf-8', newline='') as f:
        w = csv.writer(f)
        w.writerow([
            'Capítulo', 'Archivo .qmd', '#Fig', 'Línea', 'Tipo',
            'Origen (en .qmd)', 'Ruta en figuras_editor', 'Caption'
        ])
        for ch in chapter_records:
            for r in ch['figures']:
                w.writerow([
                    ch['chapter'], ch['qmd_file'], r['pos'], r['line'],
                    r['type'], r['src_qmd'] or '', r['figura_editor'] or '',
                    (r['caption'] or '')[:240],
                ])


def write_manifest(chapter_records, warnings):
    lines = []
    lines.append("# Manifiesto de figuras — Dinámica Poblacional de Orquídeas\n")
    lines.append(
        "Inventario completo de TODAS las figuras del libro "
        "(estáticas markdown + generadas por código R), organizadas por capítulo "
        "y orden de aparición. Cada figura está enlazada con su ubicación "
        "esperada en `figuras_editor/<capítulo>/`. Este archivo —junto con la "
        "carpeta `figuras_editor/`— es la entrega para el editor/productor del libro.\n"
    )

    total_figs = sum(len(c['figures']) for c in chapter_records)
    by_type = {}
    for c in chapter_records:
        for r in c['figures']:
            by_type[r['type']] = by_type.get(r['type'], 0) + 1

    lines.append("## Resumen\n")
    lines.append(f"- **Total figuras**: {total_figs}\n")
    lines.append(f"- **Capítulos con figuras**: {len(chapter_records)}\n")
    lines.append("- **Por tipo**:\n")
    type_es = {
        'static':       'imagen markdown estática',
        'render_dual':  'PNG generado por `render_dual()` (DOT → PNG)',
        'ggsave':       'PNG generado por `ggsave()`',
        'dynamic':      'PNG generado por chunk R (ggplot, plot, etc.)',
        'widget':       'widget HTML (`plot_life_cycle`/`grViz`) sin PNG estático',
    }
    for t, n in sorted(by_type.items(), key=lambda x: -x[1]):
        lines.append(f"  - {type_es.get(t, t)}: **{n}**\n")
    lines.append("")

    lines.append("## Cómo regenerar este manifiesto\n")
    lines.append("```bash\nquarto render          # genera docs/*_files/figure-html/\n"
                 "python3 scripts/collect_figures.py  # recolecta a figuras_editor/\n```\n\n"
                 "Para auditar sin copiar: `python3 scripts/collect_figures.py --audit`\n\n")

    # Inventario por capítulo
    lines.append("## Inventario por capítulo\n")
    for ch in chapter_records:
        lines.append(f"### {ch['chapter']}\n")
        lines.append(f"Archivo fuente: `{ch['qmd_file']}` — {len(ch['figures'])} figura(s)\n")
        lines.append("| # | Línea | Tipo | Origen en .qmd | Ruta en figuras_editor/ | Caption |")
        lines.append("|---|------:|------|----------------|-------------------------|---------|")
        for r in ch['figures']:
            caption = (r['caption'] or '').replace('|', '\\|').replace('\n', ' ')[:120]
            origen = (r['src_qmd'] or '').replace('|', '\\|')
            dest = (r['figura_editor'] or '').replace('|', '\\|')
            lines.append(
                f"| {r['pos']} | {r['line']} | {r['type']} | `{origen}` | `{dest}` | {caption} |"
            )
        lines.append("")

    # Sección de advertencias / acción del editor
    if warnings.get('widgets_no_png'):
        lines.append("## Figuras tipo widget (HTML) sin PNG\n")
        lines.append("Los siguientes chunks producen un diagrama interactivo (`plot_life_cycle` o "
                     "`grViz`) que NO se exporta automáticamente como PNG. Para incluirlos en la "
                     "entrega física al editor, hay dos opciones:\n\n"
                     "1. **Recomendado**: añadir `ggsave()` después del chunk para guardar el "
                     "diagrama como PNG en `images/` (o usar el helper `render_dual()` "
                     "del cap. 2 para `grViz`).\n"
                     "2. Tomar captura de pantalla desde la versión HTML del libro y guardarla "
                     "manualmente en `figuras_editor/<capítulo>/`.\n\n")
        lines.append("| Capítulo | Línea | Función | Chunk |")
        lines.append("|----------|------:|---------|-------|")
        for (c, ch, ln, fn) in warnings['widgets_no_png']:
            lines.append(f"| {c} | {ln} | `{fn}()` | `{ch or '(sin label)'}` |")
        lines.append("")

    if warnings.get('missing_static') or warnings.get('missing_render_dual') or \
       warnings.get('missing_ggsave') or warnings.get('missing_chunks'):
        lines.append("## Archivos faltantes (corrige antes de la entrega)\n")
        for c, src, ln in warnings.get('missing_static', []):
            lines.append(f"- `{c}` línea {ln}: imagen estática `{src}` no existe en disco.")
        for c, src, ln in warnings.get('missing_render_dual', []):
            lines.append(f"- `{c}` línea {ln}: `render_dual` apunta a `{src}` — correr `quarto render`.")
        for c, src, ln in warnings.get('missing_ggsave', []):
            lines.append(f"- `{c}` línea {ln}: `ggsave` apunta a `{src}` — correr `quarto render`.")
        for c, chunk, ln in warnings.get('missing_chunks', []):
            lines.append(f"- `{c}` línea {ln}: chunk `{chunk}` declarado pero sin PNG en `docs/`.")
        lines.append("")

    MD_PATH.write_text('\n'.join(lines), encoding='utf-8')


if __name__ == '__main__':
    main()
