# == Class: postfix
#
class postfix::service(
  $service_name       = $::postfix::service_name,
  $service_ensure     = $::postfix::service_ensure,
  $service_enable     = $::postfix::service_enable,
  $service_hasrestart = $::postfix::service_hasrestart,
  $service_hasstatus  = $::postfix::hasstatus,
  ) {
  # resources
  service { $service_name:
    ensure     => $service_ensure,
    enable     => $service_enable,
    hasrestart => $service_hasrestart,
    hasstatus  => $service_hasstatus,
  }
}
