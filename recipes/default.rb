# -*- coding: utf-8 -*-
#
# Cookbook Name:: dvwa
# Recipe:: default
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'apache2'
include_recipe 'php'
include_recipe 'apache2::mod_php5'

# Apache2 configuration
apache_site 'default' do
  enable false
end

web_app 'dvwa' do
  cookbook 'dvwa'
  enable true
  docroot node['dvwa']['path']
  server_name node['dvwa']['apache2']['server_name']
  server_aliases node['dvwa']['apache2']['server_aliases']
end

dvwa_archive_url = 'https://github.com/RandomStorm/DVWA/archive/'
dvwa_local = "#{Chef::Config[:file_cache_path]}/dvwa.tar.gz"

remote_file dvwa_local do
  source "#{dvwa_archive_url}#{node['dvwa']['version']}.tar.gz"
end

directory node['dvwa']['path'] do
  recursive true
end

execute 'untar-dvwa' do
  cwd node['dvwa']['path']
  command "tar --strip-components 1 -xzf #{dvwa_local}"
end

template "#{node['dvwa']['path']}/config/config.inc.php" do
  source 'config.inc.php.erb'
  variables db: node['dvwa']['db'],
            recaptcha: node['dvwa']['recaptcha'],
            security_level: node['dvwa']['security_level']
end

directory "#{node['dvwa']['path']}/external/phpids/0.6/lib/IDS/tmp" do
  owner 'www-data'
  group 'www-data'
  recursive true
end

dvwa_db node['dvwa']['db']['name'] do
  pgsql node['dvwa']['db']['use_pgsql']
  server node['dvwa']['db']['server']
  port node['dvwa']['db']['port']
  username node['dvwa']['db']['username']
  password node['dvwa']['db']['password']
  dvwa_path node['dvwa']['path']
end
