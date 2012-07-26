package "redis" do
  action :install
end

cookbook_file '/opt/local/etc/redis.conf' do
  source 'redis.conf'
  mode '0644'
end

service "redis" do
  action :enable
end