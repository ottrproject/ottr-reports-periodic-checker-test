#!/usr/bin/env Rscript
# Written by Candace Savonen March 2022

library(optparse)

option_list <- list(
  make_option(
    c("--check_type"),
    type = "character",
    default = NULL,
    action = "store",
    help = "Which check type to run?",
  )
)

# Read the arguments passed
opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)

print(paste("Check type specified:", opt$check_type))

if (opt$check_type == "spelling") source("scripts/spell-check.R")
if (opt$check_type == "urls") source("scripts/url-check.R")
if (opt$check_type == "quiz_format") source("scripts/quiz-check.R")
