#!/usr/bin/env Rscript

# Adapted for this jhudsl repository by Candace Savonen Mar 2022

# Summarize url checks

library(magrittr)

# Find .git root directory
root_dir <- rprojroot::find_root(rprojroot::has_dir(".git"))

output_file <- file.path(root_dir, 'check_reports', 'url_checks.tsv')

if (!dir.exists('check_reports')) {
  dir.create('check_reports')
}

# Declare ignore_urls file
ignore_urls_file <- file.path(root_dir, 'resources', 'ignore-urls.txt')

# Read in ignore urls file if it exists
if (file.exists(ignore_urls_file)) {
  ignore_urls <- readLines(ignore_urls_file)
  } else {
  ignore_urls <- ""
}

# Only declare `.Rmd` files but not the ones in the style-sets directory
files <- list.files(path = root_dir, pattern = 'md$', full.names = TRUE)

test_url <- function(url) {
   message(paste0("Testing: ", url))

   url_status <- try(httr::GET(url), silent = TRUE)

   # Fails if host can't be resolved
   status <- ifelse(suppressMessages(grepl("Could not resolve host", url_status)), "failed", "success")

   if (status == "success") {
     # Fails if 404'ed
     status <- ifelse(try(httr::GET(url)$status_code, silent = TRUE) == 404, "failed", "success")
   }

   return(status)
 }

get_urls <- function(file) {

  message(paste("##### Testing URLs from file:", file))

  # Read in a file and return the urls from it
  content <- readLines(file)

  # Set up the possible tags
  html_tag <- "<a href="
  include_url_tag <- "include_url\\("
  include_slide_tag <- "include_slide\\("
  markdown_tag <- "\\[.*\\]\\(http[s]?.*\\)"
  markdown_tag_bracket <- "\\[.*\\]: http[s]?"
  http_gen <- "http[s]?"
  url_pattern <- "http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+"

  # Collect the different kinds of tags in a named vector
  all_tags <- c(html = html_tag,
                knitr = include_url_tag,
                ottrpal = include_slide_tag,
                markdown = markdown_tag,
                markdown_bracket = markdown_tag_bracket,
                other_http = http_gen)

  url_list <- sapply(all_tags, grep, content, value = TRUE)
  url_list$other_http <- setdiff(url_list$other_http, unlist(url_list[-6]))

  # Extract the urls only of each type
  if (length(url_list$html) > 0 ){
    url_list$html <- sapply(url_list$html, function(html_line) {
                            head(rvest::html_attr(rvest::html_nodes(rvest::read_html(html_line), "a"), "href"))
    })
    url_list$html <- unlist(url_list$html)
  }
  url_list$knitr <- stringr::word(url_list$knitr, sep = "include_url\\(\"|\"\\)", 2)
  url_list$ottrpal <- stringr::word(url_list$ottrpal, sep = "include_slide\\(\"|\"\\)", 2)
  url_list$markdown <- stringr::word(url_list$markdown, sep = "\\]\\(|\\)", 2)
  url_list$markdown <- grep("http", url_list$markdown, value = TRUE)

  if (length(url_list$markdown_bracket) > 0 ){
    url_list$markdown_bracket <- paste0("http", stringr::word(url_list$markdown_bracket, sep = "\\]: http", 2))
  }
  url_list$other_http <- stringr::word(stringr::str_extract(url_list$other_http, url_pattern), sep = "\\]", 1)

  # If after the manipulations there's not actually a URL, remove it.
  url_list <- lapply(url_list, na.omit)

  # collapse list
  urls <- unlist(url_list)

  # Remove trailing characters 
  urls <- gsub("\\'\\:$|\\'|\\:$|\\.$", "", urls)

  if (length(urls) > 0 ){
    # Remove trailing characters
    urls_status <- sapply(urls, test_url)
    url_df <- data.frame(urls, urls_status, file)
    return(url_df)
  } else {
    message("No URLs found")
  }
}

# Run this for all Rmds
all_urls <- lapply(files, get_urls)

# Write the file
all_urls_df <- dplyr::bind_rows(all_urls) %>%
  dplyr::filter(!(urls %in% ignore_urls))

if (nrow(all_urls_df) > 0) {
  all_urls_df <- all_urls_df %>%
    dplyr::filter(urls_status == "failed") %>%
    readr::write_tsv(output_file)
} else {
  all_urls_df <- data.frame(errors = NA)
}

# Print out how many spell check errors
write(nrow(all_urls_df), stdout())

# Save spell errors to file temporarily
readr::write_tsv(all_urls_df, output_file)

message(paste0("Saved to: ", output_file))
