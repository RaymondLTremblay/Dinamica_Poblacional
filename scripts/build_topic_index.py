#!/usr/bin/env python3
"""
build_topic_index.py — genera Apendice_Indice_Temas.qmd, el índice
analítico del libro. A diferencia de un índice tradicional con números
de página, éste apunta a capítulo y sección de cada aparición de un
término — apropiado para un libro digital donde el número de página
no es estable.

El vocabulario indexable se deriva de los términos del glosario
(Apendice_Glosario.qmd) + algunos términos adicionales curados aquí.
Para cada término se busca su aparición en cada capítulo y se reporta
la sección (encabezado `##` o `###`) más cercana arriba.

Uso:
    python3 scripts/build_topic_index.py
"""

from __future__ import annotations
import re
from pathlib import Path
from collections import defaultdict

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "Apendice_Indice_Temas.qmd"

CHAPTERS = [
    ("102-Intro.qmd",                          "1. Introducción"),
    ("103-Ciclos_de_Vida.qmd",                 "2. Ciclos de Vida"),
    ("104-Recopilacion_datos_en_el_campo.qmd", "3. Recopilación de datos"),
    ("105-Transiciones.qmd",                   "4. Transiciones"),
    ("106-calcular_fecundidad.qmd",            "5. Fecundidad"),
    ("107-matU_matF_matC.qmd",                 "6. Matrices U, F y C"),
    ("108-Bayesian_PPM.qmd",                   "7. Acercamiento bayesiano"),
    ("109-Crecimiento_poblacional.qmd",        "8. Crecimiento poblacional"),
    ("110-Propriedades.qmd",                   "9. Propiedades de la matriz"),
    ("111-Elasticidad.qmd",                    "10. Elasticidad y sensibilidad"),
    ("112-Dinamica_de_Transiciones.qmd",       "11. Dinámica transitoria"),
    ("113-Funciones_de_Transferencia.qmd",     "12. Funciones de transferencia"),
    ("114-LTRE.qmd",                           "13. LTRE"),
    ("115-Metodos_de_simulaciones.qmd",        "14. Métodos de simulaciones"),
    ("117_Historia_breve.qmd",                 "15. Historia breve"),
    ("118-Carl_Olaf_Tamm.qmd",                 "16. Carl Olaf Tamm"),
    ("119-COMPADRE_ORCHIDS.qmd",               "17. COMPADRE"),
    ("120-Rage_orquideas.qmd",                 "18. Rage"),
    ("121-Traduccion_protocolo_informacion.qmd","19. Protocolo estándar"),
    ("122-Impacto_de_Datos_sin_Sentido.qmd",   "20. Datos sin sentido"),
    ("123-Conclusion.qmd",                     "21. Conclusión"),
]

