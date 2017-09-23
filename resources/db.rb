# -*- coding: utf-8 -*-
#
# Cookbook Name:: dvwa
# Resource:: db
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

actions :create
default_action :create
resource_name :dvwa_db

attribute :name, kind_of: String
attribute :pgsql, kind_of: [TrueClass, FalseClass], default: false
attribute :server, kind_of: String
attribute :port, kind_of: Integer
attribute :username, kind_of: String
attribute :password, kind_of: String
attribute :dvwa_path, kind_of: String
