#
# Cookbook Name:: nginx_wrapper
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'nginx'

if node.environment == "qa" 
    es_nodes = search(:node, "role:elasticsearch AND chef_environment:qa")	
    lb_nodes = search(:node, "role:hadoop_datanode_mesos AND chef_environment:qa")	
    uchiwa_nodes = search(:node, "role:sensu_server AND chef_environment:qa")	
    grafana_nodes = search(:node, "role:sensu_server AND chef_environment:qa")	
elsif node.enviroment == "production"
    es_nodes = search(:node, "role:elasticsearch AND chef_environment:production")	
    lb_nodes = search(:node, "role:hadoop_datanode_mesos AND chef_environment:production")	
    uchiwa_nodes = search(:node, "role:sensu_server AND chef_environment:production")	
    grafana_nodes = search(:node, "role:sensu_server AND chef_environment:production")	
else 
    es_nodes = search(:node, "role:elasticsearch AND chef_environment:dev")	
    lb_nodes = search(:node, "role:hadoop_datanode_mesos AND chef_environment:dev")	
    uchiwa_nodes = search(:node, "role:sensu_server AND chef_environment:dev")	
    grafana_nodes = search(:node, "role:sensu_server AND chef_environment:dev")	
end

    

template "#{node['nginx']['dir']}/sites-available/server.conf" do
    source 'server.conf.erb'
    mode '0644'
    owner 'root'
    group 'root'
    variables({
        :es_nodes => es_nodes,
        :lb_nodes => lb_nodes,
        :uch_nodes => uchiwa_nodes,
        :gra_nodes => grafana_nodes,
        :pub_ipaddress => node['ec2']['public_ipv4']

    })
end

link "#{node['nginx']['dir']}/sites-enabled/server.conf" do
  to "#{node['nginx']['dir']}/sites-available/server.conf"
  mode '0644'
  owner 'root'
  group 'root'
end
