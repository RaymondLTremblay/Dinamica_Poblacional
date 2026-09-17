#!/usr/bin/env python3
"""
cortar_docx_por_capitulo.py: corta el Word completo del libro en un .docx por
capitulo, conservando la numeracion del libro.

Por que existe (septiembre de 2026): la editorial necesita archivos por
capitulo con la MISMA numeracion que el libro completo (secciones 10.2.1,
«Figura 10.4», «Cuadro 10.1»). render_docx_per_chapter.R renderiza cada
capitulo por separado, de modo que cada archivo empieza en 1 y lleva su propia
lista de referencias. Este script parte en cambio del Word ya compilado por
`quarto render`, donde los numeros son texto fijo y la bibliografia es una sola.

Uso (despues de `quarto render`):
    python3 scripts/cortar_docx_por_capitulo.py [ruta_al_docx] [carpeta_salida]

Ademas deja todos los capitulos en un solo Capitulos_en_Word_<fecha>.zip, junto
a la carpeta de salida.

Por defecto lee docs/Introducción-a-la-Dinámica-Poblacional-de-Orquídeas.docx
y escribe en docx_capitulos/ (la vacia antes).

Criterio de corte: cada Heading1 abre un archivo nuevo. Lo que va antes del
primer Heading1 (portada y tabla de contenidos automatica) se descarta.
Lo que no es capitulo ni apendice se nombra Preliminares_N si va antes del
primer capitulo y Final_N si va despues.
Cada archivo conserva estilos, numeracion de listas, encabezados y pies, y
solo las imagenes que usa. Los rotulos «Appendix X —» se traducen a
«Apéndice X —». Los enlaces internos a otros capitulos quedan como texto.
"""

from __future__ import annotations
import re
import shutil
import sys
import unicodedata
import zipfile
from pathlib import Path
from lxml import etree

ROOT = Path(__file__).resolve().parent.parent
W = "http://schemas.openxmlformats.org/wordprocessingml/2006/main"
R = "http://schemas.openxmlformats.org/officeDocument/2006/relationships"
PR = "http://schemas.openxmlformats.org/package/2006/relationships"
NS = {"w": W}


def slug(texto: str, n: int = 50) -> str:
    s = unicodedata.normalize("NFKD", texto).encode("ascii", "ignore").decode()
    s = re.sub(r"[^A-Za-z0-9]+", "_", s).strip("_")
    return s[:n].rstrip("_")


def nombre_archivo(titulo: str, orden_final: list) -> str:
    m = re.match(r"^(\d+)\.\s+(.*)$", titulo)
    if m:
        return f"Cap_{int(m.group(1)):02d}_{slug(m.group(2))}"
    m = re.match(r"^(?:Appendix|Apéndice)\s+([A-Z])\s*[—-]\s*(.*)$", titulo)
    if m:
        return f"Apendice_{m.group(1)}_{slug(m.group(2))}"
    orden_final.append(titulo)
    return f"Final_{len(orden_final)}_{slug(titulo)}"


def texto_parrafo(p) -> str:
    return "".join(p.itertext())


def es_h1(el) -> bool:
    if el.tag != f"{{{W}}}p":
        return False
    st = el.find("w:pPr/w:pStyle", NS)
    return st is not None and st.get(f"{{{W}}}val") == "Heading1"


def limpiar_marcadores(elems):
    """Quitar bookmarkStart/End sin pareja dentro del fragmento.

    Devuelve la lista de elementos de nivel superior sin los marcadores
    huerfanos que estaban sueltos en el cuerpo del documento.
    """
    starts, ends = {}, {}
    for e in elems:
        for b in e.iter(f"{{{W}}}bookmarkStart"):
            starts[b.get(f"{{{W}}}id")] = b
        for b in e.iter(f"{{{W}}}bookmarkEnd"):
            ends[b.get(f"{{{W}}}id")] = b
    quitar = [b for i, b in starts.items() if i not in ends] + \
             [b for i, b in ends.items() if i not in starts]
    sueltos = set()
    for b in quitar:
        padre = b.getparent()
        if padre is None:
            sueltos.add(id(b))
        else:
            padre.remove(b)
    return [e for e in elems if id(e) not in sueltos]


