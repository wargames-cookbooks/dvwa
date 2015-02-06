# -*- coding: utf-8 -*-

require 'rspec/expectations'
require 'chefspec'
require 'chefspec/berkshelf'

ChefSpec::Coverage.start! { add_filter 'dvwa' }

require 'chef/application'

describe 'dvwa::default' do
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

    before do
      stub_command('/usr/sbin/apache2 -t').and_return(true)
      stub_command('ls /recovery.conf').and_return(true)
    end

    it 'does include required recipes for webapp' do
      expect(subject).to include_recipe('apache2')
      expect(subject).to include_recipe('php')
      expect(subject).to include_recipe('apache2::mod_php5')
    end

    it 'does download dvwa archive' do
      expect(subject).to create_remote_file('/var/chef/cache/dvwa.tar.gz')
        .with(source: 'https://github.com/RandomStorm/DVWA/archive/2.tar.gz')
    end

    it 'does create directory for dvwa application' do
      expect(subject).to create_directory('/opt/dvwa-app')
        .with(recursive: true)
    end

    it 'does untar dvwa archive in created directory' do
      expect(subject).to run_execute('untar-dvwa')
        .with(cwd: '/opt/dvwa-app',
              command: 'tar --strip-components 1 -xzf '\
                       '/var/chef/cache/dvwa.tar.gz')
    end

    it 'does create config file from template' do
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

    it 'does create missing tmp directory for phpids plugin' do
      expect(subject).to create_directory(
        '/opt/dvwa-app/external/phpids/0.6/lib/IDS/tmp').with(owner: 'www-data',
                                                              group: 'www-data',
                                                              recursive: true)
    end

    it 'does setup dvwa database' do
      expect(subject).to create_dvwa_db('dvwadb')
        .with(pgsql: true,
              server: '127.0.0.1',
              port: 1337,
              username: 'dvwauser',
              password: 'dvwapass',
              dvwa_path: '/opt/dvwa-app')
    end

    it 'does include module_pgsql recipe of php cookbook' do
      expect(subject).to include_recipe('php::module_pgsql')
    end

    it 'does create pgsql user' do
      expect(subject).to create_postgresql_database_user('dvwauser')
        .with(password: 'dvwapass',
              connection: { host: '127.0.0.1',
                            port: 1337,
                            username: 'postgres',
                            password: 'foobar' })
    end

    it 'does create pgsql database' do
      expect(subject).to create_postgresql_database('dvwadb')
        .with(template: 'DEFAULT',
              encoding: 'DEFAULT',
              tablespace: 'DEFAULT',
              connection_limit: '-1',
              owner: 'dvwauser',
              connection: { host: '127.0.0.1',
                            port: 1337,
                            username: 'postgres',
                            password: 'foobar' })
    end

    it 'does create temporary sql directory' do
      expect(subject).to create_directory('create-sql-dir')
        .with(mode: '0700',
              path: '/opt/dvwa-app/sql')
    end

    it 'does copy cookbook file that contains sql queries' do
      expect(subject).to create_cookbook_file('/opt/dvwa-app/sql/dvwa-pg.sql')
        .with(source: 'dvwa-pg.sql')
    end

    it 'does init dvwa database with sql queries' do
      expect(subject).to query_database(
        'Setup database (Chef::Provider::Database::Postgresql)')
        .with(database_name: 'dvwadb',
              provider: Chef::Provider::Database::Postgresql,
              connection: { host: '127.0.0.1',
                            port: 1337,
                            username: 'postgres',
                            password: 'foobar' })
    end

    it 'does remove temporary directory' do
      expect(subject).to delete_directory('remove-sql-dir')
        .with(path: '/opt/dvwa-app/sql')
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

    before do
      stub_command('/usr/sbin/apache2 -t').and_return(true)
      stub_command('ls /recovery.conf').and_return(true)
    end

    it 'does create config file from template' do
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

    it 'does setup dvwa database' do
      expect(subject).to create_dvwa_db('dvwadb')
        .with(pgsql: false,
              server: '127.0.0.1',
              port: 1337,
              username: 'dvwauser',
              password: 'dvwapass')
    end

    it 'does include module_mysql recipe of php cookbook' do
      expect(subject).to include_recipe('php::module_mysql')
    end

    it 'does setup mysql service' do
      expect(subject).to create_mysql_service('default')
        .with(port: '3306',
              version: '5.5',
              initial_root_password: 'toor')
    end

    it 'does create database user' do
      expect(subject).to grant_mysql_database_user('dvwauser')
        .with(password: 'dvwapass',
              database_name: 'dvwadb',
              privileges: [:select, :update, :insert, :create, :delete, :drop],
              connection: { host: '127.0.0.1',
                            username: 'root',
                            password: 'toor' })
    end

    it 'does create mysql database' do
      expect(subject).to create_mysql_database('dvwadb')
        .with(connection: { host: '127.0.0.1',
                            username: 'root',
                            password: 'toor' })
    end

    it 'does copy cookbook file that contains sql queries' do
      expect(subject).to create_cookbook_file('/opt/dvwa-app/sql/dvwa-my.sql')
        .with(source: 'dvwa-my.sql')
    end

    it 'does init dvwa database with sql queries' do
      expect(subject).to query_database(
        'Setup database (Chef::Provider::Database::Mysql)')
        .with(database_name: 'dvwadb',
              provider: Chef::Provider::Database::Mysql,
              connection: { host: '127.0.0.1',
                            username: 'root',
                            password: 'toor' })
    end
  end
end