# Vocabulario indexable: (clave-de-orden, regex, etiqueta).
# La clave es lo que se usa para ordenar alfabéticamente.
# El regex es lo que se busca (case-insensitive por defecto).
# La etiqueta es lo que se muestra en el índice.
TERMS = [
    # A
    # NOTA: nombres de autores (Ackerman, Caswell, Ebert, Hutchings, Morris/Doak,
    # Mondragón, Sarukhán, Silvertown, Stott, Tamm, Tremblay, Tuljapurkar,
    # Pellegrino, Salguero-Gómez, Gascoigne) se han retirado del vocabulario:
    # son referencias citadas, no temas del libro. Para encontrar a un autor,
    # use la bibliografía o la búsqueda de texto del navegador.
    ("Adulto",                   r"\badultos?\s+(reproductiv|no reproductiv)",      "Adulto (reproductivo / no reproductivo)"),
    ("Alogamia",                 r"\balogam[íi]a\b",                     "Alogamia"),
    ("Amplificación",            r"\bamplificaci[óo]n\b",                "Amplificación (máxima)"),
    ("Análisis bayesiano",       r"\b(an[áa]lisis bayesiano|m[ée]todos? bayesianos?|marco bayesiano)\b", "Análisis bayesiano"),
    ("Análisis de perturbación", r"\ban[áa]lisis de perturbaci[óo]n\b",  "Análisis de perturbación"),
    ("Análisis de sensibilidad", r"\ban[áa]lisis de sensibilidad\b",     "Análisis de sensibilidad"),
    ("Análisis prospectivo",     r"\b(prospectiv[ao]s?)\b",              "Análisis prospectivo"),
    ("Análisis retrospectivo",   r"\bretrospectiv[ao]s?\b",              "Análisis retrospectivo"),
    ("Asintótica (dinámica)",    r"\b(crecimiento asint[óo]tico|asint[óo]ticas?)\b", "Asintótica, dinámica"),
    ("Atenuación",               r"\batenuaci[óo]n\b",                   "Atenuación (máxima)"),
    ("Autocompatibilidad",       r"\bautocompatibili(dad|es)\b",         "Autocompatibilidad"),
    ("Autogamia",                r"\bautogam[íi]a\b",                    "Autogamia"),
    ("Autovalor",                r"\b(autovalor|valor propio|eigenvalor)\b", "Autovalor (eigenvalor)"),
    ("Autovector",               r"\b(autovector|vector propio|eigenvector)\b", "Autovector (eigenvector)"),
    # B
    ("Banco de semillas",        r"\bbancos? de semillas?\b",            "Banco de semillas"),
    ("Bayes (fórmula)",          r"\b(f[óo]rmula|regla|teorema) de Bayes\b", "Bayes, fórmula de"),
    ("Beta (distribución)",      r"\bdistribuci[óo]n beta\b",            "Beta, distribución"),
    ("Birth-flow",               r"\b(birth[- ]?flow|nacimiento[- ]?flujo)\b", "Birth-flow / nacimiento-flujo"),
    ("Birth-pulse",              r"\b(birth[- ]?pulse|nacimiento[- ]?pulso)\b", "Birth-pulse / nacimiento-pulso"),
    ("Bootstrap",                r"\bbootstrap\b",                       "Bootstrap"),
    # C
    ("Cadena de Markov",         r"\bcadenas? de Markov\b|\bMCMC\b",     "Cadena de Markov / MCMC"),
    ("Cápsula",                  r"\bc[áa]psulas?\b",                    "Cápsula (fruto)"),
    ("Censo",                    r"\bcensos?\b",                         "Censo"),
    ("Censo pre-reproductivo",   r"\bcenso pre[- ]reproductivo\b",       "Censo pre-reproductivo"),
    ("Censo post-reproductivo",  r"\bcenso post[- ]reproductivo\b",      "Censo post-reproductivo"),
    ("Ciclo de vida",            r"\bciclos? de vida\b",                 "Ciclo de vida"),
    ("Cleistogamia",             r"\bcleist[óo]gam[ao]s?\b",             "Cleistogamia"),
    ("Clonal (reproducción)",    r"\b(reproducci[óo]n clonal|clonaje)\b","Clonal, reproducción"),
    ("Cohorte",                  r"\bcohortes?\b",                       "Cohorte"),
    ("COMADRE",                  r"\bCOMADRE\b",                         "COMADRE"),
    ("COMPADRE",                 r"\bCOMPADRE\b",                        "COMPADRE"),
    ("Conservación",             r"\bbiolog[íi]a de la conservaci[óo]n\b|\bplanes? de conservaci[óo]n\b", "Conservación biológica"),
    ("Conservación ex situ",     r"\bex situ\b",                         "Conservación ex situ"),
    ("Conservación in situ",     r"\bin situ\b",                         "Conservación in situ"),
    ("Cormo",                    r"\bcormos?\b",                         "Cormo"),
    ("Cosecha",                  r"\bcosechas?\b|\bextracci[óo]n sostenible\b", "Cosecha sostenible"),
    ("Crecimiento individual",   r"\bcrecimiento individual\b",          "Crecimiento individual"),
    ("Crecimiento poblacional",  r"\b(crecimiento poblacional|tasa de crecimiento)\b", "Crecimiento poblacional"),
    ("Cuantil",                  r"\bcuantiles?\b|\bquantile\b",         "Cuantil"),
    # D
    ("Damping ratio",            r"\b(damping ratio|raz[óo]n de amortiguamiento)\b", "Damping ratio (ρ)"),
    ("Datos sin sentido",        r"\bdatos sin sentido\b",               "Datos sin sentido biológico"),
    ("Densodependencia",         r"\b(densodepend|densidad-depend|denso[- ]depend)",  "Densodependencia"),
    ("Desviación estándar",      r"\bdesviaci[óo]n est[áa]ndar\b",       "Desviación estándar"),
    ("Diagrama del ciclo de vida", r"\bdiagramas? del? ciclos? de vida\b", "Diagrama del ciclo de vida"),
    ("DiagrammeR",               r"\bDiagrammeR\b",                      "DiagrammeR (paquete R)"),
    ("Dinámica poblacional",     r"\bdin[áa]mica poblacional\b",         "Dinámica poblacional"),
    ("Dinámica transitoria",     r"\bdin[áa]mica transitoria\b",         "Dinámica transitoria"),
    ("Dirichlet",                r"\bDirichlet\b",                       "Dirichlet, distribución"),
    ("Dispersión",               r"\bdispersi[óo]n\b",                   "Dispersión (de semillas)"),
    ("dplyr",                    r"\bdplyr\b",                           "dplyr (paquete R)"),
    ("Dust-seeds",               r"\b(dust[- ]?seeds?|semillas? polvo)\b","Dust-seeds (semillas polvo)"),
    # E
    ("Edad reproductiva",        r"\bedad reproductiva\b|\bmadurez reproductiva\b", "Edad reproductiva"),
    ("Elasticidad",              r"\belasticidad\b",                     "Elasticidad"),
    ("Elasticidad no lineal",    r"\belasticidad no lineal\b",           "Elasticidad no lineal"),
    ("Endémica",                 r"\bend[ée]micas?\b",                   "Endémica, especie"),
    ("Epífita",                  r"\bep[íi]fitas?\b",                    "Epífita"),
    ("Ergodicidad",              r"\bergodi(cidad|ca|co|cas?)\b",        "Ergodicidad"),
    ("Error estándar",           r"\berror est[áa]ndar\b",               "Error estándar"),
    ("Esperanza de vida",        r"\besperanzas? de vida\b",             "Esperanza de vida"),
    ("Especie en peligro",       r"\bespecies? en peligro\b|\bamenazada\b", "Especie en peligro / amenazada"),
    ("Especies invasoras",       r"\bespecies? invasoras?\b|\bespecies? invasivas?\b", "Especies invasoras"),
    ("Estadio",                  r"\bestadios?\b",                       "Estadio"),
    ("Estasis",                  r"\bestasis\b",                         "Estasis"),
    ("Estocasticidad ambiental", r"\bestocasticidad ambiental\b",        "Estocasticidad ambiental"),
    ("Estocasticidad demográfica",r"\bestocasticidad demogr[áa]fica\b",  "Estocasticidad demográfica"),
    ("Estructura estable",       r"\bestructura estable\b",              "Estructura estable (w)"),
    ("Estructura poblacional",   r"\bestructura poblacional\b",          "Estructura poblacional"),
    ("Extinción",                r"\bextinci[óo]n\b",                    "Extinción, riesgo de"),
    # F
    ("Fecundidad",               r"\bfecundidad\b",                      "Fecundidad"),
    ("Fecundidad potencial",     r"\bfecundidad potencial\b",            "Fecundidad potencial"),
    ("Fecundidad realizada",     r"\bfecundidad realizada\b",            "Fecundidad realizada"),
    ("Flexible / Lefkovitch",    r"\bLefkovitch\b",                      "Lefkovitch (modelo de)"),
    ("flextable",                r"\bflextable\b",                       "flextable (paquete R)"),
    ("Flor",                     r"\bflores?\b",                         "Flor"),
    ("Floración",                r"\bfloraci[óo]n\b",                    "Floración"),
    ("Forófito",                 r"\bfor[óo]fitos?\b",                   "Forófito"),
    ("Frecuentista",             r"\bfrecuentista\b",                    "Frecuentista, estadística"),
    ("Fruto",                    r"\b(fruto|frutos)\b",                  "Fruto"),
    ("Función de transferencia", r"\bfunci(ó|o)n(es)? de transferencia\b","Función de transferencia"),
    # G
    ("Gamma (distribución)",     r"\bdistribuci[óo]n Gamma\b|\bGamma\(", "Gamma, distribución"),
    ("ggplot2",                  r"\bggplot2?\b",                        "ggplot2 (paquete R)"),
    ("Germinación",              r"\bgerminaci[óo]n\b",                  "Germinación"),
    ("GLM",                      r"\bGLM\b|\bgeneralized linear model\b","GLM (modelo lineal generalizado)"),
    # H
    ("Hábitat",                  r"\bh[áa]bitats?\b",                    "Hábitat"),
    ("Herbivoría",               r"\bherbivor[íi]a\b",                   "Herbivoría"),
    ("Heterogeneidad",           r"\bheterogeneidad\b",                  "Heterogeneidad"),
    ("Hospedero",                r"\bhospederos?\b|\b[áa]rbol hospedero\b", "Hospedero (forófito)"),
    # I
    ("Inercia poblacional",      r"\binercia poblacional\b",             "Inercia poblacional"),
    ("Inferencia",               r"\binferenci(a|al)\b",                 "Inferencia estadística"),
    ("Intervalo de confianza",   r"\bintervalo[s]? de confianza\b",      "Intervalo de confianza (IC)"),
    ("Intervalo de credibilidad",r"\bintervalo[s]? de credibilidad\b",   "Intervalo de credibilidad (ICr)"),
    ("Intervalo de proyección",  r"\bintervalo[s]? de proyecci[óo]n\b",  "Intervalo de proyección"),
    ("Invasiva (especie)",       r"\bespecies? invasivas?\b",            "Invasiva, especie"),
    ("Irreducibilidad",          r"\birreducib(le|ilidad)\b",            "Irreducibilidad"),
    # J
    ("Juvenil",                  r"\bjuveniles?\b",                      "Juvenil"),
    # K
    ("kable",                    r"\bkable\b",                           "kable (paquete R)"),
    # L
    ("Lambda",                   r"(?:\bλ\b|\\lambda|\blambda\b)",       "λ (lambda)"),
    ("Lambda-max",               r"\b\\lambda_\{max\}|λ_max|lambda max\b", "λ_max (tasa asintótica)"),
    ("Latencia vegetativa",      r"\blatencia vegetativa\b|\bdormancy\b","Latencia vegetativa (dormancy)"),
    ("Leslie",                   r"\bLeslie\b",                          "Leslie (modelo de)"),
    ("Limitación de polinizadores",r"\blimitaci[óo]n de polinizadores\b","Limitación de polinizadores"),
    ("LTRE",                     r"\bLTRE\b",                            "LTRE (Experimento de Tabla de Vida)"),
    # M
    ("Marcaje (de plantas)",     r"\bmarcaje\b|\betiquetado\b",          "Marcaje / etiquetado"),
    ("Matrices U F C",           r"\bmat(?:U|F|C)\b|\bU/F/C\b",          "Matrices U, F y C"),
    ("Matriz de proyección",     r"\bmatriz de proyecci[óo]n\b",         "Matriz de proyección poblacional"),
    ("Matriz reducible",         r"\bmatriz reducible\b",                "Matriz reducible"),
    ("Maximum likelihood",       r"\bm[áa]xima verosimilitud\b|\bMLE\b", "Máxima verosimilitud (MLE)"),
    ("MCMC",                     r"\bMCMC\b|\bMonte Carlo\b",            "MCMC / Monte Carlo"),
    ("Mediana",                  r"\bmedianas?\b",                       "Mediana"),
    ("Micorriza",                r"\bmicorriz[ao]s?\b|\bhongos? micorr[íi]z(ico|icos)\b", "Micorriza"),
    ("Migración",                r"\bmigraci[óo]n\b|\binmigraci[óo]n\b|\bemigraci[óo]n\b", "Migración / inmigración"),
    ("Módulo de iteración",      r"\bm[óo]dulos? de iteraci[óo]n\b|\bm[óo]dulos? de crecimiento\b", "Módulo de iteración"),
    ("Monopodial",               r"\bmonopodial\b",                      "Monopodial (crecimiento)"),
    ("Mortalidad",               r"\bmortalidad\b|\btasa de mortalidad\b","Mortalidad"),
    ("MPP",                      r"\bMPP\b",                             "MPP (Matriz de Proyección Poblacional)"),
    ("Muestreo",                 r"\b(m[ée]todos? de muestreo|tama[ñn]o de muestra)\b", "Muestreo / tamaño de muestra"),
    # N
    ("N (tamaño poblacional)",   r"\btama[ñn]o poblacional\b|\bN\s*=",   "N (tamaño poblacional)"),
    ("Néctar",                   r"\bn[ée]ctar\b",                       "Néctar"),
    ("Nicho ecológico",          r"\bnicho ecol[óo]gico\b|\bmicronichos?\b", "Nicho ecológico"),
    ("Normal (distribución)",    r"\b(distribuci[óo]n normal|gauss?iana?)\b", "Normal / Gaussiana, distribución"),
    # O
    ("Orchidaceae",              r"\bOrchidaceae\b",                     "Orchidaceae (familia)"),
    # P
    ("Perron-Frobenius",         r"\bPerron[- ]?Frobenius\b",            "Perron–Frobenius (teorema)"),
    ("Perturbación",             r"\bperturbaci(ó|o)n(es)?\b",           "Perturbación"),
    ("Pleurothalliinae",         r"\bPleurothalliinae\b",                "Pleurothalliinae"),
    ("Plántula",                 r"\bpl[áa]ntulas?\b",                   "Plántula"),
    ("Poisson (distribución)",   r"\bdistribuci[óo]n Poisson\b|\bPoisson\(", "Poisson, distribución"),
    ("Polen",                    r"\bpolen\b",                           "Polen"),
    ("Polinario",                r"\bpolinarios?\b|\bpolinia\b",         "Polinario / polinia"),
    ("Polinización",             r"\bpolinizaci[óo]n\b",                 "Polinización"),
    ("Polinización por engaño",  r"\bpolinizaci[óo]n por enga[ñn]o\b",   "Polinización por engaño"),
    ("Polinizador",              r"\bpolinizadores?\b",                  "Polinizador"),
    ("popbio",                   r"\bpopbio\b",                          "popbio (paquete R)"),
    ("popdemo",                  r"\bpopdemo\b",                         "popdemo (paquete R)"),
    ("Población",                r"\bpoblaci[óo]n\s+(cerrada|abierta|natural|estable)\b", "Población (cerrada/abierta/natural)"),
    ("Posterior (distribución)", r"\bdistribuci[óo]n posterior\b|\bposteriori\b", "Posterior, distribución"),
    ("Previa (distribución)",    r"\bdistribuci[óo]n previa\b|\bprevia (informativa|d[ée]bil|uniforme)\b", "Previa, distribución"),
    ("Primitiva (matriz)",       r"\bmatriz primitiva\b",                "Primitiva, matriz"),
    ("Probabilidad de extinción",r"\bprobabilidad de extinci[óo]n\b",    "Probabilidad de extinción"),
    ("Probabilidad de transición",r"\bprobabilidad de transici[óo]n\b",  "Probabilidad de transición"),
    ("Promedio (media)",         r"\b(promedio|media aritm[ée]tica)\b",  "Promedio (media)"),
    ("Propagación",              r"\bpropagaci[óo]n\b",                  "Propagación"),
    ("Protocormo",               r"\bprotocormos?\b",                    "Protocormo"),
    ("Pseudobulbo",              r"\bpseudobulbos?\b",                   "Pseudobulbo"),
    ("PVA",                      r"\bPVA\b|\bAn[áa]lisis de Viabilidad Poblacional\b", "PVA (Análisis de Viabilidad Poblacional)"),
    # Q
    ("Quarto",                   r"\bQuarto\b",                          "Quarto (sistema)"),
    # R
    ("R (lenguaje)",             r"\bR\s+(?:Studio|software|package|version)\b|\blenguaje R\b", "R, lenguaje"),
    ("Rage",                     r"\b[rR]age\b(?!\s*\d)",                "Rage (paquete R)"),
    ("Ramets",                   r"\bramets?\b",                         "Ramets"),
    ("Raretrans",                r"\b[rR]aretrans\b",                    "Raretrans (paquete R)"),
    ("Rcompadre",                r"\b[rR]compadre\b",                    "Rcompadre (paquete R)"),
    ("Reactividad",              r"\breactividad\b",                     "Reactividad"),
    ("Reclutamiento",            r"\breclutamiento\b",                   "Reclutamiento"),
    ("Recompensa floral",        r"\brecompensas? floral(es)?\b",        "Recompensa floral"),
    ("Reducible (matriz)",       r"\b(matriz )?reducible\b",             "Reducible, matriz"),
    ("Regresión",                r"\bregresi(ó|o)n(es)?\b",              "Regresión"),
    ("Reintroducción",           r"\breintroducci[óo]n\b|\btranslocaci[óo]n\b", "Reintroducción / translocación"),
    ("Reproducción asexual",     r"\breproducci[óo]n asexual\b",         "Reproducción asexual"),
    ("Reproducción sexual",      r"\breproducci[óo]n sexual\b",          "Reproducción sexual"),
    ("Reproducción vegetativa",  r"\breproducci[óo]n vegetativa\b",      "Reproducción vegetativa"),
    ("Riesgo de extinción",      r"\briesgos? de extinci[óo]n\b",        "Riesgo de extinción"),
    ("Rizoma",                   r"\brizomas?\b",                        "Rizoma"),
    ("Rostelo",                  r"\brostelos?\b",                       "Rostelo"),
    ("Rupícola",                 r"\brup[íi]colas?\b",                   "Rupícola"),
    # S
    ("Semilla",                  r"\bsemillas?\b",                       "Semilla"),
    ("Senescencia",              r"\bsenescencia\b",                     "Senescencia"),
    ("Sensibilidad",             r"\bsensibilidad\b",                    "Sensibilidad"),
    ("Sesgo",                    r"\bsesgos?\b",                         "Sesgo"),
    ("Simpodial",                r"\bsimpodial\b",                       "Simpodial (crecimiento)"),
    ("Simulación",               r"\bsimulaci(ó|o)n(es)?\b",             "Simulación"),
    ("Supervivencia",            r"\b(probabilidad|tasa) de supervivencia\b|\bsupervivencia perfecta\b", "Supervivencia"),
    # T
    ("Talud",                    r"\btallos?\b",                         "Tallo"),
    ("Tamaño poblacional",       r"\btama[ñn]o poblacional\b",           "Tamaño poblacional (N)"),
    ("Tamaño de muestra",        r"\btama[ñn]o de muestra\b",            "Tamaño de muestra"),
    ("Tasa finita de crecimiento",r"\btasa finita de crecimiento\b",     "Tasa finita de crecimiento (λ)"),
    ("Tasa intrínseca",          r"\btasa intr[íi]nseca\b",              "Tasa intrínseca de crecimiento"),
    ("Tasa vital",               r"\btasas? vitales?\b",                 "Tasa vital"),
    ("Terrestre (orquídea)",     r"\borqu[íi]deas? terrestres?\b",       "Terrestre, orquídea"),
    ("tidyverse",                r"\btidyverse\b",                       "tidyverse (paquete R)"),
    ("Tiempo generacional",      r"\btiempo generacional\b",             "Tiempo generacional"),
    ("Translocación",            r"\btranslocaci[óo]n\b",                "Translocación"),
    ("Transición",               r"\btransici(ó|o)n(es)? demogr[áa]fica\b", "Transición demográfica"),
    ("Tubérculo",                r"\btub[ée]rculos?\b",                  "Tubérculo"),
    # U
    ("Umbral",                   r"\bumbrales?\b",                       "Umbral"),
    # V
    ("Valor reproductivo",       r"\bvalor reproductivo\b",              "Valor reproductivo (v)"),
    ("Variación espacial",       r"\bvariaci[óo]n espacial\b",           "Variación espacial"),
    ("Variación temporal",       r"\bvariaci[óo]n temporal\b",           "Variación temporal"),
    ("Verosimilitud",            r"\bverosimilitud\b",                   "Verosimilitud"),
    ("Viabilidad de semillas",   r"\bviabilidad de (las )?semillas?\b",  "Viabilidad de semillas"),
    ("Viabilidad poblacional",   r"\b(viabilidad poblacional|PVA)\b",    "Viabilidad poblacional (PVA)"),
    # W
    ("w (estructura estable)",   r"\bw[- ]?max\b|\bvector w\b",          "w (estructura estable)"),
]

