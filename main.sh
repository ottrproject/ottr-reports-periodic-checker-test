#!/bin/sh

set -e
set -o pipefail

cd $GITHUB_WORKSPACE

# This script should always run as if it were being called from
# the directory it lives in.
script_directory="$(perl -e 'use File::Basename;
  use Cwd "abs_path";
  print dirname(abs_path(@ARGV[0]));' -- "$0")"

printf "running from: $script_directory"
echo $INPUT_CHECK_TYPE >> check_type.txt

if [ "${INPUT_CHECK_TYPE}" == "spelling" ];then
  curl -o $script_directory/spell-check.R https://raw.githubusercontent.com/jhudsl/ottr-reports/main/scripts/spell-check.R
  error_name='Spelling errors'
  report_path='resources/spell_check_results.tsv'
  chk_results=$(Rscript $script_directory/spell-check.R)
  rm $script_directory/spell-check.R
elif [ "${INPUT_CHECK_TYPE}" == "urls" ];then
  curl -o $script_directory/url-check.R https://raw.githubusercontent.com/jhudsl/ottr-reports/main/scripts/url-check.R
  error_name='Broken URLs'
  report_path='resources/url_checks.tsv'
  chk_results=$(Rscript $script_directory/url-check.R)
  rm $script_directory/url-check.R
elif [ "${INPUT_CHECK_TYPE}" == "quiz_format" ];then
  curl -o $script_directory/quiz-check.R https://raw.githubusercontent.com/jhudsl/ottr-reports/main/scripts/quiz-check.R
  error_name='Quiz format errors'
  report_path='question_error_report.tsv'
  chk_results=$(Rscript $script_directory/quiz-check.R)
  rm $script_directory/quiz-check.R
fi

# Print out the output
printf $error_name
printf $report_path
printf $chk_results

# Save output
echo ::set-output name=error_name::$error_name
echo ::set-output name=report_path::$report_path
echo ::set-output chk_results=$chk_results
