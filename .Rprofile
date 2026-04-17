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
  # Body: alternating rows
  n_rows <- flextable::nrow_part(ft, part = "body")
  if (n_rows > 0) {
    even_rows <- seq(2, n_rows, by = 2)
    if (length(even_rows) > 0) {
      ft <- flextable::bg(ft, i = even_rows, bg = "#eef5f4", part = "body")
    }
  }
  # Subtle row borders
  ft <- flextable::hline(
    ft, part = "body",
    border = officer::fp_border(color = "#d4e5e3", width = 0.5)
  )
  # Bottom border under header
  ft <- flextable::hline_bottom(
    ft, part = "header",
    border = officer::fp_border(color = "#15665b", width = 1.5)
  )
  # Bottom border under table
  ft <- flextable::hline_bottom(
    ft, part = "body",
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
        values = paste0("Nota: se muestran ", max_cols, " de ",
                        length(all_cols), " columnas disponibles."))
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
