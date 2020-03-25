# -*- coding: utf-8 -*-
#
# Cookbook:: dvwa
# Resource:: db
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

resource_name :dvwa_db
default_action :create

property :server, String
property :username, String
property :password, String
property :dvwa_path, String

action :create do
  directory 'create-sql-dir' do
    path "#{new_resource.dvwa_path}/sql"
    mode '0700'
  end

  cookbook_file "#{new_resource.dvwa_path}/sql/dvwa-my.sql" do
    source 'dvwa-my.sql'
  end

  package value_for_platform(
            default: 'php-mysql',
            ubuntu: { '<= 14.04' => 'php5-mysqlnd' })

  mariadb_server_install 'MariaDB Server' do
    setup_repo true
    version '10.3'
    password 'toor'
  end

  mariadb_server_configuration 'MariaDB Server Configuration' do
    version '10.3'
    mysqld_bind_address new_resource.server
    mysqld_port 3306
  end

  mariadb_database 'drop-dvwa-db' do
    database_name new_resource.name
    action :drop
  end

  mariadb_database new_resource.name do
    action :create
    host new_resource.server
  end

  mariadb_user new_resource.username do
    action [:create, :grant]
    password new_resource.password
    database_name new_resource.name
    privileges [:all]
    host '%'
  end

  execute 'import-mysql-dump' do
    command 'mysql -h 127.0.0.1 '\
            "-u #{new_resource.username} "\
            "-p#{new_resource.password} "\
            '--socket /run/mysql-default/mysqld.sock '\
            "#{new_resource.name} < #{new_resource.dvwa_path}/sql/dvwa-my.sql"
  end
end
