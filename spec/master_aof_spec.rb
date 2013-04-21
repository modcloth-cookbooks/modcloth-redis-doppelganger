require 'chefspec'

describe 'redis::master_aof' do
  let(:chef_run) { ChefSpec::ChefRunner.new }

  before {
    chef_run.node.set['redis']['pkg_name'] = 'redis'
    chef_run.node.set['redis']['service_name'] = 'redis'
    chef_run.node.set['redis']['dir'] = '/opt/local/etc'
    chef_run.converge 'redis::master_aof'
  }

  it 'includes rails_sessions_aof recipe' do
    expect(chef_run).to include_recipe 'redis::rails_sessions_aof'
  end

  it 'creates redis.conf file with no slaveof' do
    expect(chef_run).to create_file '/opt/local/etc/redis.conf'
    expect(chef_run).to_not create_file '/opt/local/etc/redis-slave.conf'
  end

  it 'provides correct slaveof for the template' do
    files = chef_run.resources.select { |r| r.resource_name == :template }
    files.count.should == 1
    files.first.variables[:slaveof].should be_nil
  end
end
