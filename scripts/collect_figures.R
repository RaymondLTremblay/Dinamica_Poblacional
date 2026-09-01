#!/usr/bin/env Rscript
# collect_figures.R
# =================
# Recolecta TODAS las figuras del libro "Introducción a la Dinámica
# Poblacional de Orquídeas" en una estructura por capítulo numerado,
# con figuras prefijadas por su **número de figura** según Quarto
# (`Fig_X.Y_<archivo>`), donde:
#
#   - `X` es el número de capítulo (o letra para apéndices: A, B, C...).
#   - `Y` es la posición ordinal dentro del capítulo.
#
# Después de cada `quarto render`, este script genera:
#
#   figuras_editor/
#   ├── 01-Introduccion/
#   │   ├── Fig_1.1_Tolumnia_variegata_Tremblay.jpeg
#   │   ├── Fig_1.2_Demografia_de_una_poblacion.jpg
#   │   └── ...
#   ├── 02-Ciclos_de_Vida/
#   │   ├── Fig_2.1_Orchis_purpurea_1_Hans_Jacquemyn.jpg
#   │   ├── Fig_2.2_CV_2.png  (+ .pdf)
#   │   └── ...
#   ├── ApA-Lista_especies/
#   │   ├── Fig_A.1_...
#   │   └── ...
#   └── ...
#
# Para figuras generadas por chunks R con `dev=[png,pdf]` o por los
# helpers (save_plot_png/plc_save/grviz_save/render_dual), copia tanto
# el .png como el .pdf vectorial sibling. Si solo existe .png (ggsave
# directo), intenta envolverlo en PDF usando el paquete `magick`.
#
# También genera/actualiza:
#  - Figuras_Inventario.csv  — tabla con todas las figuras y su ubicación.
#  - Figuras_Manifiesto.md   — reporte legible para el editor.
#
# Uso:
#   Rscript scripts/collect_figures.R              # silencioso
#   Rscript scripts/collect_figures.R --verbose    # detalles de warnings
#   Rscript scripts/collect_figures.R --audit      # no copia, solo reporta

suppressPackageStartupMessages({
  library(stringr)
})

# magick es opcional: se usa solo como fallback PNG→PDF cuando no hay
# sibling .pdf disponible (caso típico: `ggsave()` directo a PNG).
HAS_MAGICK <- requireNamespace("magick", quietly = TRUE)

# ---- Ubicaciones ----
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
DEST <- file.path(ROOT, "figuras_editor")
DOCS <- file.path(ROOT, "docs")
IMAGES <- file.path(ROOT, "images")
CSV_PATH <- file.path(ROOT, "Figuras_Inventario.csv")
MD_PATH <- file.path(ROOT, "Figuras_Manifiesto.md")

# ---- Mapeo qmd → directorio destino ----
# IMPORTANTE: el número que abre cada etiqueta ES el número de capítulo que
# Quarto asigna, y de él se derivan tanto el nombre de la carpeta como el
# prefijo `Fig_X.Y`. Por eso esta lista sigue el orden de `_quarto.yml`, NO el
# orden alfabético de los archivos .qmd.
#
# Dos detalles que provocaron un error de etiquetado en la entrega de julio de
# 2026 (carpetas desfasadas en uno, y rotas a partir de la 15):
#   1. `index.qmd` SÍ recibe número: lleva `title:` en su YAML, así que es el
#      capítulo 1 y todo lo demás corre a partir del 2.
#   2. La parte «Historia» se declara al final de `_quarto.yml`, de modo que
#      117_Historia_breve y 118-Carl_Olaf_Tamm son los capítulos 21 y 22,
#      aunque sus nombres de archivo los ordenen antes alfabéticamente.
#
# Al añadir un capítulo, insértalo en la posición que ocupa en `_quarto.yml` y
# renumera las etiquetas siguientes.
CHAPTERS <- list(
  c("index.qmd", "01-Preliminares"),
  c("102-Intro.qmd", "02-Introduccion"),
  c("103-Ciclos_de_Vida.qmd", "03-Ciclos_de_Vida"),
  c("104-Recopilacion_datos_en_el_campo.qmd", "04-Recopilacion_datos_en_el_campo"),
  c("105-Transiciones.qmd", "05-Transiciones"),
  c("106-calcular_fecundidad.qmd", "06-Fecundidad"),
  c("107-matU_matF_matC.qmd", "07-matU_matF_matC"),
  c("108-Bayesian_PPM.qmd", "08-Bayesian_PPM"),
  c("109-Crecimiento_poblacional.qmd", "09-Crecimiento_poblacional"),
  c("110-Propriedades.qmd", "10-Propiedades"),
  c("111-Elasticidad.qmd", "11-Elasticidad"),
  c("112-Dinamica_de_Transiciones.qmd", "12-Dinamica_transitoria"),
  c("113-Funciones_de_Transferencia.qmd", "13-Funciones_de_Transferencia"),
  c("114-LTRE.qmd", "14-LTRE"),
  c("115-Metodos_de_simulaciones.qmd", "15-Metodos_de_simulaciones"),
  c("119-COMPADRE_ORCHIDS.qmd", "16-COMPADRE"),
  c("120-Rage_orquideas.qmd", "17-Rage"),
  c("121-Traduccion_protocolo_informacion.qmd", "18-Protocolo"),
  c("122-Impacto_de_Datos_sin_Sentido.qmd", "19-Datos_sin_sentido"),
  c("123-Conclusion.qmd", "20-Conclusion"),
  c("117_Historia_breve.qmd", "21-Historia_breve"),
  c("118-Carl_Olaf_Tamm.qmd", "22-Carl_Olof_Tamm"),
  c("Appendix_A_Species_List.qmd", "ApA-Lista_especies"),
  c("Appendix_B_Hoja_de_datos.qmd", "ApB-Hoja_de_datos"),
  c("Appendix_C_Datos.qmd", "ApC-Datos"),
  c("Agradecimientos.qmd", "23-Agradecimientos")
)

