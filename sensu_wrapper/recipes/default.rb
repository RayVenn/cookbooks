#
# Cookbook Name:: sensu_wrapper
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


include_recipe "build-essential"
include_recipe "sensu_wrapper::master_search"

chef_gem "chef-rewind"
require 'chef/rewind'

include_recipe "sensu::default"
unwind "template[/etc/default/sensu]"

template "/etc/default/sensu" do
    source "sensu.default.erb"
    notifies :create, "ruby_block[sensu_service_trigger]"
end

ip_type = node["sensu_wrapper"]["use_local_ipv4"] ? "local_ipv4" : "public_ipv4"
client_attributes = nil

sensu_client node.name do
  if node.has_key?("cloud")
    address node["cloud"][ip_type] || node["ipaddress"]
  else
    address node["ipaddress"]
  end
  subscriptions node["roles"] + ["all"]
  additional client_attributes
end

%w[
  check-disk.rb
  check-process.sh
  cpu-pcnt-usage-metrics.rb
  memory-pcnt-metrics.rb
  disk-usage-metrics.rb
].each do |default_plugin|
  cookbook_file "#{node["sensu"]["directory"]}/plugins/#{default_plugin}" do
    source "plugins/#{default_plugin}"
    mode 0755
  end
end

include_recipe "sensu::client_service"
