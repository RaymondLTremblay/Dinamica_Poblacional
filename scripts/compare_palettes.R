# compare_palettes.R
# =========================================================================
# Compara la paleta de color que usa el libro AHORA contra 3 alternativas
# seguras para daltonismo (colour-blind-safe), para elegir UNA consistente
# en todo el libro (incluyendo la versión de 12 colores que necesita LTRE).
#
# Uso (en RStudio, working directory = raíz del proyecto):
#
#   source("scripts/compare_palettes.R")
#
# Produce:
#   - una tabla en la consola con todos los hex de cada paleta;
#   - "palette_comparison.pdf" : swatches de cada paleta simulando visión
#     normal, deuteranopía, protanopía y tritanopía (para n = 6 y n = 12);
#   - si ggplot2 está disponible, "palette_demo.pdf" con un gráfico de
#     barras de ejemplo usando cada paleta.
#
# Dependencias:
#   - base R (obligatorio).
#   - colorspace (OPCIONAL) — para simular daltonismo. Si no está, el PDF
#     muestra solo visión normal y avisa. Instalar: install.packages("colorspace")
#   - ggplot2 (OPCIONAL) — solo para el demo de barras.
# =========================================================================

# ---- 1. Paletas --------------------------------------------------------

# La paleta ACTUAL del libro (definida en R/rlt_theme.R como `diverging`).
current_6  <- c("#009392", "#CF597E", "#E9E29C", "#39B185", "#EEB479", "#9CCB86")
# La extensión a 12 que usa SOLO el capítulo LTRE (114).
current_12 <- c(current_6,
                "#662E9B", "#E5A0D2", "#A5AA99", "#1D6996", "#DBE6E2", "#4D4D4D")

# --- Alternativa A: Okabe-Ito ------------------------------------------
# El estándar de facto para paletas cualitativas seguras para daltonismo
# (Okabe & Ito, "Color Universal Design"). 8 colores nativos.
okabe_ito_8 <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442",
                 "#0072B2", "#D55E00", "#CC79A7", "#000000")
A_6  <- okabe_ito_8[1:6]
# Okabe-Ito solo define 8; para 12 se extiende con 4 tonos distintos
# (compromiso: más allá de ~8 categorías cualitativas, considere Viridis).
A_12 <- c(okabe_ito_8, "#999999", "#661100", "#6699CC", "#882255")

# --- Alternativa B: Paul Tol -------------------------------------------
# Esquemas "Bright" (6-7) y "discrete rainbow" (12), diseñados explícita-
# mente para ser seguros para daltonismo (Tol, SRON technical note).
tol_bright_7 <- c("#4477AA", "#EE6677", "#228833", "#CCBB44",
                  "#66CCEE", "#AA3377", "#BBBBBB")
B_6  <- tol_bright_7[1:6]
B_12 <- c("#882E72", "#1965B0", "#5289C7", "#7BAFDE", "#4EB265", "#90C987",
          "#CAE0AB", "#F7F056", "#F6C141", "#F1932D", "#E8601C", "#DC050C")

# --- Alternativa C: Viridis --------------------------------------------
# Perceptualmente uniforme y segura para daltonismo a CUALQUIER n. Es
# secuencial, así que es ideal cuando las categorías tienen ORDEN (p. ej.
# clases de tamaño/etapa: plántula -> juvenil -> adulto), menos ideal para
# categorías puramente nominales (los adyacentes se parecen).
C_6  <- c("#440154", "#414487", "#2A788E", "#22A884", "#7AD151", "#FDE725")
C_12 <- c("#440154", "#482173", "#433E85", "#38598C", "#2D708E", "#25858E",
          "#1E9B8A", "#2BB07F", "#51C56A", "#85D54A", "#C2DF23", "#FDE725")

palettes_6 <- list(
  "ACTUAL (libro)"      = current_6,
  "A. Okabe-Ito"        = A_6,
  "B. Paul Tol Bright"  = B_6,
  "C. Viridis"          = C_6
)
palettes_12 <- list(
  "ACTUAL (LTRE)"           = current_12,
  "A. Okabe-Ito (ext.)"     = A_12,
  "B. Paul Tol rainbow"     = B_12,
  "C. Viridis"              = C_12
)

# ---- 2. Tabla en consola ----------------------------------------------

