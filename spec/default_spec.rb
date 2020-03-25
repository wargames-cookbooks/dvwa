require 'spec_helper'

describe 'dvwa::default' do
  let(:subject) do
    ChefSpec::SoloRunner.new(file_cache_path: '/var/chef/cache',
                             step_into: %w(dvwa_db)) do |node|
      node.override['dvwa']['version'] = '2'
      node.override['dvwa']['path'] = '/opt/dvwa-app'
      node.override['dvwa']['security_level'] = 'low'
      node.override['dvwa']['recaptcha']['public_key'] = 'recap_pubkey'
      node.override['dvwa']['recaptcha']['private_key'] = 'recap_private_key'
      node.override['dvwa']['apache2']['server_name'] = 'dvwa-site'
      node.override['dvwa']['apache2']['server_aliases'] = %w(dvwa dvwa-website)
      node.override['dvwa']['db']['server'] = '127.0.0.1'
      node.override['dvwa']['db']['name'] = 'dvwadb'
      node.override['dvwa']['db']['username'] = 'dvwauser'
      node.override['dvwa']['db']['password'] = 'dvwapass'
    end.converge(described_recipe)
  end

  it 'should install apache2' do
    expect(subject).to install_apache2_install('dvwa')
  end

  it 'should start apache2 service' do
    expect(subject).to start_service('apache2')
  end

  it 'should enable apache2 service' do
    expect(subject).to enable_service('apache2')
  end

  it 'should install libapache2-mod-php package' do
    expect(subject).to install_package('libapache2-mod-php')
  end

  it 'should include php cookbook' do
    expect(subject).to include_recipe('php')
  end

  it 'should install php-gd package' do
    expect(subject).to install_package('php-gd')
  end

  it 'should enable apache2 php module' do
    expect(subject).to enable_apache2_module('php7')
  end

  it 'should create apache2 site for dvwa' do
    expect(subject).to create_template('dvwa-site')
      .with(path: '/etc/apache2/sites-available/dvwa.conf',
            source: 'site.conf.erb',
            variables: {
              server_name: 'dvwa-site',
              server_aliases: %w(dvwa dvwa-website),
              document_root: '/opt/dvwa-app',
              log_dir: '/var/log/apache2',
              site_name: 'dvwa',
            })
  end

  it 'should enable dvwa site' do
    expect(subject).to enable_apache2_site('dvwa')
  end

  it 'should disable default site' do
    expect(subject).to disable_apache2_site('000-default')
  end

  it 'should download dvwa archive' do
    expect(subject).to create_remote_file('/var/chef/cache/dvwa.tar.gz')
      .with(source: 'https://github.com/ethicalhack3r/DVWA/archive/2.tar.gz')
  end

  it 'should create directory for dvwa application' do
    expect(subject).to create_directory('/opt/dvwa-app')
      .with(recursive: true,
            owner: 'www-data',
            group: 'www-data')
  end

  it 'should untar dvwa archive in created directory' do
    expect(subject).to run_execute('untar-dvwa')
      .with(cwd: '/opt/dvwa-app',
            user: 'www-data',
            group: 'www-data',
            command: 'tar --strip-components 1 -xzf '\
                     '/var/chef/cache/dvwa.tar.gz')
  end

  it 'should create config file from template' do
    config_file = '/opt/dvwa-app/config/config.inc.php'
    matches = [/^\$DBMS = 'MySQL';$/,
               /^\$_DVWA\['db_server'\] = '127.0.0.1';$/,
               /^\$_DVWA\['db_port'\] = '3306';$/,
               /^\$_DVWA\['db_database'\] = 'dvwadb';$/,
               /^\$_DVWA\['db_user'\] = 'dvwauser';$/,
               /^\$_DVWA\['db_password'\] = 'dvwapass';$/,
               /^\$_DVWA\['recaptcha_public_key'\] = "recap_pubkey";$/,
               /^\$_DVWA\['recaptcha_private_key'\] = "recap_private_key";$/,
               /^\$_DVWA\['default_security_level'\] = "low";$/]

    expect(subject).to create_template(config_file)
      .with(source: 'config.inc.php.erb',
            owner: 'www-data',
            group: 'www-data')

    matches.each do |m|
      expect(subject).to render_file(config_file).with_content(m)
    end
  end

  it 'should create missing tmp directory for phpids plugin' do
    expect(subject).to create_directory('/opt/dvwa-app/external/phpids/0.6/lib/IDS/tmp')
      .with(owner: 'www-data',
            group: 'www-data',
            recursive: true)
  end

  it 'should create sql directory' do
    expect(subject).to create_directory('create-sql-dir')
      .with(mode: '0700',
            path: '/opt/dvwa-app/sql')
  end

  it 'should copy cookbook file that contains sql queries' do
    expect(subject).to create_cookbook_file('/opt/dvwa-app/sql/dvwa-my.sql')
      .with(source: 'dvwa-my.sql')
  end

  it 'should setup dvwa database' do
    expect(subject).to create_dvwa_db('dvwadb')
      .with(server: '127.0.0.1',
            username: 'dvwauser',
            password: 'dvwapass',
            dvwa_path: '/opt/dvwa-app')
  end

  it 'should install package php-mysql' do
    expect(subject).to install_package('php-mysql')
  end

  it 'should install mariadb server' do
    expect(subject).to install_mariadb_server_install('MariaDB Server')
      .with(setup_repo: true,
            version: '10.3',
            password: 'toor')
  end

  it 'should modify mariadb server configuration' do
    expect(subject).to modify_mariadb_server_configuration('MariaDB Server Configuration')
      .with(mysqld_port: 3306,
            mysqld_bind_address: '127.0.0.1',
            version: '10.3')
  end

  it 'should drop mysql database' do
    expect(subject).to drop_mariadb_database('drop-dvwa-db')
      .with(database_name: 'dvwadb')
  end

  it 'should create mysql database' do
    expect(subject).to create_mariadb_database('dvwadb')
      .with(host: '127.0.0.1')
  end

  it 'should create database user' do
    expect(subject).to create_mariadb_user('dvwauser')
      .with(password: 'dvwapass',
            database_name: 'dvwadb',
            privileges: [:all],
            host: '%')
  end

  it 'should grant database user' do
    expect(subject).to grant_mariadb_user('dvwauser')
      .with(password: 'dvwapass',
            database_name: 'dvwadb',
            privileges: [:all],
            host: '%')
  end

  it 'should populate dvwa database with mysql dump' do
    expect(subject).to run_execute('import-mysql-dump')
      .with(command: 'mysql -h 127.0.0.1 -u dvwauser -pdvwapass '\
                     '--socket /run/mysql-default/mysqld.sock '\
                     'dvwadb < /opt/dvwa-app/sql/dvwa-my.sql')
  end
end
