# Disable CLI hyperlinks to prevent ANSI escape codes in LaTeX output
options(
  cli.hyperlink = FALSE,
  cli.hyperlink_help = FALSE,
  cli.hyperlink_run = FALSE,
  cli.hyperlink_vignette = FALSE,
  cli.num_colors = 1
)
Sys.setenv(NO_COLOR = "1")

# Force flextable tables to fit within page width
if (requireNamespace("flextable", quietly = TRUE)) {
  flextable::set_flextable_defaults(
    table.layout = "fixed"
  )
}
