# Kit de enlaces entrantes — contenido listo para copiar y pegar

Objetivo: conseguir 5–10 enlaces de calidad hacia el libro desde páginas que Google **sí** indexa y sigue. Cada bloque de abajo trae los valores exactos para pegar en cada plataforma. Trabaja de arriba hacia abajo; las primeras (tus propios perfiles) son las más rápidas y las que controlas tú.

## Datos base (los mismos en todas partes)

| Campo | Valor |
|---|---|
| **Título** | Introducción a la Dinámica Poblacional de Orquídeas |
| **Autores** | Tremblay, R. L.; Emeterio-Lara, A.; González, E. J.; González, E.; Hernández-Apolinar, M.; Mondragón, D.; Mujica Benitez, E.; Portillo Tzompa, P.; Ramírez-Martínez, A.; Ticktin, T. |
| **Año** | 2026 |
| **Editor / Publisher** | Zenodo (edición digital) |
| **DOI** | 10.5281/zenodo.20498242 |
| **URL del libro** | https://raymondltremblay.github.io/Dinamica_Poblacional/ |
| **DOI como URL** | https://doi.org/10.5281/zenodo.20498242 |
| **Licencia** | CC BY-NC 4.0 |
| **Idioma** | Español |

> Regla SEO: siempre que puedas, enlaza a la **URL del libro** (`raymondltremblay.github.io/...`), no solo al DOI. El DOI ayuda en el mundo académico, pero la página de Zenodo es `nofollow` y no transmite autoridad de enlace. El enlace que mueve la aguja es el que apunta directo a tu sitio.

---

## 1. Google Scholar (tu perfil) — rápido

Google Scholar suele indexar el libro solo, gracias a las meta-etiquetas `citation_*` que ya tienes en `index.qmd`. Para asegurarlo, añádelo manualmente a tu perfil:

1. Entra a tu perfil de Scholar → botón **+** → **Add article manually**.
2. Tipo: **Book**. Pega estos campos:

```
Title:            Introducción a la Dinámica Poblacional de Orquídeas
Authors:          R L Tremblay, A Emeterio-Lara, E J González, E González,
                  M Hernández-Apolinar, D Mondragón, E Mujica Benitez,
                  P Portillo Tzompa, A Ramírez-Martínez, T Ticktin
Publication date: 2026
Publisher:        Zenodo
```

> El formulario de Scholar no tiene campo de URL para libros; el vínculo real lo crea el rastreo de tu página. Lo importante es que la entrada exista en tu perfil (señal de autoría) y que la página del libro siga accesible.

---

## 2. ORCID — rápido, incluye URL y DOI

1. Entra a https://orcid.org → tu perfil → sección **Works** → **Add** → **Add manually**.
2. Rellena:

```
Work category:    Publication
Work type:        Book
Title:            Introducción a la Dinámica Poblacional de Orquídeas
Publication date: 2026
URL:              https://raymondltremblay.github.io/Dinamica_Poblacional/
```

3. En **Add external identifier**:

```
Identifier type:  DOI
Identifier value: 10.5281/zenodo.20498242
Identifier URL:   https://doi.org/10.5281/zenodo.20498242
Relationship:     Self
```

> Atajo: si ya está en Zenodo con tu ORCID, puede aparecer automáticamente vía la conexión Zenodo↔ORCID. Revisa primero si ya figura antes de añadirlo a mano.

---

## 3. ResearchGate — incluye enlace al texto completo

1. **Add new** → **Published research** → tipo **Book**.
2. Campos:

```
Title:        Introducción a la Dinámica Poblacional de Orquídeas
Authors:      (añádete a ti y a los coautores que tengan cuenta)
Publication:  2026
DOI:          10.5281/zenodo.20498242
```

3. En el campo de enlace / "Add resource" pon la **URL del libro** y/o sube el PDF.
4. Tras publicarlo, escribe una breve actualización (post) en tu perfil con la URL — genera un enlace adicional y avisa a tus seguidores.

---

## 4. Página de facultad / institucional — el enlace más valioso

