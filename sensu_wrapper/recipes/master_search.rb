




ip_type = node["sensu_wrapper"]["use_local_ipv4"] ? "local_ipv4" : "public_ipv4"
master_address = node["sensu_wrapper"]["master_address"]

case
when Chef::Config[:solo]
  master_address ||= "localhost"
when master_address.nil?
  if node["recipes"].include?("sensu_wrapper::master")
    master_address = "localhost"
  else
    master_node = case
    when node["sensu_wrapper"]["environment_aware_search"]
      search(:node, "chef_environment:#{node.chef_environment} AND recipes:sensu_wrapper\\:\\:master").first
    else
      search(:node, "recipes:sensu_wrapper\\:\\:master").first
    end

    master_address = case
    when master_node.has_key?("cloud")
      master_node["cloud"][ip_type] || master_node["ipaddress"]
    else
      master_node["ipaddress"]
    end
  end
end

node.override["sensu"]["rabbitmq"]["host"] = master_address
node.override["sensu"]["redis"]["host"] = master_address
node.override["sensu"]["api"]["host"] = master_address
