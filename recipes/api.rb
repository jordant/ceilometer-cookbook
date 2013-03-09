#
# Cookbook Name:: ceilometer
# Recipe:: api
#
# Copyright (C) 2013 Jordan Tardif
# 
# All rights reserved - Do Not Redistribute
#
#
include_recipe "ceilometer"
include_recipe "apache2"
include_recipe "apache2::mod_ssl"
include_recipe "apache2::mod_wsgi"
include_recipe "mongodb"

template "#{node['ceilometer']['docroot']}/app.wsgi" do
  source "ceilometer-api-app.wsgi.erb"
  owner node["ceilometer"]["user"]
  group node["ceilometer"]["group"]
  mode  "0755"
end

template "/etc/ceilometer/api_config.py" do
  source "ceilometer-api-config.py.erb"
  owner node["ceilometer"]["user"]
  group node["ceilometer"]["group"]
  mode  "0755"
end

apache_module "ssl" do
  conf true
end

apache_site "000-default" do
  enable false
end

template "#{node['apache']['dir']}/sites-available/ceilometer-api" do
  source "ceilometer-api-vhost.erb"
end

%w{key crt int}.each do |type|
  file "#{node['apache']['dir']}/ssl/ceilometer-api.#{type}" do
    owner "root"
    group "root"
    mode "600"
    content node['apache2']['ssl'][type]
  end
end

apache_site "ceilometer-api" do
  enable true
  notifies :reload, resources(:service => "apache2")
end        
