#!/usr/bin/env Rscript
# migrate_chunk_labels.R
# ======================
# Migrar chunks que producen figura del estilo de label en cabecera
# (```{r CV_2}```) al estilo Quarto (```{r}``` + `#| label: fig-CV_2`
# + `#| fig-cap: "..."`), de modo que Quarto numere las figuras
# consecutivamente en HTML/PDF/Word.
#
# Reglas:
#  * Solo se tocan chunks de R/Python que producen figura.
#  * Se respeta cualquier chunk con `eval=FALSE` / `include=FALSE` (en
#    cabecera o como opción `#|`).
#  * Se respeta cualquier chunk que YA tenga `#| label: fig-...` y
#    `#| fig-cap:` (a menos que la caption viva en `fig.cap=` del header
#    — en ese caso se migra).
#  * Si la cabecera tiene `fig.cap='...'`, se migra a `#| fig-cap: "..."`.
#  * Si la cabecera tiene un label `foo`, se inserta `#| label: fig-foo`
#    (el prefijo `fig-` se añade sólo si no estaba ya).
#  * Se preservan las opciones restantes en la cabecera.
#
# Uso:
#   Rscript scripts/migrate_chunk_labels.R --dry          # preview
#   Rscript scripts/migrate_chunk_labels.R --dry --file 103-Ciclos_de_Vida.qmd
#   Rscript scripts/migrate_chunk_labels.R                # aplica cambios

suppressPackageStartupMessages({
  library(stringr)
})

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

CHUNK_START_RE <- "^```\\{(r|python)([\\s,]+(.*?))?\\}\\s*$"

CHAPTERS <- c(
  "index.qmd", "102-Intro.qmd", "103-Ciclos_de_Vida.qmd",
  "104-Recopilacion_datos_en_el_campo.qmd", "105-Transiciones.qmd",
  "106-calcular_fecundidad.qmd", "107-matU_matF_matC.qmd",
  "108-Bayesian_PPM.qmd", "109-Crecimiento_poblacional.qmd",
  "110-Propriedades.qmd", "111-Elasticidad.qmd",
  "112-Dinamica_de_Transiciones.qmd",
  "113-Funciones_de_Transferencia.qmd", "114-LTRE.qmd",
  "115-Metodos_de_simulaciones.qmd", "117_Historia_breve.qmd",
  "118-Carl_Olaf_Tamm.qmd", "119-COMPADRE_ORCHIDS.qmd",
  "120-Rage_orquideas.qmd",
  "121-Traduccion_protocolo_informacion.qmd",
  "122-Impacto_de_Datos_sin_Sentido.qmd",
  "123-Conclusion.qmd"
)

any_fixed <- function(haystack, needles) {
  any(vapply(
    needles, function(n) str_detect(haystack, fixed(n)),
    logical(1)
  ))
}

# Dividir la lista de argumentos de la cabecera respetando paréntesis y comillas.
split_header_args <- function(args_str) {
  parts <- character(0)
  cur <- ""
  depth <- 0L
  in_str <- ""
  for (ch in strsplit(args_str, "", fixed = TRUE)[[1]]) {
    if (nzchar(in_str)) {
      cur <- paste0(cur, ch)
      if (ch == in_str) in_str <- ""
      next
    }
    if (ch %in% c("'", '"')) {
      in_str <- ch
      cur <- paste0(cur, ch)
      next
    }
    if (ch == "(") {
      depth <- depth + 1L
      cur <- paste0(cur, ch)
      next
    }
    if (ch == ")") {
      depth <- depth - 1L
      cur <- paste0(cur, ch)
      next
    }
    if (ch == "," && depth == 0L) {
      parts <- c(parts, str_trim(cur))
      cur <- ""
      next
    }
    cur <- paste0(cur, ch)
  }
  if (nzchar(str_trim(cur))) parts <- c(parts, str_trim(cur))

  label <- NA_character_
  rest <- character(0)
  for (i in seq_along(parts)) {
    tok <- parts[i]
    if (i == 1L && !str_detect(tok, "=") && !str_detect(tok, ":") &&
      str_detect(tok, "^[a-zA-Z_][a-zA-Z0-9_.\\-]*$")) {
      label <- tok
    } else {
      rest <- c(rest, tok)
    }
  }
  list(label = label, rest = rest)
}

extract_figcap_from_args <- function(args_vec) {
  cap <- NA_character_
  out <- character(0)
  for (a in args_vec) {
    m <- str_match(a, "^fig\\.cap\\s*=\\s*['\"](.+?)['\"]\\s*$")
    if (!is.na(m[1, 1])) cap <- m[1, 2] else out <- c(out, a)
  }
  list(cap = cap, rest = out)
}

is_figure_chunk <- function(body_text, opt_lines, skip) {
  if (skip) {
    return(FALSE)
  }
  no_cmts <- str_replace_all(body_text, "#[^\\n]*", "")
  ((any_fixed(no_cmts, FIGURE_CALLS) ||
    any_fixed(body_text, SCRIPT_SAVES) ||
    any_fixed(body_text, WIDGET_CALLS)) &&
    !any_fixed(no_cmts, TABLE_CALLS))
}

