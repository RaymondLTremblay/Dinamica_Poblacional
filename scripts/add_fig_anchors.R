#!/usr/bin/env Rscript
# add_fig_anchors.R
# =================
# Añadir un anclaje `{#fig-<slug>}` a cada imagen markdown estática
# (`![alt](src)` o `![alt](src){attrs}`) que aún no tenga uno. Sin el
# anclaje, Quarto no asigna número a la figura — y la entrega al editor
# (figuras_editor/) no puede mapearse al número de figura del libro.
#
# Reglas:
#  - Solo se procesan imágenes con texto alt no vacío (sin caption Quarto
#    no la renderiza como figura numerada de todos modos).
#  - El slug se deriva del nombre del archivo de la imagen, en kebab-case
#    ASCII. Se garantiza unicidad a nivel libro contra anclajes y labels
#    `fig-*` existentes (chunks y otras imágenes).
#  - Si la imagen ya tiene `{...}` attrs, se inserta `#fig-<slug>` dentro;
#    si no, se añade `{#fig-<slug>}` al final.
#
# Uso:
#   Rscript scripts/add_fig_anchors.R           # aplica cambios
#   Rscript scripts/add_fig_anchors.R --dry     # solo reporta

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
  "122-Impacto_de_Datos_sin_Sentido.qmd", "123-Conclusion.qmd",
  "Appendix_A_Species_List.qmd", "Appendix_B_Hoja_de_datos.qmd",
  "Appendix_C_Datos.qmd", "Apendice_Glosario.qmd", "Agradecimientos.qmd"
)

IMG_RE <- "(!\\[[^\\]]*\\])\\(([^\\)]+)\\)(\\{[^}]*\\})?"

slugify <- function(s) {
  s <- tolower(s)
  s <- str_replace_all(s, "[^a-z0-9]+", "-")
  s <- str_replace_all(s, "^-+|-+$", "")
  if (!nzchar(s)) "img" else s
}

# Recolectar anclajes y labels existentes (para evitar colisiones).
collect_existing_slugs <- function() {
  existing <- character(0)
  for (qmd in CHAPTERS) {
    p <- file.path(ROOT, qmd)
    if (!file.exists(p)) next
    txt <- paste(readLines(p, warn = FALSE, encoding = "UTF-8"),
      collapse = "\n"
    )
    m1 <- str_extract_all(txt, "#fig-[\\w-]+")[[1]]
    if (length(m1)) existing <- c(existing, sub("^#fig-", "", m1))
    # chunk option labels: #| label: fig-...
    m2 <- str_match_all(
      txt,
      "(?m)^\\s*#\\|\\s*label\\s*:\\s*fig-([\\w.\\-]+)"
    )[[1]]
    if (nrow(m2)) existing <- c(existing, m2[, 2])
  }
  unique(existing)
}

# Genera un slug único basado en el stem del archivo.
make_unique_slug <- function(file_src, existing) {
  stem <- tools::file_path_sans_ext(basename(file_src))
  base <- slugify(stem)
  slug <- base
  i <- 1L
  while (slug %in% existing) {
    slug <- paste0(base, "-", i)
    i <- i + 1L
  }
  slug
}

# Reescribir una línea: sustituye cada imagen sin anclaje añadiendo uno.
# Devuelve list(line=..., added=integer slugs añadidos en esta línea).
rewrite_line <- function(line, existing_env) {
  hits <- str_locate_all(line, IMG_RE)[[1]]
  if (nrow(hits) == 0) {
    return(list(line = line, added = 0L))
  }

  matches <- str_match_all(line, IMG_RE)[[1]]
  if (nrow(matches) == 0) {
    return(list(line = line, added = 0L))
  }

  # Construir nueva línea desde piezas (en orden).
  pieces <- list()
  cursor <- 1L
  added <- 0L
  for (k in seq_len(nrow(hits))) {
    start <- hits[k, "start"]
    end <- hits[k, "end"]
    if (cursor < start) pieces[[length(pieces) + 1L]] <- substr(line, cursor, start - 1L)

    altpart <- matches[k, 2] # ![alt]
    src <- matches[k, 3] # path
    attrs <- if (is.na(matches[k, 4])) "" else matches[k, 4]
    full <- substr(line, start, end)

    skip <- FALSE
    if (startsWith(src, "`") || str_detect(src, "\\{\\{")) skip <- TRUE
    if (str_detect(attrs, "#fig-[\\w-]+")) skip <- TRUE
    # alt vacío → no se renderiza como figura → no anclar
    alt <- substr(altpart, 3, nchar(altpart) - 1L)
    if (!nzchar(str_trim(alt))) skip <- TRUE

    if (skip) {
      pieces[[length(pieces) + 1L]] <- full
    } else {
      slug <- make_unique_slug(src, existing_env$set)
      existing_env$set <- c(existing_env$set, slug)
      new_attrs <- if (nzchar(attrs)) {
        # insertar dentro de las attrs existentes
        inner <- str_trim(substr(attrs, 2, nchar(attrs) - 1L))
        if (nzchar(inner)) {
          paste0("{", inner, " #fig-", slug, "}")
        } else {
          paste0("{#fig-", slug, "}")
        }
      } else {
        paste0("{#fig-", slug, "}")
      }
      new_full <- paste0(altpart, "(", src, ")", new_attrs)
      pieces[[length(pieces) + 1L]] <- new_full
      added <- added + 1L
    }
    cursor <- end + 1L
  }
  if (cursor <= nchar(line)) pieces[[length(pieces) + 1L]] <- substr(line, cursor, nchar(line))
  list(line = paste0(unlist(pieces), collapse = ""), added = added)
}

main <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  dry <- "--dry" %in% args

  existing_env <- new.env(parent = emptyenv())
  existing_env$set <- collect_existing_slugs()
  cat(sprintf("Slugs existentes detectados: %d\n", length(existing_env$set)))

  total <- 0L
  for (qmd in CHAPTERS) {
    p <- file.path(ROOT, qmd)
    if (!file.exists(p)) next
    lines <- readLines(p, warn = FALSE, encoding = "UTF-8")
    n_added <- 0L
    out <- character(length(lines))
    for (i in seq_along(lines)) {
      res <- rewrite_line(lines[i], existing_env)
      out[i] <- res$line
      n_added <- n_added + res$added
    }
    if (n_added > 0L) {
      total <- total + n_added
      cat(sprintf(
        "  %s %s: +%d anclajes\n",
        if (dry) "[dry]" else "✓", qmd, n_added
      ))
      if (!dry) writeLines(enc2utf8(out), p, useBytes = TRUE)
    }
  }
  cat(sprintf(
    "\nTotal anclajes %s: %d\n",
    if (dry) "a añadir" else "añadidos", total
  ))
}

main()
