#
# Cookbook Name:: kibana
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w{ruby ruby-devel}.each do |rubypkgs|  
  package rubypkgs do
    action :install
  end
end

directory "/usr/local/Kibana" do
  action :create
  owner "root"
  group "root"
  mode 00644
end

%w{bundler eventmachine}.each do |gempkgs|  
  gem_package gempkgs do
    action :install
  end
end

git "/usr/local/Kibana" do
  repository "https://github.com/rashidkpc/Kibana.git"
  action :sync
end

bash 'kibana bundle install' do
  cwd "/usr/local/Kibana"
  code 'bundle install'
end

template "/usr/local/Kibana/KibanaConfig.rb" do
  source "KibanaConfig.rb.erb"
end

