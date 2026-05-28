#!/usr/bin/env Rscript
# audit_fig_captions.R
# ====================
# Auditar la cobertura de `fig-cap` y `label: fig-*` en chunks que
# producen figuras.
#
# Quarto numera las figuras automáticamente sólo cuando el chunk lleva
# TANTO `#| fig-cap: "..."` como un label con prefijo `fig-`
# (p. ej., `#| label: fig-curva`). Cuando falta alguno, la figura sale
# sin número en el HTML/PDF/Word — lo que rompe la numeración
# consecutiva que espera el editor.
#
# Uso:
#   Rscript scripts/audit_fig_captions.R
#   Rscript scripts/audit_fig_captions.R --md  # genera Figuras_Captions_Audit.md

suppressPackageStartupMessages({
  library(stringr)
})

# ---- Determinar raíz del proyecto ----
find_project_root <- function() {
  candidates <- character(0)
  args <- commandArgs(trailingOnly = FALSE)
  fa <- grep("^--file=", args, value = TRUE)
  if (length(fa) > 0) {
    candidates <- c(
      candidates,
      tryCatch(normalizePath(dirname(sub("^--file=", "", fa[1]))),
        error = function(e) NULL
      )
    )
  }
  for (n in seq_len(sys.nframe())) {
    f <- tryCatch(sys.frame(n)$ofile, error = function(e) NULL)
    if (!is.null(f)) {
      candidates <- c(
        candidates,
        tryCatch(normalizePath(dirname(f)), error = function(e) NULL)
      )
    }
  }
  candidates <- c(candidates, normalizePath(getwd()))
  for (start in candidates) {
    d <- start
    while (TRUE) {
      if (file.exists(file.path(d, "_quarto.yml"))) {
        return(d)
      }
      parent <- dirname(d)
      if (parent == d) break
      d <- parent
    }
  }
  stop(
    "No encontré _quarto.yml hacia arriba desde: ",
    paste(unique(candidates), collapse = ", ")
  )
}
ROOT <- find_project_root()
MD_OUT <- file.path(ROOT, "Figuras_Captions_Audit.md")

# ---- Listas de detección (sincronizadas con collect_figures.py) ----
FIGURE_CALLS <- c(
  "ggplot(", "plot(", "barplot(", "hist(", "boxplot(", "image(",
  "contour(", "persp(", "pairs(", "matplot(", "curve(", "autoplot(",
  "ggarrange(", "grid.arrange(", "plot_grid(", "stage.vector.plot(",
  "image.plot("
)
SCRIPT_SAVES <- c(
  "ggsave(", "render_dual(", "plc_save(", "grviz_save(",
  "save_plot_png("
)
WIDGET_CALLS <- c("plot_life_cycle(", "grViz(")
TABLE_CALLS <- c("flextable(", "kable(", "gt(", "datatable(", "huxtable(")

CHUNK_START_RE <- "^```\\{(r|python)([\\s,]+(.*))?\\}"

CHAPTERS <- c(
  "index.qmd", "102-Intro.qmd", "103-Ciclos_de_Vida.qmd",
  "104-Recopilacion_datos_en_el_campo.qmd", "105-Transiciones.qmd",
  "106-calcular_fecundidad.qmd", "107-matU_matF_matC.qmd",
  "108-Bayesian_PPM.qmd", "109-Crecimiento_poblacional.qmd",
  "110-Propriedades.qmd", "111-Elasticidad.qmd",
  "112-Dinamica_de_Transiciones.qmd", "113-Funciones_de_Transferencia.qmd",
  "114-LTRE.qmd", "115-Metodos_de_simulaciones.qmd",
  "117_Historia_breve.qmd", "118-Carl_Olaf_Tamm.qmd",
  "119-COMPADRE_ORCHIDS.qmd", "120-Rage_orquideas.qmd",
  "121-Traduccion_protocolo_informacion.qmd",
  "122-Impacto_de_Datos_sin_Sentido.qmd", "123-Conclusion.qmd",
  "Appendix_A_Species_List.qmd", "Appendix_B_Hoja_de_datos.qmd",
  "Appendix_C_Datos.qmd"
)

