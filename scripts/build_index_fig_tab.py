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
# Capitulos en el orden del libro: (archivo, numero de capitulo, nombre).
# El numero es el que Quarto asigna realmente y el que aparece en "Figura X.Y".
# `index.qmd` es el capitulo 1 (lleva `title:` en su YAML) y la parte
# "Historia" va al final, de modo que 117 y 118 son los capitulos 21 y 22.
# Los apendices no llevan numero de capitulo: se identifican por su letra.
CHAPTERS = [
    ("102-Intro.qmd",                           "2",  "Introducción"),
    ("103-Ciclos_de_Vida.qmd",                  "3",  "Ciclos de Vida"),
    ("104-Recopilacion_datos_en_el_campo.qmd",  "4",  "Recopilación de datos en el campo"),
    ("105-Transiciones.qmd",                    "5",  "Transiciones"),
    ("106-calcular_fecundidad.qmd",             "6",  "Fecundidad"),
    ("107-matU_matF_matC.qmd",                  "7",  "Matrices U, F y C"),
    ("108-Bayesian_PPM.qmd",                    "8",  "Acercamiento bayesiano"),
    ("109-Crecimiento_poblacional.qmd",         "9",  "Crecimiento poblacional"),
    ("110-Propriedades.qmd",                    "10", "Propiedades de la matriz"),
    ("111-Elasticidad.qmd",                     "11", "Elasticidad y sensibilidad"),
    ("112-Dinamica_de_Transiciones.qmd",        "12", "Dinámica transitoria"),
    ("113-Funciones_de_Transferencia.qmd",      "13", "Funciones de transferencia"),
    ("114-LTRE.qmd",                            "14", "LTRE"),
    ("115-Metodos_de_simulaciones.qmd",         "15", "Métodos de simulaciones"),
    ("119-COMPADRE_ORCHIDS.qmd",                "16", "COMPADRE"),
    ("120-Rage_orquideas.qmd",                  "17", "Rage"),
    ("121-Traduccion_protocolo_informacion.qmd","18", "Protocolo estándar"),
    ("122-Impacto_de_Datos_sin_Sentido.qmd",    "19", "Datos sin sentido biológico"),
    ("123-Conclusion.qmd",                      "20", "Conclusión"),
    ("117_Historia_breve.qmd",                  "21", "Historia breve de MPP en orquídeas"),
    ("118-Carl_Olaf_Tamm.qmd",                  "22", "Carl Olof Tamm"),
    ("Appendix_A_Species_List.qmd",             "A",  "Apéndice A: Lista de especies"),
    ("Appendix_B_Hoja_de_datos.qmd",            "B",  "Apéndice B: Hoja de datos"),
]

# Llamadas que producen realmente una figura. Sirven para descartar los
# bloques de configuracion que llevan `fig-cap` y etiqueta `fig-` heredadas
# de una migracion anterior pero no dibujan nada: sin este filtro el indice
# contaba una decena de figuras inexistentes.
FIGURE_CALLS = (
    "ggplot(", "plot(", "barplot(", "hist(", "boxplot(", "image(",
    "contour(", "persp(", "pairs(", "matplot(", "curve(", "autoplot(",
    "ggarrange(", "grid.arrange(", "plot_grid(", "stage.vector.plot(",
    "image.plot(", "plot_life_cycle(", "grViz(", "render_dual(",
    "plc_save(", "grviz_save(", "save_plot_png(", "ggsave(",
    "include_graphics(",
)

# Patrón para imágenes markdown: ![caption](path){attrs}
# El pie puede contener corchetes (citas [@clave]); se acepta un nivel de
# anidamiento en lugar de cortar en el primer ']'.
IMG_PATTERN = re.compile(r'!\[((?:[^\[\]]|\[[^\[\]]*\])*)\]\(([^)]+)\)')

# Captions de tablas explícitas
TBL_CAP_PATTERN = re.compile(
    r'^\s*#\|\s*tbl-cap\s*:\s*(?:"([^"]+)"|\'([^\']+)\')')
TABLA_REF_PATTERN = re.compile(r'^(?:Tabla|Cuadro)\s+(\d+(?:\.\d+)?)\.\s+(.+)$')

# Caption y etiqueta de chunk
FIG_CAP_PATTERN = re.compile(
    r'^\s*#\|\s*fig-cap\s*:\s*(?:"([^"]+)"|\'([^\']+)\')')

# Pie de tabla en markdown, debajo de la tabla:  ": Texto. {#tbl-id}"
TBL_MD_PATTERN = re.compile(r'^:\s+(.+?)\s*\{#tbl-[\w:.-]+\}\s*$')

# Guardia: el estilo antiguo de knitr pone el pie en la CABECERA del bloque,
# ```{r etiqueta, echo=FALSE, fig.cap="..."}, no en una linea #|. Ese estilo es
# invisible para FIG_CAP_PATTERN, de modo que las figuras asi escritas
# desaparecian del indice y, peor, corrian la numeracion de las que si
# aparecian. Paso justamente en el capitulo 22 (tres figuras de Tamm).
# Los bloques se convirtieron al estilo #|, y este patron queda para AVISAR
# si alguien vuelve a introducir uno.
FIG_CAP_ANTIGUO = re.compile(r'^\s*```\{r[^}]*\bfig\.cap\s*=')
LABEL_PATTERN = re.compile(r'^\s*#\|\s*label\s*:\s*(\S+)')

