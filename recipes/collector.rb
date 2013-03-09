#
# Cookbook Name:: ceilometer
# Recipe:: collector
#
# Copyright (C) 2013 Jordan Tardif
# 
# All rights reserved - Do Not Redistribute
#
#
include_recipe "ceilometer"

cookbook_file "/etc/init/ceilometer-collector.conf" do
  source "ceilometer-collector-upstart.conf"
  mode "0644"
end

service "ceilometer-collector" do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true
  action [ :enable ]
end        
