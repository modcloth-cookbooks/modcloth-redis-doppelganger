if node['application'] && node['application']['environment']
  node.set[:redis][:slaveof] = search('node', "roles:redis-sessions AND application_environment:#{node['application']['environment']}").first
end

include_recipe 'redis::rails_sessions_aof'