# Excepciones verificadas contra el libro renderizado (docs/*.html). Para
# comprobarlas, comparar el numero de figuras que lista este indice con el
# ultimo "Figura X.Y" de cada capitulo en su .html.
#
# Bloques que llevan `fig-cap` y etiqueta `fig-` pero no muestran ninguna
# figura: solo cargan paquetes o guardan un PNG a disco con save_plot_png(),
# cuya salida no se imprime. La figura visible es la imagen estatica que
# viene despues.
BLOQUES_SIN_FIGURA = {
    "fig-cv11_rage_build",   # cap. 3: guarda figs/CV11_Rage_plot.png, se muestra en {#fig-cv11}
    "fig-proto-setup",       # cap. 18: carga de paquetes
}

# Bloques que dibujan mas de una figura bajo un mismo `fig-cap`, y que Quarto
# numera por separado.
BLOQUES_MULTIPLES = {
    "fig-sin_sentido_11": 2,  # cap. 19: plc_save() y despues plot(pr)
}


def etiqueta_fig(chap: str, n: int) -> str:
    """Etiqueta tal como la imprime Quarto: "3.1" en capitulos, "A.1" en apendices.

    Historia de este detalle: mientras los apendices vivian dentro de una
    `part` de _quarto.yml heredaban el numero del ultimo capitulo, y el
    Apendice A imprimia "Figura 22.1" y "22.2", los mismos numeros que las dos
    primeras figuras del capitulo de Tamm. Se declararon como `appendices:`,
    y desde entonces Quarto los numera A, B, C y sus figuras A.1, A.2.
    """
    return f"{chap}.{n}"


def short(s: str, n: int = 100) -> str:
    """Acortar el pie conservando la cursiva de los binomios latinos.

    Antes se hacia re.sub(r'[*_`]+', '', s), lo que dejaba los 55 nombres de
    especie en redonda dentro del indice mientras los pies que copia los
    llevan en cursiva. Ahora se conserva el marcado y solo se recorta,
    cuidando de no cortar por la mitad un par de asteriscos.
    """
    s = re.sub(r'\s+', ' ', s).strip()
    if len(s) > n:
        s = s[:n].rsplit(' ', 1)[0]
        # cerrar cursivas o codigo que hayan quedado abiertos por el recorte
        for marca in ('**', '*', '`'):
            if s.count(marca.replace('*', '\\*')) if False else False:
                pass
        if s.count('`') % 2: s += '`'
        if (s.count('*') - 2 * s.count('**')) % 2: s += '*'
        if s.count('**') % 2: s += '**'
        s += '…'
    return s



def codigo_efectivo(texto):
    """Quitar cadenas y comentarios de R antes de buscar llamadas.

    Sin esto, un comentario como `# plc_save(), grviz_save()` en un bloque de
    carga de paquetes hacia que ese bloque contara como figura.
    """
    limpio = []
    for linea in texto.split('\n'):
        if linea.lstrip().startswith('#|'):
            continue
        fuera, comilla, escape = [], None, False
        for ch in linea:
            if escape:
                escape = False
                continue
            if ch == '\\':
                escape = True
                continue
            if comilla:
                if ch == comilla:
                    comilla = None
                continue
            if ch in '"\'':
                comilla = ch
                continue
            if ch == '#':
                break
            fuera.append(ch)
        limpio.append(''.join(fuera))
    return '\n'.join(limpio)



