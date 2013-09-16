#
# Cookbook Name:: elasticsearch
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

## jdk1.7
jdk17 = "jdk-7u25-linux-x64.rpm"

cookbook_file "/tmp/#{jdk17}" do
  source "#{jdk17}"
end

package "jdk17" do
  action :install
  provider Chef::Provider::Package::Rpm
  source "/tmp/#{jdk17}"
end

## set JAVA_HOME

java_home = "/usr/java/default"

ruby_block  "set-env-java-home" do
  block do
    ENV["JAVA_HOME"] = java_home
  end
end

file "/etc/profile.d/jdk.sh" do
  content <<-EOS
    export JAVA_HOME=#{java_home}
  EOS
  mode 0755
end

es = "elasticsearch-0.90.3.noarch.rpm"

# cookbook_file : files/default配下のファイルを扱う
cookbook_file "/tmp/#{es}" do
  # ファイル名を変更する場合
  source "#{es}"
end

package "elasticsearch" do
  action :install
  provider Chef::Provider::Package::Rpm
  source "/tmp/#{es}"
end

service "elasticsearch" do
  action [ :enable, :start ]
end
