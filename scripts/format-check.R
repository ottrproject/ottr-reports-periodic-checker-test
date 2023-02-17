#!/usr/bin/env Rscript

# Adapted for this jhudsl repository by Candace Savonen Feb 2023

# Check for common Markdown formatting mistakes

library(magrittr)

# Find .git root directory
root_dir <- rprojroot::find_root(rprojroot::has_dir(".git"))

output_file <- file.path(root_dir, 'check_reports', 'markdown_checks.tsv')

if (!dir.exists('check_reports')) {
  dir.create('check_reports')
}

# Declare ignore_urls file
ignore_markdown_file <- file.path(root_dir, 'resources', 'markdown_ignore.txt')

# Read in ignore markdown file if it exists
if (file.exists(ignore_markdown_file)) {
  ignore_markdown <- readLines(ignore_markdown_file)
  } else {
  ignore_markdown <- ""
}

# Only declare `.Rmd` files but not the ones in the style-sets directory
files <- list.files(path = root_dir, pattern = 'md$', full.names = TRUE)

test_markdown <- function(file) {

  message(paste("##### Testing Markdown format from file:", file))

  ##### Read in a Markdown file
  content <- readLines(file, encoding = "UTF-8")

  ######## Check header formatting
  # Grab all potential headers 
  header_indices <- grep("\\#{1,6}", content)
  
  header_indices <- setdiff(header_indices, grep("http", content))
  
  # Check that there's an empty line before and after 
  before_header <- ifelse(content[header_indices - 1] == "", TRUE, FALSE)
  after_header <- ifelse(content[header_indices + 1] == "", TRUE, FALSE)

  # Check that the header starts the line and has a whitespace after it
  correct_header <- grepl("^\\#\\s.*", content[header_indices])
  
  header_tests_df <- data.frame(empty_line_before = before_header, 
                                empty_line_after = after_header,
                                correct_whitespace = correct_header) %>% 
    dplyr::mutate(tests_passed = apply(., 1, all), 
                  line_number = header_indices, 
                  text = content[header_indices]) %>% 
    dplyr::transmute(line_number, 
                     text, 
                     error = dplyr::case_when(
                       !empty_line_before ~ "Need empty line before header line", 
                       !empty_line_after ~ "Need empty line after header line", 
                       !correct_whitespace ~ "Need whitespace after # and needs to start on a new line", 
                       TRUE ~ "Passed"))
    
  
  ### Check bullet point formatting
  bullet_point_1 <- "^\\-"
  bullet_point_2 <- "^\\+"
  bullet_point_3 <- "^\\*"

  bullet_point_indices <- sort(c(grep(bullet_point_1, content), 
                            grep(bullet_point_2, content), 
                            grep(bullet_point_3, content)))
  
  bullet_point_indices <- setdiff(bullet_point_indices, grep("---", content))
  
  # This retrieves the line right before the list starts and ends
  list_start <- setdiff(bullet_point_indices - 1, bullet_point_indices) 
  list_end <- setdiff(bullet_point_indices + 1, bullet_point_indices)
  
  # Build a data frame
  bullet_point_df <- data.frame(
    line_number = bullet_point_indices,
    list_start = (bullet_point_indices %in% (list_start + 1)), 
    list_end = (bullet_point_indices %in% (list_end - 1)), 
    # Check that there is a space after the bullet
    correct_spacing = grepl("^\\s",
                             substr(content[bullet_point_indices], 
                                    2, 
                                    nchar(content[bullet_point_indices]))), 
    line_before = content[bullet_point_indices - 1], 
    line_after = content[bullet_point_indices + 1], 
    text = content[bullet_point_indices]) %>% 
    dplyr::mutate(error = dplyr::case_when(
      list_start & line_before == "" ~ "Passed", 
      list_start & line_before != "" ~ "Need empty line before bullet point list", 
      list_end & line_after == "" ~ "Passed", 
      list_end & line_after != "" ~ "Need empty line after bullet point list",
      !correct_spacing ~ "Need whitespace after bullet point and it needs to start on a new line",
      TRUE ~ "Passed"
    )) %>% 
    dplyr::select(line_number, text, error)
  
  
  #### Create full error df 
  error_df <- dplyr::bind_rows(bullet_point_df, header_tests_df) %>% 
    dplyr::mutate(file = file)
  
  return(error_df)
}

# Run this for all Rmds
all_markdown_tests <- lapply(files, test_markdown)
  
# Bind all dataframes together
all_markdown_tests_df <- dplyr::bind_rows(all_markdown_tests)
  
# If there are any errors
if (nrow(all_markdown_tests_df) > 0) {
  all_markdown_tests_df <- all_markdown_tests_df %>%
    dplyr::filter(error != "Passed") %>%
    readr::write_tsv(output_file)
} else {
  all_markdown_tests_df <- data.frame(errors = NA)
}
  
# Print out how many spell check errors
write(nrow(all_markdown_tests_df), stdout())

# Save spell errors to file temporarily
readr::write_tsv(all_markdown_tests_df, output_file)

message(paste0("Saved to: ", output_file))
