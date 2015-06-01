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
  filename = new_resource.pgsql ? 'dvwa-pg.sql' : 'dvwa-my.sql'

  directory 'create-sql-dir' do
    path "#{new_resource.dvwa_path}/sql"
    mode '0700'
  end

  cookbook_file "#{new_resource.dvwa_path}/sql/#{filename}" do
    source filename
  end

  if new_resource.pgsql
    provider = Chef::Provider::Database::Postgresql
    connection_info[:port] = new_resource.port
    connection_info[:username] = 'postgres'
    connection_info[:password] = node['postgresql']['password']['postgres']

    include_recipe 'php::module_pgsql'

    postgresql_database 'drop-dvwa-db' do
      connection connection_info
      database_name new_resource.name
      action :drop
    end

    postgresql_database_user new_resource.username do
      connection connection_info
      password new_resource.password
    end

    postgresql_database 'create-dvwa-db' do
      connection connection_info
      template 'DEFAULT'
      encoding 'DEFAULT'
      tablespace 'DEFAULT'
      connection_limit '-1'
      database_name new_resource.name
      owner new_resource.username
    end

    database "Setup database (#{provider})" do
      connection connection_info
      database_name new_resource.name
      provider provider
      sql { ::File.open("#{new_resource.dvwa_path}/sql/#{filename}").read }
      action :query
    end
  else
    filename = 'dvwa-my.sql'
    provider = Chef::Provider::Database::Mysql
    connection_info[:username] = 'root'
    connection_info[:password] = 'toor'
    connection_info[:socket] = '/run/mysql-default/mysqld.sock'

    mysql2_chef_gem 'default'
    include_recipe 'php::module_mysql'

    mysql_service 'default' do
      port '3306'
      version '5.5'
      initial_root_password 'toor'
      action [:create, :start]
    end

    mysql_database 'drop-dvwa-db' do
      database_name new_resource.name
      connection connection_info
      action :drop
    end

    mysql_database_user new_resource.username do
      connection connection_info
      password new_resource.password
      database_name new_resource.name
      privileges [:select, :update, :insert, :create, :delete, :drop]
      action :grant
    end

    mysql_database 'create-dvwa-db' do
      connection connection_info
      database_name new_resource.name
      action :create
    end

    execute 'import-mysql-dump' do
      command "mysql -h #{connection_info[:host]} "\
              "-u #{connection_info[:username]} "\
              "-p#{connection_info[:password]} "\
              '--socket /run/mysql-default/mysqld.sock '\
              "#{new_resource.name} < #{new_resource.dvwa_path}/sql/#{filename}"
    end

    link '/run/mysqld/mysqld.sock' do
      link_type :symbolic
      to '/run/mysql-default/mysqld.sock'
    end
  end

  new_resource.updated_by_last_action(true)
end
