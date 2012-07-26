cookbook_file '/opt/scripts/redis_used_memory.sh' do
  source "redis_used_memory.sh"
  mode "0644"
end

cookbook_file '/opt/scripts/redis_dbsize.sh' do
  source "redis_dbsize.sh"
  mode "0644"
end