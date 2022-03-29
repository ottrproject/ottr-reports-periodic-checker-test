#!/usr/bin/env Rscript
# Written by Candace Savonen March 2022

check_type <- readLines('check_type.txt')

print(paste("Check type specified:", check_type))

if (check_type == "spelling") source("ottr_report_scripts/spell-check.R")
if (check_type == "urls") source("ottr_report_scripts/url-check.R")
if (check_type == "quiz_format") source("ottr_report_scripts/quiz-check.R")
