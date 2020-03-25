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
license 'Apache-2.0'
description 'Installs/Configures Damn Vulnerable Web Application'
chef_version '>= 12.5'
version '0.3.0'

depends 'apache2'
depends 'php'
depends 'mariadb'

supports 'ubuntu', '>= 16.04'
supports 'debian', '>= 9.0'

source_url 'https://github.com/wargames-cookbooks/dvwa'
issues_url 'https://github.com/wargames-cookbooks/dvwa/issues'
