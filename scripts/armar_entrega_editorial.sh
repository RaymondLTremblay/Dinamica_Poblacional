#!/usr/bin/env bash
# armar_entrega_editorial.sh
# ==========================
# Arma el .zip completo para la editorial (Jardín Botánico Lankester).
#
# ORDEN OBLIGATORIO — este script NO renderiza nada, solo empaqueta lo que
# encuentre, así que hay que correrlo DESPUÉS de:
#
#   1)  quarto render                          (libro completo + figuras_editor/)
#   2)  Rscript -e 'source("scripts/render_docx_per_chapter.R");
#                   render_all_chapters()'     (~30 min, un .docx por capítulo)
#   3)  bash scripts/armar_entrega_editorial.sh
#
# Si algo falta, el script se detiene y dice qué falta, en vez de producir un
# paquete incompleto.

set -euo pipefail
cd "$(dirname "$0")/.."

FECHA="$(date +%Y-%m-%d)"
PAQUETE="Entrega_Editorial_${FECHA}"
STAGE=".entrega_tmp/${PAQUETE}"

WORD="docs/Introducción-a-la-Dinámica-Poblacional-de-Orquídeas.docx"
PDF="docs/Introducción-a-la-Dinámica-Poblacional-de-Orquídeas.pdf"

faltan=0
aviso() { echo "  FALTA: $1"; faltan=1; }

echo "== Comprobaciones previas =="
[ -f "$WORD" ]              || aviso "el Word completo ($WORD)"
[ -d "figuras_editor" ]     || aviso "figuras_editor/ (lo genera el post-render)"
[ -d "docx_chapters" ]      || aviso "docx_chapters/ (paso 2: render_docx_per_chapter.R)"

# El Word tiene que ser MÁS NUEVO que las fuentes, o se estaría entregando
# una compilación vieja. Es el error que más caro sale.
if [ -f "$WORD" ]; then
  viejos="$(find . -maxdepth 2 \
      \( -name '*.qmd' -o -name '_quarto.yml' -o -name '_language.yml' \
         -o -path './R/*' -o -path './scripts/*' \) \
      -newer "$WORD" -not -path './_archive/*' -not -path './docs/*' \
      -not -path './.entrega_tmp/*' 2>/dev/null | wc -l | tr -d ' ')"
  if [ "$viejos" != "0" ]; then
    echo "  AVISO: $viejos archivo(s) del proyecto son más nuevos que el Word."
    echo "         El paquete llevaría una compilación desactualizada."
    echo "         Vuelva a renderizar antes de empaquetar. Para empaquetar"
    echo "         igualmente: FORZAR=1 bash scripts/armar_entrega_editorial.sh"
    [ "${FORZAR:-0}" = "1" ] || faltan=1
  fi
fi

[ "$faltan" = "0" ] || { echo; echo "Paquete NO generado."; exit 1; }

echo "== Armando ${PAQUETE} =="
rm -rf ".entrega_tmp"
mkdir -p "$STAGE"/{01_Libro_completo,02_Capitulos_en_Word,03_Figuras,04_Prologos}

cp "$WORD" "$STAGE/01_Libro_completo/"
# Quarto rotula los apéndices «Appendix A — …» en inglés y esa cadena no
# es localizable en 1.9.38. Se traduce sobre la copia empaquetada.
python3 scripts/fix_docx_appendix_label.py "$STAGE/01_Libro_completo/$(basename "$WORD")" >/dev/null
rm -f "$STAGE/01_Libro_completo/$(basename "$WORD").bak"
[ -f "$PDF" ] && cp "$PDF" "$STAGE/01_Libro_completo/"

cp docx_chapters/*.docx "$STAGE/02_Capitulos_en_Word/" 2>/dev/null || true
cp -R figuras_editor/. "$STAGE/03_Figuras/"

for f in Prologos*.docx docs/Prologos.docx docx_chapters/Prologos.docx; do
  [ -f "$f" ] && cp "$f" "$STAGE/04_Prologos/"
done

n_cap="$(ls "$STAGE/02_Capitulos_en_Word" | wc -l | tr -d ' ')"
n_fig="$(find "$STAGE/03_Figuras" -type f \( -name '*.png' -o -name '*.jpg' \
          -o -name '*.jpeg' -o -name '*.pdf' \) | wc -l | tr -d ' ')"

cat > "$STAGE/_LEER_PRIMERO.md" <<EOF
# Entrega editorial — ${FECHA}

**Esta entrega reemplaza por completo cualquier envío anterior**, incluido el
Word del 2 de junio y la primera entrega de figuras. Por favor descarten las
versiones viejas para que no queden dos circulando.

## Contenido

- \`01_Libro_completo/\` — el libro entero en Word, y el PDF compuesto como
  referencia visual. **El Word es el archivo de trabajo**; el PDF solo sirve
  para ver cómo queda la maqueta.
- \`02_Capitulos_en_Word/\` — un .docx por capítulo (${n_cap} archivos), para
  repartir el trabajo de corrección entre varias personas.
- \`03_Figuras/\` — las figuras por capítulo (${n_fig} archivos), con el prefijo
  \`Fig_<capítulo>.<número>_\` que coincide exactamente con el pie impreso.
  Incluye \`Figuras_Inventario.csv\` con una fila por figura.
- \`04_Prologos/\` — los prólogos, en el idioma en que fueron escritos.

## Notas para la diagramación

- Cuando una figura existe en \`.pdf\` y en \`.png\`, **usar el .pdf**: escala
  sin pérdida. Las fotos de especies solo existen en \`.jpg\`.
- En los .docx por capítulo las referencias cruzadas a otros capítulos salen
  como \`?@fig-...\` y la numeración de figuras reinicia en 1.1. Es esperado:
  esos archivos son para corregir texto, no para maquetar. **La numeración
  válida es la del libro completo.**
- Las carpetas con \`SIN_FIGURAS.txt\` son capítulos que no tienen ninguna
  figura. No falta nada.

Cualquier duda, con gusto la resuelvo.

Raymond L. Tremblay
EOF

( cd .entrega_tmp && zip -qr "../${PAQUETE}.zip" "${PAQUETE}" )
rm -rf ".entrega_tmp"

echo
echo "  ${PAQUETE}.zip"
echo "  capítulos en Word: ${n_cap}    archivos de figura: ${n_fig}"
echo "  tamaño: $(du -h "${PAQUETE}.zip" | cut -f1)"
