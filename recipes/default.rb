#
# Cookbook Name:: ping-server
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'nginx'
template '/etc/nginx/conf.d/ping-web.conf' do
  source 'ping-web.conf.erb'
end

include_recipe 'nodejs'
execute 'npm upgrade' do
  command 'npm -g install npm@latest'
end

include_recipe 'redis::install_from_package'
