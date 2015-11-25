#
# Cookbook Name:: nginx_wrapper
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'nginx'

config="service.conf"


template "#{node['nginx']['dir']}/sites-available/#{config}" do
    source 'service.conf.erb'
    mode '0644'
    owner 'root'
    group 'root'
end

link "#{node['nginx']['dir']}/sites-enabled/#{config}" do
  to "#{node['nginx']['dir']}/sites-available/#{config}"
  mode '0644'
  owner 'root'
  group 'root'
end
