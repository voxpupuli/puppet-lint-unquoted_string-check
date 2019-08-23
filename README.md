puppet-lint-unquoted_string-check
=================================

[![Build Status](https://img.shields.io/travis/voxpupuli/puppet-lint-unquoted_string-check.svg)](https://travis-ci.org/voxpupuli/puppet-lint-unquoted_string-check)
[![Gem Version](https://img.shields.io/gem/v/puppet-lint-unquoted_string-check.svg)](https://rubygems.org/gems/puppet-lint-unquoted_string-check)
[![Gem Downloads](https://img.shields.io/gem/dt/puppet-lint-unquoted_string-check.svg)](https://rubygems.org/gems/puppet-lint-unquoted_string-check)
[![Coverage Status](https://img.shields.io/coveralls/voxpupuli/puppet-lint-unquoted_string-check.svg)](https://coveralls.io/r/voxpupuli/puppet-lint-unquoted_string-check?branch=master)
[![Donated by Camptocamp](https://img.shields.io/badge/donated%20by-camptocamp-fb7047.svg)](#transfer-notice)

A puppet-lint plugin to check that selectors and case statements cases are quoted.

## Installing

### From the command line

```shell
$ gem install puppet-lint-unquoted_string-check
```

### In a Gemfile

```ruby
gem 'puppet-lint-unquoted_string-check', :require => false
```

## Checks

### Unquoted string in case

Unquoted strings in case statements are not valid with the future parser.

#### What you have done

```puppet
case $::osfamily {
  Debian: { }
  RedHat: { }
  default: { }
}
```

#### What you should have done

```puppet
case $::osfamily {
  'Debian': { }
  'RedHat': { }
  default: { }
}
```

#### Disabling the check

To disable this check, you can add `--no-unquoted_string_in_case-check` to your puppet-lint command line.

```shell
$ puppet-lint --no-unquoted_string_in_case-check path/to/file.pp
```

Alternatively, if you’re calling puppet-lint via the Rake task, you should insert the following line to your `Rakefile`.

```ruby
PuppetLint.configuration.send('disable_unquoted_string_in_case')
```


### Unquoted string in selector

Unquoted strings in selector statements are not valid with the future parser.

#### What you have done

```puppet
$foo = $::osfamily ? {
  Debian => 'bar',
  RedHat => 'baz',
  default => 'qux',
}
```

#### What you should have done

```puppet
$foo = $::osfamily ? {
  'Debian' => 'bar',
  'RedHat' => 'baz',
  default  => 'qux',
}
```

#### Disabling the check

To disable this check, you can add `--no-unquoted_string_in_selector-check` to your puppet-lint command line.

```shell
$ puppet-lint --no-unquoted_string_in_selector-check path/to/file.pp
```

Alternatively, if you’re calling puppet-lint via the Rake task, you should insert the following line to your `Rakefile`.

```ruby
PuppetLint.configuration.send('disable_unquoted_string_in_selector')
```

## Transfer Notice

This plugin was originally authored by [Camptocamp](http://www.camptocamp.com).
The maintainer preferred that Puppet Community take ownership of the module for future improvement and maintenance.
Existing pull requests and issues were transferred over, please fork and continue to contribute here instead of Camptocamp.

Previously: https://github.com/camptocamp/puppet-lint-unquoted_string-check