# ---- Listas de detección ----
FIGURE_CALLS <- c(
  "ggplot(", "plot(", "barplot(", "hist(", "boxplot(", "image(",
  "contour(", "persp(", "pairs(", "matplot(", "curve(", "autoplot(",
  "ggarrange(", "grid.arrange(", "plot_grid(", "stage.vector.plot(",
  "image.plot("
)
WIDGET_CALLS <- c("plot_life_cycle(", "grViz(")
TABLE_CALLS <- c("flextable(", "kable(", "gt(", "datatable(", "huxtable(")

# ---- Patrones ----
IMG_PATTERN <- "!\\[([^\\]]*)\\]\\(([^\\)]+)\\)(\\{[^}]*\\})?"
CHUNK_START_RE <- "^```\\{(r|python)([\\s,]+(.*))?\\}"
RENDER_DUAL_RE <- "render_dual\\s*\\([^,]+,\\s*[\"']([^\"']+)[\"']\\s*\\)"
GGSAVE_QUOTED_RE <- "ggsave\\s*\\(\\s*(?:filename\\s*=\\s*)?[\"']([^\"']+)[\"']"
SAVE_PLOT_PNG_RE <- "save_plot_png\\s*\\([^,]+,\\s*(?:file\\s*=\\s*)?[\"']([^\"']+)[\"']"
PLC_OR_GRVIZ_RE <- "(?:plc_save|grviz_save)\\s*\\([^)]*?png\\s*=\\s*[\"']([^\"']+)[\"']"
FIG_ANCHOR_RE <- "#fig-([\\w.\\-]+)"
LABEL_OPT_RE <- "(?m)^\\s*#\\|\\s*label\\s*:\\s*([\\w.\\-]+)"

# ---- Utilidades ----
any_fixed <- function(haystack, needles) {
  any(vapply(
    needles, function(n) str_detect(haystack, fixed(n)),
    logical(1)
  ))
}

safe_name <- function(s) {
  s <- str_replace_all(s, "[^\\w\\.\\-]", "_")
  s <- str_replace_all(s, "_+", "_")
  str_replace_all(s, "^_+|_+$", "")
}

hash_inside_string <- function(line) {
  in_dq <- FALSE
  in_sq <- FALSE
  chars <- strsplit(line, "", fixed = TRUE)[[1]]
  for (ch in chars) {
    if (ch == "\"" && !in_sq) {
      in_dq <- !in_dq
      next
    }
    if (ch == "'" && !in_dq) {
      in_sq <- !in_sq
      next
    }
    if (ch == "#" && !in_dq && !in_sq) {
      return(FALSE)
    }
    if (ch == "#") {
      return(TRUE)
    }
  }
  FALSE
}

extract_chunk_label <- function(header) {
  m <- str_match(str_trim(header), CHUNK_START_RE)
  if (is.na(m[1, 1])) {
    return(list(label = NA_character_, skip = FALSE))
  }
  rest <- if (is.na(m[1, 4])) "" else m[1, 4]
  skip <- str_detect(rest, "\\b(eval|include)\\s*=\\s*(FALSE|F)\\b")
  label <- NA_character_
  for (tok in str_trim(str_split(rest, ",")[[1]])) {
    if (!nzchar(tok) || str_detect(tok, "=") || str_detect(tok, ":")) next
    if (str_detect(tok, "^[a-zA-Z_][a-zA-Z0-9_.\\-]*$")) {
      label <- tok
      break
    }
  }
  list(label = label, skip = skip)
}

# Determinar el "número de capítulo" para el prefijo Fig_X.Y a partir
# del nombre del directorio. Devuelve NA si el capítulo no recibe número
# de figura (prefacio, agradecimientos).
chapter_num <- function(chapter_label) {
  m <- str_match(chapter_label, "^(\\d+)-")
  if (!is.na(m[1, 1])) {
    n <- as.integer(m[1, 2])
    if (n == 0L) {
      return(NA_character_)
    } # prefacio
    return(as.character(n))
  }
  m <- str_match(chapter_label, "^Ap([A-Z])-")
  if (!is.na(m[1, 1])) {
    return(m[1, 2])
  }
  NA_character_
}

# Construir prefijo de archivo: "Fig_X.Y" o "NN" cuando no hay número de
# capítulo. Mantiene orden con `formatC` para sort lexicográfico estable.
build_prefix <- function(chap_num, within_idx) {
  if (is.na(chap_num)) {
    sprintf("%02d", within_idx)
  } else {
    sprintf("Fig_%s.%d", chap_num, within_idx)
  }
}

