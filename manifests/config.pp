# == Class: postfix::configure
#
class postfix::config(
  $sample_directory = $::postfix::sample_directory,
  $readme_directory = $::postfix::readme_directory,
  ) {
  # resources
  file { '/etc/postfix/main.cf':
    ensure  => 'file',
    content => template("${module_name}/main.cf.erb"),
    group   => 'roots',
    mode    => '0644',
    owner   => 'root',
  }
}