HEADING_PATTERN = re.compile(r'^(#{1,4})\s+(.+?)\s*(?:\{[^}]*\})?\s*$')


def parse_chapter_sections(qmd_path: Path):
    """
    Devuelve una lista de (línea, nivel, título, anchor_id) para cada
    encabezado en el .qmd. Los encabezados también se etiquetan con un
    id auto-generado para usar en links.
    """
    if not qmd_path.exists():
        return []
    sections = []
    lines = qmd_path.read_text(encoding='utf-8').splitlines()
    in_chunk = False
    for i, line in enumerate(lines, 1):
        s = line.strip()
        if s.startswith('```'):
            in_chunk = not in_chunk
            continue
        if in_chunk:
            continue
        m = HEADING_PATTERN.match(line)
        if m:
            level = len(m.group(1))
            title = m.group(2).strip()
            # Detectar anchor explícito {#anchor}
            anchor_match = re.search(r'\{#([^}\s]+)', line)
            anchor = anchor_match.group(1) if anchor_match else None
            sections.append((i, level, title, anchor))
    return sections


def section_for_line(line_no: int, sections: list) -> tuple[str, str | None] | tuple[None, None]:
    """
    Devuelve (título, anchor) de la sección ## (nivel 2) más cercana
    arriba de line_no. Ignora niveles ###, #### (demasiado granulares
    para un índice analítico).
    """
    title = None
    anchor = None
    for ln, level, t, a in sections:
        if ln < line_no:
            # Sólo consideramos secciones de nivel 2 (la columna principal
            # de la jerarquía del capítulo). El nivel 1 es el título del
            # capítulo, lo descartamos.
            if level == 2:
                title = t
                anchor = a
        else:
            break
    return title, anchor


