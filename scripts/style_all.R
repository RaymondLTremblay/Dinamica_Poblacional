#!/usr/bin/env Rscript
# style_all.R
# ===========
# Aplica `styler` a todo el código R del libro:
#
#  - Scripts en `scripts/*.R`
#  - Helpers en `R/*.R`
#  - `.Rprofile`
#  - Chunks R dentro de cada `*.qmd` del proyecto
#
# styler reformatea indentación, espacios alrededor de operadores
# (`x<-1` → `x <- 1`), saltos de línea y estilo de asignación SIN
# cambiar el comportamiento. Preserva comentarios `#|` de Quarto,
# texto en español y opciones de chunk.
#
# Uso:
#   Rscript scripts/style_all.R              # aplica cambios
#   Rscript scripts/style_all.R --dry        # preview de archivos que cambiarían
#
# Recomendación: commit antes de correr para que el diff sea limpio.

suppressPackageStartupMessages({
  if (!requireNamespace("styler", quietly = TRUE)) {
    stop("Instala primero: install.packages('styler')")
  }
})

# Encontrar la raíz del proyecto (mismo patrón que los otros scripts).
find_project_root <- function() {
  candidates <- character(0)
  args <- commandArgs(trailingOnly = FALSE)
  fa <- grep("^--file=", args, value = TRUE)
  if (length(fa) > 0) candidates <- c(candidates,
    tryCatch(normalizePath(dirname(sub("^--file=", "", fa[1]))),
             error = function(e) NULL))
  for (n in seq_len(sys.nframe())) {
    f <- tryCatch(sys.frame(n)$ofile, error = function(e) NULL)
    if (!is.null(f)) candidates <- c(candidates,
      tryCatch(normalizePath(dirname(f)), error = function(e) NULL))
  }
  candidates <- c(candidates, normalizePath(getwd()))
  for (start in candidates) {
    d <- start
    while (TRUE) {
      if (file.exists(file.path(d, "_quarto.yml"))) return(d)
      parent <- dirname(d); if (parent == d) break; d <- parent
    }
  }
  stop("No encontré _quarto.yml hacia arriba desde: ",
       paste(unique(candidates), collapse = ", "))
}
ROOT <- find_project_root()

# Archivos auto-generados que NO deberían ser estilizados.
SKIP_QMD <- c(
  "Apendice_Indice_Temas.qmd",
  "Apendice_Indice_Fig_Tab.qmd"
)

main <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  dry  <- "--dry" %in% args

  targets <- list()

  # R scripts en scripts/ y R/
  for (sub in c("scripts", "R")) {
    d <- file.path(ROOT, sub)
    if (dir.exists(d)) {
      targets <- c(targets, list.files(d, pattern = "\\.R$",
                                       full.names = TRUE))
    }
  }
  # .Rprofile en la raíz
  rp <- file.path(ROOT, ".Rprofile")
  if (file.exists(rp)) targets <- c(targets, rp)
  # Excluir este propio script (evita rewrite mientras corre)
  targets <- targets[!grepl("style_all\\.R$", targets)]

  # Chunks dentro de .qmd
  qmds <- list.files(ROOT, pattern = "\\.qmd$", full.names = TRUE)
  qmds <- qmds[!basename(qmds) %in% SKIP_QMD]
  targets <- c(targets, qmds)

  targets <- unique(unlist(targets))
  cat(sprintf("Archivos a procesar: %d\n", length(targets)))

  n_changed <- 0L
  for (f in targets) {
    rel <- sub(paste0("^", ROOT, "/?"), "", f)
    if (dry) {
      # En dry: copiamos a tempfile, estilizamos ahí, comparamos.
      tmp <- tempfile(fileext = paste0(".", tools::file_ext(f)))
      file.copy(f, tmp, overwrite = TRUE)
      changed <- tryCatch({
        res <- styler::style_file(tmp)
        any(res$changed)
      }, error = function(e) {
        warning(sprintf("styler falló en %s: %s", rel, conditionMessage(e)))
        FALSE
      })
      unlink(tmp)
      cat(sprintf("  %s  %s\n",
                  if (changed) "[CAMBIA]" else "[ok    ]", rel))
      if (changed) n_changed <- n_changed + 1L
    } else {
      res <- tryCatch(styler::style_file(f), error = function(e) {
        warning(sprintf("styler falló en %s: %s", rel, conditionMessage(e)))
        NULL
      })
      if (!is.null(res) && any(res$changed)) {
        cat(sprintf("  ✓ estilizado: %s\n", rel))
        n_changed <- n_changed + 1L
      }
    }
  }

  cat(sprintf("\nResumen: %d archivo(s) %s.\n",
              n_changed, if (dry) "cambiarían" else "modificados"))
  if (!dry && n_changed > 0L) {
    cat("Sugerencia: `git diff` para revisar los cambios cosméticos.\n")
  }
}

main()
