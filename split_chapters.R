library(pdftools)

# NOTE: This script splits the rendered book PDF into per-chapter PDFs.
# Updated to point at the Typst-rendered PDF (replaced the old LaTeX output
# as of 2026-04-30). After re-rendering with `quarto render --to typst`,
# verify the page numbers below — Typst pagination may differ from LaTeX,
# and the front-matter offset will likely need adjustment.

pdf_in  <- "docs/Introduccion-a-la-Dinamica-Poblacional-de-Orquideas.pdf"
out_dir <- "chapter_pdfs"
dir.create(out_dir, showWarnings = FALSE)

# Front-matter offset: number of pages before book page 1.
# Re-check this after the first Typst render — Typst typically has fewer
# front-matter pages than LaTeX `book` class.
offset <- 18

chapters <- list(
  list(file = "Cap01_Introduccion.pdf",             start =  1 + offset, end =  2 + offset),
  list(file = "Cap02_Acercamiento_practico.pdf",     start =  3 + offset, end = 14 + offset),
  list(file = "Cap03_Diagnostico_Intro.pdf",         start = 15 + offset, end = 30 + offset),
  list(file = "Cap04_Ciclo_de_Vida.pdf",             start = 31 + offset, end = 42 + offset),
  list(file = "Cap05_Recopilar_datos.pdf",           start = 43 + offset, end = 84 + offset),
  list(file = "Cap06_Transiciones.pdf",              start = 85 + offset, end = 100 + offset),
  list(file = "Cap07_Fecundidad.pdf",                start = 101 + offset, end = 116 + offset),
  list(file = "Cap08_Matrices_UFC.pdf",              start = 117 + offset, end = 136 + offset),
  list(file = "Cap09_Estimados_bayesianos.pdf",      start = 137 + offset, end = 138 + offset),
  list(file = "Cap10_Bayesiano_PPM.pdf",             start = 139 + offset, end = 168 + offset),
  list(file = "Cap11_Crecimiento_Poblacional.pdf",   start = 169 + offset, end = 188 + offset),
  list(file = "Cap12_Propiedades.pdf",               start = 189 + offset, end = 212 + offset),
  list(file = "Cap13_Elasticidad.pdf",               start = 213 + offset, end = 232 + offset),
  list(file = "Cap14_Dinamica_transitoria.pdf",      start = 233 + offset, end = 256 + offset),
  list(file = "Cap15_Funciones_Transferencia.pdf",   start = 257 + offset, end = 286 + offset),
  list(file = "Cap16_LTRE.pdf",                      start = 287 + offset, end = 310 + offset),
  list(file = "Cap17_Alternativa_grafico.pdf",       start = 311 + offset, end = 312 + offset),
  list(file = "Cap18_Variacion_Temporal.pdf",        start = 313 + offset, end = 348 + offset),
  list(file = "Cap19_COMPADRE_Orquideas.pdf",        start = 349 + offset, end = 366 + offset),
  list(file = "Cap20_Rage_Orquideas.pdf",            start = 367 + offset, end = 388 + offset),
  list(file = "Cap21_Protocolo_estandar.pdf",        start = 389 + offset, end = 416 + offset),
  list(file = "Cap22_Impactos_datos.pdf",            start = 417 + offset, end = 450 + offset),
  list(file = "Cap23_Conclusion.pdf",                start = 451 + offset, end = 454 + offset),
  list(file = "Parte_I_Historia.pdf",                start = 455 + offset, end = 456 + offset),
  list(file = "Cap24_Historia_breve.pdf",            start = 457 + offset, end = 466 + offset),
  list(file = "Cap25_Carl_Olaf_Tamm.pdf",            start = 467 + offset, end = 488 + offset),
  list(file = "Parte_II_Apendices.pdf",              start = 489 + offset, end = 490 + offset),
  list(file = "Apendice_A.pdf",                      start = 491 + offset, end = 498 + offset),
  list(file = "Apendice_B.pdf",                      start = 499 + offset, end = 502 + offset),
  list(file = "Apendice_C.pdf",                      start = 503 + offset, end = 504 + offset),
  list(file = "Cap26_Agradecimiento.pdf",            start = 505 + offset, end = 506 + offset),
  list(file = "Cap27_Agradecimientos.pdf",           start = 507 + offset, end = 552)
)

cat("Total PDF pages: 552\n")
cat("Front matter offset: 18 pages\n")
cat("Splitting into", length(chapters), "files...\n\n")

for (ch in chapters) {
  out_path <- file.path(out_dir, ch$file)
  pages <- ch$start:ch$end
  tryCatch({
    pdf_subset(pdf_in, pages = pages, output = out_path)
    cat(sprintf("OK  %s (PDF pp. %d-%d, %d pages)\n", ch$file, ch$start, ch$end, length(pages)))
  }, error = function(e) {
    cat(sprintf("ERR %s: %s\n", ch$file, e$message))
  })
}

cat("\nDone! Files saved to:", out_dir, "\n")
cat("Run: echo 'chapter_pdfs/' >> .gitignore\n")
