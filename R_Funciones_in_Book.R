# ============================================================
# Scan all .qmd files in a project and build a function appendix
# ============================================================

# ---- Load required packages ----
suppressPackageStartupMessages({
  library(knitr)
  library(codetools)
  library(dplyr)
  library(tibble)
})

# ---- 1. Find all .qmd files ----
qmd_files <- list.files(
  path = ".",
  pattern = "\\.qmd$",
  recursive = TRUE,
  full.names = TRUE
)

if (length(qmd_files) == 0) {
  stop("No .qmd files found in this directory tree.")
}

# ---- 2. Extract R code blocks from each .qmd ----
extract_r_code <- function(file) {

  lines <- readLines(file, warn = FALSE)

  in_chunk <- FALSE
  chunk <- character()
  chunks <- list()

  for (ln in lines) {

    # Start of an R chunk (```{r ...})
    if (grepl("^```\\{r", ln)) {
      in_chunk <- TRUE
      next
    }

    # End of a chunk (```)
    if (in_chunk && grepl("^```\\s*$", ln)) {
      in_chunk <- FALSE
      chunks[[length(chunks) + 1]] <- paste(chunk, collapse = "\n")
      chunk <- character()
      next
    }

    # Inside chunk
    if (in_chunk) {
      chunk <- c(chunk, ln)
    }
  }

  unlist(chunks, use.names = FALSE)
}

all_code <- unlist(lapply(qmd_files, extract_r_code))

# ---- 3. Extract function calls via static analysis ----
get_fun_info <- function(fun) {

  h <- help(fun, try.all.packages = TRUE)

  if (length(h) == 0) {
    return(data.frame(
      function = fun,
      package = NA_character_,
      description = NA_character_,
      stringsAsFactors = FALSE
    ))
  }

  topic <- h[[1]]

  data.frame(
    function = fun,
    package = topic$pkgname,
    description = topic$title,
    stringsAsFactors = FALSE
  )
}


functions_used <- sort(unique(unlist(lapply(all_code, extract_functions))))

# ---- 4. Drop infrastructure / control-flow functions ----
exclude_functions <- c(
  "library", "require", "setwd", "options", "getOption",
  "print", "message", "cat",
  "if", "for", "while", "return", "break", "next",
  "{", "(", "[", "[["
)

functions_used <- setdiff(functions_used, exclude_functions)

# ---- 5. Retrieve package and documentation title ----
get_fun_info <- function(fun) {
  get_fun_info <- function(fun) {

    h <- help(fun, try.all.packages = TRUE)

    if (length(h) == 0) {
      return(data.frame(
        function = fun,
        package = NA_character_,
        description = NA_character_,
        stringsAsFactors = FALSE
      ))
    }

    topic <- h[[1]]

    data.frame(
      function = fun,
      package = topic$pkgname,
      description = topic$title,
      stringsAsFactors = FALSE
    )
  }


functions_df <- bind_rows(lapply(functions_used, get_fun_info))

# ---- 6. Categorize functions (edit rules if desired) ----
functions_df <- functions_df %>%
  mutate(
    category = case_when(
      grepl("NeStage", package, ignore.case = TRUE) ~ "NeStage",
      package %in% c("base", "stats", "utils", "graphics", "methods") ~ "Base R",
      is.na(package) ~ "User-defined or internal",
      TRUE ~ "Contributed packages"
    )
  ) %>%
  arrange(category, function)



# ---- 7. Save outputs for reuse in the book ----

# CSV for manual annotation if desired
write.csv(
  functions_df,
  file = "function_appendix.csv",
  row.names = FALSE
)

# RDS for programmatic use
saveRDS(
  functions_df,
  file = "function_appendix.rds"
)

# ---- 8. Display summary in console ----
cat("\nFunction scan complete:\n")
print(table(functions_df$category))
cat("\nTotal functions identified:", nrow(functions_df), "\n")