def main():
    src = Path(sys.argv[1]) if len(sys.argv) > 1 else \
        ROOT / "docs" / "Introducción-a-la-Dinámica-Poblacional-de-Orquídeas.docx"
    out_dir = Path(sys.argv[2]) if len(sys.argv) > 2 else ROOT / "docx_capitulos"
    out_dir.mkdir(parents=True, exist_ok=True)
    for viejo in out_dir.glob("*.docx"):   # no dejar archivos de un corte anterior
        try:
            viejo.unlink()
        except OSError:
            print(f"AVISO: no se pudo borrar {viejo.name}; se sobrescribe si coincide el nombre")

    zin = zipfile.ZipFile(src)
    doc_xml = zin.read("word/document.xml")
    rels_xml = zin.read("word/_rels/document.xml.rels")

    # Medios usados por otras partes (encabezados, pies): nunca se quitan.
    medios_fijos = set()
    for n in zin.namelist():
        if n.endswith(".rels") and n != "word/_rels/document.xml.rels":
            for t in re.findall(rb'Target="([^"]+)"', zin.read(n)):
                medios_fijos.add(Path("word", t.decode()).as_posix())

    arbol = etree.fromstring(doc_xml)
    body = arbol.find("w:body", NS)
    hijos = list(body)
    sect_final = hijos[-1] if hijos[-1].tag == f"{{{W}}}sectPr" else None
    if sect_final is not None:
        hijos = hijos[:-1]

    # Segmentos: (titulo, [elementos])
    segmentos = []
    for el in hijos:
        if es_h1(el):
            titulo = texto_parrafo(el).strip()
            segmentos.append((titulo, [el]))
        elif segmentos:
            segmentos[-1][1].append(el)

    rels = etree.fromstring(rels_xml)
    orden_final, preliminares = [], 0
    visto_capitulo = False
    for titulo, elems in segmentos:
        es_capitulo = re.match(r"^(\d+\.|Appendix |Apéndice )", titulo)
        if es_capitulo:
            visto_capitulo = True
        if not es_capitulo and not visto_capitulo:
            preliminares += 1
            base = f"Preliminares_{preliminares}_{slug(titulo)}"
        else:
            base = nombre_archivo(titulo, orden_final)

        # documento con solo este fragmento
        nuevo = etree.fromstring(doc_xml)
        nbody = nuevo.find("w:body", NS)
        for c in list(nbody):
            nbody.remove(c)
        copias = [etree.fromstring(etree.tostring(e)) for e in elems]
        copias = limpiar_marcadores(copias)
        for c in copias:
            nbody.append(c)
        if sect_final is not None:
            nbody.append(etree.fromstring(etree.tostring(sect_final)))
        xml = etree.tostring(nuevo, xml_declaration=True, encoding="UTF-8", standalone=True)
        xml = re.sub(rb'(<w:t[^>]*>)Appendix (?=[A-Z]\s*(?:\xe2\x80\x94|-)\s)',
                     "\\1Apéndice ".encode(), xml)

        # relaciones: quitar imagenes y enlaces que el fragmento no usa
        usados = set(re.findall(rb'r:(?:embed|id|link|pict)="([^"]+)"', xml))
        nrels = etree.fromstring(rels_xml)
        medios = set()
        for rel in list(nrels):
            tipo = rel.get("Type", "")
            rid = rel.get("Id").encode()
            if (tipo.endswith("/image") or tipo.endswith("/hyperlink")) and rid not in usados:
                nrels.remove(rel)
            elif tipo.endswith("/image") and rel.get("TargetMode") != "External":
                medios.add(Path("word", rel.get("Target")).as_posix())

        destino = out_dir / f"{base}.docx"
        with zipfile.ZipFile(destino, "w", zipfile.ZIP_DEFLATED) as zout:
            for original in zin.infolist():
                n = original.filename
                # ZipInfo nuevo: writestr() modifica el ZipInfo que recibe
                # (header_offset), y reusar el del archivo de entrada corrompe
                # las lecturas siguientes de ese mismo archivo.
                info = zipfile.ZipInfo(n, date_time=original.date_time)
                info.compress_type = zipfile.ZIP_DEFLATED
                if n == "word/document.xml":
                    zout.writestr(info, xml)
                elif n == "word/_rels/document.xml.rels":
                    zout.writestr(info, etree.tostring(nrels, xml_declaration=True,
                                                       encoding="UTF-8", standalone=True))
                elif n.startswith("word/media/") and n not in medios and n not in medios_fijos:
                    continue
                else:
                    zout.writestr(info, zin.read(n))
        print(f"{destino.name:70s} {destino.stat().st_size/1e6:6.1f} MB")

    # Un solo .zip con todos los capitulos, para enviar sin adjuntar 30 archivos.
    # Los .docx ya van comprimidos, asi que se guardan sin volver a comprimir.
    import datetime
    paquete = out_dir.parent / f"Capitulos_en_Word_{datetime.date.today():%Y-%m-%d}.zip"
    with zipfile.ZipFile(paquete, "w", zipfile.ZIP_STORED) as zz:
        for f in sorted(out_dir.glob("*.docx")):
            zz.write(f, f"Capitulos_en_Word/{f.name}")
    print(f"\nZip: {paquete.name} ({paquete.stat().st_size/1e6:.0f} MB)")

    print(f"\n{len(segmentos)} archivos en {out_dir.relative_to(ROOT) if out_dir.is_relative_to(ROOT) else out_dir}")


if __name__ == "__main__":
    main()
