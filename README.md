# OTTR Reports

This action runs either spelling, url, or quiz format checks for markdown, R markdown, and Quarto courses and websites and returns reports about the errors it finds on your pull request.

## Example usage


```
runs-on: ubuntu-latest
permissions:
  pull-requests: write


steps:
- name: Checkout Actions Repository
  uses: actions/checkout@v4
  with:
    fetch-depth: 0

- name: Run Reports
  id: run-reports
  uses: ottrproject/ottr-reports@main
  with:
    check_spelling: TRUE
    spelling_error_min: 1
    check_urls: TRUE
    url_error_min: 1
    check_quiz_form: TRUE
    quiz_error_min: 1
    sort_dictionary: TRUE
```


## Inputs

## `check_spelling`, `check_urls`, and `check_quiz_form`

Are TRUE/FALSE variables would you like these checks to be run

## `spelling_error_min`, `url_error_min`, and `quiz_error_min`

For each test respectively how many minimum errors would you like to tolerate?
In other words, what number of errors should make this check fail? Default is `0`.

## Outputs

A comment on your pull request with a summary of your checsk and a zip file with the respective reports :
'spell_check_results.tsv', 'url_checks.csv', or question_error_report.tsv',


## How does it work?

All checks are run by the `jhudsl/ottrpal` docker image which contains the `ottrpal` R package.

You can use the [ottrpal R package](https://github.com/ottrproject/ottrpal) yourself for other uses.
