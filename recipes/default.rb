package node['redis']['pkg_name'] do
  action :install
end

service node['redis']['service_name'] do
  action [:enable, :start]
end