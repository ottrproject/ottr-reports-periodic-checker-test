#!/usr/bin/env Rscript
# Written by Candace Savonen March 2022

check_type <- readLines('check_type.txt')

print(paste("Check type specified:", check_type))

if (check_type == "spelling") {
  system("curl https://raw.githubusercontent.com/jhudsl/ottr-reports/v0.5/scripts/spell-check.R spell-check.R")
  source("spell-check.R")
}
if (check_type == "urls") {
  system("curl https://raw.githubusercontent.com/jhudsl/ottr-reports/v0.5/scripts/url-check.R url-check.R")
  source("url-check.R")
}
if (check_type == "quiz_format") {
  system("curl https://raw.githubusercontent.com/jhudsl/ottr-reports/v0.5/scripts/quiz-check.R quiz-check.R")
  source("quiz-check.R")
}