# ---- Parser de figuras por capítulo ----
parse_figures_in_chapter <- function(qmd_path) {
  if (!file.exists(qmd_path)) {
    return(list())
  }
  lines <- readLines(qmd_path, warn = FALSE, encoding = "UTF-8")

  figures <- list()
  in_chunk <- FALSE
  chunk_label <- NA_character_
  chunk_start <- 0L
  chunk_eval_false <- FALSE
  chunk_produces <- FALSE
  chunk_widget_fn <- NA_character_
  chunk_pending_png <- FALSE
  opt_labels <- character(0)
  unnamed_counter <- 0L

  push_fig <- function(rec) {
    figures[[length(figures) + 1L]] <<- rec
  }

  for (i in seq_along(lines)) {
    line <- lines[i]
    stripped <- str_trim(line)

    if ((str_starts(stripped, fixed("```{r")) ||
      str_starts(stripped, fixed("```{python"))) && !in_chunk) {
      in_chunk <- TRUE
      chunk_start <- i
      info <- extract_chunk_label(stripped)
      chunk_label <- info$label
      chunk_eval_false <- info$skip
      chunk_produces <- FALSE
      chunk_widget_fn <- NA_character_
      chunk_pending_png <- FALSE
      opt_labels <- character(0)
      if (is.na(chunk_label)) unnamed_counter <- unnamed_counter + 1L
      next
    }

    if (stripped == "```" && in_chunk) {
      if (!chunk_eval_false) {
        chunk_effective_label <- if (!is.na(chunk_label)) {
          chunk_label
        } else if (length(opt_labels) > 0L) {
          opt_labels[1]
        } else {
          NA_character_
        }
        if (!is.na(chunk_widget_fn)) {
          push_fig(list(
            type = "widget", chunk = chunk_effective_label,
            line = chunk_start, fn = chunk_widget_fn,
            numbered = !is.na(chunk_effective_label) &&
              startsWith(chunk_effective_label, "fig-")
          ))
        } else if (chunk_produces) {
          # Solo registrar como figura los chunks con label `fig-...`. Sin
          # ese label Quarto no numera la salida y muchos chunks con
          # `ggplot(...)` son solo asignaciones a variables (`p <- ggplot()`)
          # cuyo objeto se imprime en un chunk posterior. Antes esos chunks
          # generaban falsos positivos `missing_chunks`.
          if (!is.na(chunk_effective_label) &&
            startsWith(chunk_effective_label, "fig-")) {
            push_fig(list(
              type = "dynamic", chunk = chunk_effective_label,
              line = chunk_start,
              unnamed_idx = if (is.na(chunk_label)) unnamed_counter else NA_integer_,
              numbered = TRUE
            ))
          }
        }
      }
      in_chunk <- FALSE
      chunk_label <- NA_character_
      chunk_start <- 0L
      chunk_eval_false <- FALSE
      chunk_produces <- FALSE
      chunk_widget_fn <- NA_character_
      chunk_pending_png <- FALSE
      opt_labels <- character(0)
      next
    }

    if (in_chunk) {
      # eval: false / include: false en opciones #|
      if (str_detect(
        line,
        "^\\s*#\\|\\s*(eval|include)\\s*:\\s*(false|FALSE|F)\\b"
      )) {
        chunk_eval_false <- TRUE
        next
      }
      # label: en opciones #|
      m_lbl <- str_match(line, "^\\s*#\\|\\s*label\\s*:\\s*([\\w.\\-]+)")
      if (!is.na(m_lbl[1, 1])) {
        opt_labels <- c(opt_labels, m_lbl[1, 2])
        next
      }

      # Quitar comentarios R para evitar falsos positivos de #plot(...)
      code_only <- if (hash_inside_string(line)) {
        line
      } else {
        str_split(line, "#", n = 2)[[1]][1]
      }

      # Cierre multilínea: una llamada a plc_save()/grviz_save() abierta en una
      # línea anterior del mismo chunk, con `png =`/`file =` en ESTA línea.
      if (chunk_pending_png) {
        m_png <- str_match(code_only, "(?:png|file)\\s*=\\s*[\"']([^\"']+)[\"']")
        if (!is.na(m_png[1, 1])) {
          push_fig(list(
            type = "render_dual", src = m_png[1, 2], line = i,
            numbered = NA
          ))
          chunk_pending_png <- FALSE
          chunk_produces <- FALSE
          chunk_widget_fn <- NA_character_
          next
        }
      }

      # render_dual()
      m <- str_match(code_only, RENDER_DUAL_RE)
      if (!is.na(m[1, 1])) {
        push_fig(list(
          type = "render_dual", src = m[1, 2], line = i,
          numbered = NA
        )) # se resuelve abajo con opt_labels
        chunk_produces <- FALSE
        next
      }
      # plc_save / grviz_save con png =
      m <- str_match(code_only, PLC_OR_GRVIZ_RE)
      if (!is.na(m[1, 1])) {
        push_fig(list(
          type = "render_dual", src = m[1, 2], line = i,
          numbered = NA
        ))
        chunk_produces <- FALSE
        chunk_widget_fn <- NA_character_
        next
      }
      # plc_save()/grviz_save() abierto en multilínea: el `png =` aparece en
      # una línea posterior y lo captura el bloque chunk_pending_png de arriba.
      if (str_detect(code_only, "(?:plc_save|grviz_save)\\s*\\(")) {
        chunk_pending_png <- TRUE
        next
      }
      # save_plot_png(p, file = "path")
      m <- str_match(code_only, SAVE_PLOT_PNG_RE)
      if (!is.na(m[1, 1])) {
        push_fig(list(
          type = "render_dual", src = m[1, 2], line = i,
          numbered = NA
        ))
        chunk_produces <- FALSE
        chunk_widget_fn <- NA_character_
        next
      }
      if (str_detect(code_only, "save_plot_png\\(")) {
        # ruta dinámica → no la podemos resolver; solo cancelamos flags
        chunk_widget_fn <- NA_character_
        chunk_produces <- FALSE
        next
      }
      # ggsave()
      m <- str_match(code_only, GGSAVE_QUOTED_RE)
      if (!is.na(m[1, 1])) {
        push_fig(list(
          type = "ggsave", src = m[1, 2], line = i,
          numbered = NA
        ))
        chunk_produces <- FALSE
        next
      }
      # Widget HTML
      for (w in WIDGET_CALLS) {
        if (str_detect(code_only, fixed(w)) &&
          !any_fixed(code_only, TABLE_CALLS)) {
          chunk_widget_fn <- str_replace(w, "\\($", "")
          break
        }
      }
      # Llamada a figura productora
      if (any_fixed(code_only, FIGURE_CALLS) &&
        !any_fixed(code_only, TABLE_CALLS)) {
        if (is.na(chunk_widget_fn)) chunk_produces <- TRUE
      }
      next
    }

    # Fuera de chunks: imagen markdown
    img_matches <- str_match_all(line, IMG_PATTERN)[[1]]
    if (nrow(img_matches) == 0L) next
    for (k in seq_len(nrow(img_matches))) {
      alt <- img_matches[k, 2]
      src <- img_matches[k, 3]
      attrs <- if (is.na(img_matches[k, 4])) "" else img_matches[k, 4]
      if (startsWith(src, "`") || str_detect(src, "\\{\\{")) next
      if (str_detect(src, "images/") || str_detect(src, "figs/") ||
        str_detect(src, "\\.(png|jpe?g|svg|gif|tiff?)$")) {
        anchor <- str_match(attrs, FIG_ANCHOR_RE)
        numbered <- !is.na(anchor[1, 1])
        push_fig(list(
          type = "static", src = src, line = i,
          caption = alt, numbered = numbered
        ))
      }
    }
  }

  # Para entradas dentro de chunks (render_dual/ggsave/...): el chunk
  # entero puede llevar label `fig-...` en opciones; se aplica al final.
  # Recorrido en orden — ya están en el orden correcto.
  figures
}

