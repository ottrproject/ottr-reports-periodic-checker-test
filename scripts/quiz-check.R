#!/usr/bin/env Rscript

# This code was originally written by Josh Shapiro and Candace Savonen
# for the Childhood Cancer Data Lab an initiative of Alexs Lemonade Stand Foundation.
# https://github.com/AlexsLemonade/refinebio-examples/blob/33cdeff66d57f9fe8ee4fcb5156aea4ac2dce07f/.github/workflows/style-and-sp-check.yml#L1

# Adapted for this jhudsl repository by Candace Savonen Apr 2021

# Run spell check and save results

library(magrittr)

# Find .git root directory
root_dir <- rprojroot::find_root(rprojroot::has_dir(".git"))

ottrpal::check_quizzes(quiz_dir = 'quizzes', write_report = TRUE, verbose = TRUE)"

if (nrow(sp_errors) > 0) {
  sp_errors <- sp_errors %>%
    data.frame() %>%
    tidyr::unnest(cols = found) %>%
    tidyr::separate(found, into = c("file", "lines"), sep = ":")
}

# Print out how many spell check errors
write(nrow(sp_errors), stdout())

if (!dir.exists("resources")) {
  dir.create("resources")
}

if (nrow(sp_errors) > 0) {
# Save spell errors to file temporarily
readr::write_tsv(sp_errors, file.path('resources', 'spell_check_results.tsv'))
}
