# -*- coding: utf-8 -*-

require 'spec_helper'

describe 'dvwa::default' do
  before do
    stub_command('/usr/sbin/apache2 -t').and_return(true)
    stub_command('ls /recovery.conf').and_return(true)
  end

  context 'with postgresql' do
    let(:subject) do
      ChefSpec::SoloRunner.new(file_cache_path: '/var/chef/cache',
                               step_into: ['dvwa_db']) do |node|
        node.set['dvwa']['version'] = '2'
        node.set['dvwa']['path'] = '/opt/dvwa-app'
        node.set['dvwa']['security_level'] = 'low'
        node.set['dvwa']['recaptcha']['public_key'] = 'recap_pubkey'
        node.set['dvwa']['recaptcha']['private_key'] = 'recap_private_key'
        node.set['dvwa']['db']['use_pgsql'] = true
        node.set['dvwa']['db']['server'] = '127.0.0.1'
        node.set['dvwa']['db']['port'] = 1337
        node.set['dvwa']['db']['name'] = 'dvwadb'
        node.set['dvwa']['db']['username'] = 'dvwauser'
        node.set['dvwa']['db']['password'] = 'dvwapass'
        node.set['postgresql']['password']['postgres'] = 'foobar'
        node.set['postgresql']['config'] = {}
      end.converge(described_recipe)
    end

    it 'should include required recipes for webapp' do
      expect(subject).to include_recipe('apache2')
      expect(subject).to include_recipe('php')
      expect(subject).to include_recipe('apache2::mod_php5')
    end

    it 'should download dvwa archive' do
      expect(subject).to create_remote_file('/var/chef/cache/dvwa.tar.gz')
        .with(source: 'https://github.com/RandomStorm/DVWA/archive/2.tar.gz')
    end

    it 'should create directory for dvwa application' do
      expect(subject).to create_directory('/opt/dvwa-app')
        .with(recursive: true)
    end

    it 'should untar dvwa archive in created directory' do
      expect(subject).to run_execute('untar-dvwa')
        .with(cwd: '/opt/dvwa-app',
              command: 'tar --strip-components 1 -xzf '\
                       '/var/chef/cache/dvwa.tar.gz')
    end

    it 'should create config file from template' do
      config_file = '/opt/dvwa-app/config/config.inc.php'
      matches = [/^\$DBMS = 'PGSQL';$/,
                 /^\$_DVWA\['db_server'\] = '127.0.0.1';$/,
                 /^\$_DVWA\['db_port'\] = '1337';$/,
                 /^\$_DVWA\['db_database'\] = 'dvwadb';$/,
                 /^\$_DVWA\['db_user'\] = 'dvwauser';$/,
                 /^\$_DVWA\['db_password'\] = 'dvwapass';$/,
                 /^\$_DVWA\['recaptcha_public_key'\] = "recap_pubkey";$/,
                 /^\$_DVWA\['recaptcha_private_key'\] = "recap_private_key";$/,
                 /^\$_DVWA\['default_security_level'\] = "low";$/]

      expect(subject).to create_template(config_file)
        .with(source: 'config.inc.php.erb')

      matches.each do |m|
        expect(subject).to render_file(config_file).with_content(m)
      end
    end

    it 'should create missing tmp directory for phpids plugin' do
      expect(subject).to create_directory(
        '/opt/dvwa-app/external/phpids/0.6/lib/IDS/tmp').with(owner: 'www-data',
                                                              group: 'www-data',
                                                              recursive: true)
    end

    it 'should create sql directory' do
      expect(subject).to create_directory('create-sql-dir')
        .with(mode: '0700',
              path: '/opt/dvwa-app/sql')
    end

    it 'should copy cookbook file that contains sql queries' do
      expect(subject).to create_cookbook_file('/opt/dvwa-app/sql/dvwa-pg.sql')
        .with(source: 'dvwa-pg.sql')
    end

    it 'should setup dvwa database' do
      expect(subject).to create_dvwa_db('dvwadb')
        .with(pgsql: true,
              server: '127.0.0.1',
              port: 1337,
              username: 'dvwauser',
              password: 'dvwapass',
              dvwa_path: '/opt/dvwa-app')
    end

    it 'should include module_pgsql recipe of php cookbook' do
      expect(subject).to include_recipe('php::module_pgsql')
    end

    it 'should create pgsql user' do
      expect(subject).to create_postgresql_database_user('dvwauser')
        .with(password: 'dvwapass',
              connection: { host: '127.0.0.1',
                            port: 1337,
                            username: 'postgres',
                            password: 'foobar' })
    end

    it 'should drop pgsql database' do
      expect(subject).to drop_postgresql_database('drop-dvwa-db')
        .with(database_name: 'dvwadb',
              connection: { host: '127.0.0.1',
                            port: 1337,
                            username: 'postgres',
                            password: 'foobar' })
    end

    it 'should create pgsql database' do
      expect(subject).to create_postgresql_database('create-dvwa-db')
        .with(template: 'DEFAULT',
              encoding: 'DEFAULT',
              tablespace: 'DEFAULT',
              connection_limit: '-1',
              database_name: 'dvwadb',
              owner: 'dvwauser',
              connection: { host: '127.0.0.1',
                            port: 1337,
                            username: 'postgres',
                            password: 'foobar' })
    end
  end

  context 'with mysql' do
    let(:subject) do
      ChefSpec::SoloRunner.new(file_cache_path: '/var/chef/cache',
                               step_into: ['dvwa_db']) do |node|
        node.set['dvwa']['path'] = '/opt/dvwa-app'
        node.set['dvwa']['security_level'] = 'low'
        node.set['dvwa']['recaptcha']['public_key'] = 'recap_pubkey'
        node.set['dvwa']['recaptcha']['private_key'] = 'recap_private_key'
        node.set['dvwa']['db']['use_pgsql'] = false
        node.set['dvwa']['db']['server'] = '127.0.0.1'
        node.set['dvwa']['db']['port'] = 1337
        node.set['dvwa']['db']['name'] = 'dvwadb'
        node.set['dvwa']['db']['username'] = 'dvwauser'
        node.set['dvwa']['db']['password'] = 'dvwapass'
      end.converge(described_recipe)
    end

    it 'should install mysql2 gem package' do
      expect(subject).to install_mysql2_chef_gem('default')
    end

    it 'should create config file from template' do
      config_file = '/opt/dvwa-app/config/config.inc.php'
      matches = [/^\$DBMS = 'MySQL';$/,
                 /^\$_DVWA\['db_server'\] = '127.0.0.1';$/,
                 /^\$_DVWA\['db_port'\] = '1337';$/,
                 /^\$_DVWA\['db_database'\] = 'dvwadb';$/,
                 /^\$_DVWA\['db_user'\] = 'dvwauser';$/,
                 /^\$_DVWA\['db_password'\] = 'dvwapass';$/,
                 /^\$_DVWA\['recaptcha_public_key'\] = "recap_pubkey";$/,
                 /^\$_DVWA\['recaptcha_private_key'\] = "recap_private_key";$/,
                 /^\$_DVWA\['default_security_level'\] = "low";$/]

      expect(subject).to create_template(config_file)
        .with(source: 'config.inc.php.erb')

      matches.each do |m|
        expect(subject).to render_file(config_file).with_content(m)
      end
    end

    it 'should setup dvwa database' do
      expect(subject).to create_dvwa_db('dvwadb')
        .with(pgsql: false,
              server: '127.0.0.1',
              port: 1337,
              username: 'dvwauser',
              password: 'dvwapass')
    end

    it 'should install mysql2 gem package' do
      expect(subject).to install_mysql2_chef_gem('default')
    end

    it 'should include module_mysql recipe of php cookbook' do
      expect(subject).to include_recipe('php::module_mysql')
    end

    it 'should setup mysql service' do
      expect(subject).to create_mysql_service('default')
        .with(port: '3306',
              version: '5.5',
              initial_root_password: 'toor')
    end

    it 'should create database user' do
      expect(subject).to grant_mysql_database_user('dvwauser')
        .with(password: 'dvwapass',
              database_name: 'dvwadb',
              privileges: [:select, :update, :insert, :create, :delete, :drop],
              connection: { host: '127.0.0.1',
                            username: 'root',
                            password: 'toor',
                            socket: '/run/mysql-default/mysqld.sock' })
    end

    it 'should drop mysql database' do
      expect(subject).to drop_mysql_database('drop-dvwa-db')
        .with(database_name: 'dvwadb',
              connection: { host: '127.0.0.1',
                            username: 'root',
                            password: 'toor',
                            socket: '/run/mysql-default/mysqld.sock' })
    end

    it 'should create mysql database' do
      expect(subject).to create_mysql_database('create-dvwa-db')
        .with(database_name: 'dvwadb',
              connection: { host: '127.0.0.1',
                            username: 'root',
                            password: 'toor',
                            socket: '/run/mysql-default/mysqld.sock' })
    end

    it 'should copy cookbook file that contains sql queries' do
      expect(subject).to create_cookbook_file('/opt/dvwa-app/sql/dvwa-my.sql')
        .with(source: 'dvwa-my.sql')
    end

    it 'should populate vicnum database with mysql dump' do
      expect(subject).to run_execute('import-mysql-dump')
        .with(command: 'mysql -h 127.0.0.1 -u root -ptoor '\
                       '--socket /run/mysql-default/mysqld.sock '\
                       'dvwadb < /opt/dvwa-app/sql/dvwa-my.sql')
    end

    it 'should create symblink for mysql socket'\
       ', can\'t configure socket in dvwa..' do
      expect(subject).to create_link('/run/mysqld/mysqld.sock')
        .with(link_type: :symbolic,
              to: '/run/mysql-default/mysqld.sock')
    end
  end
end
