include_recipe "sensu_wrapper::default"

sensu_gem "rest-client"

%w[
  mesos-metrics.rb 
].each do |default_plugin|
  cookbook_file "#{node["sensu"]["directory"]}/plugins/#{default_plugin}" do
    source "plugins/#{default_plugin}"
    mode 0755
  end
end
