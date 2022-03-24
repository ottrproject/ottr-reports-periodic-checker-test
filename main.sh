#!/bin/sh

set -e
set -o pipefail

cd $GITHUB_WORKSPACE

# This script should always run as if it were being called from
# the directory it lives in.
script_directory="$(perl -e 'use File::Basename;
  use Cwd "abs_path";
  print dirname(abs_path(@ARGV[0]));' -- "$0")"

echo $script_directory
echo $INPUT_CHECK_TYPE >> check_type.txt

if [ "${INPUT_CHECK_TYPE}" == "spelling" ];then
  error_name='Spelling errors'
  report_path='resources/spell_check_results.tsv'
elif [ "${INPUT_CHECK_TYPE}" == "urls" ];then
  error_name='Broken URLs'
  report_path='resources/url_checks.tsv'
elif [ "${INPUT_CHECK_TYPE}" == "quiz_format" ];then
  error_name='Quiz format errors'
  report_path='question_error_report.tsv'
fi

# Run the check
chk_results=$(Rscript $script_directory/scripts/check_type.R)

# Print out the output
printf $error_name
printf $report_path
printf $chk_results

# Save output
echo "::set-output name=error_name::$error_name"
echo "::set-output name=report_path::$report_path"
echo "::set-output chk_results=$chk_results"