def find_term_occurrences(term_regex: str, qmd_path: Path):
    """
    Devuelve la lista de números de línea donde aparece el regex en
    el .qmd (fuera de chunks de código).
    """
    if not qmd_path.exists():
        return []
    pattern = re.compile(term_regex, re.IGNORECASE)
    lines = qmd_path.read_text(encoding='utf-8').splitlines()
    in_chunk = False
    matches = []
    for i, line in enumerate(lines, 1):
        s = line.strip()
        if s.startswith('```'):
            in_chunk = not in_chunk
            continue
        if in_chunk:
            continue
        if pattern.search(line):
            matches.append(i)
    return matches


def main():
    # Para cada capítulo, parsear secciones una vez
    chapter_sections = {}
    for qmd_file, label in CHAPTERS:
        chapter_sections[qmd_file] = parse_chapter_sections(ROOT / qmd_file)

    # Por cada término, encontrar (capítulo, sección) donde aparece
    # Mapear: key → lista de (chapter_label, qmd_html, section_title, anchor)
    index_entries = []
    for term_key, term_regex, term_label in TERMS:
        appearances = defaultdict(list)  # (chapter_label, qmd_html) → set of (section_title, anchor)
        for qmd_file, chapter_label in CHAPTERS:
            occurrences = find_term_occurrences(term_regex, ROOT / qmd_file)
            if not occurrences:
                continue
            sections = chapter_sections[qmd_file]
            unique_sections = set()
            for line_no in occurrences:
                sec_title, sec_anchor = section_for_line(line_no, sections)
                if sec_title:
                    unique_sections.add((sec_title, sec_anchor))
            if unique_sections:
                qmd_html = qmd_file.replace('.qmd', '.html')
                appearances[(chapter_label, qmd_html)] = sorted(unique_sections)
        if appearances:
            index_entries.append((term_key, term_label, appearances))

    # Construir el .qmd de salida agrupado por letra inicial
    by_letter = defaultdict(list)
    for term_key, term_label, appearances in index_entries:
        first = term_key[0].upper()
        if not first.isalpha():
            first = "#"
        by_letter[first].append((term_label, appearances))

    out = []
    desc = 'Índice analítico de temas del libro con enlaces a los capítulos y secciones donde se desarrolla cada concepto. 174 términos indexados.'
    out.append('---\n')
    out.append(f'description: "{desc}"\n')
    out.append('image: "images/Lepanthes_eltoroensis_Tremblay.jpeg"\n')
    out.append('open-graph:\n')
    out.append(f'  description: "{desc}"\n')
    out.append('twitter-card:\n')
    out.append(f'  description: "{desc}"\n')
    out.append('---\n\n')
    out.append("# Índice de temas {#IndiceTemas .unnumbered}\n\n")
    out.append("Índice analítico del libro. Cada término aparece con los "
               "capítulos y secciones donde se desarrolla — no con números "
               "de página, porque éste es un libro digital cuya paginación "
               "depende del dispositivo de lectura.\n\n")
    out.append(f"**Total:** {len(index_entries)} términos indexados.\n\n")
    out.append("Las entradas se generan automáticamente desde el "
               "[glosario](Apendice_Glosario.qmd) y se buscan en cada "
               "capítulo. Si echa de menos un término, puede sugerirlo "
               "abriendo un *issue* en el repositorio del libro.\n\n")
    out.append("------------------------------------------------------------------------\n\n")

    # Umbral: si un término aparece en muchos capítulos, listar sólo los
    # capítulos (sin sub-secciones) para no inflar el índice con entradas
    # extensas que son ruido en lugar de utilidad.
    AGGREGATE_THRESHOLD = 7

    def chapter_number(chapter_label: str) -> str:
        """Extrae '1' de '1. Introducción', 'A' de 'A. Apéndice', etc."""
        return chapter_label.split('.', 1)[0].strip()

    for letter in sorted(by_letter.keys()):
        out.append(f"## {letter}\n\n")
        for term_label, appearances in sorted(by_letter[letter], key=lambda x: x[0].lower()):
            out.append(f"**{term_label}**\n\n")
            # Si el término aparece en >= AGGREGATE_THRESHOLD capítulos,
            # formato compacto: una sola línea con los capítulos enlazados
            # separados por coma (sin listar sub-secciones).
            if len(appearances) >= AGGREGATE_THRESHOLD:
                chapter_links = ", ".join(
                    f"[{chapter_label}]({qmd_html})"
                    for (chapter_label, qmd_html) in sorted(appearances.keys())
                )
                out.append(f": *Concepto recurrente; ver* {chapter_links}.\n")
            else:
                # Aplanar: una línea por sección, con la sección como link
                # principal y el capítulo como contexto entre paréntesis.
                entries = []
                for (chapter_label, qmd_html), sections in appearances.items():
                    # Deduplicar secciones con mismo título
                    seen_titles = set()
                    unique_sections = []
                    for sec_title, sec_anchor in sections:
                        if sec_title not in seen_titles:
                            seen_titles.add(sec_title)
                            unique_sections.append(sec_title)
                    cnum = chapter_number(chapter_label)
                    for sec_title in unique_sections:
                        entries.append((sec_title, qmd_html, cnum, chapter_label))
                # Ordenar por título de sección (alfabético) para facilitar lectura
                for sec_title, qmd_html, cnum, chapter_label in sorted(entries, key=lambda x: x[0].lower()):
                    out.append(f": [{sec_title}]({qmd_html}) — Cap. {cnum}\n")
            out.append("\n")
        out.append("\n")

    OUT.write_text(''.join(out), encoding='utf-8')
    print(f"✓ Índice generado: {OUT.relative_to(ROOT)}")
    print(f"  Términos indexados: {len(index_entries)} de {len(TERMS)} en el vocabulario")
    print(f"  Términos sin apariciones (no entran al índice): "
          f"{len(TERMS) - len(index_entries)}")


if __name__ == '__main__':
    main()
