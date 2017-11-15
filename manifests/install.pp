# == Class: postfix::install
#
class postfix::install(
  $package_ensure   = $::postfix::package_ensure,
  $package_name     = $::postfix::package_name,
  $package_provider = $::postfix::package_provider,
  ) {
  # resources
  package { $package_name:
    ensure   => $package_ensure,
    name     => $package_name,
    provider => $package_provider,
  }
}
