require 'spec_helper'

describe '<%= metadata['name'] %>' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context '<%= metadata['name'] %> class without any parameters' do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('<%= metadata['name'] %>::params') }
          it { is_expected.to contain_class('<%= metadata['name'] %>::install').that_comes_before('<%= metadata['name'] %>::config') }
          it { is_expected.to contain_class('<%= metadata['name'] %>::config') }
          it { is_expected.to contain_class('<%= metadata['name'] %>::service').that_subscribes_to('<%= metadata['name'] %>::config') }

          it { is_expected.to contain_service('<%= metadata['name'] %>') }
          it { is_expected.to contain_package('<%= metadata['name'] %>').with_ensure('present') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe '<%= metadata['name'] %> class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          :osfamily        => 'Solaris',
          :operatingsystem => 'Nexenta',
        }
      end

      it { expect { is_expected.to contain_package('<%= metadata['name'] %>') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
