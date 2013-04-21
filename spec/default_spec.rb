require 'chefspec'

describe 'redis::default' do
  let(:chef_run) { ChefSpec::ChefRunner.new }

  before {
    chef_run.node.set['redis']['pkg_name'] = 'redis'
    chef_run.node.set['redis']['service_name'] = 'redis'
    chef_run.node.set['redis']['dir'] = '/opt/local/etc'
    chef_run.converge 'redis::default'
  }

  it 'installs redis' do
    expect(chef_run).to install_package 'redis'
  end

  it 'enables and starts redis service' do
    expect(chef_run).to enable_service 'redis'
    expect(chef_run).to start_service 'redis'
  end
end
