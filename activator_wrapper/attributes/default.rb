#Attribute for activator_wrapper default cookbook
default['activator']['version'] = "1.3.6"
default['activator']['dir'] = '/opt'
default['activator']['zip_url'] = "http://downloads.typesafe.com/typesafe-activator/#{node['activator']['version']}/typesafe-activator-#{node['activator']['version']}.zip"

#Attribute for orverriding the attributes in java cookbook
default['java']['install_flavor'] = "oracle"
default['java']['jdk_version'] = "8"
default['java']['oracle']['accept_oracle_download_terms'] = true

#Attribute for overriding the attributes in ark cookbook
default['ark']['path'] = node['activator']['dir']

