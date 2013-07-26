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
# Recipe:: mysql
#

include_recipe "mysql::server"
include_recipe "mysql::client"
include_recipe "database"
include_recipe "mysql::ruby"
include_recipe "php::module_mysql"

mysql_connection_info = {
  :host => "localhost",
  :username => "root",
  :password => node["mysql"]["server_root_password"]
}

mysql_database_user node["dvwa"]["db"]["username"] do
  connection mysql_connection_info
  password node["dvwa"]["db"]["password"]
  database_name node["dvwa"]["db"]["name"]
  privileges [:select,:update,:insert,:create,:delete,:drop]
  action :grant
end

mysql_database node["dvwa"]["db"]["name"] do
  connection mysql_connection_info
  action :create
end

include_recipe "dvwa::setup_db"
