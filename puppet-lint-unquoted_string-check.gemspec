Gem::Specification.new do |spec|
  spec.name        = 'puppet-lint-unquoted_string-check'
  spec.version     = '0.2.1'
  spec.homepage    = 'https://github.com/mcanevet/puppet-lint-unquoted_string-check'
  spec.license     = 'Apache-2.0'
  spec.author      = 'Mickaël Canévet'
  spec.email       = 'mickael.canevet@gmail.com'
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

  spec.add_dependency             'puppet-lint', '~> 1.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-its', '~> 1.0'
  spec.add_development_dependency 'rspec-collection_matchers', '~> 1.0'
  spec.add_development_dependency 'rake'
end
