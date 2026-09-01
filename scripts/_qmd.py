# -*- coding: utf-8 -*-
"""Utilidades compartidas para editar solo la PROSA de un .qmd,
dejando intactos los bloques de codigo (```...```) y el codigo en linea (`...`)."""
import io, re

def read(p):
    return io.open(p, encoding="utf-8").read()

def write(p, s):
    io.open(p, "w", encoding="utf-8").write(s)

def map_prose(path, fn, skip_inline_code=True, skip_yaml=True):
    """Aplica fn(texto)->texto a cada segmento de prosa. Devuelve (n_lineas_cambiadas)."""
    s = read(path)
    lines = s.split("\n")
    out = []
    infence = False
    inyaml = False
    changed = 0
    for i, l in enumerate(lines):
        if skip_yaml and i == 0 and l.strip() == "---":
            inyaml = True; out.append(l); continue
        if inyaml:
            out.append(l)
            if l.strip() == "---": inyaml = False
            continue
        if re.match(r'^\s*```', l):
            infence = not infence
            out.append(l); continue
        if infence:
            out.append(l); continue
        if re.match(r'^#\|', l):        # opciones de chunk
            out.append(l); continue
        if skip_inline_code and "`" in l:
            # trocear preservando lo que va entre backticks
            parts = re.split(r'(`[^`]*`)', l)
            new = "".join(p if p.startswith("`") else fn(p) for p in parts)
        else:
            new = fn(l)
        if new != l: changed += 1
        out.append(new)
    res = "\n".join(out)
    if res != s:
        write(path, res)
    return changed
