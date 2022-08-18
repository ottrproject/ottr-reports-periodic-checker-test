#!/bin/sh

set -e
set -o pipefail

echo $INPUT_CHECK_TYPE >> check_type.txt

if [ "${INPUT_CHECK_TYPE}" == "spelling" ];then
  curl -o $script_directory/spell-check.R https://raw.githubusercontent.com/jhudsl/ottr-reports/main/scripts/spell-check.R
  error_name=$(echo Spelling errors)
  report_path=check_reports/spell_check_results.tsv
  chk_results=$(Rscript $script_directory/spell-check.R)
  rm $script_directory/spell-check.R
elif [ "${INPUT_CHECK_TYPE}" == "urls" ];then
  curl -o $script_directory/url-check.R https://raw.githubusercontent.com/jhudsl/ottr-reports/main/scripts/url-check.R
  error_name=$(echo Broken URLs)
  report_path=check_reports/url_checks.tsv
  chk_results=$(Rscript $script_directory/url-check.R)
  rm $script_directory/url-check.R
elif [ "${INPUT_CHECK_TYPE}" == "quiz_format" ];then
  curl -o $script_directory/quiz-check.R https://raw.githubusercontent.com/jhudsl/ottr-reports/main/scripts/quiz-check.R
  error_name=$(echo Quiz format errors)
  report_path=check_reports/question_error_report.tsv
  chk_results=$(Rscript $script_directory/quiz-check.R)
  rm $script_directory/quiz-check.R
fi

# Print out the output
printf $error_name \n
printf $report_path \n
printf $chk_results \n

# Save output
echo ::set-output name=error_name::$error_name
echo ::set-output name=report_path::$report_path
echo ::set-output name=chk_results=$chk_results
