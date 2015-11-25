#
# Cookbook Name:: flume_wrapper
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# This is for testing
package "git"
include_recipe 'apt'
include_recipe 'maven'
include_recipe 'java'

#Getting the kafka and zookeeper nodes
if node.environment == "qa"
    zknodes = search(:node,"role:zk AND chef_environment:qa")
    kafkanodes = search(:node,"role:kafka AND chef_environment:qa")
elsif node.environment == "production"
    zknodes = search(:node,"role:zk AND chef_environment:production")
    kafkanodes = search(:node,"role:kafka AND chef_environment:production")
else
    zknodes = search(:node,"role:zk AND chef_environment:dev")
    kafkanodes = search(:node,"role:kafka AND chef_environment:dev")
end

zk_connect = ""
zknodes.each do |node|
    zk_connect = zk_connect + "#{node["ipaddress"]}:2181," 
    Chef::Log.info("#{node["name"]} has ip add #{node["ipaddress"]}")
end
zk_connect = zk_connect.chomp(',')
Chef::Log.info("THIS. IS. ZK "+zk_connect)


kafka_connect = ""
kafkanodes.each do |node|
    kafka_connect = kafka_connect + "#{node["ipaddress"]}:9092,"
    Chef::Log.info("#{node["name"]} has ip add #{node["ipaddress"]}")
end
kafka_connect = kafka_connect.chomp(',')
Chef::Log.info("THIS. IS. KAFKA "+kafka_connect)


#Setting the flume attributes
node.default["flume"]["archiveUrl"] = "http://archive.apache.org/dist/flume/1.6.0/apache-flume-1.6.0-bin.tar.gz"
node.default["flume"]["baseDir"] = "/vol/flume"

#Getting the git user from repo
#git_user  = data_bag_item('repo_user','repo_user')
token   = '258575ce51a5c697daf5efb4d3569fdb71db9a49'

#Setting the other variables
deploy_key_name = "flume_config"
path = "/vol/workspace"
image_folder = "/flume_config"
final_path = path+image_folder
app_name = "flume_config"
ssh_path = "/home/vagrant/.ssh"

directory "#{final_path}" do
    owner 'root'
    group 'root'
    mode '0644'
    action :create
    recursive true
end

#Creating deploy key for the repo
deploy_key deploy_key_name do
    provider Chef::Provider::DeployKeyGithub
    path ssh_path
    credentials({
        :token => token
    })
    repo 'Max2Inc/flume_config'
    owner 'root'
    group 'root'
    mode '0400'
    action :add
end

#Creating wrapper for using deploy key
file "/root/git_wrapper.sh" do
  owner "root"
  mode "0755"
  content "#!/bin/sh\nexec /usr/bin/ssh -o \"StrictHostKeyChecking=no\" -i #{ssh_path}/#{deploy_key_name} \"$@\""
end

#Cloning the repo
git "#{final_path}" do
    repository "git@github.com:Max2Inc/#{app_name}.git"
    revision "master"
    ssh_wrapper "/root/git_wrapper.sh"
    action :sync
    notifies :run, "bash[package_flume_config]", :immediately
end

#Setting the java_home variable because the flume agent resource requires it
ENV['JAVA_HOME'] = `printf %s "$(readlink -f /usr/bin/javac | sed \"s:bin/javac::\")"`

#Building the project
bash 'package_flume_config' do
    cwd "#{final_path}/AvroSerializer"
    action :nothing
    code <<-EOH
    mvn clean && mvn package
    EOH
    #notifies :create, "flume_agent[applogs]", :immediately
end

flume_user = "flume"
flume_group = "flume"


for topic in [ "AppLogs", "Ask", "Collection", "Employment", "Endorse", "ExternalDeal", "ExternalEvent", "Give", "Merchant", "MerchantDeal", "Notification", "Organization", "Queue", "QueueMember", "Team", "UserInterest", "UserNotification", "Restaurants", "Plan", "Places", "Hotels" ] do
    #Configuring the flume agent
    flume_agent topic.downcase do
        action :create
        userName flume_user
        userGroup flume_group
        agentName topic.downcase

        flumeEnv do
            cookbook_filename "flume-env.sh.erb"
        end

        configFile do
            cookbook_filename "generic.conf.erb"
            variables({
                :zk_connect => zk_connect,
                :kafka_connect => kafka_connect,
                :environment => node.environment,
                :schema_repo => "registry.max2.com",
                :topic_name => topic.downcase,
                :topic => topic
            })
        end
        notifies :run, "bash[transfer_avro_jars_#{topic}]", :immediately
    end

    # variables for updated template
    instanceName = topic.downcase
    installDir = "#{node["flume"]["baseDir"]}/#{instanceName}"
    serviceName = "flume_#{instanceName}"
    userName = flume_user
    outputConfigurationFile = "#{installDir}/conf/flume.agent.#{instanceName}.properties"
    postStartupScript = ""

    template "/etc/init.d/flume_#{topic.downcase}" do
        action :create
        source "flume-agent.sh.erb"
        mode '0755'
        owner flume_user
        group flume_group
        variables({
            :instanceName => instanceName,
            :installDir => installDir,
            :serviceName => serviceName,
            :userName => userName,
            :outputConfigurationFile => outputConfigurationFile,
            :postStartupScript => postStartupScript
        })
    end

    #Transferring the jars to a flume agent
    bash "transfer_avro_jars_#{topic}" do
        cwd "#{final_path}/AvroSerializer/target"
        action :run
        code <<-EOH
        cp *.jar #{node["flume"]["baseDir"]}/#{topic.downcase}/lib
        EOH
    end

end

