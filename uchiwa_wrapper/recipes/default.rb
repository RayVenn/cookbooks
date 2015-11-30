#
# Cookbook Name:: uchiwa_wrapper
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

template "/etc/default/uchiwa" do
    source "uchiwa.default.erb"
end

include_recipe "uchiwa::default"
