# -*- coding: utf-8 -*-
#
# Cookbook:: dvwa
# Attributes:: default
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

default['dvwa']['version'] = 'master'
default['dvwa']['path'] = '/opt/dvwa'
default['dvwa']['security_level'] = 'high'

default['dvwa']['recaptcha']['public_key'] = '6LfzKeUSAAAAABbGMjVS77HmkY7emIB9v5VGeEvb'
default['dvwa']['recaptcha']['private_key'] = '6LfzKeUSAAAAAEPD91_3uUGaemNs9ZNehkccBOoF'

default['dvwa']['apache2']['server_name'] = 'dvwa'
default['dvwa']['apache2']['server_aliases'] = ['dvwa']

default['dvwa']['db']['server'] = 'localhost'
default['dvwa']['db']['name'] = 'dvwa'
default['dvwa']['db']['username'] = 'dvwa'
default['dvwa']['db']['password'] = 'dvwa'
