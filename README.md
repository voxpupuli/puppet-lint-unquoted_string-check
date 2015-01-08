puppet-lint-unquoted_string-check
=================================

[![Build Status](https://travis-ci.org/camptocamp/puppet-lint-unquoted_string-check.svg)](https://travis-ci.org/camptocamp/puppet-lint-unquoted_string-check)
[![Code Climate](https://codeclimate.com/github/camptocamp/puppet-lint-unquoted_string-check/badges/gpa.svg)](https://codeclimate.com/github/camptocamp/puppet-lint-unquoted_string-check)
[![Gem Version](https://badge.fury.io/rb/puppet-lint-unquoted_string-check.svg)](http://badge.fury.io/rb/puppet-lint-unquoted_string-check)
[![Coverage Status](https://img.shields.io/coveralls/camptocamp/puppet-lint-unquoted_string-check.svg)](https://coveralls.io/r/camptocamp/puppet-lint-unquoted_string-check?branch=master)

A puppet-lint plugin to check that selectors and case statements cases are quoted.


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
