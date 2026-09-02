#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Traducir el rótulo «Appendix X —» a «Apéndice X —» en un .docx de Quarto.

Por qué hace falta un post-proceso y no basta la configuración:

  - `_language.yml` SÍ se aplica (se comprobó: `callout-tip-title` cambia el
    rótulo de los recuadros, y el valor por defecto en español sería «Tip»).
  - La traducción al español de Quarto 1.9.38 YA define
    `crossref-apx-prefix: "Apéndice"`, y aun así el encabezado del apéndice
    sale «Appendix A — …» en el .docx.

Es decir: ese encabezado no toma su rótulo de `crossref-apx-prefix`, que
gobierna solo las referencias cruzadas. En esta versión de Quarto la cadena
del encabezado no es localizable. Como el .docx es el archivo que recibe la
editorial, se corrige aquí.

Solo se tocan los nodos de TEXTO (`<w:t>`). Los marcadores internos
(`w:name="AppendixA"`, `w:anchor="AppendixA"`) se dejan intactos: son los
identificadores que enlazan el índice con el apéndice, y renombrarlos
rompería esos enlaces.

Uso:
    python3 scripts/fix_docx_appendix_label.py archivo.docx [más.docx ...]
"""
import re
import shutil
import sys
import zipfile

# «Appendix A — » dentro de un nodo de texto. La raya larga es la que emite
# Quarto; se acepta también guion normal por si cambiara.
PATRON = re.compile(r'(<w:t[^>]*>)Appendix (?=[A-Z]\s*[—-]\s)')


def corregir(ruta):
    with zipfile.ZipFile(ruta) as z:
        nombres = z.namelist()
        contenido = {n: z.read(n) for n in nombres}

    xml = contenido["word/document.xml"].decode("utf-8")
    nuevo, n = PATRON.subn(r"\1Apéndice ", xml)
    if n == 0:
        print(f"  {ruta}: nada que cambiar")
        return 0
    contenido["word/document.xml"] = nuevo.encode("utf-8")

    shutil.copy2(ruta, str(ruta) + ".bak")
    with zipfile.ZipFile(ruta, "w", zipfile.ZIP_DEFLATED) as z:
        for nombre in nombres:
            z.writestr(nombre, contenido[nombre])
    print(f"  {ruta}: {n} rótulo(s) traducido(s) (copia previa en .bak)")
    return n


def main(argv):
    if len(argv) < 2:
        print(__doc__)
        return 2
    total = sum(corregir(a) for a in argv[1:])
    print(f"total: {total}")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