print_palette <- function(name, cols) {
  cat("\n", name, "  (", length(cols), " colores)\n", sep = "")
  cat("  ", paste(cols, collapse = ", "), "\n", sep = "")
}
cat("=========================================================\n")
cat(" PALETAS DE 6 COLORES\n")
cat("=========================================================\n")
invisible(Map(print_palette, names(palettes_6), palettes_6))
cat("\n=========================================================\n")
cat(" PALETAS DE 12 COLORES (para LTRE)\n")
cat("=========================================================\n")
invisible(Map(print_palette, names(palettes_12), palettes_12))

# ---- 3. Simulación de daltonismo --------------------------------------

has_colorspace <- requireNamespace("colorspace", quietly = TRUE)
if (!has_colorspace) {
  message("\n[aviso] El paquete 'colorspace' no está instalado: el PDF ",
          "mostrará SOLO visión normal.\n        Para simular daltonismo: ",
          "install.packages(\"colorspace\")")
}

# Devuelve una lista de versiones (normal + tipos de daltonismo) de un vector
# de colores.
cvd_versions <- function(cols) {
  if (!has_colorspace) return(list("Visión normal" = cols))
  list(
    "Visión normal"          = cols,
    "Deuteranopía (~6% H)"   = colorspace::deutan(cols),
    "Protanopía (~2% H)"     = colorspace::protan(cols),
    "Tritanopía (rara)"      = colorspace::tritan(cols)
  )
}

# ---- 4. Dibujar swatches ----------------------------------------------

# Una fila de rectángulos de color con su hex debajo.
draw_swatch_row <- function(cols, y, row_label, label_hex = TRUE) {
  n  <- length(cols)
  x0 <- seq(0, 1, length.out = n + 1)[-(n + 1)]
  w  <- 1 / n
  rect(x0, y, x0 + w, y + 0.7, col = cols, border = "grey40", lwd = 0.5)
  text(-0.02, y + 0.35, row_label, adj = 1, cex = 0.7, xpd = NA)
  if (label_hex && n <= 12) {
    text(x0 + w / 2, y + 0.35, cols, cex = 0.42,
         col = ifelse(colSums(col2rgb(cols)) < 330, "white", "black"))
  }
}

# Una página: una paleta mostrada bajo cada tipo de visión.
draw_palette_page <- function(name, cols) {
  vers <- cvd_versions(cols)
  k    <- length(vers)
  op <- par(mar = c(0.5, 8, 3, 1)); on.exit(par(op))
  plot(NA, xlim = c(0, 1), ylim = c(0, k), axes = FALSE, xlab = "", ylab = "")
  title(main = sprintf("%s  —  %d colores", name, length(cols)), cex.main = 1.1)
  ys <- rev(seq(0, k - 1)) + 0.15
  for (i in seq_len(k)) {
    draw_swatch_row(vers[[i]], ys[i], names(vers)[i],
                    label_hex = (i == 1))  # hex solo en la fila normal
  }
}

pdf("palette_comparison.pdf", width = 9, height = 6)
# Sección de 6 colores
for (nm in names(palettes_6)) draw_palette_page(nm, palettes_6[[nm]])
# Sección de 12 colores
for (nm in names(palettes_12)) draw_palette_page(nm, palettes_12[[nm]])
dev.off()
cat("\n[ok] Escrito: palette_comparison.pdf\n")

# ---- 5. Demo ggplot (opcional) ----------------------------------------

if (requireNamespace("ggplot2", quietly = TRUE)) {
  library(ggplot2)
  set.seed(1)
  demo_df <- data.frame(
    etapa = factor(paste0("Etapa ", 1:6), levels = paste0("Etapa ", 1:6)),
    valor = c(8, 5, 6, 9, 4, 7)
  )
  make_demo <- function(name, cols) {
    ggplot(demo_df, aes(etapa, valor, fill = etapa)) +
      geom_col() +
      scale_fill_manual(values = cols) +
      labs(title = name, x = NULL, y = "Valor") +
      theme_minimal(base_size = 11) +
      theme(legend.position = "none")
  }
  pdf("palette_demo.pdf", width = 7, height = 4.5)
  for (nm in names(palettes_6)) print(make_demo(nm, palettes_6[[nm]]))
  dev.off()
  cat("[ok] Escrito: palette_demo.pdf (barras de ejemplo por paleta)\n")
} else {
  message("[aviso] ggplot2 no disponible: se omite palette_demo.pdf")
}

cat("\nListo. Abra palette_comparison.pdf para comparar.\n")
cat("Cuando elija, dígame cuál (ACTUAL/A/B/C) y la aplico en R/rlt_theme.R\n")
cat("y en los 7 capítulos con tema inline (108,110,112,114,115,118,122).\n")
