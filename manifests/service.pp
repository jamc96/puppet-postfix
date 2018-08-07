# == Class: postfix
#
class postfix::service inherits postfix{
  # service resource
  service { 'postfix':
    ensure     => $postfix::service_ensure,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }
}
