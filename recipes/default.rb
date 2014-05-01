# encoding: utf-8
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

include_recipe "apache2"
include_recipe "php"
include_recipe "apache2::mod_php5"

# Apache2 configuration
apache_site "default" do
    enable false
end

web_app "dvwa" do
  cookbook "dvwa"
  enable true
  docroot node["dvwa"]["path"]
  server_name node["dvwa"]["apache2"]["server_name"]
  server_aliases node["dvwa"]["apache2"]["server_aliases"]
end

# DVWA Installation
dvwa_dl_url = "https://github.com/RandomStorm/DVWA/archive/" + node["dvwa"]["version"] + ".tar.gz"
dvwa_local = Chef::Config[:file_cache_path] + "/dvwa-" + node["dvwa"]["version"] + ".tar.gz"

remote_file dvwa_local do
  source dvwa_dl_url
  mode "0644"
end

directory node["dvwa"]["path"] do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

execute "untar-dvwa" do
  cwd node['dvwa']['path']
  command "tar --strip-components 1 -xzf " + dvwa_local
end

template node['dvwa']['path'] + '/config/config.inc.php' do
  source 'config.inc.php.erb'
  mode 0644
  owner 'root'
  group 'root'
  variables(
            :server => 'localhost',
            :dbms   => (node["dvwa"]["db"]["use_psql"]) ? 'PGSQL' : 'MySQL',
            :dbname => node["dvwa"]["db"]["name"],
            :dbuser => node["dvwa"]["db"]["username"],
            :dbpass => node["dvwa"]["db"]["password"],
            :dbport => node["dvwa"]["db"]["port"],
            :security_level => node["dvwa"]["security_level"],
            :rc_public_key => node["dvwa"]["recaptcha"]["public_key"],
            :rc_private_key => node["dvwa"]["recaptcha"]["private_key"])
end

directory node["dvwa"]["path"] + "/external/phpids/0.6/lib/IDS/tmp" do
  owner "www-data"
  group "www-data"
  mode "0755"
  recursive true
end

# Database configuration
if node["dvwa"]["db"]["use_psql"]
  include_recipe "dvwa::postgresql"
else
  include_recipe "dvwa::mysql"
end
