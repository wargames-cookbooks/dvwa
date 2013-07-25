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

require 'chef/resource'

class Chef
  class Resource
    class DvwaHttpPost < Chef::Resource

      def initialize(host, run_context=nil)
        super
        @resource_name = :dvwa_http_post
        @provider = Chef::Provider::DvwaHttpPost
        @action = :post
        @allowed_actions = [:post]

        @host = host
        @uri = '/'
        @headers = {}
        @data = ''
      end

      def host(arg=nil)
        set_or_return(:host, arg, :kind_of => String)
      end

      def uri(arg=nil)
        set_or_return(:uri, arg, :kind_of => String)
      end

      def headers(arg=nil)
        set_or_return(:headers, arg, :kind_of => Hash)
      end

      def data(arg=nil)
        set_or_return(:data, arg, :kind_of => String)
      end
    end
  end
end
