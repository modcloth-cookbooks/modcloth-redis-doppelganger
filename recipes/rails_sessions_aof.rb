package node['redis']['pkg_name'] do
  action :install
end

template "#{node['redis']['dir']}/redis.conf" do
  source 'redis.conf.rails.sessions.aof.erb'
  slaveof = node[:redis][:slaveof]
  variables(
    :slaveof => slaveof
  )
end

service 'redis' do
  action [:enable, :start]
end

if node[:redis][:master_slave]
  template "#{node['redis']['dir']}/redis-slave.conf" do
    source 'redis.conf.rails.sessions.master-slave.aof.erb'
    variables(
      :slaveof => { :ipaddress => '127.0.0.1' }
    )
  end

  smf 'redis-slave' do
    start_command '/opt/local/bin/redis-server %{config_file}'
    start_timeout 60
    stop_command ':kill'
    stop_timeout 60

    ignore ['core', 'signal']
    manifest_type 'application'
    service_path  '/var/svc/manifest'
    property_groups({
      'application' => {
        'config_file' => "#{node['redis']['dir']}/redis-slave.conf"
      }
    })
  end

  service 'redis-slave' do
    action [:enable, :start]
  end
end

