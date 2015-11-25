#
# Cookbook Name:: arti_wrapper
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

#include_recipe 'java'

user node['artifactory']['user'] do
  home node['artifactory']['home']
end

directory '/vol/artifactory' do
  owner 'artifactory'
  group 'artifactory'
  mode '0755'
  recursive true
  action :create
end

include_recipe 'apt'
include_recipe 'java'
include_recipe 'artifactory'
