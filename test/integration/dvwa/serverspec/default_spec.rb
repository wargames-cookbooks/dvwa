require "spec_helper"

describe "dvwa::default" do
  it 'dvwa vhost' do
    file(node["apache"]["dir"] + "/sites-available/dvwa.conf").must_exist
  end

  it 'dvwa vhost enabled' do
    file(node["apache"]["dir"] + "/sites-enabled/dvwa.conf").must_exist
  end

  it 'docroot created' do
    directory(node["dvwa"]["path"]).must_exist
  end
end
