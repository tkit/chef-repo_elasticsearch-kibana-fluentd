#
# Cookbook Name:: fluentd
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

cookbook_file "/etc/security/limits.d/fluentd_limits.conf" do
  source "fluentd_limits.conf"
end

template "/etc/sysctl.conf" do
  source "sysctl.conf.erb"
end

bash "fluentd_repo" do
  code <<-EOL
   curl -L http://toolbelt.treasure-data.com/sh/install-redhat.sh | sh 
  EOL
  not_if {File.exist?("/usr/sbin/td-agent")}
end

package "td-agent" do
  action :install
end

gem_package "fluent-plugin-elasticsearch" do
  gem_binary("/usr/lib64/fluent/ruby/bin/fluent-gem")
  action :install
end

template "/etc/td-agent/td-agent.conf" do
  source "td-agent.conf.erb"
  notifies :restart, 'service[td-agent]', :delayed
end

file "#{node['fluentd']['source-config']['pos_file']}" do
  owner "root"
  group "root"
  mode 00777
  action :create
end

service "td-agent" do
  action [:start , :enable]
end

