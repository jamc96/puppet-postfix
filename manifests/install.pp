# == Class: postfix::install
#
class postfix::install inherits postfix {
  # resources
  package { 'postfix':
    ensure   => $postfix::_package_ensure,
  }
}
