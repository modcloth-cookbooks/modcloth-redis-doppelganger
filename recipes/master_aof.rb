node.set[:redis][:master] = true

include_recipe "redis::rails_sessions_aof"