# -*- coding: utf-8 -*-

require 'serverspec'

include SpecInfra::Helper::Exec
include SpecInfra::Helper::DetectOS

describe service('apache2') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/apache2/sites-available/dvwa.conf') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 644 }
end

describe file('/etc/apache2/sites-enabled/dvwa.conf') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_linked_to '/etc/apache2/sites-available/dvwa.conf' }
end

describe file('/opt/dvwa') do
  it { should be_directory }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 755 }
end

# TODO: /opt/dvwa/sql does not exists
