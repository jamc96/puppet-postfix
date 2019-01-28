# Class: postfix
# ===========================
#
# Full description of class postfix here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'postfix':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2017 Your name here, unless otherwise noted.
#
class postfix(
  String $package_ensure,
  String $port,
  String $config_file,
  String $config_ensure,
  Enum['running','stopped'] $service_ensure,
  String $sample_directory,
  String $readme_directory,
  String $manpage_directory,
  Enum['yes','no'] $html_directory,
  String $setgid_group,
  String $mailq_path,
  String $newaliases_path,
  String $sendmail_path,
  String $debug_peer_level,
  String $alias_database,
  String $alias_maps,
  String $ukwn_reject_code,
  String $mydestination,
  String $inet_protocols,
  String $inet_interfaces,
  String $mail_owner,
  String $data_directory,
  String $daemon_directory,
  String $command_directory,
  String $queue_directory,
  String $myhostname,
  String $mydomain,
  String $myorigin,
  String $relayhost,
  Enum['yes','no'] $smtp_use_tls,
  String $aliases_path,
  String $mail_recipient,
  Optional[String] $mysql_lib_source,
  ){
  # mysql libs dependencies
  if $mysql_lib_source {
    exec { 'install_mysql_lib':
      path    =>  '/usr/bin:/usr/sbin:/bin',
      command => "rpm -Uvh ${mysql_lib_source}",
      onlyif  => 'rpm -qa |grep -i MySQL-server-5.6.12',
      unless  => ['rpm -qa |grep MariaDB','rpm -qa |grep -i MySQL-shared-compat-5.6.13-1.el6.x86_64'],
      notify  => Class['postfix::install'],
    }
  }
  # class containment
  contain ::postfix::install
  contain ::postfix::config
  contain ::postfix::service
  # class relationships
  Class['::postfix::install']
  -> Class['::postfix::config']
  ~> Class['::postfix::service']
}
