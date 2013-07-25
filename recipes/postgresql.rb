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
# Recipe:: postgresql
#

include_recipe "postgresql::server"
include_recipe "postgresql::client"
include_recipe "database"
include_recipe "postgresql::ruby"
include_recipe "php::module_pgsql"

psql_connection_info = {
  :host => "localhost",
  :port => node["dvwa"]["db"]["port"],
  :username => "postgres",
  :password => node["postgresql"]["password"]["postgres"]
}

postgresql_database_user node["dvwa"]["db"]["username"] do
  connection psql_connection_info
  password node["dvwa"]["db"]["password"]
  action :create
end

postgresql_database node["dvwa"]["db"]["name"] do
  connection psql_connection_info
  template 'DEFAULT'
  encoding 'DEFAULT'
  tablespace 'DEFAULT'
  connection_limit '-1'
  owner node["dvwa"]["db"]["username"]
  action :create
end
