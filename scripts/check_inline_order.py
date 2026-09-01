#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Detectar codigo en linea `r ...` que usa un objeto definido MAS ABAJO.

Motivo: el render del 1 de septiembre se detuvo con «object 'compadre' not
found» en 117:47. El parrafo usaba `r length(unique(compadre$Family))` pero el
objeto se cargaba 116 lineas mas abajo. knitr evalua en orden de documento, asi
que un uso en linea solo es valido si el objeto ya existe en ese punto.

Heuristica deliberadamente conservadora: solo mira asignaciones de nivel
superior dentro de bloques de codigo (`nombre <- ...`) y avisa cuando un
identificador usado en linea no aparece asignado antes. Los falsos positivos
esperables son funciones de paquetes; por eso se ignoran los nombres seguidos
de parentesis y una lista corta de objetos base.
"""
import io, re, sys, glob

ASIGNA = re.compile(r'^\s*([A-Za-z.][\w.]*)\s*(?:<-|=(?!=))')
INLINE = re.compile(r'`r\s+(.+?)`', re.S)
# Se eliminan primero las llamadas a funcion (`nombre(` -> `(`) y los accesos
# `$campo`; lo que queda son nombres de OBJETO, que es lo que interesa. Sin
# este paso, un lookahead sobre el identificador retrocede y produce basura
# como 'lengt' o 'roun'.
LLAMADA = re.compile(r'\b[A-Za-z.][\w.]*\s*(?=\()')
CAMPO = re.compile(r'\$\s*[A-Za-z.][\w.]*')
# Nombres de argumento (`na.rm =`, `collapse =`) no son objetos.
ARG = re.compile(r'\b[A-Za-z.][\w.]*\s*=(?!=)')
# Parametros de una funcion anonima declarada en la propia expresion.
PARAMS = re.compile(r'\bfunction\s*\(([^)]*)\)')
IDENT = re.compile(r'(?<![\w.$@"\'])([A-Za-z.][\w.]*)\b')
IGNORAR = {
    "c","if","else","for","function","TRUE","FALSE","NA","NULL","Inf",
    "T","F","in","return","length","unique","round","sum","max","min","mean",
    "median","nrow","ncol","dim","paste","paste0","sprintf","format","seq",
    "rev","sort","head","tail","abs","sqrt","exp","log","is","as","na",
    "rm","names","levels","factor","which","table","class","print","cat",
}

def revisar(path):
    texto = io.open(path, encoding="utf-8").read().split("\n")
    definidos, avisos, dentro = set(), [], False
    for i, linea in enumerate(texto, 1):
        if re.match(r'^\s*```', linea):
            dentro = not dentro
            continue
        if dentro:
            m = ASIGNA.match(linea)
            if m:
                definidos.add(m.group(1))
            continue
        for m in INLINE.finditer(linea):
            expr = m.group(1)
            locales = set()
            for pm in PARAMS.finditer(expr):
                locales |= {q.strip() for q in pm.group(1).split(',') if q.strip()}
            limpio = ARG.sub("", CAMPO.sub("", LLAMADA.sub("", expr)))
            for ident in set(IDENT.findall(limpio)):
                if ident in IGNORAR or ident in definidos or ident in locales:
                    continue
                avisos.append((i, ident, expr[:60]))
    return avisos

def main():
    total = 0
    for path in sorted(glob.glob("*.qmd")):
        if path.startswith("Apendice_Indice"):
            continue
        for linea, ident, frag in revisar(path):
            print(f"{path}:{linea}  '{ident}' se usa en línea antes de estar definido  →  `r {frag}`")
            total += 1
    print(f"\navisos: {total}")
    return 1 if total else 0

if __name__ == "__main__":
    sys.exit(main())
