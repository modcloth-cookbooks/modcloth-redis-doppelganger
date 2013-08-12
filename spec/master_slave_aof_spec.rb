require 'chefspec'

describe 'redis::master_slave_aof' do
  let(:chef_run) { ChefSpec::ChefRunner.new }

  before {
    chef_run.node.set['redis']['pkg_name'] = 'redis'
    chef_run.node.set['redis']['service_name'] = 'redis'
    chef_run.node.set['redis']['dir'] = '/opt/local/etc'
    chef_run.converge 'redis::master_slave_aof'
  }

  templates = {
      master: {
          name: '/opt/local/etc/redis.conf',
          source: 'redis.conf.rails.sessions.aof.erb',
          variables: {slaveof: nil}
      },
      slave: {
          name: '/opt/local/etc/redis-slave.conf',
          source: 'redis.conf.rails.sessions.master-slave.aof.erb',
          variables: {slaveof: {ipaddress: '127.0.0.1'}}
      }
  }

  it 'includes rails_sessions_aof recipe' do
    chef_run.node['redis']['master_slave'].should == true
    expect(chef_run).to include_recipe 'redis::rails_sessions_aof'
  end

  it 'creates redis.conf and redis-slave.conf file with correct slaveof' do
    expect(chef_run).to create_file '/opt/local/etc/redis.conf'
    expect(chef_run).to create_file '/opt/local/etc/redis-slave.conf'
  end

  it 'reads templates for redis.conf and redis-slave.conf files correctly' do
    files = chef_run.resources.select { |r| r.resource_name == :template }
    files.count.should == 2

    files.first.name.should == templates[:master][:name]
    files.first.source.should == templates[:master][:source]
    files.first.variables.should == templates[:master][:variables]

    files.last.name.should == templates[:slave][:name]
    files.last.source.should == templates[:slave][:source]
    files.last.variables.should == templates[:slave][:variables]
  end

  it 'creates redis-slave smf' do
    redis_slave_smf = chef_run.resources.select { |r| r.resource_name == :smf }.first
    redis_slave_smf.name.should == 'redis-slave'
    redis_slave_smf.start_command.should == "/opt/local/bin/redis-server %{config_file}"
    redis_slave_smf.service_path.should == "/var/svc/manifest"
    redis_slave_smf.property_groups['application'].should == {"config_file" => "/opt/local/etc/redis-slave.conf"}
  end

end
