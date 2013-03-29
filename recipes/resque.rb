package node['redis']['pkg_name'] do
  action :install
end

service 'redis' do
  action [:enable, :start]
end