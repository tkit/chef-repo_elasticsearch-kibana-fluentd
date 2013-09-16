#
# Cookbook Name:: starterkit
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# iptables off
service "iptables" do
  action [:disable, :stop]
end

%w{vim-enhanced yum-utils git}.each do |pkgs|
  package pkgs do
    action :install
  end
end

cookbook_file "/root/.vimrc" do
  source "vimrc"
end

git "/usr/local/rbenv" do
  repository "https://github.com/sstephenson/rbenv.git"
  action :sync
end

directory "/usr/local/rbenv/plugins" do
  action :create
  owner "root"
  group "root"
  mode 00755
end

git "/usr/local/rbenv/plugins/ruby-build" do
  repository "https://github.com/sstephenson/ruby-build.git"
  action :sync
end

rbenv_root = "/usr/local/rbenv"

ruby_block  "set-env-rbenv" do
  not_if {ENV["PATH"].include?(rbenv_root)}
  block do
    ENV["RBENV_ROOT"] = rbenv_root
    tmppath = ENV["RBENV_ROOT"] + "/bin:" + ENV["PATH"]  
    ENV["PATH"] = tmppath
  end
end

file "/etc/profile.d/rbenv.sh" do
  content <<-EOS
    export RBENV_ROOT="#{rbenv_root}"
    export PATH="#{rbenv_root}/bin:$PATH"
    eval "$(rbenv init -)"
  EOS
  mode 0755
end

bash "ruby_install" do
  not_if "test \"`rbenv version | cut -d' ' -f1`\" = \"#{node['ruby']['version']}\""
  action :run
  user "root"
  code <<-EOH
    rbenv install #{node['ruby']['version']}
    rbenv global #{node['ruby']['version']}
    rbenv rehash
  EOH
end

