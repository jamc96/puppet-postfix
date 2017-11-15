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
  $package_ensure   = $postfix::params::package_ensure,
  $package_name     = $postfix::params::package_name,
  $package_provider = $postfix::params::package_provider,
  $port             = '587',
  $config_dir       = '/etc/postfix/main.cf',
  $config_ensure    = 'file',
  $config_group     = 'root',
  $config_owner     = '0644',
  $config_mode      = 'root',
  $sample_directory = "/usr/share/doc/postfix-${postfix::params::version}/samples",
  $readme_directory = "/usr/share/doc/postfix-${postfix::params::version}/README_FILES",
  ) inherits postfix::params {

  class { '::postfix::install': } ->
  class { '::postfix::config': } ~>
  class { '::postfix::service': } ->
  Class['::postfix']
}
