# -*- coding: utf-8 -*-
#
# Cookbook:: dvwa
# Recipe:: default
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

# PHP directives
node.default['php']['directives']['allow_url_fopen'] = 'On'
node.default['php']['directives']['allow_url_include'] = 'On'
node.default['php']['directives']['display_errors'] = node['dvwa']['security_level'] == 'low' ? 'On' : 'Off'

# PHP apache2 conf_dir
node.override['php']['conf_dir'] = node['php']['conf_dir'].gsub(%r{/cli}, '/apache2')

# Fix php attributes for Debian 10
if platform?('debian') && node['platform_version'].to_i >= 10
  node.override['php']['packages'] = %w(php7.3-cgi php7.3 php7.3-dev php7.3-cli php-pear)
  node.override['php']['conf_dir'] = '/etc/php/7.3/apache2'
end

# Apache2 configuration
apache2_install 'dvwa'

service 'apache2' do
  extend Apache2::Cookbook::Helpers
  service_name lazy { apache_platform_service_name }
  supports restart: true, status: true, reload: true
  action [:start, :enable]
end

package value_for_platform(
          default: 'libapache2-mod-php',
          ubuntu: {
            default: 'libapache2-mod-php',
            '<= 14.04' => 'libapache2-mod-php5',
          })

include_recipe 'php'
package 'php-gd'

mod, modname, identifier = value_for_platform(
       default: ['php7', nil, nil],
       ubuntu: {
         default: %w(php7.0 libphp7.0.so php7_module),
         '>= 18.04' => %w(php7.2 libphp7.2.so php7_module),
         '<= 14.04' => %w(php5 libphp5.so php5_module),
       })

apache2_module mod do
  mod_name modname unless modname.nil?
  identifier identifier unless identifier.nil?
end

template 'dvwa-site' do
  extend Apache2::Cookbook::Helpers
  source 'site.conf.erb'
  path "#{apache_dir}/sites-available/dvwa.conf"
  variables(
    server_name: node['dvwa']['apache2']['server_name'],
    server_aliases: node['dvwa']['apache2']['server_aliases'],
    document_root: node['dvwa']['path'],
    log_dir: default_log_dir,
    site_name: 'dvwa'
  )
end

apache2_site 'dvwa'

apache2_site '000-default' do
  action :disable
end

# DVWA install
remote_file "#{Chef::Config[:file_cache_path]}/dvwa.tar.gz" do
  source "#{node['dvwa']['archive_url']}#{node['dvwa']['version']}.tar.gz"
end

directory node['dvwa']['path'] do
  extend Apache2::Cookbook::Helpers
  recursive true
  owner default_apache_user
  group default_apache_group
end

execute 'untar-dvwa' do
  extend Apache2::Cookbook::Helpers
  cwd node['dvwa']['path']
  command "tar --strip-components 1 -xzf #{Chef::Config[:file_cache_path]}/dvwa.tar.gz"
  user default_apache_user
  group default_apache_group
end

template "#{node['dvwa']['path']}/config/config.inc.php" do
  extend Apache2::Cookbook::Helpers
  source 'config.inc.php.erb'
  owner default_apache_user
  group default_apache_group
  variables db: node['dvwa']['db'],
            recaptcha: node['dvwa']['recaptcha'],
            security_level: node['dvwa']['security_level']
end

directory "#{node['dvwa']['path']}/external/phpids/0.6/lib/IDS/tmp" do
  extend Apache2::Cookbook::Helpers
  owner default_apache_user
  group default_apache_group
  recursive true
end

dvwa_db node['dvwa']['db']['name'] do
  server node['dvwa']['db']['server']
  username node['dvwa']['db']['username']
  password node['dvwa']['db']['password']
  dvwa_path node['dvwa']['path']
end