Un enlace desde un dominio universitario (`.edu`, `.upr.edu`, etc.) pesa mucho. Pide que añadan esto a tu listado de publicaciones o recursos docentes. Texto listo:

> **Tremblay, R. L., et al. (2026).** *Introducción a la Dinámica Poblacional de Orquídeas.* Libro digital de acceso abierto. DOI: [10.5281/zenodo.20498242](https://doi.org/10.5281/zenodo.20498242). Disponible en línea: [raymondltremblay.github.io/Dinamica_Poblacional](https://raymondltremblay.github.io/Dinamica_Poblacional/)

Versión HTML (si quien administra la página acepta HTML):

```html
<p><strong>Tremblay, R. L., et al. (2026).</strong>
<em>Introducción a la Dinámica Poblacional de Orquídeas.</em>
Libro digital de acceso abierto.
DOI: <a href="https://doi.org/10.5281/zenodo.20498242">10.5281/zenodo.20498242</a>.
Disponible en línea:
<a href="https://raymondltremblay.github.io/Dinamica_Poblacional/">raymondltremblay.github.io/Dinamica_Poblacional</a>.</p>
```

---

## 5. Comunidades temáticas

Correo / mensaje breve para pedir que listen el libro como recurso. Personaliza el saludo:

> Estimado/a [nombre]:
>
> Quería compartir un libro digital gratuito y en español que podría ser útil para su comunidad: *Introducción a la Dinámica Poblacional de Orquídeas*. Cubre desde la recolección de datos en el campo hasta modelos matriciales de proyección, estimación bayesiana de transiciones, elasticidad, LTRE, dinámica transitoria y simulaciones estocásticas, con un capítulo crítico sobre el impacto de datos sin sentido biológico. Está hecho con R y usa COMPADRE y Rage en varios ejemplos.
>
> Si les parece pertinente, ¿podrían incluirlo en su sección de recursos? Enlace: https://raymondltremblay.github.io/Dinamica_Poblacional/ — DOI: https://doi.org/10.5281/zenodo.20498242
>
> Gracias,
> Raymond L. Tremblay

Destinatarios sugeridos: mantenedores de COMPADRE/COMADRE y de los paquetes `Rcompadre`/`Rage`; sociedades de orquídeas y jardines botánicos (p. ej. Lankester); listas docentes de ecología en español.

---

## 6. Difusión social (refuerzo de descubrimiento)

**Versión corta (Bluesky / Mastodon / X) — español:**

> 📖 Nuevo libro digital gratuito y en español: *Introducción a la Dinámica Poblacional de Orquídeas*. De los datos de campo a los modelos matriciales, métodos bayesianos, LTRE y simulaciones estocásticas — todo en R. #rstats #ecología #orquídeas
> 👉 https://raymondltremblay.github.io/Dinamica_Poblacional/

**Short version (English, for international #rstats / ecology reach):**

> 📖 New free, open-access book (in Spanish): *Introducción a la Dinámica Poblacional de Orquídeas* — orchid population dynamics from field data to matrix models, Bayesian transitions, LTRE & stochastic simulations, all in R. #rstats #ecology
> 👉 https://raymondltremblay.github.io/Dinamica_Poblacional/

---

## Lista de seguimiento

Marca cada enlace cuando lo consigas (apunta a que Google rastree páginas que sí siguen enlaces):

- [x] Google Scholar (perfil) ✅ 2026-06-09
- [x] ORCID ✅ 2026-06-09
- [x] ResearchGate (entrada + post) ✅ 2026-06-09
- [ ] Página de facultad / institucional ← siguiente (mayor peso)
- [ ] COMPADRE / Rage (recurso o mención)
- [ ] Sociedad de orquídeas / jardín botánico
- [ ] Publicación social (Bluesky/Mastodon/X)
- [ ] (opcional) Entrada de blog / r-bloggers

Cuando tengas 3–4 de estos, vuelve a Search Console → **Request indexing** en los capítulos clave y observa el informe *Pages* subir.
