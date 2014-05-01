# encoding: utf-8
#
# Cookbook Name:: dvwa
# Recipe:: postgresql
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

include_recipe "dvwa::setup_db"
