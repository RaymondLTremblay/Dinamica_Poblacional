#!/usr/bin/env python3
# renumerar_entrega_figuras.py
# ============================
# Script de UN SOLO USO (septiembre 2026).
#
# Reorganiza la entrega ya generada en `figuras_editor/` para que los numeros
# de carpeta y los prefijos `Fig_X.Y` coincidan con la numeracion real de
# capitulos del libro. Corrige la entrega de julio de 2026, en la que:
#
#   - las carpetas 1 a 14 iban un numero por debajo del capitulo real,
#   - las carpetas 15 y 16 eran en realidad los capitulos 21 y 22,
#   - las carpetas 18, 19 y 20 eran los capitulos 17, 18 y 19,
#   - la carpeta 17 no existia (el cap. 16, COMPADRE, no tiene figuras).
#
# La causa estaba en la lista `CHAPTERS` de `scripts/collect_figures.R`, que
# seguia el orden alfabetico de los .qmd y no el orden de `_quarto.yml`. Esa
# lista ya esta corregida, de modo que cualquier `quarto render` futuro produce
# la numeracion correcta directamente y este script deja de hacer falta.
#
# Se usa aqui porque permite corregir la entrega existente sin volver a
# renderizar el libro completo. El contenido de cada carpeta no cambia: solo
# cambian el numero de capitulo, los nombres de archivo y las rutas en
# `Figuras_Inventario.csv` y `Figuras_Manifiesto.md`.
#
# Uso, desde la raiz del proyecto:
#   python3 scripts/renumerar_entrega_figuras.py [--dry]

import csv
import os
import re
import sys

DRY = "--dry" in sys.argv
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, "figuras_editor")

# carpeta actual -> (numero de capitulo real, carpeta nueva)
MAPA = {
    "01-Introduccion":                   (2,  "02-Introduccion"),
    "02-Ciclos_de_Vida":                 (3,  "03-Ciclos_de_Vida"),
    "03-Recopilacion_datos_en_el_campo": (4,  "04-Recopilacion_datos_en_el_campo"),
    "04-Transiciones":                   (5,  "05-Transiciones"),
    "05-Fecundidad":                     (6,  "06-Fecundidad"),
    "06-matU_matF_matC":                 (7,  "07-matU_matF_matC"),
    "07-Bayesian_PPM":                   (8,  "08-Bayesian_PPM"),
    "08-Crecimiento_poblacional":        (9,  "09-Crecimiento_poblacional"),
    "09-Propiedades":                    (10, "10-Propiedades"),
    "10-Elasticidad":                    (11, "11-Elasticidad"),
    "11-Dinamica_transitoria":           (12, "12-Dinamica_transitoria"),
    "12-Funciones_de_Transferencia":     (13, "13-Funciones_de_Transferencia"),
    "13-LTRE":                           (14, "14-LTRE"),
    "14-Metodos_de_simulaciones":        (15, "15-Metodos_de_simulaciones"),
    "18-Rage":                           (17, "17-Rage"),
    "19-Protocolo":                      (18, "18-Protocolo"),
    "20-Datos_sin_sentido":              (19, "19-Datos_sin_sentido"),
    "15-Historia_breve":                 (21, "21-Historia_breve"),
    "16-Carl_Olaf_Tamm":                 (22, "22-Carl_Olof_Tamm"),
    "ApA-Lista_especies":                (None, "ApA-Lista_especies"),
}

# capitulos y apendices sin ninguna figura: la carpeta se entrega vacia, con
# una nota, para que la secuencia no tenga huecos.
VACIOS = [
    ("01-Preliminares",    "Portada, dedicatoria y prefacio"),
    ("16-COMPADRE",        "COMPADRE y las orquideas"),
    ("20-Conclusion",      "Conclusion"),
    ("ApB-Hoja_de_datos",  "Apendice B: hoja de datos"),
    ("ApC-Datos",          "Apendice C: datos"),
    ("23-Agradecimientos", "Agradecimientos"),
]

# orden final de las carpetas, tal como aparecen en el libro
ORDEN = [n for _, n in sorted(
    [(v[0] if v[0] is not None else 22.5, v[1]) for v in MAPA.values()]
    + [(1, "01-Preliminares"), (16, "16-COMPADRE"), (20, "20-Conclusion"),
       (22.6, "ApB-Hoja_de_datos"), (22.7, "ApC-Datos"), (23, "23-Agradecimientos")]
)]


def old_num(folder):
    m = re.match(r"^(\d+)-", folder)
    return int(m.group(1)) if m else None


def renombrar_archivo(nombre, nuevo_num):
    """Fig_<viejo>.<Y>_resto -> Fig_<nuevo>.<Y>_resto"""
    if nuevo_num is None:
        return nombre
    return re.sub(r"^Fig_\d+\.(\d+)_", r"Fig_%d.\1_" % nuevo_num, nombre)


