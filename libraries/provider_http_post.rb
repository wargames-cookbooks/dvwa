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

require 'chef/provider'
require 'net/http'

class Chef
  class Provider
    class DvwaHttpPost < Chef::Provider

      def load_current_resource
        @current_resource ||= Chef::Resource::DvwaHttpPost.new(new_resource.name)

        @current_resource.host(new_resource.host)
        @current_resource.uri(new_resource.uri)
        @current_resource.headers(new_resource.headers)
        @current_resource.data(new_resource.data)
        @current_resource
      end

      def action_post
        http = Net::HTTP.new(@new_resource.host)

        Chef::Log.debug("#{@new_resource} POST request HOST; #{@new_resource.host}")

        response = http.post(
          @new_resource.uri,
          @new_resource.data,
          @new_resource.headers
        )

        Chef::Log.info("#{@new_resource} POST to #{@new_resource.host}#{@new_resource.uri} successful")
        Chef::Log.debug("#{@new_resource} POST request response #{response.body}")
      end

    end
  end
end
