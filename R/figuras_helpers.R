# R/figuras_helpers.R
# ====================
# Helpers para guardar figuras del libro como PNG (display) y PDF (editor).
#
# Uso típico en un chunk de Quarto:
#
#   source("R/figuras_helpers.R")
#
#   # plot_life_cycle (devuelve htmlwidget de DiagrammeR):
#   p <- plot_life_cycle(matA, stages = c("p", "j", "a"))
#   save_plot_png(p, "images/cap_chunk.png")   # guarda .png Y .pdf
#   p                                            # mostrar widget en HTML
#
#   # grViz directo: igual patrón.
#
# El PNG queda en `images/<chunk>.png` y se acompaña de `images/<chunk>.pdf`
# (vector cuando es posible). `scripts/collect_figures.py` recoge ambos
# a `figuras_editor/<cap>/` con el prefijo de orden correspondiente.

# Tamaño y resolución por defecto del PNG
.SAVE_PLOT_PNG_WIDTH <- 2400
.SAVE_PLOT_PNG_HEIGHT <- 1600
.SAVE_PLOT_PNG_DPI <- 300

#' Reemplazar la extensión de un archivo por otra.
#' Internal helper.
.replace_ext <- function(path, new_ext) {
  sub("\\.[^./\\\\]+$", paste0(".", sub("^\\.", "", new_ext)), path)
}

