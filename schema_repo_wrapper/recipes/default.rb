#
# Cookbook Name:: schema-repo_wrapper
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

 
include_recipe 'apt'
include_recipe 'java'
include_recipe 'ark'

app_name = "schema-repo"
data_dir = "#{node['schema_repo']['dir']}/data"

directory "/vol" do
    owner 'root'
    group 'root'
    mode '0644'
    action :create
    recursive true
end

package 'unzip'
package 'maven'

if !::File.exist?("#{node['schema_repo']['dir']}/deploy.sh")
    ark 'schema-repo' do
        url node['schema_repo']['zip_url']
        path '/vol'
        action :put
    end 
    execute 'deploy' do
        cwd "#{node['schema_repo']['dir']}"
        command 'mvn install'
    end 
end

template "/etc/init.d/schema-repo" do
    source 'schema-repo.erb'
    mode '0755'
    owner 'root'
    group 'root'
    variables ({
        :path => node['schema_repo']['dir']
    })  
    notifies :restart, 'service[schema-repo]', :immediately
end

template "#{node['schema_repo']['dir']}/bundle/config/local-file-system-config.properties" do
    source "local-file-system-config.properties.erb"
    owner 'root'
    group 'root'
    mode '0644'
    variables({
        :data_dir => data_dir
    })
    notifies :restart, 'service[schema-repo]', :immediately
end

service 'schema-repo' do
    action :start
end

template "#{node['schema_repo']['dir']}/zk-bundle/config/config.properties" do
    source 'zookeeper.properties.erb'
    mode '0644'
    owner 'root'
    group 'root'
    variables ({
        :zk_nodes => node['schema_repo']['zk']
    })  
    notifies :restart, 'service[schema-repo]', :immediately
end
