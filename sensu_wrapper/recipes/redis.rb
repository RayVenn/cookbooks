

include_recipe "sensu_wrapper::default"

sensu_gem "redis"

%w[
 check-redis-memory.rb
 redis-metrics.rb 
].each do |default_plugin|
  cookbook_file "#{node["sensu"]["directory"]}/plugins/#{default_plugin}" do
    source "plugins/#{default_plugin}"
    mode 0755
  end
end