# ---- Utilidades ----
any_fixed <- function(haystack, needles) {
  any(vapply(
    needles, function(n) str_detect(haystack, fixed(n)),
    logical(1)
  ))
}

extract_chunk_label <- function(header_line) {
  m <- str_match(str_trim(header_line), CHUNK_START_RE)
  if (is.na(m[1, 1])) {
    return(NA_character_)
  }
  rest <- ifelse(is.na(m[1, 4]), "", m[1, 4])
  tokens <- str_trim(str_split(rest, ",")[[1]])
  for (tok in tokens) {
    if (!nzchar(tok) || str_detect(tok, "=") || str_detect(tok, ":")) next
    if (str_detect(tok, "^[a-zA-Z_][a-zA-Z0-9_.\\-]*$")) {
      return(tok)
    }
  }
  NA_character_
}

audit_chapter <- function(qmd_path) {
  if (!file.exists(qmd_path)) {
    return(list())
  }
  lines <- readLines(qmd_path, warn = FALSE, encoding = "UTF-8")
  rows <- list()

  in_chunk <- FALSE
  chunk_start <- 0L
  chunk_label <- NA_character_
  header_options <- character(0)
  chunk_code <- character(0)
  skip <- FALSE

  for (i in seq_along(lines)) {
    line <- lines[i]
    stripped <- str_trim(line)

    if (!in_chunk) {
      if (str_detect(stripped, CHUNK_START_RE)) {
        in_chunk <- TRUE
        chunk_start <- i
        chunk_label <- extract_chunk_label(stripped)
        header_options <- character(0)
        chunk_code <- character(0)
        # eval/include = FALSE en cabecera del chunk
        skip <- str_detect(
          stripped,
          "\\b(eval|include)\\s*=\\s*(FALSE|F)\\b"
        )
      }
      next
    }

    if (stripped == "```") {
      if (!skip) {
        joined <- paste(chunk_code, collapse = "\n")
        joined_no_cmts <- str_replace_all(joined, "#[^\\n]*", "")
        has_fig_call <- any_fixed(joined_no_cmts, FIGURE_CALLS)
        has_script_save <- any_fixed(joined, SCRIPT_SAVES)
        has_widget <- any_fixed(joined, WIDGET_CALLS)
        has_table <- any_fixed(joined_no_cmts, TABLE_CALLS)
        is_figure <- (has_fig_call || has_script_save || has_widget) &&
          !has_table

        if (is_figure) {
          has_cap <- any(str_detect(
            header_options,
            "#\\|\\s*fig-cap\\s*:\\s*(.+)"
          ))
          opt_labels <- character(0)
          for (l in header_options) {
            m <- str_match(l, "#\\|\\s*label\\s*:\\s*([\\w.\\-]+)")
            if (!is.na(m[1, 1])) opt_labels <- c(opt_labels, m[1, 2])
          }
          has_fig_lbl <- (!is.na(chunk_label) && startsWith(chunk_label, "fig-")) ||
            any(startsWith(opt_labels, "fig-"))

          snippet <- ""
          for (ln in chunk_code) {
            if (any_fixed(ln, c(FIGURE_CALLS, SCRIPT_SAVES, WIDGET_CALLS))) {
              snippet <- substr(str_trim(ln), 1, 120)
              break
            }
          }
          label_to_use <- if (!is.na(chunk_label)) {
            chunk_label
          } else if (length(opt_labels) > 0) {
            opt_labels[1]
          } else {
            NA_character_
          }

          rows[[length(rows) + 1L]] <- list(
            line          = chunk_start,
            label         = label_to_use,
            has_cap       = has_cap,
            has_fig_label = has_fig_lbl,
            snippet       = snippet
          )
        }
      }
      in_chunk <- FALSE
      next
    }

    if (str_detect(line, "^\\s*#\\|")) {
      header_options <- c(header_options, line)
      if (str_detect(line, "#\\|\\s*(eval|include)\\s*:\\s*(false|FALSE|F)\\b")) {
        skip <- TRUE
      }
    } else {
      chunk_code <- c(chunk_code, line)
    }
  }
  rows
}

