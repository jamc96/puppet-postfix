# == Define: postfix::alias
#
define postfix::aliases (
  Enum['present', 'absent', 'blank'] $ensure,
  $accounts,
  ) {
    case $ensure {
      'present': {
        $changes = "set ${name}: ${accounts}"
      }
      'absent': {
        $changes = "rm ${name}"
      }
      'blank': {
        $changes = "clear ${name}"
      }
      default: {
        fail "Uknown value for ensure ${ensure}"
      }
    }
  augeas{ "manage alias '${title}' ":
    context => '/etc/aliases',
    changes => $changes,
    require => File['/etc/aliases'],
  }
}
