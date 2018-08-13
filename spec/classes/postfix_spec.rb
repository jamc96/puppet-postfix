require 'spec_helper'

describe 'postfix' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to compile.with_all_deps }
      # packages
      if os_facts[:operatingsystemmajrelease] == '7'
        package_ensure = '2:2.10.1-6.el7'
        version        = '2.10.1'
      else
        package_ensure   = '2:2.6.6-8.el6'
        version          = '2.6.6'
      end
      it { is_expected.to contain_package('postfix').with(ensure: package_ensure, provider: 'yum') }
      # config files
      # main config file configuration
      regex_array = [
        'queue_directory\s+[=]\s+\/var\/spool\/postfix',
        'command_directory\s+[=]\s+\/usr\/sbin',
        'daemon_directory\s+[=]\s+\/usr\/libexec\/postfix',
        'data_directory\s+[=]\s+\/var\/lib\/postfix',
        'mail_owner\s+[=]\s+postfix',
        'myhostname\s+[=]\s+foo',
        'mydomain\s+[=]\s+example.com',
        'myorigin\s+[=]\s+foo.example.com',
        'inet_interfaces\s+[=]\s+localhost',
        'inet_protocols\s+[=]\s+all',
        'mydestination\s+[=]\s+\$myhostname[,]\s+localhost[.]\$mydomain[,]\s+localhost',
        'unknown_local_recipient_reject_code\s+[=]\s+550',
        'relayhost\s+[=]\s+\[mail.isp.example\][:]587',
        'alias_maps\s+[=]\s+hash[:]\/etc\/aliases',
        'alias_database\s+[=]\s+hash[:]\/etc\/aliases',
        'debug_peer_level\s+[=]\s+2',
        'sendmail_path\s+[=]\s+\/usr\/sbin\/sendmail[.]postfix',
        'newaliases_path\s+[=]\s+\/usr\/bin\/newaliases[.]postfix',
        'mailq_path\s+[=]\s+\/usr\/bin\/mailq[.]postfix',
        'setgid_group\s+[=]\s+postdrop',
        'html_directory\s+[=]\s+no',
        'manpage_directory\s+[=]\s+\/usr\/share\/man',
        "sample_directory\s+[=]\s+\/usr\/share\/doc\/postfix[-]#{version}\/samples",
        "readme_directory\s+[=]\s+\/usr\/share\/doc\/postfix[-]#{version}\/README_FILES",
        'smtp_use_tls\s+[=]\s+yes',
      ]
      it { is_expected.to contain_file('/etc/postfix/main.cf').with(ensure: 'present', owner: 'root', group: 'root') }
      regex_array.each do |regex|
        it { is_expected.to contain_file('/etc/postfix/main.cf').with_content(%r{^#{regex}$}) }
      end
      # aliases
      it { is_expected.to contain_file('/etc/aliases').with(ensure: 'present', owner: 'root', group: 'root') }
    end
  end
  context 'with version => 3.0.1' do
    let(:params) { { 'version' => '3.0.1' } }

    it { is_expected.to contain_file('/etc/postfix/main.cf').with_content(%r{^sample_directory\s+[=]\s+\/usr\/share\/doc\/postfix[-]3[.]0[.]1\/samples$}) }
    it { is_expected.to contain_file('/etc/postfix/main.cf').with_content(%r{^readme_directory\s+[=]\s+\/usr\/share\/doc\/postfix[-]3[.]0[.]1\/README_FILES$}) }
  end
  context 'with package_ensure => 3:3.0.1-7.el6' do
    let(:params) { { 'package_ensure' => '3:3.0.1-7.el6' } }

    it { is_expected.to contain_package('postfix').with(ensure: '3:3.0.1-7.el6', provider: 'yum') }
  end
  context 'with port => 25' do
    let(:params) { { 'port' => '25' } }

    it { is_expected.to contain_file('/etc/postfix/main.cf').with_content(%r{^relayhost\s+[=]\s+\[mail.isp.example\][:]25$}) }
  end
  context 'with config_file => /tmp/main.cf' do
    let(:params) { { 'config_file' => '/tmp/main.cf' } }

    it { is_expected.to contain_file('/tmp/main.cf').with_ensure('present') }
  end
  context 'with config_ensure => absent' do
    let(:params) { { 'config_ensure' => 'absent' } }

    it { is_expected.to contain_file('/etc/postfix/main.cf').with_ensure('absent') }
    it { is_expected.to contain_file('/etc/aliases').with_ensure('absent') }
  end
  context 'with service_ensure => stopped' do
    let(:params) { { 'service_ensure' => 'stopped' } }

    it { is_expected.to contain_service('postfix').with_ensure('stopped') }
  end
  context 'with sample_directory => /tmp/samples' do
    let(:params) { { 'sample_directory' => '/tmp/samples' } }

    it { is_expected.to contain_file('/etc/postfix/main.cf').with_content(%r{^sample_directory\s+[=]\s+\/tmp\/samples$}) }
  end
  context 'with readme_directory => /tmp/README_FILES' do
    let(:params) { { 'readme_directory' => '/tmp/README_FILES' } }

    it { is_expected.to contain_file('/etc/postfix/main.cf').with_content(%r{^readme_directory\s+[=]\s+\/tmp\/README_FILES$}) }
  end
  context 'with html_directory => yes' do
    let(:params) { { 'html_directory' => 'yes' } }

    it { is_expected.to contain_file('/etc/postfix/main.cf').with_content(%r{^html_directory\s+[=]\s+yes$}) }
  end
  context 'with setgid_group => predrop' do
    let(:params) { { 'setgid_group' => 'predrop' } }

    it { is_expected.to contain_file('/etc/postfix/main.cf').with_content(%r{^setgid_group\s+[=]\s+predrop$}) }
  end
  context 'with mailq_path => /bin/mailq.postfix' do
    let(:params) { { 'mailq_path' => '/bin/mailq.postfix' } }

    it { is_expected.to contain_file('/etc/postfix/main.cf').with_content(%r{^mailq_path\s+[=]\s+\/bin\/mailq[.]postfix$}) }
  end
  context 'with newaliases_path => /bin/newaliases.postfix' do
    let(:params) { { 'newaliases_path' => '/bin/newaliases.postfix' } }

    it { is_expected.to contain_file('/etc/postfix/main.cf').with_content(%r{^newaliases_path\s+[=]\s+\/bin\/newaliases[.]postfix$}) }
  end
  context 'with sendmail_path => /bin/sendmail.postfix' do
    let(:params) { { 'sendmail_path' => '/bin/sendmail.postfix' } }

    it { is_expected.to contain_file('/etc/postfix/main.cf').with_content(%r{^sendmail_path\s+[=]\s+\/bin\/sendmail[.]postfix$}) }
  end
  context 'with debug_peer_level => 1' do
    let(:params) { { 'debug_peer_level' => '1' } }

    it { is_expected.to contain_file('/etc/postfix/main.cf').with_content(%r{^debug_peer_level\s+[=]\s+1$}) }
  end
  context 'with alias_database => hash:/tmp/aliases' do
    let(:params) { { 'alias_database' => 'hash:/tmp/aliases' } }

    it { is_expected.to contain_file('/etc/postfix/main.cf').with_content(%r{^alias_database\s+[=]\s+hash[:]\/tmp\/aliases$}) }
  end
  context 'with alias_maps => hash:/tmp/aliases' do
    let(:params) { { 'alias_maps' => 'hash:/tmp/aliases' } }

    it { is_expected.to contain_file('/etc/postfix/main.cf').with_content(%r{^alias_maps\s+[=]\s+hash[:]\/tmp\/aliases$}) }
  end
  context 'with ukwn_reject_code => 400' do
    let(:params) { { 'ukwn_reject_code' => '400' } }

    it { is_expected.to contain_file('/etc/postfix/main.cf').with_content(%r{^unknown_local_recipient_reject_code\s+[=]\s+400$}) }
  end
  context 'with mydestination => $myhostname' do
    let(:params) { { 'mydestination' => '$myhostname' } }

    it { is_expected.to contain_file('/etc/postfix/main.cf').with_content(%r{^mydestination\s+[=]\s+\$myhostname$}) }
  end
  context 'with inet_interfaces => 255.255.255.0' do
    let(:params) { { 'inet_interfaces' => '255.255.255.0' } }

    it { is_expected.to contain_file('/etc/postfix/main.cf').with_content(%r{^inet_interfaces\s+[=]\s+255[.]255[.]255[.]0$}) }
  end
  context 'with mail_owner => root' do
    let(:params) { { 'mail_owner' => 'root' } }

    it { is_expected.to contain_file('/etc/postfix/main.cf').with_content(%r{^mail_owner\s+[=]\s+root$}) }
  end
  context 'with data_directory => /tmp/postfix' do
    let(:params) { { 'data_directory' => '/tmp/postfix' } }

    it { is_expected.to contain_file('/etc/postfix/main.cf').with_content(%r{^data_directory\s+[=]\s+\/tmp\/postfix$}) }
  end
  context 'with daemon_directory => /tmp/libexec/postfix' do
    let(:params) { { 'daemon_directory' => '/tmp/libexec/postfix' } }

    it { is_expected.to contain_file('/etc/postfix/main.cf').with_content(%r{^daemon_directory\s+[=]\s+\/tmp\/libexec\/postfix$}) }
  end
  context 'with command_directory => /bin' do
    let(:params) { { 'command_directory' => '/bin' } }

    it { is_expected.to contain_file('/etc/postfix/main.cf').with_content(%r{^command_directory\s+[=]\s+\/bin$}) }
  end
  context 'with queue_directory => /tmp/spool/postfix' do
    let(:params) { { 'queue_directory' => '/tmp/spool/postfix' } }

    it { is_expected.to contain_file('/etc/postfix/main.cf').with_content(%r{^queue_directory\s+[=]\s+\/tmp\/spool\/postfix$}) }
  end
  context 'with myhostname => bar' do
    let(:params) { { 'myhostname' => 'bar' } }

    it { is_expected.to contain_file('/etc/postfix/main.cf').with_content(%r{^myhostname\s+[=]\s+bar$}) }
  end
  context 'with mydomain => test.com' do
    let(:params) { { 'mydomain' => 'test.com' } }

    it { is_expected.to contain_file('/etc/postfix/main.cf').with_content(%r{^mydomain\s+[=]\s+test[.]com$}) }
  end
  context 'with myorigin => bar.test.com' do
    let(:params) { { 'myorigin' => 'bar.test.com' } }

    it { is_expected.to contain_file('/etc/postfix/main.cf').with_content(%r{^myorigin\s+[=]\s+bar[.]test[.]com$}) }
  end
  context 'with relayhost => mail.test.com' do
    let(:params) { { 'relayhost' => 'mail.test.com' } }

    it { is_expected.to contain_file('/etc/postfix/main.cf').with_content(%r{^relayhost\s+[=]\s+mail[.]test[.]com:587$}) }
  end
  context 'with smtp_use_tls => no' do
    let(:params) { { 'smtp_use_tls' => 'no' } }

    it { is_expected.to contain_file('/etc/postfix/main.cf').with_content(%r{^smtp_use_tls\s+[=]\s+no$}) }
  end
  context 'with smtp_use_tls => no' do
    let(:params) { { 'smtp_use_tls' => 'no' } }

    it { is_expected.to contain_file('/etc/postfix/main.cf').with_content(%r{^smtp_use_tls\s+[=]\s+no$}) }
  end
  context 'with aliases_path => /tmp/aliases' do
    let(:params) { { 'aliases_path' => '/tmp/aliases' } }

    it { is_expected.to contain_file('/tmp/aliases').with_ensure('present') }
  end
  context 'with mail_recipient => all' do
    let(:params) { { 'mail_recipient' => 'all' } }

    it { is_expected.to contain_file('/etc/aliases').with_content(%r{^root[:]all$}) }
  end
end
