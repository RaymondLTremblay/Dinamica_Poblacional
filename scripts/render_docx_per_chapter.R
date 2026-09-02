# render_docx_per_chapter.R
# =========================
# Renderiza cada capítulo del libro como un .docx INDEPENDIENTE — un
# archivo por capítulo, no un solo .docx con todo el libro.
#
# Diseñado para usarse INTERACTIVAMENTE en RStudio:
#
#   source("scripts/render_docx_per_chapter.R")
#   render_chapter("105-Transiciones.qmd")     # uno solo
#   render_all_chapters()                      # los 27 (toma ~30 min)
#   render_all_chapters(dry_run = TRUE)        # solo listar, no renderizar
#
# Por qué un truco: Quarto, al renderizar a `docx` dentro de un proyecto
# `type: book`, COMPILA todo el libro en un único .docx. Para obtener un
# .docx por capítulo, renderizamos cada uno en un directorio temporal
# con un `_quarto.yml` despojado (sin `project.type: book`). Los assets
# (images/, figs/, R/, .Rprofile, bibliografía, filtros) se enlazan
# simbólicamente al original — nada se duplica en disco.
#
# Salida: docx_chapters/<chapter>.docx, un archivo por capítulo.
#
# Caveats:
#  - Referencias cruzadas entre capítulos (@fig-X en otro qmd) salen
#    como `?@fig-X` — esperado.
#  - Números de figura empiezan en 1.1 en cada capítulo (no continúan
#    la numeración global del libro). Captions son las correctas.

# No usamos yaml::write_yaml — produce YAML 1.1 (`yes`/`no`) que Quarto
# rechaza, y confunde la clave `y:` (margin) con un boolean. En vez de
# eso, leemos `_quarto.yml` como texto y eliminamos las secciones que no
# queremos línea por línea, preservando el formato original.

# Usar el paquete quarto si está disponible (resuelve el path al binario
# automáticamente). Si no, caemos a system2 con búsqueda manual.
.has_quarto_pkg <- requireNamespace("quarto", quietly = TRUE)

# ---- Configuración -----------------------------------------------------

# Raíz del proyecto: la carpeta que contiene _quarto.yml.
.ROOT <- (function() {
  d <- normalizePath(getwd())
  while (TRUE) {
    if (file.exists(file.path(d, "_quarto.yml"))) return(d)
    parent <- dirname(d); if (parent == d) break; d <- parent
  }
  stop("No encontré _quarto.yml hacia arriba desde ", getwd(),
       ". Asegúrate de tener la working directory en la raíz del proyecto.")
})()

.OUT_DIR <- file.path(.ROOT, "docx_chapters")

# Assets a enlazar dentro del temp dir; solo se enlaza si existe en ROOT.
.SHARED_ASSETS <- c(
  ".Rprofile", ".renvignore", "R", "images", "figs", "data", "fonts",
  "book.bib", "packages.bib", "peerj.csl", "lankesteriana.csl",
  "auto-functions.lua", "spanish-quotes.lua",
  "reference.docx",
  "theme.scss", "theme-dark.scss",
  "typst-patches", ".quarto", "_freeze"
)

# Capítulos a renderizar (mismo orden que _quarto.yml).
.CHAPTERS <- c(
  "index.qmd", "Prologos.qmd",
  "102-Intro.qmd", "103-Ciclos_de_Vida.qmd",
  "104-Recopilacion_datos_en_el_campo.qmd", "105-Transiciones.qmd",
  "106-calcular_fecundidad.qmd", "107-matU_matF_matC.qmd",
  "108-Bayesian_PPM.qmd", "109-Crecimiento_poblacional.qmd",
  "110-Propriedades.qmd", "111-Elasticidad.qmd",
  "112-Dinamica_de_Transiciones.qmd",
  "113-Funciones_de_Transferencia.qmd", "114-LTRE.qmd",
  "115-Metodos_de_simulaciones.qmd",
  "117_Historia_breve.qmd", "118-Carl_Olaf_Tamm.qmd",
  "119-COMPADRE_ORCHIDS.qmd", "120-Rage_orquideas.qmd",
  "121-Traduccion_protocolo_informacion.qmd",
  "122-Impacto_de_Datos_sin_Sentido.qmd",
  "123-Conclusion.qmd",
  "Appendix_A_Species_List.qmd", "Appendix_B_Hoja_de_datos.qmd",
  "Appendix_C_Datos.qmd", "Apendice_Glosario.qmd",
  "Agradecimientos.qmd"
)

# ---- Helpers internos --------------------------------------------------

