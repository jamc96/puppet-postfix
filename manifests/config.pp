# == Class: postfix::configure
#
class postfix::config(
  $sample_directory = $::postfix::sample_directory,
  $readme_directory = $::postfix::readme_directory,
  ) {
  # resources
  file { '/etc/postfix/main.cf':
    ensure   => 'file',
    content  => template("${module_name}/main.cf.erb"),
    group    => '0',
    mode     => '0644',
    owner    => '0',
    selrange => 's0',
    selrole  => 'object_r',
    seltype  => 'postfix_etc_t',
    seluser  => 'system_u',
    type     => 'file',
  }
}
