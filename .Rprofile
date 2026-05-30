# Disable CLI hyperlinks to prevent ANSI escape codes in LaTeX output
options(
  cli.hyperlink = FALSE,
  cli.hyperlink_help = FALSE,
  cli.hyperlink_run = FALSE,
  cli.hyperlink_vignette = FALSE,
  cli.num_colors = 1
)
Sys.setenv(NO_COLOR = "1")

# ── Word-deliverable hook: ocultar líneas de "plumbing" del código mostrado ──
# En el libro en línea (HTML) estas líneas son inofensivas, pero en el .docx
# para la editora son ruido irrelevante (no aportan al lector impreso). Este
# hook de knitr las ELIMINA del código que se *muestra* solo cuando el destino
# es docx; el chunk sigue ejecutándose igual (las figuras se generan), así que
# el HTML no cambia. Cubre: source(...), ggsave(...), save_plot_png(...),
# plc_save(...), grviz_save(...). Para añadir más patrones, amplíe `noise`.
local({
  base_hook <- knitr::knit_hooks$get("source")
  knitr::knit_hooks$set(source = function(x, options) {
    if (isTRUE(tryCatch(knitr::pandoc_to("docx"), error = function(e) FALSE))) {
      x <- unlist(strsplit(paste(x, collapse = "\n"), "\n", fixed = TRUE))
      noise <- paste0(
        "^\\s*(source\\(|ggsave\\(|ggplot2::ggsave\\(|",
        "save_plot_png\\(|plc_save\\(|grviz_save\\()"
      )
      x <- x[!grepl(noise, x)]
      x <- paste(x, collapse = "\n")
    }
    base_hook(x, options)
  })
})

# ── Word-deliverable: ocultar el CÓDIGO de chunks que solo CONSTRUYEN tablas
# informativas (datos escritos a mano con tribble), no análisis. En el libro
# en línea (HTML) el código se muestra (es didáctico); en el .docx para la
# editora ese código de captura de datos es ruido — la editora solo necesita
# ver la tabla resultante. Marque tales chunks con `#| docx_hide_code: true`:
# el código se OCULTA solo en docx (echo=FALSE) pero el chunk se ejecuta igual,
# así que la tabla se renderiza. En HTML el código sigue visible/plegable.
knitr::opts_hooks$set(docx_hide_code = function(options) {
  if (isTRUE(options$docx_hide_code) &&
    isTRUE(tryCatch(knitr::pandoc_to("docx"), error = function(e) FALSE))) {
    options$echo <- FALSE
  }
  options
})

# ── Word-deliverable: ajustar figuras altas (diagramas de ciclo de vida) para
# que quepan en la página. En Word la imagen se escala al ancho de texto (6.5")
# y, por su relación de aspecto vertical, queda más alta que los 9" de alto útil
# de la página (carta, márgenes de 1") y se sale por abajo. Marque esos chunks
# con `#| docx_fit: true`: en docx se reduce el ancho mostrado al 65% (preserva
# la proporción, así la altura baja lo suficiente para caber). HTML no cambia.
knitr::opts_hooks$set(docx_fit = function(options) {
  if (isTRUE(options$docx_fit) &&
    isTRUE(tryCatch(knitr::pandoc_to("docx"), error = function(e) FALSE))) {
    options$out.width <- "65%"
  }
  options
})

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
  # Tipografía de tablas: SANS-SERIF (contrasta con el cuerpo serif y se lee
  # mejor en celdas estrechas) + cifras alineadas a la derecha en columnas
  # numéricas. Arial tiene cifras tabulares (lining) por defecto, así que los
  # dígitos quedan alineados en columna. Solo para HTML/Word; en Typst (PDF) se
  # deja la fuente del documento (Libertinus) para no romper ese pipeline.
  out_fmt <- tryCatch(knitr::pandoc_to(), error = function(e) NULL)
  if (is.null(out_fmt) || grepl("^(docx|odt|html)", out_fmt)) {
    ft <- flextable::font(ft, fontname = "Arial", part = "all")
    ft <- flextable::fontsize(ft, size = 10, part = "all")
    num_j <- which(vapply(ft$body$dataset, is.numeric, logical(1)))
    if (length(num_j)) {
      ft <- flextable::align(ft, j = num_j, align = "right", part = "all")
    }
  }
  ft
}

