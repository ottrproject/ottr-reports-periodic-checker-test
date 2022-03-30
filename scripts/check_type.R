#!/usr/bin/env Rscript
# Written by Candace Savonen March 2022



check_type <- readLines('check_type.txt')

print(paste("Check type specified:", check_type))

if (check_type == "spelling") source("spell-check.R")
if (check_type == "urls") source("url-check.R")
if (check_type == "quiz_format") source("quiz-check.R")
