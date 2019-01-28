# == Class: postfix::install
#
class postfix::install inherits postfix {
  # resources
  package { 'postfix':
    ensure   => $postfix::package_ensure,
  }
}
