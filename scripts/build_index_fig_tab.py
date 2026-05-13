#!/usr/bin/env python3
"""
build_index_fig_tab.py — genera el apéndice "Índice de figuras y
tablas" para el libro Dinámica Poblacional de Orquídeas.

Recorre los .qmd en el orden del libro, extrae:
  - Figuras (markdown images con caption, render_dual con destino conocido).
  - Tablas con caption explícito (tbl-cap, Tabla N., Cuadro N.).
y produce Apendice_Indice_Fig_Tab.qmd.

Uso:
    python3 scripts/build_index_fig_tab.py
"""

from __future__ import annotations
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "Apendice_Indice_Fig_Tab.qmd"

# Capítulos en el orden del libro, con nombre legible
CHAPTERS = [
    ("102-Intro.qmd",                          "Introducción"),
    ("103-Ciclos_de_Vida.qmd",                 "Ciclos de Vida"),
    ("104-Recopilacion_datos_en_el_campo.qmd", "Recopilación de datos en el campo"),
    ("105-Transiciones.qmd",                   "Transiciones"),
    ("106-calcular_fecundidad.qmd",            "Fecundidad"),
    ("107-matU_matF_matC.qmd",                 "Matrices U, F y C"),
    ("108-Bayesian_PPM.qmd",                   "Acercamiento bayesiano"),
    ("109-Crecimiento_poblacional.qmd",        "Crecimiento poblacional"),
    ("110-Propriedades.qmd",                   "Propiedades de la matriz"),
    ("111-Elasticidad.qmd",                    "Elasticidad y sensibilidad"),
    ("112-Dinamica_de_Transiciones.qmd",       "Dinámica transitoria"),
    ("113-Funciones_de_Transferencia.qmd",     "Funciones de transferencia"),
    ("114-LTRE.qmd",                           "LTRE"),
    ("115-Metodos_de_simulaciones.qmd",        "Métodos de simulaciones"),
    ("117_Historia_breve.qmd",                 "Historia breve de MPP en orquídeas"),
    ("118-Carl_Olaf_Tamm.qmd",                 "Carl Olaf Tamm"),
    ("119-COMPADRE_ORCHIDS.qmd",               "COMPADRE"),
    ("120-Rage_orquideas.qmd",                 "Rage"),
    ("121-Traduccion_protocolo_informacion.qmd","Protocolo estándar"),
    ("122-Impacto_de_Datos_sin_Sentido.qmd",   "Datos sin sentido biológico"),
    ("123-Conclusion.qmd",                     "Conclusión"),
    ("Appendix_A_Species_List.qmd",            "Apéndice A: Lista de especies"),
    ("Appendix_B_Hoja_de_datos.qmd",           "Apéndice B: Hoja de datos"),
]

# Patrón para imágenes markdown: ![caption](path){attrs}
IMG_PATTERN = re.compile(r'!\[([^\]]*)\]\(([^)]+)\)')

# Captions de tablas explícitas
TBL_CAP_PATTERN = re.compile(r'^\s*#\|\s*tbl-cap\s*:\s*"([^"]+)"')
TABLA_REF_PATTERN = re.compile(r'^(?:Tabla|Cuadro)\s+(\d+(?:\.\d+)?)\.\s+(.+)$')

# Caption de chunk
FIG_CAP_PATTERN = re.compile(r'^\s*#\|\s*fig-cap\s*:\s*"([^"]+)"')


def short(s: str, n: int = 100) -> str:
    """Acortar string colapsando markdown y limitando longitud."""
    # quitar formato markdown básico
    s = re.sub(r'[*_`]+', '', s)
    s = re.sub(r'\s+', ' ', s).strip()
    if len(s) > n:
        s = s[:n].rsplit(' ', 1)[0] + '…'
    return s


