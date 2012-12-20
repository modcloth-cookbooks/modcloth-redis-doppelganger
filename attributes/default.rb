case platform
when "ubuntu"
  default['redis']['pkg_name'] = "redis-server"
  default['redis']['service_name'] = "redis-server"
  default['redis']['dir'] = "/etc"
when "smartos"
	default['redis']['pkg_name'] = "redis"
	default['redis']['service_name'] = "redis"
	default['redis']['dir'] = "/opt/local/etc"
end

