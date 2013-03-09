package "redis" do
  action :install
end

template "#{node['redis']['dir']}/redis.conf" do
  source "redis.conf.rails.sessions.aof.erb"
  slaveof = node[:redis][:slaveof]
  variables(
    :port => '6379',
    :redis_pid => 'redis.pid',
    :redis_log => 'redis.log',
    :slaveof => slaveof,
    :aof_file_name => 'appendonly.aof',
    :appendfsync => 'no',
    :auto_aof_rewrite_percentage => 0
  )
end

service "redis" do
  action [:enable, :start]
end

if node[:redis][:master]
  template "#{node['redis']['dir']}/redis-slave.conf" do
    source "redis.conf.rails.sessions.aof.erb"
    variables(
      :port => '6380',
      :redis_pid => 'redis-slave.pid',
      :redis_log => 'redis-slave.log',
      :slaveof => { :ipaddress => '127.0.0.1' },
      :aof_file_name => 'appendonly.aof',
      :appendfsync => 'everysec',
      :auto_aof_rewrite_percentage => 100
    )
  end

  smf "redis-slave" do
    start_command "/opt/local/bin/redis-server %{config_file}"
    start_timeout 60
    stop_command ":kill"
    stop_timeout 60

    ignore ["core", "signal"]
    manifest_type "application"
    service_path  "/var/svc/manifest"
    property_groups({
      "application" => {
        "config_file" => "#{node['redis']['dir']}/redis-slave.conf"
      }
    })
  end

  service "redis-slave" do
    action [:enable, :start]
  end
end