def parse_chapter(qmd_path: Path):
    """Devolver (figuras, tablas) del .qmd, en orden de aparición."""
    if not qmd_path.exists():
        return [], []
    lines = qmd_path.read_text(encoding='utf-8').splitlines()
    figs = []
    tbls = []
    fig_n = 0
    tbl_n = 0
    in_chunk = False

    for i, line in enumerate(lines, 1):
        s = line.strip()

        # Track chunks (we want to look inside for tbl-cap / fig-cap)
        if s.startswith('```{r') or s.startswith('```{python'):
            in_chunk = True
            continue
        if s == '```' and in_chunk:
            in_chunk = False
            continue

        if in_chunk:
            # tbl-cap chunk option
            m = TBL_CAP_PATTERN.match(line)
            if m:
                tbl_n += 1
                tbls.append({'n': tbl_n, 'line': i, 'caption': m.group(1)})
                continue
            # fig-cap chunk option
            m = FIG_CAP_PATTERN.match(line)
            if m:
                fig_n += 1
                figs.append({'n': fig_n, 'line': i, 'caption': m.group(1)})
                continue
        else:
            # Markdown image (figures with caption)
            for m in IMG_PATTERN.finditer(line):
                caption = m.group(1).strip()
                if not caption:
                    continue   # skip uncaptioned images
                fig_n += 1
                figs.append({'n': fig_n, 'line': i, 'caption': caption})
            # Captioned tables in prose (e.g., "Tabla 1. Matriz de …")
            m = TABLA_REF_PATTERN.match(line)
            if m and i > 5:  # skip yaml/headers
                tbl_n += 1
                tbls.append({'n': tbl_n, 'line': i,
                             'caption': m.group(2).strip()})
    return figs, tbls


def main():
    total_figs = 0
    total_tbls = 0
    chapter_data = []

    for qmd_file, label in CHAPTERS:
        figs, tbls = parse_chapter(ROOT / qmd_file)
        if figs or tbls:
            chapter_data.append((qmd_file, label, figs, tbls))
            total_figs += len(figs)
            total_tbls += len(tbls)

    # Write the appendix
    out = []
    desc = 'Índice de figuras y tablas del libro: 52 figuras y 7 tablas con leyenda, organizadas por capítulo y enlazadas a su lugar de aparición.'
    out.append('---\n')
    out.append(f'description: "{desc}"\n')
    out.append('image: "images/Lepanthes_eltoroensis_Tremblay.jpeg"\n')
    out.append('open-graph:\n')
    out.append(f'  description: "{desc}"\n')
    out.append('twitter-card:\n')
    out.append(f'  description: "{desc}"\n')
    out.append('---\n\n')
    out.append("# Índice de figuras y tablas {#IndiceFigTab .unnumbered}\n\n")
    out.append("Listado de todas las figuras y tablas del libro, organizadas "
               "por capítulo y orden de aparición. La numeración es relativa "
               "a cada capítulo. Clic en el enlace del capítulo para navegar a su contenido.\n\n")
    out.append(f"**Total:** {total_figs} figuras y {total_tbls} tablas con "
               f"caption explícito en {len(chapter_data)} capítulos.\n\n")
    out.append("> *Las tablas markdown simples sin caption (e.g., listas de "
               "referencias, comparaciones tabulares cortas) no se incluyen en "
               "este índice. Las figuras generadas dinámicamente por código R "
               "que no tienen `fig-cap` explícito tampoco aparecen — se las "
               "puede ubicar en el manifiesto de figuras para el productor (`Figuras_Manifiesto.md`).*\n\n")
    out.append("------------------------------------------------------------------------\n\n")
    out.append("## Figuras\n\n")
    for qmd_file, label, figs, _ in chapter_data:
        if not figs:
            continue
        # Use Quarto cross-reference for HTML link
        html_link = qmd_file.replace('.qmd', '.html')
        out.append(f"### [{label}]({html_link})\n\n")
        for f in figs:
            out.append(f"- **Fig. {f['n']}** — {short(f['caption'])}\n")
        out.append("\n")

    out.append("------------------------------------------------------------------------\n\n")
    out.append("## Tablas\n\n")
    has_any_table = any(tbls for _, _, _, tbls in chapter_data)
    if not has_any_table:
        out.append("*No se detectaron tablas con caption explícito en los capítulos analizados.*\n\n")
    else:
        for qmd_file, label, _, tbls in chapter_data:
            if not tbls:
                continue
            html_link = qmd_file.replace('.qmd', '.html')
            out.append(f"### [{label}]({html_link})\n\n")
            for t in tbls:
                out.append(f"- **Tabla {t['n']}** — {short(t['caption'])}\n")
            out.append("\n")

    OUT.write_text(''.join(out), encoding='utf-8')
    print(f"✓ Índice generado: {OUT.relative_to(ROOT)}")
    print(f"  Figuras catalogadas: {total_figs}")
    print(f"  Tablas catalogadas: {total_tbls}")
    print(f"  Capítulos con figuras/tablas: {len(chapter_data)}")


if __name__ == '__main__':
    main()