def mover_carpetas():
    """Renombra en el sitio, en dos fases para evitar colisiones.

    Solo se usan renombrados (nunca borrados): las carpetas montadas desde el
    equipo del autor no permiten eliminar archivos.
    """
    fase1 = []
    for viejo, (num, nuevo) in MAPA.items():
        origen = os.path.join(SRC, viejo)
        if not os.path.isdir(origen):
            print("  aviso: no existe %s" % viejo)
            continue
        n_arch = len(os.listdir(origen))
        print("  %-36s -> %-36s (%d archivos)" % (viejo, nuevo, n_arch))
        fase1.append((origen, os.path.join(SRC, "__tmp__" + nuevo), nuevo, num))

    for nombre, desc in VACIOS:
        print("  %-36s -> %-36s (vacia)" % ("", nombre))

    if DRY:
        return sum(len(os.listdir(o)) for o, _, _, _ in fase1)

    # Fase 1: a nombres temporales, para que 01->02, 02->03 ... no colisionen.
    for origen, tmp, _, _ in fase1:
        os.rename(origen, tmp)

    # Fase 2: nombre definitivo, y renombrado de los archivos dentro.
    movidos = 0
    for _, tmp, nuevo, num in fase1:
        destino = os.path.join(SRC, nuevo)
        os.rename(tmp, destino)
        for f in sorted(os.listdir(destino)):
            nf = renombrar_archivo(f, num)
            if nf != f:
                os.rename(os.path.join(destino, f), os.path.join(destino, nf))
            movidos += 1

    for nombre, desc in VACIOS:
        d = os.path.join(SRC, nombre)
        os.makedirs(d, exist_ok=True)
        with open(os.path.join(d, "SIN_FIGURAS.txt"), "w", encoding="utf-8") as fh:
            fh.write(
                "%s: sin figuras.\n\n"
                "Esta carpeta se entrega vacia a proposito: %s no contiene\n"
                "ninguna figura. Se incluye para que la numeracion de carpetas\n"
                "coincida exactamente con la del libro.\n" % (nombre, desc))

    return movidos


def actualizar_csv():
    path = os.path.join(ROOT, "Figuras_Inventario.csv")
    with open(path, encoding="utf-8") as fh:
        filas = list(csv.reader(fh))
    cab, cuerpo = filas[0], filas[1:]

    for fila in cuerpo:
        viejo = fila[0]
        if viejo not in MAPA:
            continue
        num, nuevo = MAPA[viejo]
        fila[0] = nuevo
        if num is not None and fila[3]:
            fila[3] = re.sub(r"^\d+\.", "%d." % num, fila[3])
        for j in (7, 8):
            if fila[j] and fila[j].startswith("figuras_editor/"):
                base = renombrar_archivo(os.path.basename(fila[j]), num)
                fila[j] = "figuras_editor/%s/%s" % (nuevo, base)

    orden_idx = {n: i for i, n in enumerate(ORDEN)}
    cuerpo.sort(key=lambda f: (orden_idx.get(f[0], 99),
                               int(f[2]) if f[2].isdigit() else 0))

    if not DRY:
        with open(path, "w", encoding="utf-8", newline="") as fh:
            w = csv.writer(fh)
            w.writerow(cab)
            w.writerows(cuerpo)
    return len(cuerpo)


def actualizar_manifiesto():
    path = os.path.join(ROOT, "Figuras_Manifiesto.md")
    with open(path, encoding="utf-8") as fh:
        texto = fh.read()

    partes = re.split(r"(?m)^### ", texto)
    cabecera, secciones = partes[0], partes[1:]

    nuevas = []
    for sec in secciones:
        viejo = sec.split("\n", 1)[0].strip()
        if viejo not in MAPA:
            nuevas.append((99, sec))
            continue
        num, nuevo = MAPA[viejo]
        sec = sec.replace(viejo, nuevo)
        if num is not None:
            viejo_num = old_num(viejo)
            sec = re.sub(r"Fig_%d\.(\d+)_" % viejo_num, r"Fig_%d.\1_" % num, sec)
            sec = re.sub(r"(?m)^\| (\d+) \| %d\.(\d+) \|" % viejo_num,
                         r"| \1 | %d.\2 |" % num, sec)
        nuevas.append((ORDEN.index(nuevo), sec))

    nuevas.sort(key=lambda t: t[0])
    salida = cabecera + "".join("### " + s for _, s in nuevas)

    nota = (
        "\n## Capitulos sin figuras\n\n"
        "Los capitulos 1 (preliminares), 16 (COMPADRE), 20 (Conclusion) y 23\n"
        "(Agradecimientos), y los apendices B y C, no contienen ninguna figura.\n"
        "Su carpeta se entrega vacia, con un archivo `SIN_FIGURAS.txt`, para que\n"
        "la numeracion de carpetas coincida con la del libro.\n")
    if "## Capitulos sin figuras" not in salida:
        salida = salida.rstrip("\n") + "\n" + nota

    if not DRY:
        with open(path, "w", encoding="utf-8") as fh:
            fh.write(salida)
    return len(nuevas)


if __name__ == "__main__":
    print("Renumerando la entrega de figuras%s\n" % (" (--dry)" if DRY else ""))
    n = mover_carpetas()
    f = actualizar_csv()
    s = actualizar_manifiesto()
    print("\n%d archivos, %d filas del inventario, %d secciones del manifiesto."
          % (n, f, s))
