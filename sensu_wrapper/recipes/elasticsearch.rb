

include_recipe "sensu_wrapper::default"

sensu_gem "rest-client"
sensu_gem "json"

%w[
 check-es-cluster-status.rb
 check-es-file-descriptors.rb
 check-es-heap.rb
 es-node-metrics.rb
].each do |default_plugin|
  cookbook_file "#{node["sensu"]["directory"]}/plugins/#{default_plugin}" do
    source "plugins/#{default_plugin}"
    mode 0755
  end
end
