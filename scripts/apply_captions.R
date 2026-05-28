#!/usr/bin/env Rscript
# apply_captions.R
# ================
# Sustituir `#| fig-cap: "[TODO: caption]"` por la caption correspondiente
# desde un archivo JSON con mapping `{label_fig: caption_text}`.
#
# Solo se modifican chunks cuyo `#| label: fig-<L>` aparece en el JSON.
# La caption se inserta literal entre comillas dobles, escapando comillas
# dobles internas como `\"`.
#
# Uso:
#   Rscript scripts/apply_captions.R --json captions_drafted.json
#   Rscript scripts/apply_captions.R --json captions_drafted.json --dry

suppressPackageStartupMessages({
  library(stringr)
  library(jsonlite)
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

LABEL_RE <- "^(\\s*)#\\|\\s*label\\s*:\\s*([\\w.\\-]+)\\s*$"
TODO_RE <- "^(\\s*)#\\|\\s*fig-cap\\s*:\\s*\"\\[TODO: caption\\]\"\\s*$"

# Las opciones #| son YAML — escapar barras y comillas dobles.
escape_for_quoted_yaml <- function(s) {
  s |>
    str_replace_all("\\\\", "\\\\\\\\") |>
    str_replace_all("\"", "\\\\\"")
}

apply_to_file <- function(path, mapping) {
  lines <- readLines(path, warn = FALSE, encoding = "UTF-8")
  out <- lines
  current_label <- NA_character_
  n_changed <- 0L

  for (i in seq_along(lines)) {
    line <- lines[i]
    m1 <- str_match(line, LABEL_RE)
    if (!is.na(m1[1, 1])) {
      current_label <- m1[1, 3]
      next
    }
    m2 <- str_match(line, TODO_RE)
    if (!is.na(m2[1, 1]) && !is.na(current_label) &&
      current_label %in% names(mapping)) {
      indent <- m2[1, 2]
      cap <- escape_for_quoted_yaml(mapping[[current_label]])
      out[i] <- sprintf('%s#| fig-cap: "%s"', indent, cap)
      n_changed <- n_changed + 1L
    }

    # Salir del bloque de opciones cuando dejamos las líneas `#|`
    stripped <- str_trim(line)
    if (!(str_starts(stripped, "#\\|") || stripped == "")) {
      current_label <- NA_character_
    }
  }
  list(n = n_changed, lines = out)
}

main <- function() {
  args <- commandArgs(trailingOnly = TRUE)

  json_idx <- which(args == "--json")
  if (length(json_idx) == 0 || json_idx == length(args)) {
    stop("Uso: Rscript scripts/apply_captions.R --json <archivo.json> [--dry]")
  }
  json_path <- args[json_idx + 1L]
  dry <- "--dry" %in% args

  mapping <- fromJSON(json_path, simplifyVector = TRUE)
  cat(sprintf(
    "Cargadas %d captions desde %s\n",
    length(mapping), json_path
  ))

  total <- 0L
  for (qmd in CHAPTERS) {
    p <- file.path(ROOT, qmd)
    if (!file.exists(p)) next
    res <- apply_to_file(p, mapping)
    if (res$n > 0) {
      total <- total + res$n
      tag <- if (dry) "[dry]" else "✓"
      cat(sprintf("  %s %s: %d captions aplicadas\n", tag, qmd, res$n))
      if (!dry) writeLines(enc2utf8(res$lines), p, useBytes = TRUE)
    }
  }

  verb <- if (dry) "a aplicar" else "aplicadas"
  cat(sprintf("\nTotal: %d captions %s.\n", total, verb))
}

main()
