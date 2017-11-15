# == Class: postfix::params
#
class postfix::params {
  $package_ensure   = 'present'
  $package_name     = 'postfix'
  $package_provider = 'yum'
}
