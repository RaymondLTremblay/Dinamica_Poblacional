# ─────────────────────────────────────────────────────────────────────────
# Tema y paleta de color personal para las gráficas ggplot2 del libro.
#
# Definición ÚNICA y canónica. Antes estaba copiada en ~11 capítulos; ahora
# cada capítulo solo hace `source("R/rlt_theme.R")` en su chunk de preparación.
# El código se muestra una sola vez en el libro (sección "Convenciones
# gráficas" del capítulo de introducción) mediante un chunk con
# `#| file: R/rlt_theme.R` y `#| eval: false`.
#
# Notas:
# - Funciones de ggplot2 con prefijo `ggplot2::` para que `source()` no falle
#   aunque ggplot2 aún no esté adjunto (p. ej. al sourcear desde .Rprofile).
# - `rlt_style_fill()` / `rlt_style_colour()` resuelven `diverging` en tiempo
#   de llamada, así que un capítulo podría REDEFINIR `diverging` localmente
#   DESPUÉS de este `source()` si lo necesitara. Ya ningún capítulo lo hace:
#   los 8 colores bastan para todas las figuras del libro.
# ─────────────────────────────────────────────────────────────────────────

# Tipografía base de las figuras: una serif que coincide con el cuerpo del
# libro (Libertinus Serif, la misma fuente del PDF tipográfico, que es una
# dependencia de compilación). Todo el texto de la figura (ejes, leyenda,
# título) hereda esta familia desde `text`. Si la fuente no estuviera instalada
# en la máquina que renderiza, cámbiela por la genérica "serif".
base_family <- "Libertinus Serif"

rlt_theme <- ggplot2::theme(
  text = ggplot2::element_text(family = base_family),
  axis.title.y = ggplot2::element_text(colour = "grey20", size = 10, face = "bold"),
  axis.text.x = ggplot2::element_text(colour = "grey20", size = 10, face = "bold"),
  axis.text.y = ggplot2::element_text(colour = "grey20", size = 15, face = "bold"),
  axis.title.x = ggplot2::element_text(colour = "grey20", size = 15, face = "bold")
) +
  ggplot2::theme(
    # Remover los bordes
    panel.border = ggplot2::element_blank(),
    # Remover las líneas
    panel.grid.major = ggplot2::element_blank(),
    panel.grid.minor = ggplot2::element_blank(),
    # Remover el fondo del panel
    panel.background = ggplot2::element_blank(),
    # añadir lineas más gruesas
    axis.line.x = ggplot2::element_line(colour = "black", linewidth = 1),
    axis.line.y = ggplot2::element_line(colour = "black", linewidth = 1)
  )

# Paleta cualitativa segura para daltonismo (Okabe-Ito, 8 colores), con el
# tercer color sustituido por el teal de la marca del libro (#009392) para
# mantener la identidad visual. El nombre `diverging` se conserva por
# compatibilidad con las llamadas existentes en los capítulos.
diverging <- c(
  "#E69F00", "#56B4E9", "#009392", "#F0E442",
  "#0072B2", "#D55E00", "#CC79A7", "#000000"
)

# Combinar tema + escala en una lista que se añade al gráfico con un solo '+'.
rlt_style_fill <- function() {
  list(
    rlt_theme,
    ggplot2::scale_fill_manual(values = diverging)
  )
}

rlt_style_colour <- function() {
  list(
    rlt_theme,
    ggplot2::scale_colour_manual(values = diverging)
  )
}
