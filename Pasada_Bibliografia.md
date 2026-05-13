# Pasada de bibliografía — resumen

Auditoría completa de `book.bib` y verificación cruzada con todas las citas `@key` usadas en los `.qmd`.

## Antes / Después

| Métrica | Antes | Después |
|---|---|---|
| Entradas en `book.bib` | 494 | 471 |
| Líneas en `book.bib` | 5040 | 4821 |
| Citas huérfanas (cited but missing entry) | 0 | 0 |
| Entradas huérfanas (in bib, never cited) | 23 | 0 |
| Entradas sin año / sin autor / sin título | 0 / 0 / 0 | 0 / 0 / 0 |
| Duplicados por DOI | 0 | 0 |
| Duplicados por título | 1 real | 0 |
| Llaves desbalanceadas | 0 | 0 |

## Acciones aplicadas

### 1. Duplicado real arreglado

`aucencia2024acclimatization` y `emeterio2024acclimatization` eran la misma publicación (Emeterio-Lara & Damon 2024, *Journal for Nature Conservation*), pero la entrada `aucencia*` tenía los nombres del autor invertidos ("Aucencia, Emeterio-Lara and Anne, Damon" — primer nombre tratado como apellido).

- Acción 1: La única cita en `104-Recopilacion_datos_en_el_campo.qmd` (línea 342) se actualizó de `[@aucencia2024acclimatization]` a `[@emeterio2024acclimatization]`.
- Acción 2: La entrada duplicada `aucencia2024acclimatization` se eliminó de `book.bib`.

### 2. 22 entradas huérfanas eliminadas

Estas entradas estaban en `book.bib` pero ninguna `.qmd` las citaba. No rompían el render, pero eran lastre:

```
acevedo2015spatial
acevedo2020local
arevalo2004diversidad
damon2000review
falcon2018island
fantinato2017food
flores2001sampling
hanski1999metapopulation
heggerud2023transient
hutchings1987populationb
morales2010morphological
orive1993effective
pfeifer2006long
salguero2016fast
sao2019reproductive
turkingtonjohn
turnbull2000plant
vsvecova2023difficulties
wells1981population
xie2015
zhang2019comparative
zimmerman1992ecological
```

**Backup:** `book.bib.backup` contiene la versión previa por si quieres restaurar alguna.

### 3. Verificación de integridad

- Todas las 471 entradas restantes tienen llaves balanceadas.
- Todas tienen los campos básicos (autor/editor, título, año).
- No quedan citas huérfanas reales (los 5 falsos positivos en grep — `@biology`, `@pmb`, `@book`, `@incollection`, `@matC` — son emails y fragmentos de código R, no citas).
- No quedan entradas huérfanas.

## Pendiente sólo si quieres extender el audit

Cosas que no toqué porque son juicio editorial, no errores:

- **DOIs faltantes.** Muchas entradas no tienen `doi`. No impide el render; sólo afecta a quien quiera enlazar desde el HTML/PDF a las publicaciones originales. Si quieres, puedo intentar enriquecer las que faltan con búsqueda DOI (requiere acceso a Crossref).
- **Formato de autores.** Algunas entradas usan `{Apellido, Nombre}`, otras `{Nombre Apellido}`. El CSL los normaliza al renderizar, así que no es funcional, sólo cosmético.
- **Mezcla de `@article`, `@incollection`, `@misc`** — todos válidos en BibTeX; cada uno renderiza distinto. Si ves alguna referencia con formato raro en el render, dímelo.
