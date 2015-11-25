# Cookbook Name:: kafka-manager_wrapper
# Recipe:: stop
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

procs = 'kafka-manager'

bash 'check_process' do
    cwd '/opt'
    code <<-EOH
    pid=$(pgrep "kafka-manager" -f)
    if [ -n "${pid}" ]
    then
        kill -9 ${pid}
    fi
    EOH
end
