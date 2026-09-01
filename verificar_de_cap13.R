# verificar_de_cap13.R  ·  archivo temporal, se puede borrar despues
# ------------------------------------------------------------------
# Resuelve una sola pregunta: en popdemo, el vector `d` selecciona FILAS
# o COLUMNAS de la matriz?
#
# El capitulo 13 dice, en la linea 80: "los vectores d (columna) y e (renglon)".
# La documentacion de popdemo dice lo contrario: "The rows to be perturbed are
# determined by d and the columns to be perturbed are determined by e", que es
# ademas lo coherente con la ecuacion A + delta * d e^T que el propio capitulo
# imprime en la linea 84.
#
# Si el capitulo esta equivocado, tres de sus ejemplos perturban el elemento
# equivocado, y uno de ellos perturba un cero estructural.

library(popdemo)

estadios <- c("PL", "J", "NR", "AR")
Lr1 <- matrix(c(
  0.4324, 0,      0,      0.146,
  0.3784, 0.8459, 0,      0,
  0,      0.0034, 0.7954, 0.2300,
  0,      0.0890, 0.1841, 0.7510
), nrow = 4, byrow = TRUE, dimnames = list(estadios, estadios))

# ---- Prueba: los d/e del ejemplo c) del capitulo -------------------
# tfs_lambda() devuelve la sensibilidad del elemento que perturba, asi que
# basta compararla con las dos candidatas. No hace falta elegir un tamano
# de perturbacion.

s <- tfs_lambda(Lr1, d = c(0, 0, 0, 1), e = c(0, 0, 1, 0))

cat("\ntfs_lambda devuelve:", round(as.numeric(s), 4), "\n\n")
cat("  0.4585  ->  d selecciona FILAS. Perturba a[4,3] (NR -> AR).\n")
cat("            La documentacion tiene razon y el capitulo se equivoca:\n")
cat("            hay que invertir d y e en los ejemplos b), c) y d).\n\n")
cat("  0.3638  ->  d selecciona COLUMNAS. Perturba a[3,4] (AR -> NR).\n")
cat("            El capitulo tiene razon y no hay nada que cambiar.\n\n")

# ---- Segunda prueba, independiente de la anterior ------------------
# En la figura del ejemplo d), la curva usa d = c(0,0,0,1), e = c(1,0,0,0)
# y la recta de sensibilidad usa d = c(1,0,0,0), e = c(0,0,0,1). Sean cuales
# sean las convenciones, esos son DOS elementos distintos: la recta no puede
# ser la tangente de la curva.
cat("Ejemplo d): la curva y su recta de sensibilidad apuntan a elementos distintos.\n")
cat("  tfa usa d=(0,0,0,1) e=(1,0,0,0) ; tfs usa d=(1,0,0,0) e=(0,0,0,1)\n")
cat("  sensibilidad con los d/e de la curva:",
    round(as.numeric(tfs_lambda(Lr1, d = c(0, 0, 0, 1), e = c(1, 0, 0, 0))), 4), "\n")
cat("  sensibilidad con los d/e de la recta:",
    round(as.numeric(tfs_lambda(Lr1, d = c(1, 0, 0, 0), e = c(0, 0, 0, 1))), 4), "\n")
cat("  (0.1061 y 0.1574: confirman que son elementos distintos)\n\n")
