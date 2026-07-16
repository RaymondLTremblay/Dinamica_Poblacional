# Plan para mejorar la indexación y descubribilidad en Google

**Libro:** *Introducción a la Dinámica Poblacional de Orquídeas*
**URL:** https://raymondltremblay.github.io/Dinamica_Poblacional/
**Repositorio:** https://github.com/raymondltremblay/Dinamica_Poblacional

> Estado al 9 de junio de 2026: configuración técnica correcta (sitemap, robots.txt, verificación, títulos y meta-descripciones únicas, sin `noindex`). Sitemap **ya enviado** a Search Console con estado *Success*. **DOI de Zenodo ya existe y está bien integrado** (`10.5281/zenodo.20498242`): meta-etiquetas `citation_*` de Google Scholar en el `index.qmd`, cita completa + BibTeX en el prefacio, insignia en el `README.md`, licencia CC BY-NC 4.0. El cuello de botella restante **no es técnico**: es la **autoridad** del sitio (un dominio `github.io` nuevo, sin enlaces externos, con contenido reciente). La palanca que realmente queda por trabajar es **enlaces entrantes** desde páginas que Google sí indexe y siga.

---

## Palanca 1 — Enlaces entrantes (lo más importante)

Cada enlace desde un sitio que Google ya considera confiable le dice "este contenido importa, indéxalo". Para un sitio académico nuevo, conseguir 5–10 buenos enlaces vale más que cualquier ajuste técnico. Orden sugerido, de mayor a menor impacto y facilidad:

### A. Tus propios perfiles académicos (rápido, alta confianza)

Estos son los más fáciles — los controlas tú — y Google los rastrea con frecuencia.

1. **Google Scholar** — añade el libro como una entrada ("Add article manually") en tu perfil, con el enlace al sitio. Señal académica directa para Google.
2. **ORCID** — en *Works* → *Add work*, añade el libro con la URL (y el DOI una vez lo tengas, ver Palanca 2).
3. **ResearchGate** — sube el libro como *Book* o *Other* con el enlace al sitio HTML y/o el PDF.
4. **Página de facultad / institucional** — pide que el libro aparezca en tu listado de publicaciones o recursos docentes. Un enlace desde un dominio `.edu`/universitario pesa mucho.
5. **LinkedIn / perfil personal** — en *Featured* o *Publications*, con la URL.

### B. Comunidades temáticas (medio esfuerzo, muy relevantes por tema)

Google valora enlaces desde sitios temáticamente afines.

6. **COMPADRE / COMADRE (Padrino / rcompadre)** — el libro usa estas bases; pregunta a los mantenedores si pueden listarlo como recurso educativo en español (su web o repositorio de recursos).
7. **Comunidad Rage / paquetes de demografía en R** — viñetas, wiki o lista de recursos del paquete.
8. **Sociedades de orquídeas** (p. ej. sociedades regionales, grupos de orquideología, jardines botánicos como Lankester) — recurso docente en español sobre demografía de orquídeas es poco común; ofrécelo para su sección de recursos.
9. **r-bloggers / comunidad R en español** — si publicas una entrada de blog anunciando el libro, puede sindicarse y generar enlaces.

### C. Difusión social y mención (bajo esfuerzo, refuerzo)

No son enlaces "fuertes" para SEO pero aceleran el descubrimiento inicial y generan tráfico.

10. **Bluesky / Mastodon / X** — anuncio con la URL. Las comunidades #rstats y de ecología son activas.
11. **Listas de correo** académicas (ECOLOG-L, listas de botánica/ecología en español).

### Texto reutilizable para los anuncios

> *Introducción a la Dinámica Poblacional de Orquídeas* — un libro digital gratuito y en español sobre dinámica poblacional, desde la recolección de datos en el campo hasta modelos matriciales, estimación bayesiana de transiciones, elasticidad, LTRE, dinámica transitoria y simulaciones estocásticas, con un capítulo crítico sobre el impacto de datos sin sentido biológico. Hecho con R y Quarto.
> 👉 https://raymondltremblay.github.io/Dinamica_Poblacional/

**Meta realista:** 5–10 enlaces de calidad en las próximas semanas. No hace falta cantidad; hace falta confianza temática.

---

## Palanca 2 — DOI en Zenodo: YA HECHO (con un matiz importante)

El DOI ya existe y está **muy bien integrado** — mejor que en la mayoría de los libros publicados:

- DOI: **`10.5281/zenodo.20498242`** (versión v.1.0.0, publicada 1 de junio de 2026, licencia CC BY-NC 4.0).
- Meta-etiquetas `citation_*` de Google Scholar en el `<head>` del `index.qmd` (autores, fecha, DOI, idioma, URL del resumen).
- Cita formateada + BibTeX en el prefacio del libro.
- Insignia del DOI en el `README.md`.
- Registrado en **DataCite** y indexado en **OpenAIRE**.

No hay que crear nada. Sirve para descubrimiento académico (Google Scholar, OpenAIRE, DataCite) y da a otros una forma estándar de citarte.

### ⚠ Matiz importante para SEO web

Las páginas de registro de Zenodo se sirven con `<meta robots="noindex, nofollow">`. Esto significa que **Zenodo NO transmite "autoridad de enlace" a tu sitio** en el índice web de Google: Google no indexa la página del registro ni sigue sus enlaces. Por tanto, el DOI ayuda muchísimo en **Google Scholar** y en el mundo académico, pero **no** cuenta como un enlace entrante que mejore tu posición en la búsqueda web general.

**Conclusión:** el DOI ya hace su trabajo académico. Para el problema concreto de indexación en la búsqueda web de Google, lo que falta son **enlaces desde páginas que Google sí indexa y sigue** (Palanca 1). Esa es ahora la prioridad real.

### Único ajuste opcional en Zenodo

En el registro, *Related works* solo enlaza al **repositorio de GitHub** ("Is supplement to: Software"). Puedes añadir también el **sitio del libro** como recurso relacionado (edita el registro → *Related works* → añade `https://raymondltremblay.github.io/Dinamica_Poblacional/`, relación *"is identical to"* o *"is supplement to"*). Es cosmético para SEO (la página es nofollow), pero completa los metadatos académicos. Baja prioridad.

---

## Después: empujón manual en Search Console

Para las 2 páginas en "Crawled – currently not indexed" (y cualquier capítulo que tarde en aparecer):

1. En Search Console, pega la URL de la página en la barra **"Inspect any URL"** de arriba.
2. Si dice "URL is not on Google", pulsa **Request indexing**.
3. Repite para las páginas clave (no hace falta para las 31; prioriza index, los capítulos principales y los que más te importen).

Esto es un empujón puntual; no sustituye a la autoridad, pero acelera el re-rastreo de páginas concretas.

---

## Resumen de prioridades

1. ✅ **Sitemap enviado** (hecho — *Success*).
2. ✅ **DOI en Zenodo** (hecho — bien integrado; sirve para Scholar/OpenAIRE, no para ranking web por ser noindex/nofollow).
3. **Enlaces entrantes** ← *prioridad real ahora*. Empieza por tus perfiles (Scholar, ORCID, ResearchGate, página de facultad) esta semana, luego comunidades temáticas (COMPADRE/Rage, sociedades de orquídeas).
4. **Request indexing** en Search Console para las páginas rezagadas.
5. **Espera y observa** el informe *Pages* subir de 10 hacia 31 en las próximas semanas. En un dominio nuevo, esto es normal que tome tiempo.
