# Cookbook Name:: kafka-manager_wrapper
# Recipe:: stop
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'kafka-manager_wrapper::stop'

directory 'remove' do
    recursive true
    path '/opt/kafka-manager'
    action :delete
end
