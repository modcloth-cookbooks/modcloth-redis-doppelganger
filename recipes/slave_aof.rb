node.set[:redis][:slaveof] = search("node", "roles:redis-sessions AND chef_environment:#{node.chef_environment}").first

include_recipe 'redis::rails_sessions_aof'