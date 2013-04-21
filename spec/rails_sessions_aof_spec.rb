require 'chefspec'

describe 'redis::rails_sessions_aof' do
  let(:chef_run) { ChefSpec::ChefRunner.new }

  before {
    chef_run.node.set['redis']['pkg_name'] = 'redis'
    chef_run.node.set['redis']['service_name'] = 'redis'
    chef_run.node.set['redis']['dir'] = '/opt/local/etc'
  }



  context 'master_slave attribute is not true' do
    before { chef_run.converge 'redis::rails_sessions_aof' }

    it 'installs redis' do
      expect(chef_run).to install_package 'redis'
    end

    it 'creates file redis.conf' do
      expect(chef_run).to create_file '/opt/local/etc/redis.conf'
      expect(chef_run).to_not create_file '/opt/local/etc/redis-slave.conf'
    end

    it 'enables and starts redis service' do
      expect(chef_run).to enable_service 'redis'
      expect(chef_run).to start_service 'redis'
    end

  end

  context 'master_slave attribute is true' do
    before {
      chef_run.node.set['redis']['master_slave'] = true
      chef_run.converge 'redis::rails_sessions_aof'
    }

    it 'creates file redis-slave.conf' do
      expect(chef_run).to create_file '/opt/local/etc/redis-slave.conf'
    end

    it 'enables and starts redis and redis-slave' do
      expect(chef_run).to enable_service 'redis-slave'
      expect(chef_run).to start_service 'redis-slave'
    end
  end
end
