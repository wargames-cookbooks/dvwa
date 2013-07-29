# This source file is part of DVWA's chef cookbook.
#
# DVWA's chef cookbook is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# DVWA's chef cookbook is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with DVWA's chef cookbook. If not, see <http://www.gnu.org/licenses/gpl-3.0.html>.
#
# Cookbook Name:: dvwa_test
# Recipe:: default
#

require File.expand_path('../support/helpers', __FILE__)

describe "dvwa_test::default" do
  include Helpers::DvwaTest

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
