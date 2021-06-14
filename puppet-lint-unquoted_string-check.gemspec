$LOAD_PATH.push(File.expand_path('../lib', __FILE__))
require 'puppet-lint-unquoted-string-check/version'

Gem::Specification.new do |spec|
  spec.name        = 'puppet-lint-unquoted_string-check'
  spec.version     = PuppetLintUnquotedStringCheck::VERSION.dup
  spec.homepage    = 'https://github.com/puppet-community/puppet-lint-unquoted_string-check'
  spec.license     = 'Apache-2.0'
  spec.author      = 'Vox Pupuli'
  spec.email       = 'voxpupuli@groups.io'
  spec.files       = Dir[
    'README.md',
    'LICENSE',
    'lib/**/*',
    'spec/**/*',
  ]
  spec.test_files  = Dir['spec/**/*']
  spec.summary     = 'A puppet-lint plugin to check that selectors and case statements cases are quoted.'
  spec.description = <<-EOF
    A puppet-lint plugin to check that selectors and case statements cases are quoted.
  EOF

  spec.required_ruby_version = '>= 2.4'

  spec.add_dependency             'puppet-lint', '>= 2.1', '< 3.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-its', '~> 1.0'
  spec.add_development_dependency 'rspec-collection_matchers', '~> 1.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'rake'
end