# Quita project: y book: del _quarto.yml para que Quarto trate el archivo
# como documento standalone. Trabaja sobre el texto crudo para preservar
# el formato original (YAML 1.2: `true`/`false`, no `yes`/`no`) y la
# clave `y:` en `margin:` (que yaml::read_yaml convierte en TRUE).
.make_standalone_yaml <- function(src_yaml, dest_yaml,
                                  drop = c("project", "book")) {
  lines <- readLines(src_yaml, encoding = "UTF-8", warn = FALSE)
  drop_re <- paste0("^(", paste(drop, collapse = "|"), "):")
  out <- character(0)
  in_skip <- FALSE
  for (line in lines) {
    # Una nueva sección de nivel superior empieza en la columna 0 con un
    # carácter alfabético (no espacio, no #, no -).
    if (grepl("^[a-zA-Z]", line)) {
      in_skip <- grepl(drop_re, line)
    }
    if (!in_skip) out <- c(out, line)
  }
  writeLines(out, dest_yaml, useBytes = TRUE)
}

# Render un único capítulo en un temp dir.
.render_one <- function(qmd) {
  out_docx <- sub("\\.qmd$", ".docx", basename(qmd))
  out_dest <- file.path(.OUT_DIR, out_docx)

  tmp <- tempfile(pattern = "qmd-standalone-")
  dir.create(tmp, recursive = TRUE)
  on.exit(unlink(tmp, recursive = TRUE, force = TRUE), add = TRUE)

  # Enlaces simbólicos a assets compartidos
  for (asset in .SHARED_ASSETS) {
    src <- file.path(.ROOT, asset)
    if (file.exists(src) || dir.exists(src)) {
      file.symlink(src, file.path(tmp, asset))
    }
  }

  # _quarto.yml despojado
  .make_standalone_yaml(file.path(.ROOT, "_quarto.yml"),
                        file.path(tmp, "_quarto.yml"))

  # Copia del .qmd (overwrite seguro)
  file.copy(file.path(.ROOT, qmd), file.path(tmp, basename(qmd)),
            overwrite = TRUE)

  message("  • Renderizando ", qmd, " …")
  old <- setwd(tmp); on.exit(setwd(old), add = TRUE)

  # Preferimos quarto::quarto_render — sabe dónde está el binario de
  # quarto sin depender del PATH del subproceso. Fallback a system2.
  # `--output out_docx` fuerza el nombre del archivo de salida; sin
  # esto Quarto usa `output-file:` de la sección docx del _quarto.yml
  # (todos los capítulos saldrían con el nombre del libro entero).
  ok <- if (.has_quarto_pkg) {
    tryCatch({
      quarto::quarto_render(input = basename(qmd), output_format = "docx",
                            quarto_args = c("--output", out_docx),
                            quiet = FALSE)
      TRUE
    }, error = function(e) {
      message("    ✗ quarto::quarto_render falló: ", conditionMessage(e))
      FALSE
    })
  } else {
    status <- system2("quarto",
                      c("render", basename(qmd), "--to", "docx",
                        "--output", out_docx))
    status == 0L
  }
  setwd(old)

  src <- file.path(tmp, out_docx)
  if (ok && file.exists(src)) {
    file.rename(src, out_dest)
    message("    ✓ ", file.path("docx_chapters", out_docx))
    return(TRUE)
  } else {
    message("    ✗ falló (no se generó ", out_docx, ")")
    return(FALSE)
  }
}

# ---- API pública -------------------------------------------------------

#' Renderiza un capítulo como .docx independiente.
#'
#' @param qmd  Nombre del archivo .qmd (e.g. "105-Transiciones.qmd").
#' @return TRUE si tuvo éxito.
render_chapter <- function(qmd) {
  if (!file.exists(file.path(.ROOT, qmd))) {
    stop("No existe: ", qmd)
  }
  if (!dir.exists(.OUT_DIR)) dir.create(.OUT_DIR, recursive = TRUE)
  message("Destino: ", .OUT_DIR)
  .render_one(qmd)
}

#' Renderiza todos los capítulos como .docx independientes.
#'
#' @param dry_run Si TRUE, solo lista los capítulos sin renderizar.
#' @return invisible(list) con TRUE/FALSE por capítulo.
render_all_chapters <- function(dry_run = FALSE) {
  if (!dir.exists(.OUT_DIR)) dir.create(.OUT_DIR, recursive = TRUE)
  message("Destino: ", .OUT_DIR, "\n")

  if (dry_run) {
    for (qmd in .CHAPTERS) {
      out <- sub("\\.qmd$", ".docx", basename(qmd))
      cat(sprintf("  [dry] %s  →  docx_chapters/%s\n", qmd, out))
    }
    cat(sprintf("\nTotal: %d capítulos\n", length(.CHAPTERS)))
    return(invisible(NULL))
  }

  results <- list()
  for (qmd in .CHAPTERS) {
    p <- file.path(.ROOT, qmd)
    if (!file.exists(p)) {
      message("  ⚠ no existe: ", qmd); next
    }
    results[[qmd]] <- .render_one(qmd)
  }
  n_ok   <- sum(unlist(results))
  n_fail <- length(results) - n_ok
  message("\nResumen: ", n_ok, " ok, ", n_fail, " fallaron.")
  message("Destino: docx_chapters/")
  invisible(results)
}

# Mensaje al sourcing
message("Cargado. Usa: render_chapter(\"105-Transiciones.qmd\")",
        " | render_all_chapters() | render_all_chapters(dry_run = TRUE)")
