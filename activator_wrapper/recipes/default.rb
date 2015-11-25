#
# Cookbook Name:: activator_wrapper
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'apt'
include_recipe 'java'
package 'unzip'

ark 'activator' do
    url node['activator']['zip_url']
    #checksum node['activator']['zip_checksum']
    path node['activator']['dir']
    action :put
end

link "/usr/local/bin/activator" do
    to "#{node['activator']['dir']}/activator/activator"
    owner 'root'
    group 'root'
end



#bash 'install_activator' do
#    cwd dir
#    code <<-EOH
#        apt-get install unzip && \
#        wget http://downloads.typesafe.com/typesafe-activator/"#{version}"/typesafe-activator-"#{version}".zip && \
#        unzip typesafe-activator-"#{version}".zip && \
#        rm -f typesafe-activator-"#{version}".zip && \
#        mv /opt/activator-dist-"#{version}" /opt/activator && \
#        ln -s /opt/activator/activator /usr/local/bin/activator
#    EOH
#    not_if do ::File.exists?('/usr/local/bin/activator') end
#    action :run
#end
