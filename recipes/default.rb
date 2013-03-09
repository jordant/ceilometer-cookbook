#
# Cookbook Name:: ceilometer
# Recipe:: default
#
# Copyright (C) 2013 Jordan Tardif
# 
# All rights reserved - Do Not Redistribute
include_recipe "apt"
include_recipe "osops-utils::repo"
include_recipe "osops-utils"

group node["ceilometer"]["group"] do
  action :create
end

user node["ceilometer"]["user"] do
  comment "Ceilometer"
  gid node["ceilometer"]["group"]
  home node["ceilometer"]["docroot"]
  system true
  shell "/bin/false"
  action :create
end

package "ceilometer" do
  action :upgrade
end

directory "/etc/ceilometer" do
  action :create
  owner node["ceilometer"]["user"]
  group node["ceilometer"]["group"]
  mode "0755"
end

directory "/var/cache/ceilometer" do
  action :create
  owner node["ceilometer"]["user"]
  group node["ceilometer"]["group"]
  mode "0755"
end

%w{pipeline.yaml policy.json sources.json }.each do |file|
  cookbook_file "/etc/ceilometer/#{file}" do
    source "#{file}"
    owner node["ceilometer"]["user"]
    group node["ceilometer"]["group"]
    mode "0644"
  end
end

execute "chowndocroot" do
  command "chown #{node["ceilometer"]["user"]}.#{node["ceilometer"]["group"]} #{node["ceilometer"]["docroot"]} -R"
  action :run
end



ks_admin_endpoint = get_access_endpoint("keystone", "keystone", "admin-api")
rabbit_ip = IPManagement.get_ips_for_role("rabbitmq-server", "nova", node)[0]
Chef::Log.debug("URI #{ks_admin_endpoint["uri"]}")

template "/etc/ceilometer/ceilometer.conf" do
  source "ceilometer.conf.erb"
  owner node["ceilometer"]["user"]
  group node["ceilometer"]["group"]
  mode "0644"
  variables(
    :auth_uri => ks_admin_endpoint["uri"],
    :auth_host => ks_admin_endpoint["host"],
    :verbose => node["ceilometer"]["verbose"],
    :rabbit_ip => rabbit_ip,
    :tenant_name => node["ceilometer"]["tenant_name"],
    :os_username => node["ceilometer"]["os_username"],
    :os_password => node["ceilometer"]["os_password"],
    :auth_protocol => node["ceilometer"]["auth_protocol"]
  )
end
