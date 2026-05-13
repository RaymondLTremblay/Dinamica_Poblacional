#!/bin/bash
# Wrapper conveniente alrededor de scripts/collect_figures.py.
#
# Uso:
#   bash scripts/collect-figures.sh
#
# Después de cada `quarto render`, recolecta todas las figuras
# (estáticas, generadas por chunks, y render_dual) en una estructura
# por capítulo dentro de figuras_editor/.
#
# Ver scripts/collect_figures.py para los detalles de la lógica.

set -euo pipefail
BOOK_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$BOOK_ROOT"
python3 scripts/collect_figures.py "$@"
