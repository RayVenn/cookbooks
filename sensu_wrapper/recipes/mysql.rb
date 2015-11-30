include_recipe "build-essential::default"
include_recipe "sensu_wrapper::default"

sensu_gem "mysql"

%w[
 mysql-connections.rb
].each do |default_plugin|
  cookbook_file "#{node["sensu"]["directory"]}/plugins/#{default_plugin}" do
    source "plugins/#{default_plugin}"
    mode 0755
  end
end
