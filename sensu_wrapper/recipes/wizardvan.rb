
sensu_dir = node["sensu"]["directory"]

directory "#{sensu_dir}/extensions/handlers" do
  recursive true
  owner 'root'
  group 'sensu'
end

directory "#{sensu_dir}/extensions/mutators" do
  recursive true
  owner 'root'
  group 'sensu'
end

cookbook_file "#{sensu_dir}/extensions/handlers/relay.rb" do
  source 'relay.rb'
  mode '0755'
  action :create
end

cookbook_file "#{sensu_dir}/extensions/mutators/metrics.rb" do
  source 'metrics.rb'
  mode '0755'
  action :create
end

cookbook_file "#{sensu_dir}/conf.d/config_relay.json" do
  source 'config_relay.json'
  mode '0755'
  action :create
end