# ---- Copia auxiliar PDF (sibling o wrapped) ----
swap_ext <- function(path, new_ext) {
  if (!startsWith(new_ext, ".")) new_ext <- paste0(".", new_ext)
  paste0(tools::file_path_sans_ext(path), new_ext)
}

ensure_pdf_companion <- function(src_png, dest_pdf, audit = FALSE) {
  sibling <- swap_ext(src_png, "pdf")
  if (file.exists(sibling)) {
    if (!audit) {
      ok <- tryCatch(file.copy(sibling, dest_pdf, overwrite = TRUE),
        error = function(e) FALSE
      )
      if (!isTRUE(ok)) {
        warning(sprintf("no se pudo copiar PDF sibling %s", sibling))
        return(list(path = NA_character_, mode = "skipped"))
      }
    }
    return(list(path = dest_pdf, mode = "sibling-vector"))
  }
  if (HAS_MAGICK && file.exists(src_png)) {
    if (!audit) {
      ok <- tryCatch(
        {
          img <- magick::image_read(src_png)
          magick::image_write(img, path = dest_pdf, format = "pdf")
          TRUE
        },
        error = function(e) FALSE
      )
      if (!isTRUE(ok)) {
        warning(sprintf("magick no pudo envolver %s", src_png))
        return(list(path = NA_character_, mode = "skipped"))
      }
    }
    return(list(path = dest_pdf, mode = "wrapped-raster"))
  }
  list(path = NA_character_, mode = "skipped")
}

# ---- Limpieza segura de figuras_editor/ ----
try_clear_dir <- function(d) {
  if (!dir.exists(d)) {
    return(TRUE)
  }
  for (child in sort(list.files(d, full.names = TRUE, include.dirs = TRUE))) {
    res <- tryCatch(
      unlink(child, recursive = TRUE, force = FALSE),
      error = function(e) 1
    )
    if (!isTRUE(all(res == 0))) {
      # silencioso; el ciclo continúa
    }
  }
  TRUE
}