# ── Conditional theme: modern for HTML, booktabs for PDF ──
ft_theme_auto <- function(ft) {
  # Mostrar los valores numéricos con 4 CIFRAS SIGNIFICATIVAS en TODOS los
  # formatos. A diferencia de un número fijo de decimales, las cifras
  # significativas preservan los valores pequeños (p. ej. priores ~1e-5 del
  # capítulo bayesiano, que con 3 decimales aparecerían como 0.000). Solo afecta
  # la PRESENTACIÓN; los cálculos internos usan la precisión completa. Se aplica
  # a columnas `double`; las enteras (conteos) y de texto no se tocan.
  sig4 <- function(z) formatC(z, format = "g", digits = 4)
  num_j <- tryCatch(
    names(ft$body$dataset)[vapply(ft$body$dataset, is.double, logical(1))],
    error = function(e) character(0)
  )
  if (length(num_j)) {
    ft <- tryCatch(
      do.call(
        flextable::set_formatter,
        c(list(ft), stats::setNames(rep(list(sig4), length(num_j)), num_j))
      ),
      error = function(e) ft
    )
  }
  if (knitr::is_latex_output()) {
    ft <- flextable::theme_booktabs(ft)
  } else {
    ft <- ft_theme_modern(ft)
  }
  # En Word, `layout="autofit"` (con o sin width=1) NO basta: el algoritmo de
  # autoajuste de Word puede encoger las columnas a su ancho mínimo de contenido
  # y apilar el texto en vertical (letra por letra). La solución ROBUSTA es
  # LAYOUT FIJO con anchos de columna explícitos que SUMEN el ancho de texto de
  # la página: así Word respeta esos anchos y ENVUELVE el texto dentro de la
  # celda en vez de colapsarlo. Usamos anchos IGUALES (page_in/ncol); no
  # llamamos a autofit() porque produce un tblGrid degenerado en Word.
  # SCOPING: solo docx/odt. Typst (PDF) tiene su propio pipeline de tablas.
  out_fmt <- tryCatch(knitr::pandoc_to(), error = function(e) NULL)
  if (!is.null(out_fmt) && grepl("^(docx|odt)", out_fmt)) {
    message(sprintf("[ft_theme_auto] anchos fijos para %s", out_fmt))
    page_in <- 6.5 # ancho de texto: carta (8.5") con márgenes de 1"
    ncol <- length(ft$col_keys)
    # NO llamar a flextable::autofit() aquí: en el pipeline de Word genera un
    # tblGrid degenerado (UNA sola <w:gridCol> para una tabla de varias
    # columnas), y Word entonces apila el texto en vertical. En su lugar fijamos
    # anchos explícitos e IGUALES que suman el ancho de página: flextable emite
    # N columnas correctas y Word envuelve el texto dentro de cada celda.
    if (ncol > 0) {
      ft <- flextable::width(ft, width = page_in / ncol)
    }
    ft <- flextable::set_table_properties(ft, layout = "fixed")
  }
  ft
}

# Defaults de flextable. NB: NO fijar `table.layout = "autofit"` aquí. Ese default
# global hace que flextable RE-AUTOAJUSTE cada tabla al imprimir, sobrescribiendo
# los anchos fijos por columna que pone el tema (ft_theme_auto, rama docx) y
# generando el tblGrid degenerado de UNA columna que apila el texto en Word.
# El default propio de flextable es "fixed", que es justo lo que queremos; el
# tema fija los anchos explícitos. (Confirmado: width()+layout="fixed" sin este
# default produce columnas correctas; con él, colapsan.)
if (requireNamespace("flextable", quietly = TRUE)) {
  flextable::set_flextable_defaults(
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
