# encoding: utf-8
#
# Cookbook Name:: dvwa
# Recipe:: setup_db
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

if node["dvwa"]["db"]["use_psql"]
  filename = "dvwa-pg.sql"
  provider = Chef::Provider::Database::Postgresql
  connection_info = {
    :host => "localhost",
    :port => node["dvwa"]["db"]["port"],
    :username => "postgres",
    :password => node["postgresql"]["password"]["postgres"]
  }
else
  filename = "dvwa-my.sql"
  provider = Chef::Provider::Database::Mysql
  connection_info = {
    :host => "localhost",
    :username => "root",
    :password => node["mysql"]["server_root_password"]
  }
end

directory node["dvwa"]["path"] + "/sql" do
  owner "root"
  group "root"
  mode  "0700"
  action :create
end

cookbook_file node["dvwa"]["path"] + "/sql/" + filename do
  source filename
  cookbook "dvwa"
end

database "Setup database (#{@provider})" do
  connection connection_info
  database_name node["dvwa"]["db"]["name"]
  provider provider
  sql { ::File.open(node["dvwa"]["path"] + "/sql/" + filename).read }
  action :query
end

directory node["dvwa"]["path"] + "/sql" do
  action :delete
  recursive true
end
