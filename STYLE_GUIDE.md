# Guía de estilo — Dinámica Poblacional

Convenciones editoriales del libro. Estándar: español panhispánico (RAE/ASALE), apto para lectores de México, España, Puerto Rico, Sudamérica.

## Ortografía y vocabulario

- **sensibilidad** (no "sensitividad")
- **intrínseco/intrínseca** (no "intrínsico/intrínsica")
- **forófito** (con tilde)
- **estadio** (sin tilde; "estadío" es incorrecto)
- **capítulo** (con tilde)
- **demografía** (con tilde)
- **obtiene** (no "optiene")
- **etc.** (no "ect.")
- **e.g.** preferido sobre **v.g.** (mezclado en el libro, se está unificando)
- **i.e.** se conserva tal cual

## Términos técnicos consistentes

- **estadio** > **etapa** > **fase**: usar "estadio" como término preferente en demografía estructurada. "Etapa" y "fase" pueden usarse en prosa cuando el contexto no es técnico.
- **función de transferencia** vs **funciones de transferencia**: usar plural cuando se habla del marco/clase de funciones; singular para una instancia concreta.
- **dinámica poblacional** (no "dinámica de poblaciones" excepto cuando contraste regional lo amerita).
- **a largo/corto plazo** preferido sobre **de largo/corto plazo** en construcciones [sustantivo] + plazo.
- **pseudobulbo** (sin guion; RAE acepta sin guion).
- **plántula** (con tilde).

## Acentos comúnmente omitidos

- están, son, está (verbos)
- fácil, público, básico, práctico, único/única
- específico, máximo, mínimo

## Citaciones

- **Estilo CSL**: `peerj.csl` (3 autores completos, "et al." sólo desde 4).
- **Sintaxis Quarto**: `[@key]` para parentética, `@key` para inline.
- **Multi-cita**: `[@key1; @key2]` (punto y coma, no coma).
- **Citas en prosa**: "Tremblay y colaboradores [@tremblay2015stable]" preferido sobre "Tremblay et al. (2015)" en redacción.

## Italicas

- **Binomios latinos**: siempre en cursiva (*Lepanthes caritensis*).
- **Subfamilias/familias**: en cursiva (*Orchidaceae*, *Pleurothalliinae*).
- **Préstamos del inglés** usados como término: cursiva (*ramets*, *dust-seeds*, *grosso modo*, *per se*).
- **Paquetes R**: con backticks (`Rage`, `popbio`, `flextable`).
- **Funciones R**: con backticks (`eigen.analysis()`, `lambda()`).
- Después de la primera mención del género completo, abreviarlo (*L. rubripetala*).

## Símbolos matemáticos

- **λ** (no "lambda") en prosa o `$\lambda$` (LaTeX) en ecuaciones / inline math.
- **decimales con punto** (`0.5`, `λ = 1.007`), nunca con coma. Razón: consistencia con el código R.
- Subíndices en estilo LaTeX: `$\lambda_{max}$`, `$t_{0}$`.

## Estructura

- Pies de tabla y figura: "Tabla 1. ..." / "Figura 1. ..." con número y punto.
- Referencias cruzadas: preferir `[nombre del capítulo](archivo.qmd)` sobre "Capítulo X".
- Callouts: `::: callout-note`, `::: callout-tip`, `::: callout-important`, `::: callout-warning`.

## Comentarios en código R

- Lenguaje: español preferido (consistente con el resto del libro).
- Marcadores `#` precedidos por espacio: `# Comentario`.

## Compatibilidad HTML + PDF

- Usar Markdown estándar (links, imágenes, tablas) — funcionan en ambos.
- Evitar HTML crudo cargado (raw `<a href>`, `<div>` complejos).
- Para tablas que aparecen en PDF: `flextable` puede tener problemas en PDF — para tablas importantes considerar `kable`.
- Smart quotes («») se renderizan correctamente con `lang: es`.
- Em-dash (—) y guion (-) funcionan en ambos.
