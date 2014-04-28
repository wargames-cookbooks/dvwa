require "spec_helper"

describe service('apache2') do
  it { should be_enabled }
  it { should be_running }
end

describe file("/etc/apache2/sites-available/dvwa.conf") do
  it { should be_file }
end

describe file("/etc/apache2/sites-enabled/dvwa.conf") do
  it { should be_file }
end

describe file("/opt/dvwa") do
  it { should be_directory }
end
