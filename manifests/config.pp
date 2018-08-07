# == Class: postfix::configure
#
class postfix::config inherits postfix {
  # defaults
  File {
    ensure => $postfix::config_ensure,
    owner  => 'root',
    group  => 'root',
  }
  # config files
  file {
    $postfix::config_file:
      content => template("${module_name}/main.cf.erb");
    $postfix::aliases_path:
      content => template("${module_name}/aliases.erb");
  }
}