def parse_chapter(qmd_path):
    """Devolver (figuras, tablas) del .qmd, en orden de aparicion.

    Un bloque de codigo solo cuenta como figura si ademas de `fig-cap`
    contiene alguna llamada que dibuje algo (ver FIGURE_CALLS). Los bloques
    de configuracion que arrastran un `fig-cap` sin producir figura quedan
    fuera, que es lo que descuadraba el total del indice.
    """
    if not qmd_path.exists():
        return [], []
    lines = qmd_path.read_text(encoding='utf-8').splitlines()
    figs = []
    tbls = []
    fig_n = 0
    tbl_n = 0

    in_chunk = False
    cuerpo = []
    etiqueta = None
    fig_cap = None
    tbl_cap = None
    chunk_line = 0

    for i, line in enumerate(lines, 1):
        s = line.strip()

        if not in_chunk and (s.startswith('```{r') or s.startswith('```{python')):
            if FIG_CAP_ANTIGUO.match(line):
                raise SystemExit(
                    f"\nERROR en {ruta}:{i}\n"
                    "  Este bloque usa el estilo antiguo fig.cap= en la cabecera.\n"
                    "  El indice no lo ve, y su figura queda fuera y corre la\n"
                    "  numeracion de las demas del capitulo.\n"
                    "  Conviertalo a lineas #| label: y #| fig-cap: antes de seguir.\n"
                )
            in_chunk = True
            cuerpo, fig_cap, tbl_cap, chunk_line = [], None, None, i
            etiqueta = None
            continue

        if in_chunk and s == '```':
            in_chunk = False
            texto = '\n'.join(cuerpo)
            if tbl_cap:
                tbl_n += 1
                tbls.append({'n': tbl_n, 'line': chunk_line, 'caption': tbl_cap})
            if fig_cap and etiqueta not in BLOQUES_SIN_FIGURA and \
                    any(c in codigo_efectivo(texto) for c in FIGURE_CALLS):
                for _ in range(BLOQUES_MULTIPLES.get(etiqueta, 1)):
                    fig_n += 1
                    figs.append({'n': fig_n, 'line': chunk_line,
                                 'caption': fig_cap})
            continue

        if in_chunk:
            cuerpo.append(line)
            m = TBL_CAP_PATTERN.match(line)
            if m:
                tbl_cap = m.group(1) or m.group(2)   # comillas dobles o simples
                continue
            m = FIG_CAP_PATTERN.match(line)
            if m:
                fig_cap = m.group(1) or m.group(2)   # comillas dobles o simples
                continue
            m = LABEL_PATTERN.match(line)
            if m:
                etiqueta = m.group(1)
            continue

        # Fuera de bloque: imagenes markdown con pie
        for m in IMG_PATTERN.finditer(line):
            caption = m.group(1).strip()
            if not caption:
                continue
            fig_n += 1
            figs.append({'n': fig_n, 'line': i, 'caption': caption})
        # Pie de tabla markdown debajo de la tabla: ": Texto. {#tbl-id}"
        m = TBL_MD_PATTERN.match(line.rstrip())
        if m:
            tbl_n += 1
            tbls.append({'n': tbl_n, 'line': i, 'caption': m.group(1).strip()})
            continue
        # Tablas con pie en prosa ("Tabla 1. Matriz de ...")
        m = TABLA_REF_PATTERN.match(line)
        if m and i > 5:
            tbl_n += 1
            tbls.append({'n': tbl_n, 'line': i, 'caption': m.group(2).strip()})

    return figs, tbls


def main():
    total_figs = 0
    total_tbls = 0
    chapter_data = []

    for qmd_file, chap, label in CHAPTERS:
        figs, tbls = parse_chapter(ROOT / qmd_file)
        if figs or tbls:
            chapter_data.append((qmd_file, chap, label, figs, tbls))
            total_figs += len(figs)
            total_tbls += len(tbls)

    # Write the appendix
    out = []
    desc = (f'Índice de figuras y tablas del libro: {total_figs} figuras y '
            f'{total_tbls} tablas con leyenda, organizadas por capítulo y '
            f'enlazadas a su lugar de aparición.')
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
               "por capítulo y orden de aparición. Cada figura se identifica "
               "con el número que lleva en el texto, «Figura X.Y», donde X es "
               "el capítulo e Y la posición dentro de él. Clic en el enlace "
               "del capítulo para navegar a su contenido.\n\n")
    out.append(f"**Total:** {total_figs} figuras y {total_tbls} tablas con "
               f"caption explícito en {len(chapter_data)} capítulos.\n\n")
    out.append("> *Las tablas markdown simples sin caption (e.g., listas de "
               "referencias, comparaciones tabulares cortas) no se incluyen en "
               "este índice. Las figuras generadas dinámicamente por código R "
               "que no tienen `fig-cap` explícito tampoco aparecen — se las "
               "puede ubicar en el manifiesto de figuras para el productor (`Figuras_Manifiesto.md`).*\n\n")
    out.append("------------------------------------------------------------------------\n\n")
    out.append("## Figuras\n\n")
    for qmd_file, chap, label, figs, _ in chapter_data:
        if not figs:
            continue
        # Enlazar al .qmd: Quarto reescribe la extension segun el formato.
        # Emitir .html dejaba enlaces muertos en el PDF y el .docx.
        html_link = qmd_file
        out.append(f"### [{label}]({html_link})\n\n")
        for f in figs:
            out.append(f"- **Figura {etiqueta_fig(chap, f['n'])}** — {short(f['caption'])}\n")
        out.append("\n")

    out.append("------------------------------------------------------------------------\n\n")
    out.append("## Tablas\n\n")
    has_any_table = any(tbls for _, _, _, _, tbls in chapter_data)
    if not has_any_table:
        out.append("*No se detectaron tablas con caption explícito en los capítulos analizados.*\n\n")
    else:
        for qmd_file, chap, label, _, tbls in chapter_data:
            if not tbls:
                continue
            html_link = qmd_file
            out.append(f"### [{label}]({html_link})\n\n")
            for t in tbls:
                out.append(f"- **Tabla {etiqueta_fig(chap, t['n'])}** — {short(t['caption'])}\n")
            out.append("\n")

    OUT.write_text(''.join(out), encoding='utf-8')
    print(f"✓ Índice generado: {OUT.relative_to(ROOT)}")
    print(f"  Figuras catalogadas: {total_figs}")
    print(f"  Tablas catalogadas: {total_tbls}")
    print(f"  Capítulos con figuras/tablas: {len(chapter_data)}")


if __name__ == '__main__':
    main()
