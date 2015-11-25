#
# Cookbook Name:: elasticsearch_wrapper
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'apt'
include_recipe 'java'
include_recipe 'chef-sugar'
include_recipe 'curl'


#Setting the config values
#secrets = data_bag_item('aws', 'keys')
service_name = 'elasticsearch'

if node.environment == "qa"
    if node.role?('elasticsearch')
        node.override['elasticsearch']['cluster_name'] = "qa_elasticsearch"
        node.override['elasticsearch']['ec2_group'] = "qa_sg_elasticsearch"
        node.override['elasticsearch']['bucket_name'] = "qa-elasticsearch"
    elsif node.role?('elasticsearch_logs')
        node.override['elasticsearch']['cluster_name'] = "qa_elasticsearch_logs"
        node.override['elasticsearch']['ec2_group'] = "qa_sg_elasticsearch_logs"
        node.override['elasticsearch']['bucket_name'] = "com.max2.qa-elasticsearch-logs"
    end
elsif node.environment == "production"
    if node.role?('elasticsearch')
        node.override['elasticsearch']['cluster_name'] = "production_elasticsearch"
        node.override['elasticsearch']['ec2_group'] = "production_sg_elasticsearch"
        node.override['elasticsearch']['bucket_name'] = "production-elasticsearch"
    elsif node.role?('elasticsearch_logs')
        node.override['elasticsearch']['cluster_name'] = "production_elasticsearch_logs"
        node.override['elasticsearch']['ec2_group'] = "production_sg_elasticsearch_logs"
        node.override['elasticsearch']['bucket_name'] = "com.max2.production-elasticsearch-logs"
    end        
else
    if node.role?('elasticsearch')    
        node.override['elasticsearch']['cluster_name'] = "dev_elasticsearch"
        node.override['elasticsearch']['ec2_group'] = "dev_sg_elasticsearch"
        node.override['elasticsearch']['bucket_name'] = "dev-elasticsearch"
    elsif node.role?('elasticsearch_logs')
        node.override['elasticsearch']['cluster_name'] = "dev_elasticsearch_logs"
        node.override['elasticsearch']['ec2_group'] = "dev_sg_elasticsearch_logs"
        node.override['elasticsearch']['bucket_name'] = "com.max2.dev-elasticsearch-logs"
    end        
end

elasticsearch_user 'elasticsearch' do
  username  'elasticsearch'
  groupname 'elasticsearch'
  homedir   "#{node['elasticsearch']['base_dir']}"
  shell     '/bin/bash'
  comment   'Elasticsearch User'

  action :create
end

elasticsearch_install 'my_es_installation' do
  type :tarball # type of install
  dir "#{node['elasticsearch']['base_dir']}"
  owner 'elasticsearch' # user and group to install under
  group 'elasticsearch'
  version "#{node['elasticsearch']['version']}"
  #download_url "#{node['elasticsearch']['download_urls']['debian']}"
  #download_checksum "#{node['elasticsearch']['checksums']['1.7.2']['debian']}"
  action :install # could be :remove as well
end


elasticsearch_configure 'my_elasticsearch' do
  dir "#{node['elasticsearch']['base_dir']}"
  es_home "#{node['elasticsearch']['base_dir']}/elasticsearch-#{node['elasticsearch']['version']}"
  path_conf "#{node['elasticsearch']['conf_dir']}"
  path_data "#{node['elasticsearch']['data_dir']}"
  path_logs "#{node['elasticsearch']['log_dir']}"
  logging({:"action" => 'INFO'})
    
  #Default calculation of allocated memory is good
  #allocated_memory '9216m'
  thread_stack_size "#{node['elasticsearch']['tss']}"

  #env_options '-DFOO=BAR'
  gc_settings <<-CONFIG
                -XX:+UseParNewGC
                -XX:+UseConcMarkSweepGC
                -XX:CMSInitiatingOccupancyFraction=75
                -XX:+UseCMSInitiatingOccupancyOnly
                -XX:+HeapDumpOnOutOfMemoryError
                -XX:+PrintGCDetails
              CONFIG

  configuration ({
    'node.name' => node.hostname,
    'cluster.name' => "#{node['elasticsearch']['cluster_name']}",
    'discovery.zen.ping.multicast.enabled' => false,
    #'cloud.aws.access_key' => secrets["access_key"],
    #'cloud.aws.secret_key' => secrets["secret_key"],
    'discovery.type' => 'ec2',
    'discovery.ec2.groups' => "#{node['elasticsearch']['ec2_group']}",
    'repositories.s3.bucket' => "#{node['elasticsearch']['bucket_name']}",
    'repositories.s3.region' => 'us-east'
  })
  
  action :manage
end

elasticsearch_service service_name  do
  #node_name 'crazy'
  path_conf "#{node['elasticsearch']['conf_dir']}"
  pid_path "#{node['elasticsearch']['pid_path']}"
  #user 'foo'
  #group 'bar'
end

=begin
#Creating directory for elasticsearch plugins
["#{node['elasticsearch']['base_dir']}/elasticsearch-#{node['elasticsearch']['version']}/plugins","#{node['elasticsearch']['base_dir']}/plugin"].each do |plugin_dir|
directory plugin_dir do
    owner 'root'
    group 'root'
    mode  '755'
    recursive true
    action :create
end
end
=end

#if !File.directory?("")

elasticsearch_plugin 'lmenezes/elasticsearch-kopf/master' do
  action :install
  not_if {File.directory?(File.join("#{node['elasticsearch']['plugin_dir']}", 'kopf'))}
end

elasticsearch_plugin 'elasticsearch/elasticsearch-cloud-aws/2.7.0' do
  action :install
  not_if {File.directory?(File.join("#{node['elasticsearch']['plugin_dir']}", 'cloud-aws'))}
end

service service_name do
    supports :status => true,:stop => true, :restart => true
    action [:enable,:start]
end