# ---- Main ----
main <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  audit <- "--audit" %in% args
  verbose <- ("--verbose" %in% args) || ("-v" %in% args)

  if (!audit) {
    if (dir.exists(DEST)) {
      for (child in sort(list.files(DEST,
        full.names = TRUE,
        include.dirs = TRUE
      ))) {
        if (dir.exists(child)) try_clear_dir(child)
      }
    } else {
      dir.create(DEST, recursive = TRUE)
    }
  }

  chapter_records <- list()
  total_copied <- 0L
  total_pdf_vect <- 0L
  total_pdf_wrap <- 0L
  chapters_with <- 0L
  warnings_l <- list(
    missing_static       = list(),
    missing_render_dual  = list(),
    missing_ggsave       = list(),
    no_render_dir        = list(),
    missing_chunks       = list(),
    widgets_no_png       = list(),
    no_pdf               = list()
  )

  for (entry in CHAPTERS) {
    qmd_file <- entry[1]
    chapter_label <- entry[2]
    qmd_path <- file.path(ROOT, qmd_file)
    figures <- parse_figures_in_chapter(qmd_path)
    if (length(figures) == 0L) {
      if (file.exists(qmd_path)) {
        message(sprintf(
          "[collect_figures] AVISO: %s (%s) no produjo figuras detectables.",
          qmd_file, chapter_label
        ))
        # Se crea igualmente la carpeta, con una nota, para que la secuencia
        # entregada a la editorial no tenga huecos. Un capitulo sin figuras
        # (1, 16, 20, 23) es una ausencia legitima, no un archivo perdido.
        if (!audit) {
          empty_dir <- file.path(DEST, chapter_label)
          dir.create(empty_dir, recursive = TRUE, showWarnings = FALSE)
          writeLines(
            c(
              sprintf("Capitulo %s: sin figuras.", chapter_label),
              "",
              "Esta carpeta se entrega vacia a proposito: el capitulo no",
              "contiene ninguna figura. Se incluye para que la numeracion de",
              "carpetas coincida exactamente con la del libro."
            ),
            file.path(empty_dir, "SIN_FIGURAS.txt")
          )
        }
      }
      next
    }

    chapter_dir <- file.path(DEST, chapter_label)
    if (!audit) dir.create(chapter_dir, recursive = TRUE, showWarnings = FALSE)
    chapters_with <- chapters_with + 1L

    qmd_stem <- tools::file_path_sans_ext(qmd_file)
    figure_html_dir <- file.path(
      DOCS, paste0(qmd_stem, "_files"),
      "figure-html"
    )
    dir_warned <- FALSE
    chnum <- chapter_num(chapter_label)

    records <- list()
    pos <- 0L
    for (fig in figures) {
      pos <- pos + 1L
      prefix <- build_prefix(chnum, pos)
      rec <- list(
        pos = pos, fig_num = if (is.na(chnum)) {
          NA_character_
        } else {
          sprintf("%s.%d", chnum, pos)
        },
        line = fig$line, type = fig$type, src_qmd = NA,
        figura_editor = NA, figura_editor_pdf = NA,
        caption = ifelse(is.null(fig$caption), "", fig$caption)
      )

      if (fig$type == "static") {
        src_path <- file.path(ROOT, fig$src)
        rec$src_qmd <- fig$src
        if (!file.exists(src_path)) {
          warnings_l$missing_static[[length(warnings_l$missing_static) + 1L]] <-
            list(chapter = chapter_label, src = fig$src, line = fig$line)
          rec$figura_editor <- "[FALTA EN DISCO]"
        } else {
          dest_name <- sprintf("%s_%s", prefix, safe_name(basename(src_path)))
          rec$figura_editor <- file.path("figuras_editor", chapter_label, dest_name)
          if (!audit) {
            ok <- tryCatch(
              file.copy(src_path,
                file.path(chapter_dir, dest_name),
                overwrite = TRUE
              ),
              error = function(e) FALSE
            )
            if (isTRUE(ok)) total_copied <- total_copied + 1L
          }
        }
      } else if (fig$type == "render_dual") {
        src_path <- file.path(ROOT, fig$src)
        rec$src_qmd <- fig$src
        if (!file.exists(src_path)) {
          warnings_l$missing_render_dual[[length(warnings_l$missing_render_dual) + 1L]] <-
            list(chapter = chapter_label, src = fig$src, line = fig$line)
          rec$figura_editor <- "[FALTA — correr quarto render]"
        } else {
          dest_name <- sprintf("%s_%s", prefix, safe_name(basename(src_path)))
          rec$figura_editor <- file.path("figuras_editor", chapter_label, dest_name)
          if (!audit) {
            ok <- tryCatch(
              file.copy(src_path,
                file.path(chapter_dir, dest_name),
                overwrite = TRUE
              ),
              error = function(e) FALSE
            )
            if (isTRUE(ok)) total_copied <- total_copied + 1L
          }
          pdf_dest <- file.path(chapter_dir, swap_ext(dest_name, "pdf"))
          comp <- ensure_pdf_companion(src_path, pdf_dest, audit = audit)
          if (!is.na(comp$path)) {
            rec$figura_editor_pdf <- file.path(
              "figuras_editor", chapter_label,
              basename(pdf_dest)
            )
            if (comp$mode == "sibling-vector") total_pdf_vect <- total_pdf_vect + 1L
            if (comp$mode == "wrapped-raster") total_pdf_wrap <- total_pdf_wrap + 1L
          } else {
            warnings_l$no_pdf[[length(warnings_l$no_pdf) + 1L]] <-
              list(chapter = chapter_label, pos = pos, src = fig$src)
          }
        }
      } else if (fig$type == "ggsave") {
        src_path <- file.path(ROOT, fig$src)
        if (!file.exists(src_path)) {
          alt <- file.path(IMAGES, basename(fig$src))
          if (file.exists(alt)) src_path <- alt
        }
        rec$src_qmd <- fig$src
        if (!file.exists(src_path)) {
          warnings_l$missing_ggsave[[length(warnings_l$missing_ggsave) + 1L]] <-
            list(chapter = chapter_label, src = fig$src, line = fig$line)
          rec$figura_editor <- "[FALTA — correr quarto render]"
        } else {
          dest_name <- sprintf("%s_%s", prefix, safe_name(basename(src_path)))
          rec$figura_editor <- file.path("figuras_editor", chapter_label, dest_name)
          if (!audit) {
            ok <- tryCatch(
              file.copy(src_path,
                file.path(chapter_dir, dest_name),
                overwrite = TRUE
              ),
              error = function(e) FALSE
            )
            if (isTRUE(ok)) total_copied <- total_copied + 1L
          }
          pdf_dest <- file.path(chapter_dir, swap_ext(dest_name, "pdf"))
          comp <- ensure_pdf_companion(src_path, pdf_dest, audit = audit)
          if (!is.na(comp$path)) {
            rec$figura_editor_pdf <- file.path(
              "figuras_editor", chapter_label,
              basename(pdf_dest)
            )
            if (comp$mode == "sibling-vector") total_pdf_vect <- total_pdf_vect + 1L
            if (comp$mode == "wrapped-raster") total_pdf_wrap <- total_pdf_wrap + 1L
          } else {
            warnings_l$no_pdf[[length(warnings_l$no_pdf) + 1L]] <-
              list(chapter = chapter_label, pos = pos, src = fig$src)
          }
        }
      } else if (fig$type == "widget") {
        rec$src_qmd <- sprintf(
          "chunk '%s' (%s)",
          ifelse(is.na(fig$chunk), "(sin label)", fig$chunk),
          fig$fn
        )
        rec$figura_editor <- sprintf(
          "[WIDGET HTML — sin PNG; chunk: %s]",
          ifelse(is.na(fig$chunk), "sin_label", fig$chunk)
        )
        warnings_l$widgets_no_png[[length(warnings_l$widgets_no_png) + 1L]] <-
          list(
            chapter = chapter_label, chunk = fig$chunk,
            line = fig$line, fn = fig$fn
          )
      } else if (fig$type == "dynamic") {
        rec$src_qmd <- sprintf(
          "chunk '%s'",
          ifelse(is.na(fig$chunk), "(sin label)", fig$chunk)
        )
        if (!dir.exists(figure_html_dir)) {
          if (!dir_warned) {
            warnings_l$no_render_dir[[length(warnings_l$no_render_dir) + 1L]] <-
              chapter_label
            dir_warned <- TRUE
          }
          rec$figura_editor <- "[FALTA — correr quarto render]"
        } else {
          chunk <- fig$chunk
          if (!is.na(chunk)) {
            matches <- sort(list.files(figure_html_dir,
              pattern = sprintf(
                "^%s-.*\\.png$",
                str_replace_all(chunk, "([.])", "\\\\\\1")
              ),
              full.names = TRUE
            ))
            if (length(matches) == 0L) {
              matches <- sort(list.files(figure_html_dir,
                pattern = sprintf(
                  "^%s\\.png$",
                  str_replace_all(chunk, "([.])", "\\\\\\1")
                ),
                full.names = TRUE
              ))
            }
          } else {
            idx <- fig$unnamed_idx
            matches <- if (!is.na(idx)) {
              sort(list.files(figure_html_dir,
                pattern = sprintf("^unnamed-chunk-%d-.*\\.png$", idx),
                full.names = TRUE
              ))
            } else {
              character(0)
            }
          }

          if (length(matches) == 0L) {
            warnings_l$missing_chunks[[length(warnings_l$missing_chunks) + 1L]] <-
              list(
                chapter = chapter_label,
                chunk = ifelse(is.na(fig$chunk),
                  sprintf("unnamed-%d", fig$unnamed_idx),
                  fig$chunk
                ),
                line = fig$line
              )
            rec$figura_editor <- "[FALTA — correr quarto render]"
          } else {
            paths <- character(0)
            pdf_paths <- character(0)
            for (j in seq_along(matches)) {
              mfile <- matches[j]
              suffix <- if (length(matches) > 1L) sprintf("_%d", j) else ""
              dest_name <- sprintf(
                "%s%s_%s", prefix, suffix,
                safe_name(basename(mfile))
              )
              paths <- c(
                paths,
                file.path("figuras_editor", chapter_label, dest_name)
              )
              if (!audit) {
                ok <- tryCatch(
                  file.copy(mfile,
                    file.path(chapter_dir, dest_name),
                    overwrite = TRUE
                  ),
                  error = function(e) FALSE
                )
                if (isTRUE(ok)) total_copied <- total_copied + 1L
              }
              pdf_dest <- file.path(chapter_dir, swap_ext(dest_name, "pdf"))
              comp <- ensure_pdf_companion(mfile, pdf_dest, audit = audit)
              if (!is.na(comp$path)) {
                pdf_paths <- c(
                  pdf_paths,
                  file.path(
                    "figuras_editor", chapter_label,
                    basename(pdf_dest)
                  )
                )
                if (comp$mode == "sibling-vector") {
                  total_pdf_vect <- total_pdf_vect + 1L
                }
                if (comp$mode == "wrapped-raster") {
                  total_pdf_wrap <- total_pdf_wrap + 1L
                }
              }
            }
            rec$figura_editor <- paste(paths, collapse = "; ")
            if (length(pdf_paths)) {
              rec$figura_editor_pdf <- paste(pdf_paths, collapse = "; ")
            } else {
              warnings_l$no_pdf[[length(warnings_l$no_pdf) + 1L]] <-
                list(
                  chapter = chapter_label, pos = pos,
                  src = ifelse(is.na(fig$chunk),
                    sprintf("unnamed-%d", fig$unnamed_idx),
                    fig$chunk
                  )
                )
            }
          }
        }
      }

      records[[length(records) + 1L]] <- rec
    }

    chapter_records[[length(chapter_records) + 1L]] <- list(
      chapter = chapter_label, qmd_file = qmd_file, figures = records
    )
  }

  write_csv(chapter_records)
  write_manifest(chapter_records, warnings_l)

  total_figs <- sum(vapply(chapter_records, function(c) length(c$figures), integer(1)))
  mode_str <- if (audit) "AUDITORÍA (sin copiar)" else "RECOLECCIÓN"
  cat(sprintf(
    "\n✓ %s: %d figuras en %d capítulos.\n",
    mode_str, total_figs, length(chapter_records)
  ))
  if (!audit) {
    cat(sprintf("  Copiadas (PNG): %d\n", total_copied))
    cat(sprintf("  PDF vectoriales (sibling .pdf): %d\n", total_pdf_vect))
    cat(sprintf("  PDF envueltos (magick PNG→PDF): %d\n", total_pdf_wrap))
    if (!HAS_MAGICK) {
      message("  ⚠ magick no disponible: ggsave() sin sibling .pdf no tendrá PDF.")
    }
    cat(sprintf("  Destino:  %s/\n", basename(DEST)))
  }
  cat(sprintf("  Inventario: %s\n", basename(CSV_PATH)))
  cat(sprintf("  Manifiesto: %s\n", basename(MD_PATH)))

  n_warn <- sum(vapply(warnings_l, length, integer(1)))
  if (n_warn > 0L) {
    message(sprintf("\n  Advertencias: %d", n_warn))
    for (k in names(warnings_l)) {
      if (length(warnings_l[[k]]) > 0L) {
        message(sprintf("    %s: %d", k, length(warnings_l[[k]])))
      }
    }
    if (verbose) {
      for (k in names(warnings_l)) {
        if (length(warnings_l[[k]]) > 0L) {
          message(sprintf("\n  -- %s --", k))
          for (it in warnings_l[[k]]) message("    ", paste(it, collapse = " | "))
        }
      }
    } else {
      message("  (Pasar --verbose para ver el detalle)")
    }
  }
}

