# == Class: postfix::configure
#
class postfix::config(
  $config_dir       = $::postfix::config_dir,
  $config_ensure    = $::postfix::config_ensure,
  $config_group     = $::postfix::config_group,
  $config_owner     = $::postfix::config_owner,
  $config_mode      = $::postfix::config_mode,
  $sample_directory = $::postfix::sample_directory,
  $readme_directory = $::postfix::readme_directory,
  ) {
  # resources
  file { 'main.cf':
    ensure  => $config_ensure,
    content => template("${module_name}/main.cf.erb"),
    group   => $config_group,
    mode    => $config_mode,
    owner   => $config_owner,
    path    => $config_dir,
  }
}
