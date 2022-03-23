#!/usr/bin/env Rscript
# Written by Candace Savonen March 2022

library(optparse)

check_type <- readLines('check_type.txt')

print(paste("Check type specified:", check_type))

if (check_type == "spelling") source("scripts/spell-check.R")
if (check_type == "urls") source("scripts/url-check.R")
if (check_type == "quiz_format") source("scripts/quiz-check.R")
