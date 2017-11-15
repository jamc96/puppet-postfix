# == Class: postfix::install
#
class postfix::install(
  $package_ensure   = $::posftix::package_ensure,
  $package_name     = $::posftix::package_name,
  $package_provider = $::posftix::package_provider,
  ) {
  # resources
  package { $package_name:
    ensure   => $package_ensure,
    name     => $package_name,
    provider => $package_provider,
  }
}
