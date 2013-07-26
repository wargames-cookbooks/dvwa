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
# Recipe:: setup_db
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
