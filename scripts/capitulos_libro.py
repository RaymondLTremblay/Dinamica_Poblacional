#!/usr/bin/env python3
"""
capitulos_libro.py: numeracion de capitulos y apendices leida de _quarto.yml.

La usan build_index_fig_tab.py y build_topic_index.py. Antes cada script
llevaba su propia lista escrita a mano, y las dos se desfasaron del libro
cada vez que cambio el orden de los capitulos.

Criterio de numeracion (decision editorial de septiembre de 2026):
  - Los preliminares (dedicatoria, indice de figuras, prologos, agradecimientos,
    prefacio) NO llevan numero: su primer H1 es .unnumbered. Un archivo de
    `chapters:` se numera solo si su primer H1 no lo es. 102-Intro.qmd es el 1.
  - Los capitulos se numeran en el orden de `book: chapters:` de _quarto.yml,
    incluidos los de la parte «Historia», que van al final.
  - Los apendices Appendix_A/B/C llevan su letra. El resto de `appendices:`
    (glosario, indices, agradecimientos) no lleva numero ni letra.

No depende de PyYAML: lee las lineas «- archivo.qmd» del bloque `book:`.
"""

from __future__ import annotations
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent



def h1_crudo(qmd: Path) -> str:
    """Linea del primer H1 fuera del YAML y de los bloques de codigo."""
    en_yaml = en_bloque = False
    for i, linea in enumerate(qmd.read_text(encoding="utf-8").splitlines()):
        s = linea.strip()
        if i == 0 and s == "---":
            en_yaml = True
            continue
        if en_yaml:
            if s == "---":
                en_yaml = False
            continue
        if s.startswith("```"):
            en_bloque = not en_bloque
            continue
        if not en_bloque and linea.startswith("# "):
            return linea
    return ""


def titulo_h1(qmd: Path) -> str:
    """Primer encabezado de nivel 1 fuera del YAML y de los bloques de codigo."""
    en_yaml = en_bloque = False
    for i, linea in enumerate(qmd.read_text(encoding="utf-8").splitlines()):
        s = linea.strip()
        if i == 0 and s == "---":
            en_yaml = True
            continue
        if en_yaml:
            if s == "---":
                en_yaml = False
            continue
        if s.startswith("```"):
            en_bloque = not en_bloque
            continue
        if not en_bloque and linea.startswith("# "):
            return re.sub(r"\s*\{[^}]*\}\s*$", "", linea[2:]).strip()
    return qmd.stem


def capitulos():
    """Lista de (archivo, etiqueta, titulo) en orden del libro.

    etiqueta es "1", "2", ... para capitulos y "A", "B", "C" para apendices.
    """
    texto = (ROOT / "_quarto.yml").read_text(encoding="utf-8")
    en_book = False
    seccion = None
    caps, apes = [], []
    for linea in texto.splitlines():
        if re.match(r"^book:", linea):
            en_book = True
            continue
        if en_book and re.match(r"^\S", linea):
            break
        if not en_book:
            continue
        if re.match(r"^\s+chapters:", linea) and seccion is None:
            seccion = "caps"
        elif re.match(r"^\s+appendices:", linea):
            seccion = "apes"
        m = re.match(r"^\s*-\s+([\w.\-]+\.qmd)\s*$", linea)
        if m and seccion:
            (caps if seccion == "caps" else apes).append(m.group(1))

    salida = []
    n = 0
    for f in caps:
        if "unnumbered" in h1_crudo(ROOT / f):
            continue
        n += 1
        salida.append((f, str(n), titulo_h1(ROOT / f)))
    for f in apes:
        m = re.match(r"Appendix_([A-Z])_", f)
        if m:
            salida.append((f, m.group(1), titulo_h1(ROOT / f)))
    return salida


if __name__ == "__main__":
    for f, et, t in capitulos():
        print(f"{et:>3}  {f:45s} {t}")
