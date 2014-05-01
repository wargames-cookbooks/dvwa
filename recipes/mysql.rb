# encoding: utf-8
#
# Cookbook Name:: dvwa
# Recipe:: mysql
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
