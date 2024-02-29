#!/usr/bin/env Rscript

# This code was originally written by Josh Shapiro and Candace Savonen
# for the Childhood Cancer Data Lab an initiative of Alexs Lemonade Stand Foundation.
# https://github.com/AlexsLemonade/refinebio-examples/blob/33cdeff66d57f9fe8ee4fcb5156aea4ac2dce07f/.github/workflows/style-and-sp-check.yml#L1

# Adapted for this jhudsl repository by Candace Savonen Apr 2021

# Run spell check and save results

library(magrittr)

if (!("spelling" %in% installed.packages())){
  install.packages("spelling")
}
# Find .git root directory
root_dir <- rprojroot::find_root(rprojroot::has_dir(".git"))

# Set up output file directory
output_file <- file.path(root_dir, 'check_reports', 'spell_check_results.tsv')

if (!dir.exists('check_reports')) {
  dir.create('check_reports')
}

# Read in dictionary
dict_file <- file.path(root_dir, 'resources', 'dictionary.txt')
dictionary <- readLines(dict_file)

# Declare exclude_files.txt
exclude_file <- file.path(root_dir, 'resources', 'exclude_files.txt')

# Read in exclude_files.txt if it exists
if (file.exists(exclude_file)) {
  exclude_file <- readLines(exclude_file)
} else {
  exclude_file <- ""
}

# Make it alphabetical and only unique entries
writeLines(unique(sort(dictionary)), dict_file)

# Only declare `.Rmd` files but not the ones in the style-sets directory
files <- list.files(pattern = 'md$', recursive = TRUE, full.names = TRUE)

# Exclude files lists in the exclude_file
files <- setdiff(files, file.path(root_dir, exclude_file))

# Get quiz file names
quiz_files <- list.files(file.path(root_dir, "quizzes"), pattern = '\\.md$', full.names = TRUE)

# Put into one list
files <- c(files, quiz_files)

files <- grep("About.Rmd", files, ignore.case = TRUE, invert = TRUE, value = TRUE)
files <- grep("style-sets", files, ignore.case = TRUE, invert = TRUE, value = TRUE)

tryCatch( 
  expr = {
    # Run spell check
    sp_errors <- spelling::spell_check_files(files, ignore = dictionary)
    
    if (nrow(sp_errors) > 0) {
      sp_errors <- sp_errors %>%
        data.frame() %>%
        tidyr::unnest(cols = found) %>%
        tidyr::separate(found, into = c("file", "lines"), sep = ":")
    } else {
      sp_errors <- data.frame(errors = NA)
    }
  },
  error = function(e){
    message("Spell check did not work. Check that your dictionary is formatted correctly. You cannot have special characters (e.g., Diné) in the dictionary.txt file. You need to use HTML formatting (e.g., Din&eacute;) for these.")
  }
)

# Print out how many spell check errors
write(nrow(sp_errors), stdout())

# Save spell errors to file temporarily
readr::write_tsv(sp_errors, output_file)

message(paste0("Saved to: ", output_file))
