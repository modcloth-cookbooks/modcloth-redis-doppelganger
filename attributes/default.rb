case platform
when 'ubuntu'
  default['redis']['pkg_name'] = 'redis-server'
  default['redis']['service_name'] = 'redis-server'
  default['redis']['dir'] = '/etc'
when 'smartos'
	default['redis']['pkg_name'] = 'redis'
	default['redis']['service_name'] = 'redis'
	default['redis']['dir'] = '/opt/local/etc'

  # redis default attributes for either master or slave
  default['redis']['port'] = 6379
  default['redis']['redis_pid'] = 'redis.pid'
  default['redis']['redis_log'] = 'redis.log'
  default['redis']['aof_file_name'] = 'appendonly.aof'

  # redis master/slave attributes
  default['redis-master-slave']['port'] = 6380
  default['redis-master-slave']['redis_pid'] = 'redis-slave.pid'
  default['redis-master-slave']['redis_log'] = 'redis-slave.log'
  default['redis-master-slave']['aof_file_name'] = 'appendonly.aof'
  default['redis-master-slave']['appendfsync'] = 'everysec'
  default['redis-master-slave']['auto_aof_rewrite_percentage'] = 100
end

