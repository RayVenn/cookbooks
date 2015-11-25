# Cookbook Name:: kafka-manager_wrapper
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'apt'
include_recipe 'java'
include_recipe 'ark'

package 'unzip'

if !::File.exist?('/opt/kafka-manager/conf/application.conf')
    ark 'kafka-manager' do
        url node['kafka_manager']['zip_url']
        path '/tmp'
        action :put
    end

    bash 'deploy' do
        cwd '/tmp/kafka-manager'
        code <<-EOH
        ./sbt clean dist && cd target/universal
        unzip -q -o kafka-manager-*.zip && rm kafka-manager-*.zip
        mv kafka-manager-* #{node['kafka_manager']['dir']}
        EOH
    end
end

template "/etc/init.d/kafka-manager" do
    source 'kafka-manager.erb'
    mode '0755'
    owner 'root'
    group 'root'
    variables ({
        :path => node['kafka_manager']['dir']
    })
    notifies :restart, 'service[kafka-manager]', :immediately
end

service 'kafka-manager' do
    action :start
end

template "#{node['kafka_manager']['dir']}/conf/application.conf" do
    source 'application.conf.erb'
    mode '0644'
    owner 'root'
    group 'root'
    variables ({
        :zk_nodes => node['kafka_manager']['zk']
    })
    notifies :restart, 'service[kafka-manager]', :immediately
end