main <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  want_md <- "--md" %in% args

  summary_list <- list()
  total_fig <- 0
  total_ok <- 0
  total_no_cap <- 0
  total_no_label <- 0
  total_nothing <- 0
  details_per_chap <- list()

  for (qmd_name in CHAPTERS) {
    qmd <- file.path(ROOT, qmd_name)
    rows <- audit_chapter(qmd)
    if (length(rows) == 0) next

    ok <- sum(vapply(rows, function(r) r$has_cap && r$has_fig_label, logical(1)))
    no_cap <- sum(vapply(rows, function(r) !r$has_cap && r$has_fig_label, logical(1)))
    no_lbl <- sum(vapply(rows, function(r) r$has_cap && !r$has_fig_label, logical(1)))
    nothing <- sum(vapply(rows, function(r) !r$has_cap && !r$has_fig_label, logical(1)))

    summary_list[[length(summary_list) + 1L]] <- list(
      qmd = qmd_name, total = length(rows),
      ok = ok, no_cap = no_cap, no_label = no_lbl, nothing = nothing
    )
    details_per_chap[[qmd_name]] <- rows
    total_fig <- total_fig + length(rows)
    total_ok <- total_ok + ok
    total_no_cap <- total_no_cap + no_cap
    total_no_label <- total_no_label + no_lbl
    total_nothing <- total_nothing + nothing
  }

  cat("\n=== Auditoría de captions y labels (figuras de script) ===\n\n")
  cat(sprintf("Total chunks que producen figura: %d\n", total_fig))
  cat(sprintf("  ✓ fig-cap + label fig-* :     %d\n", total_ok))
  cat(sprintf("  ⚠ con label, sin fig-cap:    %d\n", total_no_cap))
  cat(sprintf("  ⚠ con fig-cap, sin label:    %d\n", total_no_label))
  cat(sprintf("  ✗ sin ninguno:               %d\n\n", total_nothing))
  cat(sprintf("%-48s OK  ⚠cap  ⚠lbl  ✗nada\n", "Capítulo"))
  for (s in summary_list) {
    cat(sprintf(
      "  %-46s %3d  %4d  %4d  %4d\n",
      s$qmd, s$ok, s$no_cap, s$no_label, s$nothing
    ))
  }

  if (want_md) {
    lines <- c(
      "# Auditoría de `fig-cap` y `label: fig-*`",
      "",
      paste0(
        "Quarto numera figuras consecutivamente sólo cuando un chunk ",
        "de R/Python que produce figura lleva **tanto** ",
        "`#| fig-cap: \"...\"` **como** `#| label: fig-...`. ",
        "Este reporte lista los chunks que no cumplen ese criterio."
      ),
      "",
      "## Resumen",
      "",
      sprintf("- Total chunks con figura: **%d**", total_fig),
      sprintf("- ✓ con cap+label: **%d**", total_ok),
      sprintf("- ⚠ con label pero sin fig-cap: **%d**", total_no_cap),
      sprintf("- ⚠ con fig-cap pero sin label fig-*: **%d**", total_no_label),
      sprintf("- ✗ sin ninguno: **%d**", total_nothing),
      ""
    )

    for (qmd_name in names(details_per_chap)) {
      rows <- details_per_chap[[qmd_name]]
      bad <- Filter(function(r) !(r$has_cap && r$has_fig_label), rows)
      if (length(bad) == 0) next
      lines <- c(
        lines, sprintf("## %s", qmd_name), "",
        "| Línea | Label | fig-cap | fig-label | Snippet |",
        "|------:|-------|:-------:|:---------:|---------|"
      )
      for (r in bad) {
        cap <- if (r$has_cap) "✓" else "—"
        lbl <- if (r$has_fig_label) "✓" else "—"
        snippet <- str_replace_all(r$snippet, "\\|", "\\\\|")
        label <- if (is.na(r$label)) "(sin label)" else r$label
        lines <- c(lines, sprintf(
          "| %d | `%s` | %s | %s | `%s` |",
          r$line, label, cap, lbl, snippet
        ))
      }
      lines <- c(lines, "")
    }
    writeLines(enc2utf8(lines), MD_OUT, useBytes = TRUE)
    cat(sprintf("\nReporte MD: %s\n", basename(MD_OUT)))
  }
}

main()
