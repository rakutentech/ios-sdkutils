# Warn when there is a big PR
warn("Big PR") if git.lines_of_code > 500

xcov.report(
  workspace: 'RSDKUtils.xcworkspace',
  scheme: 'Tests',
  output_directory: 'artifacts/unit-tests/coverage',
  source_directory: 'Sources',
  json_report: true,
  include_targets: 'RSDKUtils.framework',
  include_test_targets: false,

# Disabled until next unit tests PR
# minimum_coverage_percentage: 70.0, 

  skip_slack: true
)