write_csv <- function(chapter_records) {
  con <- file(CSV_PATH, open = "w", encoding = "UTF-8")
  on.exit(close(con))
  csv_line <- function(fields) {
    # Quotear si contiene coma, comillas dobles, o salto de línea.
    q <- function(s) {
      s <- as.character(s)
      if (is.na(s)) s <- ""
      if (grepl("[,\"\n]", s)) {
        s <- gsub("\"", "\"\"", s, fixed = TRUE)
        sprintf("\"%s\"", s)
      } else {
        s
      }
    }
    paste(vapply(fields, q, character(1)), collapse = ",")
  }
  writeLines(csv_line(c(
    "Capítulo", "Archivo .qmd", "#Fig", "Figura X.Y", "Línea", "Tipo",
    "Origen (en .qmd)", "Ruta PNG (figuras_editor)",
    "Ruta PDF (figuras_editor)", "Caption"
  )), con, useBytes = TRUE)
  for (ch in chapter_records) {
    for (r in ch$figures) {
      writeLines(csv_line(c(
        ch$chapter, ch$qmd_file, r$pos,
        if (is.na(r$fig_num)) "" else r$fig_num,
        r$line, r$type,
        if (is.na(r$src_qmd)) "" else r$src_qmd,
        if (is.na(r$figura_editor)) "" else r$figura_editor,
        if (is.na(r$figura_editor_pdf)) "" else r$figura_editor_pdf,
        substr(if (is.na(r$caption)) "" else r$caption, 1, 240)
      )), con, useBytes = TRUE)
    }
  }
}

