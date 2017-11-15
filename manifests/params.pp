# == Class: postfix::params
#
class postfix::params {
  $package_name     = 'postfix'
  $package_provider = 'yum'

  case $::operatingsystemmajrelease {
    '7': {
      $package_ensure   = '2:2.10.1-6.el7'
      $version          = '2.10.1'
    }
    default: {
      $package_ensure   = '2:2.6.6-8.el6'
      $version          = '2.6.6'
    }
  }

}
