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

%w{bundler eventmachine}.each do |gempkgs|  
  gem_package gempkgs do
    action :install
  end
end

git "/usr/share/kibana" do
  repository "https://github.com/rashidkpc/Kibana.git"
  action :sync
end

bash 'kibana_bundle_install' do
  cwd "/usr/share/kibana"
  code 'bundle install'
end

template "/usr/share/kibana/KibanaConfig.rb" do
  source "KibanaConfig.rb.erb"
end

directory "/usr/share/kibana/tmp" do
  action :create
  owner "root"
  group "root"
  mode 00644
end

cookbook_file "/etc/init.d/kibana" do
  source "kibana"
  action :create_if_missing
  mode 00755
end

bash "add_kibana_service" do
  code <<-EOL
    chkconfig --add kibana
  EOL
end

service "kibana" do
  action [:start, :enable]
end

