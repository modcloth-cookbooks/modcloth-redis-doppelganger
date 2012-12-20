package node['redis']['pkg_name'] do
  action :install
end

template "#{node['redis']['dir']}/redis.conf" do
  source "redis.conf.erb"
end

service node['redis']['service_name'] do
  action [:enable, :start]
end