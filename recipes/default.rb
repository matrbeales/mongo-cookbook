#
# Cookbook:: mongo
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.
include_recipe("apt")
apt_update("update") do
  action :update
end

apt_repository("mongodb-org") do
  uri "http://repo.mongodb.org/apt/ubuntu"
  distribution "xenial/mongodb-org/3.2"
  components ["multiverse"]
  keyserver "hkp://keyserver.ubuntu.com:80"
  key "EA312927"
end

package("mongodb-org") do
  action :upgrade
end

service("mongod") do
  action [:enable, :start]
end

template "/etc/mongod.conf" do
  source "mongod.conf.erb"
  variables proxy_port: node["mongodb"]["proxy_port"]
  notifies :restart, "service[mongod]"
end
