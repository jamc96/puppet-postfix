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
        "sample_directory\s+[=]\s+\/usr\/share\/doc\/postfix[-]#{version}/samples",
        "readme_directory\s+[=]\s+\/usr\/share\/doc\/postfix[-]#{version}/README_FILES",
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
end
