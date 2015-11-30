sensu_handler "slack" do
  type "pipe"
  command "/vol/sensu/handlers/slack.rb"
end

%w[
  slack.rb
].each do |default_plugin|
  cookbook_file "#{node["sensu"]["directory"]}/handlers/#{default_plugin}" do
    source "handlers/#{default_plugin}"
    mode 0755
  end 
end

cookbook_file "#{node["sensu"]["directory"]}/conf.d/slack.json" do
  source 'slack.json'
  mode '0755'
  action :create
end
