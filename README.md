# OTTR Reports

This action runs either spelling, url, or quiz format checks in an [OTTR course](https://github.com/jhudsl/OTTR_Template).

## Inputs

## `check_type`

**Required** the type of check to be done. Either `spelling`, `urls`, or `quiz_format`.

## `error_min`

What number of errors should make this check fail? Default is `0`.

## Outputs

A report called one of the following:
'resources/spell_check_results.tsv', 'resources/url_checks.csv', or 'resources/question_error_report.tsv',

## Example usage

For spelling checks:
```
uses: jhudsl/ottr-reports@main
with:
  check_type: "spelling"
  error_min: 3
```

For broken url checks:
```
uses: jhudsl/ottr-reports@main
with:
  check_type: "urls"
  error_min: 0
```

For quiz_format checks:
```
uses: jhudsl/ottr-reports@main
with:
  check_type: "quiz_format"
  error_min: 0
```
