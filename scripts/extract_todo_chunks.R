#!/usr/bin/env Rscript
# extract_todo_chunks.R
# =====================
# Extraer chunks con `#| fig-cap: "[TODO: caption]"` y su código R
# para alimentar el drafting de captions.
#
# Salida: JSON con estructura:
# [
#   {
#     "chapter": "103-Ciclos_de_Vida.qmd",
#     "label":   "fig-CV_2",
#     "line":    139,
#     "code":    "...código R del chunk..."
#   },
#   ...
# ]
#
# Uso:
#   Rscript scripts/extract_todo_chunks.R

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
OUT_JSON <- file.path(ROOT, "captions_todo.json")

CHUNK_START <- "^```\\{(r|python)([\\s,]+(.*?))?\\}\\s*$"
TODO_CAP <- "#\\|\\s*fig-cap\\s*:\\s*\"\\[TODO: caption\\]\""
LABEL_OPT <- "#\\|\\s*label\\s*:\\s*([\\w.\\-]+)"

CHAPTERS <- c(
  "102-Intro.qmd", "103-Ciclos_de_Vida.qmd",
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

extract_chapter <- function(path) {
  lines <- readLines(path, warn = FALSE, encoding = "UTF-8")
  out <- list()
  i <- 1L
  n <- length(lines)

  while (i <= n) {
    if (str_detect(str_trim(lines[i]), CHUNK_START)) {
      chunk_start <- i
      j <- i + 1L
      opts <- character(0)
      while (j <= n && str_detect(lines[j], "^\\s*#\\|")) {
        opts <- c(opts, lines[j])
        j <- j + 1L
      }
      body_start <- j
      while (j <= n && str_trim(lines[j]) != "```") j <- j + 1L
      body <- if (body_start <= j - 1L) lines[body_start:(j - 1L)] else character(0)

      has_todo <- any(str_detect(opts, TODO_CAP))
      if (has_todo) {
        label <- NA_character_
        for (o in opts) {
          m <- str_match(o, LABEL_OPT)
          if (!is.na(m[1, 1])) {
            label <- m[1, 2]
            break
          }
        }
        out[[length(out) + 1L]] <- list(
          chapter = basename(path),
          label   = label,
          line    = chunk_start,
          code    = str_trim(paste(body, collapse = "\n"))
        )
      }
      i <- j + 1L
    } else {
      i <- i + 1L
    }
  }
  out
}

main <- function() {
  rows <- list()
  for (qmd in CHAPTERS) {
    p <- file.path(ROOT, qmd)
    if (!file.exists(p)) next
    rows <- c(rows, extract_chapter(p))
  }

  # Escribir JSON (auto_unbox para que ints/strings salgan sin []).
  json_text <- toJSON(rows,
    auto_unbox = TRUE, pretty = TRUE,
    na = "null"
  )
  writeLines(enc2utf8(json_text), OUT_JSON, useBytes = TRUE)

  cat(sprintf(
    "Extraídos %d chunks con [TODO: caption] → %s\n",
    length(rows), basename(OUT_JSON)
  ))

  by_chap <- table(vapply(rows, function(r) r$chapter, character(1)))
  for (c in sort(names(by_chap))) {
    cat(sprintf("  %s: %d\n", c, by_chap[[c]]))
  }
}

main()
