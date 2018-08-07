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
  $version            = $postfix::params::version,
  $package_ensure     = $postfix::params::package_ensure,
  $port               = '587',
  $config_file        = '/etc/postfix/main.cf',
  $config_ensure      = 'present',
  $service_ensure     = 'running',
  $sample_directory   = "/usr/share/doc/postfix-${version}/samples",
  $readme_directory   = "/usr/share/doc/postfix-${version}/README_FILES",
  $manpage_directory  = '/usr/share/man',
  $html_directory     = 'no',
  $setgid_group       = 'postdrop',
  $mailq_path         = '/usr/bin/mailq.postfix',
  $newaliases_path    = '/usr/bin/newaliases.postfix',
  $sendmail_path      = '/usr/sbin/sendmail.postfix',
  $debug_peer_level   = '2',
  $alias_database     = 'hash:/etc/aliases',
  $alias_maps         = 'hash:/etc/aliases',
  $ukwn_reject_code   = '550',
  $mydestination      = '$myhostname, localhost.$mydomain, localhost',
  $inet_protocols     = 'all',
  $inet_interfaces    = 'localhost',
  $mail_owner         = 'postfix',
  $data_directory     = '/var/lib/postfix',
  $daemon_directory   = '/usr/libexec/postfix',
  $command_directory  = '/usr/sbin',
  $queue_directory    = '/var/spool/postfix',
  $myhostname         = $::hostname,
  $mydomain           = $::domain,
  $myorigin           = $::fqdn,
  $relayhost          = '[mail.isp.example]',
  $smtp_use_tls       = 'yes',
  $aliases_path       = '/etc/aliases',
  $mail_recipient     = 'nobody',
  $mysql_lib_source   = undef,
  ) inherits postfix::params {
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
  contain ::postfix::params
  # class relationships
  Class['::postfix::install']
  -> Class['::postfix::config']
  ~> Class['::postfix::service']
}
