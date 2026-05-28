# Disable CLI hyperlinks to prevent ANSI escape codes in LaTeX output
options(
  cli.hyperlink = FALSE,
  cli.hyperlink_help = FALSE,
  cli.hyperlink_run = FALSE,
  cli.hyperlink_vignette = FALSE,
  cli.num_colors = 1
)
Sys.setenv(NO_COLOR = "1")

# ── Modern theme for HTML: striped rows + teal header ──
ft_theme_modern <- function(ft) {
  ft <- flextable::border_remove(ft)
  # Header: teal background, white bold text
  ft <- flextable::bg(ft, bg = "#1a7a6d", part = "header")
  ft <- flextable::color(ft, color = "#ffffff", part = "header")
  ft <- flextable::bold(ft, part = "header")
  ft <- flextable::padding(ft, padding.top = 6, padding.bottom = 6, part = "header")
  # Body: alternating rows. Requiere al menos 2 filas para tener una
  # fila "par" que sombrear; con 0 o 1 filas, `seq(2, n_rows, by = 2)`
  # falla con "wrong sign in 'by' argument".
  n_rows <- flextable::nrow_part(ft, part = "body")
  if (n_rows >= 2L) {
    even_rows <- seq(2L, n_rows, by = 2L)
    ft <- flextable::bg(ft, i = even_rows, bg = "#eef5f4", part = "body")
  }
  # Subtle row borders
  ft <- flextable::hline(
    ft,
    part = "body",
    border = officer::fp_border(color = "#d4e5e3", width = 0.5)
  )
  # Bottom border under header
  ft <- flextable::hline_bottom(
    ft,
    part = "header",
    border = officer::fp_border(color = "#15665b", width = 1.5)
  )
  # Bottom border under table
  ft <- flextable::hline_bottom(
    ft,
    part = "body",
    border = officer::fp_border(color = "#1a7a6d", width = 1.5)
  )
  ft <- flextable::padding(ft, padding.top = 4, padding.bottom = 4, part = "body")
  ft
}

# ── Conditional theme: modern for HTML, booktabs for PDF ──
ft_theme_auto <- function(ft) {
  if (knitr::is_latex_output()) {
    ft <- flextable::theme_booktabs(ft)
  } else {
    ft <- ft_theme_modern(ft)
  }
  # En docx el `table.layout` global de flextable no se aplica;
  # ni siquiera `set_table_properties(layout="autofit")` por sí solo
  # produce columnas anchas — Word ignora el hint y colapsa cada
  # columna al ancho mínimo de contenido (letras apiladas verticales).
  # Combinación que sí funciona:
  #   1. `autofit()` mide el contenido y FIJA anchos explícitos por
  #      columna en pulgadas (escribe `width=...` celda por celda).
  #   2. `set_table_properties(layout="autofit", width=1)` declara que
  #      la tabla ocupa el 100% del texto y respeta los anchos calculados.
  # SCOPING: solo a docx/odt. Typst (PDF) tiene su propio pipeline
  # de tablas que ya funciona y no necesita estas propiedades.
  out_fmt <- tryCatch(knitr::pandoc_to(), error = function(e) NULL)
  if (!is.null(out_fmt) && grepl("^(docx|odt)", out_fmt)) {
    message(sprintf("[ft_theme_auto] aplicando autofit para %s", out_fmt))
    ft <- flextable::autofit(ft)
    ft <- flextable::set_table_properties(ft, layout = "autofit", width = 1)
  }
  ft
}

# Force flextable tables to fit within page width and use compatible font
if (requireNamespace("flextable", quietly = TRUE)) {
  flextable::set_flextable_defaults(
    table.layout = "autofit",
    fonts_ignore = TRUE,
    theme_fun = ft_theme_auto,
    padding.top = 2,
    padding.bottom = 2
  )
}

# Helper: make wide tables compact for PDF (landscape), modern for HTML
# Trims to max_cols columns for PDF and adds a note about remaining columns
ft_wide <- function(ft, max_cols = 10) {
  all_cols <- ft$col_keys
  if (knitr::is_latex_output()) {
    # Trim columns if too many
    if (length(all_cols) > max_cols) {
      extra <- length(all_cols) - max_cols
      ft <- flextable::delete_columns(ft, j = all_cols[(max_cols + 1):length(all_cols)])
      ft <- flextable::add_footer_lines(ft,
        values = paste0(
          "Nota: se muestran ", max_cols, " de ",
          length(all_cols), " columnas disponibles."
        )
      )
      ft <- flextable::fontsize(ft, size = 7, part = "footer")
      ft <- flextable::italic(ft, part = "footer")
    }
    ft <- flextable::fontsize(ft, size = 6, part = "header")
    ft <- flextable::fontsize(ft, size = 6, part = "body")
    ft <- flextable::padding(ft,
      padding.top = 1, padding.bottom = 1,
      padding.left = 1, padding.right = 1
    )
    ft <- flextable::set_table_properties(ft, layout = "autofit")
  }
  ft
}

# ── Universal preload ──
# Hace disponible flextable() y los helpers `mat_to_ft / compmat_to_ft /
# pretty` en TODOS los chunks del libro sin que cada capítulo tenga que
# acordarse de `library(flextable)` o `source("R/figuras_helpers.R")`.
# Estos imports per-capítulo son idempotentes (no rompen nada si están
# duplicados) — los dejamos por claridad, pero esta preload garantiza
# que aunque un capítulo se olvide, las funciones siguen disponibles.
suppressPackageStartupMessages({
  if (requireNamespace("flextable", quietly = TRUE)) library(flextable)
})
local({
  # Caminar hacia arriba desde el cwd hasta encontrar _quarto.yml; desde
  # ahí sourcear R/figuras_helpers.R. No depende de paquetes externos
  # (rprojroot, here) por si .Rprofile corre antes de install.packages.
  d <- normalizePath(getwd())
  while (TRUE) {
    if (file.exists(file.path(d, "_quarto.yml"))) {
      helpers <- file.path(d, "R", "figuras_helpers.R")
      if (file.exists(helpers)) source(helpers)
      break
    }
    parent <- dirname(d)
    if (parent == d) break
    d <- parent
  }
})
