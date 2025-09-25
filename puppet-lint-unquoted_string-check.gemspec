Gem::Specification.new do |spec|
  spec.name        = 'puppet-lint-unquoted_string-check'
  spec.version     = '4.0.0'
  spec.homepage    = 'https://github.com/puppet-community/puppet-lint-unquoted_string-check'
  spec.license     = 'Apache-2.0'
  spec.author      = 'Vox Pupuli'
  spec.email       = 'voxpupuli@groups.io'
  spec.files       = Dir[
    'README.md',
    'LICENSE',
    'lib/**/*',
    'spec/**/*',
    'CHANGELOG.md',
  ]
  spec.summary     = 'A puppet-lint plugin to check that selectors and case statements cases are quoted.'
  spec.description = <<-EOF
    A puppet-lint plugin to check that selectors and case statements cases are quoted.
  EOF

  spec.required_ruby_version = '>= 3.2'

  spec.add_dependency 'puppet-lint', '~> 5.1'
end
