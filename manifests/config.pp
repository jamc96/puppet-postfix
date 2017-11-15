# == Class: postfix::configure
#
class postfix::config(
  $config_dir        = $::postfix::config_dir,
  $config_ensure     = $::postfix::config_ensure,
  $config_group      = $::postfix::config_group,
  $config_owner      = $::postfix::config_owner,
  $config_mode       = $::postfix::config_mode,
  $sample_directory  = $::postfix::sample_directory,
  $readme_directory  = $::postfix::readme_directory,
  $manpage_directory = $::postfix::manpage_directory,
  $html_directory    = $::postfix::html_directory,
  $setgid_group      = $::postfix::setgid_group,
  $mailq_path        = $::postfix::mailq_path,
  $newaliases_path   = $::postfix::newaliases_path,
  $sendmail_path     = $::postfix::sendmail_path,
  $debug_peer_level  = $::postfix::debug_peer_level,
  $alias_database    = $::postfix::alias_database,
  $alias_maps        = $::postfix::alias_maps,
  $ukwn_reject_code  = $::postfix::ukwn_reject_code,
  $mydestination     = $::postfix::mydestination,
  $inet_protocols    = $::postfix::inet_protocols,
  $inet_interfaces   = $::postfix::inet_interfaces,
  $mail_owner        = $::postfix::mail_owner,
  $data_directory    = $::postfix::data_directory,
  $daemon_directory  = $::postfix::daemon_directory,
  $command_directory = $::postfix::command_directory,
  $queue_directory   = $::postfix::queue_directory,
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
