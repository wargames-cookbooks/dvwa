DVWA Cookbook
=============
Deploy a Damn Vulnerable Web Application environment.
[![Cookbook Version](https://img.shields.io/cookbook/v/dvwa.svg)](https://community.opscode.com/cookbooks/dvwa) [![Build Status](https://secure.travis-ci.org/wargames-cookbooks/dvwa.png)](http://travis-ci.org/wargames-cookbooks/dvwa)

Requirements
------------

#### Platform
- `Ubuntu 12.04`

#### Cookbooks
- `apache2` - https://supermarket.chef.io/cookbooks/apache2
- `php` - https://supermarket.chef.io/cookbooks/php
- `database` - https://supermarket.chef.io/cookbooks/database
- `mysql` - https://supermarket.chef.io/cookbooks/mysql
- `postgresql` - https://supermarket.chef.io/cookbooks/postgresql

Attributes
----------

#### dvwa::default
<table>
<tr>
<th>Key</th>
<th>Type</th>
<th>Description</th>
<th>Default</th>
</tr>
<tr>
<td><tt>['dvwa']['db']['use_pgsql']</tt></td>
<td>Boolean</td>
<td>Use Postgresql instead MySQL.</td>
<td><tt>false</tt></td>
</tr>
<tr>
<td><tt>['dvwa']['db']['server']</tt></td>
<td>String</td>
<td>Database server host</td>
<td><tt>localhost</tt></td>
</tr>
<tr>
<td><tt>['dvwa']['db']['port']</tt></td>
<td>Integer</td>
<td>Database port, only needed for postgresql dbms</td>
<td><tt>5432</tt></td>
</tr>
<tr>
<td><tt>['dvwa']['db']['name']</tt></td>
<td>String</td>
<td>Database name</td>
<td><tt>dvwa</tt></td>
</tr>
<tr>
<td><tt>['dvwa']['db']['username']</tt></td>
<td>String</td>
<td>Database user name</td>
<td><tt>dvwa</tt></td>
</tr>
<tr>
<td><tt>['dvwa']['db']['password']</tt></td>
<td>String</td>
<td>Database user password</td>
<td><tt>dvwa</tt></td>
</tr>
<tr>
<td><tt>['dvwa']['recaptcha']['public_key']</tt></td>
<td>String</td>
<td>Recaptcha public key</td>
<td><tt>6LfzKeUSAAAAABbGMjVS77HmkY7emIB9v5VGeEvb</tt></td>
</tr>
<tr>
<td><tt>['dvwa']['recaptcha']['private_key']</tt></td>
<td>String</td>
<td>Recaptcha private key</td>
<td><tt>6LfzKeUSAAAAAEPD91_3uUGaemNs9ZNehkccBOoF</tt></td>
</tr>
<tr>
<td><tt>['dvwa']['apache2']['server_name']</tt></td>
<td>String</td>
<td>Apache2 server name</td>
<td><tt>dvwa</tt></td>
</tr>
<tr>
<td><tt>['dvwa']['apache2']['server_aliases']</tt></td>
<td>Array</td>
<td>Array of apache2 virtualhost aliases</td>
<td><tt>[dvwa]</tt></td>
</tr>
<tr>
<td><tt>['dvwa']['version']</tt></td>
<td>String</td>
<td>DVWA version to deploy</td>
<td><tt>v1.0.8</tt></td>
</tr>
<tr>
<td><tt>['dvwa']['path']</tt></td>
<td>String</td>
<td>Path where application will be deployed</td>
<td><tt>/opt/dvwa</tt></td>
</tr>
<tr>
<td><tt>['dvwa']['security_level']</tt></td>
<td>String</td>
<td>DVWA default security level</td>
<td><tt>high</tt></td>
</tr>
</table>

Usage
-----
#### dvwa::default

Just include `dvwa` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[dvwa]"
  ]
}
```

#### Running tests

- First, install dependencies:  
`bundle install`

- Run Checkstyle and ChefSpec:  
`bundle exec rake`

- Run Kitchen tests:  
`bundle exec rake kitchen`  

Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add-component-x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Sliim <sliim@mailoo.org> 

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