write_manifest <- function(chapter_records, warnings_l) {
  lines <- c(
    "# Manifiesto de figuras — Dinámica Poblacional de Orquídeas",
    "",
    paste0(
      "Inventario completo de TODAS las figuras del libro ",
      "(estáticas markdown + generadas por código R), organizadas por ",
      "capítulo y orden de aparición. Cada figura está enlazada con su ",
      "ubicación esperada en `figuras_editor/<capítulo>/` y, cuando ",
      "aplica, con el número de figura `Fig X.Y` del libro renderizado."
    ),
    ""
  )

  total <- sum(vapply(chapter_records, function(c) length(c$figures), integer(1)))
  by_type <- table(unlist(lapply(
    chapter_records,
    function(c) vapply(c$figures, function(r) r$type, character(1))
  )))
  lines <- c(
    lines, "## Resumen", "",
    sprintf("- **Total figuras**: %d", total),
    sprintf("- **Capítulos con figuras**: %d", length(chapter_records)),
    "- **Por tipo**:"
  )
  type_es <- c(
    static = "imagen markdown estática",
    render_dual = "PNG generado por `render_dual()` (DOT → PNG)",
    ggsave = "PNG generado por `ggsave()`",
    dynamic = "PNG generado por chunk R (ggplot, plot, etc.)",
    widget = "widget HTML (`plot_life_cycle`/`grViz`) sin PNG estático"
  )
  for (t in names(sort(by_type, decreasing = TRUE))) {
    pretty <- if (t %in% names(type_es)) type_es[[t]] else t
    lines <- c(lines, sprintf("  - %s: **%d**", pretty, by_type[[t]]))
  }
  lines <- c(lines, "")

  lines <- c(
    lines, "## Cómo regenerar este manifiesto",
    "",
    "```bash",
    "quarto render                       # genera docs/*_files/figure-html/",
    "Rscript scripts/collect_figures.R   # recolecta a figuras_editor/",
    "```",
    "",
    "Para auditar sin copiar: `Rscript scripts/collect_figures.R --audit`",
    ""
  )

  lines <- c(lines, "## Inventario por capítulo")
  for (ch in chapter_records) {
    lines <- c(
      lines, "", sprintf("### %s", ch$chapter), "",
      sprintf(
        "Archivo fuente: `%s` — %d figura(s)",
        ch$qmd_file, length(ch$figures)
      ),
      "",
      "| # | Fig X.Y | Línea | Tipo | Origen en .qmd | PNG | PDF | Caption |",
      "|---|---------|------:|------|----------------|-----|-----|---------|"
    )
    for (r in ch$figures) {
      cap <- str_replace_all(if (is.na(r$caption)) "" else r$caption, "\\|", "\\\\|")
      cap <- str_replace_all(cap, "\\n", " ")
      cap <- substr(cap, 1, 120)
      origen <- str_replace_all(if (is.na(r$src_qmd)) "" else r$src_qmd, "\\|", "\\\\|")
      dest <- str_replace_all(if (is.na(r$figura_editor)) "" else r$figura_editor, "\\|", "\\\\|")
      dest_pdf <- str_replace_all(if (is.na(r$figura_editor_pdf)) "" else r$figura_editor_pdf, "\\|", "\\\\|")
      fignum <- if (is.na(r$fig_num)) "" else r$fig_num
      lines <- c(
        lines,
        sprintf(
          "| %d | %s | %d | %s | `%s` | `%s` | `%s` | %s |",
          r$pos, fignum, r$line, r$type, origen, dest, dest_pdf, cap
        )
      )
    }
  }

  if (length(warnings_l$widgets_no_png) > 0L) {
    lines <- c(
      lines, "",
      "## Figuras tipo widget (HTML) sin PNG",
      "",
      paste0(
        "Los siguientes chunks producen un diagrama interactivo (`plot_life_cycle` ",
        "o `grViz`) que NO se exporta automáticamente como PNG. Para incluirlos ",
        "en la entrega física al editor: añadir `plc_save()`/`grviz_save()` o ",
        "tomar captura desde la versión HTML del libro."
      ),
      "",
      "| Capítulo | Línea | Función | Chunk |",
      "|----------|------:|---------|-------|"
    )
    for (it in warnings_l$widgets_no_png) {
      lines <- c(
        lines,
        sprintf(
          "| %s | %d | `%s()` | `%s` |",
          it$chapter, it$line, it$fn,
          ifelse(is.na(it$chunk), "(sin label)", it$chunk)
        )
      )
    }
  }

  missing_any <- (length(warnings_l$missing_static) +
    length(warnings_l$missing_render_dual) +
    length(warnings_l$missing_ggsave) +
    length(warnings_l$missing_chunks)) > 0L
  if (missing_any) {
    lines <- c(lines, "", "## Archivos faltantes (corrige antes de la entrega)", "")
    for (it in warnings_l$missing_static) {
      lines <- c(lines, sprintf(
        "- `%s` línea %d: imagen estática `%s` no existe en disco.",
        it$chapter, it$line, it$src
      ))
    }
    for (it in warnings_l$missing_render_dual) {
      lines <- c(lines, sprintf(
        "- `%s` línea %d: `render_dual` apunta a `%s` — correr `quarto render`.",
        it$chapter, it$line, it$src
      ))
    }
    for (it in warnings_l$missing_ggsave) {
      lines <- c(lines, sprintf(
        "- `%s` línea %d: `ggsave` apunta a `%s` — correr `quarto render`.",
        it$chapter, it$line, it$src
      ))
    }
    for (it in warnings_l$missing_chunks) {
      lines <- c(lines, sprintf(
        "- `%s` línea %d: chunk `%s` declarado pero sin PNG en `docs/`.",
        it$chapter, it$line, it$chunk
      ))
    }
  }

  writeLines(enc2utf8(lines), MD_PATH, useBytes = TRUE)
}

main()