existing_opt <- function(opt_lines, key) {
  pat <- sprintf("#\\|\\s*%s\\s*:\\s*(.*)$", gsub("\\.", "\\\\.", key))
  for (ol in opt_lines) {
    m <- str_match(str_trim(ol), pat)
    if (!is.na(m[1, 1])) {
      return(str_trim(m[1, 2]))
    }
  }
  NA_character_
}

migrate_file <- function(path) {
  lines <- readLines(path, warn = FALSE, encoding = "UTF-8")
  out <- character(0)
  i <- 1L
  n <- length(lines)
  n_modified <- 0L

  while (i <= n) {
    line <- lines[i]
    m <- str_match(line, CHUNK_START_RE)
    if (is.na(m[1, 1])) {
      out <- c(out, line)
      i <- i + 1L
      next
    }

    chunk_start <- i
    chunk_lang <- m[1, 2]
    chunk_args <- if (is.na(m[1, 4])) "" else str_trim(m[1, 4])
    opt_lines <- character(0)
    j <- i + 1L
    while (j <= n && str_detect(lines[j], "^\\s*#\\|")) {
      opt_lines <- c(opt_lines, lines[j])
      j <- j + 1L
    }
    body_start <- j
    while (j <= n && str_trim(lines[j]) != "```") j <- j + 1L
    chunk_end <- j
    body <- if (body_start <= chunk_end - 1L) lines[body_start:(chunk_end - 1L)] else character(0)
    body_str <- paste(body, collapse = "\n")

    skip <- any(str_detect(
      opt_lines,
      "#\\|\\s*(eval|include)\\s*:\\s*(false|FALSE|F)\\b"
    ))
    if (str_detect(chunk_args, "\\b(eval|include)\\s*=\\s*(FALSE|F)\\b")) skip <- TRUE

    if (!is_figure_chunk(body_str, opt_lines, skip)) {
      out <- c(out, lines[chunk_start:chunk_end])
      i <- chunk_end + 1L
      next
    }

    opt_label <- existing_opt(opt_lines, "label")
    opt_cap <- existing_opt(opt_lines, "fig-cap")
    sp <- split_header_args(chunk_args)
    fc <- extract_figcap_from_args(sp$rest)
    header_lbl <- sp$label
    header_cap <- fc$cap
    rest_args <- fc$rest

    already_fig_lbl <- (!is.na(opt_label) && startsWith(opt_label, "fig-")) ||
      (!is.na(header_lbl) && startsWith(header_lbl, "fig-"))
    already_any_cap <- !is.na(opt_cap) || !is.na(header_cap)

    if (already_fig_lbl && already_any_cap && is.na(header_cap)) {
      out <- c(out, lines[chunk_start:chunk_end])
      i <- chunk_end + 1L
      next
    }

    base_label <- if (!is.na(opt_label)) {
      opt_label
    } else if (!is.na(header_lbl)) {
      header_lbl
    } else {
      NA_character_
    }

    new_label <- if (!is.na(base_label)) {
      paste0("fig-", str_replace(base_label, "^fig-", ""))
    } else {
      stem <- str_split(tools::file_path_sans_ext(basename(path)), "-")[[1]][1]
      sprintf("fig-%s-%d", stem, chunk_start)
    }

    new_cap <- if (!is.na(opt_cap)) {
      opt_cap
    } else if (!is.na(header_cap)) {
      header_cap
    } else {
      "[TODO: caption]"
    }

    new_header <- if (length(rest_args) > 0) {
      sprintf("```{%s, %s}", chunk_lang, paste(rest_args, collapse = ", "))
    } else {
      sprintf("```{%s}", chunk_lang)
    }

    new_opts <- c(
      sprintf("#| label: %s", new_label),
      sprintf('#| fig-cap: "%s"', str_replace_all(new_cap, '"', '\\\\"'))
    )
    # Conservar las opciones existentes salvo label/fig-cap.
    for (ol in opt_lines) {
      if (str_detect(ol, "^\\s*#\\|\\s*label\\s*:") ||
        str_detect(ol, "^\\s*#\\|\\s*fig-cap\\s*:")) {
        next
      }
      new_opts <- c(new_opts, ol)
    }

    out <- c(out, new_header, new_opts, body, lines[chunk_end])
    i <- chunk_end + 1L
    n_modified <- n_modified + 1L
  }

  list(n = n_modified, lines = out)
}

main <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  dry <- "--dry" %in% args
  one <- {
    idx <- which(args == "--file")
    if (length(idx) == 1L && idx < length(args)) args[idx + 1L] else NULL
  }

  total <- 0L
  files <- if (!is.null(one)) one else CHAPTERS
  for (qmd in files) {
    p <- file.path(ROOT, qmd)
    if (!file.exists(p)) next
    res <- migrate_file(p)
    if (res$n > 0) {
      total <- total + res$n
      if (dry) {
        cat(sprintf("  [dry] %s: %d chunks a migrar\n", qmd, res$n))
      } else {
        writeLines(enc2utf8(res$lines), p, useBytes = TRUE)
        cat(sprintf("  ✓ %s: %d chunks migrados\n", qmd, res$n))
      }
    } else if (dry) {
      cat(sprintf("  [dry] %s: 0 (nada que hacer)\n", qmd))
    }
  }
  verb <- if (dry) "a migrar" else "migrados"
  cat(sprintf("\nTotal: %d chunks %s.\n", total, verb))
}

main()
