require 'spec_helper'

describe 'hubot', :type => :class do
  context 'on a centos system' do
    let(:facts) do
      {
        :osfamily => 'RedHat'
      }
    end

    context 'when enable_epel is true' do
      let(:params) do
        {
          :enable_epel => true
        }
      end

      it 'should install epel' do
        should include_class('epel')
      end
    end

    context 'when enable_epel is false' do
      let(:params) do
        {
          :enable_epel => false
        }
      end

      it 'should not install epel' do
        should_not include_class('epel')
      end
    end

    context 'when defaulting to redis brain' do
      it 'should include the redis module' do
        should include_class('redis')
      end
    end

    context 'when specifying an unsupported brain' do
      let(:params) do
        {
          :brain => 'fuuuu'
        }
      end

      it 'should fail' do
        expect { subject }.to raise_error(Puppet::Error,/unsupported hubot brain \"fuuuu\"/)
      end
    end

    it 'should setup node stuff' do
      should contain_package('nodejs').with_ensure('installed')
      should contain_package('npm').with_ensure('installed')
    end

    it 'should have an init script' do
      should contain_file('/etc/init.d/hubot').with({
        :ensure  => 'file',
        :mode    => '0755',
      })
    end

    it 'should manage the hubot service' do
      should contain_service('hubot').with_ensure('running').with_enable('true')
    end
  end


  context 'on an unsupported osfamily' do
    let(:facts) do
      {
        :osfamily => 'fuuuu'
      }
    end

    it 'should slap the user and send them packing' do
      expect { subject }.to raise_error(Puppet::Error,/unsupported osfamily \"fuuuu\"/)
    end

  end
end