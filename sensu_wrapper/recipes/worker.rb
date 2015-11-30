


include_recipe "sensu_wrapper::master_search"

chef_gem "chef-rewind"
require 'chef/rewind'

include_recipe "sensu::default"
unwind "template[/etc/default/sensu]"

template "/etc/default/sensu" do
    source "sensu.default.erb"
    notifies :create, "ruby_block[sensu_service_trigger]"
end

sensu_gem "sensu-plugin" do
  version node["sensu_wrapper"]["sensu_plugin_version"]
end

handlers = node["sensu_wrapper"]["default_handlers"] + node["sensu_wrapper"]["metric_handlers"]
handlers.each do |handler_name|
  next if handler_name == "debug"
  include_recipe "sensu_wrapper::#{handler_name}_handler"
end

sensu_handler "default" do
  type "set"
  handlers node["sensu_wrapper"]["default_handlers"]
end

sensu_handler "metrics" do
  type "set"
  handlers node["sensu_wrapper"]["metric_handlers"]
end

check_definitions = case
when Chef::Config[:solo]
  data_bag("sensu_checks").map do |item|
    data_bag_item("sensu_checks", item)
  end
when Chef::DataBag.list.has_key?("sensu_checks")
  search(:sensu_checks, "*:*")
else
  Array.new
end

check_definitions.each do |check|
  sensu_check check["id"] do
    type check["type"]
    command check["command"]
    subscribers check["subscribers"]
    interval check["interval"]
    handlers check["handlers"]
    additional check["additional"]
  end
end

include_recipe "sensu::server_service"
