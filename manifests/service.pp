# == Class: postfix
#
class postfix::service(
  $service_name       = $::postfix::service_name,
  $service_ensure     = $::postfix::service_ensure,
  ) {
  # resources
  service { $service_name:
    ensure     => $service_ensure,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }
}
