# -*- coding: utf-8 -*-
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

name 'dvwa'
maintainer 'Sliim'
maintainer_email 'sliim@mailoo.org'
license 'Apache 2.0'
description 'Installs/Configures Damn Vulnerable Web Application'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.3'

recipe 'default', 'Installs/configures dvwa webapp'
recipe 'mysql', 'MySQL database configuration'
recipe 'postgresql', 'PostgreSQL database configuration'
recipe 'setub_db', 'Common database settings'

depends 'apache2'
depends 'mysql'
depends 'postgresql'
depends 'php'
depends 'database'

supports 'ubuntu'
supports 'centos'
