# -*- coding: utf-8 -*-
#
# Cookbook Name:: dvwa
# Provider:: db
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

include Chef::DSL::IncludeRecipe

action :create do
  connection_info = { host: new_resource.server }

  if new_resource.pgsql
    filename = 'dvwa-pg.sql'
    provider = Chef::Provider::Database::Postgresql
    connection_info[:port] = new_resource.port
    connection_info[:username] = 'postgres'
    connection_info[:password] = node['postgresql']['password']['postgres']

    include_recipe 'php::module_pgsql'

    postgresql_database_user new_resource.username do
      connection connection_info
      password new_resource.password
    end

    postgresql_database new_resource.name do
      connection connection_info
      template 'DEFAULT'
      encoding 'DEFAULT'
      tablespace 'DEFAULT'
      connection_limit '-1'
      owner new_resource.username
    end
  else
    filename = 'dvwa-my.sql'
    provider = Chef::Provider::Database::Mysql
    connection_info[:username] = 'root'
    connection_info[:password] = 'toor'

    include_recipe 'php::module_mysql'

    mysql_service 'default' do
      port '3306'
      version '5.5'
      initial_root_password 'toor'
      action [:create, :start]
    end

    mysql_database_user new_resource.username do
      connection connection_info
      password new_resource.password
      database_name new_resource.name
      privileges [:select, :update, :insert, :create, :delete, :drop]
      action :grant
    end

    mysql_database new_resource.name do
      connection connection_info
      action :create
    end
  end

  directory 'create-sql-dir' do
    path "#{new_resource.dvwa_path}/sql"
    mode '0700'
  end

  cookbook_file "#{new_resource.dvwa_path}/sql/#{filename}" do
    source filename
  end

  sql_server_database "Setup database (#{provider})" do
    connection connection_info
    database_name new_resource.name
    provider provider
    sql { ::File.open("#{new_resource.dvwa_path}/sql/#{filename}").read }
    action :query
  end

  directory 'remove-sql-dir' do
    path "#{new_resource.dvwa_path}/sql"
    action :delete
  end

  new_resource.updated_by_last_action(true)
end