#' Guardar un objeto gráfico (ggplot, htmlwidget, grViz) como PNG y PDF.
#'
#' Siempre escribe `file` (PNG). Si `also_pdf = TRUE` (por defecto) también
#' escribe el sibling PDF (misma ruta, extensión .pdf). El PDF es vectorial
#' cuando es posible (ggplot vía `ggsave`; widgets vía SVG→PDF con
#' `DiagrammeRsvg` + `rsvg`). Si las dependencias no están disponibles cae
#' a `webshot2` con salida PDF (rasterizado dentro del PDF).
#'
#' @param obj      objeto a guardar: ggplot, htmlwidget, o grViz.
#' @param file     ruta del PNG de salida (típicamente "images/<nombre>.png").
#' @param width_px ancho en píxeles. Default 2400.
#' @param height_px alto en píxeles. Default 1600.
#' @param dpi      DPI para conversión ggplot. Default 300.
#' @param zoom     zoom para fallback con webshot2. Default 1.5.
#' @param also_pdf escribir también un sibling PDF. Default TRUE.
#' @return `file` (invisible).
save_plot_png <- function(obj, file,
                          width_px = .SAVE_PLOT_PNG_WIDTH,
                          height_px = .SAVE_PLOT_PNG_HEIGHT,
                          dpi = .SAVE_PLOT_PNG_DPI,
                          zoom = 1.5,
                          also_pdf = TRUE) {
  dir.create(dirname(file), showWarnings = FALSE, recursive = TRUE)
  pdf_file <- if (also_pdf) .replace_ext(file, "pdf") else NULL

  # Caso 1: objeto ggplot
  if (inherits(obj, "ggplot")) {
    ggplot2::ggsave(
      filename = file, plot = obj,
      width = width_px / dpi, height = height_px / dpi, dpi = dpi
    )
    message("Saved ggplot to: ", file)
    if (!is.null(pdf_file)) {
      try(
        {
          ggplot2::ggsave(
            filename = pdf_file, plot = obj,
            width = width_px / dpi, height = height_px / dpi,
            device = grDevices::cairo_pdf
          )
          message("Saved ggplot PDF to: ", pdf_file)
        },
        silent = TRUE
      )
    }
    return(invisible(file))
  }

  # Caso 2: htmlwidget (DiagrammeR / grViz / plot_life_cycle)
  if (inherits(obj, "htmlwidget") || inherits(obj, "grViz")) {
    ok <- FALSE
    if (requireNamespace("DiagrammeRsvg", quietly = TRUE) &&
      requireNamespace("rsvg", quietly = TRUE)) {
      try(
        {
          svg_txt <- DiagrammeRsvg::export_svg(obj)
          rsvg::rsvg_png(
            charToRaw(svg_txt), file,
            width = width_px, height = height_px
          )
          message("Saved htmlwidget via SVG->PNG to: ", file)
          if (!is.null(pdf_file)) {
            try(
              {
                rsvg::rsvg_pdf(charToRaw(svg_txt), pdf_file)
                message("Saved htmlwidget PDF (vector) to: ", pdf_file)
              },
              silent = TRUE
            )
          }
          ok <- TRUE
        },
        silent = TRUE
      )
    }
    if (!ok) {
      if (!requireNamespace("htmlwidgets", quietly = TRUE) ||
        !requireNamespace("webshot2", quietly = TRUE)) {
        stop(
          "Para guardar htmlwidgets se necesita ",
          "'DiagrammeRsvg'+'rsvg' o bien 'htmlwidgets'+'webshot2'."
        )
      }
      htmlfile <- tempfile(fileext = ".html")
      htmlwidgets::saveWidget(obj, file = htmlfile, selfcontained = TRUE)
      webshot2::webshot(
        htmlfile,
        file = file,
        vwidth = width_px, vheight = height_px, zoom = zoom
      )
      message("Saved htmlwidget via webshot2 to: ", file)
      if (!is.null(pdf_file)) {
        try(
          {
            webshot2::webshot(
              htmlfile,
              file = pdf_file,
              vwidth = width_px, vheight = height_px, zoom = zoom
            )
            message("Saved htmlwidget PDF (rasterized) to: ", pdf_file)
          },
          silent = TRUE
        )
      }
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

# ---- Renderizado de matrices y objetos como tablas legibles ----

#' Renderizar una matriz numérica como flextable con nombres de fila/columna.
#'
#' Las matrices `matA`, `matU`, `matF`, `matC` de Rcompadre y similares son
#' `matrix` con dim-names. Imprimirlas crudo en un chunk produce salida ASCII
#' que en Word/PDF se ve fea (letras apiladas o columnas estrechas).
#' Este helper las convierte a un data.frame con la primera columna siendo
#' los nombres de fila y luego flextable.
#'
#' @param m         matriz (o objeto convertible a matriz).
#' @param digits    decimales a mostrar. Default 3.
#' @param row_label etiqueta de la primera columna (los nombres de fila).
#'                  Default " " (espacio en blanco).
#' @return un objeto `flextable`.
mat_to_ft <- function(m, digits = 3, row_label = " ") {
  # Caso común con Rcompadre: matA(), matU(), matF(), matC() devuelven una
  # *lista* de matrices (una por fila del CompadreDB). Si es lista de
  # longitud 1, extraer la matriz; si es lista más larga, advertir y usar
  # la primera.
  if (is.list(m) && !is.data.frame(m)) {
    if (length(m) > 1L) {
      warning("mat_to_ft() recibió una lista de ", length(m),
              " matrices; mostrando solo la primera.")
    }
    m <- m[[1]]
  }
  # Si es data.frame, convertir; preserva nombres de fila/columna.
  if (is.data.frame(m)) m <- as.matrix(m)
  if (!is.matrix(m)) m <- as.matrix(m)
  if (!is.numeric(m)) {
    # Algunos pipelines (p.ej. `cdb_flatten()` de Rcompadre) almacenan
    # matrices con storage.mode no numérico (character, factor, etc.).
    # Intentamos coercer preservando dimensiones y dim-names. Si quedan
    # NAs nuevos (valores no parseables) los conservamos en la salida —
    # el editor verá "NA" en esas celdas en lugar de un error del render.
    coerced <- suppressWarnings(matrix(
      as.numeric(as.character(m)),
      nrow = nrow(m), ncol = ncol(m),
      dimnames = dimnames(m)
    ))
    n_new_na <- sum(is.na(coerced) & !is.na(m))
    if (n_new_na > 0L) {
      warning("mat_to_ft(): ", n_new_na, " valor(es) no parseable(s) ",
              "convertido(s) a NA en la salida.")
    }
    m <- coerced
  }
  if (is.null(rownames(m))) rownames(m) <- as.character(seq_len(nrow(m)))
  if (is.null(colnames(m))) colnames(m) <- as.character(seq_len(ncol(m)))
  m_round <- round(m, digits)
  df <- data.frame(
    rn = rownames(m_round),
    m_round,
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  names(df)[1] <- row_label
  flextable::flextable(df)
}

#' Dispatcher genérico: renderiza cualquier objeto como una tabla
#' legible en HTML/PDF/Word, usando el helper adecuado según la clase.
#'
#' Útil para reemplazar referencias a objetos "crudas" al final de un chunk
#' (que knitr imprime con `print()` por defecto, generando ASCII feo en Word):
#'
#'   # Antes:  mi_matriz
#'   # Después: pretty(mi_matriz)
#'
#' Cubre: matrix → `mat_to_ft`, CompadreMat → `compmat_to_ft`,
#' data.frame/tibble → flextable, summary.default (los típicos
#' "Min., 1st Qu., …") → flextable horizontal, named numeric vector →
#' flextable de dos columnas.
#'
#' @param x       objeto a renderizar.
#' @param digits  decimales para matrices/valores numéricos. Default 3.
#' @param ...     argumentos extra propagados al helper específico.
#' @return el objeto flextable (o lo que devuelva el helper específico).
pretty <- function(x, digits = 3, ...) {
  if (inherits(x, "CompadreMat")) {
    return(compmat_to_ft(x, digits = digits, ...))
  }
  if (is.matrix(x)) {
    return(mat_to_ft(x, digits = digits, ...))
  }
  if (inherits(x, "summaryDefault") || inherits(x, "table")) {
    df <- data.frame(
      Estadístico = names(x),
      Valor       = round(as.numeric(x), digits),
      check.names = FALSE
    )
    return(flextable::flextable(df))
  }
  if (is.data.frame(x)) {
    return(flextable::flextable(as.data.frame(x)))
  }
  if (is.numeric(x) && !is.null(names(x))) {
    df <- data.frame(
      Nombre = names(x),
      Valor  = round(as.numeric(x), digits),
      check.names = FALSE
    )
    return(flextable::flextable(df))
  }
  # Fallback: imprimir tal cual (mejor que romper).
  print(x)
}

#' Renderizar un objeto `CompadreMat` (resultado de `mpm_mean`, `mpm_median`,
#' etc.) como una serie de flextables: matA, matU, matF, matC y la
#' clasificación de estadios.
#'
#' Imprime directamente vía `knit_print` para que funcione en chunks
#' normales sin necesidad de `results: asis`.
#'
#' @param cm     objeto CompadreMat.
#' @param digits decimales para los valores de las matrices. Default 3.
#' @return invisible(NULL); imprime los flextables como efecto secundario.
compmat_to_ft <- function(cm, digits = 3) {
  slots_show <- intersect(c("matA", "matU", "matF", "matC"),
                          methods::slotNames(cm))
  for (sn in slots_show) {
    m <- methods::slot(cm, sn)
    if (!is.matrix(m) || length(m) == 0L) next
    cat(sprintf("\n\n**%s**\n\n", sn))
    print(mat_to_ft(m, digits = digits))
  }
  if ("MatrixClassAuthor" %in% methods::slotNames(cm)) {
    cat("\n\n**Etapas**\n\n")
    df <- data.frame(
      Tipo  = cm@MatrixClassOrganized,
      Etapa = cm@MatrixClassAuthor,
      stringsAsFactors = FALSE
    )
    print(flextable::flextable(df))
  }
  invisible(NULL)
}
