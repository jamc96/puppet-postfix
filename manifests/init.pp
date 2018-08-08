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
  Pattern[/^[.+_0-9:~-]+$/] $version = $postfix::params::version,
  String $package_ensure             = $postfix::params::package_ensure,
  String $port                       = '587',
  String $config_file                = '/etc/postfix/main.cf',
  String $config_ensure              = 'present',
  String $service_ensure             = 'running',
  String $sample_directory           = "/usr/share/doc/postfix-${version}/samples",
  String $readme_directory           = "/usr/share/doc/postfix-${version}/README_FILES",
  String $manpage_directory          = '/usr/share/man',
  String $html_directory             = 'no',
  String $setgid_group               = 'postdrop',
  String $mailq_path                 = '/usr/bin/mailq.postfix',
  String $newaliases_path            = '/usr/bin/newaliases.postfix',
  String $sendmail_path              = '/usr/sbin/sendmail.postfix',
  String $debug_peer_level           = '2',
  String $alias_database             = 'hash:/etc/aliases',
  String $alias_maps                 = 'hash:/etc/aliases',
  String $ukwn_reject_code           = '550',
  String $mydestination              = '$myhostname, localhost.$mydomain, localhost',
  String $inet_protocols             = 'all',
  String $inet_interfaces            = 'localhost',
  String $mail_owner                 = 'postfix',
  String $data_directory             = '/var/lib/postfix',
  String $daemon_directory           = '/usr/libexec/postfix',
  String $command_directory          = '/usr/sbin',
  String $queue_directory            = '/var/spool/postfix',
  String $myhostname                 = $::hostname,
  String $mydomain                   = $::domain,
  String $myorigin                   = $::fqdn,
  String $relayhost                  = '[mail.isp.example]',
  String $smtp_use_tls               = 'yes',
  String $aliases_path               = '/etc/aliases',
  String $mail_recipient             = 'nobody',
  Optional[String] $mysql_lib_source = undef,
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
