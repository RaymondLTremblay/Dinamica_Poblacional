# R/figuras_helpers.R
# ====================
# Helpers para guardar figuras del libro como PNG estáticos.
#
# Uso típico en un chunk de Quarto:
#
#   source("R/figuras_helpers.R")
#
#   # plot_life_cycle (devuelve htmlwidget de DiagrammeR):
#   p <- plot_life_cycle(matA, stages = c("p", "j", "a"))
#   save_plot_png(p, "images/cap_chunk.png")
#   p                       # mostrar widget en HTML
#
#   # grViz directo: igual patrón.
#
# El PNG queda en `images/` y `scripts/collect_figures.py` lo recoge a
# `figuras_editor/<cap>/` con el prefijo de orden correspondiente.

# Tamaño y resolución por defecto del PNG
.SAVE_PLOT_PNG_WIDTH  <- 2400
.SAVE_PLOT_PNG_HEIGHT <- 1600
.SAVE_PLOT_PNG_DPI    <- 300

#' Guardar un objeto gráfico (ggplot, htmlwidget, grViz) como PNG.
#'
#' @param obj      objeto a guardar: ggplot, htmlwidget, o grViz.
#' @param file     ruta del PNG de salida (típicamente "images/<nombre>.png").
#' @param width_px ancho en píxeles. Default 2400.
#' @param height_px alto en píxeles. Default 1600.
#' @param dpi      DPI para conversión ggplot. Default 300.
#' @param zoom     zoom para fallback con webshot2. Default 1.5.
#' @return `file` (invisible).
save_plot_png <- function(obj, file,
                          width_px = .SAVE_PLOT_PNG_WIDTH,
                          height_px = .SAVE_PLOT_PNG_HEIGHT,
                          dpi = .SAVE_PLOT_PNG_DPI,
                          zoom = 1.5) {
  dir.create(dirname(file), showWarnings = FALSE, recursive = TRUE)

  # Caso 1: objeto ggplot
  if (inherits(obj, "ggplot")) {
    ggplot2::ggsave(
      filename = file, plot = obj,
      width = width_px / dpi, height = height_px / dpi, dpi = dpi
    )
    message("Saved ggplot to: ", file)
    return(invisible(file))
  }

  # Caso 2: htmlwidget (DiagrammeR / grViz / plot_life_cycle)
  if (inherits(obj, "htmlwidget") || inherits(obj, "grViz")) {
    ok <- FALSE
    if (requireNamespace("DiagrammeRsvg", quietly = TRUE) &&
        requireNamespace("rsvg",           quietly = TRUE)) {
      try({
        svg_txt <- DiagrammeRsvg::export_svg(obj)
        rsvg::rsvg_png(
          charToRaw(svg_txt), file,
          width = width_px, height = height_px
        )
        message("Saved htmlwidget via SVG->PNG to: ", file)
        ok <- TRUE
      }, silent = TRUE)
    }
    if (!ok) {
      if (!requireNamespace("htmlwidgets", quietly = TRUE) ||
          !requireNamespace("webshot2",    quietly = TRUE)) {
        stop(
          "Para guardar htmlwidgets se necesita ",
          "'DiagrammeRsvg'+'rsvg' o bien 'htmlwidgets'+'webshot2'."
        )
      }
      htmlfile <- tempfile(fileext = ".html")
      htmlwidgets::saveWidget(obj, file = htmlfile, selfcontained = TRUE)
      webshot2::webshot(
        htmlfile, file = file,
        vwidth = width_px, vheight = height_px, zoom = zoom
      )
      message("Saved htmlwidget via webshot2 to: ", file)
    }
    return(invisible(file))
  }

  stop("Tipo de objeto no soportado: ", paste(class(obj), collapse = ", "))
}

#' Atajo: `plot_life_cycle(...)` que ADEMÁS guarda PNG.
#'
#' Equivalente a:
#'   p <- Rage::plot_life_cycle(...); save_plot_png(p, png); p
#'
#' @param ...   args para Rage::plot_life_cycle.
#' @param png   ruta del PNG; típicamente "images/<chunk-id>.png".
#' @return el htmlwidget (para que se muestre como antes en HTML).
plc_save <- function(..., png) {
  if (missing(png) || is.null(png) || !nzchar(png)) {
    stop("plc_save() requiere `png = 'images/<nombre>.png'`")
  }
  p <- Rage::plot_life_cycle(...)
  save_plot_png(p, file = png)
  p
}

#' Atajo: `grViz(...)` que ADEMÁS guarda PNG.
#' @param dot  código DOT.
#' @param png  ruta del PNG; típicamente "images/<chunk-id>.png".
#' @return el htmlwidget grViz.
grviz_save <- function(dot, ..., png) {
  if (missing(png) || is.null(png) || !nzchar(png)) {
    stop("grviz_save() requiere `png = 'images/<nombre>.png'`")
  }
  g <- DiagrammeR::grViz(dot, ...)
  save_plot_png(g, file = png)
  g
}
