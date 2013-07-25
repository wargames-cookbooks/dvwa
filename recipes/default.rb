# This source file is part of DVWA's chef cookbook.
#
# DVWA's chef cookbook is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# DVWA's chef cookbook is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with DVWA's chef cookbook. If not, see <http://www.gnu.org/licenses/gpl-3.0.html>.
#
# Cookbook Name:: dvwa
# Recipe:: default
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

dvwa_http_post "127.0.0.1" do
  data "create_db=Create+%2F+Reset+Database"
  uri "/setup.php"
end
