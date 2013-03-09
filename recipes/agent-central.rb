#
# Cookbook Name:: ceilometer
# Recipe:: agent-central
#
# Copyright (C) 2013 Jordan Tardif
# 
# All rights reserved - Do Not Redistribute
#
#
include_recipe "ceilometer"

cookbook_file "/etc/init/ceilometer-agent-central.conf" do
  source "ceilometer-agent-central-upstart.conf"
  mode "0644"
end

service "ceilometer-agent-central" do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true
  action :enable
end        
