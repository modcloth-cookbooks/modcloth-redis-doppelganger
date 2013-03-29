node.set[:redis][:master_slave] = true

include_recipe 'redis::rails_sessions_aof'