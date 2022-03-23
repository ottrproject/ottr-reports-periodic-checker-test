#!/usr/bin/env Rscript
# Written by Candace Savonen March 2022

if (!("optparse" %in% installed.packages())){
  install.packages("optparse")
}

library(optparse)

option_list <- list(
  optparse::make_option(
    c("--check_type"),
    type = "character",
    default = NULL,
    help = "Which check type to run?",
  )
)

# Read the arguments passed
opt_parser <- optparse::OptionParser(option_list = option_list)
opt <- optparse::parse_args(opt_parser)

if (opt$check_type == "spelling") source("scripts/spell-check.R")
if (opt$check_type == "urls") source("scripts/url-check.R")
if (opt$check_type == "quiz_format") source("scripts/quiz-check.R")
