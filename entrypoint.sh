#!/usr/bin/env bash

set -e

printf "Found files in workspace:\n"
ls

printf "Looking for which report to be done...\n"

if ${{inputs.check_type == 'spelling'}} ;then
  error_name='Spelling errors'
  report_path='resources/spell_check_results.tsv'
  chk_results="Rscript scripts/spell-check.R"
elif ${{inputs.check_type == 'urls'}} ;then
  error_name='Broken URLs'
  report_path='resources/url_checks.tsv'
  chk_results="Rscript scripts/url-check.R"
elif ${{inputs.check_type ==  'quiz_format'}} ;then
  error_name='Quiz format errors'
  report_path='question_error_report.tsv'
  chk_results="Rscript -e 'ottrpal::check_quizzes(quiz_dir = 'quizzes', write_report = TRUE, verbose = TRUE)'"
fi

printf $error_name
printf $report_path
${chk_results}

chk_results="$((chk_results-1))"
echo $chk_results
