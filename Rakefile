$LOAD_PATH.push(File.expand_path('../lib', __FILE__))
require 'puppet-lint-unquoted-string-check/version'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

begin
  require 'github_changelog_generator/task'
  GitHubChangelogGenerator::RakeTask.new :changelog do |config|
    config.future_release = PuppetLintUnquotedStringCheck::VERSION.dup
    config.header = "# Changelog\n\nAll notable changes to this project will be documented in this file."
    config.exclude_labels = %w{duplicate question invalid wontfix wont-fix skip-changelog}
    config.user = 'voxpupuli'
    config.project = 'puppet-lint-unquoted_string-check'
  end
rescue LoadError
end
