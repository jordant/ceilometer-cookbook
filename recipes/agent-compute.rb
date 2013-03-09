#
# Cookbook Name:: ceilometer
# Recipe:: agent-compute
#
# Copyright (C) 2013 Jordan Tardif
# 
# All rights reserved - Do Not Redistribute
#
#
include_recipe "ceilometer"

cookbook_file "/etc/init/ceilometer-agent-compute.conf" do
  source "ceilometer-agent-compute-upstart.conf"
  mode "0644"
end

service "ceilometer-agent-compute" do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true
  action :enable
end        
