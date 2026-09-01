# Figuras del libro: entrega corregida

**Introducción a la Dinámica Poblacional de Orquídeas** Entrega del 1 de septiembre de 2026. Sustituye por completo a la entrega anterior.

## Qué se corrigió

En la entrega anterior el número de cada carpeta no correspondía al número del capítulo. El error estaba únicamente en el **etiquetado de la entrega**, no en el libro: las figuras, sus pies y su numeración dentro del texto siempre fueron correctos.

El script que arma esta carpeta ordenaba los capítulos alfabéticamente por nombre de archivo, en vez de seguir el orden real del libro. De ahí los tres síntomas que ustedes detectaron:

1.  Las carpetas 1 a 14 iban un número por debajo del capítulo real (la carpeta 1 contenía las figuras del capítulo 2).
2.  La secuencia se rompía a partir de la carpeta 15, porque los dos capítulos de la parte «Historia» van al final del libro (capítulos 21 y 22) aunque sus archivos empiecen por 117 y 118. Por eso la «figura 15.1» aparecía fuera de lugar: es en realidad la figura 21.1, del capítulo 21.
3.  Faltaba la carpeta 17, porque el capítulo 16 (COMPADRE y las orquídeas) no tiene ninguna figura y la carpeta no llegaba a crearse.

Ya está corregido en el origen, de modo que las entregas futuras salen bien numeradas directamente.

## Cómo leer esta carpeta

Cada carpeta es un capítulo, y su número **es** el número del capítulo en el libro. Dentro, cada archivo lleva el prefijo `Fig_X.Y_`, donde `X` es el capítulo y `Y` la posición de la figura dentro de ese capítulo. Así, el archivo `Fig_12.3_...` es la «Figura 12.3» del texto.

Los capítulos 1 (preliminares), 16 (COMPADRE y las orquídeas), 20 (Conclusión) y 23 (Agradecimientos), y los apéndices B y C, no contienen ninguna figura. Su carpeta se incluye vacía, con un archivo `SIN_FIGURAS.txt`, para que la secuencia de carpetas no tenga huecos.

Las figuras del apéndice A salen numeradas como `Fig_A.1` y `Fig_A.2`. En el texto aparecen como «Figura 1» y «Figura 2», porque el apéndice no lleva número de capítulo. Si prefieren «Figura A.1» y «Figura A.2» en el texto impreso, podemos ajustarlo.

## Formatos

La mayoría de las figuras vienen en dos versiones con el mismo nombre:

- `.png`, mapa de bits, para consulta rápida y para la versión digital.
- `.pdf`, vectorial, que es la que conviene colocar en la diagramación siempre que exista, porque no pierde definición al ampliarse.

Las fotografías de campo vienen solo en `.jpg` o `.jpeg`, que es su formato original.

## Referencia cruzada

`Figuras_Inventario.csv` acompaña esta entrega y lista, para cada figura: el capítulo, el archivo `.qmd` de origen, el número de figura, el tipo, la ruta del `.png` y del `.pdf`, y el pie de figura completo. Sirve para cotejar cualquier figura con su lugar en el texto.

Cualquier duda, con gusto la aclaro.

Raymond L. Tremblay
